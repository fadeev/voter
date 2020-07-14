package voter

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/fadeev/voter/x/voter/types"
)

func handleMsgCreatePoll(ctx sdk.Context, k Keeper, msg MsgCreatePoll) (*sdk.Result, error) {
	var poll = types.Poll{
		Creator: msg.Creator,
		ID:      msg.ID,
    Title: msg.Title,
    Options: msg.Options,
	}
	k.CreatePoll(ctx, poll)

	return &sdk.Result{Events: ctx.EventManager().Events()}, nil
}
