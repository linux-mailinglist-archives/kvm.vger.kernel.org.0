Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB6C5FBF70
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 05:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJLDNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 23:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJLDNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 23:13:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D7CA878F;
        Tue, 11 Oct 2022 20:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F41E6134C;
        Wed, 12 Oct 2022 03:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83DF9C433C1;
        Wed, 12 Oct 2022 03:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665544398;
        bh=CICsZCGS6pK7U0z+gVzQaFZvKfpUi8t/bNunxjoKwrA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qx2KXw5Hobs3unDINoM2y1ChTsx1sFOkW7BvRSoL3ZwWlQ3khxzuT/jLdc+WiUKZG
         z9Tc8sY05C5wn3tdH3Q3+6BKJ1I3/Jb6ztgWccZTJ7li8/9IGCq2E3Dsuo1ggcmEDu
         IkvHV7z2Vw3dRmEUjxKYB38uwDt82gujO2kHImFCDtnb28ME1RvXpOo7gY/lPRNu40
         UsF0rQwLRRsdZ0Ou16BCVWgI1jEHJOZWBkT6W1GJEBd0bBqh8CpSTc0jyo2g0i4VSF
         M6n3YVoIiPa7ibW5t7esNp7znw1ZlBl3qTTTkQEverFuaEgnTxfzFtPyqMrVltlO8+
         pmgyQro2sPN6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 710ACE4D00C;
        Wed, 12 Oct 2022 03:13:18 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221011134757.1074225-1-pbonzini@redhat.com>
References: <20221011134757.1074225-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221011134757.1074225-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e18d6152ff0f41b7f01f9817372022df04e0d354
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f311d498be8f1aa49d5cfca0b18d6db4f77845b7
Message-Id: <166554439845.11405.8600988894809522074.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Oct 2022 03:13:18 +0000
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

The pull request you sent on Tue, 11 Oct 2022 09:47:57 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f311d498be8f1aa49d5cfca0b18d6db4f77845b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
