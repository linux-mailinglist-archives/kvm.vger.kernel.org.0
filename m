Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8043DA950
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 18:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhG2QrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 12:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhG2QrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 12:47:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B869960EB2;
        Thu, 29 Jul 2021 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627577227;
        bh=s0UNMkNeFre0YiRZMUT9ZUSx5Eqb8rQ9Or+Qvqxl/v8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HbhLjpTY7Xi4VhSe6VPXMEMS/7PZxRtzx7Rlw1InhHmAiSccOG+aE2EEJBe1oJ1uq
         hS+ry72WRUKOFq46Wy1zIM2D8yby38zao94pKdi43YM1jxzldLrBAkoxlq9LC4Wugk
         V2zLYIgz/CsX0Yy5QdTulQ7FRgIQEuxlPSrKs4CTyrexUps7Xe5uVIvB/NSz/qmFdl
         bLIqO2YC5fGSK2tgb7wtx2wPrctl12eJejFY2wR6QrzN6JCFveAwMcFafY7q/vId7T
         W+ADfrnpE3yhFZkEZlAfpuf8L5TH+NTAx49FAuXZbD+dRlt3h1wwFICif2wcDjEQ9g
         mJOM8YlfnOdRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AE3D760A7B;
        Thu, 29 Jul 2021 16:47:07 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.14-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210729143736.2012671-1-pbonzini@redhat.com>
References: <20210729143736.2012671-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210729143736.2012671-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8750f9bbda115f3f79bfe43be85551ee5e12b6ff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7e96bf476270aecea66740a083e51b38c1371cd2
Message-Id: <162757722770.17762.1106985350881994065.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Jul 2021 16:47:07 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 29 Jul 2021 10:37:36 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7e96bf476270aecea66740a083e51b38c1371cd2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
