Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ACF36A242
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhDXRFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Apr 2021 13:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232339AbhDXRFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Apr 2021 13:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6D808613CD;
        Sat, 24 Apr 2021 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619283901;
        bh=5kipEaBMjkjdLwoExPeZMrq4SwKnyXMBAYzOLILqoys=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XJqrrZLlhXXERqPygTJJy6tZLwwaBj+yFmpNUsXdR534EwZrPuMd6O2Cwq9zywZDg
         U3yx5+A9CGFkpIT9wxUMUpqNrMwxUofhLbsL5CtjXNlMsgwHrQEmWgqSb5Hb1LV649
         DdlUvt0FV3W2XGUOstW62wpmnaawZIX05z/fsZCpr+8CAqfX9FisG2tltUeiTnzPeg
         yU1+7WoT4ZRGITQZ26Mmb3WdmBgykrHeDSCE2xTeyK8rMPAmd4JGAjUkzbiHzNEh7W
         BeJWfhkWhG7YYK6tlxfsKEvMTDMothgysN0pCTKw2d5GRp8vjJ1HFUiCq3d8TNFIwt
         FDJM9oqRC4pAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 625EE60C08;
        Sat, 24 Apr 2021 17:05:01 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fix for 5.12 final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210424082110.1773621-1-pbonzini@redhat.com>
References: <20210424082110.1773621-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210424082110.1773621-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9c1a07442c95f6e64dc8de099e9f35ea73db7852
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a1d7946fa53cea2083e5981ff55a8176ab2be6b
Message-Id: <161928390133.22892.9483160838961158456.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Apr 2021 17:05:01 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 24 Apr 2021 04:21:10 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a1d7946fa53cea2083e5981ff55a8176ab2be6b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
