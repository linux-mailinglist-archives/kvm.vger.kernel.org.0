Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D144324404
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 19:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhBXSsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 13:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbhBXSrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 13:47:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F0A2A64F16;
        Wed, 24 Feb 2021 18:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614192396;
        bh=WBuaXYkFZ8OIu5PLRx1YOCxy+PCbpldjj/MeA5K46O4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Yxvzzs6FUxdxY+UQTYT+s5jIV1k2rMAzKGZhsOCRqnLS0zhqx46XgC88BdlBFv7bn
         C9ZGvcs8KzAjYH1Nwle+H0I4gmVQdGREJRFw7HVMM5PwraIu6GYGTlDDHVdT2YZBpA
         thJQycMP1shVgKx5PfE9cjet46X5UZ/jSOeOV9WQEHwg42Et4KNBt9Tf1HZHN6xYJJ
         56PHlfqplW6RbeBA4DfPuBMPanDVPfzeJ3X9TKUtZUm7KCH9Rqo7IgfB0K3NZJ/Bp5
         dtogAConKAjerV65P7uAhQlqhfDBO4cxGcUzaaR11X+O//TajXbuUBeJy0r/4ddG3w
         2/lVlIwXFSljQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECEA460176;
        Wed, 24 Feb 2021 18:46:35 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.12-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210224105013.03713eb6@omen.home.shazbot.org>
References: <20210224105013.03713eb6@omen.home.shazbot.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210224105013.03713eb6@omen.home.shazbot.org>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc1
X-PR-Tracked-Commit-Id: 4d83de6da265cd84e74c19d876055fa5f261cde4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 719bbd4a509f403f537adcaefd8ce17532be2e84
Message-Id: <161419239596.20610.14280521723779659136.pr-tracker-bot@kernel.org>
Date:   Wed, 24 Feb 2021 18:46:35 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 24 Feb 2021 10:50:13 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/719bbd4a509f403f537adcaefd8ce17532be2e84

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
