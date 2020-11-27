Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09772C745D
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388598AbgK1Vtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730710AbgK0Twe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 14:52:34 -0500
Subject: Re: [GIT PULL] KVM changes for 5.10-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504792;
        bh=zHDNSuzfHyxHq3myzehD2yURkDGLQHKJO7MVxcmkQWw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=pH7eiEK/tev/bjo408y1ma1njZs+Z1Fpw7HZWNSaNKC0LyQB3ZnA5cHWwHPDL/EeB
         qIaJl/nE2DMGO0LOf04MPxgjlDqVcHDDAUE5WrjJ6SahEC4rwK8795ueVFbp/ewyI7
         qMKD6J3vtA3jLt+zbJWKd1A0AlFvecYVzGJPioR4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201127163846.3233976-1-pbonzini@redhat.com>
References: <20201127163846.3233976-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201127163846.3233976-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9a2a0d3ca163fc645991804b8b032f7d59326bb5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3913a2bc814987c1840a5f78dcff865dbfec1e64
Message-Id: <160650479254.7570.17181231443400922969.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Nov 2020 19:19:52 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 27 Nov 2020 11:38:46 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3913a2bc814987c1840a5f78dcff865dbfec1e64

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
