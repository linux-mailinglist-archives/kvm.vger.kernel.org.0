Return-Path: <kvm+bounces-16391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 587868B932E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 03:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9617B22651
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E35171AD;
	Thu,  2 May 2024 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="EZAY33JE"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474733207;
	Thu,  2 May 2024 01:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714614300; cv=none; b=X6OxVT8M5GzmKZlZXfyILrYQdxR7vtCqLVbQrXUeNJ2GNuBb9SScbxENsODQoXZUZU0BuJz9Kb2IIUN64j7Z6leF+/mdSEr9giJEerNnqFhROhgjV5cmRciVq4VzzQNaCOknytLerM06VMfQl3QvkG8/X5sCM1qJx8Dg3lwBfn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714614300; c=relaxed/simple;
	bh=4/6ccF66M6jfy4na42oviYshr2LOBPT25Dm7w4642t4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RINtBZzi5mDN6/hWe4eGwUXSNAQ25/oe2pnfYNpguijOedhyIIdEtvPtN0rkuY3yDPjNpY5rAkGUV5FxTijrcaleBiESzoUpbsn/Dq/Iom5oprk3J1a65yNMJz3GS7VlVuFXdOaifU9KOOd4SLiM1ktz0Y9z47uPSRoKEPxjfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=EZAY33JE; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1714613623;
	bh=4/6ccF66M6jfy4na42oviYshr2LOBPT25Dm7w4642t4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=EZAY33JEALU8XVl7KTq3DxYg/uHLFyAMRvc4XqzUNE64PUsUG/nI+FirEx7DByHNF
	 ZbpTx75v9UJMxP/IMChibVgFYJup586biteVaVOAQar6SqFbC+LrFD0f4TQQ86BH94
	 3Uu9sInK+nne4DE4ugGPvNsR2M36BSUVqMBcoPeI=
Received: by gentwo.org (Postfix, from userid 1003)
	id F07EF401D5; Wed,  1 May 2024 18:33:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id ECB50401C3;
	Wed,  1 May 2024 18:33:42 -0700 (PDT)
Date: Wed, 1 May 2024 18:33:42 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH 1/9] cpuidle: rename ARCH_HAS_CPU_RELAX to
 ARCH_HAS_OPTIMIZED_POLL
In-Reply-To: <20240430183730.561960-2-ankur.a.arora@oracle.com>
Message-ID: <7473bd3d-f812-e039-24cf-501502206dc9@gentwo.org>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com> <20240430183730.561960-2-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 30 Apr 2024, Ankur Arora wrote:

> ARCH_HAS_CPU_RELAX is a bit of a misnomer since all architectures
> define cpu_relax(). Not all, however, have a performant version, with
> some only implementing it as a compiler barrier.
>
> In contexts that this config option is used, it is expected to provide
> an architectural primitive that can be used as part of a polling
> mechanism -- one that would be cheaper than spinning in a tight loop.

The intend of cpu_relax() is not a polling mechanism. Initial AFAICT it 
was introduced on x86 as the REP NOP instruction. Aka as PAUSE. And it was 
part of a spin loop. So there was no connection to polling anything.

The intend was to make the processor aware that we are in a spin loop. 
Various processors have different actions that they take upon encountering 
such a cpu relax operation.

The polling (WFE/WFI) available on ARM (and potentially other platforms) 
is a different mechanism that is actually intended to reduce the power 
requirement of the processor until a certain condition is met and that 
check is done in hardware.

These are not the same and I think we need both config options.

The issues that you have with WFET later in the patchset arise from not 
making this distinction.

The polling (waiting for an event) could be implemented for a 
processor not supporting that in hardware by using a loop that 
checks for the condition and then does a cpu_relax().

With that you could f.e. support the existing cpu_relax() and also have 
some form of cpu_poll() interface.


