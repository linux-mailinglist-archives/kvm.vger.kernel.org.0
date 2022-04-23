Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACF150C5FC
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 03:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiDWBXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 21:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiDWBXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 21:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE25D5DB;
        Fri, 22 Apr 2022 18:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BF76121B;
        Sat, 23 Apr 2022 01:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B402C385A4;
        Sat, 23 Apr 2022 01:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650676845;
        bh=ZZarClVFfMgX6Og7MsvLi8AgktkGufmRzE3Jw9a/F0k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bbuzhcc/1KZ2cjYEEJE1tgllVev3HulIm7ID6/qfY2MgZSuRCLkGMDXHKo19MvTH6
         7lmJDw5D7eyydOw9C7OODMVmtxrZ9GS/CsuCge00dtfR5FL5FXN0s7FQFHDOpOzxqN
         wkfaCh3okyqZeL3cknKfbHjUj81Ub6JBqMiYpGvzjvcqp2m8yaJ4tO78aH5WP7Krt1
         4KHkPhI6dTaYDBnZTEJBwHtL+Qhcb6uqCpuTIShnWeZWethZ+oMR3u6NTYvRu7NmCL
         F1mXSXhdYgm1jUf8B9PJ/G7Fl43ybE2P/t/ZhJPwAs11ojPRRFqsPyWCY2TMA41R40
         XKs5RItQN+Jlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27F76E6D402;
        Sat, 23 Apr 2022 01:20:45 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.18-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220422165655.1665574-1-pbonzini@redhat.com>
References: <20220422165655.1665574-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220422165655.1665574-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e852be8b148e117e25be1c98cf72ee489b05919e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bb4ce2c65881a2b9bdcd384f54a260a12a89dd91
Message-Id: <165067684515.21969.7535247569900677190.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Apr 2022 01:20:45 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 22 Apr 2022 12:56:55 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bb4ce2c65881a2b9bdcd384f54a260a12a89dd91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
