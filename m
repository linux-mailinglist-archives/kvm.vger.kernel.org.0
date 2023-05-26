Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C487130B2
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbjEZXxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbjEZXxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E1910CE;
        Fri, 26 May 2023 16:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BB165485;
        Fri, 26 May 2023 23:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE53DC433D2;
        Fri, 26 May 2023 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685145095;
        bh=ohleGxeg0IQxuOcsdSSLEEUhu0hn8PzrLfUhhzMqn98=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZN2mC7TTrnMMJTIKTN9JmN9V2oSVy2QltP7ES/9Hvo9i3aoVa9nTk/gWugPl+ZF9B
         5JOWsQSrFJi0VjD9E9aJinj2bLk3Ivo3HG6L/sGvEgusYMwye3zdCl6QPMexW7Pas4
         ds5OW3CxOjbpjwePv7S7EHcgEVNBfsxYvWjievoL0TkixvU/Bn0o5uK7ox3E2k/Ae3
         Vmkj5bNd57k/dEAjLOGAtGB4jE9ZONqWvbCMuTWRi6nDsOo2Apu9PwSpUZ2IHrDvi0
         0WEiT93zogPX2Bnm2afa/tmH7IfbeV6A4Ynz6muSn8oNC+HxxFcekOwcDQ+Ym9Cxur
         sFmgaTk/l/S2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABC21C4166F;
        Fri, 26 May 2023 23:51:35 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v6.4-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230526141846.6f549439.alex.williamson@redhat.com>
References: <20230526141846.6f549439.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230526141846.6f549439.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc4
X-PR-Tracked-Commit-Id: 4752354af71043e6fd72ef5490ed6da39e6cab4a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8846af7547b52704cc50b76eecb5fe5a5128fda9
Message-Id: <168514509569.17241.13163039278546863023.pr-tracker-bot@kernel.org>
Date:   Fri, 26 May 2023 23:51:35 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 26 May 2023 14:18:46 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8846af7547b52704cc50b76eecb5fe5a5128fda9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
