Return-Path: <kvm+bounces-31691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D80069C665F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E32E1F21AE3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 00:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528A01EB39;
	Wed, 13 Nov 2024 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAYGEAns"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87CB665;
	Wed, 13 Nov 2024 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459563; cv=none; b=ZGNomDUfRUZMAcaEbLTeSiSaVsOwD37l38PNTpdQoljSR/93P1UyIallsONyA+9MQtBE44IxUIDTby7TabodLxts7oYmzYIRpkBdlaqDBCMUx/6lwjU1GqjcUIR5oG9xgxZDa2k9Krj3XU65SL+5CFWygJecRbOKjqhU6eEL/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459563; c=relaxed/simple;
	bh=90uZg7sPcZs6xapZO7Sny+SwArLF0kzm8+56+pmdOao=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=X2bIcTBeKh7jfoHN9Vh+N8Lk+hZrYwdS/iznGWyxIPTcVx3/DH16nPCRcy4YUjhPXCi38XAa/J9P44jN5bOqmzl6A8IDgYmfdzx+WNqnU65L6fEKVyKplcD4kT++lMZerI1zq9AUMWKXeAwtDczpjDqQbMo/6EmuJYnvPEEV87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAYGEAns; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F394DC4CED4;
	Wed, 13 Nov 2024 00:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731459563;
	bh=90uZg7sPcZs6xapZO7Sny+SwArLF0kzm8+56+pmdOao=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cAYGEAns0u2GqpWJ1/A4PL1lxYFknXTHAsztjiJKI78i4FdfiaCT/YQO9aBvYCJRH
	 la+s8EWlR28uh33LFPUKeQgFQiAhhuMkTcZevV/VXeBwuotbK4NuNlpTB4hexnXhRF
	 utceMCzgz1XgX2cc2uRW44o3qNZDqULlcG52Vji5UbwIJW57X1uC4xJ7XP6uHi70N/
	 yUD/zglFdH5fZJr1l+uoJKZeG2k74RpP8p2qqdgLIeE1LDW8t9tTzS6lODDHiVpzuP
	 so46tsMUYfCSy7a8Akw01oQLZlZNSr3DmWfTlbPZhP+uRyh8oBUZhEGxfddXk7wmAL
	 WzgJ/+lrkgSmw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710AF3809A80;
	Wed, 13 Nov 2024 00:59:34 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfix
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241112183037-mutt-send-email-mst@kernel.org>
References: <20241112183037-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241112183037-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 29ce8b8a4fa74e841342c8b8f8941848a3c6f29f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f1b785f4c7870c42330b35522c2514e39a1e28e7
Message-Id: <173145957292.735839.6511436323242434838.pr-tracker-bot@kernel.org>
Date: Wed, 13 Nov 2024 00:59:32 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dtatulea@nvidia.com, jasowang@redhat.com, mst@redhat.com, si-wei.liu@oracle.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 12 Nov 2024 18:30:37 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f1b785f4c7870c42330b35522c2514e39a1e28e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

