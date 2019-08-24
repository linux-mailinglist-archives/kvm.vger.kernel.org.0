Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C39BF5D
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2019 20:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfHXSpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Aug 2019 14:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbfHXSpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Aug 2019 14:45:09 -0400
Subject: Re: [GIT PULL] arm64: Fixes for -rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566672308;
        bh=7Qs4bkWflVG2mFrf3I3eozRzQTQ5YMm/Ki/3Id1X/AI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nIAB4BxMmxWEosyKv10E7oJVldQ05MeERhSeCglIKLgjWljr2Wy5JQY1UX+ndUgn3
         85W+dw4yr9dwMkmlTWdwamz5jUpmnBygOpzNglxppFzcLo+q912QCdTpN1keUHwAiy
         1qqAgCYxQsCP+OOZr+dEFbmf7yhi9qeIoQBh2hQQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
References: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190824121255.ojqt7tjlzfp5a3nw@willie-the-truck>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
 tags/arm64-fixes
X-PR-Tracked-Commit-Id: 087eeea9adcbaef55ae8d68335dcd3820c5b344b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a022eccf7c468efcb8aa5192b8d13e20127bbac
Message-Id: <156667230824.2337.2969578272613309440.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Aug 2019 18:45:08 +0000
To:     Will Deacon <will@kernel.org>
Cc:     torvalds@linux-foundation.org, catalin.marinas@arm.com,
        marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Sat, 24 Aug 2019 13:12:55 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a022eccf7c468efcb8aa5192b8d13e20127bbac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
