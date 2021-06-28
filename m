Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F3E3B6B67
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 01:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhF1XjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 19:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhF1XjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 19:39:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5D7FC61D04;
        Mon, 28 Jun 2021 23:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624923396;
        bh=u6VnLbf3ZulenKFDKRRWSDU0BLQs2pttUgLwSu+cnEM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TOdZbzM8LgUT2Lszv2JIDHXEByO7KZF81e0s4LTEeMtNM6I+zlI/Ke+gy0326xlp+
         eUCvSwTk+0uGMIvtslhiLu2laGj56b/XtSzLhIa6jn2jDaTohXzmqnD9qtacvjOxIZ
         iTATB/kohcY3w0m5+XWWO4yZCH4W7a4YG9m5seel70LpFBtFx1ru5JJ0hvtJa1GhJ9
         ixuK/y44VjCgf+YkXywxQrHT9Io4pTCuJkdvHwNBUD6I4ZnQsnsWKQDDN7k0GJplk/
         54UktHg91acY8ducbpWsGQZSqubR5bzKQG2tWgg7UXZxP8tD/TmQ/TZju7T8Oltvxm
         5u8/m+t9JPG/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5767160A3A;
        Mon, 28 Jun 2021 23:36:36 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 5.14
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210625154805.133099-1-pbonzini@redhat.com>
References: <20210625154805.133099-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210625154805.133099-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: b8917b4ae44d1b945f6fba3d8ee6777edb44633b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 36824f198c621cebeb22966b5e244378fa341295
Message-Id: <162492339635.13806.1858328284331539337.pr-tracker-bot@kernel.org>
Date:   Mon, 28 Jun 2021 23:36:36 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 25 Jun 2021 11:48:05 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/36824f198c621cebeb22966b5e244378fa341295

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
