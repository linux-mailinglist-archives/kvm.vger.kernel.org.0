Return-Path: <kvm+bounces-42770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1ADFA7C67F
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 01:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4CA53B2A01
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB0E1A841E;
	Fri,  4 Apr 2025 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PyNqoE2/"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F126F15990C
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 23:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743807679; cv=none; b=k9AAAxw5TWjjcq0L4B0dK+jDW2Ctyi/SehRyLnm4o7xzT3jhr8m6EAUAm6iaCmCVEfeqvqxtVjGTe9b2ImvQLvW9Uru9sJ0jSItBaOBLoW8+7HEVcMobZRRwDqPcYvwVnmpZdYWIWyTAZ9uW313Uqfj3RU/LIq79zrgWygB/7f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743807679; c=relaxed/simple;
	bh=8JXCydsPOHzLUEkj6S8pAb7qip648/8JXVPlR/qPOuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyenC4ogv0jSsN91sl56g+krkkNMQgFDPb8nY/8o1Q3L2vmXJBIZH7Ojbd+1oi3DFn1oLDuI54xAE3GZLWb4blS9AMlrPiHAmF6TNYumczfogviYte2HoroEfCMpX6Iq76trlgJsd3aok32zuFpcqD2Q1FtniCcomDNmBM6qsTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PyNqoE2/; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Apr 2025 16:01:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743807670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7WE4k0gwgTAUdZ3znm9Bphq+twxiG2Hgud2fjJc9JwU=;
	b=PyNqoE2/uDWdg8j9a/zZA+hEa6IgIfhZnH++GFAzOCUqkD/3MxaMoGETH/bOrsK4RMj0tZ
	3cuWIXLc2+4QaqYxb/3koglx3rsxd33mzVqIdmCUJ8zXAPn4yta8DhMdtByqfwr7S7d5JV
	82bM8c0zA8FEttfc3VTH8bcwMH6KGUQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
Message-ID: <Z_BksUn4JiPPGc4G@linux.dev>
References: <20250404220659.1312465-1-rananta@google.com>
 <20250404220659.1312465-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404220659.1312465-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 04, 2025 at 10:06:59PM +0000, Raghavendra Rao Ananta wrote:
> Atomic instructions such as 'ldset' over (global) variables in the guest
> is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
> was particularly apparent on Neoverse-N3.
> 
> According to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte load/store),
> it is implementation defined that a data abort with the mentioned FSC
> is reported for the first stage of translation that provides an
> inappropriate memory type. It's likely that the same rule also applies
> to memory attribute mismatch. When the guest loads the memory location of
> the variable that was already cached during the host userspace's copying
> of the ELF into the memory, the core is likely running into a mismatch
> of memory attrs that's checked in stage-1 itself, and thus causing the
> abort in EL1.

Sorry, my index of the ARM ARM was trashed when we were discussing this
before.

DDI0487L.a B2.2.6 describes the exact situation you encountered, where
atomics are only guaranteed to work on Inner/Outer Shareable MT_NORMAL
memory.

What's a bit more explicit for other memory attribute aborts (like the
one you've cited) is whether or not the implementation can generate the
abort solely on the stage-1 attributes vs. the combined stage-1/stage-2
attributes at the end of translation.

Either way, let's correct the citation to point at the right section.

Thanks,
Oliver

