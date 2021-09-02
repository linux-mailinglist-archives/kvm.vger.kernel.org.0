Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD923FF529
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhIBU43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhIBU42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E98260FC0;
        Thu,  2 Sep 2021 20:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630616129;
        bh=ctEN46C7hU0k3XCjFxpy+myKCJa2ov5i1NnH7bGbI7g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cYO/DK+HbUGZeBhyA3YWRqzV2mQZdMFwg9bffRqroTJ5uQkbEikxuwSpK4bcMB7rW
         CGdIM/aoNrdAd9+B1Bi33xlxx8XVzVOEJWzi0AmzMuFhzguONi9orFoO4PAqOa5KAj
         knVir3uUvJsO6DCoPY8dgVKpYDrVrB8Hyr8PxIVlodgnzIGHZFhwRrws1cKUem3Vj5
         fVBRKsO0ogI65ZrvpL4CWdtjLW+dXvEipXCFm6u+EdlD6o+CgK7g+g7EBVZZontaPl
         xUv9fmqHnYpkUrpMbDrOI6ScYnrUU+PArrCV9sl7PNhBmTeq4nxb929gBQi0Ns/u8D
         oryHoB9yBww2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D90760A0C;
        Thu,  2 Sep 2021 20:55:29 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO update for v5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210901130821.6c81da7e.alex.williamson@redhat.com>
References: <20210901130821.6c81da7e.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210901130821.6c81da7e.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.15-rc1
X-PR-Tracked-Commit-Id: ea870730d83fc13a5fa2bd0e175176d7ac8a400a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89b6b8cd92c068cd1bdf877ec7fb1392568ef35d
Message-Id: <163061612952.4397.4445309581412678319.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Sep 2021 20:55:29 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 1 Sep 2021 13:08:21 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.15-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89b6b8cd92c068cd1bdf877ec7fb1392568ef35d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
