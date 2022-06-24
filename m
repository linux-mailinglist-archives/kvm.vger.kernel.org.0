Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8965F55A205
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 21:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiFXThP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 15:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiFXThN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 15:37:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521EC81D94;
        Fri, 24 Jun 2022 12:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B869B82B70;
        Fri, 24 Jun 2022 19:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2B90C34114;
        Fri, 24 Jun 2022 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656099430;
        bh=IVnpHG0UpG3x2KRRifv5c2CFbi8tuxeEhqNmP5UYlMY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HTCwtcsKN+SNdJDpy91D58PZjVXJSxktqQmCiCPzzcc72hR9bxoGOVp/1/RctAc2R
         Pe9U9bwSlsJMQUJahEw6qjGr0KLiZOX47kpA6Q84IeBcCGWulQyWaOcUUt73QITfbT
         r2/Av9s2+b0C1RssEfiaEG4xmlcD0cCytc75g8dzYpOOb47yS1WOWsEhRVeVIzDWHH
         BO3I/n9oY88GAavKaONjVNYQIc5HCc4xlieyV5BbjzlyCEPiLNrw/wPJs3YhKiL87P
         l1+Cn6i3M2oEtw8tKBgbeNZAesuRRGGeoH3+w1UJ4W+m/+X8vz2b3ZOV+DHwF7M/Rn
         UfaIR6MuKBDHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF2A6E574DA;
        Fri, 24 Jun 2022 19:37:10 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.19-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220624083216.2723369-1-pbonzini@redhat.com>
References: <20220624083216.2723369-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220624083216.2723369-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6defa24d3b12bbd418bc8526dea1cbc605265c06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e946554905c1d04da2a094ce4fdf47708f570bef
Message-Id: <165609943077.3020.11909383964706846172.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Jun 2022 19:37:10 +0000
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

The pull request you sent on Fri, 24 Jun 2022 04:32:16 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e946554905c1d04da2a094ce4fdf47708f570bef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
