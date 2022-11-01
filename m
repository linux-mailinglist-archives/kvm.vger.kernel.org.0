Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A5D614D3A
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiKAO4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiKAOzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141275FD7
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7TECTzTa7hC5sKywUnBQKWMdakLSbkAT8891gFZhdv0=;
        b=NnwCYdAMAoGm0k3UpbJh+AMV7X5Nwx0sw/PpfZseQQYd2JInW5W2jt3aqtmhOV/KNk3Ajy
        VLSko967nuV6SCwSVtyJpcvi5a/HpijHbFJjKJ3T3E/AD5QzuY+P1EeKxwKjyk8TOzs8M6
        Q+0PPl6nokO4vx9Kr7H4YilQTtLtZ9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-rOwUHN5YMBWTsvcsieWm-Q-1; Tue, 01 Nov 2022 10:54:45 -0400
X-MC-Unique: rOwUHN5YMBWTsvcsieWm-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF0CC8630C6;
        Tue,  1 Nov 2022 14:54:44 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EA2CC2C8D8;
        Tue,  1 Nov 2022 14:54:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 05/48] KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'
Date:   Tue,  1 Nov 2022 15:53:43 +0100
Message-Id: <20221101145426.251680-6-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make terminology between Hyper-V-on-KVM and KVM-on-Hyper-V consistent,
rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'. The change
eliminates the use of confusing 'direct' and adds the missing underscore.

No functional change.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.c    | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.h    | 6 +++---
 arch/x86/kvm/vmx/vmx.c             | 6 +++---
 arch/x86/kvm/x86.c                 | 6 +++---
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..6033b54963a4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,7 +123,7 @@ KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_OPTIONAL(enable_direct_tlbflush)
+KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..50fe0c7a5571 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1625,7 +1625,7 @@ struct kvm_x86_ops {
 					void *insn, int insn_len);
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
-	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 52c73a8be72b..26a89d0da93e 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -14,7 +14,7 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index d5cb2c62e355..45faf84476ce 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -13,7 +13,7 @@
 
 static struct kvm_x86_ops svm_x86_ops;
 
-int svm_hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
+int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
@@ -53,8 +53,8 @@ static inline void svm_hv_hardware_setup(void)
 
 			vp_ap->nested_control.features.directhypercall = 1;
 		}
-		svm_x86_ops.enable_direct_tlbflush =
-				svm_hv_enable_direct_tlbflush;
+		svm_x86_ops.enable_l2_tlb_flush =
+				svm_hv_enable_l2_tlb_flush;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..6b258d9cf53c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -526,7 +526,7 @@ static unsigned long host_idt_base;
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
-static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
+static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
@@ -8481,8 +8481,8 @@ static int __init vmx_init(void)
 		}
 
 		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_direct_tlbflush
-				= hv_enable_direct_tlbflush;
+			vmx_x86_ops.enable_l2_tlb_flush
+				= hv_enable_l2_tlb_flush;
 
 	} else {
 		enlightened_vmcs = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..f618187585b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4480,7 +4480,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			kvm_x86_ops.nested_ops->get_state(NULL, NULL, 0) : 0;
 		break;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
+		r = kvm_x86_ops.enable_l2_tlb_flush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
@@ -5496,10 +5496,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		}
 		return r;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
-		if (!kvm_x86_ops.enable_direct_tlbflush)
+		if (!kvm_x86_ops.enable_l2_tlb_flush)
 			return -ENOTTY;
 
-		return static_call(kvm_x86_enable_direct_tlbflush)(vcpu);
+		return static_call(kvm_x86_enable_l2_tlb_flush)(vcpu);
 
 	case KVM_CAP_HYPERV_ENFORCE_CPUID:
 		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
-- 
2.37.3

