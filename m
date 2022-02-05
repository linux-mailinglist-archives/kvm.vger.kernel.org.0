Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBA94AAABE
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 18:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380827AbiBER7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 12:59:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46950 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380816AbiBER7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Feb 2022 12:59:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFA95B80CAC;
        Sat,  5 Feb 2022 17:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A23F6C340E8;
        Sat,  5 Feb 2022 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644083967;
        bh=CGAwSsF+d1JCAM602DJ7DXSX3ofHbKXlLW2z0yqc8lU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=imWIbYZpoxZGebqXERyQIP95n5Y0OaICv5zXt3tLnkCyAeLwkSZmfwqnRyvUW1tpA
         AcmmjvhL954zNbbZN80PKRi1RV3AMVSajTERSiWEmw8pFPByVMCHivHR86fAOJw9AX
         v/8FTp+dxEZ7C3ab3pT8DN737ZUi0RGGllxd/oTP4S0W0dw+5Ro4rfLPgqmFHb0gEq
         aNgXqIaLpSWf34OVie0Lnh0dTFfSxtG4lLPJ5ZyMTEo2lkGPVJFGfwfN6bCR2HuMpH
         2Dh46CrphMM/Ln3wcY2FBSBPBs1A/ixfe2i+/ugbK4pykc7v47xS6zrNGpDo+aalEU
         VcTAMP02hW0MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90664E5869F;
        Sat,  5 Feb 2022 17:59:27 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.17-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220205060919.88656-1-pbonzini@redhat.com>
References: <20220205060919.88656-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220205060919.88656-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 7e6a6b400db8048bd1c06e497e338388413cf5bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5fdb26213fcb912955e0c9eacbe2b8961628682f
Message-Id: <164408396758.20735.17451039880823459064.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Feb 2022 17:59:27 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat,  5 Feb 2022 01:09:19 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5fdb26213fcb912955e0c9eacbe2b8961628682f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
