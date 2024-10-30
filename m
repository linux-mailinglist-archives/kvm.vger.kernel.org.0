Return-Path: <kvm+bounces-30097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD6F9B6CAF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF93B23753
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014C022805C;
	Wed, 30 Oct 2024 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d6hyuXjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBCD21FD87;
	Wed, 30 Oct 2024 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314877; cv=none; b=Ht7kHwQoTkkZH12GWo5gGmWHRovWXEPrHcusseBbLl8mzc09X/QplX/ZeN7HsWsuX93aNMAGIYlIi5fj7poBzlnZ3kSD2RdJveLGZPbEq2r3s5ZRDICjhYf9c4FDNPGiXjo2x/r557+cXUQsBLw/fqWJIuD5Ll9on68LfU4tM4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314877; c=relaxed/simple;
	bh=eulfXokD5/qZzy03Oms7b48P4y09C+Abv8jAdEYUHSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5z4DApHfyvxETruU+WbUQmL1+SPBwUYsNPlllS3Unk4SIXX75rp2RZOSLZr5P9vNJ9S6GoNbmMTeFqEwZozlk2NGDyyGC0cVibFm/EiPZBVd6ZyYMR7onEIFUDsAk8qdUnmshrf9W7zyvY100b3JbAs/n8IczoVJq8JkdMRH6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d6hyuXjZ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314874; x=1761850874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eulfXokD5/qZzy03Oms7b48P4y09C+Abv8jAdEYUHSk=;
  b=d6hyuXjZJbM8iO8nVGkLZ5Si0LGevBFPaLOXatw6nuvMk/KnvvSTGzYH
   YGEfZtj5FgZHfsuOW62p8hyFicQontCCLcC/kwqiFQg9Y8yrUi8VFn+D0
   gzP7zyPD+7CY2KIzwpASdMrRFzpw20kjuRlO0tQ5Mmqo5bDUK3Qb9mea9
   PnYodtnaDk0eqAk2J3AwoxFLc/FdfqNN+Jhdjk9fhkcjmOwgy5Y1RQL86
   2WUEsF6FD8SEx73YiXVWLYisgLLi0Ph/ZxmLKTjKdnS2Nc7ZE2eJlGYiX
   CkXsmAdpktc8zVKNrUHw7/xDW9VU9swadd3EBCNTNxiz950ELRPFLO0Qg
   Q==;
X-CSE-ConnectionGUID: R69U6LmiR/mb2l2mOR6seA==
X-CSE-MsgGUID: K2MTfBKrR4qHHcCEubzatw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678821"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678821"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:05 -0700
X-CSE-ConnectionGUID: mpyYMRYmRZ6Nk1XKNE8sKA==
X-CSE-MsgGUID: zs4cth0sSy+ItWgwmeRccA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499437"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:05 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 19/25] KVM: TDX: initialize VM with TDX specific parameters
Date: Wed, 30 Oct 2024 12:00:32 -0700
Message-ID: <20241030190039.77971-20-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

After the crypto-protection key has been configured, TDX requires a
VM-scope initialization as a step of creating the TDX guest.  This
"per-VM" TDX initialization does the global configurations/features that
the TDX guest can support, such as guest's CPUIDs (emulated by the TDX
module), the maximum number of vcpus etc.

This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
to be done before KVM creates any vcpus.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Move setting of gfn_direct_bits into MMU part 2 series (Yan)
 - Enable NO_RBP_MOD after removing workaround in later pactches (Fengwei)
 - Use TDX 1.5 naming of config_flags instead of exec_controls (Xiaoyao)
 - fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Reject leaves that are not in tdx caps (Rick)
 - Add TD state handling (Tony)
 - Generate data directly from td_conf (Tony)
 - Fold in guest physical address to configure EPT level (Xiaoyao)
 - Use helpers for phys_addr_bits and add comments (Paolo)

uAPI breakout v1:
 - Drop TDX_TD_XFAM_CET and use XFEATURE_MASK_CET_{USER, KERNEL}.
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Move gfn_shared_mask settings into this patch due to MMU section move
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)
 - Allow userspace configure xfam directly
 - Check if user sets non-configurable bits in CPUIDs
 - Rename error->hw_error
 - Move code change to tdx_module_setup() to __tdx_bringup() due to
   initializing is done in post hardware_setup() now and
   tdx_module_setup() is removed.  Remove the code to use API to read
   global metadata but use exported 'struct tdx_sysinfo' pointer.
 - Replace 'tdx_info->nr_tdcs_pages' with a wrapper
   tdx_sysinfo_nr_tdcs_pages() because the 'struct tdx_sysinfo' doesn't
   have nr_tdcs_pages directly.
 - Replace tdx_info->max_vcpus_per_td with the new exported pointer in
   tdx_vm_init().
 - Decrease the reserved space for struct kvm_tdx_init_vm (Kai)
 - Use sizeof_field() for struct kvm_tdx_init_vm cpuids (Tony)
 - No need to init init_vm, it gets copied over in tdx_td_init() (Chao)
 - Use kmalloc() instead of () kzalloc for init_vm in tdx_td_init() (Chao)
 - Add more line breaks to tdx_td_init() to make code easier to read (Tony)
 - Clarify patch description (Kai)

