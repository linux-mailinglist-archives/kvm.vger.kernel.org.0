Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B753941653B
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242724AbhIWSfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242604AbhIWSfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 14:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC87660F56;
        Thu, 23 Sep 2021 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632422027;
        bh=UG9hxQ2GWvx5PZvcU2UBywNfFYTbd8ErxDfADN6EfdE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=K4eVxDExX6opLjAMRweK3dw43onZN6mUhup0QdMc2J1TeqdeUUV/SUmcwyWEEc7H1
         +1vHYgiFItLzv2X3vkpAInxAgY7t/Gh2huOXWaEQhmdzmBTRIPLcjPab6indwP4hCd
         nlnYfcfojISPi3PtHoxGjyqsYBg9jejI3RfEoJ2f9QnwWGAvbH2798JNlc91gj0owr
         ghVvUjcc4n28nffjLXxaevbI882+rvdUyob80D9HVOQHIaL5692KsYdb2KeDVaEsTV
         h/KFU59NeyUvpRaqrpmupUC1YW4VGAxPjwSCsMWTHCCKGmHVNWLG2weyxEXfPu90aV
         T8XdBKX8eULlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB2F960952;
        Thu, 23 Sep 2021 18:33:47 +0000 (UTC)
Subject: Re: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210923181252.44385-1-pbonzini@redhat.com>
References: <20210923181252.44385-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210923181252.44385-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-rseq
X-PR-Tracked-Commit-Id: 2da4a23599c263bd4a7658c2fe561cb3a73ea6ae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f10f0481a5b58f8986f626d43f8534472f7776c2
Message-Id: <163242202777.15763.11071956466334630792.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Sep 2021 18:33:47 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 23 Sep 2021 14:12:52 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-rseq

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f10f0481a5b58f8986f626d43f8534472f7776c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
