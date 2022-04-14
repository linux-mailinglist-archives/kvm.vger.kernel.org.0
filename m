Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA406501F05
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 01:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347594AbiDNX2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 19:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347587AbiDNX2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 19:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3653CFDB;
        Thu, 14 Apr 2022 16:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A38D620D5;
        Thu, 14 Apr 2022 23:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA95CC385A9;
        Thu, 14 Apr 2022 23:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649978754;
        bh=zCfxcaRKoFJHWVQPutdkyzJ7/AOB+K/yTZRWSCLPDXY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Vbakdzeue84IyHgncZpiSmGiiq/MOxYCHTgRypMIqsBHDynObgslfffZrU7tRz1hj
         D4lkh/j816Ihx9G1hRvuiu/pMcqBB4KuOhobsx10rlBxHylnJPESGCT1rSx7UdvipR
         6TbmLeIIK0jRgcdLNIknaXgt9q9ncwpPwP+vzhl5NJ18frZFnnEUeo9IFzWdMk0xX0
         0yY6hToxDYlf5p6Lg8Q3CPbH0A9FFQHc1DXwrav2C3a0g69uqmexlfgUsJecQVOT5L
         9jb7OSrTW83MeQzSv0vP9hfsbrlLXakTXGHZVYvL0YQVYBXduFtFVXa82OWoZcys98
         W0KOUtpeDUqHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4F2EE85D15;
        Thu, 14 Apr 2022 23:25:54 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v5.18-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220414135801.306f33dd.alex.williamson@redhat.com>
References: <20220414135801.306f33dd.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220414135801.306f33dd.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc3
X-PR-Tracked-Commit-Id: 1ef3342a934e235aca72b4bcc0d6854d80a65077
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 38a5e3fb17e542dd86078eeb43029bf8f146a884
Message-Id: <164997875473.7927.16024281469221412808.pr-tracker-bot@kernel.org>
Date:   Thu, 14 Apr 2022 23:25:54 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 14 Apr 2022 13:58:01 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/38a5e3fb17e542dd86078eeb43029bf8f146a884

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
