Return-Path: <kvm+bounces-67971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82074D1ACF1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 19:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3ACC63038992
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5DD34C130;
	Tue, 13 Jan 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ikuw0w/8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909EE31B131;
	Tue, 13 Jan 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328125; cv=none; b=kjOczZxHms4HHUuco2UCqQ1EGzM9n8wP16LY5Ta/m67MWL/MJmpB6a2ak/C2oyYb1UEOCnnHYRRVQcv0iSPlJAc1kEY/KJWC4klkdKlwHmme9MqU/B1zuyyvUkcV0g6rEtMd15SXmpBWsgZEIak4J15xKnylzn1znvnQvfEtnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328125; c=relaxed/simple;
	bh=40Wsrd5Bibzh7RWq7iyhvmOeEgbSrYPW25LYjuglYhk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NcQs5AsJEN3LkcBfW/Y+85zz9sbDltNwoBCzH82tY1/n+lB5TidQbz1gCmqfARSl0CaLEYeM/TkNL9wMvYi1+S8ptKRE6LzzI4zY8Er7pp+G4bA2cb+gmYlsi/S6AMmMLNYt4WMbvkoXuizVdGeas00LbqSi/hV1JywABoH3lKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ikuw0w/8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F682C116C6;
	Tue, 13 Jan 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768328125;
	bh=40Wsrd5Bibzh7RWq7iyhvmOeEgbSrYPW25LYjuglYhk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ikuw0w/8nm8bsJ4wOGiNVL2KO4o5Q35K3gOOB/QruIpaXXukoKKMWTkGmicy4qVWl
	 4mDKugXRaISaQd7QQyZ54p8gyCDB25BuxcnbudBvVsA64P56t3jYnJxdsVDdpGFGTz
	 xpzxBI87Xzhk8rLmsXQDPRBJM6DVVWsngREW8YcUO3QH5OGZfWO/bILfBvJJjK7DcS
	 52pHWDsyT4wdfM6N/swrMuSqgUZ055jeiXYxc3QUKdkBzghn3dlzTJP7me9xBnAdIA
	 hyyR0NJCjbhXCv3yNYBAF74SFFERNHHp9oHoVlKR/rr3dJHPQ9YTHflRYL4TKFqfxl
	 ZtapSYXzAWlCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B5AF13808200;
	Tue, 13 Jan 2026 18:11:59 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.19-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260113172459.1291801-1-pbonzini@redhat.com>
References: <20260113172459.1291801-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260113172459.1291801-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 3611ca7c12b740e250d83f8bbe3554b740c503b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0bb933a9fcdee14ef82970caeb8617ad59a11303
Message-Id: <176832791827.2405565.1388238832879364807.pr-tracker-bot@kernel.org>
Date: Tue, 13 Jan 2026 18:11:58 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 13 Jan 2026 18:24:59 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0bb933a9fcdee14ef82970caeb8617ad59a11303

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

