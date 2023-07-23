Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A5275E430
	for <lists+kvm@lfdr.de>; Sun, 23 Jul 2023 20:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjGWSor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 14:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjGWSoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 14:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF31E40;
        Sun, 23 Jul 2023 11:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB0F60E00;
        Sun, 23 Jul 2023 18:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FF57C433C7;
        Sun, 23 Jul 2023 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690137884;
        bh=E/wb8tAkRY3T0SAXlQaLfYMUjYThK8aoLqX1paxjcGU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bJ0ZSLQ9GyMivxZad7jn49jXL02UYIZGTtYqVh0Wq5nv785O9mtNWb73e0BfhjVD3
         92v3QHO/zXDlWZlM/ALT89Q8ZPlKuzzqMCkSb/D3+NNVNdi+Jyvg7ra09xkuT98iNs
         q0kcnGpbpQuTHN8FBPJHkJusQzEfDQdy8AGc0Zf4j60FY75DjnbgU6A1/GnPu6Rf31
         +Ks77o1G3NkEzf8cdyzQw7cPs1wYzMbuD36F4oseQX6DbCwREwdLgnAGxl2Y7hES4y
         GqCYm+G0d5nc2677iRgfT6jT5or+LwLFn8V27JvpYDlJ4p5FUIc0+GSTAw/c+2a0dh
         1mPgJwBidOCAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59FA1C595C1;
        Sun, 23 Jul 2023 18:44:44 +0000 (UTC)
Subject: Re: [GIT PULL] (Non-x86) KVM fixes for Linux 6.5-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230723170117.2317135-1-pbonzini@redhat.com>
References: <20230723170117.2317135-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230723170117.2317135-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 0c189708bfbfa90b458dac5f0fd4379f9a7d547e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 269f4a4b85a1b61e94bf935b30c56a938e92f585
Message-Id: <169013788434.27296.17546307556083051459.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Jul 2023 18:44:44 +0000
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

The pull request you sent on Sun, 23 Jul 2023 13:01:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/269f4a4b85a1b61e94bf935b30c56a938e92f585

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
