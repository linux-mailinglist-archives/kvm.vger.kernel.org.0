Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA44E676C6
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2019 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfGLXUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 19:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbfGLXUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 19:20:18 -0400
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562973618;
        bh=5fnjQnEkilAfDp9J/VYRnGM31rtO2XqtGYhBIQgrLCE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zskheKRk4oPMgxOKyuSikDQjP6otuY3WPDH/kXowdWpiogrpoHqrZ1Xzm9Ih2TEm/
         p0bnA7UmLnVdHAQ8JZRHrKjKJQYHtg6rgRNNq4L89FiJPvOAzI6et8V+KVad6IhlAb
         ymEzYdG8O6/jKjp/BbrpiWju1T+OylUrjbVKWYbc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1562953464-55786-1-git-send-email-pbonzini@redhat.com>
References: <1562953464-55786-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1562953464-55786-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: a45ff5994c9cde41af627c46abb9f32beae68943
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39d7530d7494b4e47ba1856e741f513dafd17e3d
Message-Id: <156297361804.22922.5531872921368121742.pr-tracker-bot@kernel.org>
Date:   Fri, 12 Jul 2019 23:20:18 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 12 Jul 2019 19:44:24 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39d7530d7494b4e47ba1856e741f513dafd17e3d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
