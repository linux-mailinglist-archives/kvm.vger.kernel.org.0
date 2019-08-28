Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDA6A08D8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfH1RpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 13:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfH1RpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 13:45:08 -0400
Subject: Re: [GIT PULL] arm64: Fixes for -rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567014307;
        bh=hc0bjImHvnq/IxCT5s4NZI7gpFd6msv+Pulf0AYrCR4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Oe2zFU4HpEJT04R+CubK1ZvFncH0jBu+Vkbguy2huLOriKL/CTUcTaDPCYgaKJKei
         XVVJ3CUe00SyErsxbyAewrvodXJBzCciVlNo6Q9/Q8x3yallMOeG/uPT2Uo9GHA5NK
         qqSIR8ONUMBj7/2inMxN8JMfs5yti7gQAUwK25iE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190828173233.zqwm5nd4p5xa4jxi@willie-the-truck>
References: <20190828173233.zqwm5nd4p5xa4jxi@willie-the-truck>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190828173233.zqwm5nd4p5xa4jxi@willie-the-truck>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
 tags/arm64-fixes
X-PR-Tracked-Commit-Id: 82e40f558de566fdee214bec68096bbd5e64a6a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9cf6b756cdf2cd38b8b0dac2567f7c6daf5e79d5
Message-Id: <156701430762.19174.2439398136739791001.pr-tracker-bot@kernel.org>
Date:   Wed, 28 Aug 2019 17:45:07 +0000
To:     Will Deacon <will@kernel.org>
Cc:     torvalds@linux-foundation.org, catalin.marinas@arm.com,
        marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 28 Aug 2019 18:32:33 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9cf6b756cdf2cd38b8b0dac2567f7c6daf5e79d5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
