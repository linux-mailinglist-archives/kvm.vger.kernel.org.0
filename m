Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3435320E20
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 23:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhBUWDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 17:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhBUWDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 17:03:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E7BEC64EDB;
        Sun, 21 Feb 2021 22:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613944915;
        bh=wS727jVtYsL2dmpDZqTrhJFV4YFFRTw4Zm+tqy/eqdQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pNZTrNfyV33CXxS1ghZ6mJroirjl1c6230Z7hcApOZZEtATJXlrldGV2i2Zqf8m5m
         hk9kd07/INFYLEa4gq7dyd/n/JRZ5BwsUHuITK/CHY+d+I0QM0F8t16SuFzLVfG2A5
         Qiq/K3kZ+8/ZcXYUuB7kovpR1wv3kqErLcNz19uSm+aRxEUFdcxyZUZ8rdbtJoH/xX
         sIfQdzqVfHJbIvM4l/Klvu4gFyNi4FNKexP49hC8Bj2hBinIIEHLIwssTNdKPg+lKN
         HN2UXRMNeX0WrlXeyeYrJk76pnGp6QqjmTjXNYQHTvgFbCRVRCneTJi+3id22GzfQx
         NkbQvqsAHiaCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E1AF860192;
        Sun, 21 Feb 2021 22:01:55 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.12
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210214172845.1047934-1-pbonzini@redhat.com>
References: <20210214172845.1047934-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210214172845.1047934-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8c6e67bec3192f16fa624203c8131e10cc4814ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e10585335b7967326ca7b4118cada0d2d00a2ab
Message-Id: <161394491591.8676.9147322641970268083.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Feb 2021 22:01:55 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 14 Feb 2021 12:28:45 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e10585335b7967326ca7b4118cada0d2d00a2ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
