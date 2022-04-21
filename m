Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4017509938
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385848AbiDUHie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385827AbiDUHi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:38:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F1E00D
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650526540; x=1682062540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=SK6DfUD1Elhz4wP8ubWVI6Kmk8qCznEz0nRUM7R0eFk=;
  b=a8rmEu9O9Tvjb2cnGcLoo+SgoKHKkcGtjVpsKW0lddoswseairfs2I9i
   mnxuolaAOOoi+NJocYH9D3u+VCrwjLUw0KB+9K4ym7sRwQa/ILLzhGPXA
   Pig9bGCuqtG/oVKbvyuRO1YQcFOIkfEJ14WIDIAWauTKmJn0aEi5F7xpB
   yQFxAxw8nF7ws2u2Ngav68wYT/U++LmQtlul+MrvzDa7uwTPH16EzfI3C
   oI4QF4MhM43l6GLpTMPoN6qx5pmaG9GcF2ll2ytEtPWe/dwuNTtMLnuC1
   kDe6P+6Q371CB47fRyif9mCJ29kOAbvxhnu/o73qAMw3LlPPNHG5C6eOY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264440500"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264440500"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530155145"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:35:14 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 1/3] linux-header: update linux header
Date:   Thu, 21 Apr 2022 15:40:26 +0800
Message-Id: <20220421074028.18196-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421074028.18196-1-chenyi.qiang@intel.com>
References: <20220421074028.18196-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This linux-header update is only a reference to include some definitions
related to notify VM exit.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 linux-headers/asm-x86/kvm.h |  4 +++-
 linux-headers/linux/kvm.h   | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index bf6e96011d..41541561ed 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -359,7 +360,8 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
+	__u8 triple_fault_pending;
+	__u8 reserved[26];
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index d232feaae9..67c0f6a938 100644
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
@@ -1134,6 +1140,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_X86_NOTIFY_VMEXIT  215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2051,4 +2058,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+#define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
+#define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
-- 
2.17.1

