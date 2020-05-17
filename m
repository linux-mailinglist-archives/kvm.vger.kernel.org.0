Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781991D65EB
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEQEpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgEQEpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:45:04 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.7-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589690703;
        bh=SweHTvu+PJIfFXBzOv61A7qSs3KErvxIRGR1py4o8k8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=acPE1HDrBFlqB9DP+6dKn7AaXhvBvCFajBbVyqBzBfKRg98NtwzUjJeBLdpALRWUe
         209rWm8pe0OPVkcLcx1LAO6yt6t+YDJ9HNd+nvljWnTDQV1U64n+evHO7oXfjypMKX
         OZybL6PRPUZerRSWXssFELVCnIyfYZI2aamgMyPQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200516122413.693424-1-pbonzini@redhat.com>
References: <20200516122413.693424-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200516122413.693424-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: c4e0e4ab4cf3ec2b3f0b628ead108d677644ebd9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5d438e071f09845f0abd1464b52cddee880c2364
Message-Id: <158969070377.26561.9873386854860145706.pr-tracker-bot@kernel.org>
Date:   Sun, 17 May 2020 04:45:03 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 16 May 2020 08:24:13 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5d438e071f09845f0abd1464b52cddee880c2364

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
