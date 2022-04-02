Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E924F0604
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344032AbiDBUC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 16:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349333AbiDBUCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 16:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77853E0ED;
        Sat,  2 Apr 2022 13:00:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1106C60DD7;
        Sat,  2 Apr 2022 20:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 721D2C340EC;
        Sat,  2 Apr 2022 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648929657;
        bh=9ZDAfV1trtRZw9mVQsd8cLLmHdQx99aE1x254gKpHOk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DFS1oYbKKOR1yLDiu0wD65iZbvUzBCJqf8SLX3tPRRzIoMt3P3ipWKGdnBMQP+iei
         AVagjPPNypb4IoqxqCeo+jSIfbQO2LW0iFgsFa4OMNV0fbpniaoXQfFCpYIUdC1LBg
         lscSCyi5/6JapOhSpXBf4PXTWGjX8mJFdpnHmDN3gUedgHVUEmcROUYfpdW8m7//R/
         hDkfQFMYGjv5qg9z8ly7NT30ZhW+uaLWD+7iH6p/CWNprAdH8uILUC1o7AkpZS/k0e
         ZrJq0fvW/YK8kHsAtW/qwpuyJ+MB0WATQUJiiL59Ln6EargFD+U30xJT3LFg+rRo85
         X/2m8dMoNxJiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61023EAC09B;
        Sat,  2 Apr 2022 20:00:57 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes and docs for Linux 5.18 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220402100139.207620-1-pbonzini@redhat.com>
References: <20220402100139.207620-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220402100139.207620-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c15e0ae42c8e5a61e9aca8aac920517cf7b3e94e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 38904911e86495d4690f8d805720b90e65426c71
Message-Id: <164892965739.29522.9269464782497472580.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Apr 2022 20:00:57 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat,  2 Apr 2022 06:01:39 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/38904911e86495d4690f8d805720b90e65426c71

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
