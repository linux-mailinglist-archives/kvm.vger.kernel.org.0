Return-Path: <kvm+bounces-63171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1F3C5AE06
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 02:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D7A033456B7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09AFA251791;
	Fri, 14 Nov 2025 01:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QptaYP91"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FCF2222B2;
	Fri, 14 Nov 2025 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763082341; cv=none; b=DBTA1mWxzsyGT8YrXUVrUs0TuntgVAn1oFAosbRUVn8i0cVsGhGNcGIPxuxGf7dj3NuRRF47CZAOAb2qWoLZyluFvtAM0roAIhUcWKE3pcWbbarJi7IvPzMm89IlqZ37zcyup6XlIVIrJrof8t9E5waVYADhYuw/56joT4ksjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763082341; c=relaxed/simple;
	bh=QugQm3N+fuqcF8Sglnsg+8dfao3r/7Zoswv1b4QUlR8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qwCsqNC8UU0dPkup/gQwF7ZpoT7wosfHLrgEvLIdTONiRvUzOc+qMoA+m7jDDog3bVUpFI5EYqG91Uhcs0W1eUDG7BKpumcAwDYjsLdAsMj2GaQr1RE3k2x9wgxyyJ6L5wV9nPhv9m7jM2uH70dF+HsDsFpSzkApZe2ZdNRXzH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QptaYP91; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D1EC4CEF5;
	Fri, 14 Nov 2025 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763082340;
	bh=QugQm3N+fuqcF8Sglnsg+8dfao3r/7Zoswv1b4QUlR8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QptaYP91jBkaC1PDgHvOZZcAegnxOv5FWxboFfIEtsUXBqSwwi+IyN5DPYpwmUlLl
	 0ggsDsFrwtr3r+mthwQmAYGSVXhNyaHOjHrNNftwV7SdwA8orVB39HH8J7ZpFonZ3I
	 x9sSW47y316O58DYbFoe9l9KS3UU6zNfSg0a0asNzUPIpKH4vViQItbBiO4kn6AOoy
	 xzig08mqWqOD2tVY4s3YpXAjRKD3MTGcYl42j2+o46lA8Oj/dvS3tbcCixCzHZZrSE
	 ZPtDvv1Bsu0kZ6ppaKJxNsa5sluz//uOiN4npwX/r0bmG9GPZi7qlMorco1w+T2osd
	 J5IlCtrD8P/3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE083A55F83;
	Fri, 14 Nov 2025 01:05:10 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251113160831.775d61dd.alex@shazbot.org>
References: <20251113160831.775d61dd.alex@shazbot.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251113160831.775d61dd.alex@shazbot.org>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc6
X-PR-Tracked-Commit-Id: d323ad739666761646048fca587734f4ae64f2c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6da43bbeb6918164f7287269881a5f861ae09d7e
Message-Id: <176308230960.1071348.7917402062394420106.pr-tracker-bot@kernel.org>
Date: Fri, 14 Nov 2025 01:05:09 +0000
To: Alex Williamson <alex@shazbot.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Alex Mastro <amastro@fb.com>, David Matlack <dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 13 Nov 2025 16:08:31 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6da43bbeb6918164f7287269881a5f861ae09d7e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

