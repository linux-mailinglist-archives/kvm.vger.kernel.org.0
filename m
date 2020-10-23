Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1681297756
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755142AbgJWSxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755135AbgJWSxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 14:53:20 -0400
Subject: Re: [GIT PULL] KVM changes for Linux 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603479199;
        bh=IjAP73y7IG/n/JYBdwRJ8w4XeOpZ9U5HPUE44e+r9N4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=k71XDvx2Zl7DTphAGuxcpLeT5J+aCIJuDJrc51nYSu05D3nM/OWCrcsj5S1tOx1R+
         RCroKOijyNxnjtWe5cQRsyDHpWVLT+3zdr0WzSkVxgh3dWwfDU43JbBeiChS/N1uMY
         5tbl7c+kePex67zk0Y7q/o524OozIkh8KXEQYlNc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201023173619.2785471-1-pbonzini@redhat.com>
References: <20201023173619.2785471-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201023173619.2785471-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 29cf0f5007a215b51feb0ae25ca5353480d53ead
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f9a705ad1c077ec2872c641f0db9c0d5b4a097bb
Message-Id: <160347919945.2166.2540518909924106756.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 18:53:19 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 23 Oct 2020 13:36:19 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f9a705ad1c077ec2872c641f0db9c0d5b4a097bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
