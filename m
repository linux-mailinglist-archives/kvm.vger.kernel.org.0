Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30DA4D75DC
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiCMOcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiCMOcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:32:01 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3C69BAF4;
        Sun, 13 Mar 2022 07:30:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x15so20024079wru.13;
        Sun, 13 Mar 2022 07:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vvFg0tG8qKQJGX7GaBTq12KHlg0aXVnGRCZLTU302pk=;
        b=NgUVjisQDjaJPqCiBCqkTz686mHZsPa7RWV+vLCjA1AmEpu5t9JQHE7mg0/OgP1WXN
         CR6qAKLZtgUy1JF3aM+oGNoSs6JDZAfGt9m0DQ6LnEBVuQcTvK2aDXgjXjI4is1SSRCb
         aKKuYMV+wvvYgm3sXsz/8TLP/a9wUgYuDZyzdb2Nx/39jvqi7oSXUrZUnBTl1MbVx0P+
         fBfegXYLtANgjUTsO/UIhS16EyfdEsRsPTeNsM34yc1sd7aGysDfZDA1A2P0tUrWGY4r
         k3gKw/Dov8lXz/QyC5q6kx6F756IOhQ7tpZal3KGhGsl0eDyzVZbic8bwWyej25QBmm/
         wKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vvFg0tG8qKQJGX7GaBTq12KHlg0aXVnGRCZLTU302pk=;
        b=tu/+KBdtL/bwxzhED77M/IlZi8tmfqG1cgsYvacupvlB6/uZ6IF4aLGBq4MXrCCN5k
         6wb0il5/eHOnFHNg0cQ8tP3ad2imphZ3CteqN4u+NWsDvVFLfk2y5uww+6+ZtU/atNpr
         Uc9kLfklfYbLeOQW0txfW3i4tAazl8coJE1s2i/5n8iuRIGhDX13tunE/Ma0ITgY1MGR
         7mXgPmIle5hmgP2/12OzSlsuhySBDOVnbpjqcOmWRiANDt1dxde5OjLDMLZA7cfKZwT3
         g8VBaIzzG3AuIC8OTNd/soYxaDkda55O+0cYacIVrLsreI2gzdmqVduqc2aBG2d7AZz2
         UAVg==
X-Gm-Message-State: AOAM533ifTDdE/pLtMAvFm9qCEau+yC5V8BD6NQTWAJG+0Ytt0om70yT
        7JwfvXEG/GHhuQsjlimUGoEM1MrOez0=
X-Google-Smtp-Source: ABdhPJx0TnNje9HcnOzo3VxH19llTtCTHjxXBlskjJR1Q0AyGCCPqUaXEnhCsKqhrMYDjyDRz6dwxw==
X-Received: by 2002:adf:816b:0:b0:203:7fae:a245 with SMTP id 98-20020adf816b000000b002037faea245mr13943998wrm.619.1647181852145;
        Sun, 13 Mar 2022 07:30:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id l25-20020a1c7919000000b0038999b380e9sm12287708wme.38.2022.03.13.07.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:30:51 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <21922e4b-20ed-f8e4-3f37-a1e3523c2110@redhat.com>
Date:   Sun, 13 Mar 2022 15:30:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 012/104] KVM: TDX: Define TDX architectural
 definitions
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d32e6bac7028e7e60929846cda126cd0e4309bff.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d32e6bac7028e7e60929846cda126cd0e4309bff.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
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
> ---
>   arch/x86/kvm/vmx/tdx_arch.h | 158 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 158 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> new file mode 100644
> index 000000000000..3824491d22dc
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -0,0 +1,158 @@
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
> +#define TDX_TD_XFAM_LBR			BIT_ULL(15)
> +#define TDX_TD_XFAM_AMX			(BIT_ULL(17) | BIT_ULL(18))
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

