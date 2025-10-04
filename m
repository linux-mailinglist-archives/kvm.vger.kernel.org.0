Return-Path: <kvm+bounces-59495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D4CBB90D2
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 20:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 656364EA3BC
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 18:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF57217F33;
	Sat,  4 Oct 2025 18:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mX1jThVd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2641E51EF;
	Sat,  4 Oct 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759601913; cv=none; b=KyA49QEDWyvrSCZE+Mm5db0aXKOP9PP2bhY87BT56IdTPlRZCREC8TPKO37/IpVfSLCKcuJN7Z3m+HgzdzhwJJJoxqoq+Oei6G8njeGBu5GV1TvcYz96xnKEt8/WPoIMi5UIhYCqygoKv7jY1ls655YRatsngsIIe6NGPZ3yNU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759601913; c=relaxed/simple;
	bh=K31z83YjkWt4CrJtF9r5IYOD8ZEdTrjF2GYDzjc4uIw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=d7y7D1gOlcU3Cr5XmEmsmbBgNh+pC/yB0zLaQx8NdWaMgU6CIS4SykjDndpugLDuQEBrMMvx380vMYgHz0GDa4MuG807qzOgU0k92k0WLI38hoZrjsirYUKkQfgJpjzmdtczHvrDfRprAEsn1WwJaQZxZhaulH/gX4H+MkTK1l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mX1jThVd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2457C4CEF1;
	Sat,  4 Oct 2025 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759601913;
	bh=K31z83YjkWt4CrJtF9r5IYOD8ZEdTrjF2GYDzjc4uIw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mX1jThVdLjrnTzSrljKoqp3CzLY6I2VHBjm5g1KiZY5oqybSjemfZ7kVCYP2CYoYP
	 ubLTdtYMdPNbAjTeW7CSM8BbNhfYpyojXlhbzGcQ1nBnul97sjOKpXpYgRm5nK+qtC
	 JPD8Jz8Ug/KOSJgY03F/df19ZWNlsMwfXD/wAtpJ8os/wEtvieoh2aw0KKXb0bcz+d
	 xV6hDEOrHp2Jsx98pFS9JJ5ZC1BSdRNUmjQoqknr/2OBg6HvZa5wrZwnKjtYDxxevJ
	 MeZwJIkvEKo3GpZXIp59kp+9MrChIfnvyTJujMvMthCAW64UunSq+cW3t3hGRVkWpS
	 G0cHUAir1WhdQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFED39D0C1A;
	Sat,  4 Oct 2025 18:18:25 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251003131028.67395-1-pbonzini@redhat.com>
References: <20251003131028.67395-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251003131028.67395-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 99cab80208809cb918d6e579e6165279096f058a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3826aa9962b4572d01083c84ac0f8345f121168
Message-Id: <175960190426.404121.1412462422892921015.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 18:18:24 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  3 Oct 2025 09:10:27 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3826aa9962b4572d01083c84ac0f8345f121168

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

