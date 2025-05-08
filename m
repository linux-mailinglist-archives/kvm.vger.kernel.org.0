Return-Path: <kvm+bounces-45974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3FAAB03FE
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8356526EFC
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA6028C2CE;
	Thu,  8 May 2025 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qNtjnMjj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9E28B4EE;
	Thu,  8 May 2025 19:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733749; cv=none; b=g7GvmOxRdh5Kb3iucIrcevvU17oixI493tSZiNvSeo19iHSbsVUx7It4sNcXwcx226QPeE/NCUIh5Ke8TIJ9DLYW+wbUCiyP3/WxfTGwWrMmIYXigYh496krEdPy6ip+A8EhncbYCXoJ9TeA0MN/vokZzpFafgtdrnROVADJxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733749; c=relaxed/simple;
	bh=vYaEU9jmr/hAjHN1jca+C+uM1/t3hCMtG4siuAOSw40=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B0ekeO69llFQBMXxmhFm6B1vNRxlVq2tuYxm72EsPBAcPmLRx1vUW7QDKkOQnEQJqUmrk45taaZGIqYzID3INTkSS8By2bcjDnIEzzcSjQfwgeiGYKH8xuxinlww4rXQtIRfD8aGeGXC8Gn2poaYHD6fVZ9kChGzLormK0M4msw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qNtjnMjj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55823C4CEE7;
	Thu,  8 May 2025 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746733749;
	bh=vYaEU9jmr/hAjHN1jca+C+uM1/t3hCMtG4siuAOSw40=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qNtjnMjj7nVHbnLJPIxmCKxPPKbb5RornA2jDuob3VSc1Hw+MzvQiyN8GARu0st+V
	 9fzj5wDFAoW0QbpJP4kTEnEFg2NX4VWqcP3/RNCnhJBJbA8IFAbODBDUSi00ML5BMs
	 RCdnka+L87p+oouQL68JsF/q/PG5JeUHYv6QXm6SFlpl1ClQAdhVCrk7pfaK59m7ka
	 qZkOMIFpgMtbL8AEJI0cDyakioqMTLEA+SOFy5BMJqzRPOM3Hiexh5Gt9mP1xkqbm2
	 M07F5rafSUkUNv5fDmSyI/37YTryKGToJffdJG4v72Ux986ATruPDTDQsViW++Oyp3
	 I5oAkqtE93v3g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33ED1380AA70;
	Thu,  8 May 2025 19:49:49 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO update for v6.15-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250508115110.5ac2ee95.alex.williamson@redhat.com>
References: <20250508115110.5ac2ee95.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250508115110.5ac2ee95.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc6
X-PR-Tracked-Commit-Id: c1d9dac0db168198b6f63f460665256dedad9b6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: acaa3e726f4a29f32bca5146828565db56bc396f
Message-Id: <174673378766.3023805.11870843112252300594.pr-tracker-bot@kernel.org>
Date: Thu, 08 May 2025 19:49:47 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 8 May 2025 11:51:10 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/acaa3e726f4a29f32bca5146828565db56bc396f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

