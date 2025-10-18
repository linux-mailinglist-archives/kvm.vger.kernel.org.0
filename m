Return-Path: <kvm+bounces-60444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2E5BED541
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 19:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2394819C1216
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 17:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564D225EF9C;
	Sat, 18 Oct 2025 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VI8rVAdt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FCF25C838;
	Sat, 18 Oct 2025 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760808468; cv=none; b=BIFx+AVFBKOP1fkxCxFpwtrvkfkr/K85KKxzgl6eRhjNUhMu2uiW9TaVgdV2ihn8sq6b2NC7W6ZJV58YLZKZpuYeWQmlIKNtLpdk3lucKfAZCJDm4ddmK7t+3O3PXI1XGCJogfw7t9SALZhSgyqNbvg6wIC3FEihNXUH2i9oWiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760808468; c=relaxed/simple;
	bh=WOAVhWPsgqBr+Xuibi9BNUKajNdE9hGanhzf8fdOoE4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hG+GVBxjzKm/TgMFpNJa9aE1MIVAGuCRpkvRg8dRP4CpRAu2uzAjky1TBx75s/uEh5PJZgaxy9IyEZpToBsq+09zQukc9a1cwoj24nsBLSwljgoACLI1KGBdBabN6tIjy2XkToq86jG+6wCYAgAGtTjw0SB/UoL/K/g5T/RdEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VI8rVAdt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586E3C4CEF8;
	Sat, 18 Oct 2025 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760808468;
	bh=WOAVhWPsgqBr+Xuibi9BNUKajNdE9hGanhzf8fdOoE4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VI8rVAdtndPlU4iAWVtxQvAp8xRHX8FIOr870bZqdAd4Skc75cTtQdPM98k1ZMo6I
	 qQ1j3F+SC8FwlgnmBPObzPozwPZAAGiiGOCaaepgJiv6zteS+XpQbGfQRb5oJokilx
	 VlQ97AyRU/qFIIqlr+Nc12dwcfnlJ1sKSADau3T2x2ua+5PVdTjM57HbD5LjifCKUY
	 nruUs5TmE7k/79mW69F7FG0jRg1VLTPFumyDQWg2PrCWq+4geiKtsGNujZ2Mt4lV80
	 gujdW6xIUOppxWapqDjn0K0I8zqPj3mYN5xBmlL6J1u3P/knXJst8XBXAgyHdYgUl1
	 d9+lJ7bBrRXLw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE47239EFBB7;
	Sat, 18 Oct 2025 17:27:32 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.18-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251018145533.2072927-1-pbonzini@redhat.com>
References: <20251018145533.2072927-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251018145533.2072927-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4361f5aa8bfcecbab3fc8db987482b9e08115a6a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 02e5f74ef08d3e6afec438d571487d0d0cec3c48
Message-Id: <176080845134.3050468.5640299267808320826.pr-tracker-bot@kernel.org>
Date: Sat, 18 Oct 2025 17:27:31 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, maz@kernel.org, seanjc@google.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 18 Oct 2025 16:55:32 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/02e5f74ef08d3e6afec438d571487d0d0cec3c48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

