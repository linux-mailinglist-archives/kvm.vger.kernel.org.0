Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBF53B03F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiFAVxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiFAVxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C5318B11;
        Wed,  1 Jun 2022 14:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 335676123E;
        Wed,  1 Jun 2022 21:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 994D5C385A5;
        Wed,  1 Jun 2022 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654120383;
        bh=VBrz3puA8qiyKjjOmVr0zveL0DfoJYY+7reDC2rlSbs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=k8VV3eV4eY7sapqWdH2+Up8hbtRoWL8lLsoxasSe3G+MIBA9TDY7pPam/ONoijmi9
         2hbO4s2l+njQRtjrMn2X2sBKButxsD8mL42KT4UZKcR1RN7l5OtzQt7KrtWLG/OEjt
         J1DbD7Rxbn/JV+KKw7EpuFRcQcY3+RzbsC+uIW5ke0XhX4H53TP212SaRs8NiFQpZ1
         hoHq7Y+uMHZkbY1Gg6M4sr6jj9rv/coHM9cXWP3wNl/THINQ/NorHATQrtft/uCcaD
         dBCnFBa6l+8bB2r4N3C6cdb5jOaHcb0cagInEliQR/iiB7JiimwE+S3iD+CrK+TKFJ
         BXYnw4Kusju6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88CC5EAC081;
        Wed,  1 Jun 2022 21:53:03 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.19-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220601111128.7bf85da0.alex.williamson@redhat.com>
References: <20220601111128.7bf85da0.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220601111128.7bf85da0.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v5.19-rc1
X-PR-Tracked-Commit-Id: 421cfe6596f6cb316991c02bf30a93bd81092853
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 176882156ae6d63a81fe7f01ea6fe65ab6b52105
Message-Id: <165412038355.5556.16078386325749571594.pr-tracker-bot@kernel.org>
Date:   Wed, 01 Jun 2022 21:53:03 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 1 Jun 2022 11:11:28 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v5.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/176882156ae6d63a81fe7f01ea6fe65ab6b52105

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
