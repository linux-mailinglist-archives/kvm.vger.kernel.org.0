Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD97878E526
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 05:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346053AbjHaDuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 23:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345950AbjHaDuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 23:50:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45146CF7;
        Wed, 30 Aug 2023 20:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BE6B82172;
        Thu, 31 Aug 2023 03:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B35C2C433C7;
        Thu, 31 Aug 2023 03:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693453827;
        bh=pHR1QOLKMhaP1Sh2f3haCZ+iUBUcmBwcpVk2txRtkv8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AuVrUxYdurQyESsLV4XBU5od9FWd/OexnpzdbC/KM80brLXcZM1U8kkovOCEfFj3+
         PndUphXxko7dvi/+kRjzikbEPPODLyLMHzRX/t+vhRvf4J0uzjtaKbfMFYVR/q6fH4
         FmpNNjHVACI8bqhqtCSby5jrDaJpfqUUQJdYd4iVck5mTLc6+xmetmhppPgUbwtAZ4
         R/doUdgiRbLjlKCSHeTs3NIJQXXHbg4ovI+bPvWl2qZjeyRW0K2jpVitkbFShOOKeb
         8LR9/YdnStfsomKCYYOmql4nxCXt9Epz37MUwFMKdcN/SZ8sr6I7b0MZhzK9KXqBHO
         sQ2tAL1KdbGpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AFB9C595D2;
        Thu, 31 Aug 2023 03:50:27 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.6-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230830161456.646826da.alex.williamson@redhat.com>
References: <20230830161456.646826da.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230830161456.646826da.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc1
X-PR-Tracked-Commit-Id: 642265e22ecc7fe05c49cb8e1e0000a049df9857
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec0e2dc81072300acbda5deca2e02f98485eafa9
Message-Id: <169345382762.18053.15354969827316922022.pr-tracker-bot@kernel.org>
Date:   Thu, 31 Aug 2023 03:50:27 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 30 Aug 2023 16:14:56 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec0e2dc81072300acbda5deca2e02f98485eafa9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
