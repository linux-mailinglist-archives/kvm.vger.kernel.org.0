Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11531F0169
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgFEVPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgFEVPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:15:13 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591391713;
        bh=oQyLIewFNpzlOjQ4PSj3b5+ZFwBGdhdTDF8msLILm7Y=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=A19tFT7e/51ajS9JHd6G9i8DE1u59Ua5/ziYBfQjWe8DAWrBeoPlHYg6aOohjEJsX
         6UwZKqMi1B/F8T7tnULTdsBKRHmIMwhYbjtWjzJbqIUa02zVMQnKP4s2RFp8Mst4uL
         6Wh2JRl236NgdTCgMgFOfDNeFJBwK9Ac1DhCJmX8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200603112304.017a7954@x1.home>
References: <20200603112304.017a7954@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200603112304.017a7954@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.8-rc1
X-PR-Tracked-Commit-Id: 4f085ca2f5a8047845ab2d6bbe97089daed28655
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a36f0f3f518c60ccddf052e6c48862f357d126f
Message-Id: <159139171319.26946.16668090218308110642.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Jun 2020 21:15:13 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 3 Jun 2020 11:23:04 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.8-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a36f0f3f518c60ccddf052e6c48862f357d126f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
