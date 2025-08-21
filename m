Return-Path: <kvm+bounces-55256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD87B2ED8C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 07:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E6371C8458A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADD62BEC28;
	Thu, 21 Aug 2025 05:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OC3rk993"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A11D49620;
	Thu, 21 Aug 2025 05:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755753845; cv=none; b=Af8fjuzi0kFk1JL+XsDLST8tgyAUXOM09D+Hu/p5GIHL1m1cHJDkHqNRw4PgRgjURN2sRucuC0bBdCKrIQYDRkMMOp2nS5VYVyhbn4CdyltR32GS5NcvYwNJ7H0EDwtYeGQqDRn/DcpJ4+U8LvpUm8pGMKOsnon0IIiZgM4FFKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755753845; c=relaxed/simple;
	bh=aRxjhvMv7K3+zEEb1KjJOi47ZdXTCG7tkrSzxnqsbB0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=j+HALP17yzBMpj4cbFMVUO4jSEoCjNZmx3zlqAQfW+5V3uyu3nikNcVG/OXouq1gWsE39VENryieyslgrVmbRgN4AEU9irP5jt2i343z+CERJ1pbyJHVzx2iV+7esNArMfkyoiq9WcdtNrYCB6fmEYw9LKzlOWDmFa4QISRKKHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OC3rk993; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755753844; x=1787289844;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=aRxjhvMv7K3+zEEb1KjJOi47ZdXTCG7tkrSzxnqsbB0=;
  b=OC3rk993Jw+NfWUKtXKmhMevXmaDK5aAYsFkLojJ4uAjvUPaDA5CSBxH
   xCBvXEveLW/ybTivWByvK96L0cVruJyTUGxnXOEqdAYVmSi25anQ3v9Oj
   0TBqrgV0SuURw/Vr1VhVEEYuRdTwbOGN8VA6h1CXSzb+Wdo0JlXvcFAxQ
   GTJdknzM8W4LyDZVZl8yrRbvmxzw1au/vJJ7dRE6Dq+VcyTYKTGfj3nMR
   3gOkP7o4NtPaMsia7AkFELNZJPRy7w8tQrO/lcf9/zbBMRo31w4ERcIQs
   zx8SKm3VHjx7O1Nn7c2h43IJ7bszfi1ssvYQk5dJTQlfMecbJmSh91jR1
   Q==;
X-CSE-ConnectionGUID: zuNrf0PgSkWtZGkkhd0+5w==
X-CSE-MsgGUID: B/jPkF+bRT6hCx3XzPEerQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58101254"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="58101254"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 22:24:03 -0700
X-CSE-ConnectionGUID: dSauImomRY+Qa3SbBJGH+A==
X-CSE-MsgGUID: Q86G0S2DTVKRycJnMGuFEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="168572953"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 22:23:58 -0700
Message-ID: <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
Date: Thu, 21 Aug 2025 13:23:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com> <aIDzBOmjzveLjhmk@google.com>
 <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com>
 <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com>
 <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
 <aKYMQP5AEC2RkOvi@google.com>
 <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
