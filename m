Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF756F8A34
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 22:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjEEUdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 16:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbjEEUdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 16:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE0D49D2;
        Fri,  5 May 2023 13:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA2C62F81;
        Fri,  5 May 2023 20:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CE7DC433D2;
        Fri,  5 May 2023 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683318784;
        bh=NdnK+bhqBm23Svz0A0viCXMCQ9i9M8JqT1rUxpcHwGY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tCmhvZyw3MXC7KRrO7rkSeHuAdBmNx4gNtCnF7q7IsQ+4E5qzfZWgTGrqS0rLRnOW
         w0DBKRVUDLALgpy/ho1zYwNRvvNdBUnReyPuukW9Yr/zTmUKFRR/ajUCdEHlri6+pc
         Kz3uBG24rWJbmqKhniDBUKSvsLJrO8ha1+w9B5Hl0RDrQHUM6P3q+kr9/7tuLD/Jp+
         G7akRqqSmVvFPBud3W/wgnYpbxIzeDhhnsFGFiQEgWm6uSJMzR9/GecSb00UCgDd4E
         c/TnYZm8qNQK+n5lVWJUlwZwESyQHZJUjWUJqcgvyYgjwsSklXQy9ayeTi1uCQyPtP
         z8JhPZC9p41Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B240E5FFFA;
        Fri,  5 May 2023 20:33:04 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM patches for Linux 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230505103912.3270597-1-pbonzini@redhat.com>
References: <20230505103912.3270597-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230505103912.3270597-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 7a8016d95651fecce5708ed93a24a03a9ad91c80
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 493804a6895d63240fe45d087cd14c4b77d8488b
Message-Id: <168331878423.21250.14699972065852420276.pr-tracker-bot@kernel.org>
Date:   Fri, 05 May 2023 20:33:04 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  5 May 2023 06:39:12 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/493804a6895d63240fe45d087cd14c4b77d8488b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
