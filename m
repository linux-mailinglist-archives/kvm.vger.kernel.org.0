Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13176D6D1B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbjDDT1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbjDDT1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89F649C5;
        Tue,  4 Apr 2023 12:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B909C63913;
        Tue,  4 Apr 2023 19:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23887C433D2;
        Tue,  4 Apr 2023 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680636450;
        bh=CVs1A1h4K6iW+igbmqYSYrhPbS5njvPMa7aHMVWdXG8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=F9VoKbSS+d91vHTDH55EaunPl9km782HiQ5SoenoShMaG63mlSQYXeUYyhP0u0y1e
         9Y6j+8mdjCRl91YbgjlEM757jq96ojB34V6Lprp6H34lC6P00fDa52wiykSWK2glqx
         iEL/8T+tiXbu4GvjcScQDPx/3S5+zb6gXerOMLaVW3svNIcqC8MhMVa7k/KEIL4qaK
         IJfdzIvbwUcJ46NuM41+oAKOZDTsXPW8gzIqqJkl1zo0TSdlWrDXb9FgwJ4cYafM4N
         Ln90rSf9CApMpzSKZ61Z/wzSEocqJG0BxMoE28xIcWo8xe7p9Bo0XNuz11/XdYq1ql
         WV75YA9AYruxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11FC8E29F4D;
        Tue,  4 Apr 2023 19:27:30 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.4-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230404175106.757011-1-pbonzini@redhat.com>
References: <20230404175106.757011-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230404175106.757011-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: fb5015bc8b733323b58f015b88e4f316010ec856
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 76f598ba7d8e2bfb4855b5298caedd5af0c374a8
Message-Id: <168063645005.19891.6520787695369402545.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Apr 2023 19:27:30 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  4 Apr 2023 13:51:06 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/76f598ba7d8e2bfb4855b5298caedd5af0c374a8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
