Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D96DB99E7
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 01:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391468AbfITXA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 19:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfITXA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 19:00:27 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.4-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569020426;
        bh=ohXvMkhgOssbGFzFsH3WYA8GivXmapSr+T3y1U1LNQs=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=CiYDFxbqXEkwQTLYqU4JGm58WZqZNiiub0WJNLkTylTv1KK9/xCVUPLtc+1MaKEcH
         krwSlpcougQfMRkEIVP1cRovP5AGEkiNjpk1OmdZBpmuHe5Ckd9xHTdQ6KZ6E4wj90
         nzzgFlrgd84jNbWaAT7NrsGebK07xsQpUVJqb5g4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190920151226.541871fe@x1.home>
References: <20190920151226.541871fe@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190920151226.541871fe@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.4-rc1
X-PR-Tracked-Commit-Id: e6c5d727db0a86a3ff21aca6824aae87f3bc055f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1ddd00276fd5fbd14dd5e366d8777dcd5f2d1b65
Message-Id: <156902042693.31413.16973837338352473872.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Sep 2019 23:00:26 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 20 Sep 2019 15:12:26 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1ddd00276fd5fbd14dd5e366d8777dcd5f2d1b65

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
