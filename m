Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5932DA69
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 20:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhCDTbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 14:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236098AbhCDTba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 14:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6479964F5F;
        Thu,  4 Mar 2021 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614886249;
        bh=KM9+FUcEaPklWZy9Z1oXj8NOVoR5Gwh+Tr9RnmZFoBw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=O1u2CviFfCz5K954vEVSUa7DsOMb49cAan6vr5AefWgNmJOQ9TCTQVnJSKjguzhr2
         4O4/hFeltpGZAf3b1zkOFv7IsOjhPZd3sLVY8eFsU8RrWhDlcuH5K75aYH1I5bGENC
         m+/i4LsOh85uorrkS3KcMyAa7QTq1crhLOvM+dceSsTCW71J+exzvhE79JyHFNVdkI
         6DLN1cwnj30uBFSILI2XAP32ALUgAqvVpEBaQEn+PtLOYjvXVeRYCDZjZEJjGg5Ebb
         TXl8gtsMTuG01A+ocAb2k9vxhiNQ26b/F7yrwESuLgE89y301G/BuzmpCKDHiTnnfY
         RgexsUMV46xPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F569609E7;
        Thu,  4 Mar 2021 19:30:49 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.12-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210303151007.383323-1-pbonzini@redhat.com>
References: <20210303151007.383323-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210303151007.383323-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9e46f6c6c959d9bb45445c2e8f04a75324a0dfd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cee407c5cc427a7d9b21ee964fbda613e368bdff
Message-Id: <161488624926.28500.3551606696689046612.pr-tracker-bot@kernel.org>
Date:   Thu, 04 Mar 2021 19:30:49 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  3 Mar 2021 10:10:07 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cee407c5cc427a7d9b21ee964fbda613e368bdff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
