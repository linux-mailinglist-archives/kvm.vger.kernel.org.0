Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ABB3ECA58
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhHORBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 13:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhHORBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 13:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70A3661208;
        Sun, 15 Aug 2021 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629046831;
        bh=8lZjZUmXNjUxnntj8NOK40riB6BGm9Audqqf/G6okw0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Aj6bMOsaEAlfFIt3nQxYHFYu2pof8jsBObOZgBhisFqSecEB1G7F9bY5Fgt3eEIWu
         QKYPgvwEfNZ9FqTuKnlZgbngvM5osts4C54brmEre0PhFhu3ksu53jWdYrZ9soQhLG
         lcQZiXKeizErjusgE5LRgR3yydqeByMQrOwBBH5uyhQG3FivKUeHKzr64bbZJ6KeLp
         FTMMuXMJe19B+1WSyPsC41bMOL/W1lXmpM2tb01EtkAc2gauUMK0xG4gLHqKMP5sWx
         ztWgleFKpWZ79taNFfIWP95XIPfesiy/SAqFnhxpf9s37B9laHIgSTUh6A/SEgFFTA
         Xn25NKT714gyQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5CC5A60BC7;
        Sun, 15 Aug 2021 17:00:31 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.14-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210815065617.3754533-1-pbonzini@redhat.com>
References: <20210815065617.3754533-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210815065617.3754533-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6e949ddb0a6337817330c897e29ca4177c646f02
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e763ec7914f20f55ebd9a5c087fa26e8452257e
Message-Id: <162904683132.11260.13488124645706361605.pr-tracker-bot@kernel.org>
Date:   Sun, 15 Aug 2021 17:00:31 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 15 Aug 2021 02:56:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e763ec7914f20f55ebd9a5c087fa26e8452257e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
