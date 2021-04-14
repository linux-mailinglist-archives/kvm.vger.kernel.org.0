Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6993F35F8D1
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 18:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351635AbhDNQPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 12:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351582AbhDNQPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 12:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F3A961168;
        Wed, 14 Apr 2021 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618416904;
        bh=5l4UNr1/zdHkE2Xm4JPmV7N7rukf9kN/f+0pBe/IyhA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=WLWmTmEE4KIoJlC3pNBKot4O4lpMNuEWP055PECttTDTGDUI8qM1/0+Wm+ZT8rzxZ
         spzrCBCIJKwjiXiWR0GCpyLfeTSzaXbgVsQigfVX7crMeHOyMgA6zwRmS8zPeNKxqm
         DWvQDuWAetfda5SBCuVj+e8fE5RsVixurk4fs1zV1/b32Phjs9vSPez6Z4AitiBm5s
         rRiUMIgxdiGbVdfSH3Ai8WSQoWTCD9i+GFJUhX2z0HkJK4ZmPCTZdv70Encx7CrRI9
         igcDExwHTGhNngOJv48QuUPKFHZ+kpZbihPuulMYgpkw+smAC7WuTF8sIiAuY8HMf1
         ub1B1d+RXc9kg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35E6260CCF;
        Wed, 14 Apr 2021 16:15:04 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v5.12-rc8/final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210414090325.3580db75@omen>
References: <20210414090325.3580db75@omen>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210414090325.3580db75@omen>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc8
X-PR-Tracked-Commit-Id: 909290786ea335366e21d7f1ed5812b90f2f0a92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e70b911acc1687100c31e550251715dbdac96a12
Message-Id: <161841690421.3200.16413509673206057841.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Apr 2021 16:15:04 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, lk@c--e.de
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 14 Apr 2021 09:03:25 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e70b911acc1687100c31e550251715dbdac96a12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
