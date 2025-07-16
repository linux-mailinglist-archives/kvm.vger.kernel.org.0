Return-Path: <kvm+bounces-52637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0D9B075DB
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C7531892BBB
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D522F509B;
	Wed, 16 Jul 2025 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrYvOd7X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A32B19CC37;
	Wed, 16 Jul 2025 12:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669582; cv=none; b=sYXQavXuUrDQeUrI7Vxym4ZsDQ53HHDP1+8qOrfnm+ZaqFKL98tdR5kAQYfvAfHacMMdhwyZvicZ/tjt//8IxF1nomBx2DcKvP3XjIoYYgaMG4lSLKyTCrH+CCjq7m6yQdCbgAi/4Y1uN85vyAy0SL5FBl4lFii5mGMsslQobvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669582; c=relaxed/simple;
	bh=cHjkb9Opsdc3THxe/4NAVACMMW673IYb7HqjRSyKF7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lg3X7n7MZJ5SHMMzU8fXcsYrmryQawaVTc8aXmf3Oaer6TWsR3RVso04LjNHFVjtzntWfn+hLonzOHFY8q6nD5Yf71eSm3AuAJKoAcIdzxcq5pjkPdSNW60NSyC1O35QpEM/rAnIGPpiEUfKI9AotpbBV9yQ4Z6Qu2q+Y1WS6pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lrYvOd7X; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752669580; x=1784205580;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cHjkb9Opsdc3THxe/4NAVACMMW673IYb7HqjRSyKF7I=;
  b=lrYvOd7XnBoMIDT5PlcwT5mkhC6pG73AemiKlDseMgqi4b8C1bX8PauI
   tkcoE9W6iQOpH/+dUVG5BozL+LLAmqXdtKjwR56Lgd/ye3/8fg+S53uKs
   7z+RjdAlSIBXw/MsW9JWpzj90Ey0g5dnm13G+KNaodF36rMtwmzmYlw5p
   KdvDeq7Y9n+Fm0H1yTuqjGD4giQrFB7UexZZza75ZActgHdnSwPFrnjdQ
   uz4m1OekCUAK+rB2WAVVpu7bSDxskcUtD/unn0KFIU6YmPz/Yg5u2kNd7
   fg0Skyyb4N8BWBgyDH3RvAJ4nX/CxYWqcLJY+6Tj6Hm85C1uw/TWXH6fo
   A==;
X-CSE-ConnectionGUID: Txktgtc6T42JbFoNe8DfcQ==
X-CSE-MsgGUID: r2uJznPZSReni1cT16Vayw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65482604"
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="65482604"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:39:39 -0700
X-CSE-ConnectionGUID: mvq7H6+oQaikv0WazwLfTg==
X-CSE-MsgGUID: aqXX1s79TyCTOFMuOZuDyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="158047006"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:39:25 -0700
Message-ID: <c8b74572-3ed3-4a93-8433-1207e59f56e7@intel.com>
Date: Wed, 16 Jul 2025 20:39:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Fuad Tabba <tabba@google.com>, David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
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
 <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
 <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com>
 <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
 <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
 <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com>
 <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
 <f7a54cc4-1017-4e32-85b8-cf74237db935@redhat.com>
 <CA+EHjTzOqCpcaNU4caddh6N3bCO0GvrOoZ+rMApdRh4=+BEXNA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CA+EHjTzOqCpcaNU4caddh6N3bCO0GvrOoZ+rMApdRh4=+BEXNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 8:24 PM, Fuad Tabba wrote:
