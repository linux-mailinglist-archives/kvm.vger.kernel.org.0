Return-Path: <kvm+bounces-32787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACD19DF3CB
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 00:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4080D281678
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 23:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8391AB53F;
	Sat, 30 Nov 2024 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYGEgEWk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F56149DF4;
	Sat, 30 Nov 2024 23:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733008517; cv=none; b=JtgHXtTnS5ukBR5fGdSr/2JatwCvBESupp02FlnS86jhzfbxVJZ+dWKDbXdT0hGpy2eUJFA+oGQCaotSdtT1xlUQQjHVD37u7QdbhQauGEDWQHK/2PUPh3QylWo1lVKJjZMe/OejJe/YP5h43lujunBhbqQ1w0qvnS9npOytD1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733008517; c=relaxed/simple;
	bh=lxgYj4aCos8b64YCRfCrVPnsl5CdCAdrJYJfD8ZpwM8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=W/v5Ax77cOeeQpGG6yix87dQYpZiDeulnd1RnDzqUKflE0GfiDyTHPmjuFrs9q1NykA63qUZT/t+bo1H4UPK3LeWxlRop42oRttR9wjAQjf3wY5GQy0MO8byOcF7Hns12F+zfNJjNWCzzOd3OK+STe/vNGw9RK4UcoYk0YgARnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYGEgEWk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792D6C4CECC;
	Sat, 30 Nov 2024 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733008517;
	bh=lxgYj4aCos8b64YCRfCrVPnsl5CdCAdrJYJfD8ZpwM8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tYGEgEWkXTBrLES6bYpMJfTuQCo3lRk8MBmTtM/VeocY8vzWcHbA8IeIyMW2N5Ysj
	 wUyo2Cl9rAorSCNAM1LauLJ/jWnbGpkR5+sHzDDLRigB8AIDslAY2TULqupF9pZ8iN
	 E/Ozm+WKR8ZN7dk8dpjT2ovJRvLPGRXH/RNoFXotHjBpnctlg96HmEjr/VE1twiNYN
	 LbqKPpsQCtk9pWtBCPJt4pje1W4HvanKX/Ic6GFyENgZ3T+bCzeEGZvbUMswnjuqeM
	 oxUKpEwy5vYg6ZzKxoB3XmY7SNPj5bW7tQVFjj+ZZUbrUB1hhctYDiU88SQBlGKmNq
	 gDhNDSrDz04Xg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F95380A944;
	Sat, 30 Nov 2024 23:15:32 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241129231841.139239-1-pbonzini@redhat.com>
References: <20241129231841.139239-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241129231841.139239-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c4bb3a2d641c02ac2c7aa45534b4cefdf9bf416b
Message-Id: <173300853113.2503582.12707891667313640125.pr-tracker-bot@kernel.org>
Date: Sat, 30 Nov 2024 23:15:31 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 Nov 2024 18:18:41 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c4bb3a2d641c02ac2c7aa45534b4cefdf9bf416b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

