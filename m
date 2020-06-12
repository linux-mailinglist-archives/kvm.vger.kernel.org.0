Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668441F7D88
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 21:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFLTZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 15:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgFLTZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 15:25:34 -0400
Subject: Re: [GIT PULL] Second batch of KVM patches for Linux 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591989934;
        bh=TPvJCwvOXdh8mLjnahnee+4KPe5QqLKe09oiqI+ts+k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=S4CyH3TUP5fAleADvfWltMfiE+5i8z2rEJpcQxIWgHAcl54c/yClGv+UwhKIba0IZ
         WU2Nn1aRZ1JxGro6U2UdwxnIZCPaZFaD1M+WVLdPd1auPtxrtbxWugBvMFNOZzCtkq
         t6oU4t3V+pPwQNUGr9s4ilwPDvKudXIwbZ25r9+g=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200612163112.16001-1-pbonzini@redhat.com>
References: <20200612163112.16001-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200612163112.16001-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 49b3deaad3452217d62dbd78da8df24eb0c7e169
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52cd0d972fa6491928add05f11f97a4a59babe92
Message-Id: <159198993397.4050.12494916014185458605.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Jun 2020 19:25:33 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 12 Jun 2020 12:31:12 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52cd0d972fa6491928add05f11f97a4a59babe92

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