Content-Language: en-US
In-Reply-To: <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/21/2025 11:30 AM, Binbin Wu wrote:
>
>
> On 8/21/2025 1:56 AM, Sean Christopherson wrote:
>> On Wed, Aug 20, 2025, Binbin Wu wrote:
[...]
>>> Hi Sean,
>>>
>>> Since guest_force_mtrr_state() also supports to force MTRR variable ranges,
>>> I am wondering if we could use guest_force_mtrr_state() to set the legacy PCI
>>> hole range as UC?
>>>
>>> Is it less hacky?
>> Oh!  That's a way better idea than my hack.  I missed that the kernel would still
>> consult MTRRs.
>>
>> Compile tested only, but something like this?
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 8ae750cde0c6..45c8871cdda1 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -933,6 +933,13 @@ static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
>>     static void __init kvm_init_platform(void)
>>   {
>> +       u64 tolud = e820__end_of_low_ram_pfn() << PAGE_SHIFT;
>> +       struct mtrr_var_range pci_hole = {
>> +               .base_lo = tolud | X86_MEMTYPE_UC,
>> +               .mask_lo = (u32)(~(SZ_4G - tolud - 1)) | BIT(11),
>> +               .mask_hi = (BIT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
>> +       };
>> +
>
> This value of tolud  may not meet the range size and alignment requirement for
> variable MTRR.
>
> Variable MTRR has requirement for range size and alignment:
> For ranges greater than 4 KBytes, each range must be of length 2^n and its base
> address must be aligned on a 2^n boundary, where n is a value equal to or
> greater than 12. The base-address alignment value cannot be less than its length.

Wait, Linux kernel converts MTRR register values to MTRR state (base and size) and
cache it for later lookups (refer to map_add_var()). I.e., in Linux kernel,
only the cached state will be used.

These MTRR register values are never programmed when using
guest_force_mtrr_state() , so even the values doesn't meet the
requirement from hardware perspective, Linux kernel can still get the right base and size.

No bothering to force the base and size alignment.
But a comment would be helpful.
Also, BIT(11) could be replaced by MTRR_PHYSMASK_V.

How about:
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 90097df4eafd..a9582ffc3088 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -934,9 +934,15 @@ static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
  static void __init kvm_init_platform(void)
  {
         u64 tolud = e820__end_of_low_ram_pfn() << PAGE_SHIFT;
+       /*
+        * The range's base address and size may not meet the alignment
+        * requirement for variable MTRR. However, Linux guest never
+        * programs MTRRs when forcing guest MTRR state, no bothering to
+        * enforce the base and range size alignment.
+        */
         struct mtrr_var_range pci_hole = {
                 .base_lo = tolud | X86_MEMTYPE_UC,
-               .mask_lo = (u32)(~(SZ_4G - tolud - 1)) | BIT(11),
+               .mask_lo = (u32)(~(SZ_4G - tolud - 1)) | MTRR_PHYSMASK_V,
                 .mask_hi = (BIT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
         };


I tested it in my setup, it can fix the issue of TPM driver failure with the
modified ACPI table for TPM in QEMU.


Hi Vishal,
Could you test it with google's VMM?


>
> In my setup, the value of tolud is 0x7FF7C000, it requires 3 variable MTRRs to
> meet the requirement, i.e.,
> - 7FF7 C000  ~   7FF8 0000
> - 7FF8 0000  ~   8000 0000
> - 8000 0000  ~ 1 0000 0000
>
> I checks the implementation in EDK2, in order to fit the legacy PCI hole into
> one variable MTRR, it has some assumption to truncate the size and round up the
> base address in PlatformQemuUc32BaseInitialization():
>     ...
>     ASSERT (
>       PlatformInfoHob->HostBridgeDevId == INTEL_Q35_MCH_DEVICE_ID ||
>       PlatformInfoHob->HostBridgeDevId == INTEL_82441_DEVICE_ID
>       );
>     ...
>     //
>     // Start with the [LowerMemorySize, 4GB) range. Make sure one
>     // variable MTRR suffices by truncating the size to a whole power of two,
>     // while keeping the end affixed to 4GB. This will round the base up.
>     //
>     PlatformInfoHob->Uc32Size = GetPowerOfTwo32 ((UINT32)(SIZE_4GB - PlatformInfoHob->LowMemory));
>     PlatformInfoHob->Uc32Base = (UINT32)(SIZE_4GB - PlatformInfoHob->Uc32Size);
>     //
>     // Assuming that LowerMemorySize is at least 1 byte, Uc32Size is at most 2GB.
>     // Therefore Uc32Base is at least 2GB.
>     //
>     ASSERT (PlatformInfoHob->Uc32Base >= BASE_2GB);
>
> I am not sure if KVM can do such assumption.
> Otherwise, KVM needs to calculate the ranges to meet the requirement. :(
>
>
>>          if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
>> kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
>>                  unsigned long nr_pages;
>> @@ -982,8 +989,12 @@ static void __init kvm_init_platform(void)
>>          kvmclock_init();
>>          x86_platform.apic_post_init = kvm_apic_init;
>>   -       /* Set WB as the default cache mode for SEV-SNP and TDX */
>> -       guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
>> +       /*
>> +        * Set WB as the default cache mode for SEV-SNP and TDX, with a single
>> +        * UC range for the legacy PCI hole, e.g. so that devices that expect
>> +        * to get UC/WC mappings don't get surprised with WB.
>> +        */
>> +       guest_force_mtrr_state(&pci_hole, 1, MTRR_TYPE_WRBACK);
>>   }
>>     #if defined(CONFIG_AMD_MEM_ENCRYPT)
>
>


