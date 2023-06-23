Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0273AE22
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 03:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjFWBDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 21:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjFWBDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 21:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B5A1FE6;
        Thu, 22 Jun 2023 18:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE1161919;
        Fri, 23 Jun 2023 01:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 525E6C433C0;
        Fri, 23 Jun 2023 01:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687482213;
        bh=r5AieYcQ/8CMtjzH+kIWuUtfL9zdednKaLGqavxzFa8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uOkR0+zKbBO0L/O35oilrqoK2Pn7l+FqbdCvPkYyQmzuMkQngdxgFVLiAHDvEvawB
         uEgacJuUb1E6DEdN8cc3I5f/dtVo3D5qCHDT7G98J9Ohr/51QJXnF6K/z1optvbQGo
         f8XFAv68+eWM8BqkeiBpc/PvlBOeBdXbtf2iOb/mX5PHN9iYz/3N3UTZbLDl4yk5rz
         S8ilMM123tL6911ur77uOYxiPxSOkSbKjO3hH9E4mksclc5stDYXkeCfutJ8D9qojp
         ZZ0+JhdRT+YPwaTAnZveaN0R7C3OWHoMqbGIsVsn72eK1f99MXfDHX/HHik5730DMu
         1nBxLG7LOmTOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F0F8C395FF;
        Fri, 23 Jun 2023 01:03:33 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM fixes for Linux 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230622195247.3984207-1-pbonzini@redhat.com>
References: <20230622195247.3984207-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230622195247.3984207-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 2623b3dc875a3c92dd0e0775cd19fbaeef0574ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 412d070b31c3e4018afc6bb1712709df0464da48
Message-Id: <168748221325.12146.5481021113095300828.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Jun 2023 01:03:33 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 22 Jun 2023 15:52:47 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/412d070b31c3e4018afc6bb1712709df0464da48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
