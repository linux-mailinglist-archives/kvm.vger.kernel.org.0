Return-Path: <kvm+bounces-39110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5FCA4411F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75C2B172818
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4332626982F;
	Tue, 25 Feb 2025 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wH+xhjsR"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE921C8600
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740490666; cv=none; b=ubDaJgwVmZRmq6SC2DlXhOKmPKUGslmUBmar/SOpVDsk/Uz/tsOpL7J6xsJIO/D/RMVIb55dcDlSip7PCuhM+UT6dIruL8pyg1eCF9ELhWAbSfopNUVFK4x1Wrdj/Qg33JsyAGmnfToNQyqxWBsgzHy2Jl4v2l/CyXblFycXfsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740490666; c=relaxed/simple;
	bh=wvvJXRE0O84VRA3zOoy6Pc4KAcKH5gEPxyv2TGshKEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwjvW0NS9NwgHbr8levgpDIrwh3/N4eUV31RwauFYYa1sU+Hz1if/PTJV9r5qb+kDylOEgsQ7KauQ1N5Te5xN1Wv40i6go02jTJNqfCRhPcASA5hTn5a3/O8nt0uD/gO+jUsqox8awrX3LhM2v9r8eNacEpzd3+H2KaUgin5Ofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wH+xhjsR; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 25 Feb 2025 14:37:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740490661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ixqOC12lcUbO8F8o140WgK+Y55hHmyICfLfrpYnuPM=;
	b=wH+xhjsRmvhrhpxvrfoccwgz9vk4ycI7xJw3NIyc5a0Cnhjg34RUCnfdqBfFCOGenODEy4
	mNmIL02lvg+cKWngs6CywduekBe+7s9leXhvNgdLmd/IyG5MmwUslcfu2ORydBCklhQp32
	SvBxreXHRruBA0wHnBtaIVkApGPpBH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [RFC kvm-unit-tests PATCH] lib: Use __ASSEMBLER__ instead of
 __ASSEMBLY__
Message-ID: <20250225-f474d056a12e6b23cc05f9e7@orel>
References: <20250222014526.2302653-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250222014526.2302653-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 05:45:26PM -0800, Sean Christopherson wrote:
> Convert all non-x86 #ifdefs from __ASSEMBLY__ to __ASSEMBLER__, and remove
> all manual __ASSEMBLY__ #defines.  __ASSEMBLY_ was inherited blindly from
> the Linux kernel, and must be manually defined, e.g. through build rules
> or with the aforementioned explicit #defines in assembly code.
> 
> __ASSEMBLER__ on the other hand is automatically defined by the compiler
> when preprocessing assembly, i.e. doesn't require manually #defines for
> the code to function correctly.
> 
> Ignore x86, as x86 doesn't actually rely on __ASSEMBLY__ at the moment,
> and is undergoing a parallel cleanup.

With ignoring x86, I see just one other instance of ASSEMBLY, which is in
a comment and is mispelled to only have the leading underscores

lib/libfdt/fdt.h:48:#endif /* !__ASSEMBLY */

With that replaced, for riscv and arm

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

