Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE473A1F92
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 23:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhFIWBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 18:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIWBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 18:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46C8E613DF;
        Wed,  9 Jun 2021 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623275963;
        bh=61hh2zM0qqXMEYOyDLIM2ziddOLZ719KMtjLu8kJoSo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DSVd9pe4nEMW7H5CRQ0jawP9/3mPP+eNtg7y3v/Fk7Aar8upPaucOnRDiEcl+5icn
         SV2K2M10vG+Ku8kXSElQ4/gOib0qk7V815Kt50huYwLzgcVeBObnIE2T0HpCIP7dq7
         924YsYOqu5wjp2VqJQmLwMFelLP41DoWiP+ePR6u0D9Uv9mCBzT+qv9jl/9ee3s3Yp
         3RRe86DLvd/gFpFVfAmdKIe27WD1+nPlC2meo8Vao2dGUd3GdD6rgWKHzh4Y+qV5mR
         XHV31sqD0lNTVVibAjc0OmlQ3ePf94xEbB6J35yk27Y57NYrjHzEO5dX/NigVhx1ZL
         ihsVCZiJBbWvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 332E4609D2;
        Wed,  9 Jun 2021 21:59:23 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.13-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210609000743.126676-1-pbonzini@redhat.com>
References: <20210609000743.126676-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210609000743.126676-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: da27a83fd6cc7780fea190e1f5c19e87019da65c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4422829e8053068e0225e4d0ef42dc41ea7c9ef5
Message-Id: <162327596315.6358.6895024846376544704.pr-tracker-bot@kernel.org>
Date:   Wed, 09 Jun 2021 21:59:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  8 Jun 2021 20:07:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4422829e8053068e0225e4d0ef42dc41ea7c9ef5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
