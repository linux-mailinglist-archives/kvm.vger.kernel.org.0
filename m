Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8CA4567
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 18:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfHaQpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Aug 2019 12:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbfHaQpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Aug 2019 12:45:09 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.3-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567269908;
        bh=vubgKTpg5td5IeaSwB94NLqghhYsAWgqbVw40GiyhJg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=UJ1BchBbPQ751dZfaNv+ExXw4xwNDNOQXkBdtD8Ydi8jXJmm+u2nkl/VUkpVehri8
         ytLMzWW9IIAJ98aVQwwufkA0EHBXxgDm1vyrF5uCrJt29k/6hkDm11pGtXViEQsd28
         lMtGFrH26I1VZ4kGiG3z0N0Swtx6hUaC1X4VWe8Y=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190831022626.GA453351@flask>
References: <20190831022626.GA453351@flask>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190831022626.GA453351@flask>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/virt/kvm/kvm tags/for-linus
X-PR-Tracked-Commit-Id: 75ee23b30dc712d80d2421a9a547e7ab6e379b44
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 834354f642adfe7bb6d5dba5f7de6ecd3150fb2f
Message-Id: <156726990822.25629.14623210787018605059.pr-tracker-bot@kernel.org>
Date:   Sat, 31 Aug 2019 16:45:08 +0000
To:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 31 Aug 2019 04:26:26 +0200:

> git://git.kernel.org/pub/scm/virt/kvm/kvm tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/834354f642adfe7bb6d5dba5f7de6ecd3150fb2f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
