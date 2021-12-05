Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C7468C44
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 18:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhLERFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 12:05:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39820 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbhLERFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Dec 2021 12:05:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08332610A7;
        Sun,  5 Dec 2021 17:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 609F6C00446;
        Sun,  5 Dec 2021 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638723722;
        bh=bnf0TZWX3/GCuYWgIk0E7VyU+FTb317lfmJJMsptlJU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Fs4xej3xyTqb45H+U2IXead63podeYpRu0EyNpGlmfhsK6LBILahV7rk9k5MV9KuZ
         TJ1uAJhCn5BurHXIifg0OSriHjDmdX3vVzGHk2jTyHscqdySVgUpJku0i48CLkFLvK
         hvVALmcZUIgqOXGxJyyDYiaZVLQu+Zib/w1RzqX0OD8iJbpmuOzYxHqTOnSSroJi/X
         jE5ZuPv6C6m38r8cvJeiIjQgB7qdIxSQQlHu83efursdM43YW7FvonDON4TohAp/wK
         CVXOuLic8Tp3oB5wkss9rwyuETm2qMInTBM5u/D0QOoLNyrNvqoV2FTl7FeYPAoKcZ
         Nfgx+FAw9x2dQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C694604EB;
        Sun,  5 Dec 2021 17:02:02 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM fixes for 5.16-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211205081339.8716-1-pbonzini@redhat.com>
References: <20211205081339.8716-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211205081339.8716-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ad5b353240c8837109d1bcc6c3a9a501d7f6a960
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 90bf8d98b422c09625762d55644bad64ab74c509
Message-Id: <163872372218.18723.5396724008300070737.pr-tracker-bot@kernel.org>
Date:   Sun, 05 Dec 2021 17:02:02 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  5 Dec 2021 03:13:39 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/90bf8d98b422c09625762d55644bad64ab74c509

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
