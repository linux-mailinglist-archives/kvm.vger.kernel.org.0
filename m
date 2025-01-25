Return-Path: <kvm+bounces-36598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7140DA1C4EB
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 19:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1296F3A847C
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 18:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB7C13B792;
	Sat, 25 Jan 2025 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyRVQPFh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70B137932;
	Sat, 25 Jan 2025 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737829790; cv=none; b=VmADD3ki/IefYj7kvJwaqAU7VAY1sO8E96U6nUhYtzi4Q/nzJxTxaxF2eh/5R4DQaAGS/PNdKUFgFsEx3xYC7wGsLBwdGvszho5FWEjIFG1zNnkHsk3INq2XjorRxWjaOvMuQr4XUI4hQ7InDCzl8spudfg3q1DSXcVjNFRCV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737829790; c=relaxed/simple;
	bh=PXZWJRdSfNzAI7BaXN8XsagKJK3PHkm4Uoj5F/xI5Es=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FHhgmOwMuoibymIeJpLVgocajNGKvK2LQHWGf/saub0FDMmoisvt5xuWvTnOdGECuzy5qvIs4myEXaqaAChuVECgFAiJyX8raSBv9G1AaPyZP4d4l+4KoTlOWgt4EMh7H8N6vq8JnYPDvz2yBiGbkfHAwvNx7q6F4iFdeECsSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyRVQPFh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E132BC4CED6;
	Sat, 25 Jan 2025 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737829789;
	bh=PXZWJRdSfNzAI7BaXN8XsagKJK3PHkm4Uoj5F/xI5Es=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LyRVQPFhwnvH6pMKsPhSKeSc1uCCeUdpWbeAGD4Eow8TUCnWssJCtiWQ6eoboTkHH
	 t9gklY5tJz+BLVC7Mo9lRHwDc8eczEb+3tOztfpt+rutI3ICaeoZCwUD3CwnmyadPH
	 b58sR/yWzl3isFx/HWdzasc2cj85eXmiRBpATKtVSgZISH2MhKpfpdt1djLTW9lSfC
	 czeLO2phmF1yLUedusDi2asIuLJbFzvOcaVKrheQa5Gq7BCf5Es3tg+fLyRHJcFP1x
	 zVfES5imqgXIHk6fD/cMiibnBjz4/yLn+lk6F7FwSXP1mM00kRTm93nlyUONiAMFGP
	 RtwyEcpJ72cIQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 558E7380AA7A;
	Sat, 25 Jan 2025 18:30:16 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250124163741.101568-1-pbonzini@redhat.com>
References: <20250124163741.101568-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250124163741.101568-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 931656b9e2ff7029aee0b36e17780621948a6ac1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f8e26b38d7ac72b3ad764944a25dd5808f37a6e
Message-Id: <173782981528.2581083.11031023589297138310.pr-tracker-bot@kernel.org>
Date: Sat, 25 Jan 2025 18:30:15 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Jan 2025 11:37:41 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f8e26b38d7ac72b3ad764944a25dd5808f37a6e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

