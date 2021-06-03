Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6670639AAB1
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 21:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFCTL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 15:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFCTL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 15:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 917CB613E3;
        Thu,  3 Jun 2021 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622747383;
        bh=MSLGRUy0MFeclD+Y+OnG6WS2CmJ2jmNADhWwcdX5c4I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oaf1+ysMw4PLhQZNOlWI7NjasEz6B9cfawzNs2biuaAWTJRRTnE0t63OJ8FvzJtxT
         ukC+FIdvzijnd8vQfyuw5EtZPjNJVaaJ9q7iXhQie57ha/E3HCApQWHYaV6JgczHmh
         U9NXjjh2PtqIpyAbO6PxBG3iDfhPp4vmpIJgEfH2O/2kp8uEANCBVCcxgcP8B9j3mM
         SgjYBshn2NcmAqVXiSCnWX3lYtkH/ChK1a3kRN4e0J5UcoDKXLQoLXcyktgIm7LsGw
         FNMITmkKbf4sAtTcF3JhtjjAhxXhXXWIDhLKJEGwcpoisXs8y97la/gUYK5eYuXKDG
         0Pyi3+GfsCx1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BAC860A5C;
        Thu,  3 Jun 2021 19:09:43 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v5.13-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210603112237.42b620c1.alex.williamson@redhat.com>
References: <20210603112237.42b620c1.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210603112237.42b620c1.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc5
X-PR-Tracked-Commit-Id: dc51ff91cf2d1e9a2d941da483602f71d4a51472
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f88cd3fb9df228e5ce4e13ec3dbad671ddb2146e
Message-Id: <162274738356.14300.3597193776411565556.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Jun 2021 19:09:43 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 3 Jun 2021 11:22:37 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f88cd3fb9df228e5ce4e13ec3dbad671ddb2146e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
