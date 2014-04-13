"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema
crypto = require("crypto")
authTypes = [
  "github"
  "twitter"
  "facebook"
  "google"
]

###
User Schema
###
UserSchema = new Schema(
  name: String
  email: String
  role:
    type: String
    default: "user"

  hashedPassword: String
  provider: String
  salt: String
  facebook: {}
  twitter: {}
  github: {}
  google: {}
)

###
Virtuals
###
UserSchema.virtual("password").set((password) ->
  @_password = password
  @salt = @makeSalt()
  @hashedPassword = @encryptPassword(password)
  return
).get ->
  @_password


# Basic info to identify the current authenticated user in the app
UserSchema.virtual("userInfo").get ->
  name: @name
  role: @role
  provider: @provider


# Public profile information
UserSchema.virtual("profile").get ->
  name: @name
  role: @role


###
Validations
###

# Validate empty email
UserSchema.path("email").validate ((email) ->
  # if you are authenticating by any of the oauth strategies, don't validate
  return true  if authTypes.indexOf(@provider) isnt -1
  email.length
), "Email cannot be blank"

# Validate empty password
UserSchema.path("hashedPassword").validate ((hashedPassword) ->
  # if you are authenticating by any of the oauth strategies, don't validate
  return true  if authTypes.indexOf(@provider) isnt -1
  hashedPassword.length
), "Password cannot be blank"

# Validate email is not taken
UserSchema.path("email").validate ((value, respond) ->
  self = this
  @constructor.findOne
    email: value
  , (err, user) ->
    throw err  if err
    if user
      return respond(true)  if self.id is user.id
      return respond(false)
    respond true
    return

  return
), "The specified email address is already in use."
validatePresenceOf = (value) ->
  value and value.length


###
Pre-save hook
###
UserSchema.pre "save", (next) ->
  return next()  unless @isNew
  if not validatePresenceOf(@hashedPassword) and authTypes.indexOf(@provider) is -1
    next new Error("Invalid password")
  else
    next()
  return


###
Methods
###
UserSchema.methods =
  ###
  Authenticate - check if the passwords are the same

  @param {String} plainText
  @return {Boolean}
  @api public
  ###
  authenticate: (plainText) ->
    @encryptPassword(plainText) is @hashedPassword


  ###
  Make salt

  @return {String}
  @api public
  ###
  makeSalt: ->
    crypto.randomBytes(16).toString "base64"


  ###
  Encrypt password

  @param {String} password
  @return {String}
  @api public
  ###
  encryptPassword: (password) ->
    return ""  if not password or not @salt
    salt = new Buffer(@salt, "base64")
    crypto.pbkdf2Sync(password, salt, 10000, 64).toString "base64"

module.exports = mongoose.model("User", UserSchema)