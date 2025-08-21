Return-Path: <kvm+bounces-55232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1332FB2EBF2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2438D1BC7345
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB662E6126;
	Thu, 21 Aug 2025 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EolSgQFA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E922E5B03;
	Thu, 21 Aug 2025 03:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755747036; cv=none; b=u9C4WYoM/GX4hS1BLOXz+CIoc2oxugBiv4rnu58QIs84kXgvMVZU4Lrcj+ZpLCEk8rad/8BSqw0JlYvqASKZg0FVAizEmuCSIUqFFKVX8RbTzSJfsNAY+i+NejX+c8jwd+0GSYB4FPR3bSNvmHb8V1RAt2jupSQm+bxejfmVe68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755747036; c=relaxed/simple;
	bh=hGZnT5MfWeTZd2SOXfqoQAwccyPDnsuXk0ZwAoQRF5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YhxPuALF/qFPENXwJhnTCRW6baeLcDnPAOZqNURiJxe87NJRwuMFsbCJT8eOiwBGu+QcNmiiV9Gb58W5B1fjajGVOeSoCj/Fn+rPmjkO1fraH659SvwJbGuohFL0h8UxSaBhDM3QUXDLBPodYLt4O0MbA1voZmBnoB2k4PdEXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EolSgQFA; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755747035; x=1787283035;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hGZnT5MfWeTZd2SOXfqoQAwccyPDnsuXk0ZwAoQRF5c=;
  b=EolSgQFAViq1murkZ7iKgLAvrKyi7WanJgCPODQstOMuMHU8p94uCJL/
   uFhLjeeV9tdhAdgKnOlVTip4LVZO51JDPYesOQnuVNmrJV+2emLPHWXT8
   1+GNXj8nVjfcfK77+iiAmdSxanPTjPHDpyV3Na9KSqKnXj2mIqr/cJuuq
   wVKsz4uoQ4cA91aKfjqSSGguRAOvQuk02F7Ral/SXeC81QCMz7XygLJyL
   JtWd1pmXZ3qA3H5erqEFuQqPECxssnLemNl8tOC5hfgJZiUmd0XSYggqE
   L9k8eHS41GFRFoBMrydjW7w+VPB/y4mv3QOpdbl6w5SgbNh67al67OxYe
   Q==;
