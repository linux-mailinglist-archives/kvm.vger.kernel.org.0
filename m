Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192F2B6A62
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388071AbfIRSU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388059AbfIRSU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:20:28 -0400
Subject: Re: [GIT PULL] Urgent KVM fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568830828;
        bh=qmSdnSCl5TAzbeKhQgoNzjjdohfHSOvn6HhX7YUzSPk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=AcQTp9yQWkAFV/gsDmz9l2hpAXaFhXXNP5OA2l7Hb0951/Xl0HD14ByN7yaCIROs3
         7nhS+XWQn0KHgYBa6c6MdUIHZTxQ6USiGYEcYqK0erW5+PnvAy5WEl/jJ23P1bzlPf
         73cYON8deZMNPZm3Yh3fo3jvRptDYX6sGuRM5hIw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1568816553-26210-1-git-send-email-pbonzini@redhat.com>
References: <1568816553-26210-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1568816553-26210-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus-urgent
X-PR-Tracked-Commit-Id: b60fe990c6b07ef6d4df67bc0530c7c90a62623a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 404e634fdb96a3c99c7517353bfafbd88e04ab41
Message-Id: <156883082807.23903.15600463358497393396.pr-tracker-bot@kernel.org>
Date:   Wed, 18 Sep 2019 18:20:28 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 18 Sep 2019 16:22:33 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-urgent

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/404e634fdb96a3c99c7517353bfafbd88e04ab41

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
