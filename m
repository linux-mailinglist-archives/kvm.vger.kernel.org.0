Return-Path: <kvm+bounces-60798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 08CE1BFA214
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9ED974F127E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 05:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5062EC0A4;
	Wed, 22 Oct 2025 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fq9beKtZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB22623AB9C;
	Wed, 22 Oct 2025 05:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112598; cv=none; b=dFIHbfFWsbge61KGemVhlTGIkj7jQoQiow2YHRNwxCHtUpuavkRcJhLtoOpo/DnkeStf6bQyaolQpjGj5NZeDkkD0MJIc3rsMerm5LX0dEFx+bEE0hJUUAqWbll6hQ048wDHXv6mdDy0iOjArt4w+UQIQf+5wd/bXoyZ5onuZaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112598; c=relaxed/simple;
	bh=e0BNSEe8+JWm79ZsctEdZVSTDEu6ZAcAN5FVm7Wus1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTRU1FrSkNg+jKeEkDLhTtH6tQF1RUdM03m1aol2GGsuV3TE8mxNm6WgLX/fpnVbJi/D62SMZrGoTooXsN1Wxizegcl7ComKo4HQsRp7Pp8c7oh7mihBokPEZ+Vb1hk9ZcHk63nVGBvCtH3QbcgpPtjo4JHIDzp4okQ0Zuz2Sks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fq9beKtZ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761112596; x=1792648596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e0BNSEe8+JWm79ZsctEdZVSTDEu6ZAcAN5FVm7Wus1E=;
  b=fq9beKtZpSZ9xtF+1HtgOxXkuuxjT4aQcwDE1euEyeV7Srf9KEC3+Wkp
   N2HU5onhiIKNBycmOWo333J71u/xv0N8gUnRtNJokKeVJyn2u9b5JWOrf
   ULvKNp+Snf9bPgTr3OWDqvyYHcqC5iju7Jx/zzBdGeelzj2gMGSPOuyiT
   ySstzO4fXUxfPN7+M50NCYJ38POiG4+gc5+rLVt+Uf0P7itDQDwvV0izU
   YXrXf86y0I/2f9OJccsLMHRs3VavY0uDXlJAxJ93CTcZBVQGz8006BBC8
   PJ79/mKqSTUkt+PxuqCH5vQLdHmaFJEGOut9fksw+TVkHc0ihel32Ny9s
   w==;
X-CSE-ConnectionGUID: +icgYwRvTquDif4tD09DqA==
X-CSE-MsgGUID: uQcm2lSUSUSQtXWIpNgFnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73920266"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="73920266"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:56:35 -0700
X-CSE-ConnectionGUID: oEyBARVoRTqxmx9FX15Ezg==
X-CSE-MsgGUID: iu37FNdWT/WUX/u/fUlTIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="184184586"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 22:56:28 -0700
Message-ID: <7aa86887-b499-4618-b174-96cb0cd17d24@linux.intel.com>
Date: Wed, 22 Oct 2025 13:56:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/25] Revert "KVM: x86/tdp_mmu: Add a helper function
 to walk down the TDP MMU"
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-6-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251017003244.186495-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> Remove the helper and exports that were added to allow TDX code to reuse
> kvm_tdp_map_page() for its gmem post-populate flow now that a dedicated
> TDP MMU API is provided to install a mapping given a gfn+pfn pair.
>
> This reverts commit 2608f105760115e94a03efd9f12f8fbfd1f9af4b.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

