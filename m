Return-Path: <kvm+bounces-26943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2A097950D
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 09:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFAFD283700
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 07:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3853422F19;
	Sun, 15 Sep 2024 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eO3xnsK9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486321B85CD;
	Sun, 15 Sep 2024 07:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726386098; cv=none; b=MetXBls6gYXAW62Rau8XAGVGcXRUgZb/uoHcgoH1tx1Mp1GId4EcE9uprdSWfPKqTqLhI64I/9EveDH/oWIdomUOWy6d2V2eL1tYaUboGPrLaJHZbY+Qyq3jVxw5QRHOxU+tBTxouZUHrDwYGJ4sGPCYegMJ7+cMnLu9R9kBlV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726386098; c=relaxed/simple;
	bh=9H3qxg92rzc5zfLECW4TicvbMckAfbWjXh7xepnFSPo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=l8g1SW6hhd/DRokWceOzKkXGwG4t3QLyYu0Dm8waYpWPmLU2V9OWMheukr0W1cGadt3J7RYWHsrL6ewet7Yw5eeH3RDe6yAdDjwbzI8ZFPRDmC3Vh8xUAp33lqUHBZOToMJW7rYHuUGuUXfDwp9RrIyc2vpJxg/zY6esWN//Xno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eO3xnsK9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBBEC4CEC3;
	Sun, 15 Sep 2024 07:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726386098;
	bh=9H3qxg92rzc5zfLECW4TicvbMckAfbWjXh7xepnFSPo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eO3xnsK9+5PfRf/TOdRp1sDWR6JHbCGfLUM+4em5rjOP8Ej+ZtyLVJp4kw2OZmZyK
	 cpLgpigNuwUGhnJqW4iMNP3EdjFxc9rERmIrwcv7UMpzPs2rSkaTKix9vTnnbYRZLj
	 E/JWLdsByyI17tWplBgPa0xv0jhhmFfhv4By345EOjNwYOyNRzb/PnE9awib023ztf
	 dP7hmdp7t5nRRFBhDkIl8vMelDihmtSO9wN7g2+iGig4vuSVyVWwuUeV0WelRDDLZo
	 RgodqQwcPfISE3wb5TFJlCyI5yemcNFCG21tjA4sUz/wUfIxC4F8zztSf10hHmxRKt
	 UYgk/iLgvH18Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AEDF43822D1B;
	Sun, 15 Sep 2024 07:41:40 +0000 (UTC)
Subject: Re: [GIT PULL] KVM revert for Linux 6.11-rc8 (or final)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240915073010.5860-1-pbonzini@redhat.com>
References: <20240915073010.5860-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240915073010.5860-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.11
X-PR-Tracked-Commit-Id: 9d70f3fec14421e793ffbc0ec2f739b24e534900
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d42f7708e27cc68d080ac9d3803d27e86821d775
Message-Id: <172638609915.2722482.11806654902543829085.pr-tracker-bot@kernel.org>
Date: Sun, 15 Sep 2024 07:41:39 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 15 Sep 2024 03:30:10 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d42f7708e27cc68d080ac9d3803d27e86821d775

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

