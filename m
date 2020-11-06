Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342D2A9EED
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 22:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgKFVNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 16:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgKFVNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 16:13:23 -0500
Subject: Re: [GIT PULL] VFIO fixes for v5.10-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604697203;
        bh=Fw23+0OsxcBrqf1MpJP96N4jzfg0u8Irl5O9gb3+5UI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=a8bD36s2x8AwoGFUdmnyFxmd9GOnqikWgyGNQzmjW7FD/47qpdZbG7VJvLlDZwHWs
         iIbs1gupxflwYWI6tEuL3xJR4wfY6JSVx2OlPixPvnECGS3m85eHFR2Gd3HmfGaN5v
         E+dMjyv0X4i9QQkKkA6cmc6vaK0vVo3AMNYp/QYk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201105135157.72abcadb@w520.home>
References: <20201105135157.72abcadb@w520.home>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201105135157.72abcadb@w520.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc3
X-PR-Tracked-Commit-Id: e4eccb853664de7bcf9518fb658f35e748bf1f68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1669ecf9c884c639c4a83859e33a24d892aec790
Message-Id: <160469720329.14190.11091433669088855193.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Nov 2020 21:13:23 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Thu, 5 Nov 2020 13:51:57 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1669ecf9c884c639c4a83859e33a24d892aec790

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
