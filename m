Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9045438E7
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiFHQ11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 12:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245443AbiFHQ1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099BC4C7B5;
        Wed,  8 Jun 2022 09:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FFB961794;
        Wed,  8 Jun 2022 16:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F4025C3411D;
        Wed,  8 Jun 2022 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654705644;
        bh=sDfJYv2re1lkoBUIiTxSKOcwRSYoYL14Z0wr/FtM1KA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=q6FYb3W3glUa20yt3PZsp928rYZ0FIdxG5Z/JjzdXQnhIierNZ79bWcfgNVKO0I8t
         aaPBAQFBsO2Wypl0R+ev4kalTfjBxqjeAJb7xV+AOgOE7fw6vmh92soeEvMctq4xEv
         JqVA/4cZg2SIj58D6ruHwC82ylt0piQbWedbf+OmKEKC2tTTI4ABHwTWN3AIOewBVl
         s7bvr+C0mhTp0ee5r0iVccmH9A8DUrGowGU2G3azx6fISOe/e5MN0vegPVs0JgUdSL
         FCN5iPXi993kjOrSsYiR4O/qnKknNZEwNjegBb2RrdJJL+Izrp0telPqnar5fEcxW4
         CUhMJWXLMmkyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0948E737EF;
        Wed,  8 Jun 2022 16:27:23 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.19-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220608152009.893314-1-pbonzini@redhat.com>
References: <20220608152009.893314-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220608152009.893314-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6cd88243c7e03845a450795e134b488fc2afb736
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34f4335c16a5f4bb7da6c8d2d5e780b6a163846a
Message-Id: <165470564391.4500.14872010289303521458.pr-tracker-bot@kernel.org>
Date:   Wed, 08 Jun 2022 16:27:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed,  8 Jun 2022 11:20:09 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34f4335c16a5f4bb7da6c8d2d5e780b6a163846a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
