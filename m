Return-Path: <kvm+bounces-51319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C34AF5F6D
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EADB3AA1F5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C16A301122;
	Wed,  2 Jul 2025 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZ6N53uE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5E22FF48C;
	Wed,  2 Jul 2025 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751475988; cv=none; b=dYF+e2gbcfYcYzaBef0lqg6sTFHCezD0Vn87NqzJ8S1wSgcptET5w3PxHQIhOHkpAm6M8J0GKAlPOdrEje1aOakGE63OJNF1Zd9Mq+JqmjmUca2tnobYBQZpLpBfaUhnn4Nd+ivGpxeAIF1dQtzMoRoQi5YGWfE0MeEcUdLastQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751475988; c=relaxed/simple;
	bh=0CLGjDOmDfatZRrAl0GSnkmH2KbfeUCzoMspdVLmHp4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KCREu86fi8Q9zjUaxBzAaogV1RVnnDyZlgYFW7UUoQwC/RddfAF9wUu+wUigB/zhA/3v5zy+udZl1P48obo4LAZBBRPUCZC6nMHZUXSL8MR2ViUg2oAJiVCBl8fPZklF/vT3Kf/C2CKUgfp5or5r1uFdDYeaaj0/o/75aKD3pH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZ6N53uE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC26C4CEF1;
	Wed,  2 Jul 2025 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751475988;
	bh=0CLGjDOmDfatZRrAl0GSnkmH2KbfeUCzoMspdVLmHp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FZ6N53uEm/D7Mlrsq/AK+YLoU+lIDswtealSVLMNBjA6CCfFVI6NoJX+ZzJl5N3wX
	 EXDI37u420+lXgMVq2wizup94Dwsy9cLItYzYEHqV1I+mWIhS3g1GTPYVtjHYi2AjP
	 dCznQjsFojZC+cqUJmB5OxfZnp4CUzwS9kFh7l6eXfUrt532WA9KtDHPg1AFBf1SFi
	 Jfzzv289LsaS/QU56VgNzLEj+iWPMLHlo6sc5oYQkza0xeLQhm3HBAXoZ+m4snmmgv
	 C98xoLELhsexAtwII/sFQ811Uc9N4fNAQ8Ya01scV3oEXs5cuEGtByrnQEnqLtM6qs
	 o04SbL7XQ7+Og==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADC1383B273;
	Wed,  2 Jul 2025 17:06:53 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250702141453.GA1129243@nvidia.com>
References: <20250702141453.GA1129243@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250702141453.GA1129243@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 9a96876e3c6578031fa5dc5dde7759d383b2fb75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3c894cb29bbf4e36c5f2497cf8ea6fb09e157920
Message-Id: <175147601261.796050.4530835309908516171.pr-tracker-bot@kernel.org>
Date: Wed, 02 Jul 2025 17:06:52 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 2 Jul 2025 11:14:53 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3c894cb29bbf4e36c5f2497cf8ea6fb09e157920

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

