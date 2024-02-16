Return-Path: <kvm+bounces-8904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F64C8585CD
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD6EB2894C8
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C136137C3E;
	Fri, 16 Feb 2024 18:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4uy0BTp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824A1135A51;
	Fri, 16 Feb 2024 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708109519; cv=none; b=AXNi2z1zhgKcmQnFvKTYM4VZlxw0zajmbgdYtAtK46t76T+9S+wsep+33EAN8qSBIEBIoXiE4V+b4jd+iZXvZac+EhD0ZJyFh+AlQ9fQ5SXh+TVo1angul8qIxRQ5caWcv4fxWXrm2gDawkAyJLCNXNe4fmBLXtK+1xeijuhJFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708109519; c=relaxed/simple;
	bh=z1wEHUsx8sHtbllePsy0F6JldriJlX548LiYZM+POiY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fPZeXsVnYe9Vpkpx1s1DXjNhrb8RkSbbuOeYqeYCHQYMQwCkD2F6njfa5tI0bkQrXq7IHYTG2btIOvcrWlvX2H6wUpwh47V65oPvalWENtW3A9grTrN5VTmBrxlec4z4lPzjxnoVAIWmHbLOhtHYBGxqOg3UTJTfHJWMpv8DPF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4uy0BTp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 585DAC433C7;
	Fri, 16 Feb 2024 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708109519;
	bh=z1wEHUsx8sHtbllePsy0F6JldriJlX548LiYZM+POiY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=N4uy0BTpCOQxCLKVnVo8dcLA+5KUZ1AjSVs9amcy8kCwPmY3FIRaMECzD4EMRh5mN
	 2wYRBqPjwppAiODRVzC9yrlmJ08soDZQLiJLZbB/2Sk+luvq3E1xSgK9/7GictWwor
	 hA1OlOMWnybdThxHPKkm6ysHmdYl+5K8YzbF1afrRFdrB/fXGhF+JEOsUaaedHEPCP
	 2hU74pisTlbW4ACErRCGgjJPwRUFgJh2Hvzp7die1qoUfWnLky9MM5bvORnsseg9AU
	 fAFsGVclLib4Gr5MoeForlyyBZiJgJFz1U0r7ggs0nI76UwV7tg4V+w8OsPGZslxRG
	 lOev0EwKAq6/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42692D84BCD;
	Fri, 16 Feb 2024 18:51:59 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes and cleanups for 6.8-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240216171030.12745-1-pbonzini@redhat.com>
References: <20240216171030.12745-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240216171030.12745-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9895ceeb5cd61092f147f8d611e2df575879dd6f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 683b783c2093e0172738f899ba188bc406b0595f
Message-Id: <170810951926.23532.3882456779664688966.pr-tracker-bot@kernel.org>
Date: Fri, 16 Feb 2024 18:51:59 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 Feb 2024 12:10:30 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/683b783c2093e0172738f899ba188bc406b0595f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

