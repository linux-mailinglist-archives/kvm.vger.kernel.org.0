Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4114449FFA4
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 18:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350559AbiA1RgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 12:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350378AbiA1RgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 12:36:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8E4C061747;
        Fri, 28 Jan 2022 09:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE51B82693;
        Fri, 28 Jan 2022 17:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E391DC340E6;
        Fri, 28 Jan 2022 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643391353;
        bh=Yz79Qm6Yh91Wg11rYV44FmGH5cq9wa7CHYyPzQZ+EAs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=RMeTCKgws5ANrXVSJFv5s5SPPnv9ZAytJwQmbBE4CfBtsShTmzAzwjyPed6itmGW3
         O2pp9ECNAC4W2Afj5utZq2QXPa0LrIjbwImsOcDTKTTrR+UULDoWOKbi88CA6pWXC3
         cMLHYw348NyI1OlB06RIMvSddAlhkRWI7cV6Ek6JcLOyUD6/LUcEUTUPPeyS/YcaoE
         JP73Rc0fmfy+QCWw81Sxas1VyMlVsGKdUiJCQMylT2ipCNvy+MvIC0aY16hjaThFA5
         /2shr3vuT6wSLbRe8mkdYrX25KUmzqA2d8+gjbZvZLCwOB8tv6OyP1wByEMIHvIkF8
         xWsoCyIC6i1Qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2FEFF6079F;
        Fri, 28 Jan 2022 17:35:53 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.17-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220128130019.4123266-1-pbonzini@redhat.com>
References: <20220128130019.4123266-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220128130019.4123266-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 17179d0068b20413de2355f84c75a93740257e20
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3cd7cd8a62e6f4b81e8429db7afcb11cc155ea3c
Message-Id: <164339135385.16649.2507165916091160487.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Jan 2022 17:35:53 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 28 Jan 2022 08:00:19 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3cd7cd8a62e6f4b81e8429db7afcb11cc155ea3c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
