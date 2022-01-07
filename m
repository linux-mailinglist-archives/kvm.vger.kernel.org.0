Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE4487B7D
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348598AbiAGRez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240283AbiAGRey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 12:34:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7AC061574;
        Fri,  7 Jan 2022 09:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C83E61B14;
        Fri,  7 Jan 2022 17:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5E0EC36AEB;
        Fri,  7 Jan 2022 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641576893;
        bh=8krBx1gytrosmbWC84kskE4gFrWWCO1541DVkCCNRLE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lRnQp9Z9iXvVTdznQC5BkAyeD4paQwNX/M6NeqABokY3i4++CbGh6DTTtRdTErjEc
         8W4KZl6hp3R49NoXRoeortvJVNdOi//6M28qPjT5r7VU0OZIFH0ymxTgVMzvDmmTDL
         iNsVocsGB9QnANstc2IdOM47ikMhgTo05BJy4QHeNGWPfjUiIz/waIjacsafQe9IwB
         uToRcidOPp3h9kFJcewzrqyTm0H0EQzcn2tI0nOcEcWtDEH7FbJJZZoFFfg7O47bru
         o6j/ehmlbyUts0xLeNZdnPtVgaHDHA8z+GErq5p/m3ccP5OEdEdUyruyJmBXYjQWyV
         YFv6EEqBIRByg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B418DF79401;
        Fri,  7 Jan 2022 17:34:53 +0000 (UTC)
Subject: Re: [GIT PULL] Final batch of KVM fixes for Linux 5.16
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220107170940.653733-1-pbonzini@redhat.com>
References: <20220107170940.653733-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220107170940.653733-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: fffb5323780786c81ba005f8b8603d4a558aad28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 24556728c305886b8bb05bf2ac7e20cf7db3e314
Message-Id: <164157689373.23528.12594335132424607706.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Jan 2022 17:34:53 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  7 Jan 2022 12:09:40 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/24556728c305886b8bb05bf2ac7e20cf7db3e314

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
