Return-Path: <kvm+bounces-18927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9EBE8FD23A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45C1D1F23180
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B7715216F;
	Wed,  5 Jun 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnAMLMmu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF9645005;
	Wed,  5 Jun 2024 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603144; cv=none; b=RGSycrYmPGouQ5t6mYYhbGw84E+PYkwUs2Tx7diFDQokFd6NQ6azyhfCCz7OPBU2GJcthbhMSJcUnP2xXmp24u+myDCQ/axfD+A2961hdpw5Hk8u62iph3a67d+5z5/pjrS2LKoHD/8WlvopA9/yXlprqUIpawkryx+YBJwoFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603144; c=relaxed/simple;
	bh=kJA6RCQe59gNhyFE5vMGx7WY/pIvBmdhj6ZGWBW3ICk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mZ97TiU59zUZgnuIoj+5sCxWQEovaI/BKE/S3d6lYRjEQ6DfIhvSxomLZIienQZlnMIGfvr/OSxJTHGu2bf/nvcXswPblMsVsQa61RVEKdFZ+Zz1V+phmlYmCKKZ+EteSQzl46gbFkj3XiM+LN/CoUVTIpkJokezjyPTrAcz00A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnAMLMmu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ED44C32781;
	Wed,  5 Jun 2024 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603144;
	bh=kJA6RCQe59gNhyFE5vMGx7WY/pIvBmdhj6ZGWBW3ICk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SnAMLMmu+oyRAIgx2NAOHXCQtQ5GcSYmmoEruoa1ivceAzWr84AS7h2x1D9hrzTR1
	 hix887ByU6/y6QU9tVHTfsVVfYUWvXz1lh8KyNllFNwpGRUlVNjSyV5aZ8i9suARDO
	 VMW8CL3bN59kgo98wvL5oXyVkKxZMoq7WamqJQoFAH2FYaHGe6hVIEYdgU9qjTiIzE
	 QUhOTnb6vUOeAU5AzKs77nOKza8o8Sl0TwQbR0Em3YCnMnfuOOMwvAlpydMTS0+skM
	 JUrGA/DuRWyl5D/bdO2Nob2A7rmENoSCRMaUpwwZHBCdlRl1nnco4x9NWJotC6IIwC
	 HoHhvCJ+lDNpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89A54D3E997;
	Wed,  5 Jun 2024 15:59:04 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.10-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240605115644.8573-1-pbonzini@redhat.com>
References: <20240605115644.8573-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240605115644.8573-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: db574f2f96d0c9a245a9e787e3d9ec288fb2b445
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 71d7b52cc33bc3b6697cce8a0a5ac9032f372e47
Message-Id: <171760314455.19032.4936003001185258170.pr-tracker-bot@kernel.org>
Date: Wed, 05 Jun 2024 15:59:04 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed,  5 Jun 2024 07:56:44 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/71d7b52cc33bc3b6697cce8a0a5ac9032f372e47

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

