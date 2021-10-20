Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CCE434FEB
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 18:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJTQSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 12:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231260AbhJTQSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 12:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 699496139F;
        Wed, 20 Oct 2021 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634746564;
        bh=5PkqLT4ECl0sRroCFaaKmjtCpChdCyyra8q5enB/9ew=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Go/TXNB7ylKy4lH3ll85Y6aboKceIgSKn7juTViiYmoCwKsD84sXzIHmLNit9/EJy
         sQKliZl6XxM54ngKKL1aIJ2l9Zyf2Z1YBRwBbdQgd2X3MakbZd7ggvstJQqIVqYBgu
         uVfmkMHxhOhzKswAkKtH847H7qTNMY2q+6rA5zmxMW9XcWkMxYtrWqWoUET/hLFaLo
         /bsXPyreS2IMcmcM3kEfcCHo1/KWSU3v8UNUxyop0ZJiN8OFpkPg+cxFrffGvWbROh
         WRpMSCPXk6uLMe2tM4Xpz7h5I795iIJ7AqEoYsCVi2C2Iz7aS7FsPs0z0zOFGANrtI
         w15BbeVu0nrUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6365D609D7;
        Wed, 20 Oct 2021 16:16:04 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linus 5.15-rc7, take 2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211018183355.588382-1-pbonzini@redhat.com>
References: <20211018183355.588382-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211018183355.588382-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9f1ee7b169afbd10c3ad254220d1b37beb5798aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0afe64bebb13509ef9a4be9deb18286b4c052c93
Message-Id: <163474656440.19537.18443353896727542007.pr-tracker-bot@kernel.org>
Date:   Wed, 20 Oct 2021 16:16:04 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 18 Oct 2021 14:33:55 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0afe64bebb13509ef9a4be9deb18286b4c052c93

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
