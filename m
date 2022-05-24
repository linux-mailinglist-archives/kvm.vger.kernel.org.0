Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190EB532BC2
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbiEXN4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEXN4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:56:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF8D3465D
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 06:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400610; x=1684936610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=JdShOr5JW3EdD/+1WRPhlMd9UsMATYvu9LGcy64jWZk=;
  b=CHWWV/hSnywnSuH5y7GgOaYwIO05QuuU8thMKyvomciI9Vo6s1t/f8pu
   bwH4UPjmdLwySJw85bYAhOWC1MOWue4uDWRu35cWPz+dguj9V69NCp3OK
   Z276mOczNWEt79HY66Sz2OAawA3XnDc1+Buo43Do8ZF4WtMQ/x1Bzrn3q
   vN/7aFxRK0t8a1DNRnQKYZQ7mdNGUSJtqGDQXaZHfuYIcjMoEsNgKVloG
   cupmZhlvWqsAdedTJFV25qkhRQ4o0KKF0GKpgN3jvKs3Pk4DNSSzjjC/H
   2zrqi1qwdM8d+SZKNPbKIulJW/piSkJF0O/ySDHdoTIHcAo/8+NuwUh61
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273261453"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273261453"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:56:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="717179432"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:56:48 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 1/3] linux-header: update linux header
Date:   Tue, 24 May 2022 22:03:00 +0800
Message-Id: <20220524140302.23272-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524140302.23272-1-chenyi.qiang@intel.com>
References: <20220524140302.23272-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This linux-header update is only a reference to include some definitions
related to notify VM exit.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 linux-headers/asm-x86/kvm.h |  6 +++++-
 linux-headers/linux/kvm.h   | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index bf6e96011d..8791f7c228 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -359,7 +360,10 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
+	struct {
+		__u8 pending;
+	} triple_fault;
+	__u8 reserved[26];
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index d232feaae9..81dfdcfaa1 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_NOTIFY           36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +488,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_NOTIFY */
+		struct {
+#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+			__u32 flags;
+		} notify;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1134,6 +1140,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_TRIPLE_FAULT_EVENT 216
+#define KVM_CAP_X86_NOTIFY_VMEXIT 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2051,4 +2059,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+#define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
+#define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
-- 
2.17.1

