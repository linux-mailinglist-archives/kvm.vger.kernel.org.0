Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD37B0AD9
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjI0RKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 13:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjI0RKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 13:10:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB002E6;
        Wed, 27 Sep 2023 10:10:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 629C1C433C7;
        Wed, 27 Sep 2023 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695834643;
        bh=nPZBefKAPIx5448kBvSo7bUV1E3ig2aK3HaJC7w60jI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oDhTH20tGczeMhoaFD1jJq6pCG8cITZjt+Sbc+CmYUkogMCWkJyXCdso30snZC7XQ
         tWXSMp3cJbk1Nixfq3qxSIxE6Tni2ycHgtvw+UK6bw23RUrToXSgMss/jjZ5klfnfo
         rLWGptiNAHiq0PU58x8okDGAU0xEfOmmz5EImVltNfgIUBEqE+IAmqnq0xa5/uLQCx
         /UWBCuvx0YRcNQ8CG6U9GOAu+MPoqW1NlmTHyUfMFoDYUOQmyaFmtW8Xi0IXSZc/pu
         EMrAOTCz3CqQ6lbS+qHmaAyjef8TGWFZYjrTsFKrkbMCwUrB5D337b5YiFNLVvW5SI
         5LkCiH7LBPxbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51397C43158;
        Wed, 27 Sep 2023 17:10:43 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v6.6-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230926154538.20a5b2c4.alex.williamson@redhat.com>
References: <20230926154538.20a5b2c4.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230926154538.20a5b2c4.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc4
X-PR-Tracked-Commit-Id: c777b11d34e0f47dbbc4b018ef65ad030f2b283a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b6cd17050bc0817c79924f23716198b2e935556e
Message-Id: <169583464332.26255.17167261992407004635.pr-tracker-bot@kernel.org>
Date:   Wed, 27 Sep 2023 17:10:43 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 26 Sep 2023 15:45:38 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b6cd17050bc0817c79924f23716198b2e935556e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
