Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85116ED6DD
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 23:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjDXVpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 17:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbjDXVpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 17:45:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C2F5267;
        Mon, 24 Apr 2023 14:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DA516289E;
        Mon, 24 Apr 2023 21:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72AAFC433D2;
        Mon, 24 Apr 2023 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682372737;
        bh=TwnZUueyFdVR1wIPPiWen4VJwzu3FfozwfIcM1QoYPA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=t3A/n5b0n7vbVqd9ZgaslNQjFbzJCwvVePCmHb3OwLKZeOh35DKZnadeOyKoTT5M4
         BOOAi1dWQjY+wR82rsMJj/GjpM8MXPaz2iU8kkA+qienZ1/nnkvLsyGvtrv1K6X3/z
         i64WPCB5aFKBVFl8dkfh47JSRxSYIaGMUfGyWuiS0TAHeWKdeP+f1xC7irud27L3Ty
         sIxZJiffz6KJRHEqosNNadidJEip4EnZIs63/J9fV6iC3KmiZ5Hx7D48RxdukWqvxm
         uxfkv8UsxizRHD24pZgStq4sIIZENhsaUB6Y7T07IYRMs5eQlgdDBC2fTAn8dLnACe
         EoiGsXdlXTXvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E4D3E5FFC9;
        Mon, 24 Apr 2023 21:45:37 +0000 (UTC)
Subject: Re: [GIT PULL] fork: user workers & vhost
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230421-satzglied-cybernaut-b2b652a46bfa@brauner>
References: <20230421-satzglied-cybernaut-b2b652a46bfa@brauner>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230421-satzglied-cybernaut-b2b652a46bfa@brauner>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/v6.4/kernel.user_worker
X-PR-Tracked-Commit-Id: 6e890c5d5021ca7e69bbe203fde42447874d9a82
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3323ddce085cdb33331c2c1bb7a88233023566a9
Message-Id: <168237273738.2393.13319031457791989144.pr-tracker-bot@kernel.org>
Date:   Mon, 24 Apr 2023 21:45:37 +0000
To:     Christian Brauner <brauner@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 21 Apr 2023 15:37:12 +0200:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/v6.4/kernel.user_worker

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3323ddce085cdb33331c2c1bb7a88233023566a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
