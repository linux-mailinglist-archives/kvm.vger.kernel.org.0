Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075F266A44F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 21:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjAMUpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 15:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjAMUpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 15:45:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BAF87925;
        Fri, 13 Jan 2023 12:45:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04504CE2162;
        Fri, 13 Jan 2023 20:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31170C433D2;
        Fri, 13 Jan 2023 20:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673642716;
        bh=G/OekLgN5DCAh7qUz6HVlcICZPX4UlauftnFyJpR7MY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UF0TF+HCyJI9dWPAfBRrgWQA6+8nDWn9eOFFFChoer+vER6TFS6mOVz8dxk+EAbIe
         guw0f1h+k/5EUAWLmpk9jnuruNSE5U2VyR/quASxIsWp5+flOwrgglCfOUo296yuLC
         PRWMMyZ0sbl5UYCsA+GlTRMvA2LjVmSH/nRVx5sWyQQ6bMT8DQg+nMJlYwozio71PH
         Wx0Tk+YPKXLWMK2P+4Zxnunt9PbPQhVco4uynAUwYTitmw0+2plZNSZ+I8itUZ1Bbp
         KizHcx/3B7m1hAcYwD4IwSnDfmlsffgrEN2+ZfOQG2mdoj0ZfFsyQeDngF6cSAeM8G
         g9oROfHZbMu+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E4F5C395C7;
        Fri, 13 Jan 2023 20:45:16 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.2-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230113173710.2825302-1-pbonzini@redhat.com>
References: <20230113173710.2825302-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230113173710.2825302-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 310bc39546a435c83cc27a0eba878afac0d74714
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 92783a90bcbde8659dd4a160506c46c56db494d6
Message-Id: <167364271611.4516.10598281625219681750.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Jan 2023 20:45:16 +0000
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

The pull request you sent on Fri, 13 Jan 2023 12:37:10 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/92783a90bcbde8659dd4a160506c46c56db494d6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
