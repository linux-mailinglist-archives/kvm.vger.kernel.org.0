Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94456EBA72
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDVQrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 12:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDVQrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 12:47:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D191FEE;
        Sat, 22 Apr 2023 09:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72EB860916;
        Sat, 22 Apr 2023 16:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7229C433D2;
        Sat, 22 Apr 2023 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682182021;
        bh=lSarrmV1UYt13xCdQmDm+lMAabPMQoHcL0qpkZndFfA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LZGqnPUEXaJtZLzO6rOa7+gu/bf4P3pZ91GW1tlV7vuKr03XCyOk9r/7EwtaDMf1M
         gxgbFk9XN5tH7si+tAuGBiQ3xOi5f4HmcLcgVV8pvCgBftjKO0vlHVuBDY8G3TeOPW
         YmZQb4okGy4o4I0EcHG/te9SdxXxBPpY3DOOITnFQJp8RYZ/nxLYf/NdSfs27TGtSY
         GBsNnpPtw7zApkamLurxvUxzIycab2O09O9pu5N36EibLB2KDKukA03cyCFRWqpXgI
         67rJP4Y0wJARHwHgKbjKKRXRr6EYhBP2sUNkNDojL21hKFnC+N2JgguFyZyoLivliy
         KbP25N+ZwOUmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4E04E270DB;
        Sat, 22 Apr 2023 16:47:01 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM fixes for Linux 6.3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230422125317.2222959-1-pbonzini@redhat.com>
References: <20230422125317.2222959-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230422125317.2222959-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 265b97cbc22e0f67f79a71443b60dc1237ca5ee6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2caeeb9d4a1bccd923b7918427f9e9ef7151ddd8
Message-Id: <168218202179.21238.2395027109464113435.pr-tracker-bot@kernel.org>
Date:   Sat, 22 Apr 2023 16:47:01 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 22 Apr 2023 08:53:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2caeeb9d4a1bccd923b7918427f9e9ef7151ddd8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
