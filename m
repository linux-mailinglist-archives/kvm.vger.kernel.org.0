Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3405B4E6969
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 20:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353292AbiCXTp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 15:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353271AbiCXTpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 15:45:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504663A71A;
        Thu, 24 Mar 2022 12:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E16C061B95;
        Thu, 24 Mar 2022 19:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D274C340F3;
        Thu, 24 Mar 2022 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648151060;
        bh=/3PjWgXpOaZV7R2SxiFLWIzkzoSjIJIdQd1au8GnmLw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hRClB6H0rPlhtz/wp7MePk2X0GKFOqlqgQoEEvHxtu4imiknXGa28NkyZfZBpEaON
         Ir3MxYayoRF+MDMvtNgjE8u3sa66sLk5iigCRHthjWrWA3SLJ46flRx/ALMdokXf5O
         nuMNjjxtr8tLdQxCcXRXewxpJA7T5OOEHau1Py+wEVJqSljdjqxnjPpL3ZP6A9CPxS
         r3BgSzsEVjZ/rf08PEPoxibakgezCaAfIVxBvIjG2Lz7O9l2qTPVg6brAkm9XIXuWu
         4SZ0uCY5oYoLj3nBfS2cBK5ORQpfoIvyp6/N+w+EV53cYUtO3BjHTrxgm2TWpbk8DP
         xvLu6tu0xQ/iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3979EE7BB0B;
        Thu, 24 Mar 2022 19:44:20 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220322132057.5cf2a4a1.alex.williamson@redhat.com>
References: <20220322132057.5cf2a4a1.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220322132057.5cf2a4a1.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc1
X-PR-Tracked-Commit-Id: f621eb13facb7681a79f4fec8ec6553ae160da76
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7403e6d8263937dea206dd201fed1ceed190ca18
Message-Id: <164815106023.31218.4569835096848370408.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Mar 2022 19:44:20 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 22 Mar 2022 13:20:57 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7403e6d8263937dea206dd201fed1ceed190ca18

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
