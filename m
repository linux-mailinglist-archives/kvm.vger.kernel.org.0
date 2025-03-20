Return-Path: <kvm+bounces-41602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 689C2A6AFC1
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 756C5886B7C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 21:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8868F229B2C;
	Thu, 20 Mar 2025 21:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHMZxz50"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7391EA7DE;
	Thu, 20 Mar 2025 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505648; cv=none; b=XOFuwK/Z+hk2qKU8Vq8QseKxMw5qLtn1BkkgC4vPkPXLj4pmgiNTTO8f5Mg/AK04ojN0LefGtgEN4E/J97pJkfMPSZCQcSJvLqR9o+BqU/tCk7+wEO0NFL+e516bDfjWJ687ahf9NTfVSDVqQURFIF/mKTzkcp2qFvEaXmQ6iog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505648; c=relaxed/simple;
	bh=2pxp6U9YrsIurnP7Uxe5+BtRYINx9aJ985g/tR1aY+E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZcNElsAIR+J4Evaeo9CnKYYCSsIoX8I066zmaCVxQYPiUKv+sjudUBW8MQSkZ8QzhhlRLwVB/KIEjzHRh87OyRVHg8z2bkG4hHafTbmg2kcTo29U3QwQdRgg/yGGh7j6hUUftg8Q2L6OsHrjj82JfPOHwacdujLGPjs8MG9GxOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHMZxz50; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE4FC4CEE3;
	Thu, 20 Mar 2025 21:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742505648;
	bh=2pxp6U9YrsIurnP7Uxe5+BtRYINx9aJ985g/tR1aY+E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jHMZxz50/Pt0/khH/bTqwHSt5aQW0qiS6tnjoGpS9oCUPGAIgMEjtcLURu/gCZjXR
	 SMrNZvcV2DmqAX2QkymHrsnxebj3oxBXInHW6IbaRmDCXGvCicSWdHqQ0eL48G35dU
	 3oq/BPcKqyR3JnTwSS7mMGX6W1coyM7CGtUP7G9sTJHdVRQeDimGsErYTIKMgyrqXE
	 BXZjkoTMlrtm1anvbaqrEC0o1WqTJGPsSZKLtgBAlQjUyLR4oyMjgQSvzoeYN2AFIp
	 35kqDrR2bZtMRqH5Yv18S54nh0eMUU6TunB0mwQ/1piabLYWLYJ6oOfu3wFBGjAuHD
	 vrQVzE8jdeuGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE01C3806654;
	Thu, 20 Mar 2025 21:21:25 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fix for Linux 6.14 final
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250320180522.155371-1-pbonzini@redhat.com>
References: <20250320180522.155371-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250320180522.155371-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: abab683b972cb99378e0a1426c8f9db835fa43b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f45f8f0ed4c6d3a9be27ff27347408e1c1bbb364
Message-Id: <174250568438.1915575.18231063226845575643.pr-tracker-bot@kernel.org>
Date: Thu, 20 Mar 2025 21:21:24 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 20 Mar 2025 14:05:22 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f45f8f0ed4c6d3a9be27ff27347408e1c1bbb364

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

