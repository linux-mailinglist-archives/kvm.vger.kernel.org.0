Return-Path: <kvm+bounces-33546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4019EDE7C
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24CE21889094
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7AD17C7C4;
	Thu, 12 Dec 2024 04:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mH88PfDO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17A170A1B;
	Thu, 12 Dec 2024 04:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733977816; cv=none; b=qLvQplXxqQBHQ8LEYHdxQy2FKfb4pPZfqymavBwdberhqK2uYgc0LeK4ItkQdDGCJngD/K+BzcM3qgGaelgEwYSeuGDH+BNMxVUyrzj7iXR+SuAzC+Cz4DgkvWawJsMi2TjsnZIZw7l+KkY0mlG+XllIC5ohaQvMcmwUdjkQ8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733977816; c=relaxed/simple;
	bh=w0GaN2svvAl//6VXkTZuXQXE+ogd0LPmILmAZXFMlxM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=MX9Frq4E403K6mDlF4Yblj8IW7xhrmaIw4o/uFUBvuWQTJVAV7elK5XcqcR4Vg2PougBXsUq34a5oTtDzVNHFe+uHOMoMDyCYoX5qGOI4WLLCPhNXfPtSwxQEONfwJV7J3eiVA1Twc5Bx9p0NFGr06hP0fhamQ4tysG+4sG/om0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mH88PfDO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5071C4CED0;
	Thu, 12 Dec 2024 04:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733977815;
	bh=w0GaN2svvAl//6VXkTZuXQXE+ogd0LPmILmAZXFMlxM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mH88PfDOqyp6h2xinfzwPU3ZRwO4xhmM+/l/vWYDoyz1dDjpjFXLCW14d7to7h0Ho
	 Ki9MLSz8zFsey+48X9CWlm2hFhBtyGt3Q8qNyyHoK68a1vgvgPJXWKM08dgKKFGjPY
	 eU9rpzeFXLbu20YZlrTcslXpgPJSI0pvkx4QrJUyn6/GuCbHAb70LXYQIcpEWDkDKY
	 K+RggOwr2hO8fgEnwx10FtZVUsDzIGTkHU1c4xI2n5OJcO35oSqxh+ziN1UH5gbtTH
	 ctafaFDlYsiinQPQgs808dQTvEghkfnMaj7UYaxOayOr+z0uL/zAstMXXX+mYUGPkM
	 8IPaRv1MNt99A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 345F3380A959;
	Thu, 12 Dec 2024 04:30:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] MANA: Fix few memory leaks in mana_gd_setup_irqs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173397783199.1847197.16469133820148942308.git-patchwork-notify@kernel.org>
Date: Thu, 12 Dec 2024 04:30:31 +0000
References: <20241209175751.287738-1-mlevitsk@redhat.com>
In-Reply-To: <20241209175751.287738-1-mlevitsk@redhat.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, kuba@kernel.org, haiyangz@microsoft.com,
 schakrabarti@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 decui@microsoft.com, pabeni@redhat.com, linux-kernel@vger.kernel.org,
 kotaranov@microsoft.com, leon@kernel.org, kys@microsoft.com,
 wei.liu@kernel.org, andrew+netdev@lunn.ch, shradhagupta@linux.microsoft.com,
 davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 longli@microsoft.com, yury.norov@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 Dec 2024 12:57:49 -0500 you wrote:
> Fix 2 minor memory leaks in the mana driver,
> introduced by commit
> 
> 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> 
> Best regards,
> 	Maxim Levitsky
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: mana: Fix memory leak in mana_gd_setup_irqs
    https://git.kernel.org/netdev/net/c/bb1e3eb57d2c
  - [v2,2/2] net: mana: Fix irq_contexts memory leak in mana_gd_setup_irqs
    https://git.kernel.org/netdev/net/c/9a5beb6ca630

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



