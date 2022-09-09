Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2745B5B36D9
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiIIL76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 07:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiIIL7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 07:59:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8B3A16F;
        Fri,  9 Sep 2022 04:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21658B82469;
        Fri,  9 Sep 2022 11:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD66AC433D7;
        Fri,  9 Sep 2022 11:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662724791;
        bh=eHgRP2j7HAi0E/+yAq/Vxw4TaNkFNQXTEkQ8XH0c300=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Kl/rqEo8gpQqyDxlFrJXEQiwU2O0aQUE6D0vTNTH1lnC6vR4aRrI197Qg7DQiA3bu
         DYrx7EbC8jru0fkem25ygjfsJ82ZdZuGGhXtXWt8DEPrudV45RkQf//Zo95r2xsZUL
         72eOMuIz9fuEh1bpU9ZfEOIL82/NpvcBMtlaq5nNA4QwA5j9AM49F7Rerxrt6xJMmj
         +dJBGhCJ6X9j/Ssve1lROvtHYdpvWJO8+kGCYzAKg6z+DZKOFCSf3z6Xvn58M10Z50
         tWt5qGhDJ4TbGiUS6naxLP3fOkjOw9OTTt86TDwzPu71mx5MicWAPIE1Sv0obIM2w+
         GB8eKNffvgDrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC546C4166E;
        Fri,  9 Sep 2022 11:59:51 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220909045225.3a572a57.alex.williamson@redhat.com>
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220909045225.3a572a57.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc5
X-PR-Tracked-Commit-Id: 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 725f3f3b2708d8f3fe56df8113bfdc7380d52dc9
Message-Id: <166272479176.31182.12971166661136217899.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Sep 2022 11:59:51 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 9 Sep 2022 04:52:25 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/725f3f3b2708d8f3fe56df8113bfdc7380d52dc9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
