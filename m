Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FFC27957F
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 02:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgIZARm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 20:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgIZARm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 20:17:42 -0400
Subject: Re: [GIT PULL] Second batch of KVM fixes for Linux 5.9-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601079462;
        bh=gxJ5vQ59gSyCcJve887J8PbMh8nUekCVFKlkjtkdsiQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VhL4EhhT9y/tEHs4IfQ+/uLar8aiD8e/zOAmxpFdgTXf+nuTPd+8HvEudou8lgMIt
         A2Sj6quTn2QTX/1Ra4vGhuxjDj73jImn5AHA0KF+k0Q4gbcjT4hMauTCiAlbFxgyul
         xsVkEND4WBEacV2Rsb0Bg5JUqgcZfCFs+oGOG8+M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200925233652.2187766-1-pbonzini@redhat.com>
References: <20200925233652.2187766-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200925233652.2187766-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4bb05f30483fd21ea5413eaf1182768f251cf625
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c7ec3226f5f33f9c050d85ec20f18419c622ad6
Message-Id: <160107946221.14661.16795756209476827695.pr-tracker-bot@kernel.org>
Date:   Sat, 26 Sep 2020 00:17:42 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 25 Sep 2020 19:36:52 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c7ec3226f5f33f9c050d85ec20f18419c622ad6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
