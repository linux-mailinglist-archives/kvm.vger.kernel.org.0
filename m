Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51744F4CC
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 20:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhKMTSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 14:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhKMTSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 14:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 71455611EE;
        Sat, 13 Nov 2021 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636830925;
        bh=tfzTtNy72HuvUkMo0//95tonC/+HNaj2B9WkA50DDoQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jAjGyqF0G9azvaphb37IRXsw+nEGwdRFhcXJQHZdwoCciOWxoZvgOKZdI8tSlVfgd
         /AlTbkocW5yYhYbx8VlmRzmT2wxCOe/Dla2tM2CEtqiZImfYHZPvqtWxKFcJCsdV0j
         adyGEXk+Xvx1a4kq5HTi0cAQR2gDta1Y3FCA28RGfArQ2ncx0jJKahwvwUs93QhXLL
         bWIDiUXkq9U8AAhddu+JYQDW1ilHNjUCsY0Erh8JqBmNcNKXfg92KDbDR23P7uvsSm
         st14J9FFJELYIVdFR5sXVWclPSafZwlMqJfmQQg55cDp2ibU01HaHtB7Ar7RF7PgGS
         33sMwfgD11MGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B83F60987;
        Sat, 13 Nov 2021 19:15:25 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.16 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211112220315.3995734-1-pbonzini@redhat.com>
References: <20211112220315.3995734-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211112220315.3995734-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 84886c262ebcfa40751ed508268457af8a20c1aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d6fe79fdeccb8f3968d71bc633e622d43f1309c
Message-Id: <163683092543.10343.8830796288766749205.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Nov 2021 19:15:25 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 12 Nov 2021 17:03:15 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d6fe79fdeccb8f3968d71bc633e622d43f1309c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
