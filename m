Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2535C628AB7
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 21:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbiKNUqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 15:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiKNUqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 15:46:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C724312088;
        Mon, 14 Nov 2022 12:46:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E8F61462;
        Mon, 14 Nov 2022 20:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCCB7C433C1;
        Mon, 14 Nov 2022 20:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668458810;
        bh=X2mHCf+Q3ldFeCet6iqC0kk9fVee+YkuElaO2KDDo8w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bQtZqwLcSLVcdLVr1ZzxNQaZbUefqbCiSFC6aC2LpHOqv070RTxca9LU/ue6ZWeWW
         AywYvc3AU8kE5NzT13qq2ACyFFPOq2C5x/qmHeD0flVq/PUxtZjp7AzGs3q7GLRVmQ
         ieV3H9i4aDi6LVARxkBxmIurBQr54TqKnT2PYe7+CHydizftWRKNHRmbi7T+S721aX
         dLVgpeu77vSDrvThiAUPe86V71z2rzJmywdatzq6PgIvRG/+92Mm+YaFberbBD85zJ
         tkBtBpmCRfGMrJ708C8mu/h2Pvcjx4MRUIp06pZbWID8JcBgaKm2az03XCAQBuha9O
         sw+OS9pB5RsYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8B3EE270EF;
        Mon, 14 Nov 2022 20:46:50 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.1-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221114124217.784a2d3f.alex.williamson@redhat.com>
References: <20221114124217.784a2d3f.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221114124217.784a2d3f.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.1-rc6
X-PR-Tracked-Commit-Id: e806e223621e4f5105170df69d7311dc3fb4bbb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e01d50cbd6eece456843717a566a34e8b926cf0c
Message-Id: <166845881075.1688.1275038050189564935.pr-tracker-bot@kernel.org>
Date:   Mon, 14 Nov 2022 20:46:50 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, ajderossi@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 14 Nov 2022 12:42:17 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.1-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e01d50cbd6eece456843717a566a34e8b926cf0c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
