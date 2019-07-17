Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4756C0F8
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 20:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389102AbfGQSaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 14:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389084AbfGQSaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 14:30:18 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.3-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563388217;
        bh=MTxNpKGoIn42yUyBGZCUJ+12p65DnLhbZOm3QUDj3SU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1/0vHMJfvwZ6sICTwXl47Tvdvv9w83847BNCp41z7q8lj7Rbp1V3q7Q3BPn7/klGd
         02DV6W/9P+ebHj5jbOWYIOctmhdPu7h7XnX+fiOvmFtNCph/gr0/6OfUZUir+sOu9T
         PRy7Jb2fWc0K3G81g7eRfztNN03VtUjpZGlJqHT0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190716091815.74662138@x1.home>
References: <20190716091815.74662138@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190716091815.74662138@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.3-rc1
X-PR-Tracked-Commit-Id: 1e4d09d2212d9e230b967f57bc8df463527dbd75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 37d4607ebbbf5d8b74cbcb9434a5ce6897a51864
Message-Id: <156338821753.716.9809168070958100900.pr-tracker-bot@kernel.org>
Date:   Wed, 17 Jul 2019 18:30:17 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 16 Jul 2019 09:18:15 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/37d4607ebbbf5d8b74cbcb9434a5ce6897a51864

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
