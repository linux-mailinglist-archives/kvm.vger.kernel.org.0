Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA7379826
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhEJUNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhEJUNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 16:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FB03610F8;
        Mon, 10 May 2021 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620677533;
        bh=xN6f/l9ZLXmsrZ8qOdxNy8Tw6yolQ8Gf55ZxCnAySGE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BQfInEClRXFtpr3wigVKLT6X+OerJEBQHW9oO/RAe9/XMXoMmtyWXwmx7hgPQRry+
         wrYXAcrhKwFnZA9ItjN66+sIBELy4jWspLm7LSHrEkZzInPeYJTO1COUCPpyUpGUNg
         dL2poPE4Shc/OejZix2FeCQkpJy5R4323/VAsqzkHdMGdpat/aYz+gsl2v3cB8UmHU
         ZCtAUf9cUoexDxiotLLvhObHBnhUml9udeAcj9Q2QAWYhO/066kfwAxteRf5SnrQrb
         mtPuQVr4Yb3IgSZZCV8AIWQVnmlFH9XbNq8IROvXN/PZM6E90BC1O9e6yXFfIx9Ud7
         /lcvpq7EQGT/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B034609B6;
        Mon, 10 May 2021 20:12:13 +0000 (UTC)
Subject: Re: [GIT PULL] KVM updates for Linux 5.13-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210510181441.351452-1-pbonzini@redhat.com>
References: <20210510181441.351452-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210510181441.351452-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ce7ea0cfdc2e9ff31d12da31c3226deddb9644f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0aa099a312b6323495a23d758009eb7fc04a7617
Message-Id: <162067753305.25270.11623992623087230005.pr-tracker-bot@kernel.org>
Date:   Mon, 10 May 2021 20:12:13 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 10 May 2021 14:14:41 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0aa099a312b6323495a23d758009eb7fc04a7617

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
