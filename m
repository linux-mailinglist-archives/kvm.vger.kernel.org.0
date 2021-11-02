Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847D34435B1
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhKBSj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235128AbhKBSjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 14:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62A5360F90;
        Tue,  2 Nov 2021 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635878240;
        bh=4k8zltF7QtFU40KJzcjW8RkZOwuYsAk/oXigcGixW3s=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=EKHJJqwPYPTclxE5smGYChekEQR+zI2ldTd3o/FXUgIUQGkJ+QOaUE4GGTYZyzl8Q
         mOn92C2qReLA6tXi0ij2o/rXI60CtNU1CBdOz8hl6QOWPsD/hHStE7Xd6k2mRw34zt
         fGllEqDl48PhrC2HJrRYzDd75RE5tInH21B0w4p88luHmsuEw238G8Jwff+q1mW+4s
         hX8pcDJFiJZr1ux627JWjiiFfBQAmGAfMckYJEAR+l1ifBw37JnwhS4PYfSXEfswHm
         N7g8mQZAAe+sRBzcXTxVye370wfIX5QhL0oMYgL/Wfzn9tULbwlkcOtZpaeVujuqkG
         +H1gupkGSCVaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5CD0260A90;
        Tue,  2 Nov 2021 18:37:20 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.16
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211102165331.599683-1-pbonzini@redhat.com>
References: <20211102165331.599683-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211102165331.599683-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 52cf891d8dbd7592261fa30f373410b97f22b76c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d7e0a795bf37a13554c80cfc5ba97abedf53f391
Message-Id: <163587824037.14475.14218836851153334665.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Nov 2021 18:37:20 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue,  2 Nov 2021 12:53:31 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d7e0a795bf37a13554c80cfc5ba97abedf53f391

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
