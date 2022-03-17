Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5A4DC815
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiCQOAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiCQOAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:00:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D338124C00
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525569; x=1679061569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xGNGefUxjPIGm5UnqrEmcMpPpWZ4Sammgn0BpFNAAMQ=;
  b=mgmvqlHG5vC57b4ipF8CjaUIH3yTzBvk2WC0V4paOegkKtKMDHI8ETLZ
   z38O/RGpCf332YtivAF7TQWntQG/WDbl/obKKNHx7eBwxsyagwBwOq+uY
   Bn5pv1NcK29wHHst+ZNXtHvOv1WeawzFDjL6z5QMqueKRPO2k8++gw2vb
   ypCUZ0dGxpu/cz6fiCuxZB9EBRD5FCHWG646n2BKN4rcAYQL4kBdM3DxQ
   DWoNDruOcDI+qFE+rShjjHPQJViuUrtEh4DAWEMXLKLi0Bd7njw3KbIhW
   /KA7n/vysWJ387h0Lu5mvbx6p1R8anngYAzdsOqSbf+MknG2O7ppOGNVQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256600124"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="256600124"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377813"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:18 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 01/36] *** HACK *** linux-headers: Update headers to pull in TDX API changes
Date:   Thu, 17 Mar 2022 21:58:38 +0800
Message-Id: <20220317135913.2166202-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pull in recent TDX updates, which are not backwards compatible.

It's just to make this series runnable. It will be updated by script

	scripts/update-linux-headers.sh

once TDX support is upstreamed in linux kernel.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 linux-headers/asm-x86/kvm.h | 60 +++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h   |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index bf6e96011dfe..c4692bac8e51 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -525,4 +525,64 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_TDX_VM		1
+
+/* Trust Domain eXtension command*/
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	__u32 padding;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 attributes;
+	__u64 cpuid;
+	__u64 mrconfigid[6];    /* sha384 digest */
+	__u64 mrowner[6];       /* sha384 digest */
+	__u64 mrownerconfig[6]; /* sha348 digest */
+	__u64 reserved[43];     /* must be zero for future extensibility */
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index d232feaae972..466f43f6d746 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1135,6 +1135,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 
+#define KVM_CAP_VM_TYPES 1000
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
-- 
2.27.0

