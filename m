Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3EB74336E
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 06:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjF3EQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 00:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjF3EQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 00:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EE42102;
        Thu, 29 Jun 2023 21:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB546169F;
        Fri, 30 Jun 2023 04:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22103C433C9;
        Fri, 30 Jun 2023 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688098610;
        bh=bpYbLvucEyJ32hINQQAQ1CbkrNPXOnYsO/mnvxbBwgU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pRrInoFre+XhTKOgxiBi03JEdDp+Tnh12rKVLC6Csk3NyAwIN6So9WbxEt1V4WFp2
         66EehYbIgUXUN6wjXXYhPp9lHgquFRrSh0+QBtkMpYlGe6bxdif3AAAZYSSdFvbO0y
         UG9HFJjmm7QVTt6mmIz7OtpQnAtFWVLwV+zuu0ACdJc0D1kw9+NZkrOQz9t3AXowKW
         c0wIQdl1zsTbhflUln8DKzX1gNEXdbc4SzPKKkztBrz1Lba6zHM2eOHGzNuvhcRjhC
         QqSOX/q1clXzoX7mBEl5n25p6/UcBd1TwcmbG6fZKXXbjPntKLQ7Ftb9SQaAg2fpnL
         G9SeqYFn6X4WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F2CFC6445A;
        Fri, 30 Jun 2023 04:16:50 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZJw95Knh/UEL6vQh@nvidia.com>
References: <ZJw95Knh/UEL6vQh@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZJw95Knh/UEL6vQh@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: dbe245cdf5189e88d680379ed13901356628b650
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 31929ae00890d921618b0b449722dcdf4a4416cc
Message-Id: <168809861005.23778.16859013806626555298.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Jun 2023 04:16:50 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 28 Jun 2023 11:04:20 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/31929ae00890d921618b0b449722dcdf4a4416cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
