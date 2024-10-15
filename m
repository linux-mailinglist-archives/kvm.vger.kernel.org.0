Return-Path: <kvm+bounces-28895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5104699EE0C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1445B24148
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0771D5144;
	Tue, 15 Oct 2024 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uX00nqRb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5D1C07CC;
	Tue, 15 Oct 2024 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999628; cv=none; b=CRPqQgcXYko0uyCHqUOnDYOa6q3AlpeIJM6t/cIKbSmBCUwI4ZQ+TXN9VbTdGsdoihjYFg6mb/e+pYgF83I03wF9IXvYGIoZTSnoVhRy8hxYJhOxJwBWa0Kox316+ZHHuZs/1KvhCwJrwI8EYaoLddNxnf8XJky6IPSafrlS8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999628; c=relaxed/simple;
	bh=+eg5Ogets9SiLlYwP2uE1cyuHarfu0eMJpCc1LNOyZk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ug4MgT8fgB7kMq9hVseVE0EAWTXXezthk4GuhW0dcHjEoxnkLzY9RRTsKpoyfXf+6y4CbmDdFdnsdJ3+Ydizvu4VqhbFM6nlobQVoUO3lTsdULFp1bdrbcGGFtxlV2vm83tT/Iq/RhDT5Eu1hrDnVpRLuvgIyWIraeoWWUSSLQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uX00nqRb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D07C4CEC6;
	Tue, 15 Oct 2024 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728999626;
	bh=+eg5Ogets9SiLlYwP2uE1cyuHarfu0eMJpCc1LNOyZk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uX00nqRbj0TEG1Tz8shbGOT2WxuN/MzsJ0/O8D6fMk7nTY7nynwkrPoV5Izq1912G
	 MCNxilzGTiCcfUAS5pjSXwW6q3cRG/BW6D6YbtnmlO0q+fhZtWAV8iW5Tl912r9gZP
	 jE929Z//XzSjfIYVBdbbV+yN6bRsMcoaXu9P5SmP/HpGUsX8oWRvpS3y/CHIagsxmZ
	 wSs02+S5+DmmcEkoZwbxu00ArbFRTvF91bDqH9pPk66sN6FjSlgd1oE0CGyqAvnLq/
	 xoAmzPiMCVa7yA7fqt68pGzpMEomnxnAVW+/H1RaLmsld8vRk3GlFiM5j84R4We9bm
	 NTYamxloL6Fqw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B943809A8A;
	Tue, 15 Oct 2024 13:40:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/17] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172899963173.1165800.13282848624565322990.git-patchwork-notify@kernel.org>
Date: Tue, 15 Oct 2024 13:40:31 +0000
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: linux-nfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
 vbabka@suse.cz, paulmck@kernel.org, tom@talpey.com, Dai.Ngo@oracle.com,
 okorniev@redhat.com, neilb@suse.de, linux-can@vger.kernel.org,
 bridge@lists.linux.dev, b.a.t.m.a.n@lists.open-mesh.org,
 linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
 netdev@vger.kernel.org, ecryptfs@vger.kernel.org,
 linux-block@vger.kernel.org, npiggin@gmail.com, christophe.leroy@csgroup.eu,
 naveen@kernel.org, maddy@linux.ibm.com, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Sun, 13 Oct 2024 22:16:47 +0200 you wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were done using the following Coccinelle semantic patch.
> This semantic patch is designed to ignore cases where the callback
> function is used in another way.
> 
> [...]

Here is the summary with links:
  - [01/17] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [02/17] ipv4: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [03/17] inetpeer: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [04/17] ipv6: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [05/17] xfrm6_tunnel: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [06/17] batman-adv: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    https://git.kernel.org/netdev/net-next/c/356c81b6c494
  - [08/17] net: bridge: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [10/17] can: gw: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [14/17] kcm: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [15/17] netfilter: nf_conncount: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [16/17] netfilter: expect: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)
  - [17/17] netfilter: xt_hashlimit: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