v19:
 - Check NO_RBP_MOD of feature0 and set it
 - Update the comment for PT and CET

v18:
 - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
 - typo in comment. sha348 => sha384
 - updated comment in setup_tdparams_xfam()
 - fix setup_tdparams_xfam() to use init_vm instead of td_params

---
 arch/x86/include/uapi/asm/kvm.h |  24 +++
 arch/x86/kvm/cpuid.c            |   7 +
 arch/x86/kvm/cpuid.h            |   2 +
 arch/x86/kvm/vmx/tdx.c          | 259 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h          |  24 +++
 5 files changed, 306 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0630530af334..892e16bd7430 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -929,6 +929,7 @@ struct kvm_hyperv_eventfd {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -959,4 +960,27 @@ struct kvm_tdx_capabilities {
 	struct kvm_cpuid2 cpuid;
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 xfam;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+
+	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+	__u64 reserved[12];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..14be20e003f4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1513,6 +1513,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
+{
+	return cpuid_entry2_find(entries, nent, function, index);
+}
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
+
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 41697cca354e..00570227e2ae 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
+					       int nent, u32 function, u64 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c9093b003c13..ac224d79ba1e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 #include "x86_ops.h"
 #include "tdx.h"
 
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -63,6 +64,11 @@ static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
 	return val;
 }
 
+static int tdx_get_guest_phys_addr_bits(const u32 eax)
+{
+	return (eax & GENMASK(23, 16)) >> 16;
+}
+
 static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
 {
 	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
@@ -360,7 +366,11 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 
 void tdx_vm_free(struct kvm *kvm)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
 	tdx_reclaim_td_control_pages(kvm);
+
+	kvm_tdx->state = TD_STATE_UNINITIALIZED;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -379,10 +389,10 @@ static int tdx_do_tdh_mng_key_config(void *param)
 	return 0;
 }
 
-static int __tdx_td_init(struct kvm *kvm);
-
 int tdx_vm_init(struct kvm *kvm)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
 	kvm->arch.has_private_mem = true;
 
 	/*
@@ -398,8 +408,9 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
 
-	/* Place holder for TDX specific logic. */
-	return __tdx_td_init(kvm);
+	kvm_tdx->state = TD_STATE_UNINITIALIZED;
+
+	return 0;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -450,7 +461,142 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
-static int __tdx_td_init(struct kvm *kvm)
+/*
+ * KVM reports guest physical address in CPUID.0x800000008.EAX[23:16], which is
+ * similar to TDX's GPAW. Use this field as the interface for userspace to
+ * configure the GPAW and EPT level for TDs.
+ *
+ * Only values 48 and 52 are supported. Value 52 means GPAW-52 and EPT level
+ * 5, Value 48 means GPAW-48 and EPT level 4. For value 48, GPAW-48 is always
+ * supported. Value 52 is only supported when the platform supports 5 level
+ * EPT.
+ */
+static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
+					struct td_params *td_params)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	int guest_pa;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
+	if (!entry)
+		return -EINVAL;
+
+	guest_pa = tdx_get_guest_phys_addr_bits(entry->eax);
+
+	if (guest_pa != 48 && guest_pa != 52)
+		return -EINVAL;
+
+	if (guest_pa == 52 && !cpu_has_vmx_ept_5levels())
+		return -EINVAL;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+	if (guest_pa == 52) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->config_flags |= TDX_CONFIG_FLAGS_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	return 0;
+}
+
+static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+				 struct td_params *td_params)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	const struct kvm_cpuid_entry2 *entry;
+	struct tdx_cpuid_value *value;
+	int i, copy_cnt = 0;
+
+	/*
+	 * td_params.cpuid_values: The number and the order of cpuid_value must
+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
+	 * It's assumed that td_params was zeroed.
+	 */
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		struct kvm_cpuid_entry2 tmp;
+
+		td_init_cpuid_entry2(&tmp, i);
+
+		entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
+					      tmp.function, tmp.index);
+		if (!entry)
+			continue;
+
+		copy_cnt++;
+
+		value = &td_params->cpuid_values[i];
+		value->eax = entry->eax;
+		value->ebx = entry->ebx;
+		value->ecx = entry->ecx;
+		value->edx = entry->edx;
+
+		/*
+		 * TDX module does not accept nonzero bits 16..23 for the
+		 * CPUID[0x80000008].EAX, see setup_tdparams_eptp_controls().
+		 */
+		if (tmp.function == 0x80000008)
+			value->eax = tdx_set_guest_phys_addr_bits(value->eax, 0);
+	}
+
+	/*
+	 * Rely on the TDX module to reject invalid configuration, but it can't
+	 * check of leafs that don't have a proper slot in td_params->cpuid_values
+	 * to stick then. So fail if there were entries that didn't get copied to
+	 * td_params.
+	 */
+	if (copy_cnt != cpuid->nent)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
+	int ret;
+
+	if (kvm->created_vcpus)
+		return -EBUSY;
+
+	if (init_vm->attributes & ~tdx_get_supported_attrs(td_conf))
+		return -EINVAL;
+
+	if (init_vm->xfam & ~tdx_get_supported_xfam(td_conf))
+		return -EINVAL;
+
+	td_params->max_vcpus = kvm->max_vcpus;
+	td_params->attributes = init_vm->attributes | td_conf->attributes_fixed1;
+	td_params->xfam = init_vm->xfam | td_conf->xfam_fixed1;
+
+	td_params->config_flags = TDX_CONFIG_FLAGS_NO_RBP_MOD;
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
+
+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
+	if (ret)
+		return ret;
+
+	ret = setup_tdparams_cpuids(cpuid, td_params);
+	if (ret)
+		return ret;
+
+#define MEMCPY_SAME_SIZE(dst, src)				\
+	do {							\
+		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
+		memcpy((dst), (src), sizeof(dst));		\
+	} while (0)
+
+	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
+	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
+	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
+
+	return 0;
+}
+
+static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
+			 u64 *seamcall_err)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages;
@@ -458,8 +604,9 @@ static int __tdx_td_init(struct kvm *kvm)
 	unsigned long tdr_pa = 0;
 	unsigned long va;
 	int ret, i;
