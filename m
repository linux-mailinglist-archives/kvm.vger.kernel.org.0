Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764D12A20B7
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 19:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgKASJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 13:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgKASI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 13:08:58 -0500
Subject: Re: [GIT PULL] KVM fixes for 5.10-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604254138;
        bh=AAQ0Cjh/CtSW7cNKedsPErfoinIy1ZlkNv0b4A44j1o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Hx+ty7aBvelX3Cydb3qioEnEJOva47tl4CinM0z1jvfC72QG9+p5CsmjLeAeQj8A4
         rTT1V3l495SY+a8iwVdcVz2YdpDMQ88flwXGER/SeA0jliLbWReM9GWSIcFERnojXp
         A8qjMZpDGnoBinjZ1lje22N2FnARUNkd1kYx8dCU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201101092427.3999755-1-pbonzini@redhat.com>
References: <20201101092427.3999755-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201101092427.3999755-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9478dec3b5e79a1431e2e2b911e32e52a11c6320
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d38c80d5bafecdd3bdb0d22b722afba8101ec1f
Message-Id: <160425413815.10555.6712069766913415369.pr-tracker-bot@kernel.org>
Date:   Sun, 01 Nov 2020 18:08:58 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  1 Nov 2020 04:24:27 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d38c80d5bafecdd3bdb0d22b722afba8101ec1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
