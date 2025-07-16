Return-Path: <kvm+bounces-52564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBFAB06CF4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D294E3620
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9A727281D;
	Wed, 16 Jul 2025 05:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jM1EtteE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A503597E;
	Wed, 16 Jul 2025 05:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752642480; cv=none; b=q5GIL0RNI0zf6Ut3IA55H4KiwbwzztT6R2Z2dsp1Re5TBfI2K92BdBFqwnHg7d4+gHNTvOKQGk5hfUeEUpDSzm0g+6lRgk6pwZqq+f1SMgUjZbL39W8mkQgZCQCFYe5y8UqJQVCG1O2nWug8Qlv7qD31HQJp7ScTdu9DU5JCZow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752642480; c=relaxed/simple;
	bh=QMCcgS8H6b0NTyUy16oi1nPFHtz7ibymTuYgq5x4YN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtQr7+CBqD6KgfLJZ6kgFbNi0q9pFxYJqqpdBqVPaLsh8POKFCA6zhuzWf4MFUwTkkNalLMidoRZjM1MuCCd5bYRi9C3mYL88kiYftQrV7OElRGYeoK7MtU7guNxaf4xGn2PXrFW/6nRrbjhsnuTjaObnXIwPJGKMEUyDeplE28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jM1EtteE; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752642479; x=1784178479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QMCcgS8H6b0NTyUy16oi1nPFHtz7ibymTuYgq5x4YN8=;
  b=jM1EtteEzY1kUERXKxWzh9JLBzjQl0+Df2Cy76CEFstoRjP/SaxbFSSv
   ori2/W9mbRgwyUwDGy/DIdh6dmcEYFj772Zw+/PScJH8O1g5xExbx4VV6
   4Ev/ddL/Fu5mAzZHMQpSUiK74YpbsrDFePO95bdBhs5USRJp6Vd53+3uY
   cSutS1PrNip55IqnBQctEnIroA9FnkQqTHz2lrnv5puDBHWXxJwKL4Qrd
   T6jzV/pWK1wJJNFPlvg9AuqsBkD/pQM3ncx8+tbHkoIz5JUwwS47hnNYA
   dWVCIS920Cu78BK2QlIItaUMDjRgZq+G9iqoT/XXB4KQP7Wa4OJXIpG5f
   A==;
X-CSE-ConnectionGUID: pww3+7DITD+g0E2rlJ7Pvg==
X-CSE-MsgGUID: EgkvVJuKTPaUbFZxc0DSvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="55026216"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="55026216"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:07:57 -0700
X-CSE-ConnectionGUID: 42ThZuFZT06jHaEFVlQWfw==
X-CSE-MsgGUID: /IlBCgamRSmR6+bWLAGcGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="188408979"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:07:43 -0700
Message-ID: <83d124c1-2d1d-4ba4-a72b-82a008a97301@intel.com>
Date: Wed, 16 Jul 2025 13:07:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/21] KVM: Introduce kvm_arch_supports_gmem()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-4-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Introduce kvm_arch_supports_gmem() to explicitly indicate whether an
> architecture supports guest_memfd.
> 
> Previously, kvm_arch_has_private_mem() was used to check for guest_memfd
> support. However, this conflated guest_memfd with "private" memory,
> implying that guest_memfd was exclusively for CoCo VMs or other private
> memory use cases.
> 
> With the expansion of guest_memfd to support non-private memory, such as
> shared host mappings, it is necessary to decouple these concepts. The
> new kvm_arch_supports_gmem() function provides a clear way to check for
> guest_memfd support.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 +++-
>   include/linux/kvm_host.h        | 11 +++++++++++
>   virt/kvm/kvm_main.c             |  4 ++--
>   3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index acb25f935d84..bde811b2d303 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2277,8 +2277,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   
>   #ifdef CONFIG_KVM_GMEM
>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
>   #else
>   #define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_supports_gmem(kvm) false
>   #endif
>   
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> @@ -2331,7 +2333,7 @@ enum {
>   #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
>   
>   # define KVM_MAX_NR_ADDRESS_SPACES	2
> -/* SMM is currently unsupported for guests with private memory. */
> +/* SMM is currently unsupported for guests with guest_memfd private memory. */

Please don't change the comment.

As below, it checks kvm_arch_has_private_mem(). Nothing to do with 
guest_memfd.

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
>   # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
>   # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)



