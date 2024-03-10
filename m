Return-Path: <kvm+bounces-11478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D1087779B
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 17:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8772C1C209A3
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 16:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5E3383BF;
	Sun, 10 Mar 2024 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcZozizj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD32D1D6BD;
	Sun, 10 Mar 2024 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710088439; cv=none; b=o3tz5IqRvdJao3G1/FrT7UPtCpx8mXIHVT03Z1gQ50usmqMSHCT5hqcU512K1OIPo5QUvIscpbVD7cE9HPQEqGJwkKZOgsG3jAXW5kLhBjSqwe4/Tu6UBAqY5JuhhB/xhTGaBl3JatXntplftEDB840DCbi4/JzFt2KMf7NZEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710088439; c=relaxed/simple;
	bh=Z8jOyUxP/iAvH2vnccw1mUuAZX3CM9L4UUvgDWTGcpI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fu0bGOQVEFc2t0vgozlBqxjd8koR7TaZFf3gjiXNnFWVVmALMc30B/qdCg/J8QLB3jFLLCrQFaH4DUHP8hCNBQm9SUwthSEIaFBNthusg/dTcOLFitIkMIJelzbqTkLsxLgwNyx/4zSCABwiOeaEo56xHSJyoxMKUP3yNfPqdgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcZozizj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD143C433C7;
	Sun, 10 Mar 2024 16:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710088439;
	bh=Z8jOyUxP/iAvH2vnccw1mUuAZX3CM9L4UUvgDWTGcpI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tcZozizj0gpmc74mAZq1hJ712xBpcCzJdyBwZ1G0048BLAqBiW3SL7RVITI1lwELC
	 vKL8akKRV7F5DFOw1azQhoQEoTXrJMyOb83THTBQxHKwiFAY6Q9hfCRwEMolBzHLjG
	 /TpkOWoB7tr/PTic1/ziz8D2HtP6G43rYd9Sfyq9IVlF6h8eSYUmaStaLoArvvf6E4
	 gIfKtyl/rf9bxEY8K+0M/DOilmberEjOxCURPmhjurq8SfrMQI3gR3KvHLIUU43Mxe
	 h9JsRDVGlPcS+6mly78wbHM1VJy6aD0LM+l5eNKa9rInK1+zCyUOxeyD8KHwZcEcoJ
	 frBQp6GaRhDeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B76BC04D3F;
	Sun, 10 Mar 2024 16:33:59 +0000 (UTC)
Subject: Re: [GIT PULL] Final set of KVM fixes for Linux 6.8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240310093556.653127-1-pbonzini@redhat.com>
References: <20240310093556.653127-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240310093556.653127-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 5abf6dceb066f2b02b225fd561440c98a8062681
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 137e0ec05aeb657472d2f84dbb3081016160334b
Message-Id: <171008843962.6744.15399494588773965243.pr-tracker-bot@kernel.org>
Date: Sun, 10 Mar 2024 16:33:59 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 10 Mar 2024 10:35:56 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/137e0ec05aeb657472d2f84dbb3081016160334b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

