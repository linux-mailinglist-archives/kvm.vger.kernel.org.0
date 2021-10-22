Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860F6437F14
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 22:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhJVUFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 16:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhJVUFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 16:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73F046103E;
        Fri, 22 Oct 2021 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634933001;
        bh=1egVs162fh07V9il1IU3ZcKstjp7L8hFTiJO6D0l8pI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ERHM9AfXY2XKpBFFYU6EU6o6Xtl0QQtHz/nT1uO/oLt4eFeiUoB5r2DEEqp+6910O
         Nrxt+0pYPhq3IMfssdf7FzVA3gr6+Ru6BUYRJK3pZnyadZrYs299Xc0EoXuKGd4GI5
         KFLv8tnGX6ZiZ+V6elyxkhRuJ00jqUkGvuP33JcgMmUi/ErYvq7FYHb/oewQ9Z7U/6
         RQw6OGxif1+XnUtLViZltM4cDtr+dzRY88qboDvY55igrahyAteiwd5Ur6xd79qvA4
         nZ5d4IvnWMpHFXAYrxmOnYjm8BV1nqsyQSthLV3YxibcWukMMn3PPD7LzofmxZ4sNa
         r/47aR74XaYgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6426B60A2A;
        Fri, 22 Oct 2021 20:03:21 +0000 (UTC)
Subject: Re: [GIT PULL] More x86 KVM fixes for Linux 5.15-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211022170036.1782205-1-pbonzini@redhat.com>
References: <20211022170036.1782205-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211022170036.1782205-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 95e16b4792b0429f1933872f743410f00e590c55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd82c4a73b6713984b69c57a2a687203d3e0e34a
Message-Id: <163493300135.2975.5203742240708850309.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Oct 2021 20:03:21 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 22 Oct 2021 13:00:36 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd82c4a73b6713984b69c57a2a687203d3e0e34a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
