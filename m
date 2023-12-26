Return-Path: <kvm+bounces-5253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D015681E5C9
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 08:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3AF11C21CBB
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 07:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695D44CB20;
	Tue, 26 Dec 2023 07:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MXBTihth"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000034C625
	for <kvm@vger.kernel.org>; Tue, 26 Dec 2023 07:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703577045; x=1735113045;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DA9Wp8qt9DF3LYe+8KG9X1qCIDDb03+8OnjJ5vSMc2I=;
  b=MXBTihthKpnd7A5YCseiq4B2l6KI3iB3fkWMaPC1S+dA70P9UNy1RgJB
   sFFH+YVQVwx2FtaICkiR+zSbdEk7/wa4JsIYCQpFkaq99KIf3wB9yfQKZ
   0X5IardNCCRm+NjLdA90BA4KoGNR9FNsLb1D+exnDbRwNvNkgfeT1GeTz
   qq499aJG7NU83VD4O6EKhZmtkZJINn9xb/ukV7JO5G7nEs3v78pMhZ49T
   SPxXVJZCLbw4x98zKQgt1NqxjVu3cXq5qJShJtmzaioEzC/SYGOJaFex+
   zN52btQyz11a0H2mARJFlnjUl7Vst4OzyiHzlhhE4y+Q63xtXZWakF5MI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="462755564"
X-IronPort-AV: E=Sophos;i="6.04,304,1695711600"; 
   d="scan'208";a="462755564"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 23:50:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="812198500"
X-IronPort-AV: E=Sophos;i="6.04,304,1695711600"; 
   d="scan'208";a="812198500"
Received: from qianwen-mobl1.ccr.corp.intel.com (HELO [10.93.21.67]) ([10.93.21.67])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 23:50:39 -0800
Message-ID: <1399b8c9-4f63-0b2d-c078-66c00796bea5@intel.com>
Date: Tue, 26 Dec 2023 15:50:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101
 Thunderbird/109.0
Subject: Re: [kvm-unit-tests RFC v2 02/18] x86 TDX: Add support functions for
 TDX framework
Content-Language: en-US
To: Zeng Guang <guang.zeng@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "nikos.nikoleris@arm.com" <nikos.nikoleris@arm.com>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
 "Zhang, Yu C" <yu.c.zhang@intel.com>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Qiang, Chenyi" <chenyi.qiang@intel.com>,
 "ricarkol@google.com" <ricarkol@google.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
 <20231218072247.2573516-3-qian.wen@intel.com>
 <576d65f4-695c-406f-bff7-4b62473c68dd@intel.com>
