Return-Path: <kvm+bounces-48078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02657AC87CE
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 07:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C8634E0771
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 05:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6B21E8323;
	Fri, 30 May 2025 05:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQN3ylPM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A1D186A;
	Fri, 30 May 2025 05:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748582595; cv=none; b=uYyDJqFtpeTSt+gn5iF+nYi2QJGbXxTrQqjrZnK+j+6qOHYU083HtQP+lUK+SrecAmmt0Lv+wpukae15wGmhQWyuW8oF8EGRetz3hrpxl+k40KXvkPgL175mqvx0wsRlmhvlCLo3OPt/8Tr1Q+9DtCBnBrLzR+0fZmsLuqrzSOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748582595; c=relaxed/simple;
	bh=UUSQVyHtUMB0ilUAqR1Rlf0jpDZeu+aMdADtiW9AjRg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MgOwcBfhfzvqVYNUJqw7b2xtyCsrgr7wElpTYPnSkILLDIESZcGJU6ITmIYzG0COTH13iWSTv7X6ZRyB4NkjP/6Sh6DOUZdxDBoYdEQd9mrmUHKCmfEA8s/AEqjUILu93v7Rb7HToJgAOOTCbnzFoRcWQepTVi3OrDJ0Ys2VGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQN3ylPM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE68DC4CEE9;
	Fri, 30 May 2025 05:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748582595;
	bh=UUSQVyHtUMB0ilUAqR1Rlf0jpDZeu+aMdADtiW9AjRg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EQN3ylPMk6L+RQBbKDNzD5lyjR1EuIOP0zJsqimNHN+PrE/qgGcit3uoeGPqakenx
	 A2M2Wf55qsM9e3N4GNHy1Y+3q9K8aF7arvh1tbvknrK0qxym14g1+MJ3nG+Om8s05x
	 q4vZDm+ZlIAsL9jbveFxCQrtXiz4woKV3d69ZockYv6VZ11VubCtLUryJVcOcoBMjo
	 S9tvDTxRGUxxQCjHUKT11+cAgbSmcb5RQ03wEys0506UYIRQZM/tMW6a9wvSXi0AAl
	 l3X1cSLDYmQaU8Ek89vvU6+lMVWv6O+SMDdwyBfqEOgADnQZYtO2TBpSkC6tK0SWRC
	 08esfnMGqk9FQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70FC939F1DEE;
	Fri, 30 May 2025 05:23:50 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250529144851.1ce2ce66.alex.williamson@redhat.com>
References: <20250529144851.1ce2ce66.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250529144851.1ce2ce66.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.16-rc1
X-PR-Tracked-Commit-Id: 4518e5a60c7fbf0cdff393c2681db39d77b4f87e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3536049822060347c8cb5a923186a8d65a8f7a48
Message-Id: <174858262905.3833287.15899806792991622129.pr-tracker-bot@kernel.org>
Date: Fri, 30 May 2025 05:23:49 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 29 May 2025 14:48:51 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3536049822060347c8cb5a923186a8d65a8f7a48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

