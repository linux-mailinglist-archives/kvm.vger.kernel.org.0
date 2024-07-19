Return-Path: <kvm+bounces-21959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 633E2937C1F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 20:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2479B282CE0
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD94149C53;
	Fri, 19 Jul 2024 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lyzpgq5R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BB8149019;
	Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721412570; cv=none; b=G10ptbeukGtExLbMyvEJbdS71hLil8228dX/NZvDX8vpsFe3u+b/C3QL5POQ8mxeA/iYev/PrAuIt/KEPs91ptXwMYgTxNyT9KgPevA2nT0r7arPUdhaqpjGj7DEEnRwrxtVSK/m2RqABCnrAeSLUL3R3PyAFIEZRzEqS8ELjL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721412570; c=relaxed/simple;
	bh=K6YI3OvI9xUAPcmQlqwvsy/IOBL+RllKzVRlqGuNKGU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o/zJzbfPojz4WvuVmh/E11A3N8KenFKCTAVTzmslCTLjThGPO0+AkvOAQb55Jp00+VAlWC5HICIDYui+pEbe8KRMvCYqTvumriLYrm+JoccQC2FYJslKGnoKtmGyLwJ1X4imhd9pJGrGjCIAeO9O+jYEz2k84syu2KSJhxtgfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lyzpgq5R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA479C4AF0F;
	Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721412569;
	bh=K6YI3OvI9xUAPcmQlqwvsy/IOBL+RllKzVRlqGuNKGU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Lyzpgq5RUA4yiSGa5qT/pPDNRGlqOWuT1kwS9wTr8A9LavN0z9x4LyoRV3P6wpBH+
	 4omK/DGyc5Ufv7sykiC773hNGAJ4kbOkTsZoCwzj4MZf6Hi1ovQ5YT6m2REBa6h01c
	 2rc3wRp+SEcAOD3xHJXdDI/qRmFAOk4nQnTn2l5USdN7ZYzNyYlAkdiafrd2U9A4R8
	 EKbpRXrhtTN+psvoVV3yZ96M+2ADyhNeEH82rMGSUq4BsgxWllz6uERw6ty21qFKcr
	 Mx7fqDhRZMuUX9Ny1Qzu5Wyaa/GepdMN1fMmVwxsbTCz//eYZAYJPDRJg4f0qDr4mU
	 EJLQf/y7Hsbcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1417C4332D;
	Fri, 19 Jul 2024 18:09:29 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240717184603.GA4188230@nvidia.com>
References: <20240717184603.GA4188230@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20240717184603.GA4188230@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 136a8066676e593cd29627219467fc222c8f3b04
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef7c8f2b1fb46d3fc7a46d64bb73919e288ba547
Message-Id: <172141256978.2862.5386851165696458605.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jul 2024 18:09:29 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 17 Jul 2024 15:46:03 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef7c8f2b1fb46d3fc7a46d64bb73919e288ba547

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

