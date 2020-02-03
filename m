Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507FC15126C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 23:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBCWfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 17:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbgBCWfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 17:35:18 -0500
Subject: Re: [GIT PULL] VFIO updates for v5.6-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580769317;
        bh=/4rid16jfCwgrNyPfrTnkrlU6xZyx5EXx7reLI1Pzc8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=aep98udM8LdvEJKO7LPYraQbg7v1XL8IOwt/JRnwWlj/0cylHbeDakbpqVGhCB+07
         CCb+CFD9Gy6IxNK4AU9j/JmU9eNHl0n8eeFZQbvH2/R69472+NHrcUit0HPt91ViBy
         BPDC/qxpvxOkWFu32qNlkOfbntqFGhQsPnZY1RyM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200203134037.2fda624f@w520.home>
References: <20200203134037.2fda624f@w520.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200203134037.2fda624f@w520.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.6-rc1
X-PR-Tracked-Commit-Id: 7b5372ba04ca1caabed1470d4ec23001cde2eb91
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a6d5f9dca42eab3526e2f73aa5b7df2a5fec2c9d
Message-Id: <158076931783.15745.4248247112744305708.pr-tracker-bot@kernel.org>
Date:   Mon, 03 Feb 2020 22:35:17 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 3 Feb 2020 13:40:37 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.6-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a6d5f9dca42eab3526e2f73aa5b7df2a5fec2c9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
