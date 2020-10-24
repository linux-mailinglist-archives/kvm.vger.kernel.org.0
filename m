Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB3297E34
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 21:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764087AbgJXThR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 15:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762379AbgJXThQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 15:37:16 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603568236;
        bh=hX5oM8AHkodXVrsb7jxKH7jYDfypv+YxVzQxHvJeShg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=CCsifblaiUCDLTGBZhACCEERq7NUJpCVTk2/rEYZyTc5WEvh/Oq9qPOsZ/Ur5oZfV
         lm6OHNOn4L6uHh2hXmyyPZc7sn86B2sSX8v/c5OdXtz149YxRgAALX9qomd+EG8PbS
         vxaGtFfeHYVvqVWxGaMZejVv4qvyt3QO+Ux6D58c=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201024090157.2818024-1-pbonzini@redhat.com>
References: <20201024090157.2818024-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201024090157.2818024-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 77377064c3a94911339f13ce113b3abf265e06da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9bf8d8bcf3cebe44863188f1f2d822214e84f5b1
Message-Id: <160356823650.4617.3707324342349252811.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Oct 2020 19:37:16 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 24 Oct 2020 05:01:57 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9bf8d8bcf3cebe44863188f1f2d822214e84f5b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
