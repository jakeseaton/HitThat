//
//  File.swift
//  HitThat
//
//  Created by Jake Seaton on 4/11/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import Foundation

// KILL ME

struct FormValidator {
    func validateEditForm(form:EditProfileForm) -> [String:AnyObject]?{
        if let alias = form.alias{
            if let userHeight = form.height{
                if let bodyType = form.bodyType{
                    if let userWeight = form.weight{
                        if let bestMove = form.bestMove{
                            if let hitsWith = form.hitsWith{
                                if let reach = form.reach{
                                    if let bio = form.bio{
                                        if let gpa = form.gpa{
                                            if let lookingFor = form.lookingFor{
                                                // this is where you can modify the data. It is all getting through to here though.
                                            let data:[String:AnyObject] = [
                                                "lookingFor":lookingFor,
                                                "reach" :reach,
                                                "bio" : bio,
                                                "jailTime" : form.jailTime,
                                                "tatoos" : form.tatoos,
                                                "gpa" : gpa,
                                                "hitsWith":hitsWith,
                                                "alias": alias,
                                                "height":userHeight,
                                                "weight":userWeight,
                                                "bestMove": bestMove,
                                                "bodyType":bodyType
                                            ]
                                            return data
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
        return nil
    }
 func validateRegisterForm(form:RegisterForm) -> [String:AnyObject]?{
    if let alias = form.alias{
        if let userHeight = form.height{
            if let bodyType = form.bodyType{
                if let userWeight = form.weight{
                    if let bestMove = form.bestMove{
                        if let hitsWith = form.hitsWith{
                            if let reach = form.reach{
                                if let bio = form.bio{
                                    if let gpa = form.gpa{
                                        if let lookingFor = form.lookingFor{
                                            let doubleGPA = (gpa as NSString).doubleValue
                                            let intWeight = userWeight.toInt()
                                            let data:[String:AnyObject] = [
                                                "lookingFor":lookingFor,
                                                "reach" :reach,
                                                "bio" : bio,
                                                "jailTime" : form.jailTime,
                                                "tatoos" : form.tatoos,
                                                "gpa" : doubleGPA,
                                                "hitsWith":hitsWith,
                                                "alias": alias,
                                                "height":userHeight,
                                                "weight":intWeight!,
                                                "bestMove": bestMove,
                                                "bodyType":bodyType
                                            ]
                                            return data
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return nil
    }
}
