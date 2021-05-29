Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CFC394D2D
	for <lists+kvm@lfdr.de>; Sat, 29 May 2021 18:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhE2Quk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 12:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhE2Quj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 May 2021 12:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CDF966105A;
        Sat, 29 May 2021 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622306941;
        bh=eKGCjGlrM/fX7Vcnu/Wba51hAY7iOG6CV1ahDTOBbdk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=L0i6Tw/u2yCssULeUDRr4Ml2N94WFZTKWo19jWVMCThqd3jbOvDoJGB02iOombyMi
         il+0bijX5a3o7YqMBcVh9YBcP5ulxyR65vx1yQ2In3UG/QH/LO0sDyrLRFroYnF+yX
         uzrhchuI44ubyGluE2uoAIntKv6VG9wjbJoUOeHlsm5PjAcUe1QXHZ1a7VsSMYAIro
         sEKrcLHoy4zC+sV9jul7kBlR03YYdASCnWl0vgUInUR1ruWnrk4pADCfLEYEBYWV29
         PbaLBxlq2XihEHVH8yNzc9zro0moW39AJK2FN3M+ELDYTh4zZFFp0pj2cebLsedJMD
         NHlNOwUCcBgwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB02460A39;
        Sat, 29 May 2021 16:49:01 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes and new selftests for Linux 5.14-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210529103206.3853545-1-pbonzini@redhat.com>
References: <20210529103206.3853545-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210529103206.3853545-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 000ac42953395a4f0a63d5db640c5e4c88a548c5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 224478289ca0e7abf06a3bc63b06c42a2bf84c69
Message-Id: <162230694170.3322.8197885978080864045.pr-tracker-bot@kernel.org>
Date:   Sat, 29 May 2021 16:49:01 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 29 May 2021 06:32:06 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/224478289ca0e7abf06a3bc63b06c42a2bf84c69

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
