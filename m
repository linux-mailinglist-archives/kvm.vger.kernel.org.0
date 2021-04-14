Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E992B35F8D0
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 18:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351620AbhDNQP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 12:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhDNQPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 12:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3692A6117A;
        Wed, 14 Apr 2021 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618416904;
        bh=1nDvP95bzb/uGokuz/oElAfbPFu9dpjFesgxr65T4+w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tA83H+ogr0YmNzNmB08TSrm9AQ+KJLdpF8hnVZgfx4ci6Wx9T/IGtx5upTD71tqgh
         gg0dV1ullKausocnX2qAd5p3lCPX/GdCtV6SHvzuyknRGhnw0opMUd/88qFz6gsmIO
         YvqyX2arWSm+wVOHyblNtAZjJZddKGW0lvcbiKyka2k/sh84Yr+2xuRA0VXjlGzuwr
         FjU6LPUF9GN61mVaYgH5CzrRF/ycsxbr5cKxDs0i85NMMBG3oxzaivKYdgHVqALUin
         JU5UkSNyRlr+BfM+8/HVBKtiaLOVbqIFRMAaztyyVyqf7KfFDAqEc/wWdoCe9P/eTV
         pWqE8SfR667rQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2485D60CD1;
        Wed, 14 Apr 2021 16:15:04 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.12-rc8 or final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210413223958.156145-1-pbonzini@redhat.com>
References: <20210413223958.156145-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210413223958.156145-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2558258d78873998b8cd81ce7661dc68541b8b51
Message-Id: <161841690408.3200.15405279772210006990.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Apr 2021 16:15:04 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 13 Apr 2021 18:39:58 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2558258d78873998b8cd81ce7661dc68541b8b51

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
