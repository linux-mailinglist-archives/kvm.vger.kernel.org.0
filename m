Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39DC41A165
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 23:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhI0Vgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 17:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237050AbhI0Vgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88EC760FC2;
        Mon, 27 Sep 2021 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632778511;
        bh=i/5qaUd5B27WS8trQceONaMrzSaPPkc0J5yt7RdrsXo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CkLvQS04zUoiO7qe2hPeoGXXYxHH6rD9ze0Udt4ZA6am/lL6cK8QVhulOcjyrpPYf
         xRDCayWJxEmcq/RpmWhWjxWGUNf3Kstud2kqoDAOnShqB4K0iOGCe3m99L0FBANRCl
         VgtPctzoB83hBSDreLKlepaD59SUwqxQx8+PFHmBAYgnIKphrAFh2arblzOiFTOF8d
         0CBjiucy15RnVxquI4gOTF50ekJqSAcuMA7LPMcFBrGvmrqHKvEcdeHV3ffB7bbAOs
         sjqAbD6kvjEp4jb9YownIOXInvV8d4JH9bfWJAmEQB4JYD5hpqBC+Pvu3YFZd58wvx
         9HBCutm5bYcxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7869A609CF;
        Mon, 27 Sep 2021 21:35:11 +0000 (UTC)
Subject: Re: [GIT PULL] (Many) KVM fixes for 5.15-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210927152947.532485-1-pbonzini@redhat.com>
References: <20210927152947.532485-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210927152947.532485-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 50b078184604fea95adbb144ff653912fb0e48c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9cccec2bf32fa2a8039cfcd228b9f3a4f0a4f5aa
Message-Id: <163277851143.31120.15946236454699069311.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Sep 2021 21:35:11 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 27 Sep 2021 11:29:47 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9cccec2bf32fa2a8039cfcd228b9f3a4f0a4f5aa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
