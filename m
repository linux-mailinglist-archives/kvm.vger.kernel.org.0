Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1413A463D1C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbhK3RsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 12:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245006AbhK3Rr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 12:47:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD0AC061574;
        Tue, 30 Nov 2021 09:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A711B819D9;
        Tue, 30 Nov 2021 17:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29DBCC53FC1;
        Tue, 30 Nov 2021 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638294276;
        bh=Rp2Gp/egZ4qHFOaTZvslUxL2rU44Tl2+N/LVxzWLTTI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mbZZmXWY+Fn2sOEY86FbsMl1XBUY39licUCY5b8JeBbE/T7oFvqIC4fEevEmretWY
         vvhupL2wg66zZpVduvmdPNuw9onrxd+Me6a7moxXq10cQgEXeso+gGrFBpOjKbHDEw
         tCuJVaPk9GgAQtyTRjAKA61jftZfMkz6uca+TK3oZdRdAzZhmJgU2LsLVTTRTsYfJA
         tegL803WskJaY/yCIThpkEMyGS9RvUpB9kaHsjJYSvRdxKYbkz//ZLgHO9cdYtfct/
         kijrSV2fMVNiuW3J7IDw32umnqRjPabS71sz2ojO6MAiR8XHJ7Sao/CS6SPLYyCgrN
         E2zWFVMFzHlQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F285C60BE4;
        Tue, 30 Nov 2021 17:44:35 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 5.16-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211130165738.358058-1-pbonzini@redhat.com>
References: <20211130165738.358058-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211130165738.358058-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 7cfc5c653b07782e7059527df8dc1e3143a7591e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f080815fdb3e3cff5a004ca83b3815ac17ef71b1
Message-Id: <163829427593.13483.5255490699168250098.pr-tracker-bot@kernel.org>
Date:   Tue, 30 Nov 2021 17:44:35 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 30 Nov 2021 11:57:38 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f080815fdb3e3cff5a004ca83b3815ac17ef71b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
