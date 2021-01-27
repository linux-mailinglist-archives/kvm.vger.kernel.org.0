Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE013063D2
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 20:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344379AbhA0TKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 14:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344212AbhA0TJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 14:09:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5576764DC1;
        Wed, 27 Jan 2021 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611774518;
        bh=0F9hwVXsEx5Aglg2zYpQsWXv1inmLCapUAoJXBye5Dk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=W3V1c+ZomAZBfhLETp8M6uDGVia+3Ptit1Vk8naYpTzNF5HwB17RTzEQBmn0+ekn2
         UIHkMXEa4WvyVR4+F/pyS7nvHwd8XFtj8pgtwoxx9sQjDPrDuD7Ec/qp7r1nOX3MOx
         cZdPDegGS42ifYnz3tlLBegb0UWb/1zyEeLTkZfA1r8sQvY1iGSKyqjUv8TmtuxDCy
         E+4D7fmCdk3LyueNTHl8cx2i/Ya9FR85/jVhaXbV3a3kAvNbm4ZhL/DeM0vDWmyAyS
         w5I517eBo6v7ySgFRIMnozNZUOCO0x+Ae1/W+xt+NGeq+ga3j8CkYQ1gZty2UtNm7d
         vc0JPVcnkD42g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F55E652DA;
        Wed, 27 Jan 2021 19:08:38 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.11-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210127102246.1599444-1-pbonzini@redhat.com>
References: <20210127102246.1599444-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210127102246.1599444-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9a78e15802a87de2b08dfd1bd88e855201d2c8fa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4992eb41ab1b5d08479193afdc94f9678e5ded13
Message-Id: <161177451817.15019.12373579485166090231.pr-tracker-bot@kernel.org>
Date:   Wed, 27 Jan 2021 19:08:38 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 27 Jan 2021 05:22:46 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4992eb41ab1b5d08479193afdc94f9678e5ded13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
