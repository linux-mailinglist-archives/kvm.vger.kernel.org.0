Return-Path: <kvm+bounces-54215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF903B1D201
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 07:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E070188FF9E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 05:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D4621A424;
	Thu,  7 Aug 2025 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8SOXWJA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EEA2144C7;
	Thu,  7 Aug 2025 05:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754544604; cv=none; b=bDCec2iS+JDlbNEnM9ey8eOmUhBZmvuMM3Q/r+KUMpXIu+7xr0q9CTeaZz5IhKHw3eZVkg3y30Gn/8XYFcQNpHINtBo2cyWkf5e4+Tt3AA3XalRXCiNz/n494C2EzHDarRJ8HQPxb89PDn7WbHI3SScdRb2UHvynfBZIM12lPPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754544604; c=relaxed/simple;
	bh=yw0wleab6JL75QDCKh9JpWhe3+4w2rgAvg4L2KdgAOo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CA64LgM7L4+m3Dp0XesBPEJNwmzaGMzYphVD8PhAV7HppU2cKIPRTncYV3mObjE4JHn165eACuGZLhUAeuW09Dr5tiaE2ymk0HCaQvaZDwZRk4vMQbpMmwu3NazoFm5bcaiZpg9CivbofuuGw1QX1cwG8A8K9A9TDvaX61/YbGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8SOXWJA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F4C4CEEB;
	Thu,  7 Aug 2025 05:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754544604;
	bh=yw0wleab6JL75QDCKh9JpWhe3+4w2rgAvg4L2KdgAOo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=V8SOXWJACmYtcs1VLcNckvn1pWgiIgNTf30HekKZ2Z4F8Hbyb+5T+RTstQ0kVl4JG
	 kn/RS9TxU1ZTSklNDJmmp4qkx3w6YIl9pdUydOxu508xnbLW9280hiOL0ZoPc+Ecwl
	 f6s7EwEwjvZzIpvHGiD8cPKfVmgwg7jW7w2lkZh3ZWYaZKHqop2vOKQ5/o0v2UCasC
	 UKGM5Htnido7a8jKKhODoEDzc2zGi8ePJBaVe6KaCvDHCsVkgjDK63QKEXnzWdeHXb
	 mVINhWe5qoIULHW39kkH4WaRgtih5JeYLgqSKQnNOSn788Nu96mRNa9YzjlUZT8qc2
	 0GSiKV+dz5TFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 89506383BF57;
	Thu,  7 Aug 2025 05:30:19 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1 v2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250806093511.2909a521.alex.williamson@redhat.com>
References: <20250806093511.2909a521.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250806093511.2909a521.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.17-rc1-v2
X-PR-Tracked-Commit-Id: b1779e4f209c7ff7e32f3c79d69bca4e3a3a68b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8214ed59b75fa794126686370a5e47cb7da5b12
Message-Id: <175454461820.3059740.3843521768193150634.pr-tracker-bot@kernel.org>
Date: Thu, 07 Aug 2025 05:30:18 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 6 Aug 2025 09:35:11 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.17-rc1-v2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8214ed59b75fa794126686370a5e47cb7da5b12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

