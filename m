Return-Path: <kvm+bounces-3664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6FE8067BB
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 07:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF128282314
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 06:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DBB11C9A;
	Wed,  6 Dec 2023 06:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QFXp1wcW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB211B5;
	Tue,  5 Dec 2023 22:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701845285; x=1733381285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=31X1TWrsJxin+f+eEFIJ23ndoGZuq9yKYHwAu/cTynM=;
  b=QFXp1wcWYYCPxISuORclhkhCIQ2CwSGqLnuab7fEa8sftyYI/IIgm5Dn
   A22BN736/SNM6VnbT5hmS8gVy8G7WDQ14KssSDM7oXu61Cwp+ZrFUrxii
   GtxRqKRPIisODGvUxL0ip2GGdYTfXOzEyRBdlwGabgHy65m8DnAbXSLqG
   NrUm7t7ppKVSqLKztH6l0j7Rhb1xv0s4hfG2w2/d3C502blzWvyWLuwff
   FXpXdRMGE2G3D5t05EbPBfsDxEsSKKUOVZQvEmitHb0At/ptdXe+MOqFZ
   O17wWLdHzwYIySTcp7tpnqYoVvyle5Qk6cDA0OBE/hEh/hcg7DnWO9uL/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="458338509"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="458338509"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 22:48:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="774895857"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="774895857"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 22:48:01 -0800
Message-ID: <dc599704-5e24-4cbd-8b47-48049b83b01f@linux.intel.com>
Date: Wed, 6 Dec 2023 14:47:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 013/116] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <c81e63be8ecaceb5df49d6355cc091c7966afe4e.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c81e63be8ecaceb5df49d6355cc091c7966afe4e.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add helper functions to print out errors from the TDX module in a uniform
> manner.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Makefile        |  2 +-
>   arch/x86/kvm/vmx/tdx_error.c | 20 ++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx_ops.h   |  5 +++++
>   3 files changed, 26 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/kvm/vmx/tdx_error.c
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 4b01ab842ab7..e3354b784e10 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -25,7 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
>   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>   			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> -kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/tdx_error.o
>   
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
>   			   svm/sev.o svm/hyperv.o
> diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
> new file mode 100644
> index 000000000000..d083c79a2331
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_error.c
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* functions to record TDX SEAMCALL error */
> +
> +#include <linux/kernel.h>
> +#include <linux/bug.h>
> +
> +#include "tdx_ops.h"
> +
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
> +{
> +	if (!out) {
> +		pr_err_ratelimited("SEAMCALL[%lld] failed: 0x%llx\n",
> +				   op, error_code);
> +		return;
> +	}
> +
> +#define MSG	"SEAMCALL[%lld] failed: 0x%llx RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n"
> +	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
> +			   out->r9, out->r10, out->r11);
> +}
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index a55977626ae3..c9f74b2400a7 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -10,6 +10,7 @@
>   #include <asm/cacheflush.h>
>   #include <asm/asm.h>
>   #include <asm/kvm_host.h>
> +#include <asm/tdx.h>
>   
>   #include "tdx_errno.h"
>   #include "tdx_arch.h"
> @@ -57,6 +58,10 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>   	return ret;
>   }
>   
> +#ifdef CONFIG_INTEL_TDX_HOST
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
> +#endif
> +
>   static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
>   {
>   	clflush_cache_range(__va(addr), PAGE_SIZE);


