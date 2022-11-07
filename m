Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8AB61F6E4
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 15:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiKGO5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 09:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiKGO4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 09:56:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3BA1DF3A
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 06:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cVbwk+9xr1sKrFlNTxQjNZzM0TkSy1dde/13PKXshmM=;
        b=GN2hGodP/e31qXJ57eswVh6BqyixZ9JQs5BLVXPUiX1WJYSqXmFsfEeeRfFMWij7ax+4H0
        PX3JdKekKqM4KZZ6EGNPKWOEkCVAZLotOr5Zp8EiJhiEBCY4q1ro1sxe/z20hMTlRXVEdk
        0rAcQYAsJwg8Ff+h+MO68mGUbyFTvFI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-d3sgd_FoNjyzGs34KLc8ZA-1; Mon, 07 Nov 2022 09:54:40 -0500
X-MC-Unique: d3sgd_FoNjyzGs34KLc8ZA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC8593826A43;
        Mon,  7 Nov 2022 14:54:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 786872024CB7;
        Mon,  7 Nov 2022 14:54:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com
Subject: [PATCH 8/8] x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and callers
Date:   Mon,  7 Nov 2022 09:54:36 -0500
Message-Id: <20221107145436.276079-9-pbonzini@redhat.com>
In-Reply-To: <20221107145436.276079-1-pbonzini@redhat.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_virt_spec_ctrl only deals with the paravirtualized
MSR_IA32_VIRT_SPEC_CTRL now and does not handle MSR_IA32_SPEC_CTRL
anymore; remove the corresponding, unused argument.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/spec-ctrl.h | 10 +++++-----
 arch/x86/kernel/cpu/bugs.c       |  2 +-
 arch/x86/kvm/svm/svm.c           |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec-ctrl.h
index 5393babc0598..cb0386fc4dc3 100644
--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -13,7 +13,7 @@
  * Takes the guest view of SPEC_CTRL MSR as a parameter and also
  * the guest's version of VIRT_SPEC_CTRL, if emulated.
  */
-extern void x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool guest);
+extern void x86_virt_spec_ctrl(u64 guest_virt_spec_ctrl, bool guest);
 
 /**
  * x86_spec_ctrl_set_guest - Set speculation control registers for the guest
@@ -24,9 +24,9 @@ extern void x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bo
  * Avoids writing to the MSR if the content/bits are the same
  */
 static inline
-void x86_spec_ctrl_set_guest(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
+void x86_spec_ctrl_set_guest(u64 guest_virt_spec_ctrl)
 {
-	x86_virt_spec_ctrl(guest_spec_ctrl, guest_virt_spec_ctrl, true);
+	x86_virt_spec_ctrl(guest_virt_spec_ctrl, true);
 }
 
 /**
@@ -38,9 +38,9 @@ void x86_spec_ctrl_set_guest(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
  * Avoids writing to the MSR if the content/bits are the same
  */
 static inline
-void x86_spec_ctrl_restore_host(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl)
+void x86_spec_ctrl_restore_host(u64 guest_virt_spec_ctrl)
 {
-	x86_virt_spec_ctrl(guest_spec_ctrl, guest_virt_spec_ctrl, false);
+	x86_virt_spec_ctrl(guest_virt_spec_ctrl, false);
 }
 
 /* AMD specific Speculative Store Bypass MSR data */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6ec0b7ce7453..3e3230cccaa7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -200,7 +200,7 @@ void __init check_bugs(void)
  * MSR_IA32_SPEC_CTRL for SSBD.
  */
 void
-x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
+x86_virt_spec_ctrl(u64 guest_virt_spec_ctrl, bool setguest)
 {
 	u64 guestval, hostval;
 	struct thread_info *ti = current_thread_info();
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 31aa158a2e10..e95684cbc194 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3999,7 +3999,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * being speculatively taken.
 	 */
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
@@ -4007,7 +4007,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		reload_tss(vcpu);
 
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(vcpu->kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
-- 
2.31.1

