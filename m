Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133113E1C9E
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbhHET0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 15:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242838AbhHET0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 15:26:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF9966056B;
        Thu,  5 Aug 2021 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628191562;
        bh=W3bdIEvqemUYRjwXQLEDWzdZhdqeZC5+k281tmxhah4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AFKJnuNeUhP+EF81UVBQDyS52m+NJWFO/1kZZyalpCvcYhi+fcJjwPKM0sP6ifhGP
         F3oSBN+/A8+m52Nkz1YXcToLY7ZDHPGkdFUQOjKb5bWahuFWxwvQYvXp3b1cRBBiQ5
         krx0EaOHJNbAv82scZ5EbckMfpeK2GaFX0JSXhA3EiIFrVyKybVR3shbMy3wTe/O31
         uSGLnVcxUYqWTRbyLdII5l34s1CUIBjTCU1tmCvP1WQfjGGFaKuzDdlpMOKfN5TPrS
         yQ7VOzfBpXUyTCAg9ZNGt8y/UIulzn7ALn7UX6qTkcC/7lcH44Y6tE9rGkX43XBhMM
         mS9Lq3pYUR8IA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB26A60A48;
        Thu,  5 Aug 2021 19:26:02 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.14-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210805073958.2684067-1-pbonzini@redhat.com>
References: <20210805073958.2684067-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210805073958.2684067-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d5aaad6f83420efb8357ac8e11c868708b22d0a9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 97fcc07be81d4f49e1763483144ca7ff79fe0ad5
Message-Id: <162819156282.13342.5496279504621527828.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Aug 2021 19:26:02 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  5 Aug 2021 03:39:58 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/97fcc07be81d4f49e1763483144ca7ff79fe0ad5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
