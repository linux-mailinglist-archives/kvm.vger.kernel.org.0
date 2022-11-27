Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83F8639BE9
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiK0ROy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 12:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiK0ROt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 12:14:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568C8DFFA;
        Sun, 27 Nov 2022 09:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D183CE0B18;
        Sun, 27 Nov 2022 17:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC5C4C433C1;
        Sun, 27 Nov 2022 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669569284;
        bh=l2DtAB8VfKuZAahZWvUEliq5f2hTUDHhY+gOnbUzeis=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OwFNPwPwGtWkzyYvJuqvKjT7yaYy049rlNVNnO7vjFM7NSDYChNzKj7dXu1iCRwuu
         DvE62xfXRgJxyJ71j/3435bLLd8h4mPsE3H6UelXXwtE59CAvQUpEbepBNGgR00m8x
         5y23H3rtmZFLA0e9KZyWM5dOlaXOU3Zh8BrAyKJwQGSXWyUdyZRnyStSlAVlHqJgBB
         B41fe63IEioQi2EauhF1iA3ekT3phsJ2fnxxTzYNvSTvHQoZkXcjMCq2KLuwdndwCR
         LsMiHaNXU3+a3/Qb08fXIShwMA0k61G9RYi6LqF1sZaW+eQL80wZRPjadRNgBkhd2W
         iPIVrlELMCptg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA5C6C395EC;
        Sun, 27 Nov 2022 17:14:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.1-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221127085316.452610-1-pbonzini@redhat.com>
References: <20221127085316.452610-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221127085316.452610-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: fe08e36be9ecbf6b38714a77c97b1d25b7a6e4b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf82d38c91f857083f2d1b9770fa3df55db2ca3b
Message-Id: <166956928475.3809.5518377189221714905.pr-tracker-bot@kernel.org>
Date:   Sun, 27 Nov 2022 17:14:44 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 27 Nov 2022 03:53:16 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf82d38c91f857083f2d1b9770fa3df55db2ca3b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
