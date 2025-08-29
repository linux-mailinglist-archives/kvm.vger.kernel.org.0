Return-Path: <kvm+bounces-56376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AFDEB3C529
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D019A65FCD
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7752D63E8;
	Fri, 29 Aug 2025 22:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcxshr0E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCAB2C3272;
	Fri, 29 Aug 2025 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756507309; cv=none; b=Bcz9i41KaCPjiDAhnFJ0aWciQ8W9jttNgp7iaaWFBb3b3HjxAddOs+wsd6bAVM0H0466aCm+iFLMjeoXEbIfZa5v+oRLvvimOpBBteWpGOxL9pebs+nmJ+5wFD5+dPKDIjtU266w9B15QWYQfWqqjHhRGIczCD+hWDEQVMfJ2b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756507309; c=relaxed/simple;
	bh=txD+vWZDNrR/TDaoW5sGV/zEaE3gyzzeNma5uR4oeTw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JAoIRxZGa1r0qUg/nTTuWIblbE4/rkeUMWC9yiYPByvsVbWEisUK9Qlp4+d8xER6HbvxhMvCYffcmOXi25V6H2bOKVKCltKqbadtwkNABzExNTA/k1/VH8U02K82j2BMuATipKTFtlBLs8xjPvjuU9PyZ84Vl0zYqTHCC1e07xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcxshr0E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A5C4CEF1;
	Fri, 29 Aug 2025 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756507309;
	bh=txD+vWZDNrR/TDaoW5sGV/zEaE3gyzzeNma5uR4oeTw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lcxshr0ECtQZ6PFHp/rSazFlm+iz3oHfxIXvIYDufbRtPHe8/0uhlo/Rl+MjtN7pd
	 NiLdZ6jxnvcivIAkpdFUfAYZZ0pbQukh9Ezv1WpARH4qRCWbQEQ5ApuPu+QttNJQxs
	 RNO4EdBsZpcOtOWvPIbX+luYXzWYtHmzN6RlvBMJMPeVEhj84WBwXByVogqnfo385v
	 2hv1XvvkzutGwUEw/oSDeBpt+O0XSpKyeAGsGjEG8PpjEFXM2hAIk9Y3a6Hb3kizNs
	 qhKakV6lwFIQGNiY3s2z3K/zTdZSDM1rzBdTXGf600QvZ3bB7enMWtqueZflgXaFiZ
	 ghv/hndKnLxLw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71039383BF75;
	Fri, 29 Aug 2025 22:41:57 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.17-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250829172727.169887-1-pbonzini@redhat.com>
References: <20250829172727.169887-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250829172727.169887-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 42a0305ab114975dbad3fe9efea06976dd62d381
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11e7861d680c3757eab18ec0a474ff680e007dc4
Message-Id: <175650731592.2358151.15194419799133888093.pr-tracker-bot@kernel.org>
Date: Fri, 29 Aug 2025 22:41:55 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 Aug 2025 13:27:26 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11e7861d680c3757eab18ec0a474ff680e007dc4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

