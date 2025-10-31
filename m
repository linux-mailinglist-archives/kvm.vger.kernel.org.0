Return-Path: <kvm+bounces-61666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB1BC2409D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E5FA582DB3
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12C93314DD;
	Fri, 31 Oct 2025 09:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vun81wAc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DA6330D42;
	Fri, 31 Oct 2025 09:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901551; cv=none; b=cjnf4/9PpaafOYWbeHh6SyDTgOpLGW+Tn7O9TVG6a41QYQXAi/lN0QHbhx011reETBODNtXJn5ebFdulPwdO+GjZCta6/Y31vdTK5ge+eYdIHGFPfmCCHVZGmTZncISbePhlC21IYWDAyU+iZQAt4ombXyLImicJVBeRU36aKNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901551; c=relaxed/simple;
	bh=qFNmSQUeXMaY7XvP4sAPgKkJ8Ev3XCXyw2q+qbAZDIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfCxXx7NTa9CeSPi6WgXJYPemJqGtpSNxjRjV09JT0P7OPrZAoCsd2Frim5Ti3B4pJ/RNsJMvltMlnp84iCi0Lp3FJPvACp1SXhZJthYRzAB1NOkKRnhD7UV7AbhWMuGyqoJ9SI47E7aXPdzebaB8GbxdDrIiQ+2moFMKmvvwyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vun81wAc; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901550; x=1793437550;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qFNmSQUeXMaY7XvP4sAPgKkJ8Ev3XCXyw2q+qbAZDIU=;
  b=Vun81wAcy+RcxGoGoHOb4w/NwL2uJtMlUTm2z1ByhQTSFBItC2aNdrpq
   92T/FKqpDQvdnvgjxcwIC6YlCgxGoz/emZ7hk6uD2+XjR94RWwxRJ6xU1
   gsLglw13wJmxN9Df0KMgrS85Svv8VwMB53dNV3/DmL1ZDa101+rWp3Qti
   gLiR4igQ217qGCDrSY/V40DPCek8EglRr7vR5cFEYMB0eazMRSoxZTa9A
   RoeD0Rqpz/PHXh7xvH/Vbw2buzuDd9PosvTCCYTYSrOwvyo8qutvw9uU9
   eDCd+hl1zO5a7vGJ0tBLZvmovR5kZhlFvq08MxGySBA3emcUTzTShXNvN
   A==;
X-CSE-ConnectionGUID: 65a9MG8gRdOtC5sbjJs+cQ==
X-CSE-MsgGUID: I9UlVlnuTOmmmz7S0CnGyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74735559"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="74735559"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:05:49 -0700
X-CSE-ConnectionGUID: 74SstBqUTA+jLaMpUFXqYw==
X-CSE-MsgGUID: XHQQUxgjRVKQmbMphXDwOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186121992"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:05:41 -0700
Message-ID: <18ecf186-c3b9-4027-a54b-7f3e5ba9f484@linux.intel.com>
Date: Fri, 31 Oct 2025 17:05:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/28] KVM: TDX: Assert that mmu_lock is held for write
 when removing S-EPT entries
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
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> Unconditionally assert that mmu_lock is held for write when removing S-EPT
> entries, not just when removing S-EPT entries triggers certain conditions,
> e.g. needs to do TDH_MEM_TRACK or kick vCPUs out of the guest.
> Conditionally asserting implies that it's safe to hold mmu_lock for read
> when those paths aren't hit, which is simply not true, as KVM doesn't
> support removing S-EPT entries under read-lock.
>
> Only two paths lead to remove_external_spte(), and both paths asserts that
                                                                 ^
                                                               assert
> mmu_lock is held for write (tdp_mmu_set_spte() via lockdep, and
> handle_removed_pt() via KVM_BUG_ON()).
>
> Deliberately leave lockdep assertions in the "no vCPUs" helpers to document
> that wait_for_sept_zap is guarded by holding mmu_lock for write, and keep
> the conditional assert in tdx_track() as well, but with a comment to help
> explain why holding mmu_lock for write matters (above and beyond why
> tdx_sept_remove_private_spte()'s requirements).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 63d4609cc3bc..999b519494e9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1715,6 +1715,11 @@ static void tdx_track(struct kvm *kvm)
>   	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
>   		return;
>   
> +	/*
> +	 * The full sequence of TDH.MEM.TRACK and forcing vCPUs out of guest
> +	 * mode must be serialized, as TDH.MEM.TRACK will fail if the previous
> +	 * tracking epoch hasn't completed.
> +	 */
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	err = tdh_mem_track(&kvm_tdx->td);
> @@ -1762,6 +1767,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	gpa_t gpa = gfn_to_gpa(gfn);
>   	u64 err, entry, level_state;
>   
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
>   	/*
>   	 * HKID is released after all private pages have been removed, and set
>   	 * before any might be populated. Warn if zapping is attempted when


