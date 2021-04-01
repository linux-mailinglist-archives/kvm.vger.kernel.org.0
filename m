Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E4435201B
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 21:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhDATsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 15:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhDATs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 15:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60E626023C;
        Thu,  1 Apr 2021 19:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617306508;
        bh=ex6C/CpDcBPYIzQF/5F+qRYhaP9QhFht9C4BSicyCMY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CLWAWO9r2xjQKEmFRzVY0+6hE7ZFgRRZNBnzb6fyZQfFJxF7XtQLXTF6VBcDh1SeL
         Qc22VWNeUH99O9MVnMWerKdAcdhCgSjnKvhD78BJRGMyS4kRzh8Cj1EGWKbRtRQKul
         VzME8vBmABdUIzpkVNZpRz72CfpgMIUGuA7OD7tcRXVvpp3vKCj9cZPBf6WbI3CRt7
         4B7/T3+zsmXsXUVm32WSkKCGapAU6EEOJwbR0NRcZ5OpkHJqj2g+zb+jGXtDfUtHfc
         T8hdEshNConloLETBVCu/YfNxpjl9BvTP42E14iNjbpeXMPA5RizDFHJqdMRWsy5Yh
         1MTWSZslt+Trg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5090860727;
        Thu,  1 Apr 2021 19:48:28 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.12-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210401192120.3280562-1-pbonzini@redhat.com>
References: <20210401192120.3280562-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210401192120.3280562-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 55626ca9c6909d077eca71bccbe15fef6e5ad917
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6905b1dc3c32a094f0da61bd656a740f0a97d592
Message-Id: <161730650827.24871.12676189243476737600.pr-tracker-bot@kernel.org>
Date:   Thu, 01 Apr 2021 19:48:28 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  1 Apr 2021 15:21:20 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6905b1dc3c32a094f0da61bd656a740f0a97d592

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
