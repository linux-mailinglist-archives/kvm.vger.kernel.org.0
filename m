Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB233B486B
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhFYRva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 13:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhFYRv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 13:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0F00C6157E;
        Fri, 25 Jun 2021 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624643348;
        bh=tDN0c/CBsYNm5d+a3o1LYo5O9kw45mX4O7Gt3KOxcmo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mJHueK1L87pqdUtIYC/hfo4+M/aQRkX1uQVxRbOZcZDdkf/oMRjvrMPch1U5oMM7x
         ZsN4wP0HhfgeoznqLh/CseE6bi2QfSM7HVLFz1L4W1901q6nxOSfQVRtlCT7GCBxim
         PrirTevZOZOT6mvTfGYV+hOOcH/TJ7Y+tmbQnEAECjckUuOzlfq9KvmeO+hqVy5iTd
         sNU8aWOXkasWzhpIEStgLmmVAM/P/c+pX/evQXmPWf8obur7mI39BME8Hy4L0TQdOr
         e56GhItckwCYf4l0XvU7udKZaXGbAskUcWhFvEmfDcyLoJuhvxzz6WyBJrQND/Y8b2
         BbmUvpvMslkHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09A4560A71;
        Fri, 25 Jun 2021 17:49:08 +0000 (UTC)
Subject: Re: [GIT PULL] Final batch of KVM changes for Linux 5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210625144730.32703-1-pbonzini@redhat.com>
References: <20210625144730.32703-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210625144730.32703-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-urgent
X-PR-Tracked-Commit-Id: f8be156be163a052a067306417cd0ff679068c97
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 616a99dd146a799d0cac43f884a3a46571bd2796
Message-Id: <162464334803.2214.16273265079220454847.pr-tracker-bot@kernel.org>
Date:   Fri, 25 Jun 2021 17:49:08 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 25 Jun 2021 10:47:30 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-urgent

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/616a99dd146a799d0cac43f884a3a46571bd2796

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
