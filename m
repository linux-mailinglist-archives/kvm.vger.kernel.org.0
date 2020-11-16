Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52222B4F72
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388485AbgKPS3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:48445 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731941AbgKPS2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:18 -0500
IronPort-SDR: QXOKLmbX/23N4GXPr4JDWrQtUVwsfXpSTg4SX1wy7k8RCYzCADivbaMBvdB+aSaVhcy5GkRjhv
 R77puYbI7zLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819186"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819186"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:17 -0800
IronPort-SDR: uP+JkfsVTjgEUcMPHXjLS1wTMENYh8D8HmaojHVqwVBavi/ozPBGpzhC3vy5iN083AEwmxYOsU
 lGi8d6efpuQg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528285"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:17 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 53/67] KVM: TDX: Add architectural definitions for structures and values
Date:   Mon, 16 Nov 2020 10:26:38 -0800
Message-Id: <4e6f074f8dcf0e8248870919185539d1f5aa3d62.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/tdx_arch.h | 230 ++++++++++++++++++++++++++++++++++++
 1 file changed, 230 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..d13db55e5086
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_ARCH_H
+#define __KVM_X86_TDX_ARCH_H
+
+#include <linux/types.h>
+
+/*
+ * SEAMCALL API function leaf
+ */
+#define SEAMCALL_TDENTER		0
+#define SEAMCALL_TDADDCX		1
+#define SEAMCALL_TDADDPAGE		2
+#define SEAMCALL_TDADDSEPT		3
+#define SEAMCALL_TDADDVPX		4
+#define SEAMCALL_TDASSIGNHKID		5
+#define SEAMCALL_TDAUGPAGE		6
+#define SEAMCALL_TDBLOCK		7
+#define SEAMCALL_TDCONFIGKEY		8
+#define SEAMCALL_TDCREATE		9
+#define SEAMCALL_TDCREATEVP		10
+#define SEAMCALL_TDDBGRD		11
+#define SEAMCALL_TDDBGRDMEM		12
+#define SEAMCALL_TDDBGWR		13
+#define SEAMCALL_TDDBGWRMEM		14
+#define SEAMCALL_TDDEMOTEPAGE		15
+#define SEAMCALL_TDEXTENDMR		16
+#define SEAMCALL_TDFINALIZEMR		17
+#define SEAMCALL_TDFLUSHVP		18
+#define SEAMCALL_TDFLUSHVPDONE		19
+#define SEAMCALL_TDFREEHKIDS		20
+#define SEAMCALL_TDINIT			21
+#define SEAMCALL_TDINITVP		22
+#define SEAMCALL_TDPROMOTEPAGE		23
+#define SEAMCALL_TDRDPAGEMD		24
+#define SEAMCALL_TDRDSEPT		25
+#define SEAMCALL_TDRDVPS		26
+#define SEAMCALL_TDRECLAIMHKIDS		27
+#define SEAMCALL_TDRECLAIMPAGE		28
+#define SEAMCALL_TDREMOVEPAGE		29
+#define SEAMCALL_TDREMOVESEPT		30
+#define SEAMCALL_TDSYSCONFIGKEY		31
+#define SEAMCALL_TDSYSINFO		32
+#define SEAMCALL_TDSYSINIT		33
+
+#define SEAMCALL_TDSYSINITLP		35
+#define SEAMCALL_TDSYSINITTDMR		36
+#define SEAMCALL_TDTEARDOWN		37
+#define SEAMCALL_TDTRACK		38
+#define SEAMCALL_TDUNBLOCK		39
+#define SEAMCALL_TDWBCACHE		40
+#define SEAMCALL_TDWBINVDPAGE		41
+#define SEAMCALL_TDWRSEPT		42
+#define SEAMCALL_TDWRVPS		43
+#define SEAMCALL_TDSYSSHUTDOWNLP	44
+#define SEAMCALL_TDSYSCONFIG		45
+
+#define TDVMCALL_MAP_GPA		0x10001
+#define TDVMCALL_REPORT_FATAL_ERROR	0x10003
+
+/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_CLASS_SHIFT		56
+#define TDX_FIELD_MASK		GENMASK_ULL(31, 0)
+
+#define BUILD_TDX_FIELD(class, field)	\
+	(((u64)(class) << TDX_CLASS_SHIFT) | ((u64)(field) & TDX_FIELD_MASK))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)	BUILD_TDX_FIELD(0, (field))
+
+/*
+ * @offset is the offset (in bytes) from the beginning of the architectural
+ * virtual APIC page.
+ */
+#define TDVPS_APIC(offset)	BUILD_TDX_FIELD(1, (offset))
+
+/* @gpr is the index of a general purpose register, e.g. eax=0 */
+#define TDVPS_GPR(gpr)		BUILD_TDX_FIELD(16, (gpr))
+
+#define TDVPS_DR(dr)		BUILD_TDX_FIELD(17, (0 + (dr)))
+
+enum tdx_guest_other_state {
+	TD_VCPU_XCR0 = 32,
+	TD_VCPU_IWK_ENCKEY0 = 64,
+	TD_VCPU_IWK_ENCKEY1,
+	TD_VCPU_IWK_ENCKEY2,
+	TD_VCPU_IWK_ENCKEY3,
+	TD_VCPU_IWK_INTKEY0 = 68,
+	TD_VCPU_IWK_INTKEY1,
+	TD_VCPU_IWK_FLAGS = 70,
+};
+
+/* @field is any of enum tdx_guest_other_state */
+#define TDVPS_STATE(field)	BUILD_TDX_FIELD(17, (field))
+
+/* @msr is the MSR index */
+#define TDVPS_MSR(msr)		BUILD_TDX_FIELD(19, (msr))
+
+/* Management class fields */
+enum tdx_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_guest_management */
+#define TDVPS_MANAGEMENT(field)	BUILD_TDX_FIELD(32, (field))
+
+#define TDX1_NR_TDCX_PAGES		4
+#define TDX1_NR_TDVPX_PAGES		5
+
+#define TDX1_MAX_NR_CPUID_CONFIGS	6
+#define TDX1_MAX_NR_CMRS		32
+#define TDX1_MAX_NR_TDMRS		64
+#define TDX1_EXTENDMR_CHUNKSIZE		256
+
+struct tdx_cpuid_config {
+	u32 leaf;
+	u32 sub_leaf;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+struct tdx_cpuid_value {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+#define TDX1_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
+#define TDX1_TD_ATTRIBUTE_SYSPROF	BIT_ULL(1)
+#define TDX1_TD_ATTRIBUTE_PKS		BIT_ULL(30)
+#define TDX1_TD_ATTRIBUTE_KL		BIT_ULL(31)
+#define TDX1_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
+
+/*
+ * TD_PARAMS is provided as an input to TDINIT, the size of which is 1024B.
+ */
+struct td_params {
+	u64 attributes;
+	u64 xfam;
+	u32 max_vcpus;
+	u32 reserved0;
+
+	u64 eptp_controls;
+	u64 exec_controls;
+	u16 tsc_frequency;
+	u8  reserved1[38];
+
+	u64 mrconfigid[6];
+	u64 mrowner[6];
+	u64 mrownerconfig[6];
+	u64 reserved2[4];
+
+	union {
+		struct tdx_cpuid_value cpuid_values[0];
+		u8 reserved3[768];
+	};
+} __packed __aligned(1024);
+
+/* Guest uses MAX_PA for GPAW when set. */
+#define TDX1_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDX1 requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. TDX-SEAM
+ * can only program frequencies that are multiples of 25MHz.  The frequency
+ * must be between 1ghz and 10ghz (inclusive).
+ */
+#define TDX1_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX1_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX1_MIN_TSC_FREQUENCY_KHZ		1  * 1000 * 1000
+#define TDX1_MAX_TSC_FREQUENCY_KHZ		10 * 1000 * 1000
+
+struct tdmr_reserved_area {
+	u64 offset;
+	u64 size;
+} __packed;
+
+struct tdmr_info {
+	u64 base;
+	u64 size;
+	u64 pamt_1g_base;
+	u64 pamt_1g_size;
+	u64 pamt_2m_base;
+	u64 pamt_2m_size;
+	u64 pamt_4k_base;
+	u64 pamt_4k_size;
+	struct tdmr_reserved_area reserved_areas[16];
+} __packed __aligned(4096);
+
+struct cmr_info {
+	u64 base;
+	u64 size;
+} __packed;
+
+struct tdsysinfo_struct {
+	/* TDX-SEAM Module Info */
+	u32 attributes;
+	u32 vendor_id;
+	u32 build_date;
+	u16 build_num;
+	u16 minor_version;
+	u16 major_version;
+	u8 reserved0[14];
+	/* Memory Info */
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size;
+	u8 reserved1[10];
+	/* Control Struct Info */
+	u16 tdcs_base_size;
+	u8 reserved2[2];
+	u16 tdvps_base_size;
+	u8 tdvps_xfam_dependent_size;
+	u8 reserved3[9];
+	/* TD Capabilities */
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u8 reserved4[32];
+	u32 num_cpuid_config;
+	union {
+		struct tdx_cpuid_config cpuid_configs[0];
+		u8 reserved5[892];
+	};
+} __packed __aligned(1024);
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.17.1

