Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DAE3CAC5C
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 21:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbhGOTdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 15:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244996AbhGOTb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 15:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BEBF86127C;
        Thu, 15 Jul 2021 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626377307;
        bh=4HWM4tpcP4pGITadY2F28bkjO35bnPSOJYeCWAN8R8w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hJv5h5awS+ve9SLdUyYrLK0qJLJWqk715qJHX2CMO1iigG9XZCXCi2jpwwxssdzUi
         Er5mIj/JB2DDISiA+udvXllJWC/xoDhgtu1l8x7KAtNIJX9coWDor9WdqC1B9Q2YhD
         Qz7EPnAPZsvh04ix3bTiH0vjX6FnxI3Hai61jmPUxcNBlpDj8BgWjpt+Ocz5fSyk+4
         eF4Vuc87XUxyUrJ6cP05et/Yq8TQBXVv6nFvoLXKgZYiLijggQ9Zuod6YAdlk1aLRq
         CYrYukGG3x3ZkWGmI2ubmjzsrhTJKSypUN64gP7rLOsy5+4hpnH5SkLR2wJqWm0cRq
         /kid0+HEX0Rjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B738D609A3;
        Thu, 15 Jul 2021 19:28:27 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 5.14-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210715144159.1132260-1-pbonzini@redhat.com>
References: <20210715144159.1132260-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210715144159.1132260-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d951b2210c1ad2dc08345bb8d97e5a172a15261e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 405386b02157ea1ee49ecb6917c2397985bb2a39
Message-Id: <162637730774.11736.1500213796241321822.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Jul 2021 19:28:27 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 15 Jul 2021 10:41:59 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/405386b02157ea1ee49ecb6917c2397985bb2a39

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
