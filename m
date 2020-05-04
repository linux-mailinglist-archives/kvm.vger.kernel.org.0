Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D41C461B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEDSia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgEDSi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 14:38:29 -0400
Subject: Re: [GIT PULL] vhost: fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588617305;
        bh=y7Pu1FubvJ8XEaBkpZaNRpWFQQvvFrFooiqYxgdFwlI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=o0+z+lEgyX0XO0M7qlk60y8gvXxm+B6YVhwMNbOooUgwauzhVMCt/iHrM/8Us84/I
         NQq+6lH48j3BGusVJfeNnvuYfBB5Hh356hYbLBSr3dG7hdxtouET22MjN64Tcun/cw
         79y9gGmTovRi2prymYxytR1uEJmUKeN4JuEGaWJ4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200504081540-mutt-send-email-mst@kernel.org>
References: <20200504081540-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200504081540-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 0b841030625cde5f784dd62aec72d6a766faae70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a16a47e98a30ae6a424d30ce9f4f99e4d9384713
Message-Id: <158861730512.3296.10840791650276451054.pr-tracker-bot@kernel.org>
Date:   Mon, 04 May 2020 18:35:05 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin.he@arm.com, ldigby@redhat.com, mst@redhat.com, n.b@live.com,
        stefanha@redhat.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 4 May 2020 08:15:40 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a16a47e98a30ae6a424d30ce9f4f99e4d9384713

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
