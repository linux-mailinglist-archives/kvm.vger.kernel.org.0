Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193F72965AE
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 22:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370540AbgJVUEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 16:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370530AbgJVUET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 16:04:19 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603397056;
        bh=/usABYf/Rlci7Bx6r2eKk/L+8XV9hQo32Wmk/fov9P4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=awrBl1bc9YYC+p1cBM08vh2UqAvDssGeI+KyTGfcCWhVR3RpHk4ULe8BkYigBHkOm
         x9LTAMC3z4U0I5e417V/5BIr/gIfbsR+DhtWXlrCPzM4/3593A8FvkpJ2fsszPWOA2
         mDfELBJecrBCxvbtgXal7nNz45/9EUj0Dtt+5WyA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201022115157.597fa544@w520.home>
References: <20201022115157.597fa544@w520.home>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201022115157.597fa544@w520.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc1
X-PR-Tracked-Commit-Id: 2e6cfd496f5b57034cf2aec738799571b5a52124
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc996db970a33c74d3db3ee63532b15187258027
Message-Id: <160339705673.15216.180072999117409116.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Oct 2020 20:04:16 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 22 Oct 2020 11:51:57 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc996db970a33c74d3db3ee63532b15187258027

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
