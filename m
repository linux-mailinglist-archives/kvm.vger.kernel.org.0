Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803DB615251
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKATcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiKATcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:32:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E62013EA5;
        Tue,  1 Nov 2022 12:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1D8761720;
        Tue,  1 Nov 2022 19:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2240CC433C1;
        Tue,  1 Nov 2022 19:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667331131;
        bh=fXkw+blh829pKLcuanHKOMdwQD+YyC+ODBCeAxf7M+Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=kEwHjXGv3Gb8emQ2hHhgSaAwvYeVTmXFvhbaRcS8fPk4Hfh6PYXIunqBfBVMtILr0
         uvj7jqjlM7tQ1i7U8A0lI58iFa54yJf4aM1uA6QA+kkN8O+1EOR8KoIUYbC1mzHqsZ
         P7cB33z+LvzE+WNudt8tDzNOiBlEtWps3V2kLd65iN9x5ERLBvGtNN75jhI7yyM979
         T9Ps7tepn2eSTFUQ0HxjBiwgbWTaH9F0yjjBeE/5oFj0W2Ckgy0ntJdez73leI/Sdi
         ZdZRPgEw1a+BHm3ybUkJ5za1PK8VqeCr3AEA6GlBXVhIs+ca6gd5d5UB1X9VIEnf/t
         6WEzYEgggTThQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11B5CE270D3;
        Tue,  1 Nov 2022 19:32:11 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.1-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221101142431.3635848-1-pbonzini@redhat.com>
References: <20221101142431.3635848-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221101142431.3635848-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 7353633814f6e5b4899fb9ee1483709d6bb0e1cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f526d6a82242f7ee72d2a4448eb492622cb7d556
Message-Id: <166733113106.6375.544525777995477337.pr-tracker-bot@kernel.org>
Date:   Tue, 01 Nov 2022 19:32:11 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  1 Nov 2022 10:24:31 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f526d6a82242f7ee72d2a4448eb492622cb7d556

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
