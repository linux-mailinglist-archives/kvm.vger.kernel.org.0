Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBE86DA02C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbjDFSqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 14:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240306AbjDFSqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 14:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5577E7A9D;
        Thu,  6 Apr 2023 11:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAB42649E1;
        Thu,  6 Apr 2023 18:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C893C4339E;
        Thu,  6 Apr 2023 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680806770;
        bh=4dxODKZZfoqLpUA1ABZqmTsHHOW/ReH/5zsWDpM5nII=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mUK0Mg82n2nw8B9AyQjFSJKlNci+g/KxwEFIPaUfFSoWSv5NPIg0VybCsNm0gcoJu
         ASSCwPvGyWRndenNPJFgm3hnCagIU9d0EPo4jyVUeRh8oRPeJZHMJXC9VNu8BwpkzQ
         d6O1+o6AEwT9Pxy262kbxZkr3UEBYc0WKyXZcI9E5EF9Gm8iS8qZ5IQm7Y5d30wDPl
         +dEhE8h8Xv6USOmfN4K6NxsJA4ObjfrihAR682io4OrzZ/Fgn9kS0sjrSqTRbSZhdp
         nLkDPP57oF4vwUu6XtQC+blHSf1IZMJ5yiZeeoC5GqNTZ0JPSR9YFiM0++r++FQup5
         XwjdYOI/2SZfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32D26E4F153;
        Thu,  6 Apr 2023 18:46:10 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZC7Kb3WmjvooWtLE@nvidia.com>
References: <ZC7Kb3WmjvooWtLE@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZC7Kb3WmjvooWtLE@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 13a0d1ae7ee6b438f5537711a8c60cba00554943
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 105b64c83872c39d86c1e3dea9ee4185c62114dc
Message-Id: <168080677020.24406.5130803914063115504.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Apr 2023 18:46:10 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 6 Apr 2023 10:34:39 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/105b64c83872c39d86c1e3dea9ee4185c62114dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