-	u64 err;
+	u64 err, rcx;
 
+	*seamcall_err = 0;
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
@@ -573,10 +720,23 @@ static int __tdx_td_init(struct kvm *kvm)
 		}
 	}
 
-	/*
-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
-	 * ioctl() to define the configure CPUID values for the TD.
-	 */
+	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &rcx);
+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
+		/*
+		 * Because a user gives operands, don't warn.
+		 * Return a hint to the user because it's sometimes hard for the
+		 * user to figure out which operand is invalid.  SEAMCALL status
+		 * code includes which operand caused invalid operand error.
+		 */
+		*seamcall_err = err;
+		ret = -EINVAL;
+		goto teardown;
+	} else if (WARN_ON_ONCE(err)) {
+		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
+		ret = -EIO;
+		goto teardown;
+	}
+
 	return 0;
 
 	/*
@@ -624,6 +784,82 @@ static int __tdx_td_init(struct kvm *kvm)
 	return ret;
 }
 
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm;
+	struct td_params *td_params = NULL;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (kvm_tdx->state != TD_STATE_UNINITIALIZED)
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	init_vm = kmalloc(sizeof(*init_vm) +
+			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+			  GFP_KERNEL);
+	if (!init_vm)
+		return -ENOMEM;
+
+	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	if (copy_from_user(init_vm->cpuid.entries,
+			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
+			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (init_vm->cpuid.padding) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
+	if (!td_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = setup_tdparams(kvm, td_params, init_vm);
+	if (ret)
+		goto out;
+
+	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
+	if (ret)
+		goto out;
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+
+	kvm_tdx->state = TD_STATE_INITIALIZED;
+out:
+	/* kfree() accepts NULL. */
+	kfree(init_vm);
+	kfree(td_params);
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -645,6 +881,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_CAPABILITIES:
 		r = tdx_get_capabilities(&tdx_cmd);
 		break;
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index e557a82bc882..1fcb7c1b078d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -10,14 +10,27 @@ void tdx_cleanup(void);
 
 extern bool enable_tdx;
 
+/* TDX module hardware states. These follow the TDX module OP_STATEs. */
+enum kvm_tdx_state {
+	TD_STATE_UNINITIALIZED = 0,
+	TD_STATE_INITIALIZED,
+	TD_STATE_RUNNABLE,
+};
+
 struct kvm_tdx {
 	struct kvm kvm;
 
 	unsigned long tdr_pa;
 	unsigned long *tdcs_pa;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
 	u8 nr_tdcs_pages;
+
+	u64 tsc_offset;
+
+	enum kvm_tdx_state state;
 };
 
 struct vcpu_tdx {
@@ -45,6 +58,17 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	u64 err, data;
+
+	err = tdh_mng_rd(kvm_tdx->tdr_pa, TDCS_EXEC(field), &data);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		return 0;
+	}
+	return data;
+}
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
-- 
2.47.0


