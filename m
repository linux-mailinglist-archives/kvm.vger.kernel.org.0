Return-Path: <kvm+bounces-53329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FEFB0FF15
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 05:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78AF11CC706D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 03:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4761DE2CF;
	Thu, 24 Jul 2025 03:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvYmty6n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F343595B;
	Thu, 24 Jul 2025 03:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753326980; cv=none; b=hI9j41Bdy3vk32lvdRFjevtHKwWB4cUGrXN2UwE1rBk5B4BBY+TbCmIp1XDBViAolNptH9Noa6Rh1EBViFVZGuclguYpPOGIfGzrlm31ABL5EqEAQqpnrjZt89B/axyGFUek97gSg5lH7v0tWI3/R8JyFCY3bygNdgpiMZ3ppLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753326980; c=relaxed/simple;
	bh=Bif4n6JVG6wBWb6k9PZmjAci1apCNQebKJ6dRreUqHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jkMwDbFyE3oZaz5FuqdYZvZOWbkrpqJVROtM4Dh3wkQdSEMB72XO31K6ENe5eQO94XZf5gve5lywXfFgYoFX2OgPAhCZ7a2UFCOh0xdlkBU6/Hrpg9vQJ7cKRRepHfLmLbWhkv2oeHONxhA6r3R0c9dON+9nPAGc5+G9fvVxhd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvYmty6n; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753326979; x=1784862979;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Bif4n6JVG6wBWb6k9PZmjAci1apCNQebKJ6dRreUqHc=;
  b=lvYmty6njuXRylmCeKIkxwUatGAbIzuYMFwgGIFlztEhWUkNQ/iB89BS
   jlzOV3RRbbLJ3Q5WF+Rf0NSbG2J8lYpXqlMVm3H+SM0QVuaVHaIz/UqIf
   gaLNJIE/8rB6EN1uzJMjCrLvTkyYfEyYVcRwNAB0SHFi+wS+6iBbkWHv3
   D2v8bZSMp01N+cvi6GyYmXfMF60dOEqIFqSOhPTF6MsdrNQfQecuhDGQ2
   9pQ4IFcxZq0azFb8Zxzgq4tt8ScIJzhIwHj/FwV0zT5MBjZu2oirVZNfM
   qw4HFKmOS5OfGna1nSBj26N4+mJ0e1VbBCkLQFVs6icD00DvdAnnU3kOq
   Q==;
X-CSE-ConnectionGUID: 2hpuD0zESaaJ49m4LO8mig==
X-CSE-MsgGUID: Zy4Lu+F5SFKqOQdB21y8TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55329209"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="55329209"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 20:16:16 -0700
X-CSE-ConnectionGUID: b0YDqmNbT9y46jQ+Rh8BMA==
X-CSE-MsgGUID: nC89alN6SvSXWn/hOklasA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160047898"
Received: from unknown (HELO [10.238.11.128]) ([10.238.11.128])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 20:16:12 -0700
Message-ID: <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
Date: Thu, 24 Jul 2025 11:16:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>,
 Nikolay Borisov <nik.borisov@suse.com>
Cc: Jianxiong Gao <jxgao@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
 jgross@suse.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com,
 Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com>
 <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com> <aIDzBOmjzveLjhmk@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aIDzBOmjzveLjhmk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/23/2025 10:34 PM, Sean Christopherson wrote:
