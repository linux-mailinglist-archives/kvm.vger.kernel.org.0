Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4AD5FCE77
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJLWdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 18:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiJLWdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 18:33:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E15D8D0EC;
        Wed, 12 Oct 2022 15:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E43DEB819BB;
        Wed, 12 Oct 2022 22:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A8FDC433D6;
        Wed, 12 Oct 2022 22:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665614009;
        bh=xONmnRImONKv+PUBJadpg56RH/yUrJivjJgtm4hzhtk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=W6M3qRyGnO/de3DYYzzKQd6093pMjwc3vqmHrwDiCz2gLaNIALjuu3sqSQtyMIfD3
         Bo0ALdKUjc1UtIlktx/pgns9Otpwy6qLDFJjXvIO+LD+3BVHpQgsmFgTb8t2vU4n68
         ExSQaIUFXyMWDfGTYqs9HCqfnOOm/mUIdKgoeACspIarRBsuK/30ektTP9HT/F6jBD
         Gn/Rl7pn65l0e8Nbg4WF7wQVVlSb7n4QpyKbFfxIvsUrZhyqVVtfAc3dgN4laKITim
         jmljhugWXoEa3c/9M66Tibk5HiXiWL6Ik6OvX8DoZXTWwRQyj1VJl1037Dc4aKaK3z
         bjBLtjMKezeYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89F57E21EC5;
        Wed, 12 Oct 2022 22:33:29 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.1-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221012091434.650250cd.alex.williamson@redhat.com>
References: <20221012091434.650250cd.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221012091434.650250cd.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.1-rc1
X-PR-Tracked-Commit-Id: b1b8132a651cf6a5b18a01d8f1bd304f5d210315
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3cf40513330752238ae585fdb0e46ec6baa588b
Message-Id: <166561400956.16489.5983648311784806654.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Oct 2022 22:33:29 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        alex.williamson@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 12 Oct 2022 09:14:34 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3cf40513330752238ae585fdb0e46ec6baa588b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
