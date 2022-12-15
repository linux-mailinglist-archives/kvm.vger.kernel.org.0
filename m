Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7147F64E2FA
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiLOVUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiLOVUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DAC5C0EF;
        Thu, 15 Dec 2022 13:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA8461DF3;
        Thu, 15 Dec 2022 21:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D17B9C433D2;
        Thu, 15 Dec 2022 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671139215;
        bh=GP7shHdk1ZTDNP6SobUegK31SbYKyc/TR/tgYY6unRA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=n2C1FIlw7w2qhL9JVQ0Zf3DlotraAbcUMhAYI5MOxOzy87RCCrpEAdLELZNKE98KD
         VzJZf+BprILlsOGCqeZgtDCLxxRDiYum2B43d4QR7OxXqqIbOYbMZhBWUB3881LoYC
         8w3Ydclmq+t/axcXl0Dt171tPvb/tV//uafVthtDlx0ap6j1kQVEAfWbFq8uG/MxNT
         KJQKFQ3bDkIfhrcd56yqnnx50SmV4GqigGF1i9uvLcuSMr9/OJvEwMMWQToApErxxI
         zN3C5luweYG315/BRWVD0Fg8y8+5kNr9hLO/uY647NsoCAM1aWbSrN6XkdHorMdw9C
         234UG6l2xy7kw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD7ADE4D028;
        Thu, 15 Dec 2022 21:20:15 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.2-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221215132415.07f82cda.alex.williamson@redhat.com>
References: <20221215132415.07f82cda.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221215132415.07f82cda.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc1
X-PR-Tracked-Commit-Id: 70be6f322860d322ebcd120cf0c05402ead5c6de
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 785d21ba2f447fb26df4b22f45653763beb767ea
Message-Id: <167113921567.15818.18296679987223463629.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Dec 2022 21:20:15 +0000
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

The pull request you sent on Thu, 15 Dec 2022 13:24:15 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/785d21ba2f447fb26df4b22f45653763beb767ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
