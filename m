Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54CD470E2A
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344783AbhLJWuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:50:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:50:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE987B828B0;
        Fri, 10 Dec 2021 22:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 931AFC00446;
        Fri, 10 Dec 2021 22:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639176406;
        bh=mnjp6VDYXfLJMttoXHB7lrmitWzQ13Jm3O4ADKVDob4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=j8InpeyuR164AZVjh7D7d8yQTGyoibX71kZF/mGtOH5xf33dMICJGt/eLAgZ8b5ru
         hdVfL5L98tPV+tfN2mwh0R5NNLgnKj4mRRPSMQh5uiuwY2phZeOWp3P5Y0NLja1F5v
         hJ5PublvJHADkEsd2+dTtJW+49yu/v5JbQEoEUf7W04GvE9/jlDJFSBOrTSFbTWb/R
         S7qdgPSY4x5xUqALVOkv8KsXSRVegPZQV1Xbt7+Gw+eykbhKR6INg9TgLKb6wwCp1s
         DpOfIlYjPelZMhq9BnPJaboCCXn9c6mtAUQwUxdK8H6Bw3b0kNquFfFbLggGS6U/vF
         dX5C0aTaupljw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 67FCE60A39;
        Fri, 10 Dec 2021 22:46:46 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.16-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211210145044.28699-1-pbonzini@redhat.com>
References: <20211210145044.28699-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211210145044.28699-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 10e7a099bfd860a2b77ea8aaac661f52c16dd865
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b9172f9e88446f3ede07594752c70555a2aee33f
Message-Id: <163917640636.4787.1657191058795981482.pr-tracker-bot@kernel.org>
Date:   Fri, 10 Dec 2021 22:46:46 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 10 Dec 2021 09:50:44 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b9172f9e88446f3ede07594752c70555a2aee33f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
