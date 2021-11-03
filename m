Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864A444498D
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhKCUeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhKCUeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 16:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41C346109F;
        Wed,  3 Nov 2021 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635971503;
        bh=TZE9ZmMDlHYSGyNr/pxQ26OIeIt6CwqmjPg4SSMxe7M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oWArRgH1d0Ph+gmu5JRUrJcI7vmu53OAj94RGCxfnYxhS9SV04B+JthGKNtLyzq41
         JA5FcG0YiNTzYJe2LUTLM4F+I+cZM4/G91KdZSEQgtq8jIrAikvYlN8ICcpt5p6l/f
         dSqtGMoP1JgtgxF3jQm6SEL241d+aFiD0pt7ATzHGebAgb79Go+ZeOkqQDP27FH0rM
         sxXF29I19DlfB8NIYZbO2sRIgDuAzmyoBdHOV8y7FOrKM7fWNPCz26RR+FLc/LY47M
         BoU9OOZReGzU7C8dswxy2Puf1h+OEB9+gRaEjf+z7mKrCm6qwLJlRSMd0AhT4K1DK3
         BmHLaCJNh6U9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2821360173;
        Wed,  3 Nov 2021 20:31:43 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211103140252.475e4543.alex.williamson@redhat.com>
References: <20211103140252.475e4543.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211103140252.475e4543.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc1
X-PR-Tracked-Commit-Id: 3bf1311f351ef289f2aee79b86bcece2039fa611
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4ec3d5535c784c3adbc41c2bbc5d17a00a4a898
Message-Id: <163597150310.28710.9869937319599215136.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Nov 2021 20:31:43 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Colin Xu <colin.xu@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 3 Nov 2021 14:02:52 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4ec3d5535c784c3adbc41c2bbc5d17a00a4a898

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