From: "Wen, Qian" <qian.wen@intel.com>
In-Reply-To: <576d65f4-695c-406f-bff7-4b62473c68dd@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 12/26/2023 3:44 PM, Zeng Guang wrote:
> 
> On 12/18/2023 3:22 PM, Qian Wen wrote:
>> From: Zhenzhong Duan <zhenzhong.duan@intel.com>
>>
>> Detect TDX during at start of efi setup. And define a dummy is_tdx_guest()
>> if CONFIG_EFI is undefined as this function will be used globally in the
>> future.
>>
>> In addition, it is fine to use the print function even before the #VE
>> handler of the unit test has complete configuration.
>>
>> TDVF provides the default #VE exception handler, which will convert some
>> of the forbidden instructions to TDCALL [TDG.VP.VMCALL] <INSTRUCTION>,
>> e.g., IO => TDCALL [TDG.VP.VMCALL] <Instruction.IO> (see “10 Exception
>> Handling” in TDVF spec [1]).
>>
>> [1] TDVF spec: https://cdrdv2.intel.com/v1/dl/getContent/733585
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>> Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
>> Link: https://lore.kernel.org/r/20220303071907.650203-2-zhenzhong.duan@intel.com
>> Co-developed-by: Qian Wen <qian.wen@intel.com>
>> Signed-off-by: Qian Wen <qian.wen@intel.com>
>> ---
>>   lib/x86/asm/setup.h |  1 +
>>   lib/x86/setup.c     |  6 ++++++
>>   lib/x86/tdx.c       | 39 +++++++++++++++++++++++++++++++++++++++
>>   lib/x86/tdx.h       |  9 +++++++++
>>   4 files changed, 55 insertions(+)
>>
>> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
>> index 458eac85..1deed1cd 100644
>> --- a/lib/x86/asm/setup.h
>> +++ b/lib/x86/asm/setup.h
>> @@ -15,6 +15,7 @@ unsigned long setup_tss(u8 *stacktop);
>>   efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>>   void setup_5level_page_table(void);
>>   #endif /* CONFIG_EFI */
>> +#include "x86/tdx.h"
>>     void save_id(void);
>>   void bsp_rest_init(void);
>> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
>> index d509a248..97d9e896 100644
>> --- a/lib/x86/setup.c
>> +++ b/lib/x86/setup.c
>> @@ -308,6 +308,12 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>>       efi_status_t status;
>>       const char *phase;
>>   +    status = setup_tdx();
>> +    if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
>> +        printf("INTEL TDX setup failed, error = 0x%lx\n", status);
>> +        return status;
>> +    }
>> +
>>       status = setup_memory_allocator(efi_bootinfo);
>>       if (status != EFI_SUCCESS) {
>>           printf("Failed to set up memory allocator: ");
>> diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
>> index 1f1abeff..a01bfcbb 100644
>> --- a/lib/x86/tdx.c
>> +++ b/lib/x86/tdx.c
>> @@ -276,3 +276,42 @@ static int handle_io(struct ex_regs *regs, struct ve_info *ve)
>>         return ve_instr_len(ve);
>>   }
>> +
>> +bool is_tdx_guest(void)
>> +{
>> +    static int tdx_guest = -1;
>> +    struct cpuid c;
>> +    u32 sig[3];
>> +
>> +    if (tdx_guest >= 0)
>> +        goto done;
>> +
>> +    if (cpuid(0).a < TDX_CPUID_LEAF_ID) {
>> +        tdx_guest = 0;
>> +        goto done;
>> +    }
>> +
>> +    c = cpuid(TDX_CPUID_LEAF_ID);
>> +    sig[0] = c.b;
>> +    sig[1] = c.d;
>> +    sig[2] = c.c;
>> +
>> +    tdx_guest = !memcmp(TDX_IDENT, sig, sizeof(sig));
>> +
>> +done:
>> +    return !!tdx_guest;
>> +}
>> +
>> +efi_status_t setup_tdx(void)
>> +{
>> +    if (!is_tdx_guest())
>> +        return EFI_UNSUPPORTED;
>> +
>> +    /* The printf can work here. Since TDVF default exception handler
> Comments need start at another new line with leading asterisk.

Ooh, good catch, thanks!

Thanks,
Qian

>> +     * can handle the #VE caused by IO read/write during printf() before
>> +     * finalizing configuration of the unit test's #VE handler.
>> +     */
>> +    printf("Initialized TDX.\n");
>> +
>> +    return EFI_SUCCESS;
>> +}
>> diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
>> index cf0fc917..45350b70 100644
>> --- a/lib/x86/tdx.h
>> +++ b/lib/x86/tdx.h
>> @@ -21,6 +21,9 @@
>>     #define TDX_HYPERCALL_STANDARD        0
>>   +#define TDX_CPUID_LEAF_ID    0x21
>> +#define TDX_IDENT        "IntelTDX    "
>> +
>>   /* TDX module Call Leaf IDs */
>>   #define TDG_VP_VMCALL            0
>>   @@ -136,6 +139,12 @@ struct ve_info {
>>       u32 instr_info;
>>   };
>>   +bool is_tdx_guest(void);
>> +efi_status_t setup_tdx(void);
>> +
>> +#else
>> +inline bool is_tdx_guest(void) { return false; }
>> +
>>   #endif /* CONFIG_EFI */
>>     #endif /* _ASM_X86_TDX_H */
> 

