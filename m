Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A5058F654
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 05:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiHKDPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 23:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiHKDPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 23:15:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404DC103D;
        Wed, 10 Aug 2022 20:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660187712; x=1691723712;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eG7pE1AkaxRu/I4Nox6vSigWlWaHMWgrs2p/ibYV4j8=;
  b=T53/AKhWJ9ytkKPTpH6Xgj7VTTY7WtpS0KO1WB7S16A1d6i0P7Za/u2k
   dAVWcsiJDZ63G9H4aUkemPkAFWqQTIOSTPHZEey5/+8aFy8BZuEH37sRK
   tgcUsRmsMZPJbVwxXMDUNZF0G5YvjD9JJpPLu+ysJsQaiYM8Edn7gUejI
   8SUX6f0CE/b1O+LnwbvH4dQVyLohIgXrgPEekglFeCY0NQwvz00plhC9W
   TNjAoX5XcWu3nG6aSs+BjFZqXMRnVSTj//DgzZ/1KFjrX21ryWX5/Di+7
   iZHZiv935j36kQzG/AXUYusTI3OgVmmqIQ/FL9Ku99I58tUCmGOM++A8b
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292037276"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292037276"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 20:15:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="665180068"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.169.32]) ([10.249.169.32])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 20:15:09 -0700
Message-ID: <b19f28ac-07e0-2bd2-1b2e-abf7373b0960@linux.intel.com>
Date:   Thu, 11 Aug 2022 11:15:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 013/103] KVM: TDX: Define TDX architectural definitions
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <f6bbcf4fb65a3de2ee7d4b2baa2965e24b0ede90.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f6bbcf4fb65a3de2ee7d4b2baa2965e24b0ede90.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:00, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Define architectural definitions for KVM to issue the TDX SEAMCALLs.
>
> Structures and values that are architecturally defined in the TDX module
> specifications the chapter of ABI Reference.
>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx_arch.h | 157 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 157 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
>
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> new file mode 100644
> index 000000000000..94258056d742
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -0,0 +1,157 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_ARCH_H
> +#define __KVM_X86_TDX_ARCH_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * TDX SEAMCALL API function leaves
> + */
> +#define TDH_VP_ENTER			0
> +#define TDH_MNG_ADDCX			1
> +#define TDH_MEM_PAGE_ADD		2
> +#define TDH_MEM_SEPT_ADD		3
> +#define TDH_VP_ADDCX			4
> +#define TDH_MEM_PAGE_RELOCATE		5
> +#define TDH_MEM_PAGE_AUG		6
> +#define TDH_MEM_RANGE_BLOCK		7
> +#define TDH_MNG_KEY_CONFIG		8
> +#define TDH_MNG_CREATE			9
> +#define TDH_VP_CREATE			10
> +#define TDH_MNG_RD			11
> +#define TDH_MR_EXTEND			16
> +#define TDH_MR_FINALIZE			17
> +#define TDH_VP_FLUSH			18
> +#define TDH_MNG_VPFLUSHDONE		19
> +#define TDH_MNG_KEY_FREEID		20
> +#define TDH_MNG_INIT			21
> +#define TDH_VP_INIT			22
> +#define TDH_VP_RD			26
> +#define TDH_MNG_KEY_RECLAIMID		27
> +#define TDH_PHYMEM_PAGE_RECLAIM		28
> +#define TDH_MEM_PAGE_REMOVE		29
> +#define TDH_MEM_SEPT_REMOVE		30
> +#define TDH_MEM_TRACK			38
> +#define TDH_MEM_RANGE_UNBLOCK		39
> +#define TDH_PHYMEM_CACHE_WB		40
> +#define TDH_PHYMEM_PAGE_WBINVD		41
> +#define TDH_VP_WR			43
> +#define TDH_SYS_LP_SHUTDOWN		44
> +
> +#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
> +#define TDG_VP_VMCALL_MAP_GPA				0x10001
> +#define TDG_VP_VMCALL_GET_QUOTE				0x10002
> +#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
> +#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
> +
> +/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
> +#define TDX_NON_ARCH			BIT_ULL(63)
> +#define TDX_CLASS_SHIFT			56
> +#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
> +
> +#define __BUILD_TDX_FIELD(non_arch, class, field)	\
> +	(((non_arch) ? TDX_NON_ARCH : 0) |		\
> +	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
> +	 ((u64)(field) & TDX_FIELD_MASK))
> +
> +#define BUILD_TDX_FIELD(class, field)			\
> +	__BUILD_TDX_FIELD(false, (class), (field))
> +
> +#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
> +	__BUILD_TDX_FIELD(true, (class), (field))
> +
> +
> +/* @field is the VMCS field encoding */
> +#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(0, (field))
> +
> +enum tdx_guest_other_state {
> +	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
> +};
> +
> +union tdx_vcpu_state_details {
> +	struct {
> +		u64 vmxip	: 1;
> +		u64 reserved	: 63;
> +	};
> +	u64 full;
> +};
> +
> +/* @field is any of enum tdx_guest_other_state */
> +#define TDVPS_STATE(field)		BUILD_TDX_FIELD(17, (field))
> +#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(17, (field))
> +
> +/* Management class fields */
> +enum tdx_guest_management {

More accurate to use tdx_vcpu_management?


> +	TD_VCPU_PEND_NMI = 11,
> +};
> +
> +/* @field is any of enum tdx_guest_management */
> +#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(32, (field))
> +
> +enum tdx_tdcs_execution_control {
> +	TD_TDCS_EXEC_TSC_OFFSET = 10,
> +};
> +
> +/* @field is any of enum tdx_tdcs_execution_control */
> +#define TDCS_EXEC(field)		BUILD_TDX_FIELD(17, (field))
> +
> +#define TDX_EXTENDMR_CHUNKSIZE		256
> +
> +struct tdx_cpuid_value {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
> +#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
> +#define TDX_TD_ATTRIBUTE_PKS		BIT_ULL(30)
> +#define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
> +#define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
> +
> +/*
> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> + */
> +struct td_params {
> +	u64 attributes;
> +	u64 xfam;
> +	u32 max_vcpus;
> +	u32 reserved0;
> +
> +	u64 eptp_controls;
> +	u64 exec_controls;
> +	u16 tsc_frequency;
> +	u8  reserved1[38];
> +
> +	u64 mrconfigid[6];
> +	u64 mrowner[6];
> +	u64 mrownerconfig[6];
> +	u64 reserved2[4];
> +
> +	union {
> +		struct tdx_cpuid_value cpuid_values[0];
> +		u8 reserved3[768];
> +	};
> +} __packed __aligned(1024);
> +
> +/*
> + * Guest uses MAX_PA for GPAW when set.
> + * 0: GPA.SHARED bit is GPA[47]
> + * 1: GPA.SHARED bit is GPA[51]
> + */
> +#define TDX_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
> +
> +/*
> + * TDX requires the frequency to be defined in units of 25MHz, which is the
> + * frequency of the core crystal clock on TDX-capable platforms, i.e. the TDX
> + * module can only program frequencies that are multiples of 25MHz.  The
> + * frequency must be between 100mhz and 10ghz (inclusive).
> + */
> +#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
> +#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
> +#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
> +#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
> +
> +#endif /* __KVM_X86_TDX_ARCH_H */
