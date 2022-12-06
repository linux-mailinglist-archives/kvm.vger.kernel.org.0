Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B45644C32
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 20:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLFTHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 14:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiLFTHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 14:07:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD43FB88;
        Tue,  6 Dec 2022 11:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 830E8B81B2A;
        Tue,  6 Dec 2022 19:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25C2FC433C1;
        Tue,  6 Dec 2022 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670353625;
        bh=k1zMCqE6WM9qu/H39+GrK9UzoSRuEYVThlPe0f88+xk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LSKj2NQqNP0dC5SCIZ9OM+YHFRfdAfjeeukwq4XI6lcdC++ZAMy97BeGawi706JXd
         EEn7b0+zJU4g6zv8B2uovvgFRtD+BH1kuwDB2WLMWZILtOU3v81YrmzBnYDzeHvAoL
         IAV+Aic4zWPiHUDEfZjNlQAF1x9o+/ACqlnIC/86KF/JkG2mS+Eq75e06WtvdkMvZK
         m9L8j3LHGSLP2JJLWEWQTlahnpBJrKczR1dwQNF2/VDD39AqQKs4oRmWMYg0h8sHsC
         +6lZriGDVNvDcCHCplqB+ERJkMJTxNdwvyZwPLTRO9pTNNAfuMdzlQSvSInQ+nZ15J
         Mwba0G3mWHKUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 136CDC395E5;
        Tue,  6 Dec 2022 19:07:05 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM changes for Linux 6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221206164825.1758138-1-pbonzini@redhat.com>
References: <20221206164825.1758138-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221206164825.1758138-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 34e30ebbe48cc43c14276f863f0d2995c8f13186
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5b3e0cd872b09c3c771e19464db9dfc20972c39f
Message-Id: <167035362507.3568.11876447268854852394.pr-tracker-bot@kernel.org>
Date:   Tue, 06 Dec 2022 19:07:05 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  6 Dec 2022 11:48:25 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5b3e0cd872b09c3c771e19464db9dfc20972c39f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
