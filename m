Return-Path: <kvm+bounces-65308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C56CA5F7D
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 04:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CF9C316D0CF
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 03:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAD22EC090;
	Fri,  5 Dec 2025 03:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oHwW7SGo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F462EB5C6;
	Fri,  5 Dec 2025 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903873; cv=none; b=s+Zb2DlVcuBJP4u9W52t+KPO9fK/eBXsHp7j08NZZsJMU+19qsl+k9ZFoiRJShE7AeMHzf9MS+mAX1YXAc8kfqQNIDZ1vVHmNVEkhn51QqGPWBUUKT2wZZbJiNaaeVSKaSHvzP4zbw6vC8G3QIIDavZUwvWzukN+RdV8An1KEKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903873; c=relaxed/simple;
	bh=m3FEnyczcnCXbFyHm9fAo8rtUQ3ieA/yywSFlfD7phA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GK1Z3xwy/o+yQMgb35VMFpjN0FqdrS+/Lo5Uz7cFhXYGs7+eN589lj3JaArgb2SllnvthvR9Tf5oCC2KbC7RGDPFNN50amM8YP3iVQscG51S6ZEm9uNiQsVwbcKEPLql/8MZ3WhKv112KkwZDTEcHYiuGFKIXEUNkN6uEqPj7Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oHwW7SGo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902EEC16AAE;
	Fri,  5 Dec 2025 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764903872;
	bh=m3FEnyczcnCXbFyHm9fAo8rtUQ3ieA/yywSFlfD7phA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oHwW7SGomkaSaZwfUz5fF3x6SKBEFghWuDdIqNWyuIpmgz4YpWeR37064WdJN3eP9
	 qCtci9ahhuqECW7SDPG1pt3qoXikVMAYHBUqje5Z7xu3UnDJ/FAhp7MEngNlneZQ4e
	 l4n0Y8fnGLMcKYhcPjl3b6Me5/f+vWA0SpJKD8MWri6bkU6+M8YQsossBVD2vc0dGT
	 J+ieIoz+MgZ0VH5p3hcOLmA664CVVUAjYt5S4bV07pFYtO+HGL0Gfa6evoqwdet8XV
	 2rhS+fxzbbjaTxoWWygncFzwgjdBVhRxPyXb6+wmipUcUwfwYE3/o3ZxvRaYJVaV2/
	 NX673kPbgnVlQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C502E3AA9A89;
	Fri,  5 Dec 2025 03:01:31 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251202175046.GA1155873@nvidia.com>
References: <20251202175046.GA1155873@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251202175046.GA1155873@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 5185c4d8a56b34f33cec574793047fcd2dba2055
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 056daec2925dc200b22c30419bc7b9e01f7843c4
Message-Id: <176490369063.1073302.4770727882295312665.pr-tracker-bot@kernel.org>
Date: Fri, 05 Dec 2025 03:01:30 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 2 Dec 2025 13:50:46 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/056daec2925dc200b22c30419bc7b9e01f7843c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

