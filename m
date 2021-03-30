Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE734EF08
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhC3RKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhC3RJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 13:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 498B76196C;
        Tue, 30 Mar 2021 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617124184;
        bh=4Til2j75yX/EBrzSAXOwf+bqInFuU6Tj7bD/evGd2OQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aomLc4h1KAAfZz8U0sc3mYWedXhXPrWYdcKaqawuX/7PZBB3mxV8OkqqQFwW7pRCy
         1t9wI1AFowN5vjtkpWvjaFUfgUnhTLc1ITiRQeIeLAmz4XFkr/jQuxr/cndijEJGUT
         iqpN9594oo5ZVraNpG1kOPlvRbyj/DQdzb8488JbSxUtNwjzeejhe5+jKOl9OgLtKp
         ZAfsFCu4tZ+unkc9aaltLUeKmsDgAOPhAK3HvwtO32TwAfANE8n59DJajo9lBOkYw3
         +w3c4ZbHDMBqnbnq7BBY2psLnpO3jyXM9mpNklHpKGXoJcgUMPgc7KJ47vseW45cNH
         oRy6GvakPu4Lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37B3760A56;
        Tue, 30 Mar 2021 17:09:44 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v5.12-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210330104533.4ab8d840@omen>
References: <20210330104533.4ab8d840@omen>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210330104533.4ab8d840@omen>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc6
X-PR-Tracked-Commit-Id: e0146a108ce4d2c22b9510fd12268e3ee72a0161
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17860ccabff533748c85ea32904abd6bae990099
Message-Id: <161712418416.20369.16038475467167492858.pr-tracker-bot@kernel.org>
Date:   Tue, 30 Mar 2021 17:09:44 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, jgg@nvidia.com,
        daniel.m.jordan@oracle.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 30 Mar 2021 10:45:33 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17860ccabff533748c85ea32904abd6bae990099

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
