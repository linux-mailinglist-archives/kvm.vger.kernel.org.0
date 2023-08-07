Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E68D772CAA
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 19:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjHGRVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 13:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjHGRVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 13:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1BC19BB;
        Mon,  7 Aug 2023 10:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 034AC61F1E;
        Mon,  7 Aug 2023 17:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BD62C433C9;
        Mon,  7 Aug 2023 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691428821;
        bh=dGLH6WBoIQq2f6u5pupPqEgJStrWSh5olTU+1GU46rs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jq3r9hsbrOrhF/RfogPI4dp0Uq+c64HTueEBxqY7DbH/TpJ2EVFxeNawzdM5LYDvL
         BFF7qM9d7NBUqzOedtM7v1aurbRDnifBlKgEVyUH72/3JEETjjE8gE0s4VRLecEE1t
         fcH3r/tXvAIpDrZPsXxv6Ag2OqoYGzE3d1N1C6bXXS/hAFWNK+T102Vl8JoxViiug3
         hwPF3+0N4WTOe92s6oyvLH93SHJdKcX6TkMjagi3Da+KGV9qyLOHXkuOWKuMJ4monX
         eb8vjAWoYICcagexpxWH751TYRsrZuPzj1vKjs6l0MVX/BacpsjXfX5LdZBNZOu9bB
         4hJalIFCAoAYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5686AE505D4;
        Mon,  7 Aug 2023 17:20:21 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for v6.5-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230807135243.3394830-1-pbonzini@redhat.com>
References: <20230807135243.3394830-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230807135243.3394830-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d5ad9aae13dcced333c1a7816ff0a4fbbb052466
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a027b2eca0b7e90b11a0b0ddfad0dc4068707799
Message-Id: <169142882134.16513.4562352298349377850.pr-tracker-bot@kernel.org>
Date:   Mon, 07 Aug 2023 17:20:21 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon,  7 Aug 2023 09:52:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a027b2eca0b7e90b11a0b0ddfad0dc4068707799

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
