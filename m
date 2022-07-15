Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D5357664B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 19:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiGORpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 13:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiGORp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 13:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFBD804AA;
        Fri, 15 Jul 2022 10:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5445622CF;
        Fri, 15 Jul 2022 17:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12828C34115;
        Fri, 15 Jul 2022 17:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657907124;
        bh=SkLZvx2RuGc/oVGBu/aw9AbkJ7O7+EJKghdjClZChbk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=vPBJUyLu+p0L+v8sm4rHoGw1Fb9N/cyNBRE284XdUxumP+jXezkcofrhkuQZp0YwA
         aIqsvi+4AaaSec6zSAL2n3Y9zgopabPiwHDEyrpCLAYai524uwO5VOcHnl18Ci8xLk
         V/0aJSe3mrS50H6RP5fjk3vlQOsSDsm2DShpKEl8ZKTWf9atges1tGls9HsW2OY7rh
         9kjeuk92MGo3wHNLy1bLOl4dInjb7rSIS683WGlRgiypjSnoCwW2T37kFljI7wRsL7
         ZbX4hshqYzXtkYzTiXTPpMcmaHEdnV09gZeEDLSXL0a/C8XZfi53qnd08R+w7B+nyC
         RWOxbRyYeSasQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3A3EE4521F;
        Fri, 15 Jul 2022 17:45:23 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.19-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220715165915.1464140-1-pbonzini@redhat.com>
References: <20220715165915.1464140-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220715165915.1464140-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 79629181607e801c0b41b8790ac4ee2eb5d7bc3e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8ebfcd33caf29592957229c8350f67b48b8efce
Message-Id: <165790712398.27298.9666333329447001423.pr-tracker-bot@kernel.org>
Date:   Fri, 15 Jul 2022 17:45:23 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 15 Jul 2022 12:59:15 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8ebfcd33caf29592957229c8350f67b48b8efce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