> On Wed, 16 Jul 2025 at 13:14, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 16.07.25 14:01, Xiaoyao Li wrote:
>>> On 7/16/2025 7:15 PM, David Hildenbrand wrote:
>>>> On 16.07.25 13:05, Fuad Tabba wrote:
>>>>> On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>>>>
>>>>>> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
>>>>>>> On 16.07.25 10:31, Xiaoyao Li wrote:
>>>>>>>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
>>>>>>>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>>>>>>>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>>>>>>>>>> The original name was vague regarding its functionality. This
>>>>>>>>>>> Kconfig
>>>>>>>>>>> option specifically enables and gates the kvm_gmem_populate()
>>>>>>>>>>> function,
>>>>>>>>>>> which is responsible for populating a GPA range with guest data.
>>>>>>>>>> Well, I disagree.
>>>>>>>>>>
>>>>>>>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
>>>>>>>>>> 89ea60c2c7b5
>>>>>>>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
>>>>>>>>>> memory"), which is a convenient config for vm types that requires
>>>>>>>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
>>>>>>>>>>
>>>>>>>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let
>>>>>>>>>> kvm_gmem_populate()
>>>>>>>>>> operate only on private gfns") that started to use
>>>>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate()
>>>>>>>>>> function. But
>>>>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
>>>>>>>>>>
>>>>>>>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate
>>>>>>>>>> kvm_gmem_populate() is
>>>>>>>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE
>>>>>>>>>> to gate
>>>>>>>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
>>>>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
>>>>>>>>>>
>>>>>>>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
>>>>>>>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
>>>>>>>>> I'll quote David's reply to an earlier version of this patch [*]:
>>>>>>>>
>>>>>>>> It's not related to my concern.
>>>>>>>>
>>>>>>>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
>>>>>>>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
>>>>>>>> not correct.
>>>>>>>
>>>>>>> It protects a function that is called kvm_gmem_populate().
>>>>>>>
>>>>>>> Can we stop the nitpicking?
>>>>>>
>>>>>> I don't think it's nitpicking.
>>>>>>
>>>>>> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
>>>>>> first place, and why it was picked to protect kvm_gmem_populate()?
>>>>>
>>>>> That is, in part, the point of this patch. This flag protects
>>>>> kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
>>>>> is the only thing it protects.
>>>>
>>>> I'll note that the kconfig makes it clear that it depends on
>>>> KVM_GENERIC_MEMORY_ATTRIBUTES -- having support for private memory.
>>>>
>>>> In any case, CONFIG_KVM_GENERIC_PRIVATE_MEM is a bad name: what on earth
>>>> is generic private memory.
>>>
>>> "gmem" + "memory_attribute" is the generic private memory.
>>>
>>> If KVM_GENERIC_PRIVATE_MEM is a bad name, we can drop it, but not rename
>>> it to CONFIG_KVM_GENERIC_GMEM_POPULATE.
>>>
>>>> If CONFIG_KVM_GENERIC_GMEM_POPULATE is for some reason I don't
>>>> understand yet not the right name, can we have something that better
>>>> expresses that is is about KVM .. GMEM ... and POPULATE?
>>>
>>> I'm not objecting the name of CONFIG_KVM_GENERIC_GMEM_POPULATE, but
>>> objecting the simple rename. Does something below look reasonable?
>>>> ---
>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>>> index 2eeffcec5382..3f87dcaaae83 100644
>>> --- a/arch/x86/kvm/Kconfig
>>> +++ b/arch/x86/kvm/Kconfig
>>> @@ -135,6 +135,7 @@ config KVM_INTEL_TDX
>>>            bool "Intel Trust Domain Extensions (TDX) support"
>>>            default y
>>>            depends on INTEL_TDX_HOST
>>> +       select KVM_GENERIC_GMEM_POPULATE
>>>            help
>>>              Provides support for launching Intel Trust Domain Extensions
>>> (TDX)
>>>              confidential VMs on Intel processors.
>>> @@ -158,6 +159,7 @@ config KVM_AMD_SEV
>>>            depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>>>            select ARCH_HAS_CC_PLATFORM
>>>            select KVM_GENERIC_PRIVATE_MEM
>>> +       select KVM_GENERIC_GMEM_POPULATE
>>>            select HAVE_KVM_ARCH_GMEM_PREPARE
>>>            select HAVE_KVM_ARCH_GMEM_INVALIDATE
>>>            help
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 755b09dcafce..359baaae5e9f 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>>>     int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>>> int max_order);
>>>     #endif
>>>
>>> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
>>> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>>>     /**
>>>      * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>>>      *
>>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>>> index 49df4e32bff7..9b37ca009a22 100644
>>> --- a/virt/kvm/Kconfig
>>> +++ b/virt/kvm/Kconfig
>>> @@ -121,6 +121,10 @@ config KVM_GENERIC_PRIVATE_MEM
>>>            select KVM_GMEM
>>>            bool
>>>
>>> +config KVM_GENERIC_GMEM_POPULATE
>>> +       bool
>>> +       depends on KVM_GMEM && KVM_GENERIC_MEMORY_ATTRIBUTES
>>> +
>>>     config HAVE_KVM_ARCH_GMEM_PREPARE
>>>            bool
>>>            depends on KVM_GMEM
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index b2aa6bf24d3a..befea51bbc75 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct
>>> kvm_memory_slot *slot,
>>>     }
>>>     EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>>>
>>> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
>>> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>>>     long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user
>>> *src, long npages,
>>>                           kvm_gmem_populate_cb post_populate, void *opaque)
>>>     {
>>>
>>>
>>
>> $ git grep KVM_GENERIC_PRIVATE_MEM
>> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
>> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM
>> include/linux/kvm_host.h:#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
>> virt/kvm/Kconfig:config KVM_GENERIC_PRIVATE_MEM
>> virt/kvm/guest_memfd.c:#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
>>
>>
>> Why should we leave KVM_GENERIC_PRIVATE_MEM around when there are no other users?
>>

If we don't want KVM_GENERIC_PRIVATE_MEM, we can further clean it up 
with another patch:

------8<-----------
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 3f87dcaaae83..12afc877c677 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,8 @@ config KVM_X86
         select HAVE_KVM_PM_NOTIFIER if PM
         select KVM_GENERIC_HARDWARE_ENABLING
         select KVM_GENERIC_PRE_FAULT_MEMORY
-       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+       select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
+       select KVM_GMEM if KVM_SW_PROTECTED_VM
         select KVM_WERROR if WERROR

  config KVM
@@ -95,7 +96,7 @@ config KVM_SW_PROTECTED_VM
  config KVM_INTEL
         tristate "KVM for Intel (and compatible) processors support"
         depends on KVM && IA32_FEAT_CTL
-       select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
+       select KVM_GMEM if INTEL_TDX_HOST
         select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
         help
           Provides support for KVM on processors equipped with Intel's VT
@@ -158,7 +159,8 @@ config KVM_AMD_SEV
         depends on KVM_AMD && X86_64
         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
         select ARCH_HAS_CC_PLATFORM
-       select KVM_GENERIC_PRIVATE_MEM
+       select KVM_GMEM
+       select KVM_GENERIC_MEMORY_ATTRIBUTES
         select KVM_GENERIC_GMEM_POPULATE
         select HAVE_KVM_ARCH_GMEM_PREPARE
         select HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 9b37ca009a22..67c626b1a637 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -116,11 +116,6 @@ config KVM_GMEM
         select XARRAY_MULTI
         bool

-config KVM_GENERIC_PRIVATE_MEM
-       select KVM_GENERIC_MEMORY_ATTRIBUTES
-       select KVM_GMEM
-       bool
-
  config KVM_GENERIC_GMEM_POPULATE
         bool
         depends on KVM_GMEM && KVM_GENERIC_MEMORY_ATTRIBUTES

>> @fuad help me out, what am I missing?
> 
> I'm not sure. Splitting it into two patches, one that introduces
> CONFIG_KVM_GENERIC_GMEM_POPULATE followed by one that drops
> CONFIG_KVM_GENERIC_PRIVATE_MEM ends up with the same result.

Not really the same result.

The two-step patches I proposed doesn't produce the below thing of this 
original patch. It doesn't make sense to select 
KVM_GENERIC_GMEM_POPULATE for KVM_SW_PROTECTED_VM from the name.

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..df1fdbb4024b 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,7 @@ config KVM_X86
  	select HAVE_KVM_PM_NOTIFIER if PM
  	select KVM_GENERIC_HARDWARE_ENABLING
  	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
  	select KVM_WERROR if WERROR

> Cheers,
> /fuad
> 
> 
>> --
>> Cheers,
>>
>> David / dhildenb
>>


