Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C0857F0B3
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbiGWRjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Jul 2022 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiGWRjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Jul 2022 13:39:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D1D1EEE0;
        Sat, 23 Jul 2022 10:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76A55B80932;
        Sat, 23 Jul 2022 17:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4106CC341C0;
        Sat, 23 Jul 2022 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658597991;
        bh=4PVQfkKHX1G16Txlbn9b4hbUNsINR1Er7i6tRdMljtU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MUqu63Ht0kdn4YJXZqCpgI5g2akXcTRmwoxFXEn5amggM6xXMxW9+zEVXUejiSmQ3
         Wtm+1LP9R71LaOxU43H5eeSA4cdxavhHO7gDiTjxsm1b/Erc6sPORVhfO/Rv4lz+1Q
         F17j76mBtpnAgS+3FDZheRVm5mXyvr3ZHHSkCsUD1gAhueQWVZwmMOky5xLaDo+6ca
         iSa92Rj+TtrAhO50NgDZOIIQsT0wb59dVybn6pf4lqPGv8wAiQB0C4T6PtE4KLRx5t
         R9NfFcAGIu6vvgITQtN5MwYSePlMA3TO2saGGXt4Xd6naSppGiixvWgIMVvloVhmMc
         zEBk60+h+BLGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EA3DE451AD;
        Sat, 23 Jul 2022 17:39:51 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.19-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220723075159.865703-1-pbonzini@redhat.com>
References: <20220723075159.865703-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220723075159.865703-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: cf5029d5dd7cb0aaa53250fa9e389abd231606b3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 515f71412bb73ebd7f41f90e1684fc80b8730789
Message-Id: <165859799118.12882.6470261065437416576.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Jul 2022 17:39:51 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 23 Jul 2022 09:51:59 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/515f71412bb73ebd7f41f90e1684fc80b8730789

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
