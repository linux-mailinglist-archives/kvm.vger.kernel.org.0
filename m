Return-Path: <kvm+bounces-58034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A9BB861EC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FAE01C87E70
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0243526E165;
	Thu, 18 Sep 2025 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fx3cN/e/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210624BD0C;
	Thu, 18 Sep 2025 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214281; cv=none; b=T78p2QwIHY1kL5ZDBOpSjybHiNhlJN5Fkuc7+fd3Yd8HOsM1wT7Lyv6dG1PwaCuiVx5UlpPfmv+XojidYQG6VP1uKcEwCIlwq2fujSdLcsqvqkO3VpYGo3BnqP0RrPbUdHYqeYRJ/lKADl1wO4XxIml4UHSywKYxXM61zh8Vl8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214281; c=relaxed/simple;
	bh=aBzzE6ptNAUWJm+Kwhv85Kj39AlwJ0RTOSCfrVdV5uo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G3F0Rugr3WjmKrJsk80CUSZazOHxP8rRvmUrOWItA5dvwovdybUUP1MenHBgO5YutYB72P1X4V2NxkXI+VCD74Exr+jmMxJMC9YO+LzCtXAcf+hTyEOz0U1K2VPAlFlTeOM6Ak5M2DKclFDEl5xlAZNKsbrOdAB883ISNBvtuyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fx3cN/e/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E799EC4CEE7;
	Thu, 18 Sep 2025 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758214280;
	bh=aBzzE6ptNAUWJm+Kwhv85Kj39AlwJ0RTOSCfrVdV5uo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fx3cN/e/+tG4+agMZo7QZiaj9DfwQkqqCRQl0lnSaei6g1r64Y6ZNJknrct6KXTsK
	 dXoankilSRN6z1qOYri+cVyH/UoUB+iZoZLZEk23P/Qp74bJ6AlV91f3s72sw8tpTx
	 WDbyxGRp4UE2h0vArNWAmdOiKCe+sikgCrDZ1+q1+Wb6nnP6rNgcvUKeRAu4VXHTv5
	 CpFlf/DD70CqYQRjgXvDq/Tc1ZU1lk1uxCquKpppEBhUwQxJys3RdUFRJmxfgIIlvk
	 V1zsI059sY+P29R1Uv/t9XYwgClvj8Rmy9MU8q8/ioMbEiy2kv3Vo7iA9aTWaAz5v7
	 qUoshEGIntcUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CF839D0C20;
	Thu, 18 Sep 2025 16:51:22 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.17-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250918132215.16700-1-pbonzini@redhat.com>
References: <20250918132215.16700-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250918132215.16700-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: ecd42dd170ea7bacdd9d01d8e74658df8dff621d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86cc796e5e9bff0c3993607f4301b8188095516c
Message-Id: <175821428064.2499383.11824596448322806800.pr-tracker-bot@kernel.org>
Date: Thu, 18 Sep 2025 16:51:20 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Sep 2025 15:22:15 +0200:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86cc796e5e9bff0c3993607f4301b8188095516c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

