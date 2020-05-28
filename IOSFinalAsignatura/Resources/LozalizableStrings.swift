
import Foundation

let somethingWrong = "something_wrong"
let addImage = "add_image"
let addUsername = "add_username"
let errorMessageImage = "error_message_image"

let mapAdvise = "map_advise_title"
let mapAdviseMessage = "map_advise_message"

let withoutMembersTitle = "without_members_title"
let withoutMembersMessage = "without_members_message"

let refreshAction = "refresh_action"

let signOutAction = "sign_out"
let signOutCheck = "sign_out_check"
let cancelAction = "cancel_action"



extension String {
    func toLocalized() -> String {
        return NSLocalizedString(self,
                                 comment:"")
    }
}
