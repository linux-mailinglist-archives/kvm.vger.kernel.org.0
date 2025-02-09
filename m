Return-Path: <kvm+bounces-37666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF40FA2DFE9
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 19:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59E9E164803
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 18:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E141E25F8;
	Sun,  9 Feb 2025 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXNz/1i/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D9B1DE2B7;
	Sun,  9 Feb 2025 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739125940; cv=none; b=pqbbv7ou3pxdV98q00bLJc6kd4FNaNdQYxcy3sFYrM5evSIyAnlTabhfNWFGyO6f00tVPNIGY2erYNNPF9TF/th+PNPo0ob+tLdkFZQXWYatW3amvPoKwKl4ip1GBLW0bAW95Z9bIsCnlgXGvF7ys5+AVsJwknPGVVgM9K4Nma0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739125940; c=relaxed/simple;
	bh=IeEVt4Salrmd7PHNGPDlTj4jHiN+k+mJMoBtq8qbNlc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q0Uhugqs1WzDexKuadFa6egG1/8iVYvelDkseTKYVVdTF36CjBhmC2s5TrbaTk9mLGXvgy+xqwAyfwZ67CzX+I4Ji7yWA4grSTgDPOo1iBnOuNkYC0fPA4NceJlNXPZhtJ/Bh5PmbR36sirmdPbckOglsdhRiokfdTs8j//rE4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXNz/1i/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D7C4CEDD;
	Sun,  9 Feb 2025 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739125940;
	bh=IeEVt4Salrmd7PHNGPDlTj4jHiN+k+mJMoBtq8qbNlc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kXNz/1i/af85S9+BCdhrGSDI6GV2bYsTPHQ4luOyXwQdIQMcVDNAWjlOBBpoRSyxT
	 qFxi3qCbUheQvDsDgNSWUB657E32DY31S1hUGGY0awoWagguTnaXMrCZT3RmPq3TDh
	 D9Jwljzp3HOEQXSEldIq2D/8JJyfKJsRBcRjVb9ECBx9NI3Zm7+ntw6bohaOYjqYLo
	 7fWMYbSkh2mRWb1P0bIrTlkvbMvv959Bonc3Jnu0Bc2gWPszYJlsrN49XP1ngOn+pS
	 VAfMWp4D7cutKJ+Obh5or6NRNiDxkGjcYtb3tSAtXOUaVvkBwdIjP6ckj5vhVT7d+t
	 +KRlKMsLHOCqw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EBBDA380AAEB;
	Sun,  9 Feb 2025 18:32:49 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.14-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250209071447.2521861-1-pbonzini@redhat.com>
References: <20250209071447.2521861-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250209071447.2521861-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 43fb96ae78551d7bfa4ecca956b258f085d67c40
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 954a209f431c06b62718a49b403bd4c549f0d6fb
Message-Id: <173912596854.2868883.12596754805247538634.pr-tracker-bot@kernel.org>
Date: Sun, 09 Feb 2025 18:32:48 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, imbrenda@linux.ibm.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun,  9 Feb 2025 08:14:47 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/954a209f431c06b62718a49b403bd4c549f0d6fb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

