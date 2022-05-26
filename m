Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A05E5355F3
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbiEZWFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 18:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349981AbiEZWEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 18:04:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1FC62A0C;
        Thu, 26 May 2022 15:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2399B82219;
        Thu, 26 May 2022 22:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BDE0C385A9;
        Thu, 26 May 2022 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653602684;
        bh=ECgkSFExHsqzKzy858DFNxfa09+NDtw4qUcJMjqu2Ek=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EnrS6YwNzdjYkewbpKhw1g9QE3ZFqsCwTczBBaBFKbJOKexGx5ib2RJfW434+TT0t
         TSqooSIoZ3hcaLf5Do7gsGZ3+cR1D7RrwqnUUzX7HaI3FvmFwnMfb/LvFjz47zzLp7
         v2t3DhNzy1nXVhHWZnIHON+Av0NqceGBK1+PyAisRz1ZcJIK5h2j5gj+FBVuDmxIvN
         pgO1G2hXVrNp3eKK5Juh/KUOav0odBUkGwDxHPA6z1qzAnb92KvfpCkE9vbSqLMLtz
         bMjmZZ8yJYN8uhN5tMkfYcBR41iNr21DHsUPMZkvwm8aZSGz9RSrd1fW2LRMnn0TAJ
         usx0o0LG1ZkrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79541F03938;
        Thu, 26 May 2022 22:04:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.19 merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220525152650.250776-1-pbonzini@redhat.com>
References: <20220525152650.250776-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220525152650.250776-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ffd1925a596ce68bed7d81c61cb64bc35f788a9d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf9095424d027e942e1d1ee74977e17b7df8e455
Message-Id: <165360268449.24340.12208072038298092748.pr-tracker-bot@kernel.org>
Date:   Thu, 26 May 2022 22:04:44 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 25 May 2022 11:26:50 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf9095424d027e942e1d1ee74977e17b7df8e455

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
