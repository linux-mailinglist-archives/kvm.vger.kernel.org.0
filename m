Return-Path: <kvm+bounces-42438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F6AA786AB
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4473F1891FD5
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF2918A93F;
	Wed,  2 Apr 2025 03:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQ50QPgn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5EC175D48;
	Wed,  2 Apr 2025 03:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562803; cv=none; b=je6WAfJEUdNBYyoopJA+mk84ZONb9A1aAjnl800LrLqbwseNs+IleDiy8gXHwWshP2ootxlKjuVH2vDi1vMcU1geYRXJlHOzUiGJhKCGkWhCryEbr3N0/jR/XOoJDISoBY27gHOV4nUvcgp2mHpJ6FTi4Sz2JB0UUmPyWze/8Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562803; c=relaxed/simple;
	bh=PCff27/WTHHpHsUC53z74JkozkbdGMn9zkO2USESwUE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=T2/xZKwBGnUE7uqdoDWB4BX8kJKqlrHyc8YhDFZz6T2iDS8gvOpIcjKUjjEKIvBKbkCZ67rnHdTYrS1sq11oJMw2FCXGEZwuBtyuIFLe0nOIfjbwSltvhzIH+zOq83ibqd48YHlqtPmNx8jnkc9XLr5noOwPSUvG6JUDhTFSWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQ50QPgn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B012CC4CEED;
	Wed,  2 Apr 2025 03:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743562802;
	bh=PCff27/WTHHpHsUC53z74JkozkbdGMn9zkO2USESwUE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hQ50QPgn8Pt45oE5rj/ZicinFKcMLoKnpMHrD/tN2HwDPx4G7s1p4ctWDgcp+UaJC
	 ezezSU+k/g3C+npI426QdMuG977B/gb/rdtiwrDyXXlEfMlpvIU3NN2EEFn57jzME2
	 Vw7G1HTJS2CbADEAY8MnR0GMgH4AvU0N4naRotGQu6JRjk4gY4NLNMXxwVqNGSxSG2
	 SBtAzDs9PV8Gwc+r5kmu7YffK9l3M6e3EMiIIiRP/M0gKyqf2Kr4Jf4KxXwEaB7EIb
	 IgdfXaRS6jipEKZ+LqxSPWEWBCzkwqL0wEgtaBfMCcRUsQPBsEProXEIAyQNLRhzg0
	 8eBb8BRVSZDZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B7C43380AAFE;
	Wed,  2 Apr 2025 03:00:40 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250331130550.2f9ba79e.alex.williamson@redhat.com>
References: <20250331130550.2f9ba79e.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250331130550.2f9ba79e.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc1
X-PR-Tracked-Commit-Id: 860be250fc32de9cb24154bf21b4e36f40925707
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3491aa04787f4d7e00da98d94b1b10001c398b5a
Message-Id: <174356283952.1007346.17224063458647296216.pr-tracker-bot@kernel.org>
Date: Wed, 02 Apr 2025 03:00:39 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 31 Mar 2025 13:05:50 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3491aa04787f4d7e00da98d94b1b10001c398b5a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

