Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BCE60FD6F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbiJ0QuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiJ0Qtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:49:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E99332BB3
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666889388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXIKNzxn7gEudfn9nb45VSrNj59yt6Czo/wBWBxPUSE=;
        b=fREazrcc4iw5WdE4OB2qB+TK8xeEzlFoPhhnEZ/A94sjbXtOzjebRSQTUWiCshLD9hqxkZ
        QR+nOnBQG2HjZB9mJ/tlD+DAnCvdOx2Ab9EFb4xODLsR9dSxzYAlg5BuSlPSQRdWsCs7nV
        IwWGDlKmW44bf+T/Xj7xj+yjf+XkV04=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-LiZmI3BgM0uc_oG7P16kRw-1; Thu, 27 Oct 2022 12:49:47 -0400
X-MC-Unique: LiZmI3BgM0uc_oG7P16kRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14D0529324AF;
        Thu, 27 Oct 2022 16:49:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7F8F2166B26;
        Thu, 27 Oct 2022 16:49:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com
Subject: [PATCH 10/10] KVM: x86: do not define SMM-related constants if SMM disabled
Date:   Thu, 27 Oct 2022 12:49:44 -0400
Message-Id: <20221027164944.3031588-11-pbonzini@redhat.com>
In-Reply-To: <20221027164944.3031588-1-pbonzini@redhat.com>
References: <20221027164944.3031588-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/smm.c              | 3 +++
 arch/x86/kvm/x86.c              | 4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ddcc0e6fae5..89c89c70f74e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1992,10 +1992,11 @@ enum {
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
+
+#ifdef CONFIG_KVM_SMM
 #define HF_SMM_MASK		(1 << 6)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
 
-#ifdef CONFIG_KVM_SMM
 # define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 41ca128478fc..44a8f7e57b77 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -10,6 +10,9 @@
 
 void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
+	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
+	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
+
 	trace_kvm_smm_transition(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
 
 	if (entering_smm) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5959f74c5a0a..910e3757b222 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5092,10 +5092,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 	/* events->sipi_vector is never valid when reporting to user space */
 
+#ifdef CONFIG_KVM_SMM
 	events->smi.smm = is_smm(vcpu);
 	events->smi.pending = vcpu->arch.smi_pending;
 	events->smi.smm_inside_nmi =
 		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
+#endif
 	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
 
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
@@ -8266,8 +8268,6 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 		     cs_db				? X86EMUL_MODE_PROT32 :
 							  X86EMUL_MODE_PROT16;
 	BUILD_BUG_ON(HF_GUEST_MASK != X86EMUL_GUEST_MASK);
-	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
-	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;
-- 
2.31.1

