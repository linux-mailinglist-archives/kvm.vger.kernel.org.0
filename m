Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E052242FC7
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHLT6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLT6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 15:58:30 -0400
Subject: Re: [GIT PULL] VFIO updates for v5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597262309;
        bh=zrDNdGq14UnSuTzhco0MBFbwucmtKZVl3d6A9iVqZwc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=C7D/FdE2qnlZZJVDgtv87+dliN/kCexv2zHF/qD67NAVO9MMlEeyPWAwND0iaaO59
         qM5R0iceJiIoeAg5uq8e5Qand6l102QVXylBzjibxa4N257yPX3TLN1BIurCvjAWHu
         GnEf7edtXkLHka68tycZgdjSJX3EM1H/kTJK7mYk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200811203147.1ad96351@x1.home>
References: <20200811203147.1ad96351@x1.home>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200811203147.1ad96351@x1.home>
X-PR-Tracked-Remote: git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc1
X-PR-Tracked-Commit-Id: ccd59dce1a21f473518bf273bdf5b182bab955b3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 407bc8d81837197ef02c7296f8068d3bf2c96f53
Message-Id: <159726230993.30367.12804520856299605186.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Aug 2020 19:58:29 +0000
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pull request you sent on Tue, 11 Aug 2020 20:31:47 -0600:

> git://github.com/awilliam/linux-vfio.git tags/vfio-v5.9-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/407bc8d81837197ef02c7296f8068d3bf2c96f53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
