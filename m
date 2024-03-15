Return-Path: <kvm+bounces-11940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D0E87D513
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 21:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32CAE1F20F7D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA6058AD0;
	Fri, 15 Mar 2024 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOlFQPVT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA225733F;
	Fri, 15 Mar 2024 20:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710535057; cv=none; b=RyG4B6oysM8BysoYEVTm22MHALGMVFB4/5SYJyhcfGoqy2om2E/Jh+v2wOGoHswsgagAKl1XRKWeRiq9CcEFbyphIHhkXBG/oWgVisi/9z76dXfwMWJeJ3GwVuHoyUAT4ZlKYCIHdmUmRAHDy8JJks+vxaruVtrAWcdA7rn/TnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710535057; c=relaxed/simple;
	bh=t14+dmzjKtagafYHV5FYtQZX5LQ69KcjyV2/xqxCcRg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QLy3RUZEvn7GQJY86HWd3etxWwv4zF3BgPgSrnqOgU/spCtz4FBp0emXP8v2dIQB5OQAHEdkuPU4nvcWdmWCqbw7dQfKPBfp/o5il3b2Fe960KQ/LIOJyAcu39ZiYDGe2pWWpxWSKVsspgQM+Tbvdj3aIJXHmF8efxnoYtlGb3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOlFQPVT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8117AC43394;
	Fri, 15 Mar 2024 20:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710535057;
	bh=t14+dmzjKtagafYHV5FYtQZX5LQ69KcjyV2/xqxCcRg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IOlFQPVTuPDPoSDLGcOFBK8zdMA4XvMxfPnpcVP3a062Nj6kJ689RJFIkgXK4hsEQ
	 e00cnYGd2MEbG4SBqj2wYwvpesvU2Bw6ME0jFdKwsiY19Hke4mgPeO24fOEBXqvd4Y
	 RBF6+nWK+4Sqm7r3BXnSagcLuXszuOQeoEUIUmYxmBt19JTtenzkP/2GgbIRgE+PMG
	 mqahW4h5NnNBKcWTrmoXoO0yGTPGLqDPICmlycBVFYnOC+fI67eggJTOjp+KGk+lop
	 hkSyw+QXGyEs/1+Qz+uVtvlDVwNi4yMyeedOZN0TdZvKdLMGMG/Dl0sY1wiiLv1xmy
	 kL7CY130rCu/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B7DBD95060;
	Fri, 15 Mar 2024 20:37:37 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240315174939.2530483-1-pbonzini@redhat.com>
References: <20240315174939.2530483-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240315174939.2530483-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4781179012d9380005649b0fe07f77dcaa2610e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f712ee0cbbd5c777d270427092bb301fc31044f
Message-Id: <171053505750.29375.9305137359879657985.pr-tracker-bot@kernel.org>
Date: Fri, 15 Mar 2024 20:37:37 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 Mar 2024 13:49:39 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f712ee0cbbd5c777d270427092bb301fc31044f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

