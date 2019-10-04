Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61814CC297
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 20:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfJDSZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 14:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbfJDSZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 14:25:18 -0400
Subject: Re: [GIT PULL] KVM fixes for Linux 5.4-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570213517;
        bh=QGZox6xbIMsuMNoaAIasq0J3l383S2PGxwPLl9gcOe0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=KRWmk0T90ukMyRdRxKO7C61El0eK6PfR/LbsLoxg0DzYeFMmrrp1cMy4kGbqT5zNP
         wDkAen2byCRZc0RLuJqb69ftMxRuTJ6q51EJBI5oOt7UZOI/LNjzkX+lTuUNhV6gQK
         hFMCHBht9w2KylxPOKKLOVOa0r4qyuzXB0I7BSfc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1570190632-22964-1-git-send-email-pbonzini@redhat.com>
References: <1570190632-22964-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1570190632-22964-1-git-send-email-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: cf05a67b68b8d9d6469bedb63ee461f8c7de62e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b145b0eb2031a620ca010174240963e4d2c6ce26
Message-Id: <157021351787.30669.14363078739593690285.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Oct 2019 18:25:17 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri,  4 Oct 2019 14:03:52 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b145b0eb2031a620ca010174240963e4d2c6ce26

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
