Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6BBB6A66
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbfIRSUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387996AbfIRSUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:20:23 -0400
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568830822;
        bh=GPFBgQdt1CTSJAX0HqHciIyC/bRmaqeH2vsdKoGaZ2Y=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uGbr+B0eix/EF4vpFgqQXln74YPUhr1FPWeaRy/5gWY2aricX8WA0+wQg0w7hL5Xh
         4A0BadC2U5XwyiFWb5qLWxfR5XVIzrx/l50j2aa5yBTc4+jgqcPsfCmoaDpxkD23am
         rRx+HmGDiSAArh7Ch8YwsW9tZdaGKIWrq0ycjrWc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1568652881-21933-1-git-send-email-pbonzini@redhat.com>
References: <1568652881-21933-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1568652881-21933-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: fb3925d06c285e1acb248addc5d80b33ea771b0f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fe38bd6862074c0a2b9be7f31f043aaa70b2af5f
Message-Id: <156883082293.23903.6518209741876972182.pr-tracker-bot@kernel.org>
Date:   Wed, 18 Sep 2019 18:20:22 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 16 Sep 2019 18:54:41 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fe38bd6862074c0a2b9be7f31f043aaa70b2af5f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