X-CSE-ConnectionGUID: TyPb6Gx2TwShSA0LRbBh/g==
X-CSE-MsgGUID: Dvr5pBsrRfWSQTGK7eormQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61854988"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="61854988"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 20:30:34 -0700
X-CSE-ConnectionGUID: BjYSIxRBS9S7SxhZiPa1Gg==
X-CSE-MsgGUID: Q4gvv4UxT6mmQBCIdPa+0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="167806701"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 20:30:29 -0700
Message-ID: <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
Date: Thu, 21 Aug 2025 11:30:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
 Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>,
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
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aKYMQP5AEC2RkOvi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/21/2025 1:56 AM, Sean Christopherson wrote:
> On Wed, Aug 20, 2025, Binbin Wu wrote:
>> On 8/20/2025 6:03 PM, Binbin Wu wrote:
>>>>>> Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kernel's
>>>>>> ACPI driver supposed to know that some ranges of SystemMemory must be mapped UC?
>>> Checked with Jiewen offline.
>>>
>>> He didn't think there was an existing interface to tell the OS to map a
>>> OperationRegion of SystemMemory as UC via the ACPI table. He thought the
>>> OS/ACPI driver still needed to rely on MTRRs for the hint before there was an
>>> alternative way.
>>>
>>>>> According to the ACPI spec 6.6, an operation region of SystemMemory has no
>>>>> interface to specify the cacheable attribute.
>>>>>
>>>>> One solution could be using MTRRs to communicate the memory attribute of legacy
>>>>> PCI hole to the kernel.
> So IIUC, there are no bugs anywhere, just a gap in specs that has been hidden
> until now :-(
>
>>>>> But during the PUCK meeting last week, Sean mentioned
>>>>> that "long-term, firmware should not be using MTRRs to communicate anything to
>>>>> the kernel." So this solution is not preferred.
>>>>>
>>>>> If not MTRRs, there should be an alternative way to do the job.
>>>>> 1. ACPI table
>>>>>       According to the ACPI spec, neither operation region nor 32-Bit Fixed Memory
>>>>>       Range Descriptor can specify the cacheable attribute.
>>>>>       "Address Space Resource Descriptors" could be used to describe a memory range
>>>>>       and the they can specify the cacheable attribute via "Type Specific Flags".
>>>>>       One of the Address Space Resource Descriptors could be added to the ACPI
>>>>>       table as a hint when the kernel do the mapping for operation region.
>>>>>       (There is "System Physical Address (SPA) Range Structure", which also can
>>>>>       specify the cacheable attribute. But it's should be used for NVDIMMs.)
>>>>> 2. EFI memory map descriptor
>>>>>       EFI memory descriptor can specify the cacheable attribute. Firmware can add
>>>>>       a EFI memory descriptor for the TPM TIS device as a hint when the kernel do
>>>>>       the mapping for operation region.
>>>>>
>>>>> Operation region of SystemMemory is still needed if a "Control Method" of APCI
>>>>> needs to access a field, e.g., the method _STA. Checking another descriptor for
>>>>> cacheable attribute, either "Address Space Resource Descriptor" or "EFI memory
>>>>> map descriptor" during the ACPI code doing the mapping for operation region
>>>>> makes the code complicated.
>>>>>
>>>>> Another thing is if long-term firmware should not be using MTRRs to to
>>>>> communicate anything to the kernel. It seems it's safer to use ioremap() instead
>>>>> of ioremap_cache() for MMIO resource when the kernel do the mapping for the
>>>>> operation region access?
>>>>>
>>>> Would it work if instead of doubling down on declaring the low memory
>>>> above TOLUD as WB, guest kernel reserves the range as uncacheable by
>>>> default i.e. effectively simulating a ioremap before ACPI tries to map
>>>> the memory as WB?
>>> It seems as hacky as this patch set?
>>>
>>>
>> Hi Sean,
>>
>> Since guest_force_mtrr_state() also supports to force MTRR variable ranges,
>> I am wondering if we could use guest_force_mtrr_state() to set the legacy PCI
>> hole range as UC?
>>
>> Is it less hacky?
> Oh!  That's a way better idea than my hack.  I missed that the kernel would still
> consult MTRRs.
>
> Compile tested only, but something like this?
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8ae750cde0c6..45c8871cdda1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -933,6 +933,13 @@ static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
>   
>   static void __init kvm_init_platform(void)
>   {
> +       u64 tolud = e820__end_of_low_ram_pfn() << PAGE_SHIFT;
> +       struct mtrr_var_range pci_hole = {
> +               .base_lo = tolud | X86_MEMTYPE_UC,
> +               .mask_lo = (u32)(~(SZ_4G - tolud - 1)) | BIT(11),
> +               .mask_hi = (BIT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
> +       };
> +

This value of tolud  may not meet the range size and alignment requirement for
variable MTRR.

Variable MTRR has requirement for range size and alignment:
For ranges greater than 4 KBytes, each range must be of length 2^n and its base
address must be aligned on a 2^n boundary, where n is a value equal to or
greater than 12. The base-address alignment value cannot be less than its length.

In my setup, the value of tolud is 0x7FF7C000, it requires 3 variable MTRRs to
meet the requirement, i.e.,
- 7FF7 C000  ~   7FF8 0000
- 7FF8 0000  ~   8000 0000
- 8000 0000  ~ 1 0000 0000

I checks the implementation in EDK2, in order to fit the legacy PCI hole into
one variable MTRR, it has some assumption to truncate the size and round up the
base address in PlatformQemuUc32BaseInitialization():
     ...
     ASSERT (
       PlatformInfoHob->HostBridgeDevId == INTEL_Q35_MCH_DEVICE_ID ||
       PlatformInfoHob->HostBridgeDevId == INTEL_82441_DEVICE_ID
       );
     ...
     //
     // Start with the [LowerMemorySize, 4GB) range. Make sure one
     // variable MTRR suffices by truncating the size to a whole power of two,
     // while keeping the end affixed to 4GB. This will round the base up.
     //
     PlatformInfoHob->Uc32Size = GetPowerOfTwo32 ((UINT32)(SIZE_4GB - PlatformInfoHob->LowMemory));
     PlatformInfoHob->Uc32Base = (UINT32)(SIZE_4GB - PlatformInfoHob->Uc32Size);
     //
     // Assuming that LowerMemorySize is at least 1 byte, Uc32Size is at most 2GB.
     // Therefore Uc32Base is at least 2GB.
     //
     ASSERT (PlatformInfoHob->Uc32Base >= BASE_2GB);

I am not sure if KVM can do such assumption.
Otherwise, KVM needs to calculate the ranges to meet the requirement. :(


>          if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
>              kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
>                  unsigned long nr_pages;
> @@ -982,8 +989,12 @@ static void __init kvm_init_platform(void)
>          kvmclock_init();
>          x86_platform.apic_post_init = kvm_apic_init;
>   
> -       /* Set WB as the default cache mode for SEV-SNP and TDX */
> -       guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
> +       /*
> +        * Set WB as the default cache mode for SEV-SNP and TDX, with a single
> +        * UC range for the legacy PCI hole, e.g. so that devices that expect
> +        * to get UC/WC mappings don't get surprised with WB.
> +        */
> +       guest_force_mtrr_state(&pci_hole, 1, MTRR_TYPE_WRBACK);
>   }
>   
>   #if defined(CONFIG_AMD_MEM_ENCRYPT)


