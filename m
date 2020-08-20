Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BAB24ADED
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 06:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgHTEmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 00:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgHTEmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 00:42:16 -0400
Subject: Re: [GIT PULL] VFIO fix for v5.9-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597898535;
        bh=JCJwEh+pvWXAwmuka6F/zKcU8KQZ9rz00Az2wUHTDrA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qbrVBIL7xA39n0zYp3qn9IrQP8glP8rxmTcu5C0bH6K3TXCtN67yRSHpWXlCXu1+7
         UAvRsoXDPvT1INl2M/f3l2s65QcBY670QybkJcPSTOeEwTkmdUGyWFzAy1cDy+CM4k
         q/qaYG9t7eXw6oDb9ojvki7fHalvssL3CJOu4Fjw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200819130422.357ea56c@x1.home>
References: <20200819130422.357ea56c@x1.home>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200819130422.357ea56c@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc2
X-PR-Tracked-Commit-Id: aae7a75a821a793ed6b8ad502a5890fb8e8f172d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7eac66d0456fe12a462e5c14c68e97c7460989da
Message-Id: <159789853523.19113.7573931403105003828.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Aug 2020 04:42:15 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 19 Aug 2020 13:04:22 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7eac66d0456fe12a462e5c14c68e97c7460989da

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
