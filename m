Return-Path: <kvm+bounces-66441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E08CFCD363A
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 20:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0E7A3009F47
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 19:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCEC730E839;
	Sat, 20 Dec 2025 19:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJ63gPhd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D998C24169D;
	Sat, 20 Dec 2025 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766260159; cv=none; b=qmeSrAfjFGDPguPFVQTw6p+Zq35coNTOpfGcWBGeZo+xpf94HQ1Vw0MEIeCccSlsgLpYa+bjGYPb4NmuaTH6wv7HDvngZ5p9hSpK303amUCCNooc3viDQBf1jvi8Hbgp5JxuwRN1qrMPDqSjwjxFHizzyoKb8uvCnKrI3RpVWdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766260159; c=relaxed/simple;
	bh=LPH9s8rUL+9vX77UtP8zcYFK6VJcrdpJms3EtrelL/M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JWPJg0vJCn/sJsv4jRHW60z224YIBHxtQpY8ga5umW+kpAzpWrK7qjS92jH9DOVYqzcuDYg57MwL5tTh2YYBtxHI9slNyWJDQtIWpgnYEEQViN6W/1WqJm/HkGPIKggfyu66Drx5rXAFdNv+uBMWtuzODKg+ZIgMTr+IkDgE4wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJ63gPhd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E71C4CEF5;
	Sat, 20 Dec 2025 19:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766260159;
	bh=LPH9s8rUL+9vX77UtP8zcYFK6VJcrdpJms3EtrelL/M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EJ63gPhd/404GK6l3tC8SnrnZR1UwaqWrM0BxZSekmc9mtH8v3xfkfKCzVNprojgb
	 +5jopsXID2jwSrrZljgZ/YTF/rzGn1xBPg4NQx+x8siMUnzKTSv3v3IpNWoXyv5AF1
	 XTJw77hjIKFLCfueZmU1yxaVlJF/w8BUWBZIBAckT0B7c0xGeSjTxewponFDcJWlyz
	 UmMY/7m+/YHmMU3m0zFWkPvhIUGH9zMsbe17TlvAcOaT8+ot7ODFVIJcQHcbbGvY4y
	 wPVTdRLJ6o0mOZ/IYNSuVn5EJFlNwQsaSOJMLlafBM9BC2FG2RF2h/4kn65I4RvfJC
	 GwgCdAxepxKzw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B62AA3809A05;
	Sat, 20 Dec 2025 19:46:08 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.19-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251219131131.52272-1-pbonzini@redhat.com>
References: <20251219131131.52272-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251219131131.52272-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 0499add8efd72456514c6218c062911ccc922a99
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 072c0b4f0f9597c86ddb01fd39e784fda6b7a922
Message-Id: <176625996731.123080.1916180838435164039.pr-tracker-bot@kernel.org>
Date: Sat, 20 Dec 2025 19:46:07 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Dec 2025 14:11:31 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/072c0b4f0f9597c86ddb01fd39e784fda6b7a922

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

