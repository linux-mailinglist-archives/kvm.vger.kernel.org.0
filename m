Return-Path: <kvm+bounces-64518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E52C86015
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 156C14E243A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EC4329391;
	Tue, 25 Nov 2025 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7BiLNRl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0562622541C;
	Tue, 25 Nov 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764088765; cv=none; b=H8o18x5UlspnDjX4bephDx8a3/rNmVoHmUGx7RZgjgI6xcpx1IK+P624r/7txCLMDzMu7UXz0n2jqCiRyNAozaKSuIBNpQOfzs5W8YKa/ceJ+WeuJ8E2kpZIZUNIFRYK01PdzmcMVLoOCom0fU6N8r2PkNsnagCjEmiI06G0+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764088765; c=relaxed/simple;
	bh=HmW7ECO0uGNCgHIZ3qB2KXcT/GAVE7waJ2SQUURcspo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=D1qugmuYjht7g862sSoJUJRewzzLOU/97mcY9VKx0EHPllrHPjh/1nl3KLoGhgQ9j415XQ+Afy2Teuyir5lD6N8tis78RDY0pvMyFzFhR/H0FHBqbZ4jZw1c4LyA6sJYuJHhqfabvjtSXvWzxeo1OEyTHlymbJjB7wsUVatCJHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7BiLNRl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D35CC116B1;
	Tue, 25 Nov 2025 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764088764;
	bh=HmW7ECO0uGNCgHIZ3qB2KXcT/GAVE7waJ2SQUURcspo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f7BiLNRlEnxtvkUcrDANZ6dKQ34iChxMQD2wiv4Dp0SCY+82Z44/lgDvoC/jbVcbN
	 clVKc8PiBer+yvqz0CN1XUqd0UX6Rl7pvssDQMrKllO5dhJ6kXUh1wmDXGie+AHu5H
	 deufzwR1wjBWATHdiSuNyZdL2j8YkLE0RggFeiKef47X5xvcL4SIA02mjGHHFaeOnN
	 V+HFgRJSDhfrRzu+DtI3bo6udCn6oa1lqtTmSxUwpq56+hNY6YBUmHgwQGRLYYGUUv
	 mwN7hj/26gFK7Hzqj/09kyCORyYDl4eTG44k28FR+8ODaVuFpN8+/iDYFRNZ+WQ7Gd
	 d/v4qvidvPV9g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F26380AA61;
	Tue, 25 Nov 2025 16:38:48 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251125150906.GA520978@nvidia.com>
References: <20251125150906.GA520978@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251125150906.GA520978@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: b07bf253ef8e48e7ff0b378f441a180a8ad37124
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5f8a6c70afc58d4be849407658f27f47f006a3c7
Message-Id: <176408872668.833675.6915720868920277304.pr-tracker-bot@kernel.org>
Date: Tue, 25 Nov 2025 16:38:46 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 25 Nov 2025 11:09:06 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5f8a6c70afc58d4be849407658f27f47f006a3c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

