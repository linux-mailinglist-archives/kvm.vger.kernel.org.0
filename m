Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5EE70B096
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 23:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjEUVE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjEUVE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 17:04:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA253A9;
        Sun, 21 May 2023 14:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC2D61490;
        Sun, 21 May 2023 21:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDCC9C433EF;
        Sun, 21 May 2023 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684703091;
        bh=aYTHEYBv9My7k+N0vuUH1PkTKiMCJmNQbq/pOMdaLSU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=h6Z7IuxeAxV6P/vzsY/lo4BD/rSf3quhS2nlOqnSPheMo09XHMKEIXtqyegiGgri1
         34BAjGVNEttZxMO/AcVafwDNLZOsoiKlbhG4/2xk+b2UqmS806M/hZVl4GJ0SoXrPT
         ac0bE6ikds6qyLNe33hC6H14Fc5+oXwoZgj0UucxIFckK9FKE9BHAcgtiSBm2PS9HH
         nRt3W4TwF51cuNSPAO/czj8wH8algMFcnJDsPWn+HMP6KD82d2fPza00f60bkPPvDn
         J7FofGpL36W5PdkiwTI23jrZXd99mWvrxAmsdSPKneJpHgjbswwNS+GvCW91y/0cD6
         AQbRp3HGI2z4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAF82C3959E;
        Sun, 21 May 2023 21:04:51 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.4-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230521121715.45809-1-pbonzini@redhat.com>
References: <20230521121715.45809-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230521121715.45809-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: b9846a698c9aff4eb2214a06ac83638ad098f33f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a35747c3107ebb8ef2749d4dabaf71c205e0d0fe
Message-Id: <168470309169.10838.5484370570701734009.pr-tracker-bot@kernel.org>
Date:   Sun, 21 May 2023 21:04:51 +0000
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

The pull request you sent on Sun, 21 May 2023 14:17:15 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a35747c3107ebb8ef2749d4dabaf71c205e0d0fe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
