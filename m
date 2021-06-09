Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D223A1F91
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 23:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFIWBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 18:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFIWBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 18:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F8D9613E1;
        Wed,  9 Jun 2021 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623275963;
        bh=AvJgOp53c+Ht7yBKxrC7sImqArJtU1zmhHbDVunFwMw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=POudFogSEFp76BVC3OlRQneMFMlkZesI5dj4qBNzEdFndrBkEyrb+aMGGBlm2Eyw0
         N+mlkaiR32qMhpX9vT++Jx+fW0cduyD/GTEFdcXE4U+lcDViU7n9DbzRanh1ulPv7D
         7N108vsHvBqKpSw1a/LYss88egUCzyGMFcRmn0lw56CDGYsEu8k+e0bihnWiGf61pA
         a+BuAMLoni5djB3q+FhQ6c4Uo/T4j6A26gaiREcfsCkXmEXjatkEAImQ4bmgHFZ97I
         rel3l0FpZjW5OzpwUe8588ifXcyuSbptzUNUm7EGm9Nslkn6Y48HogORzT4PjhVyBi
         86gZwjc/kz4Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5456F60A53;
        Wed,  9 Jun 2021 21:59:23 +0000 (UTC)
Subject: Re: [GIT PULL v2] KVM fixes for 5.13-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210609171313.150207-1-pbonzini@redhat.com>
References: <20210609171313.150207-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210609171313.150207-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4422829e8053068e0225e4d0ef42dc41ea7c9ef5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2f673816b2db30ce6122fe0e5e6a00de20e8d99a
Message-Id: <162327596333.6358.9722438115626670701.pr-tracker-bot@kernel.org>
Date:   Wed, 09 Jun 2021 21:59:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  9 Jun 2021 13:13:13 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2f673816b2db30ce6122fe0e5e6a00de20e8d99a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
