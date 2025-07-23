Return-Path: <kvm+bounces-53320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BABAB0FC83
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 00:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48A581718BA
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 22:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD3D272815;
	Wed, 23 Jul 2025 22:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0YU94PT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90026C39B;
	Wed, 23 Jul 2025 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753308494; cv=none; b=Rc4qo+vpXb+ILWOJKs02lDhcYdKIWIZosum1Ta3CVhonWL9wSbmml6HJOEnEy+B/dwq/9JxcszF0la1e8n/Kdz7y4GOGtIKDerNuJgYzNUB7jmtC4dRMVQUODN18XEXYZ0bVqG8hBHQ8BALpZb37BP1z/ANOESlsEnU3+k3VttU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753308494; c=relaxed/simple;
	bh=uNuVIXy0Q282vQjWihPkc0lwsHa4MlkaaNWIs3IvATs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DY/xBPmAqhi9xcnpACfvWg/AkwoOf/iDvn+0lCsnevE5URXjAnIkHtRNoyX/VzSe+nbGMY2QuTPpOWpi6dSwlmpt8ial6k7T0aDSz4j0DVyF9eNfb7/qzgbzKiwJV2nh8prwPWTs+Rk4GzkFPZwhJ8+rn+CXCG8e9QcwlnSmrp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0YU94PT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95117C4CEE7;
	Wed, 23 Jul 2025 22:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753308493;
	bh=uNuVIXy0Q282vQjWihPkc0lwsHa4MlkaaNWIs3IvATs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=K0YU94PT0FSlc3o1R/YvojGCnhXkQDaEZfiS1HZT/dHvSFY6mb8uXt9mKvedYNe0Q
	 8xnP4mURaobUBpL/WqfwuG3SQJMTRH5g6zfhaHVy0UwAsC+QI1wmmn+sylEcwglK+y
	 dQQ1ShyB/Y6x3XrE9UH7ZR/HL6hSvlAqGZO06g9zC2Km9vXx8jCDA65beAwBMbAs6W
	 uKz+G5ieyXbXTM4YhHUibpLPDDwvaTkV3pMnO1Zbx3NGk2QQc352q3Re5zpuPYcuWj
	 56lLB0pZ8akMfsC96y8TYMinY6gbeop4Ou0J7vdhlbeO3fdjRddm5LhxrrDy2g5Hon
	 YXn8FSbas5+pA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB2C5383BF4E;
	Wed, 23 Jul 2025 22:08:32 +0000 (UTC)
Subject: Re: [GIT PULL] (Final?) KVM change for Linux 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250723215556.866784-1-pbonzini@redhat.com>
References: <20250723215556.866784-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250723215556.866784-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 5a53249d149f48b558368c5338b9921b76a12f8c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f9af7b5d9349bf92cc4d0a0baa8a151295f12f4b
Message-Id: <175330851167.1794913.423285517210481500.pr-tracker-bot@kernel.org>
Date: Wed, 23 Jul 2025 22:08:31 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 23 Jul 2025 23:55:56 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f9af7b5d9349bf92cc4d0a0baa8a151295f12f4b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

