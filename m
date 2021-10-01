Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E229D41F4F7
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355894AbhJAS30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 14:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355691AbhJAS3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 14:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C7D661A51;
        Fri,  1 Oct 2021 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633112860;
        bh=fT8VZCJfFgbodnGWbVRGq1XrFb1TRAuULsoSkEjYpUM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZrTtMGSnB5dhhEpkOVBGok23k3Xfg83JhOqK0jOpae15+Z47cvtCJhZ+hZDGCz5Ad
         r9dZs1sFhPggq8gf5HBt2Fl6O+NRXIFGrcLWaiaNFm6Sby0oxsA3PHddTWvrnIl5Dk
         1c0K0mweinQe1vLOTZTITFdFiBmo3b+vc0VTqOet1CLfRaiOJ8G6cEbn/BlXlnp6OZ
         MHwNzH0W1if9kL5OpKa/8uDp1VxheUyMebqI8259cPnD5mPp6RxTu75C8CedzZKTKL
         Eom81I/FliOxR8zFF80AG8UDwwB/zDIDjaMaL9s0bUkPQ2w598tn3bbld7PZpIpop0
         /zb/HIpEaL7LA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1CA21609D6;
        Fri,  1 Oct 2021 18:27:40 +0000 (UTC)
Subject: Re: [GIT PULL] More KVM fixes Linux 5.15-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211001171310.16659-1-pbonzini@redhat.com>
References: <20211001171310.16659-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211001171310.16659-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 7b0035eaa7dab9fd33d6658ad6a755024bdce26c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2626f1e3245ddd810b69df86514774d6cb655ee
Message-Id: <163311286005.3460.13685629815618822976.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Oct 2021 18:27:40 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  1 Oct 2021 13:13:10 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2626f1e3245ddd810b69df86514774d6cb655ee

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
