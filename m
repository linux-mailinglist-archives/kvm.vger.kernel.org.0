Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F3869BB93
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 20:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBRTPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Feb 2023 14:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBRTPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Feb 2023 14:15:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6097C149AE;
        Sat, 18 Feb 2023 11:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2372EB801B9;
        Sat, 18 Feb 2023 19:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7AF5C433D2;
        Sat, 18 Feb 2023 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676747743;
        bh=3NEPSCdKHNfT0MY+YJN+MxcsBs+IrB/ZkWnpEw4ipI4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jG7RxbfVe4GTRL70uZpG8V7CWnFgNG8B6NXRoRYw59+TmOWML+e9sQ6JPTCiIgH6X
         cHPr+b4WhlCFZ88Vcw+dbJ1M9Q6Z+IhC6RLNrpN2hxH98k+aqkCOWVDxrEolABtl6d
         L06M54MZJCnx29xcjRgm0/TOvrtSsaXMdZ6gGqumNMH8w0fHroTjLiti4uQjdBKoFg
         pJww9zx6L/NV9F9GS1AFEK6B7DGfvGajVI7VGWTR8DnKfk/pdrQh0FAbdiyqCudFZq
         1f9UOleM7hmutR1UUe6uKcRTSRgeV74Y9X6dDje2P2zZGnCtXFfzKljBA69fHuX0Qp
         gNkb5Izo8eT2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD5D9E68D2F;
        Sat, 18 Feb 2023 19:15:43 +0000 (UTC)
Subject: Re: [GIT PULL] Final batch KVM changes for Linux 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230218145102.1610745-1-pbonzini@redhat.com>
References: <20230218145102.1610745-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230218145102.1610745-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2c10b61421a28e95a46ab489fd56c0f442ff6952
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5e725d112e1a54c2611d5dffd124a79415d0f0de
Message-Id: <167674774370.30281.15330609149110500615.pr-tracker-bot@kernel.org>
Date:   Sat, 18 Feb 2023 19:15:43 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 18 Feb 2023 09:51:02 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5e725d112e1a54c2611d5dffd124a79415d0f0de

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
