Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9E605211
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 23:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJSVgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiJSVgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 17:36:45 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BF01960AB
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:42 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so9935274pfm.1
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7QiDS3o7OtSH++EKWp9IHQDH2fZMMsrvU3MH16gXhw=;
        b=WqUW4/Cpcf82Yzu0+gO2vnjqwug70LaFUoCjXie3HageWxYCxZR+Xcv1ELvWdVMeyD
         aHY8Mi0JQbubxjXZOpJmE3mafu1q5rrNLMDfm4l355rN3GzLDdtPjG+o+ELr9rWO3mEU
         dHLXUthBRQmXbI7yTC5x6Tsq2CFW8N7Fb8i1Jhl6czONHNy0ORZx6WPpD6llk6KB9Jis
         t7V5Ka4u8b4cdKQJWXlDKJtH7ciAn0lVy1POXa86PRgHVGR4+yRM/tiSVv9+mO6kvBPs
         5peeTNgm6juJMNNkOaisIYvIU7fqwdsR7AinkZmFSwfS0x7Oaibe9V42mS/qwlDcZDec
         QhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7QiDS3o7OtSH++EKWp9IHQDH2fZMMsrvU3MH16gXhw=;
        b=yVIt6Et+hW2j+1kMALMonOwSXGhxiw3GwcQws5HIWRW42V0STYrFPnk4nYpI7/WY01
         qADYh/YBHGPHRfak6WuOmoNBTDK1d7sm/7MbI2Mvntqnt+x038hq9qI1k1wBzf1VzGhY
         Drsi+a7OR4KqPvrqcZDK3fPLkCZ/jVt5uPct7ORqKJl/6aIIRgrtq1Ywq3dRblJUPXQc
         AcN6rybwv6OBDfq9XaXeLn7AMhuy7yOJ2Kj2fBawNm9m9VmzkPVdZJu1IIDG0zsZTK6t
         UJf0RGTJu4Qg8fsJvphz+D/mASQ8l1lNACbRH45SdbeTz5H4eA4unhS+gPLm5jMRR9tU
         Xu7Q==
X-Gm-Message-State: ACrzQf3J7tBzzrAXJoN/0FrPkf9HsLq0ZPR1Ls+lwzFhwklFRiNd1WLo
        yYtEOE7t0HIc+QFwINnEr8XdgKXoGU9k6D4iQN/MUAFk+phJvLrHuMh4GsjtKBn0a1M2AeRZi/O
        1+uVFUOxNVTerNX+SrVQw8hL7/kEvcybbfeT8MYjRkvQJiaDkFL/o6LQy+HoFSQ0=
X-Google-Smtp-Source: AMsMyM4COD7ZeC2496iwzmVGPWySkYkdLrC6qPX+ASZiI348YY0SVF1lNYMt/nmZlCziEnSAGKJwPuvc1wdlNw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:903:2144:b0:182:42ce:5778 with SMTP
 id s4-20020a170903214400b0018242ce5778mr10333406ple.46.1666215390670; Wed, 19
 Oct 2022 14:36:30 -0700 (PDT)
Date:   Wed, 19 Oct 2022 14:36:20 -0700
In-Reply-To: <20221019213620.1953281-1-jmattson@google.com>
Mime-Version: 1.0
References: <20221019213620.1953281-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019213620.1953281-3-jmattson@google.com>
Subject: [PATCH v2 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when guest
 has IBRS
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
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c    |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..cd70ab63e919 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4767,6 +4767,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b092f61b8258..c12fd0ca3ad6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1348,8 +1348,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
-- 
2.38.0.413.g74048e4d9e-goog

