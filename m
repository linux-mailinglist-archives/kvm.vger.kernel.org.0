Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AED4C97B3
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 22:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbiCAVXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 16:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiCAVX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 16:23:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9719C0D;
        Tue,  1 Mar 2022 13:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A387EB81DB9;
        Tue,  1 Mar 2022 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D66FC340EE;
        Tue,  1 Mar 2022 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646169763;
        bh=2ThIYJUboftWJtEkVuCmm8qttmiUF0uXJz8iNhPvKlc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Rmb9ubCIKI8Az60WV3Y3tRl1icAEIs2TIrZ98dUB/3PjiasLV8TIcadGHs18yqj2S
         EzMX6xl582Sm2Gtro/1AbaaLSetXrVcYmXo17oxH31FN0sfhvcb4WDF9CONvceerzs
         3RGK/1J+MITovOrWs4bodrNZ7/gVNQFvrDvdMc7Z34S6KBuCLGi5Jsrsx0OhtCcJF9
         jIKt2aeFuqF1jzUQmceQwvnPThNPRmkJpVoG3ym5NyKK+fw5uA3ccn7kIIK0tU2UeU
         dHZUmfajFPAoB5E5viLZlHZrdkRiNAjDyrvjyx+KIdGQ7WdP444mT6MgL43sbmsQk3
         Q9mbe74R8rPzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 482E7E6D4BB;
        Tue,  1 Mar 2022 21:22:43 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.17-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220301130815.151511-1-pbonzini@redhat.com>
References: <20220301130815.151511-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220301130815.151511-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ece32a75f003464cad59c26305b4462305273d70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fb184c4af9b9f4563e7a126219389986a71d5b5b
Message-Id: <164616976328.25768.4740704337539258559.pr-tracker-bot@kernel.org>
Date:   Tue, 01 Mar 2022 21:22:43 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  1 Mar 2022 08:08:15 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fb184c4af9b9f4563e7a126219389986a71d5b5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
