Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478306A2B94
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 20:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjBYT6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 14:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBYT6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 14:58:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B8C61B4;
        Sat, 25 Feb 2023 11:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A0460B07;
        Sat, 25 Feb 2023 19:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8544EC433EF;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677355091;
        bh=K0XtR4wi5ICONj1dHwdenZuAiMXNTKQWyrzXEltUtdM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KBKi0H/wpO9DPcTserpTPQTDBjSOg+XRBPJ/cv2oShHPBsBX5XFz5OPtn6hqXqyxY
         MH0OyRXQ8uQhr2YRgpkBaNhH1QvMg5aNKIJlAQmhcJQzhd3d5Lk4j8LPG5GbLYj32b
         mXRB7dDbWcRZHvAH/Jhf9SDiA7Wy4TtPgGBVuOhgY0ybXAyVKktDvZGWeL0g1EOKux
         MSxN6VGuKMjtWhd7cQiG1TwfHZPMuexvPa08c91APoHVq0DMyqusLnVevGRoaqWuD+
         b7yVGSglFFHJAaVCltDUtZeTPvFMDW/8KmKtnEGaymzMAfi+tqU+80fGwsifG41BvB
         gew62r+X1ASQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 749F3E68D26;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.3-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230224131232.113c5eef.alex.williamson@redhat.com>
References: <20230224131232.113c5eef.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230224131232.113c5eef.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.3-rc1
X-PR-Tracked-Commit-Id: d649c34cb916b015fdcb487e51409fcc5caeca8d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cac85e4616b1cf4a90844b952b49b9cbc4562530
Message-Id: <167735509147.12970.5261956797520925686.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Feb 2023 19:58:11 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 24 Feb 2023 13:12:32 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cac85e4616b1cf4a90844b952b49b9cbc4562530

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
