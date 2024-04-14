Return-Path: <kvm+bounces-14606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C168A445E
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 19:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 593201F213ED
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 17:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB6A135A6E;
	Sun, 14 Apr 2024 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3g9x0CZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C86C135A4D;
	Sun, 14 Apr 2024 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713114773; cv=none; b=sK4ooa7u6Dfaym/5cs9QSseyo/Jd26uo4B3ohesa/FtGYJ90b/qNO9BIhgokHuVdsHfbqwwtCpJUIU4qUFLFbeJoF4DKtgWWbxnSyWaHjfNhjYw3CDd+Y1F/qintb5WSMaZK7XnzDrmpICHP6xPLQKBxlnXHaofe/EZJlLJ6J/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713114773; c=relaxed/simple;
	bh=DBvYJh2YC3326OOwmiISNvaZ8uqYe/EkC4jNLmlnPVI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BQTEJaud3+lLp1KyjSuXaRKesDuAqUxc2ZoaotTV5yP7jawnwPBrYxCOn2egnHGyrrG/n9uyYnAKjtbg9SLKXTxrLucqGfucYwbQzieLGL6wec5UULDRre2PRZXDcubLQmI/yb0WO5tvh3ApjoqrlnrExNNGBCaZiLURcDA7GTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3g9x0CZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B13C6C3277B;
	Sun, 14 Apr 2024 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713114772;
	bh=DBvYJh2YC3326OOwmiISNvaZ8uqYe/EkC4jNLmlnPVI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=a3g9x0CZdfnd9JDdkd5ZXrgwaM6nmRB89VNlv2qMfHpl8eC1Tdgcn0MXmGbpk237F
	 YY20SlVwLz6fdX8S7etIgSCYxBIAn2F3j2+aK2sFWRvXbSUI6KRAPXsoHtQaUWK7rP
	 rijctqXn50ePDWhywgmITLglmQFB89AdFFofPLCk2iQauuJ7EVnYZ12NfWZQSe3GGE
	 Hqhmh4hFzRY+NPhkOXBdy7tnc9zH5/FPzbD65q69X7VDKZDZUNlU213x5fA2x2anPK
	 /c1KpNFGInHThlA0acJ6b4QoZwCUfQlRMLMXaYTQ3MYZ5ZRDZ/ueibdpqHLVNdEa3+
	 RVhmZ3NlTrYuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5D04C43140;
	Sun, 14 Apr 2024 17:12:52 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240414042047-mutt-send-email-mst@kernel.org>
References: <20240414042047-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240414042047-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 76f408535aab39c33e0a1dcada9fba5631c65595
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 399f4dae683a719eeeca8f30d3871577b53ffcca
Message-Id: <171311477267.23099.5771272291946432817.pr-tracker-bot@kernel.org>
Date: Sun, 14 Apr 2024 17:12:52 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@kernel.org, gshan@redhat.com, jasowang@redhat.com, jie.deng@intel.com, krzysztof.kozlowski@linaro.org, lingshan.zhu@intel.com, mst@redhat.com, namhyung@kernel.org, stable@kernel.org, xianting.tian@linux.alibaba.com, yihyu@redhat.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 14 Apr 2024 04:20:47 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/399f4dae683a719eeeca8f30d3871577b53ffcca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

