Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D699282679
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 21:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgJCT6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 15:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgJCT6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 15:58:16 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.9-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601755095;
        bh=LEjN3PsFgvdGJPlfNLT7AtHXvIcVtewgyDp8aiKJVUc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=k9L291d4dV8Yc256QYiUsq8/a+JVbWwH72MlOitpPMrqtjmEnljcHRdPfgUBAqgIj
         +mhZt+t0pCCCOg7jz8p1gowPv40vmhJW4ETnFZgsEsLOjNsmOR3FYuZeNH+OR7yLZM
         HjI+EyOMemVOGO+s1/DU2ySatF7sEc4NwjQpP0U4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201003091854.240100-1-pbonzini@redhat.com>
References: <20201003091854.240100-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201003091854.240100-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e2e1a1c86bf32a8d7458b9024f518cf2434414c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 22fbc037cd32e4e6771d2271b565806cfb8c134c
Message-Id: <160175509583.27812.2666674823953193567.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Oct 2020 19:58:15 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat,  3 Oct 2020 05:18:54 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/22fbc037cd32e4e6771d2271b565806cfb8c134c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
