Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9931467F09
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 22:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358974AbhLCVGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 16:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243206AbhLCVGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 16:06:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B26C061751;
        Fri,  3 Dec 2021 13:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C1F9B82958;
        Fri,  3 Dec 2021 21:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48482C53FCB;
        Fri,  3 Dec 2021 21:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638565377;
        bh=LLXZLQbHwT3AlxfaBOmz4VHwls9ttIGOTI57YT0CMmE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VGJ8XOMsSQbCE7nbwbh8Sm/5NnI056/1l+HgjOalNQl3Pv+CDE7KXJcmuXDb2pUmE
         bc5dV6mA75pui0ZBScHvOLxjzXDZm1T6Yutqm3Lz/1sNDidKp6Yt1aQUkGUtXcs1OG
         dhzK0CNJwenmJqA0CGzyMr94NvIJiK9Q6xE1G9kh3kNgSfhB4Si2P2jmiENx09tJkR
         yv/GNXcjDebPVdv6E/zhdym2iPlw2szRANSUhyVBGBeUC2neTdvVnK284cIuyPQNSy
         RsuCuvq4rQ7y2PcQ+y+r8NRNC0KcqAeYGcojnkOA8ys44mf3iR7vCrkbCwpZfLlMLi
         JTQcNTfjO306A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3252C60A5A;
        Fri,  3 Dec 2021 21:02:57 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.16-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211203131803.7fb40f46.alex.williamson@redhat.com>
References: <20211203131803.7fb40f46.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211203131803.7fb40f46.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc4
X-PR-Tracked-Commit-Id: 8704e89349080bd640d1755c46d8cdc359a89748
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 12119cfa1052d512a92524e90ebee85029a918f8
Message-Id: <163856537719.7508.10680291123254494117.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Dec 2021 21:02:57 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 3 Dec 2021 13:18:03 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/12119cfa1052d512a92524e90ebee85029a918f8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
