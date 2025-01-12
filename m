Return-Path: <kvm+bounces-35251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC83DA0ABC3
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 21:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C7023A5AA6
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 20:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7626F1C4A20;
	Sun, 12 Jan 2025 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2Rjq6fp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D091C3F30;
	Sun, 12 Jan 2025 20:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736712489; cv=none; b=mW0TQDxam8VidRcXAuDadrEguzVzLSd3G/i3KOdHpSjEsEQupAQAqjGrevfKEkS/ovh02jm8tJseKHzghtO3EYloeedArVXeTF/r8k6qnDBrXBRrgH4JfvhEEGatLTrUn3Igwds0+8yL+lqnhbr65THfD1v44n0+gKzg+BS+C/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736712489; c=relaxed/simple;
	bh=tLU4llgdLYLdThpp9YCtvILNB2H/s7F9vIIayIHvCmI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EVKohuSldKZTvOA/iqxXK22CNfrNH+t8k4bbZLbXzLdRDKsC1t2re4fYloXl2byh3vGfruzfpjZEs6Z+DSfcCpfq08+81o3gCrAXcqGlg2OD/zGZbDulxX1TcuPtKJYV/nyyYnxfxMYkqJ4o1NctIY4CsANV/ew7chn8pBzxnLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2Rjq6fp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0F8C4CEE3;
	Sun, 12 Jan 2025 20:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736712489;
	bh=tLU4llgdLYLdThpp9YCtvILNB2H/s7F9vIIayIHvCmI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=X2Rjq6fpoEqNqGQ7/6aaPVLQZyBCQlLaYEF/szh3N4W5jwAVQwfu6kKms5q2lxz81
	 2xjlpXUnDw2bLoStG33iK8H2NtJB755yymZuVBCa8dI+iq8EWBDv+Ocl/aKODYo97l
	 nG0rcxI92RA0OLjvbrDh3i6WbTnD7ir/mPxx/fSNdsJ2UMuJroFgf41idiYfnIF0Rm
	 2xf3N3dOcsgF79DfotuZ1zrZS+N2cOrXO9dwCyJpCEvWgA+VojZ82jQFLadkS/oZBw
	 kXZNgvdsr5zyKObk2hrstGZA83Px8KlxhP5rtvSV4jqNyJAu2vgF+LfRrNpKKQQYxk
	 3Tnb4Zov99vXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE276380AA5E;
	Sun, 12 Jan 2025 20:08:32 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for 6.13-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250112120212.440133-1-pbonzini@redhat.com>
References: <20250112120212.440133-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250112120212.440133-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: a5546c2f0dc4f84727a4bb8a91633917929735f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: be548645527a131a097fdc884b7fca40c8b86231
Message-Id: <173671251129.2642586.1269098014731778000.pr-tracker-bot@kernel.org>
Date: Sun, 12 Jan 2025 20:08:31 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 12 Jan 2025 13:02:12 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/be548645527a131a097fdc884b7fca40c8b86231

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

