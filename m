Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEF59AB90
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245658AbiHTGBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHTGAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACDEA262F;
        Fri, 19 Aug 2022 23:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975253; x=1692511253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HrmPC8RfziJsITYc01VGOv40y/+qnaX0p4MPPXpFpbU=;
  b=H8MVAx+wzWKKfOoSCS7uZf2MuGWjq5jobORGyQQpJIc72pn5B4pCUSSA
   sj10wEUtEkn7FR+TvZ/V5XkNVcqpL3qh2zY/bu7tRis0wQmelWVxA1EqF
   cr8XrCG8AXFQKBysRwZBC1Fx6kpc/vsr+snXUAx9+5BkPG6uYrkQQkD4U
   /f9YdvNydxGH57iF6TQ5RWAAhq3mU9qXur3cTGvWx0U+yhuBUdirFfyA5
   YqGW+8GrsQHyuNpEk+0ZuaK9DBOlSv7KU28Db6lVAP5XqXz2RFo/Iwutb
   YMr2FImytgte5YetG98aPErbywf3zBubbsDud/T7Db9QdlNVt1j93mYvT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448983"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448983"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857561"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 16/18] KVM: Add config to not compile kvm_arch.c
Date:   Fri, 19 Aug 2022 23:00:22 -0700
Message-Id: <e59f053759aa8d1a0987afa42716fed7f67a07dc.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

So that kvm_arch_hardware_enable/disable() aren't defined.

Once the conversion of all KVM archs is done, this config and kvm_arch.c
should be removed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig     | 1 +
 include/linux/kvm_host.h | 2 ++
 virt/kvm/Kconfig         | 3 +++
 virt/kvm/Makefile.kvm    | 5 ++++-
 4 files changed, 10 insertions(+), 1 deletion(-)

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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7983744addbf..1a05438ef33f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,8 +1434,10 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
+#ifndef CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
+#endif
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
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
index c4210acabd35..c0187ec4f83c 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -5,7 +5,10 @@
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/kvm_arch.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+ifneq ($(CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE), y)
+kvm-y += $(KVM)/kvm_arch.o
+endif
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
-- 
2.25.1

