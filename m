Return-Path: <kvm+bounces-53766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E64B169B3
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 02:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DB40583407
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 00:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AF71CF7AF;
	Thu, 31 Jul 2025 00:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S62bSBTS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E61B3930;
	Thu, 31 Jul 2025 00:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753922114; cv=none; b=LVozedLbP/Z0We4L8rQjuJEKuUtDhVjL9bcm5fHnxeakpXDM97Ff3XTuy8YWGmTxDdUT4veqUGxd/r6fbNnM8ZPCd7KHxLj8xfkbZPZoeMvJCQosQJ2dLH9vPjyzEhL5ZkNlSVMCKUHA5lsG9sKpNHD5Q0MWHIN7yZ8JUkOtcCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753922114; c=relaxed/simple;
	bh=f4OCDP3VI8oYRCUsmX363nzELsnnz7LFD5EZ//Bn7JQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aohPy6QzzDzk3GTApaJJAbukVAUzWs6MbFzHCccklA+FRRD+dz/Bg4hjXHFjfiVfQcifLe/OtKthoXr8ruEzw0/3bJmEN7TZShE/7658Vb8c8v8jeVY7EJ8VdxyGa6O8QaB+fSrWeQWNdD4LTo/39AGbp+85FDAGvL7PIFQ5LY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S62bSBTS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD58C4CEEB;
	Thu, 31 Jul 2025 00:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753922113;
	bh=f4OCDP3VI8oYRCUsmX363nzELsnnz7LFD5EZ//Bn7JQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S62bSBTSscBgpnmUtYgbQ0sBLCvMKx3Fltwr7HZiJV/t2LbRzu927cv6iZO4rP6zD
	 5578EZ9pyw82cbZUSvwcDHwDloMl+ARkTasi0UmGz1FaBgc+nTnxZZPsHeKtW3hrp2
	 DeRIJfNnr1v9lmcBS/JFd4LmMxm2QtRmgtlH5u2TlY2qEV7PTw2TxjjwCqy/nVRhkR
	 sn1ptw4Xp7s+TYhaTOdaF/iZ2Bq19aRPfVb+/XMfTqqW7Sj9vGVv5KndyaTA6U/bKP
	 P/rWH6yQnTeVAhN0BtlM5G/1MtUUiXTuaATCTIatxLn5j28ixYjHIGNTH9U8FPxPwY
	 BfmGC07Srr3xA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAED3383BF5F;
	Thu, 31 Jul 2025 00:35:30 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.17 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250730181703.113459-1-pbonzini@redhat.com>
References: <20250730181703.113459-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250730181703.113459-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63eb28bb1402891b1ad2be02a530f29a9dd7f1cd
Message-Id: <175392212951.2556608.680633563748117193.pr-tracker-bot@kernel.org>
Date: Thu, 31 Jul 2025 00:35:29 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 30 Jul 2025 14:17:02 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63eb28bb1402891b1ad2be02a530f29a9dd7f1cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

