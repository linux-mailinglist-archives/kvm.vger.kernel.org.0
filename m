Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2FC67A8B0
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 03:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjAYCXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 21:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAYCXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 21:23:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E61460A1;
        Tue, 24 Jan 2023 18:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD821B817C1;
        Wed, 25 Jan 2023 02:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EC32C4339B;
        Wed, 25 Jan 2023 02:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613383;
        bh=C6nNJm7h8Sq2K/cSvFkKaRmoQUd4kofDbRITLVV6sRY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LthOSqY8GXFRlvRi6iW0qsWR3nY+fTPdVIcEgFNdRvFpTHOVlRqbE7PSThL64oz/o
         Hl+OXm8oin7GZdN+lFwaSDf4tGEMfnTslurPXVX6i8YTl+ZPKdVOPjir6cxtiKRrvg
         oPt62LKv2Z3Ccy+btHtvz/ABonW2hwwOp7hovPM4+RZgTUvo1HvTbleLFEThVoxI8D
         vsZXsc5O9kTFs7J3q8qAexwgN/hIO8gPC0Q5xCanoqRSAYS+W5vDxspXkGcR3qTbSe
         NSP4p1iKrm3xBGlt4wAZ27YXWHL3fvmlJyxsWpNepSvQRz0cM7E8J3D3aSw3zG7/G1
         fsH//9LIJ6nZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58EF4F83ECD;
        Wed, 25 Jan 2023 02:23:03 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.2-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230124180547.4192955-1-pbonzini@redhat.com>
References: <20230124180547.4192955-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230124180547.4192955-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c2c46b10d52624376322b01654095a84611c7e09
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2f317173ed5f00a00aedba71cc67454d9cde90f
Message-Id: <167461338336.26446.1440365901647932335.pr-tracker-bot@kernel.org>
Date:   Wed, 25 Jan 2023 02:23:03 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 24 Jan 2023 13:05:47 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2f317173ed5f00a00aedba71cc67454d9cde90f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
