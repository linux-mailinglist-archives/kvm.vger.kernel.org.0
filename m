Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC5E3BAA32
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 21:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhGCTnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jul 2021 15:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhGCTnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jul 2021 15:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE67961934;
        Sat,  3 Jul 2021 19:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625341249;
        bh=N21z5zEm40s1EkiC+nkIOxYWbttJy6bH5D6y5lggRBk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FPrrVyeCCCY+Fbb7ibjfnq22UqiLjf0JdQlkF3O8FRI6pE8BBpkx5OURhpToj3rSq
         QHrCddaytvdpYb13GRxsyibPAppJQ1/B60X0wWtcXQM56jRdeHGxwoPGPhqRIz9VnK
         hltyLRCXY4HG0FzRSCKU1CACy19/Njr3+9qX1NqNEB8EoSQQ6K5tdMOZLxUhDIxslv
         sSBGwWSYHLPs28E6UP4tHhzjZiGCYSXA1rJ8zXd7BJLArLBcGGpz7NiTqbQdBAXxge
         gWKOlJX/oUbpWiUXo2qLCcToJVfw4l6kIvFVq14O5m/RezTqDOlDw3TZhtQmiy9A9+
         dyJtwn0VT5Ddg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A934260A37;
        Sat,  3 Jul 2021 19:40:49 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v5.14-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210702133312.61fe06aa.alex.williamson@redhat.com>
References: <20210702133312.61fe06aa.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210702133312.61fe06aa.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.14-rc1
X-PR-Tracked-Commit-Id: 6a45ece4c9af473555f01f0f8b97eba56e3c7d0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8e8d9442d1139d05d0c3b83efa34c4b7693d2969
Message-Id: <162534124968.29280.4660936103234612335.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Jul 2021 19:40:49 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 2 Jul 2021 13:33:12 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.14-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8e8d9442d1139d05d0c3b83efa34c4b7693d2969

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
