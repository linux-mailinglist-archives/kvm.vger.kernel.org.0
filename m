Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09166F0A95
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244428AbjD0RP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244354AbjD0RP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F924233;
        Thu, 27 Apr 2023 10:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9186063DCB;
        Thu, 27 Apr 2023 17:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F24A2C433EF;
        Thu, 27 Apr 2023 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682615755;
        bh=gxT200bgMB6m7bWF4ZvtMHioGWzVMky8bhjC9K/zaXo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PtpCta0xVi0HIIrdsHN7Mc/A5jkVpVcyGMIpp0zmHW8X5pq/axpxl3gHfqX02Z+Fn
         ajuuLQyoI0fn/n3x7/qGXR7pdpyz+8YMeuTbkT3KcVGxJ/boT978N9wNDcouC2J361
         GhvEN+kRDy59bEaKNacjF59vxFuvjOD720QH4khg5CzFGyJkxWTUp/cO65CpHPZnAj
         oA7Ppvk0bi7s9ab4JU9iVEsgS6cJXZ5s+w4Xz3PKxp2AJCkRVXNfdQWo7ANWvYoYdl
         FO6BdWa3xSOMMz2tu81fg4XU2QNhibzbzVmqgNGhR1oZtW2P/AHhKAqYTEEe7VMvce
         a36PAZDGomzyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E21BAC43158;
        Thu, 27 Apr 2023 17:15:54 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZEfnucryav8vI+og@nvidia.com>
References: <ZEfnucryav8vI+og@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZEfnucryav8vI+og@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 62e37c86bf0718e1ec0156c7a88a43ced6cdf201
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6df969b77ecc2ba21dcd0e57f416e58bec2a5ca1
Message-Id: <168261575491.15936.15842307868271460868.pr-tracker-bot@kernel.org>
Date:   Thu, 27 Apr 2023 17:15:54 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 25 Apr 2023 11:46:17 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6df969b77ecc2ba21dcd0e57f416e58bec2a5ca1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
