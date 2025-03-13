Return-Path: <kvm+bounces-41005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFBDA6035F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:23:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B92803AD29C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4E81F4CB2;
	Thu, 13 Mar 2025 21:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vam83qAn"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1472126C1E
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741901018; cv=none; b=rV0jb1TqYIuuL0sEPqqdPZZSnkDNLJAIBpjaarNR5qgB8TwPtcyPhSuEEHoHQGvwh525E/RuuRJsJYb0ZUmTtDtnBb5pPRQGmtCDVy3SudJhbu2uIIInyzSk9uaLmdMqxhhgmM/rLhDHMHSAe2lWw0bhxo6De6s6kl9qfpqoMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741901018; c=relaxed/simple;
	bh=P7sEQ60PFSESIGOuTvMVWLp7MFJe5sQvrYAGjBA/4QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLtdmUWVxLFhwphF0ZZP1m/DZXIHmWbEVkAqTzeyxM3J8+N9qQ9sAcJt1EswyvdZ/ueOdmm1OBqvENJAigEIRuKBjvl2APZmb9KykFzwAWQsi/hWposRAmFoPR6AaIcCNsmlrOt+wGxbFgI6bTLtmcmkEDTPKwikWwarBsi0CmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vam83qAn; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Mar 2025 21:23:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741901004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V89hM8tFCpUAcVzUalvpAaojCLzCT+93s+jFlTRQ7/o=;
	b=Vam83qAnyD76YjtPadBmDPNg3sxoOwlWkbfO/KapGjtGqafRpV/fvYXsW+uaqz2SQrj+7w
	9pMNuIPaMt7LTTkr5mvVd2ZF3q6Xm6sJCMVNvx+kQl8Scax6rA8MegtH6Zrz2hRrYJ10fP
	QxTWTiuH5r6aa2zS6F2iU9CZnQQk+3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	"Kaplan, David" <David.Kaplan@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Unify IBRS virtualization
Message-ID: <Z9NMxr0Ri7VUlJzM@google.com>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 04:33:49PM +0000, Yosry Ahmed wrote:
> To properly virtualize IBRS on Intel, an IBPB is executed on emulated
> VM-exits to provide separate predictor modes for L1 and L2.
> 
> Similar handling is theoretically needed for AMD, unless IbrsSameMode is
> enumerated by the CPU (which should be the case for most/all CPUs
> anyway). For correctness and clarity, this series generalizes the
> handling to apply for both Intel and AMD as needed.
> 
> I am not sure if this series would land through the kvm-x86 tree or the
> tip/x86 tree.

Sean, any thoughts about this (or general feedback about this series)?

> 
> Yosry Ahmed (3):
>   x86/cpufeatures: Define X86_FEATURE_AMD_IBRS_SAME_MODE
>   KVM: x86: Propagate AMD's IbrsSameMode to the guest
>   KVM: x86: Generalize IBRS virtualization on emulated VM-exit
> 
>  arch/x86/include/asm/cpufeatures.h       |  1 +
>  arch/x86/kvm/cpuid.c                     |  1 +
>  arch/x86/kvm/svm/nested.c                |  2 ++
>  arch/x86/kvm/vmx/nested.c                | 11 +----------
>  arch/x86/kvm/x86.h                       | 18 ++++++++++++++++++
>  tools/arch/x86/include/asm/cpufeatures.h |  1 +
>  6 files changed, 24 insertions(+), 10 deletions(-)
> 
> -- 
> 2.48.1.601.g30ceb7b040-goog
> 

