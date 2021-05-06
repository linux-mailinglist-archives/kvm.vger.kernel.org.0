Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444D0375CEE
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 23:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhEFVmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 17:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhEFVmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 17:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 465EB61077;
        Thu,  6 May 2021 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620337291;
        bh=FY/ocjRlemocM3ziqWePXGxR0o2RJSQymV7kU0n807M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rO7kh0E2QsMpEffj1Zhhv/6ohCG0QfLoUBum4DPIE9Hfv/1fhTK5EldCCNIuFEzLd
         jVlN2qskYkt8lxY7AudBCgL6IlXfPt3VqMNOIENm0x65yx160rE/3fbN6YgUTsIdk6
         4lnd1rh/Fc0gVsxqei3j9TEK+IhOyCzng9X9+jTHAdwdEcr3g9CxgloIgcMWU7AUIx
         55IM1ejUIkyqZTCHGtYHoP+/syRR3C6Ki+punBb4McPBp0C+FmP/lAPrfid4i9lhFH
         nDLqjYKCGdPU56DZPufCH8hEWFRaL2iGm7GiLE9bdsDm+1mO+fNTR36K1dugRtfbWL
         Aq8OHrhB1YMog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 407A7609E8;
        Thu,  6 May 2021 21:41:31 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.13-rc1 pt2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210506123111.6b6c0bf3@redhat.com>
References: <20210506123111.6b6c0bf3@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210506123111.6b6c0bf3@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1pt2
X-PR-Tracked-Commit-Id: cc35518d29bc8e38902866b74874b4a3f1ad3617
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a2de4bbddce3e98bd2444bb027dc84418a0066b1
Message-Id: <162033729125.2467.13311999969059190277.pr-tracker-bot@kernel.org>
Date:   Thu, 06 May 2021 21:41:31 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, hi@alyssa.is,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 6 May 2021 12:31:11 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1pt2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a2de4bbddce3e98bd2444bb027dc84418a0066b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
