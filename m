Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1D5340E8C
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 20:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhCRTmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 15:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhCRTmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 15:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7844064F10;
        Thu, 18 Mar 2021 19:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616096530;
        bh=rfE540+stiOEEkbtMDa8mkgz+NqN7luxlqo01NOgfvo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=eefZoqxFbHxjQksUot+eDknNzvqv6ZiZMWrA9G+t0xvgw5r/ZNhGwJa2jDAY4+At0
         Y27mvw9Sz7FzdDQe57Bpdre4UdEQMsfThb10mYfa1PXr/p8ImyjII08MJi+P644HEK
         2RxMwsY24c1uZVM/b7ub2mrXNjZig2yWdG+PZIZ7kNtn4oIYAVNg6hCZVJO6HJ9dU6
         RkFUmB2u1zGukd9NNHughQB7LRdehhO8NfPMCLHNrv+6HT3VVl53YTri4vCIY7gPX7
         x95sz2CFbhwdxkF25FoPhCp0QonC5ORW7zHpvfLZI8PzpWuLi1R2p2mAoMZbu7KXPD
         4JS33sGno6ISg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68336600E8;
        Thu, 18 Mar 2021 19:42:10 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v5.12-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210318131539.1c66212d@omen.home.shazbot.org>
References: <20210318131539.1c66212d@omen.home.shazbot.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210318131539.1c66212d@omen.home.shazbot.org>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc4
X-PR-Tracked-Commit-Id: 4ab4fcfce5b540227d80eb32f1db45ab615f7c92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dc0337999d87a5e749ef1ac0bcc1a06d2a3f9ec0
Message-Id: <161609653037.4441.17677565695334561459.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Mar 2021 19:42:10 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        steven.sistare@oracle.com, jgg@nvidia.com,
        daniel.m.jordan@oracle.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 18 Mar 2021 13:15:39 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dc0337999d87a5e749ef1ac0bcc1a06d2a3f9ec0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
