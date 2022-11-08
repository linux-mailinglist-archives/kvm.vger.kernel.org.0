Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8E6217ED
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiKHPSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbiKHPRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:17:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2322859FC5
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 07:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cr2jmTtt8Ake5OU8pjUtzSkMz+I+1JsR/QXu4X/Lkso=;
        b=H2aH7aZuiJIzFy1IyTZBAox2/oQ0juVV+0HjJ4Ak+QVeQAtVSnnl7rvdoUkn6xO17oY3Wz
        NK3WmKNkPnq0G8deirXeyMa6W8yzZ3YfihPtAIKX3bKnDMGGNify/7ctJ3uOvB7fDF40Wb
        XpittPJw2EgOhjQcK+q7uex/EcIMZiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-zpRARqi3OF-vVOF4jj319g-1; Tue, 08 Nov 2022 10:15:36 -0500
X-MC-Unique: zpRARqi3OF-vVOF4jj319g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50B28858F13;
        Tue,  8 Nov 2022 15:15:35 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AE4E40C6FA3;
        Tue,  8 Nov 2022 15:15:35 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com
Subject: [PATCH v2 8/8] x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and callers
Date:   Tue,  8 Nov 2022 10:15:32 -0500
Message-Id: <20221108151532.1377783-9-pbonzini@redhat.com>
In-Reply-To: <20221108151532.1377783-1-pbonzini@redhat.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
index 512bc06a4ba1..e6706fd88cfa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3998,7 +3998,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * being speculatively taken.
 	 */
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
@@ -4006,7 +4006,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		reload_tss(vcpu);
 
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(vcpu->kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
-- 
2.31.1

