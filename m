Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315B0609711
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 00:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJWWjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 18:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJWWjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 18:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668E712AD9;
        Sun, 23 Oct 2022 15:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA77E60F04;
        Sun, 23 Oct 2022 22:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AEC6C433D7;
        Sun, 23 Oct 2022 22:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666564777;
        bh=m5oRIXnhkNxVKNWVXq3RUP0v/9Lr2ucn11DVzo12OP0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SWaKspz9iL4yBj1cqgLxqI0B8cnIXuzre2y/1ZdDpu6e9DbgTrQ8BXP07BARrr9To
         FEll98iLqDDln3Rvl1jrrVhKjZs9yd7yRz9bqDEq6rTHvFKdYqz8Hg60YPrDmDxO+0
         qf6FXAXwcetl9XM1wPYztpB4WeQPM3Otj5gBwnoi1tD9sze+noT2QmXpItVApJZV5L
         gXpZrxA3HuT2nrEKnD0HT5BHFC3/VnQO7CrVu1+7JGlSQA3tef2Cfu2eisHpZ/hlh7
         RoS/C3SxSDOAIwPnD4LuFQ7laKYbEQS/wzzoEbo+V3q0qRQ2NbIO5p7Se+YyLclVST
         WW62OFN8aYr2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E061E270DF;
        Sun, 23 Oct 2022 22:39:37 +0000 (UTC)
Subject: Re: [GIT PULL] KVM patches for Linux 6.1-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221023174307.1868939-1-pbonzini@redhat.com>
References: <20221023174307.1868939-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221023174307.1868939-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9aec606c1609a5da177b579475a73f6c948e034a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05b4ebd2c7cbb3671c376754b37b4963dd08a3a2
Message-Id: <166656477709.18953.3124354710980701686.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Oct 2022 22:39:37 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun, 23 Oct 2022 13:43:07 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05b4ebd2c7cbb3671c376754b37b4963dd08a3a2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
