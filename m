Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46E6786F3
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjAWT6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjAWT6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:58:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3C432505;
        Mon, 23 Jan 2023 11:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 973B060FD8;
        Mon, 23 Jan 2023 19:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C1D2C433EF;
        Mon, 23 Jan 2023 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674503925;
        bh=AAF8vqduN9r6er5Jnk3ja4V5zR/H1+V+84d1nawYhRo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BrX5NR34FE8HXOdk5tYmCZUrbbp8oxIwxKMQ79K29Kqt5H1dsPW5K7arWnJCU5avH
         /Zzll+TV9fEyYBtRm+ZKvYONYXhRFh6B/UE52bUbkO9ORlq4mVCy4CCJNkkgr0tCvY
         pbDRMzdxvpQidnGkUwhBGwGKk2QLbUaijQUpVlfn13KcNikptbCNKAdDQasjcw+fia
         bdRym18iyzg8wLUWJFLPzO2H3XL6+lQvaPaqn9e0oIa5VGojT6pUzszPV4iWSfejXV
         R3fzQtZU59TDBE/TWF10aeZg73VT/EMilsV7U763meOXcaWkUAUTVRM0x5p9vtAmkS
         LlnO+b39hWgfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE42AC395CA;
        Mon, 23 Jan 2023 19:58:44 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.2-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230123112053.173232a7.alex.williamson@redhat.com>
References: <20230123112053.173232a7.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230123112053.173232a7.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc6
X-PR-Tracked-Commit-Id: 51cdc8bc120ef6e42f6fb758341f5d91bc955952
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7bf70dbb18820b37406fdfa2aaf14c2f5c71a11a
Message-Id: <167450392496.2179.7857137175357428126.pr-tracker-bot@kernel.org>
Date:   Mon, 23 Jan 2023 19:58:44 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 23 Jan 2023 11:20:53 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7bf70dbb18820b37406fdfa2aaf14c2f5c71a11a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
