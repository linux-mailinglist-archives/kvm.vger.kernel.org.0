Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01446F36BF
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjEAT1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 15:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbjEAT1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 15:27:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C3826BD;
        Mon,  1 May 2023 12:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B4FA61EA8;
        Mon,  1 May 2023 19:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8049EC4339B;
        Mon,  1 May 2023 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682969160;
        bh=MdkUJCmXW8bUqrS3ZfvMl0ToQgVMS6T0xzhWQS20ENI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=r+CIk4ssNNhCsu4kpc4AA78jeomTKqh7gLs+KKcTq+zl784WymyE+MxrnAoCPvsT7
         882REqJ12v4rdyhWzEPUQeMZIlTgQM8/QbBjto2RfgTE325Kci5ioE2wyhXOVARPOa
         Gd5Dq+K9xYKFuM/WgKoAJqO+cdiGiHjPSbINzqSgJGA3oJ/fdiuKj83GqM7rUsZ3f1
         w0RmE6QNUHKnxwCM1gtO9Gw/rqZan8nXceL30ISQlz4yxbfsKdvw4dTWNcuKLKlaaG
         nnT9GZdw6ajud71JJFP9fYK2rKxrvtUiDSxH1pccTjKnnoyrK4KJ/ll14OLm0ukGTS
         CYlt+uRPKuETA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70BF4C395C8;
        Mon,  1 May 2023 19:26:00 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230501085326.2997739-1-pbonzini@redhat.com>
References: <20230501085326.2997739-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230501085326.2997739-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: b3c98052d46948a8d65d2778c7f306ff38366aac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c8c655c34e33544aec9d64b660872ab33c29b5f1
Message-Id: <168296916045.17937.2530630314981788230.pr-tracker-bot@kernel.org>
Date:   Mon, 01 May 2023 19:26:00 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon,  1 May 2023 04:53:26 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c8c655c34e33544aec9d64b660872ab33c29b5f1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
