Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7AB1B3134
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 22:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDUUaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 16:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgDUUaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 16:30:21 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.7-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587501020;
        bh=engZtD2Byr5RNVmx4+QRjiZoeOI+oX+7T22guYnldLw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SON04QHRx3IFEjqIFis5u/ZUdV+t/flRU32973qWUsnIWwlXQJaolyovWTM1Yhjj8
         WngXy/ybARAoHH/G4wSES/+cmQPXEPVlrt9UVhVgd5bIA24DLmFZqK/XZ9yjYRNCl7
         mhHFJ4wj+u0zParG3ZCIJ1W2MJevo6WbeEmkG1Ak=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200421160651.19274-1-pbonzini@redhat.com>
References: <20200421160651.19274-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200421160651.19274-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 00a6a5ef39e7db3648b35c86361058854db84c83
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8160a563cfff2a94e4ef20508961f1c9eead3b1f
Message-Id: <158750102085.18550.2785276584947429254.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Apr 2020 20:30:20 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 21 Apr 2020 12:06:51 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8160a563cfff2a94e4ef20508961f1c9eead3b1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
