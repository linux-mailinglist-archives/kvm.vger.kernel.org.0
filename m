Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B89F3ABD54
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 22:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhFQUTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 16:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhFQUTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 16:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A2D161026;
        Thu, 17 Jun 2021 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623961031;
        bh=ni5L8ASMyGlatUBZrcCiRjK0h+RkTYYiREk49Aupy8Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=km/HCML1GlDPyJ98mi7zHhil0siGTwI0OXeHaC757HFlE5SdNajGe+kxI6TWxa1eR
         7sFL/Kb9sgKUmwdXm5JfkA2QAWS9nnMc0Wg0oSF1WxMXN3lm8RlypTf2bCeSZAUVGx
         iOZ3BLiR8Liq0QD6+SoDu2ht1JKDPP8N9CABtCTGPNGo5Q4/jmsr+A9oeFCMWyKAIG
         t33F6C/PQtQnsPGYxGy9JXhevNExEEnMSYdItg0z6XvVREfwGnx9nsU5uc8efhH1YG
         HPb705+3bBtIuJaGiPEdHpgFCMSJj9SNUeNq5swtek8MJcGbCjIepVPSPFb7YuACc7
         yvYb7gBmKZ8UA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 36D83609EA;
        Thu, 17 Jun 2021 20:17:11 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.13-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210617183603.844718-1-pbonzini@redhat.com>
References: <20210617183603.844718-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210617183603.844718-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d8ac05ea13d789d5491a5920d70a05659015441d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd0aa1a4567d0f09e1bfe367a950b004f99ac290
Message-Id: <162396103116.22648.4631664208754684417.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Jun 2021 20:17:11 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 17 Jun 2021 14:36:03 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd0aa1a4567d0f09e1bfe367a950b004f99ac290

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
