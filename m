Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0C837082D
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 19:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhEARVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 13:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231556AbhEARVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 May 2021 13:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6798D61284;
        Sat,  1 May 2021 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619889659;
        bh=M8fSXRspM+gfwTBc56Q72oXMJRbZEUo4slnyxyJ7Xpc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mxRORHQswXRYGlLL0JIVVzBat6a9A9SBSYg4XQTDKgxF8PfJG59GLNlFTuykrC6Gq
         SZfmrZ9t7THK6Mk1YjsekxP/zgg1M6I4MlmjSFluDOtfLQ0tSkBN7ugbIj1Bfqk3oX
         hTZNadG2vaTRLVwhPgQQTjp1GZnnE/MWpidu+XQDjVPy9Ru9EnuUlgtfJ7pPp8ERXS
         h+DhHBVk0vTSPGGPmS0yTomwEovkBgVG+QVgkcQ0W6t82sGQHnGamKB7j8jp82YlWn
         sI8OH3/VkDpLzT76CrgLCUXWtVg/+/qFPSGHxUtzvbM3D/Nckbz4TQ+LeIN61rfx+w
         pSmzrcA+HGMiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6163A60978;
        Sat,  1 May 2021 17:20:59 +0000 (UTC)
Subject: Re: [GIT PULL] KVM, AMD PSP and ARM CoreSight changes for 5.13 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210428230528.189146-1-pbonzini@redhat.com>
References: <20210428230528.189146-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210428230528.189146-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 3bf0fcd754345d7ea63e1446015ba65ece6788ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 152d32aa846835987966fd20ee1143b0e05036a0
Message-Id: <161988965939.32500.10161046609992297351.pr-tracker-bot@kernel.org>
Date:   Sat, 01 May 2021 17:20:59 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Mathieu Poirier <mathieu.poirier@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 28 Apr 2021 19:05:28 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/152d32aa846835987966fd20ee1143b0e05036a0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