> On Mon, Jul 14, 2025, Nikolay Borisov wrote:
>> On 14.07.25 г. 12:06 ч., Binbin Wu wrote:
>>> On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
>>>> I tested this patch on top of commit 8e690b817e38, however we are
>>>> still experiencing the same failure.
>>>>
>>> I didn't reproduce the issue with QEMU.
>>> After some comparison on how QEMU building the ACPI tables for HPET and
>>> TPM,
>>>
>>> - For HPET, the HPET range is added as Operation Region:
>>>       aml_append(dev,
>>>           aml_operation_region("HPTM", AML_SYSTEM_MEMORY,
>>> aml_int(HPET_BASE),
>>>                                HPET_LEN));
>>>
>>> - For TPM, the range is added as 32-Bit Fixed Memory Range:
>>>       if (TPM_IS_TIS_ISA(tpm_find())) {
>>>           aml_append(crs, aml_memory32_fixed(TPM_TIS_ADDR_BASE,
>>>                      TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
>>>       }
>>>
>>> So, in KVM, the code patch of TPM is different from the trace for HPET in
>>> the patch https://lore.kernel.org/kvm/20250201005048.657470-3-seanjc@google.com/,
>>> HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn't.
> Argh, I was looking at the wrong TPM resource when poking through QEMU.  I peeked
> at TPM_PPI_ADDR_BASE, which gets an AML_SYSTEM_MEMORY entry, not TPM_TIS_ADDR_BASE.
>
> *sigh*
>
> Note, the HPET is also enumerated as a fixed resource:
IIUC, the key differences of aml_memory32_fixed and aml_operation_region:
- aml_memory32_fixed is a resource descriptor that tells the OS about a device's
   address range for configuration or driver purposes.
   It is not meant for ACPI code runtime access, it simply reports the memory
   region to the OS via ACPI resource methods like _CRS.
- aml_operation_region actually defines how AML code can access hardware or
   regions at runtime. Fields, which can be declared within an operation region,
   are then physically mapped to addresses that the AML interpreter will read or
   write during method execution.

For HPET, the method _STA will access the "VEND" and "PRD" fields within the
region. So when probe HPET in acpi_init(), method _STA will be called, and it
needs to map the region before accessing, which triggers ioremap_cache().
(See the call chain below)

>
>      crs = aml_resource_template();
>      aml_append(crs, aml_memory32_fixed(HPET_BASE, HPET_LEN, AML_READ_ONLY));
>      aml_append(dev, aml_name_decl("_CRS", crs));
>
> If I comment out the AML_SYSTEM_MEMORY entry for HPET, the kernel's auto-mapping
> does NOT kick in (the kernel complains about required resources being missing,
> but that's expected).  So I'm pretty sure it's the _lack_ of an AML_SYSTEM_MEMORY
> entry for TPM TIS in QEMU's ACPI tables that make everything happy

Only add an AML_SYSTEM_MEMORY entry as an operation region is not enough, it
also needs an ACPI method to access a field within the region during the ACPI
device probe.

For HPET, I checked the call chain is as following:
acpi_init
   ...
     acpi_bus_get_status
       acpi_bus_get_status_handle
         acpi_evaluate_integer
           acpi_evaluate_object
             acpi_ns_evaluate
               [ACPI_TYPE_METHOD] --> *acpi_ps_execute_method*
                 acpi_ps_parse_aml
                   acpi_ps_parse_loop
                     walk_state->ascending_callback -> acpi_ds_exec_end_op
                       acpi_ds_evaluate_name_path
                         acpi_ex_resolve_to_value
                           acpi_ex_resolve_node_to_value
                             acpi_ex_read_data_from_field
                               acpi_ex_extract_from_field
                                 acpi_ex_field_datum_io
                                   *acpi_ex_access_region*
                                     acpi_ev_address_space_dispatch
acpi_ex_system_memory_space_handler
                                         acpi_os_map_memory
                                           acpi_os_map_iomem
                                             ioremap_cache

>
> I can't for the life of me suss out exactly what Google's ACPI tables will look
> like.  I'll follow-up internally to try and get an answer on that front.

I guess google has defined a ACPI method to access the region for TPM TIS during
ACPI device probe.

>
> In the meantime, can someone who has reproduced the real issue get backtraces to
> confirm or disprove that acpi_os_map_iomem() is trying to map the TPM TIS range
> as WB?  E.g. with something like so:

I tried to add an AML_SYSTEM_MEMORY entry as operation region in the ACPI
table and modify the _STA method to access the region for TPM TIS in QEMU, then
the issue can be reproduced.

diff --git a/hw/tpm/tpm_tis_isa.c b/hw/tpm/tpm_tis_isa.c
index 876cb02cb5..aca2b2993f 100644
--- a/hw/tpm/tpm_tis_isa.c
+++ b/hw/tpm/tpm_tis_isa.c
@@ -143,6 +143,9 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
      Aml *dev, *crs;
      TPMStateISA *isadev = TPM_TIS_ISA(adev);
      TPMIf *ti = TPM_IF(isadev);
+    Aml *field;
+    Aml *method;
+    Aml *test = aml_local(0);

      dev = aml_device("TPM");
      if (tpm_tis_isa_get_tpm_version(ti) == TPM_VERSION_2_0) {
@@ -152,7 +155,19 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev, Aml *scope)
          aml_append(dev, aml_name_decl("_HID", aml_eisaid("PNP0C31")));
      }
      aml_append(dev, aml_name_decl("_UID", aml_int(1)));
-    aml_append(dev, aml_name_decl("_STA", aml_int(0xF)));
+
+    aml_append(dev, aml_operation_region("TPMM", AML_SYSTEM_MEMORY, aml_int(TPM_TIS_ADDR_BASE),
+                         TPM_TIS_ADDR_SIZE));
+
+    field = aml_field("TPMM", AML_DWORD_ACC, AML_LOCK, AML_PRESERVE);
+    aml_append(field, aml_named_field("TEST", 32));
+    aml_append(dev, field);
+
+    method = aml_method("_STA", 0, AML_NOTSERIALIZED);
+    aml_append(method, aml_store(aml_name("TEST"), test));
+    aml_append(method, aml_return(aml_int(0xF)));
+    aml_append(dev, method);

>
> diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> index 2e7923844afe..6c3c40909ef9 100644
> --- a/arch/x86/mm/pat/memtype.c
> +++ b/arch/x86/mm/pat/memtype.c
> @@ -528,6 +528,9 @@ int memtype_reserve(u64 start, u64 end, enum page_cache_mode req_type,
>   
>          start = sanitize_phys(start);
>   
> +       WARN(start == 0xFED40000,
> +            "Mapping TPM TIS with req_type = %u\n", req_type);
> +
>          /*
>           * The end address passed into this function is exclusive, but
>           * sanitize_phys() expects an inclusive address.
> ---


