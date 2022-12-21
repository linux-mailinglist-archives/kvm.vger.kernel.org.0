Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380206530C2
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 13:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLUM0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 07:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiLUM0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 07:26:08 -0500
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42B0B0D
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 04:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1671625563;
        bh=wFNhnD3NzmTBl/E3WRuZI7LywtLlUP3cETCmajXFZTU=;
        h=From:To:Cc:Subject:Date;
        b=jeIaI/o1DJ8WUMCms1nnK5ihfhei97zs5I1Qp6+hsGBs1DmoVnUSXKIIizqQkTGCf
         MMJxfg9ndjCCDFvyxSWTCTqD6Qz0MG2Qf9MQHsN561XvlseA4vgKWJIgWHzadZeCLF
         jEvHJuS++wwPBdEp1/MovX8PtBt+1tvExp72TE9U=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
        id 6229AC9C; Wed, 21 Dec 2022 20:24:34 +0800
X-QQ-mid: xmsmtpt1671625474tv1woa6v3
Message-ID: <tencent_31E6ACADCB6915E157CF5113C41803212107@qq.com>
X-QQ-XMAILINFO: M/NR0wiIuy70qs0pG1YAOxMsMstPYRYt/MG1TX1OpkGzw8hC1ywrfOfgUCyQyX
         qdfy1hPFOA6646ti+jbPj30FbaQYPii5k7ExSm3ZNJb9yZH3J53N9Za8u5F0gvf0TtaWruGcR95O
         AcFLcFkPtVMEPBmtnBY+HBMl3kX92xM4AXM3TBjGdzPzAiD7Io8jUXM2eCrXoPVQuIF3XrP+cYv9
         lYS7yLmjGhTfW3wMo6nYgzsbOjZ9adOK0TrpdwIer/5wabf33x2RIKWZYzdc32o7HQrXam1uC2pG
         kapORg7XUCulQ+c4uZh1vfHNc81hkJyDjYJfVK5mL9XiXqGUDh9B1Nl28mZ2goMYRt+SvABi0haM
         iuVT8HMrZ2dvoPJYWmg9bGncL81UNQhiKJcALW5MIZpfWHXaZrOxt07dx9mV/l8BQOsajZFb8HSJ
         SnYI0MsMF1kjDiY4eRqF8FNnJVljCCVfUk4xvwEY6OT5eeOcm/mnQdib9aYWjKfZA9RozhT1jOPZ
         PeWAvys/TLdafyvS2nrWL8oRqYP5O7ovJFm2DWR8ihHJazp1OS6yzXrkAO+fUm3mB41x8e50NVaY
         SSKOC1llUu6M+wYbHOITAVMW/PB5GgHJ8UhFLzqMaBd4PEjlxu2s9VHlkRlbRFECzoJOCxo4ojKK
         6GpOS+T3HRSwcLftRfEa/74oh8BmWE+zVZK6XIqRW++keN6UWHRXzxBpMlfOaVWIRIlvifxojN5R
         dRiTmkGhBZAL3Bp7xHrz8TCkvCWBtVU2osGb9XJBfyHRQm9hMHHQrgY2oG8x6MhUTTbJML+XzDKp
         56YrxY28cQKfQFz3+oQhJ6e2Xid3TBBFNiNQTo4HWbwvnU6comaqTq5AayAIebsajHWaI4W6RPE0
         BEz4iVa+ST9d0RvAf5a2qcOCR2d8Brw0hYfgFRSs+plAlDLMqe3nK3aLBNW+15Lokv42MzhzVIu7
         0mnsFZkNQeSnMXFlEtslzp6eBtfJ9RlqVFTuqC6vg01EtcDv/KoT+MXEDColcq
From:   Rong Tao <rtoax@foxmail.com>
To:     seanjc@google.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, gg@google.com,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rongtao@cestc.cn,
        rtoax@foxmail.com, tglx@linutronix.de, x86@kernel.org
Subject: [PATCH v2] KVM: VMX: Fix indentation coding style issue
Date:   Wed, 21 Dec 2022 20:24:32 +0800
X-OQ-MSGID: <20221221122432.80129-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Code indentation should use tabs where possible.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
v2: KVM: VMX: for case-insensitive searches
v1: https://lore.kernel.org/lkml/tencent_4D21B619F00AE966BD5DD2ABA4BC7A8F060A@qq.com/
---
 arch/x86/kvm/vmx/vmx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..29f0a639e1e7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -806,7 +806,7 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu))
 		eb |= get_vmcs12(vcpu)->exception_bitmap;
-        else {
+	else {
 		int mask = 0, match = 0;
 
 		if (enable_ept && (eb & (1u << PF_VECTOR))) {
@@ -1214,7 +1214,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		}
 	}
 
-    	if (vmx->nested.need_vmcs12_to_shadow_sync)
+	if (vmx->nested.need_vmcs12_to_shadow_sync)
 		nested_sync_vmcs12_to_shadow(vcpu);
 
 	if (vmx->guest_state_loaded)
@@ -4966,10 +4966,10 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
 
-       /*
-        * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
-        * e.g. if the IRQ arrived asynchronously after checking nested events.
-        */
+	/*
+	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
+	 * e.g. if the IRQ arrived asynchronously after checking nested events.
+	 */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
 		return -EBUSY;
 
-- 
2.39.0

