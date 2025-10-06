Return-Path: <kvm+bounces-59550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 875D5BBF88B
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 23:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A5874F24AA
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 21:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A5F29B776;
	Mon,  6 Oct 2025 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQkZgjs5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EFA2566DD;
	Mon,  6 Oct 2025 21:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759784486; cv=none; b=WV0igK3Y1kTbJM9nIhL2tpp/bCj+QXohQ/mA5pf0r/qiFUgxIvhRkSV0u3hWS9M9aaycuQmksWQAsgvH6Z2XBLFWmXZONSU5AWdRBFwYePjIIKOajTKjaKQp3rnUX2YaSyPI9uetc7EwHMMrB6J3EhfZiHqdFzJ232Sl5SEwNy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759784486; c=relaxed/simple;
	bh=Ump/FJYJ7HSzr3xVqnWpMbWBfQVZOSdI41vDfVMpcoM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nEwk34jnysVwqMHbJktu35WuEfKcV7XGpP6UQBlTcYjGTY1XtEx2oqK/LoH0FoLL5ftSW4LgopYq5KaZFk0/OYcrIJPN4oh4aLaASO6MDMKzJ/ySKJxsKKWz0P8dZVQNEsRLgQkBEfhT72zPBtpZ/4mmJgCQ+WPieh/MeLeE+UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQkZgjs5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF84C4CEF5;
	Mon,  6 Oct 2025 21:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759784485;
	bh=Ump/FJYJ7HSzr3xVqnWpMbWBfQVZOSdI41vDfVMpcoM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AQkZgjs5Grpv/Sc3BBwgQdQWGI7yVZ6aYKtbcQ2Pvily1HGvoUvU62eAcGv3QrhSQ
	 T7qxRHHUMwaugMggYmiQrPN8VdjwWSk5NNTEzLvbDeexrpDdotMpavams0rE7VrRnQ
	 XIAtdM27vHgqGpWST7FDYLyCCCPD5PQQfVPuz0/zRd/7wep+MN0k2FnAhZdHtqf96l
	 qWWJqPNIeDrMDN2rSerpvHya/mxJKnJYxC5nvqb70xdSfvWlrvUXE/hd516tTyN4ex
	 56J664WZOKG/G/dBrCg32AsMFolhLH3AXYlmf/KWhgfeIeG3qIEB+1wnIiR6GqJNb2
	 JL+tfxMnS9bXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2E6383B26B;
	Mon,  6 Oct 2025 21:01:16 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251006141011.74372-1-pbonzini@redhat.com>
References: <20251006141011.74372-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251006141011.74372-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 256e3417065b2721f77bcd37331796b59483ef3b
Message-Id: <175978447516.1596365.10402571502051928881.pr-tracker-bot@kernel.org>
Date: Mon, 06 Oct 2025 21:01:15 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon,  6 Oct 2025 10:10:11 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/256e3417065b2721f77bcd37331796b59483ef3b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

