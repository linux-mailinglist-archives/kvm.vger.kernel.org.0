Return-Path: <kvm+bounces-34603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C23CA028AD
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 390643A3ADC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 14:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277AB13C81B;
	Mon,  6 Jan 2025 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTbcnDTx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491181304B0;
	Mon,  6 Jan 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736175521; cv=none; b=F2TuEdo0N4n36CfQcaeYEKyrYgfGfWnTfSZcTi2H7ipTOo5+hs9yyy/3r0C0lUc6qN8fWVrxkhk29xHs12GWCxWTvebqLE4dvhzq4XG7QKPFJbeZmUfGOa351fre9C90j6ZmTziDKqNRaxxWVqNDgYt0wrjI+Z5CUAnRvIOcxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736175521; c=relaxed/simple;
	bh=t4hkw7tYIjZirKZTH+dw/tEeUKdaIURnkua/9ZkryIw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=s5cRhwLgkh0bvs4vHwK9yE7+ip02OypcCRAbzppWGpGou26HFkTCmPEt4Ivp3BZBirZs51VbHJ+a3UrYiRaBIBLserbDrW2hwdwHr0r4EsAgexcAkXRrzLKPt5zBJYh7kCuBShN0NfEiRGP0b4LXhKaglF16ZoHalnLzjEl4eeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTbcnDTx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA886C4CED2;
	Mon,  6 Jan 2025 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736175520;
	bh=t4hkw7tYIjZirKZTH+dw/tEeUKdaIURnkua/9ZkryIw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JTbcnDTxfTIJQ6biJk4RPoJ/PMH9A8eJ+FL0g8bMwNCQXmsaQfqsfeAtdYJEbd5xf
	 GlJlA/Yme0DhCbg1czOFpFrEJPTimcrA0gR/5O7nLwABOhiChq/yCzGqUuSr9+46jQ
	 2Iatv88EA4DgHXSpVzJNho6nRSKIK1//h1Q7MCDzeCjeixgjyT2lirNQdq5BHZYXUY
	 0uQbHhFccVxNDQGYh+EYdWNMB/xC+kHujMWZQ1zT8WvjMIQxg990MmLrS9eMVG2D5f
	 b414xBfmcjUThfkH0dDwlZZvMiA5jWra+ESsTHzG/FP0creQGqWA1lckjcKa521bnK
	 kxG66VB1pn8xQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34173380A976;
	Mon,  6 Jan 2025 14:59:03 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.13-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250106094419.66067d1c.alex.williamson@redhat.com>
References: <20250106094419.66067d1c.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250106094419.66067d1c.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc7
X-PR-Tracked-Commit-Id: 09dfc8a5f2ce897005a94bf66cca4f91e4e03700
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13563da6ffcf49b8b45772e40b35f96926a7ee1e
Message-Id: <173617554163.3522394.5164458064504097786.pr-tracker-bot@kernel.org>
Date: Mon, 06 Jan 2025 14:59:01 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 6 Jan 2025 09:44:19 -0500:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13563da6ffcf49b8b45772e40b35f96926a7ee1e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

