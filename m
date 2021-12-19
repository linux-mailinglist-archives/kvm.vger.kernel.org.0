Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF9047A220
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 21:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhLSUzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 15:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhLSUzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 15:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB834C061574;
        Sun, 19 Dec 2021 12:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 819AFB80DCF;
        Sun, 19 Dec 2021 20:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E761C36AE9;
        Sun, 19 Dec 2021 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639947328;
        bh=9hmwVrPYQp7EMXjpJoOwAjmT8F1gS8URjnBlochnPxE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Pjlvbp9eMxjFIlsLCucXzKs+h4yTMVOYDnJdI9Azp1SE5cFCSgEoNq4Deqohsdr/Q
         nDsO1sroAUS86f4hMusXJWgw/4P7Vhb92gQ6iZ51BguXXSWbGxINB0YRjGV/sWfFCe
         dQvXzR0vWX77vl15ByVce3bdu++mMTIFRK+hVJzgBCP7GR9+SLYuawPwMEO7fN6SuR
         RgyLjDwavTci8hKMhJ9rLDN/zA7+XiC188h5Bxz2OPq2Pf80pPdbdm/T2nZEtDkrir
         2kcLz5j02/+UX8ALU8oHyPTdkalPGbWLOI0lj4LLVxoYKzMR/CeyXdQCziNJsuiZc2
         NjA5OG9bY8bDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 29DA760A25;
        Sun, 19 Dec 2021 20:55:28 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.16-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211219191608.265537-1-pbonzini@redhat.com>
References: <20211219191608.265537-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211219191608.265537-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 18c841e1f4112d3fb742aca3429e84117fcb1e1c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f291e2d899d120880bfe8e0fa6fe22a97a54e054
Message-Id: <163994732816.21051.5133465953318410295.pr-tracker-bot@kernel.org>
Date:   Sun, 19 Dec 2021 20:55:28 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rkrcmar@kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 19 Dec 2021 20:16:08 +0100:

> git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f291e2d899d120880bfe8e0fa6fe22a97a54e054

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
