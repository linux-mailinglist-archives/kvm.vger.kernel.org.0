Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003352DC9BE
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 00:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgLPX4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 18:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgLPX4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 18:56:33 -0500
Subject: Re: [GIT PULL] VFIO updates for v5.11-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608162953;
        bh=zX+ix/Sw83n7LbweL3xS9UvJPUyLZggobu8CHCYnioc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rSnCHi1w+C4CTccL9hmcaroyMRmVlVIclWBRzIL0/3P3Tu++4McEuCFyrMIFwG8GX
         XaZ3t7AzSfF5v2qd4Jwxed0TJy5QgbI3o/VwSyxpDsuEzZ672d9QEQs3lP26YvH+3x
         GagOnwTw5Jg335zU9S8owkyvxa/F9lBpsoHQr40twijIufQ1tDhVUUqZ2HMEj0/bib
         esK8KC8fXxcxOG/Y0BFukmTvt6Ba3EnPQ51pxZAs9qGkPuMdygp3FtPwtnKb4e8tVj
         5VckG9fnKrG9kWWrBvV3UU3cCDaWkUEs52ZUNmi3FQuctmLWUFH7VUJk5KPsUO9SFl
         KsGKNNEpXmkYA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201216123701.00517b52@omen.home>
References: <20201216123701.00517b52@omen.home>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201216123701.00517b52@omen.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.11-rc1
X-PR-Tracked-Commit-Id: bdfae1c9a913930eae5ea506733aa7c285e12a06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0c71cc04eb180c4b701cbe821635f2a122926065
Message-Id: <160816295293.13963.17562945457946917061.pr-tracker-bot@kernel.org>
Date:   Wed, 16 Dec 2020 23:55:52 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, eric.auger@redhat.com,
        jgg@nvidia.com, aik@ozlabs.ru, farman@linux.ibm.com,
        baolu.lu@linux.intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Wed, 16 Dec 2020 12:37:01 -0700:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0c71cc04eb180c4b701cbe821635f2a122926065

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
