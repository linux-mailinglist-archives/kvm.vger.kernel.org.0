Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDDC5E6AC7
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiIVSX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiIVSX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCF210961A;
        Thu, 22 Sep 2022 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870940; x=1695406940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AxxjbbyyR0194wjXyMbCislo3hv78tU3zlzwW8OtOcw=;
  b=kUq0gvFlRAo9I/sbIpcCYcdTr1HkGGRiwfNFt7TIIzGVrcFqKoNsVkrH
   hWhVq79O39cd+EjMUbVhrNZ1cfQUk0tHDk7KbUj1+eP8ep9MfuBaOP3Tp
   dcyJIXjjxwS4QbixtkEQ6CRmYT69ky3Q0/uC5exsW4Lr10CUcpL2+qOGz
   A5f10yItXNAjSv0h7y1T9/40i4USMzj6nliaX8vkIOTpDCKXYwbihnVB5
   OZx02cQHbUcaGFRejncsD+fLBJAapyNu5F+RqbBQixwetqtBwOCoxss48
   B/S5MX8WPGGuww4JtXMwNDFncn5nR85fs/zSRBBpjEH+gTQsfupaN6M//
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712929"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712929"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086860"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:26 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 24/30] KVM: Add config to not compile kvm_arch.c
Date:   Thu, 22 Sep 2022 11:20:53 -0700
Message-Id: <66e9475874595880b0951edf6ad17b6317992bed.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

So that kvm_arch_hardware_enable/disable() aren't required.

Once the conversion of all KVM archs is done, this config and kvm_arch.c
should be removed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig     | 1 +
 arch/x86/kvm/x86.c       | 4 ++--
 include/linux/kvm_host.h | 3 +++
 virt/kvm/Kconfig         | 3 +++
 virt/kvm/Makefile.kvm    | 5 ++++-
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..e2e16205425d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -25,6 +25,7 @@ config KVM
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
+	select HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf8d3b901725..01687b553915 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11864,7 +11864,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-int kvm_arch_hardware_enable(void)
+static int kvm_arch_hardware_enable(void)
 {
 	return static_call(kvm_x86_hardware_enable)();
 }
@@ -11961,7 +11961,7 @@ void kvm_arch_resume(int usage_count)
 	}
 }
 
-void kvm_arch_hardware_disable(void)
+static void kvm_arch_hardware_disable(void)
 {
 	static_call(kvm_x86_hardware_disable)();
 	drop_user_return_notifiers();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8dfa212b4543..7efc4792ff5f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1440,8 +1440,11 @@ int kvm_arch_reboot(int val);
 int kvm_arch_suspend(int usage_count);
 void kvm_arch_resume(int usage_count);
 
+#ifndef CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
+#endif
+
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..917314a87696 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -72,3 +72,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
+	def_bool n
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 428b09b3f80a..c0187ec4f83c 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -5,7 +5,10 @@
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o $(KVM)/kvm_arch.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+ifneq ($(CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE), y)
+kvm-y += $(KVM)/kvm_arch.o
+endif
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
-- 
2.25.1

