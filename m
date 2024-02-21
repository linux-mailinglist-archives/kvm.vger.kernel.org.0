Return-Path: <kvm+bounces-9334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14FE985E44E
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 18:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE85286257
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 17:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E788483CD2;
	Wed, 21 Feb 2024 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ld0yni6s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B814C83CA0;
	Wed, 21 Feb 2024 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535827; cv=none; b=MG7buUK1D82MImg4P6w+zlTXnHOQZ18I8SgJQqKbuiWtzOeOYRfESJ05TOaxelaIZREW/yoVuN96E6B0tl4mNQ20coV/OC1mTl+hgp9kC/rDCPuU8HzJvcBj76mMUUDo9jkj+jVRZzuqrb3p0BFcC4C1SdnQ7RyzAoGo3U7v90A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535827; c=relaxed/simple;
	bh=/GTiiK6FPpYRPPc3y9G8GGja1BboNnmiP2Ku+d3VChA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UP3G5/X0DkILD1SFlWSrF3DRWqud2iE4FisT44D45seeukh4GXbTynQklOkCA168RPx/1Y8b14sCSZeJ2TokWKHao8x7bKojmBa5bY6cMpkAwwaUmOSWQ3Inh/g0t2nwSAdSVQzEPZYO/FFvhD09kVYwLp0m8S8BkI1+79aYilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ld0yni6s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22723C433C7;
	Wed, 21 Feb 2024 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708535827;
	bh=/GTiiK6FPpYRPPc3y9G8GGja1BboNnmiP2Ku+d3VChA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ld0yni6sYSiCzvkrLG56140z+JO+KWpZBdEPENYRZSfmE71N5OFFEM1hT+MkKhEGF
	 W7l/b1e/AkGSwPFgpPD+mQC96iTaVLOXHeL/nnkTs/Qx0yek5qg8eNjzix2ZgikeB3
	 FVs7l+dyIfBnYlGQSaBgYlWBUsWpAuPjOJMP5BI5eoKLfPq4Ji6GkPpWoT9H+gH2Im
	 YPbWWW+kexWEmu01vx3g86gTvfP5f17C/4SnBN9zxeKd3VTP16RgEWwRS4EqwVycjh
	 U8sDnBLNtPjmItw1C1I7IB7IIvnbrz65PthpiSPpME2jYi6J9U65NJI3AZtbVR+0+C
	 9C7sQAFOia5KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E81CC00446;
	Wed, 21 Feb 2024 17:17:07 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.8-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240221113913.215306-1-pbonzini@redhat.com>
References: <20240221113913.215306-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240221113913.215306-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: c48617fbbe831d4c80fe84056033f17b70a31136
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39133352cbed6626956d38ed72012f49b0421e7b
Message-Id: <170853582704.5777.13288046356892917810.pr-tracker-bot@kernel.org>
Date: Wed, 21 Feb 2024 17:17:07 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 21 Feb 2024 06:39:13 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39133352cbed6626956d38ed72012f49b0421e7b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

