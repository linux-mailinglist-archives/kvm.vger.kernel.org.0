Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7EC653ADD
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 04:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiLVDHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 22:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiLVDH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 22:07:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC4E02A;
        Wed, 21 Dec 2022 19:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8734F619CC;
        Thu, 22 Dec 2022 03:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6CEAC433F0;
        Thu, 22 Dec 2022 03:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671678447;
        bh=tdWCORj3BUqf8/nVAAszc86UGgLhHsa/Zx0NhKUGgQI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BrZj4uyLhrxk76FRe/34oeTGjCOy0VFWB2XVgjdVdfIz7PHLYK8MYR4b9jOzTr39T
         POOGoKUcinMB7t8jkPO1kVb5v7T2aT9uFRi96v+9cjR/U0cDEUsA/vyQkaCcsZtfj8
         7tOUq81yuqcKFcXPxOXk7TVhjyCgzdgW0HU6oTbFEK0sqlNhpprtp4tmgPN2olYJ8X
         mqr79uggS816a1QVHB/6dH7xCizfdoVr4kjDmXRD5uQyZw/KX85F5h3NiNluFUXYkv
         4yPUBQSIdpRdcIOZpwXqltr4yGN/+PK7JipU/Fjfz1uc0elfoYdw9MFZA2UT/iY6VK
         jCFopxOE23ETw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D67C4C395DF;
        Thu, 22 Dec 2022 03:07:27 +0000 (UTC)
Subject: Re: [GIT PULL] KVM/RISC-V changes for Linux 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221220145445.1221050-1-pbonzini@redhat.com>
References: <20221220145445.1221050-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221220145445.1221050-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6ebbdecff6ae00557a52539287b681641f4f0d33
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a5189c58b3cf250e6f50ede724409c31795d5f1
Message-Id: <167167844787.12654.6984031553573235350.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Dec 2022 03:07:27 +0000
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

The pull request you sent on Tue, 20 Dec 2022 09:54:45 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a5189c58b3cf250e6f50ede724409c31795d5f1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
