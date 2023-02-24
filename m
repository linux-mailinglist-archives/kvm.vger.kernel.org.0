Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F946A2507
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 00:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjBXX1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 18:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBXX1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 18:27:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E17679A9;
        Fri, 24 Feb 2023 15:27:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 368FDB81D64;
        Fri, 24 Feb 2023 23:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECB58C4339C;
        Fri, 24 Feb 2023 23:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677281244;
        bh=n645UGmCRsD8B402VG8f29+Unah6hw5bUNA0zxb8/b4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TMybbokhW3YmBW4bGh6B5V4TzoROIVXT9h4ZKEtHUy37yLjnFH/IOZjqwfYRZ5J6Y
         v06lgQu/MPN3pKTRhKVK3Hq24rU4q4baW2PqJYfXkO+JAdYm6msPdj5nCfe3MaWEks
         W5GXz1yFrd9dGxWg5+EMfzZ24oqmn/7gTB2y2cL5aatcamXf5lqgBG7Prvjy2WsNc0
         FcugA9eDZpF7hkMPFOmsmwrpVq+4F6jK1uqpktmzfbsFQmnA6e7gMMltdScual/An3
         mcdipK1KJXdW6175oqGNexZ5BMpkpXNLSsQvrMcYB11DStO55A2qrljVkX9bT9Z9+N
         +oyWC4kgbeAlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBD75C43151;
        Fri, 24 Feb 2023 23:27:23 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y/Tlx8j3i17n5bzL@nvidia.com>
References: <Y/Tlx8j3i17n5bzL@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y/Tlx8j3i17n5bzL@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 939204e4df962982cbc84acc26b29b421dd530a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 143c7bc6496c886ce5db2a2f9cec580494690170
Message-Id: <167728124389.28021.2369650643044234170.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Feb 2023 23:27:23 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 21 Feb 2023 11:39:51 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/143c7bc6496c886ce5db2a2f9cec580494690170

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
