Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE05AC5EE
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiIDSxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 14:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbiIDSxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 14:53:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530FD2B62A;
        Sun,  4 Sep 2022 11:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3B1B80E44;
        Sun,  4 Sep 2022 18:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5625C433C1;
        Sun,  4 Sep 2022 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662317591;
        bh=3q4Vy/t+KICNVL9YJ3dL/HUrRY5qyAZYrllUYJCKNUE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mI3BECxFf8q6UO3HGuBpHKVGB7E+TrvYUe+Yye8u3Rr8XwNHe6vzCNGfayHxzZ779
         yxlwm57OBRkUfPay0RZCNUZyAoYixMHmTxwrWxxbYHL+aIglrqgelnswyEFjuqpgPb
         kKTi2ihjlvwOoY2bB/uv03JFiGVRyOMg8uix7wHLuxWqQx2YSDMPeqwwW+Qk9hq3e5
         TIb6mQZ3xzqmWShSw0uDBWq/YqeSCIaIqvOaR1ghoWCIFinJXssAxAbl3TSDKKr6FP
         vXwRyMJbYk/tnmqy+SCDR4ctKK4N9jlEh7veI9tzEW8EW3juXDoZgRVkD+7A0Ien64
         wSC++p5AjVB0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B42ACC4166E;
        Sun,  4 Sep 2022 18:53:11 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.0-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220904095616.3966213-1-pbonzini@redhat.com>
References: <20220904095616.3966213-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220904095616.3966213-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 29250ba51bc1cbe8a87e923f76978b87c3247a8c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 685ed983e2dc330680a076a1fd37ebe04017df91
Message-Id: <166231759173.23278.13289409740909650855.pr-tracker-bot@kernel.org>
Date:   Sun, 04 Sep 2022 18:53:11 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sun,  4 Sep 2022 05:56:16 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/685ed983e2dc330680a076a1fd37ebe04017df91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
