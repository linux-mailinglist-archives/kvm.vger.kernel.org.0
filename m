Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4776A64CF18
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 19:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiLNSFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 13:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbiLNSF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 13:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5912630;
        Wed, 14 Dec 2022 10:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C91D7B818A6;
        Wed, 14 Dec 2022 18:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E6C2C433F0;
        Wed, 14 Dec 2022 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671041083;
        bh=av1MGpkBAVrOC3/H1ODRwPW9Zkps1Lgfe1vtqovQRA8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Kadt2vsiAcq7L3uiFtwnmay30cYJ9LNI33Qg72tILJPn+5T8Z+W8i72XEP1+fO05v
         ACXlVzcnYg1jpwaV2O1fYHFmxybU27YzjI7l7BpnSgYG9wnTMbwgRHrfuWXyc/9exo
         wQbJ7xamxn8DJdTZEP5W+iFJ0voCf5Em6YCFD49qIdmg9IFh6ckm6Lf7TSUNz0MGwx
         tmmCYRMO2iiwyAv6zCzePcTzMig6jHf8c5v/D4VvETj6EZnYEDzBUyXsdwl4VYMM4A
         mHvVBU5bOEXroVsmYfVJJ1nRZgx7bnrJqVIIQz4P4pHhRFQBHlZzle5DMvJigyyaHV
         EK5s40RXyOfNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D8C2E29F4D;
        Wed, 14 Dec 2022 18:04:43 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y5dzTU8dlmXTbzoJ@nvidia.com>
References: <Y5dzTU8dlmXTbzoJ@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y5dzTU8dlmXTbzoJ@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: d6c55c0a20e5059abdde81713ddf6324a946eb3c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 08cdc2157966c07d3f986a097ddaa74cee312751
Message-Id: <167104108351.17244.14344497629587467451.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Dec 2022 18:04:43 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 12 Dec 2022 14:30:37 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/08cdc2157966c07d3f986a097ddaa74cee312751

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
