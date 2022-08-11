Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A7590820
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiHKVcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiHKVcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:32:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6851995E69;
        Thu, 11 Aug 2022 14:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FDEBB8229F;
        Thu, 11 Aug 2022 21:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D685FC433C1;
        Thu, 11 Aug 2022 21:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660253533;
        bh=J1bQySmOZkLA6swB3btSUuxMPP80+PclfRfYfhM5u80=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Dpx0VIKsZQPCJThei8b/3qQEtlc5MQG8+6yNlmRO1D4tQY0ufYB/V+gqsxV/9M6yR
         m7zkNEcf4R1FguOrwYAnxBhr0VELWfxuG1hIbS8IluxISVVvfugiNPgPiN9EmKd/w7
         Qw/W4bvcAu491bI0jJMmMrWoQH/9Fjm2Q52VgbORpa8Zy+hNi+OZLeIDS+N1bM9EPQ
         GoWK4a3HEVrtLqMiaKnmhYJZilQFI4RVNHYj4X+5WX4iIi0/WifE7+dE5WKsTq1H2w
         NJ3ENJ/RPApZfF6mCLGs1eiz6mrtKACpmj/uo58wBmRI3ppSPpcb9vJtyVoklmfBY6
         VsYiOWs2WRX5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C555BC43142;
        Thu, 11 Aug 2022 21:32:13 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.20 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220811075554.198111-1-pbonzini@redhat.com>
References: <20220811075554.198111-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220811075554.198111-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 19a7cc817a380f7a412d7d76e145e9e2bc47e52f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e18a90427c4ef26e9208a8710b7d10eaf02bed48
Message-Id: <166025353380.15191.2858348863402589874.pr-tracker-bot@kernel.org>
Date:   Thu, 11 Aug 2022 21:32:13 +0000
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

The pull request you sent on Thu, 11 Aug 2022 03:55:54 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e18a90427c4ef26e9208a8710b7d10eaf02bed48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
