Config = {
    log = true,
    delayBetweenActions = 1000, -- 1 seconde
    allowedLicense = {
        ["license:8fc3f9bf5017c451d19593ae7d1105989d6635e0"] = true -- Pablo
    },

    messages = {
        harvest = {
            enable = true,
            message = "~y~+1 ~b~%s ~y~!"
        },

        transform = {
            onNoEnough = "~s~Vous n'avez pas assez de ~b~%s ~s~pour faire la transformation ! Requis: ~y~x%i %s",
            onDone = "~s~Vous avez transformé ~y~x%i %s ~s~en ~b~x%i %s"
        },

        sell = {
            onNoEnough = "~s~Vous n'avez pas assez de ~b~%s ~s~pour faire vendre ! Requis: ~y~x%i %s",
            onDone = "~s~Vous avez vendu ~y~x%i %s ~s~pour ~g~%i$"
        }
    }
}