Return-Path: <kvm+bounces-19586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCF69074F6
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B54D31C20F79
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43514145FE2;
	Thu, 13 Jun 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q809wP6K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C041422B4;
	Thu, 13 Jun 2024 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718288261; cv=none; b=E9WySayjFoyRSSaMjytV+5ATbrPtNqZhH4/lfxdob9DCjQymYkm2j8SXYivXnc8PxJH5d2drTasafBP4lcn4q2hvN4ubi+eDQCAdVFqoLtNrm4jk/oROTeP/67MjuzkKJXBAcCkNg9V4LysZUphvw1Io4UDnPbm4nS5EG6rFoiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718288261; c=relaxed/simple;
	bh=cY+0iwxjfi/10UJxN+zolp0hxf4e2REnIO+nP7ilZd8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Di1089C/7cRankZdIDcyopWIvx02Bvkz1OeQOmoKFWdAa8S8bguZUjBsIgUCNzcXBu5+7OOzmHK1We2AqifkOdksciAVi+jwGs7iTG4AT0woY0K1d0xLfrNRcyx2eXU2OfjLzRdkh3i22rdCKDNdC7lWCRsfxeWS+W/EuE38QDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q809wP6K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DC4C2BBFC;
	Thu, 13 Jun 2024 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718288260;
	bh=cY+0iwxjfi/10UJxN+zolp0hxf4e2REnIO+nP7ilZd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q809wP6KZ6dZ2KKSNToRWIFGS+TU6NU5CCFFg8KWmjJdi9aaszmfpaIVjMuKfhLBq
	 UJN5SEQEE8k67Ilrcup/14dWJNiWzw0Gq+kTmnOl3cxHd/hbJzGBv+df0UJzjBy5rb
	 ZUDfjc8O2vhrMLxae6+zOsoY3P2BzyKzw8yVcyNwWMpzV3fPJ6TSsnQvWxZdGFCxDT
	 3B33zlCsYWklU7myIP2EJ3nyLUoXLsT69r0HpVC2VQfvEe7SoXPLmc6THf+m1HnZiR
	 lCoP/WG4vm/wiMYunXqBSRWXb9Hw5BHuRVJlFTqnizqyGgcBHJWG9D5e2NvdeRzYGl
	 RfuQc0M2cv//A==
Date: Thu, 13 Jun 2024 07:17:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Julia Lawall
 <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
 kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, "Naveen N. Rao"
 <naveen.n.rao@linux.ibm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Nicholas Piggin <npiggin@gmail.com>,
 netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
 linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org, Neil Brown
 <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 linux-nfs@vger.kernel.org, linux-can@vger.kernel.org, Lai Jiangshan
 <jiangshanlai@gmail.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <20240613071738.0655ff4f@kernel.org>
In-Reply-To: <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
	<20240612143305.451abf58@kernel.org>
	<baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
	<Zmov7ZaL-54T9GiM@zx2c4.com>
	<Zmo9-YGraiCj5-MI@zx2c4.com>
	<08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Jun 2024 20:38:02 -0700 Paul E. McKenney wrote:
> o	Make rcu_barrier() wait for kfree_rcu() objects.  (This is
> 	surprisingly complex and will wait unnecessarily in some cases.
> 	However, it does preserve current code.)

Not sure how much mental capacity for API variations we expect from
people using caches, but I feel like this would score the highest
on Rusty's API scale. I'd even venture an opinion that it's less
confusing to require cache users to have their own (trivial) callbacks
than add API variants we can't error check even at runtime...

