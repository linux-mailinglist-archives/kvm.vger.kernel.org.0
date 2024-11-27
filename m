Return-Path: <kvm+bounces-32615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83EBE9DAF6A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20FE6B22484
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4BF2040AB;
	Wed, 27 Nov 2024 22:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0/VK68n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C26204090;
	Wed, 27 Nov 2024 22:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748273; cv=none; b=M1AO3OlGJ0EWo8mG7//cw2zahkstShjOmFlqcMhhMzMZX6qxdRJX44j3dqSgBxvjCvRk8nDjqqTNj6fe20IaLUr5tVKHkyzQNIweA3H1/oHi0xmGfNYEMBJ3DBXuiS0vGRteGed48k/LIYZfxKCMzKMnb4zLSGfDQUxnW5jD8Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748273; c=relaxed/simple;
	bh=LlFt15uiGSl7JW+VwFv+USSZfuV9mV2l7A8TpPmghRY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sZfr+6jZTYPfJiGyrK45AjuV6RyibNpHVjFnxidNtqlDyJjSKdwRJkcqtrU3DmYcdvI9nmhCJ5yCDjHAXJabwo56gftSu+LLycn/le0eXxV1mGkS2d11aui3WuKwnKEt+DJj+51BammB/FHo/9E9jEvhvabmNx97IEMbriPJw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0/VK68n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7666C4CECC;
	Wed, 27 Nov 2024 22:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732748272;
	bh=LlFt15uiGSl7JW+VwFv+USSZfuV9mV2l7A8TpPmghRY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f0/VK68neDapRacI33BUDaHH6eQ5NomQpE46lsYr4iEIa8HzW+LVQVGxJ3/kvU2eV
	 BVQb88eH3LDxQt3cjeiURXpKXM1aLViE9fGz2hCZbfXX44NPyW9OCvR920czN5fdPz
	 1eEKPkzHxtA69AmV8o0Um7qWcw99aoF/gfAQCpIb8WSsilbvpmtw3fVByAs7wgR7Dm
	 +mgb6By5IFs4K3h5vmEbiTOHw7NGhS+KQov4io5z6FnX7q+XaxmikwdP/N2mtLRyIE
	 4ltNLAuNnO3k5WOqobbLMsxVIKjJrGF/Tz8d3jp36Qo2RqK+SJ7cPKidzZHpaHGWiH
	 J/0ONN/GB509A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34040380A944;
	Wed, 27 Nov 2024 22:58:07 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes #2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241127155712.GA1470954@nvidia.com>
References: <20241127155712.GA1470954@nvidia.com>
X-PR-Tracked-List-Id: <iommu.lists.linux.dev>
X-PR-Tracked-Message-Id: <20241127155712.GA1470954@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: d53764723ecd639a0cc0c5ad24146847fc09f78d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64e6fc27d60f8b186bd4d071a6266f8c4d5aa2f7
Message-Id: <173274828572.1238022.642442397167715599.pr-tracker-bot@kernel.org>
Date: Wed, 27 Nov 2024 22:58:05 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 27 Nov 2024 11:57:12 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64e6fc27d60f8b186bd4d071a6266f8c4d5aa2f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

