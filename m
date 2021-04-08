Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F20C3589A3
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhDHQYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231947AbhDHQYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FD19610FA;
        Thu,  8 Apr 2021 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617899059;
        bh=5yVDw97r+W3UAYEtiyd7UV2JG82lLri5LGmgp9ecdaM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UlTcMpQkonYozgNFapLmnRBLmGhpJQ5BcOAsI1UdnHQdsa06KcnWdME6OQ6azH01n
         SwTUo5M3twQbCnTy9q2iLf+gjfnFUhL0CJ9T+PwLjocJJEn6/iFVP/szIx4Je2ZQZo
         jHPvHoZLObfIOOMVPO+S5U0RUQzpu128nRh3K2nWbEHXOC6WzsTA4WIUvrjTg2h86S
         P/D4SqicdCXvMcEhMGMSGeJwIJq+PHaGlQkZSj3JXY6BGmOlNzheHnYkcRoRG1Hxmv
         hczFsGKYn81N4VhjxlA8VnFXBghxJJueiM6jteTfVLxTkoQPr0YF9gX1BGzj1gTxgv
         LpX5uXu2dgLwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 99B3160A71;
        Thu,  8 Apr 2021 16:24:19 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 5.12-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210408121234.3895999-1-pbonzini@redhat.com>
References: <20210408121234.3895999-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210408121234.3895999-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 315f02c60d9425b38eb8ad7f21b8a35e40db23f9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d381b05e8605f8b11913831e7f3c00e700e97bbc
Message-Id: <161789905962.11255.14816713986713618304.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Apr 2021 16:24:19 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  8 Apr 2021 08:12:34 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d381b05e8605f8b11913831e7f3c00e700e97bbc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
