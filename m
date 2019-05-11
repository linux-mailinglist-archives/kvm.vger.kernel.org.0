Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1771A82A
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 17:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfEKPAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 May 2019 11:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbfEKPAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 May 2019 11:00:14 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.2-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557586814;
        bh=coXhDy5rztapowd7/ZoUvupbnJU99RnXnrpO3pouju4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Vxu44zv72tetHOZIJYwg0jBiRlXxoWhxI0uHNYLa07igKK3ba4CAUAaBBD/ZPDANF
         1h6GMesV3zusSPZ+jz4Vvm0/s8VeFtcDze6BpworAOmdOkttrex6+fUc7Lee+BWjzJ
         7ufmWA+MV757e9DSv47PewX/97dln6RC3ZDGWves=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190510155057.75cc97ba@x1.home>
References: <20190510155057.75cc97ba@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190510155057.75cc97ba@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git
 tags/vfio-v5.2-rc1
X-PR-Tracked-Commit-Id: 15c80c1659f27364734a3938b04d1c67479aa11c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fe567df04a27468b306ae5c53fa7a1cd3acc5e1
Message-Id: <155758681427.22634.1099507694139674226.pr-tracker-bot@kernel.org>
Date:   Sat, 11 May 2019 15:00:14 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Fri, 10 May 2019 15:50:57 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fe567df04a27468b306ae5c53fa7a1cd3acc5e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
