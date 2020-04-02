Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E319CD01
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390369AbgDBWpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbgDBWpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:45:18 -0400
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585867517;
        bh=PakBf7akxskSU99wEll/YnEXc+/sHzL3yLGiah2X1Eo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rEEiZH4aZaLm1RD55uQdwPICiMtiZXHtipGrGLhnkAdW9VLQbpCSQ6o+rLpjfISkV
         oEJLSihxXkVK3k2JVdk8ampcHA94pm5i4q68SNyETUg6b18P5Jv9RDtK2XX9ERTzrN
         XTviZgoFNGakSkRWQiV+1dJcXfXD2Kz3t1XGzEM0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200402192243.7186-1-pbonzini@redhat.com>
References: <20200402192243.7186-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200402192243.7186-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
 tags/for-linus
X-PR-Tracked-Commit-Id: 514ccc194971d0649e4e7ec8a9b3a6e33561d7bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c1b724ddb218f221612d4c649bc9c7819d8d7a6
Message-Id: <158586751768.2810.15790479518784305948.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Apr 2020 22:45:17 +0000
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu,  2 Apr 2020 15:22:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c1b724ddb218f221612d4c649bc9c7819d8d7a6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
