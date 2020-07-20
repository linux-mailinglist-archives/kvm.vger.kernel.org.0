Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A591D227000
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgGTUuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 16:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgGTUuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 16:50:04 -0400
Subject: Re: [GIT PULL] VFIO fix for v5.8-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595278204;
        bh=DIFaQftN44mIiB90bPH6hZbjxNtwXoghZ9cwipdluOE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zmacJtPF8i+9IuIbeg5f9FLyy0vAbGtTAWwc/r3Vck1/v4DUeNPrZkH0IE1OaN7ZV
         IDU30vWVgSJv014QmwGfsLsU+b2L5HkPqTuVgOVMupCy6p8KRBvNbc375p9zg34oJB
         PxRzKAq7PFMi+WI9fPg9hDia276eiGf2SYMr59vE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200720083427.50202e82@x1.home>
References: <20200720083427.50202e82@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200720083427.50202e82@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.8-rc7
X-PR-Tracked-Commit-Id: b872d0640840018669032b20b6375a478ed1f923
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4fa640dc52302b5e62b01b05c755b055549633ae
Message-Id: <159527820414.21281.8254818529301492915.pr-tracker-bot@kernel.org>
Date:   Mon, 20 Jul 2020 20:50:04 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Mon, 20 Jul 2020 08:34:27 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.8-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4fa640dc52302b5e62b01b05c755b055549633ae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
