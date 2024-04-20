Return-Path: <kvm+bounces-15419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF6D8ABCC3
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 20:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15EF01F211F1
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 18:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404BE4655F;
	Sat, 20 Apr 2024 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAi/MmEb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196942044;
	Sat, 20 Apr 2024 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713637966; cv=none; b=svmIcuk2qRa5wEIjM8DrTCzXMM0gZkV3ibiesl7zfyk/gZ8nZDsEu4/UKkHyreRo/Q/uqzHy+B234Fp7+OFaOyU3DCRbg81/12HYUIYwoVINA0VRAztA1TXz5kQ6oTqEnHjjhjNyRbo4lU0g2Utrf3jFn6qnT8+nzRbC+tG6kb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713637966; c=relaxed/simple;
	bh=DUGQfqBT84hWPKdV6xVQSLNa0Bdgx+WRzg5DWXNNs+w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bGrljy/kWg1yJhUVWKux50Mn2EvfEWiQL2WDM+awB8hVL+s5IZLhefgd0mmN7VFOq61XHyFawS74ASU0KQUXn9cJO+xK6BVwmOV2iXwDaXaGtU93u0qiJF84U6K3TkT4a/sYETVqec9n0qCLZvntBkTusY+mmRMcc0j5UW4W6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAi/MmEb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D3CFC3277B;
	Sat, 20 Apr 2024 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713637966;
	bh=DUGQfqBT84hWPKdV6xVQSLNa0Bdgx+WRzg5DWXNNs+w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AAi/MmEbe5W5uc3roYWGsMaC0B1ox7s/KnVzywUmY5uiAXpP9RSjj5kHuq/05V/vG
	 zfoAJC71OYhc61OZaK6chRWr0nGsQ7WlatA3VBF//LbaZvE/t5WD5jyH0K1+H/rYgy
	 wNNLKpb8sIBEazbZl5XjOEJo1WeME6w8lk040PfbQc/yxeUIxkVqPJSoTRjZkWQr8i
	 B5zTf5qPefCepGNAAuQignDmK5jJuMM4ojXrv+IxCObAdmJiSnKTEikbAOakdHQl+V
	 qSVlw1xVHIcHJB6NUJplIxQS0eUOeYVZUQrSFzGx0nMzwLmeTjmxdez0viRHtcjiqg
	 LaBYRY1EJE/ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33AC4C433E9;
	Sat, 20 Apr 2024 18:32:46 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.9-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240420083458.3692711-1-pbonzini@redhat.com>
References: <20240420083458.3692711-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240420083458.3692711-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 44ecfa3e5f1ce2b5c7fa7003abde8a667c158f88
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 817772266d10f2700c9eef41a0fb5b5a9f30fdfd
Message-Id: <171363796620.22086.10290887407075437203.pr-tracker-bot@kernel.org>
Date: Sat, 20 Apr 2024 18:32:46 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 20 Apr 2024 04:34:58 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/817772266d10f2700c9eef41a0fb5b5a9f30fdfd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

