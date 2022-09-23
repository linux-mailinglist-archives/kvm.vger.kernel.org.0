Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4659B5E7FB3
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 18:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiIWQ0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 12:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiIWQ0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 12:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D47111F13D;
        Fri, 23 Sep 2022 09:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E98A6288A;
        Fri, 23 Sep 2022 16:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82296C4347C;
        Fri, 23 Sep 2022 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663950358;
        bh=9+YQtnvOnt7N7KSCcZOefctn+rATtqA0KYLx5GG8Jv8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ib0OUCEbIYQ60d/jh7nfaYLWG19g1ZgSHtRq+YAxya5TM/wxAxl8LzS9ORImzvy8B
         s6dnyZEgI3lVihMl72PNNXBMpTZwRswDJWSgputckEKw7mZk2krm45zUBZJnptih1H
         vgEkszVsdrrldRtc5uGJvB2J0Vwx8311IglFfEHi+xsHzsnFM64wL6vy+tNIFrPPDq
         EfRAaHIMPROVnUU5QDMMgSwgHtf5hz/WJrKTFIzvLKu75qKT36BFWNfp9BWyqf0+iC
         lQAnAUOu7PB9nQB2ri++KduQWX6NXaWK/GuiV+D0UjwOVwvbklrZhxoBn90Svjq0KQ
         7glTUHzjGNIJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67476E4D03F;
        Fri, 23 Sep 2022 16:25:58 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.0-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220923141312.96688-1-pbonzini@redhat.com>
References: <20220923141312.96688-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220923141312.96688-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 69604fe76e58c9d195e48b41d019b07fc27ce9d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 317fab7ec55d5a150bce46f37efbc942013a8c5b
Message-Id: <166395035841.8411.10313157287059885272.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Sep 2022 16:25:58 +0000
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

The pull request you sent on Fri, 23 Sep 2022 10:13:12 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/317fab7ec55d5a150bce46f37efbc942013a8c5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
