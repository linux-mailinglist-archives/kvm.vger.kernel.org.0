Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB8388639
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2019 00:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHIWuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 18:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfHIWuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 18:50:08 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.3-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565391007;
        bh=oQqqXgtOPPuOYo0t1QlaaD/7YWX1DvrIVWcxq6Qaopk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OtoM/9o+BydcTMpvCYrX3cwya0mRQfwaP643UA3Mb3brESmplnb0ssQMI30OcqYEL
         PhUwEqg21dj0cGCruIjosK40b6icpxYG8YrgRJmLVZQ8zPsCIOL1G8wcZ7ZVMtehLU
         Ki5avnehTZRk7lrnA5j6Q2dybZGVecie3pWElclM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1565390195-16920-1-git-send-email-pbonzini@redhat.com>
References: <1565390195-16920-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1565390195-16920-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: a738b5e75b4c13be3485c82eb62c30047aa9f164
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7f20fd23377ac3356657ce35fcaf19ee2fea8345
Message-Id: <156539100743.24486.7661572724956295793.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Aug 2019 22:50:07 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 10 Aug 2019 00:36:35 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7f20fd23377ac3356657ce35fcaf19ee2fea8345

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
