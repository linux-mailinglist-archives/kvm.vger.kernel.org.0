Return-Path: <kvm+bounces-19510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C516E905DC7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C8C21F21F6C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975EB12BF1B;
	Wed, 12 Jun 2024 21:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4gew7GX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF5721360;
	Wed, 12 Jun 2024 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718227987; cv=none; b=qPOGh3cBQ5vGzCpkT5nkfedRvukKoVpJ9t8sCqNS69O5sXGF22H3Fa67hgS4WwN+qBoh2bEVRGrp8r0z3N+MJhy78ija599nALW5sO5WTuFPVDT42wDGew6NKvoXr+kKfrcGzx+dDsSzZt55U0nJni5wW+ND7rkBpYtF0RlYi/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718227987; c=relaxed/simple;
	bh=D7/e9lxK/rDnF5q2wBJbSwFKBep+OjF1zHYFBRsOwHY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBcrGrXaA1dgG3BtMGN9vY/WlFnWbMDlomUU7/dsIYW6Ey8fEEi8UqYvptj9MMTSecWNpT128fkxR4z5q9FOgsfc5HlZp4C7/jAlS+dIaIHT9bqlOMG3XIuiZ2BsCyT1JkxPzKD5NlwuM2zQFW0g0VlKoPK+fCzihNbHYTOs6eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4gew7GX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31DEC116B1;
	Wed, 12 Jun 2024 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718227987;
	bh=D7/e9lxK/rDnF5q2wBJbSwFKBep+OjF1zHYFBRsOwHY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J4gew7GXSUxZyxXl6G49+4erFfWm/fvqP8jJMq7QuXBUHyR17gKVbI8IJ3y71epYo
	 81Eq4piaIn37sHAKw45pOJJnpiTeuc2KSFxdSD1+2LioYDUAwYQQ8KGiGECKgXZ1Bt
	 BQIkYrv1Z3RNFkSAHVf81GTPLI5u7plWmLvmv2tSr8XWK2kuYVByujH0Xm2sSG3rLe
	 dcH3Q/OlBdRCiuZINoD5hS74CGC35ok/tQmpHn36JG4CCNQB6ctPj6kIhn5MA8jO7+
	 XDUBrtlraXPQiItIjFfHu36XD/1shI91JiWJHwx90qz33buNQ2dew6BWeH46IO/yU8
	 gdQU9P2cQi32g==
Date: Wed, 12 Jun 2024 14:33:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: linux-block@vger.kernel.org, kernel-janitors@vger.kernel.org,
 bridge@lists.linux.dev, linux-trace-kernel@vger.kernel.org, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, "Naveen N. Rao"
 <naveen.n.rao@linux.ibm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Nicholas Piggin <npiggin@gmail.com>,
 netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
 linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org, Neil Brown
 <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 linux-nfs@vger.kernel.org, linux-can@vger.kernel.org, Lai Jiangshan
 <jiangshanlai@gmail.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, "Paul E . McKenney" <paulmck@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <20240612143305.451abf58@kernel.org>
In-Reply-To: <20240609082726.32742-1-Julia.Lawall@inria.fr>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> Since SLOB was removed, it is not necessary to use call_rcu
> when the callback only performs kmem_cache_free. Use
> kfree_rcu() directly.
> 
> The changes were done using the following Coccinelle semantic patch.
> This semantic patch is designed to ignore cases where the callback
> function is used in another way.

How does the discussion on:
  [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
  https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
reflect on this series? IIUC we should hold off..

