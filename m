Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D8551DF96
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390355AbiEFTSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 15:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390383AbiEFTSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 15:18:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2916F48C;
        Fri,  6 May 2022 12:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C3A621B4;
        Fri,  6 May 2022 19:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F04CCC385A9;
        Fri,  6 May 2022 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651864494;
        bh=F/9jPRzu6LORMt13X5oeMdS+FWzPGSwKkpcgSI/FGmA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=o33nd9l8zt0+cbKQTdCyGbZpfOglld8BZxUXsl0IGy4Fnrelr0b+0qbWYggF8cpzO
         xIeLbsYOt6wis7BC5bVgwcWD/tzK/gO8FUk8biwGxKcia5Rs/Z0M/3VOrgqwD5JdBc
         4YnrF22h2EDtlBG5u0aKsElQYQ7l9+h1bHsBolUYGJqiDiqp88nmt0mPpYrYYXguhe
         x/RHfgoGYbicbPpT3LXwr+DcQmaj1CFYURgwAcgwR+0LsvnyKG197VOBoKenq2PSBO
         QUpe1ziC8LYBAhGq8oI6JlcOvxTchlzYv78uByDQb/3oz7JArFVv2vQ9NXHnMDKyiv
         BfQ94JfywiVQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D78C3F03912;
        Fri,  6 May 2022 19:14:53 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.18-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220506171649.1426392-1-pbonzini@redhat.com>
References: <20220506171649.1426392-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220506171649.1426392-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 053d2290c0307e3642e75e0185ddadf084dc36c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bce58da1f39843d47ccd6d9839fadbf898b72358
Message-Id: <165186449387.13372.14469142481679770324.pr-tracker-bot@kernel.org>
Date:   Fri, 06 May 2022 19:14:53 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  6 May 2022 13:16:49 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bce58da1f39843d47ccd6d9839fadbf898b72358

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
