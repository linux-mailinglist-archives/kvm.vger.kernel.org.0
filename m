Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC458B791
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 20:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbiHFSTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 14:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbiHFSTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 14:19:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99157E0B1;
        Sat,  6 Aug 2022 11:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 364A66115D;
        Sat,  6 Aug 2022 18:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 956DFC433D6;
        Sat,  6 Aug 2022 18:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659809975;
        bh=rdERLhkZ0U8yjmd1+IlAWaqnj1NMxw/bD59Ezr+EmcA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=l5ksTqSOh+q9L7GoOHWfoybV+EIT8hqypVJbdxNtNdOMbQ/KMpK5pyuADBWkQtmO3
         atJ3JrxTsTVeQAkSQnJVi89JvmNIP1H88OTdwkHgJE+8LFnuAMEM6NQRE1ivnRHF4M
         AWAK8MqQQGj8eNIqVHqj12uTBiLHXLCZY7dm0IJrby34YOmy9rvwXxzv2OxqStCIBF
         GiFk2DQPMtJIzS1pmKsoMN8UwJWMpyhBGqvCCvb+cwbN6xyTApHlJhmXcAt+opa3Qf
         D0S+qdMzRE0tTdCy1Y7QsQ7HmK0cAMGCYfJNBjjd3uxbkGb9i/B+5WXKbpSZiva7Jw
         THNnryHnoJgkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84BD2C43142;
        Sat,  6 Aug 2022 18:19:35 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.0-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220803124423.7ad06882.alex.williamson@redhat.com>
References: <20220803124423.7ad06882.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220803124423.7ad06882.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1
X-PR-Tracked-Commit-Id: 099fd2c2020751737d9288f923d562e0e05977eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a9cf69d0e7f2051cca1c08ed9b34fe79da951ee9
Message-Id: <165980997553.27284.15279666621666822873.pr-tracker-bot@kernel.org>
Date:   Sat, 06 Aug 2022 18:19:35 +0000
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

The pull request you sent on Wed, 3 Aug 2022 12:44:23 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a9cf69d0e7f2051cca1c08ed9b34fe79da951ee9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
