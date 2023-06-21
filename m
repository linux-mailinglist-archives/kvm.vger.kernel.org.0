Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF51738E46
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 20:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjFUSND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 14:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjFUSNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 14:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2981716;
        Wed, 21 Jun 2023 11:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A42C76167D;
        Wed, 21 Jun 2023 18:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12CE9C433C8;
        Wed, 21 Jun 2023 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687371180;
        bh=JXqUTk3bAL7lIp/+McuHuC6bhVEpHHo5RmL3WoZgySM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Mpljp096lG/UOs983g+oL+GsTsdc4r3G+2alw0KJjQFaC1WpkF1tNF9oh8FXA+3iZ
         CbO+IfHWL1mWmqttHiY66eRDNTu6E/RcxNbQPwWvVlxAA6zqhf6xkBhxX3UafUWrZk
         BEdzZH4Ccfx7dAwaLx4LVc4yWNZdp8gwtnHMb/ne9DV0EFeD7X/o+3eGJR1u/9IeI0
         mDnc7M+cll5/W+erxd81Fm6AbXfN6GAHeUba6vvjmiRzhGmMa+F6GUXpX2EUJ24GHb
         Wcf40u1O7jeAyDsaQ8z/dPk6WbewiSmgCVrXb11r4rmqvgGXE4Gj4PBVeq+bPRwY5Y
         1ZpwP/63yiIsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF8B3C395C7;
        Wed, 21 Jun 2023 18:12:59 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute revert
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230621110431-mutt-send-email-mst@kernel.org>
References: <20230621110431-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230621110431-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: afd384f0dbea2229fd11159efb86a5b41051c4a9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 007034977130b49b618a5206aad54f634d9f169c
Message-Id: <168737117997.28078.10365893103159189763.pr-tracker-bot@kernel.org>
Date:   Wed, 21 Jun 2023 18:12:59 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edliaw@google.com, lkp@intel.com, martin.roberts@intel.com,
        mst@redhat.com, suwan.kim027@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 21 Jun 2023 11:04:31 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/007034977130b49b618a5206aad54f634d9f169c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
