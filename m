Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C5E2EBF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438726AbfJXKZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 06:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407344AbfJXKZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 06:25:07 -0400
Subject: Re: [GIT PULL] VFIO fixes for v5.4-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571912707;
        bh=9ua7zFuiH5fKqiw1gYBXsuFyIEUExKT/bxIiD1Atahs=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=L2IfEz65TP0NqHo5Hqrpgv7zQOOnPpDUHTFUnx1U2wndwn8pg5Y4jdtYpj+TBnbZk
         uxXKb4f5uQ36OZNyzL4bxU4hM2kGdn196NCL0Y8AjAHxk5zf+x5WdouakH5X9EKGay
         YJIzWxrsb9UKND+G4Fl+s27KZ4w3ZJHnLC5r1n+M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191023110822.6122562f@x1.home>
References: <20191023110822.6122562f@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191023110822.6122562f@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.4-rc5
X-PR-Tracked-Commit-Id: 95f89e090618efca63918b658c2002e57d393036
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64131618e8c8a1d5c1470d4d788214f6d4b43cde
Message-Id: <157191270740.16083.17616593345898198780.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Oct 2019 10:25:07 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 23 Oct 2019 11:08:22 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.4-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64131618e8c8a1d5c1470d4d788214f6d4b43cde

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
