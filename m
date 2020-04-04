Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B9B19E6DF
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 19:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDDRuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 13:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgDDRuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 13:50:23 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.7-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586022622;
        bh=O/M0Xi670dJt4pqqvin9h8KSuZtxbX8f16RD5Ztc2aQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=yBVQsBwdA5F6iW51CfrlFIxf67qS7GaJ4QhJCdPqiKTBJEWs5k++Fa7tRTZREH583
         BGYtWgrK284Cl4y1GtG+DpzjGBmk9HM+s1FfRLkA6V1wd4V9XW1/aPJGxkDtZsja0P
         5sdYiPonMkWEHFhOoDDZTJuQ1Q61xghgxePmLBDE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200403162242.5e4f9afa@w520.home>
References: <20200403162242.5e4f9afa@w520.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200403162242.5e4f9afa@w520.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.7-rc1
X-PR-Tracked-Commit-Id: f44efca0493ddc1e8731047c234ec8e475943077
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2fb732b33b0f4d73f391066c0a970b942c600dab
Message-Id: <158602262259.31764.3687805120660330306.pr-tracker-bot@kernel.org>
Date:   Sat, 04 Apr 2020 17:50:22 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 3 Apr 2020 16:22:42 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.7-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2fb732b33b0f4d73f391066c0a970b942c600dab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
