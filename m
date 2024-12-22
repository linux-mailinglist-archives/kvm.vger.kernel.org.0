Return-Path: <kvm+bounces-34320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5409FA83C
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 22:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E75F1165AD8
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 21:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F227E192D9E;
	Sun, 22 Dec 2024 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcGNJNLT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE89259489;
	Sun, 22 Dec 2024 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734901657; cv=none; b=AZibwCRp30lFqSIVT6L+yt9GrlV8jYhxKJK+F3idGZMzR6Ab0EuLfzCh8oRxNMKpeKL1TcAdDnHsM1E/dKZ2Jb/2SB1t9jJ3XCzHCuJkrupkgZnxPNoTwAtzBDJgrSQCH5cioUuG45B8ee/kwbsupc5shcGPhi0kMiai+WUYENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734901657; c=relaxed/simple;
	bh=fC2ngRxsCACSSpg4R7QpCaEXeV6nsVFI+4V5f1o1/aE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KmelMtnZ7OkHqikIt658IuxzAGgwp3y/vTub4J2F6kWHC6QkL9ZtfqmL9csiUfeebOtmDdd3OYsOg1F3DsKN4+KEpB712zx1Y/3lYQWZEXht4KBtWFOjg+qBI+xJGH3s3LQTiOGPY2D68kxCAQgOr6Gh5KsGiTUTnNTq8iiB3Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcGNJNLT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4790C4CECD;
	Sun, 22 Dec 2024 21:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734901656;
	bh=fC2ngRxsCACSSpg4R7QpCaEXeV6nsVFI+4V5f1o1/aE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qcGNJNLT05OU5HiQhZtTs/KenO+t0Tjy6rAEQPgiqTQrCFEr4WTrgvVqKk5P61JXk
	 dnlpzcGx9Zn+32y6Aot10LW6zwtWWn3TmdkkJH74AQtgNmYd5Pmyd9evUeFVbw91kq
	 /y+5PrTMOqa5htp8RnBMqQPtaSdV3RamIF3TYrtgi6N/oHqFgggE/Kijt3f61t0FXO
	 HBk6MeWEvPXWouj9nDgqVZIb1/RAayuHrpsX2ZtSoVNhG0fFFAPKr9SyYI4G9w1Mar
	 d4v9nfcD62PMYK9OcaPyNTx5NV5QlpZs+NL7+TTBTQlcRmgMH5DR0WpaYuWZUQFPOn
	 uVHPANPFmhuHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710EE380A955;
	Sun, 22 Dec 2024 21:07:56 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.13-rc4 (or rc5)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241222194225.355168-1-pbonzini@redhat.com>
References: <20241222194225.355168-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241222194225.355168-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8afa5b10af9d748b055a43949f819d9991d63938
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1fdbe77be6d31d78ecc2a82ea7167773293fed0
Message-Id: <173490167492.3400718.3484153490733071462.pr-tracker-bot@kernel.org>
Date: Sun, 22 Dec 2024 21:07:54 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 22 Dec 2024 14:42:25 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1fdbe77be6d31d78ecc2a82ea7167773293fed0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

