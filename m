Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A640941BBEE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 02:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbhI2A57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 20:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242636AbhI2A56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 20:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 78FBE613A5;
        Wed, 29 Sep 2021 00:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632876978;
        bh=jheu7HYE8W3FK9nLQCAxRvISe5KLsxnhbpqCubvmYNg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VELvfms2oPM3ShEwC/WQqbLIHX7v8WxAgisbDkI9SP3TcqefA8hK9BCEr38pMqp7f
         1tiVSaXXL/TBUZl+37h62YHb/0rPJr6NnyMTxBUo5EJA9czqPoEtOGfXlKTNr29kt1
         p4GMFWSJpVbEsojQaGCn6sh6Jbyhva39TJAYItRnXXSuV9HSonHHnrwXmwryRNPWC6
         rERzQ76SkAngZ9mT9jEmnH3wTMtR/9SUFdacc43hojL2AcF+fefBYPqnCXWBSc3sz9
         5pykPwURU16pyVxwEsi4ynnCuaN8WunyFlJUGeiW9GFwJdvSpaWPcvP9DBkqMsRROM
         FShGlR+0SQb8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 724C9609D9;
        Wed, 29 Sep 2021 00:56:18 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v5.15-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210928103756.4070e4c6.alex.williamson@redhat.com>
References: <20210928103756.4070e4c6.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210928103756.4070e4c6.alex.williamson@redhat.com>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.15-rc4
X-PR-Tracked-Commit-Id: 42de956ca7e5f6c47048dde640f797e783b23198
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62da74a735702e62ca910d41b4bb760bbd968e3a
Message-Id: <163287697845.31747.5934695430113904824.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Sep 2021 00:56:18 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, colin.king@canonical.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 28 Sep 2021 10:37:56 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.15-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62da74a735702e62ca910d41b4bb760bbd968e3a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
