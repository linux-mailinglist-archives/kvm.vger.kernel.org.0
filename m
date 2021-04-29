Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522E636E299
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhD2A1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 20:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhD2A1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 20:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B34761440;
        Thu, 29 Apr 2021 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619655978;
        bh=3jYmgH1z5j4FafSRh8M7TWEvQtyqmhvC+64UH+2imrc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uJDHTqy5KPYni2z01eRvbvoJmIwBnrNk/+TEkvzgFIKN8cuTg/KzXmUnYfAjKe6Ce
         k0JPaVZttV2y6ueohqEIe9ZQPwQY4VTph3I3+e/QX1fovzdMsWlzgr4w/UR48yymd0
         431AdeuDaDkDPaAQNM0Ivj7OEIxCh8sID+RoSgnIKVtwplzkOxQuQwWl5tAelgUCz0
         /rLxIyDY8NVsgF1tOAoBleWmKT8qMCLuBFept6sFKcaJG5BULJCk4XHfYTOOi99Vpi
         aeDxHkkO2kbt8/Iy0WpUUn4QKwCANbFprxgvLNXjEwdMqfvKCDVB4Lbtvu7hk9DQfJ
         f3lBYBEwUEi9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 553F360A1B;
        Thu, 29 Apr 2021 00:26:18 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210428133917.1c039eac@redhat.com>
References: <20210428133917.1c039eac@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210428133917.1c039eac@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1
X-PR-Tracked-Commit-Id: adaeb718d46f6b42a3fc1dffd4f946f26b33779a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 238da4d004856ac5f832899f6f3fa27c0102381f
Message-Id: <161965597834.15418.18306030222216496427.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Apr 2021 00:26:18 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 28 Apr 2021 13:39:17 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/238da4d004856ac5f832899f6f3fa27c0102381f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
