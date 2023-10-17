Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914C67CB829
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 03:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjJQB53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 21:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbjJQB51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 21:57:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D89AF;
        Mon, 16 Oct 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18936C433C8;
        Tue, 17 Oct 2023 01:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697507846;
        bh=t0I9VlzVsMoPehowP+7oOaG/dN9TNZd9deI5XUPWwp8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ywpgnl/pjJuvGzhMAwttb4p9YVCoPfOpA31Rb4N0fUbHgglHWWcnuqr+1A9KLEn36
         jG01h/Jlt6qIXGzFXaFe5382SAQJvlElOqrHY4Xuk2OlYOBonJarE5eWhXd408G+ka
         G5GJDQ1Zr0Gg2RvDmWwZWHt+tfDsSza0/A/XS9ogp+7GnH9fGvhaosYogLG10+739u
         galK8ucDU7DT92td/wpqPkUf9KiSDVj+Yy/SZxkinpluW7+Y7stbaoPkK1KmtJxtal
         xkGruOM395KxG1rTwR1C/9Xu0XZYiphPCYtsyoLaNk7fzrhs/JazEhRGfKxh6JWW0D
         D5BQkXFFGXSYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 060F6C4316B;
        Tue, 17 Oct 2023 01:57:26 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.6-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231016225038.2829334-1-pbonzini@redhat.com>
References: <20231016225038.2829334-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231016225038.2829334-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2b3f2325e71f09098723727d665e2e8003d455dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86d6a628a281a17b8341ece99997c1251bb41a41
Message-Id: <169750784601.28912.2902501184752548539.pr-tracker-bot@kernel.org>
Date:   Tue, 17 Oct 2023 01:57:26 +0000
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

The pull request you sent on Mon, 16 Oct 2023 18:50:38 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86d6a628a281a17b8341ece99997c1251bb41a41

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
