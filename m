Return-Path: <kvm+bounces-5252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA46B81E5C5
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 08:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95DBE282475
	for <lists+kvm@lfdr.de>; Tue, 26 Dec 2023 07:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3917D4C63D;
	Tue, 26 Dec 2023 07:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+g21F7F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063F74C60B
	for <kvm@vger.kernel.org>; Tue, 26 Dec 2023 07:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703576708; x=1735112708;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N3kUXU7D07h1av4ygtV0lKXYznT5bQQW1nnXX6lvIus=;
  b=X+g21F7Fb5yva6i/8XaEAgYtDyAJCwFAKh7hL7YDAlhcG3JxI8NeAKbX
   ZbhPRWdckK7rUHwTz+Jmxe2SA0xXFIAALml7ebYbELsBZEYrnqORpau/J
   fkZiYmWZ6C7mCe63NFEShYUq/5aELD+6EKrQg+UH6JTZQjDc+ILvMY81/
   A3Ke6RrMcFJJmC3KmfRUsmiipWTqf82eo4oy/C9xDiLYgqBQBt4oAE6li
   g966/CxZFYJTsj9BoKAzu/k+EtMKX77WLqkWu4MXUi8h4+N5yVoxMunV1
   sNeiedGNCXvedbszG2tkr5JQWZPN6Al5xref459bcGfTEAl52IcGCpZol
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="460658506"
X-IronPort-AV: E=Sophos;i="6.04,304,1695711600"; 
   d="scan'208";a="460658506"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 23:45:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10934"; a="806826832"
X-IronPort-AV: E=Sophos;i="6.04,304,1695711600"; 
   d="scan'208";a="806826832"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.93.2.174]) ([10.93.2.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2023 23:45:03 -0800
Message-ID: <576d65f4-695c-406f-bff7-4b62473c68dd@intel.com>
Date: Tue, 26 Dec 2023 15:44:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests RFC v2 02/18] x86 TDX: Add support functions for
 TDX framework
To: Qian Wen <qian.wen@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
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
Content-Language: en-US
From: Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20231218072247.2573516-3-qian.wen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/18/2023 3:22 PM, Qian Wen wrote:
> From: Zhenzhong Duan <zhenzhong.duan@intel.com>
>
> Detect TDX during at start of efi setup. And define a dummy is_tdx_guest()
> if CONFIG_EFI is undefined as this function will be used globally in the
> future.
>
> In addition, it is fine to use the print function even before the #VE
> handler of the unit test has complete configuration.
>
> TDVF provides the default #VE exception handler, which will convert some
> of the forbidden instructions to TDCALL [TDG.VP.VMCALL] <INSTRUCTION>,
> e.g., IO => TDCALL [TDG.VP.VMCALL] <Instruction.IO> (see “10 Exception
> Handling” in TDVF spec [1]).
>
> [1] TDVF spec: https://cdrdv2.intel.com/v1/dl/getContent/733585
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
> Link: https://lore.kernel.org/r/20220303071907.650203-2-zhenzhong.duan@intel.com
> Co-developed-by: Qian Wen <qian.wen@intel.com>
> Signed-off-by: Qian Wen <qian.wen@intel.com>
> ---
>   lib/x86/asm/setup.h |  1 +
>   lib/x86/setup.c     |  6 ++++++
>   lib/x86/tdx.c       | 39 +++++++++++++++++++++++++++++++++++++++
>   lib/x86/tdx.h       |  9 +++++++++
>   4 files changed, 55 insertions(+)
>
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index 458eac85..1deed1cd 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -15,6 +15,7 @@ unsigned long setup_tss(u8 *stacktop);
>   efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>   void setup_5level_page_table(void);
>   #endif /* CONFIG_EFI */
> +#include "x86/tdx.h"
>   
>   void save_id(void);
>   void bsp_rest_init(void);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index d509a248..97d9e896 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -308,6 +308,12 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>   	efi_status_t status;
>   	const char *phase;
>   
> +	status = setup_tdx();
> +	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
> +		printf("INTEL TDX setup failed, error = 0x%lx\n", status);
> +		return status;
> +	}
> +
>   	status = setup_memory_allocator(efi_bootinfo);
>   	if (status != EFI_SUCCESS) {
>   		printf("Failed to set up memory allocator: ");
> diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
> index 1f1abeff..a01bfcbb 100644
> --- a/lib/x86/tdx.c
> +++ b/lib/x86/tdx.c
> @@ -276,3 +276,42 @@ static int handle_io(struct ex_regs *regs, struct ve_info *ve)
>   
>   	return ve_instr_len(ve);
>   }
> +
> +bool is_tdx_guest(void)
> +{
> +	static int tdx_guest = -1;
> +	struct cpuid c;
> +	u32 sig[3];
> +
> +	if (tdx_guest >= 0)
> +		goto done;
> +
> +	if (cpuid(0).a < TDX_CPUID_LEAF_ID) {
> +		tdx_guest = 0;
> +		goto done;
> +	}
> +
> +	c = cpuid(TDX_CPUID_LEAF_ID);
> +	sig[0] = c.b;
> +	sig[1] = c.d;
> +	sig[2] = c.c;
> +
> +	tdx_guest = !memcmp(TDX_IDENT, sig, sizeof(sig));
> +
> +done:
> +	return !!tdx_guest;
> +}
> +
> +efi_status_t setup_tdx(void)
> +{
> +	if (!is_tdx_guest())
> +		return EFI_UNSUPPORTED;
> +
> +	/* The printf can work here. Since TDVF default exception handler
Comments need start at another new line with leading asterisk.
> +	 * can handle the #VE caused by IO read/write during printf() before
> +	 * finalizing configuration of the unit test's #VE handler.
> +	 */
> +	printf("Initialized TDX.\n");
> +
> +	return EFI_SUCCESS;
> +}
> diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
> index cf0fc917..45350b70 100644
> --- a/lib/x86/tdx.h
> +++ b/lib/x86/tdx.h
> @@ -21,6 +21,9 @@
>   
>   #define TDX_HYPERCALL_STANDARD		0
>   
> +#define TDX_CPUID_LEAF_ID	0x21
> +#define TDX_IDENT		"IntelTDX    "
> +
>   /* TDX module Call Leaf IDs */
>   #define TDG_VP_VMCALL			0
>   
> @@ -136,6 +139,12 @@ struct ve_info {
>   	u32 instr_info;
>   };
>   
> +bool is_tdx_guest(void);
> +efi_status_t setup_tdx(void);
> +
> +#else
> +inline bool is_tdx_guest(void) { return false; }
> +
>   #endif /* CONFIG_EFI */
>   
>   #endif /* _ASM_X86_TDX_H */

