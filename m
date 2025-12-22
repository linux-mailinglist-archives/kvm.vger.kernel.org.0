Return-Path: <kvm+bounces-66518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80629CD6E17
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 19:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80E23302A94D
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5860332EC0;
	Mon, 22 Dec 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mSmweQke"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADEC332ECB
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766427249; cv=none; b=dvIbtxslcwGMIIPqNAYiELOsxRVcBxYiJt3rZx6D+bhpOa+I70IoFT3U57pcJuUYB62+eE9cLzbhPjvu+epASbpYm5m8pxJ+1luP83wEAHS4nWnk7PywCL05Z8PEeYLNoGUeNySvZHDhfpYInKNqQsL0Vo5ne+etFHGCVVWXZbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766427249; c=relaxed/simple;
	bh=EyyOb4PKxtLYhAmad4I67cewqyzz2pY3nBCwkpU0xJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaAJcQYqdAIWBgEyNM+5n4DuU8VWWe8Z/BSJX6GJ7t09/iO4drVBxUkxbhrt8DTCUWNn5K2Gq03Nc4ljTI4k7GQo6y0Ybaspw/F69RTD4UskcPKespz7OSUpwBChdb9Rx6RxdEIiMpBVxOpXj+OCkzikPIAq9sYjJEgyJK2v0Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mSmweQke; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Dec 2025 12:13:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766427242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zbdPyaZPt9HJuw5KayESUOdJwXP9h3ishpTKFDCnuOw=;
	b=mSmweQkezDjTlowvtfQ01ceqsPrAlzTD82wZ81Ff/00w8pOs5trd9BEiiRITc9iGRwWqQE
	U/PavRPG/J60U79SSPVmg4xwSrDn4IJoYOGYeQTXAHSpAXw8IwtCaDe2eKFVAII3U53+5c
	VessnowekdTgPsJucK4sOf+amI3vf58=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org
Subject: Re: [PATCH v2 5/5] KVM: selftests: Fix typos and stale comments in
 kvm_util
Message-ID: <20251222-5d40dd87b6e6d0308ff1e900@orel>
References: <20251215165155.3451819-1-tabba@google.com>
 <20251215165155.3451819-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215165155.3451819-6-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 04:51:55PM +0000, Fuad Tabba wrote:
> Fix minor documentation errors in `kvm_util.h` and `kvm_util.c`.
> 
> - Correct the argument description for `vcpu_args_set` in `kvm_util.h`,
>   which incorrectly listed `vm` instead of `vcpu`.
> - Fix a typo in the comment for `kvm_selftest_arch_init` ("exeucting" ->
>   "executing").
> - Correct the return value description for `vm_vaddr_unused_gap` in
>   `kvm_util.c` to match the implementation, which returns an address "at
>   or above" `vaddr_min`, not "at or below".
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 4 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

