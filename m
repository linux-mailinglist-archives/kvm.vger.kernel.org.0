Return-Path: <kvm+bounces-6738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 080F38398C4
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 19:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B4F01C279B0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 18:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D218782D82;
	Tue, 23 Jan 2024 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PRTb+ALT"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82D823AC
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706035670; cv=none; b=lLYkRbYqI5EFY1qMKjG0fgLEhob1hRP5ArEWQuJww3VTLfG36gpohEkfJbOn3sSVwyiD7tsFAE1Qgs8Fnn6FQbuAqaBNsVy/MvN/Vtouwnbo7Jmdlub5uAIIGyxWVpTmRtk3jt0U5gXV0l3KRAk+7GnbLNfrtJaTuNRi1NIiEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706035670; c=relaxed/simple;
	bh=SzGjS/uTjELtYiEmIZGNWCQ4rYkz2lxbaor0Azobn0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qdio3UL7LNqLQBkF6gTftBAZzfzUnK4Z9oELsIjqsBG0UqqnmrHglIlw06DW51eqVm+7LRX957Ibokw/QlMed/ZQd8Npu+4RcawCaNWX2JiNIOoZwXglT4nxCLba3mohOW5pUt4AbMalk308pmfVSxD2I8wJFCD+UaEZ2IgRzm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PRTb+ALT; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Jan 2024 18:47:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706035666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jf0WIQvriSPRdd8bjaSPnj7IcZw/8YcIP2eUwPV7dBo=;
	b=PRTb+ALTCGzgEjic0P0mQ2nZdMKC6g/SzVwqHWBYKvFiRxqueRjobgBUyKJ+uxaAEUIZut
	H7jOVoD+5dIN+LNgBiT09M1ccyqghhUtcPL+63vOCv2v1+8uuOoyzU/+lpg2cbziHRY5x6
	9/DcHr+og2R1AOkJKgpsxKzJWFErVJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yi Wang <up2wing@gmail.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, wanpengli@tencent.com,
	foxywang@tencent.com, maz@kernel.org, anup@brainfault.org,
	atishp@atishpatra.org, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [v2 1/4] KVM: irqchip: add setup empty irq routing function
Message-ID: <ZbAJzFeRa_6NQznQ@linux.dev>
References: <20240121111730.262429-1-foxywang@tencent.com>
 <20240121111730.262429-2-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121111730.262429-2-foxywang@tencent.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 21, 2024 at 07:17:27PM +0800, Yi Wang wrote:
> Add a new function to setup empty irq routing in kvm path, which
> can be invoded in non-architecture-specific functions. The difference
> compared to the kvm_setup_empty_irq_routing() is this function just
> alloc the empty irq routing and does not need synchronize srcu, as
> we will call it in kvm_create_vm().
> 
> This patch is a preparatory step for an upcoming patch to avoid
> delay in KVM_CAP_SPLIT_IRQCHIP ioctl.

Adding a function in a separate patch from its callsites is never
useful. Please squash this into the second patch.

-- 
Thanks,
Oliver

