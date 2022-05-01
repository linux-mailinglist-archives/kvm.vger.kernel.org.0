Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAA516748
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 21:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346713AbiEATKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 15:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiEATJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 15:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4BF33E07;
        Sun,  1 May 2022 12:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85EFD60FCD;
        Sun,  1 May 2022 19:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5731FC385AA;
        Sun,  1 May 2022 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651431993;
        bh=2lKKYOIbpWSXATrBa26WkxbAc0IL8XCCBLSFsZF1LJI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LfliSkdxCtUXHG09fyRNVhqa8N9TJ8c/2oKoolIt3fTaaAkcWWuH+IafLkefsVgMv
         O11AUqhbhSkAn7bFi85ZohdGKJXVL3MULuCEsrquC8AGV6J3PbmQi74UUpnEdicsm4
         GaFxDPtqvRa2Nsu6Rh1Az+ZqUSSOYG2zeoaw9WaGffQ8+KE/KoNNYqaV65ebaOuTIV
         54mtbiv1wCXYj+wxiOq7szlnBZ8KZxKbKW1plQXAGy/VlnxvcV5BPS6YBmFRMI+UCE
         TgSwCLgBxsrQR8i6NoDsvISqYqPmcwSK20svpp/SR1LATLMIHXFyZ5I00fx0qyHIvl
         ksAyNl8kBdfzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44007E6D402;
        Sun,  1 May 2022 19:06:33 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.18-rc5 (or -rc6)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220501173607.947159-1-pbonzini@redhat.com>
References: <20220501173607.947159-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220501173607.947159-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: f751d8eac17692905cdd6935f72d523d8adf3b65
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b6b2648911bbc13c59def22fd7b4b7c511a4eb92
Message-Id: <165143199327.12721.12284077184153293337.pr-tracker-bot@kernel.org>
Date:   Sun, 01 May 2022 19:06:33 +0000
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

The pull request you sent on Sun,  1 May 2022 13:36:07 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b6b2648911bbc13c59def22fd7b4b7c511a4eb92

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
