Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C9D456477
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 21:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhKRUwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 15:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233322AbhKRUwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 15:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 419AA61251;
        Thu, 18 Nov 2021 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637268543;
        bh=+L2HuS/cQhuFzKhQgm3kXd3ugHM0Hs/Mj23uvHqafkM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Vn2phmrMLK3E3DyOeGlSgoJUaBgpVDepIXKpDFO0DrGMRdJ2gvUDiosvlBmIg69YL
         CCbpNxMN3OPH1genExtrRubNW5CbKCfw1VpR09rkcl7CQ6oPCgLSx31Hnxj19hhBn1
         x2B2hXId5iQAuHnziHls98LSRAER5mPtkCaZl+syNoJ+nwvP33wL8LTFFBYrySEW50
         XUu4SUKza5uTmZp4j3/ubAjuQqucj3mvdkSEoxTIxLJuYk56a382V1HtRQkmf/yw05
         3bFTEYHWfEnLu5T7o/NkH5eu/HvPkIpI72/A+0mIfa11Me5X+15SxmuR2eQL9yKDzk
         AQzzx8DrqV+Fg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C5F060A4E;
        Thu, 18 Nov 2021 20:49:03 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.16-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211118130449.71796-1-pbonzini@redhat.com>
References: <20211118130449.71796-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211118130449.71796-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2845e7353bc334d43309f5ea6d376c8fdbc94c93
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c46e8ece9613b18d9554e2382a228b6e1795288d
Message-Id: <163726854323.10311.9663447744996816989.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Nov 2021 20:49:03 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 18 Nov 2021 08:04:49 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c46e8ece9613b18d9554e2382a228b6e1795288d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
