Return-Path: <kvm+bounces-65456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 334BACA9DBB
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:37:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3B9C327095A
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378B327A907;
	Sat,  6 Dec 2025 01:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQF2fFHF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F42773C1;
	Sat,  6 Dec 2025 01:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764984242; cv=none; b=Yg8aKcGonBWz7mB6B1BiHt+Xxv47D1TUgm1g3vyJR2wylLX/yblLSwJ//fW3qdX/GHsrpa6PgyP04MWV1AcHBwPV4sn1LzHxdNAon+GtdTjwNpCCpV62bepAaVqd9wzFwWrhsIctx80SOhWoUPaJylECNE2wTz1/ofyVzFuiIFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764984242; c=relaxed/simple;
	bh=4ALYMcdYVWjJ89muLHhLx9JXWYdCU3S0+p+u5ETg7pc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mxBgTeib95f0109RpBB8D86NN5k2AnkF5U6ONCRRyZSxYoefXLwPeR+NV3AIo4jeO2eSZJD7acvlKxvfXudrLiPHoLsFuoESELZ6gLd8d8SJtzwVPeG5HSj5bidz13xA4BcNWzukJiRwrJPVD/dRHp/ZqeSkru3pK9WPjCYw9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQF2fFHF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B4DC116B1;
	Sat,  6 Dec 2025 01:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764984242;
	bh=4ALYMcdYVWjJ89muLHhLx9JXWYdCU3S0+p+u5ETg7pc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gQF2fFHFpMtg901jOMOcnNzhuA4cjZRGcnmNUxh4rN835o8nxlaEfvoQszW/h3rLE
	 CgPHsQiuL/Ei8A4uvPcO+6kgl9HB9l6i47zvN08VBmJCFN8v28fCDUbXD7jAjiwk6z
	 iVPeaHLiEyq2K+XzHeOvA06KPRmVSp5lKe9BtHx+heud/Ztrm+e8XCWEjC2Ear//nr
	 Hsaa49Ri6JctOYMK4jz9SXiPaOIdbZKvK9Npj6PRXUj5qARezKr6/LepqmK7Po21qW
	 HAANTkEFT4CBQSTTbmDmo8H7/4aqetJEmfXmBB/oAT0SUh2PHtQha/blFyoxancomJ
	 tNUYiq9Z6qVuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B5F413808200;
	Sat,  6 Dec 2025 01:21:00 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251204180619.33800-1-pbonzini@redhat.com>
References: <20251204180619.33800-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251204180619.33800-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e0c26d47def7382d7dbd9cad58bc653aed75737a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51d90a15fedf8366cb96ef68d0ea2d0bf15417d2
Message-Id: <176498405947.1907434.6810124774195869303.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 01:20:59 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  4 Dec 2025 19:06:19 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51d90a15fedf8366cb96ef68d0ea2d0bf15417d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

