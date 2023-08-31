Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F78778E528
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 05:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346060AbjHaDum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 23:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345955AbjHaDuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 23:50:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D82CFC;
        Wed, 30 Aug 2023 20:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 425C6B82179;
        Thu, 31 Aug 2023 03:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1414CC433C8;
        Thu, 31 Aug 2023 03:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693453828;
        bh=t3EE8gZClnitP93lMZaNUDvdu2WS6qWOWyQTFfsI4qU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=O3Ha+sz9dIMCNFbnTBwmLrw/KPsX0TcZNQnqc5bDVS/kADWwPOa/5YQO1lcgj6cYA
         pZ39400zoG6EcGzycnAHKvtBRsNYBHzSmq85jLqD9QA/swZQ1ONq0F5tJZA/U5fUQW
         I5TSMKjDDJtLxN03xb1CiFkpqIzBHTzPtlh24FZIZHbEOsWHAR/wgLiybLNkdgM+tw
         SAz5tkpNIV5qPSXIAqvFzOeJXrlRgDnpoiFAdwb9G0/ZaYY8pIggm1ImzNkNpBinX+
         FaMY1WsCG/N6RQEtTrZT8WsodcVsUT/b2E8Y8HdliFnEx0iTDWKnAnI5ogEOIFHT/8
         c4wlrw+GxFJow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 027CBC3274C;
        Thu, 31 Aug 2023 03:50:28 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZO/Te6LU1ENf58ZW@nvidia.com>
References: <ZO/Te6LU1ENf58ZW@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZO/Te6LU1ENf58ZW@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: eb501c2d96cfce6b42528e8321ea085ec605e790
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4debf77169ee459c46ec70e13dc503bc25efd7d2
Message-Id: <169345382800.18053.13760113364662858886.pr-tracker-bot@kernel.org>
Date:   Thu, 31 Aug 2023 03:50:28 +0000
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 30 Aug 2023 20:40:43 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4debf77169ee459c46ec70e13dc503bc25efd7d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
