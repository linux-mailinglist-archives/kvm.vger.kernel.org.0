Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3414F7444D7
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjF3WaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 18:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjF3WaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 18:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6724489;
        Fri, 30 Jun 2023 15:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE21A61831;
        Fri, 30 Jun 2023 22:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FED0C433CA;
        Fri, 30 Jun 2023 22:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688164189;
        bh=eNGz5uV6SVOSrtLtVF2bhDRU6Kns2q1uJO4r8gzTOC4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VeFISMVY/Mp9M2TrnKKkcAe8E+zBnT7rJ2I6PbQcjoB1eJenS0tu8j5fE/KL8UIl3
         gNGEPRvke2RXbmdQ9CI3ueck/kL+iWLcFjpPrHQhFpqAzUG8nkf5zHcQW9Es2F0bI6
         CN3HzYHsMesNwu6/uApNPUnpmVOG+Ed+nBvdCdW5H1lTaz5E1Kz5m4f5/QqF7vUhYA
         KyreP6XmbGpRcIe/rHb3KjSeZeme41KFaHLEgE1UxZL/VFpt2Sr6WL8Op+bDRHsGwA
         /cFssrA4cvE4iZegHyqXY7ueY9hVGwiZoPdIZ+0wATQ5kYgINNgsxsCYd7rNGN+V0w
         qLjhrT6fKK+UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3003AC39563;
        Fri, 30 Jun 2023 22:29:49 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.5-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230629144949.07e6cd78.alex.williamson@redhat.com>
References: <20230629144949.07e6cd78.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230629144949.07e6cd78.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.5-rc1
X-PR-Tracked-Commit-Id: ff598081e5b9d0bdd6874bfe340811bbb75b35e4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b25f62ccb490680a8cee755ac4528909395e0711
Message-Id: <168816418919.26572.14874927329691358838.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Jun 2023 22:29:49 +0000
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

The pull request you sent on Thu, 29 Jun 2023 14:49:49 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.5-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b25f62ccb490680a8cee755ac4528909395e0711

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
