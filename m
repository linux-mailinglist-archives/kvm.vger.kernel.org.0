Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29D05EEA4F
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiI1XyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiI1Xx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:53:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D610310B59B
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:53:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t6-20020a25b706000000b006b38040b6f7so12404507ybj.6
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Ob7gfIcKgzej/uyyP5wcgDApkDIxQuqnGzwRMYlUfak=;
        b=JGHp81QitZAE+9E/3QnxV3DYUuhWNZiBDrcOP2qg4NMLmgEgWCfkM3X5BmuLt7RDO0
         Ye5hfndUcCC7Rk7ZUbH30lYhXX7GZvzwM8WBhPdGBXY7/I5ZgFuTrzulEWqMMU5nDQgy
         PiagZRZgPg3rKPB0/YC993IDdk8vuq2bhZQGVoO5fqTTvv6zluG8s0PHEhURenwqs/pK
         aGi3oKaGBkvA7s/+S1dCmtDHPg47wZVUhLBtyOHhmxCr+uIWEXbtUleTmqlcltZIuPdc
         TtbgSRTP5uyJlbXKkaXUvrf4vn3tZWxoEwqXI7b/j2twNnbW+hQIywgKCXV6OI0GI747
         LGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ob7gfIcKgzej/uyyP5wcgDApkDIxQuqnGzwRMYlUfak=;
        b=LZcAEftcntYyf3HB1fGd99Vt/IFucw5S9XCzavEOVNriMjn3n8aO0cIZQFi8afxtpP
         Rdy1WZS4J3JkSVWjcYEt8cdWbv6ypR0h+abqDXW8UPbTJpHDaVkpLce9f6WA8PXvLzNl
         kB+VPSeQfApFhxL/jp2Ol872FBkJnaa28KyY8m+rzqXA7Y3uxOu7XhWxV7pJFl7tKwU8
         hHipzFXUd0FswuaglTizmMfoeBve8wCFvxihfMqVXMd0IyRNa5VVHIBjfGlb95sVvHMp
         IPIJfH1lY2pEId9hyWlVnuDVVQ4XTRl8glL62W3tbycGckPb5k0XpLuflknx3d+ao4Wu
         a+dA==
X-Gm-Message-State: ACrzQf3ROdgBpl0caEU533oa/mFPznk3lIhCWHe/9nx6ARiKtRtzGGjC
        y3zlGUd8H5O0cBl9vnsPwN61cLy05L2uFIuQH5ViHmtIliQe/k7lNxDasiL9nVPQ3xF4TdfDi63
        AUo1EL0A4NB6TgYhCdeeVyehqaXOdGIbIvcu5Ub6iNVR3weQlPEWz2qV8LENRpvQ=
X-Google-Smtp-Source: AMsMyM7m/gEsQdOSa+TMPifR/nd3X6jcuty4Z0sT0vivy3eulFG9DuDMJq4LEnVQydJGY9NgzmxjkXwSPASsIA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:bd14:0:b0:6b0:2499:7cf7 with SMTP id
 f20-20020a25bd14000000b006b024997cf7mr576574ybk.411.1664409238080; Wed, 28
 Sep 2022 16:53:58 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:53:51 -0700
In-Reply-To: <20220928235351.1668844-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220928235351.1668844-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928235351.1668844-2-jmattson@google.com>
Subject: [PATCH 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Intel's document on Indirect Branch Restricted
Speculation, "Enabling IBRS does not prevent software from controlling
the predicted targets of indirect branches of unrelated software
executed later at the same predictor mode (for example, between two
different user applications, or two different virtual machines). Such
isolation can be ensured through use of the Indirect Branch Predictor
Barrier (IBPB) command." This applies to both basic and enhanced IBRS.

Since L1 and L2 VMs share hardware predictor modes (guest-user and
guest-kernel), hardware IBRS is not sufficient to virtualize
IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
hardware IBRS is actually sufficient in practice, even though it isn't
sufficient architecturally.)

For virtual CPUs that support IBRS, add an indirect branch prediction
barrier on emulated VM-exit, to ensure that the predicted targets of
indirect branches executed in L1 cannot be controlled by software that
was executed in L2.

Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
perform the IBPB at emulated VM-exit regardless of the current
IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
clear at emulated VM-exit.

This is CVE-2022-2196.

Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c    | 8 +++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..87993951fe47 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4604,6 +4604,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * For virtual IBRS, we have to flush the indirect branch
+	 * predictors, since L1 and L2 share hardware predictor
+	 * modes.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ffe552a82044..bf8b5c9c56ae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1347,9 +1347,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		vmcs_load(vmx->loaded_vmcs->vmcs);
 
 		/*
-		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * No indirect branch prediction barrier needed when
+		 * switching the active VMCS within a guest, except
+		 * for virtual IBRS. To minimize the number of IBPBs
+		 * executed, the one to support virtual IBRS is
+		 * handled specially in nested_vmx_vmexit().
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
-- 
2.37.3.998.g577e59143f-goog

