Return-Path: <kvm+bounces-52050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4FBB00976
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D08FF17BD06
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF4A2F005B;
	Thu, 10 Jul 2025 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cu7FgyA5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7A42A9D;
	Thu, 10 Jul 2025 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752166961; cv=none; b=bt+OiCOHNy7W2lfsGnBfnGYX66p/e+1YaQfnbhdxMqrPo7BqWfNXfNF7fysBx9r3z+gPdimNnPL1wu1wQldNzwmRDkUH/J0N9QDy/k7KazAH+BTSgluqGEjYKpinvtgvkxsAAhtRcVjTsxDmD5kXGv2IFjUXSOS5u1Cxra0wQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752166961; c=relaxed/simple;
	bh=fKAKKMdSBqRzZLrbcsxwo3WoN2zJWYgBhkXCdwB1Wr0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JQi9mVGLEcxoGxaAv7dz0xv9qp7AqOeTnWG6w3aJWTUYdvkbzsBuzfc4ehvu7OvZx7HELTmwxqK7hbNjR2++swCStOpULcC0FrSncfNDxv1v9+y0WqLYiNtBgIEbptdCK4nLvriql4jQxLI4tNJ2mmdrDeTndpzQuXIGoxHVj/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cu7FgyA5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2DCC4CEE3;
	Thu, 10 Jul 2025 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752166961;
	bh=fKAKKMdSBqRzZLrbcsxwo3WoN2zJWYgBhkXCdwB1Wr0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cu7FgyA5ZHgm2IkCElL7dXPQ2fbMo12b1Cjdga21OtmAfFZip5qk5/LKFx/oC1R/C
	 pwLGjaxsrTEs5LJBmwNmiUvI8edk+qzp59+UWmfLsHjGSJe2OG08pxL7tAfRgQBDAM
	 ovN4WAu5V+Mp1SRzVSS5eXY9gEUYpK9YktOEaFUWjbe7c7v6hda2x9czzgzqShWyxV
	 eBEN4MsGTuv+ArEnkIqVuX/QIc34wVKjinZXH0t8ZPKun0UFXZDq2A9F5+IbdVsmdC
	 VORPGOSEDt0trpI0FRy/iSWRhFCNi7MZ4Ejhju1bzyXIbFeVEMlua8qhBHGVBZTdWS
	 UdLbzxvgYZcbg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2C0383B266;
	Thu, 10 Jul 2025 17:03:03 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.16-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250710104936.232026-1-pbonzini@redhat.com>
References: <20250710104936.232026-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250710104936.232026-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4578a747f3c7950be3feb93c2db32eb597a3e55b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 73d7cf07109e79b093d1a1fb57a88d4048cd9b4b
Message-Id: <175216698234.1599846.11474661596875605855.pr-tracker-bot@kernel.org>
Date: Thu, 10 Jul 2025 17:03:02 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 10 Jul 2025 06:49:36 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/73d7cf07109e79b093d1a1fb57a88d4048cd9b4b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

