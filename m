Return-Path: <kvm+bounces-47843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1DAC60A3
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 06:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E5D29E25A0
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 04:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746D41F3FED;
	Wed, 28 May 2025 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alb3yn0w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831AE170826;
	Wed, 28 May 2025 04:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748405902; cv=none; b=VrSfIX4EAhclANHPAhCwWl12EBMbXOjeviV/9zc0hhLGb/HwSIT4Z8SsqhqZiJBP7tEO9Lh/H3NP8UFqcb54EYqxaMstnLnNlU5SkkgUdd0/9odJo8QqriyYo6E9SGuhYJNaD2FYXlfybkPrcnWG6gS4jK6obCB1mIyaTjIA/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748405902; c=relaxed/simple;
	bh=MvDl/MzUY3KR7w+lIeq0zd5B/vOkndPxkmobsRTItJo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qcCTS1OaNSSasDEskFPtiKY5g/OUvPep71kOoRnDGKOaqkRaoVwpgmruetAL0VjZz/f/3f1OfyNRDANZ9MJSXDGnmSN+380YrGhgS3gaFZIzevB4JxwgeAeZ+V3SOMvtyZhQkLuwmaOn0Jdti81m3vQe6EmX7gVNnKifoBTcxM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alb3yn0w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D19C4CEE7;
	Wed, 28 May 2025 04:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748405902;
	bh=MvDl/MzUY3KR7w+lIeq0zd5B/vOkndPxkmobsRTItJo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=alb3yn0wMusQUv4YwGNPIm6FzSS2ST5UdxBnUGpCrAbNeb8Cy6airS8dgB9fruFU1
	 ya6pU7Hwb5xBfz5QDzs3VunO9e9iHV+pyLyYhAYUWRF8bQ/PxmJGsvlme+y2bPBh3P
	 B7Xgrr9oEpeBSNHmiTlpx4pg0EqtOgQufQbRWPQmlRZc463NFOp/rJOdMUmPzTogL9
	 Sty0ZONiehdMt1auZD9OUdOrZABiFxKkfl7wxHe+NRQXomLgC4fYQMqVBjfZtf0zre
	 fgBQcJnXeROouVuVS7g4EC+ixPZVGeUgTyqAOUDTABUTxCIJFjC0MFASwi4AoxjHBK
	 KaO/p4kzXG+QA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2813822D1A;
	Wed, 28 May 2025 04:18:57 +0000 (UTC)
Subject: Re: [GIT PULL] dma-mapping update for Linux 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250526121105.434835-1-m.szyprowski@samsung.com>
References: <CGME20250526121111eucas1p277b74b79fe4ae4323fc687a06039044d@eucas1p2.samsung.com> <20250526121105.434835-1-m.szyprowski@samsung.com>
X-PR-Tracked-List-Id: <linux-rdma.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250526121105.434835-1-m.szyprowski@samsung.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git tags/dma-mapping-6.16-2025-05-26
X-PR-Tracked-Commit-Id: 3ee7d9496342246f4353716f6bbf64c945ff6e2d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 23022f545610cceacd765bcd6c19102fa11755e0
Message-Id: <174840593625.1893196.9279627536721857456.pr-tracker-bot@kernel.org>
Date: Wed, 28 May 2025 04:18:56 +0000
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-nvme@lists.infr, adead.org@web.codeaurora.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 26 May 2025 14:11:05 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git tags/dma-mapping-6.16-2025-05-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/23022f545610cceacd765bcd6c19102fa11755e0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

