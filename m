Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83535A72B6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiHaAhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiHaAgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F574A6C59
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m11-20020a17090a3f8b00b001fabfce6a26so5539312pjc.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=nNU9Bjqf9y2XiX7CZGxt5LtQZtYEQ0fRI0M+3kQYHd8=;
        b=nsUDSLmwiz2YIjGoJDWf0sAGexBLRtBGLNj+U0a0dxwdRSnDUJLZ/s81wWgXfPmfZC
         rcingM4u7HvJFWTBgWJYoy47ughU9OZmQ69i4DqRXTjNGW5TUGJAtBm24vA2koy20Z+W
         WFEt7S4TUlpmlrrMirREsdRXHPp3qTniXB67PD3UFg+egTtgi3vDgy/lBQtl6fgp7K4x
         na1upEaIRDzqldfvv3xrkoqoEluOHkX+4ctoSit8dSJRwikX9HoU6EP+/3rhGXZRoUT0
         VfANzt47NFBIqN5xekmNQ7zAiDzyfupSXNkPPIW9bVZcUW6gXapvsysItmRXJxYhCoqs
         hACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=nNU9Bjqf9y2XiX7CZGxt5LtQZtYEQ0fRI0M+3kQYHd8=;
        b=fvv2VhCNXyEpPbaGEveceN74jdn+WwmdFCROxRScTK8yHGf9gj1PnH4Sz9iVs0zEQZ
         lbzd9HRsrfVlqLAKusocpagtqJ7VTjKdMaSUFpZnwiRx7EM2CLTqdL3Uh8H6Fe1RpGW3
         UhL49lO8L9XJtb6YowDNHHKpC/r5zGDFmRk9fbxNkEvoO1y7G/osm4NStk0bDcmmoHRW
         hPp4JWCfVN1MPHWrWXoHDjWQIG7mEVI+srvWFsaP8auz4zZNwCoSRY5lPMoV1XIJQpl6
         hC/QCwI9TBmlH9mtOJoyvkDJ1WeGamkPpwjdJ8Bd8WNpMIbAsbiOETIeoGjcTqFIIT6y
         baZw==
X-Gm-Message-State: ACgBeo0fr49NZMBB2A2o1Hxk7NMF+V7AGNpQSbVRYVmbFCvpcsFDpB7d
        J0369aKJZ7D7xBVKF9eYt9jj8m2hm/k=
X-Google-Smtp-Source: AA6agR6iq5WY+NgNU9ERXKVNHlEQ6M1HBHY81ehzHMF+0tkMrIik4W+FhStuptJ4GRhrcOxrXoHTiMQFa3I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:124d:b0:538:295a:1c47 with SMTP id
 u13-20020a056a00124d00b00538295a1c47mr13357367pfi.5.1661906114650; Tue, 30
 Aug 2022 17:35:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:50 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-4-seanjc@google.com>
Subject: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove SVM's so called "hybrid-AVIC mode" and reinstate the restriction
where AVIC is disabled if x2APIC is enabled.  The argument that the
"guest is not supposed to access xAPIC mmio when uses x2APIC" is flat out
wrong.  Activating x2APIC completely disables the xAPIC MMIO region,
there is nothing that says the guest must not access that address.

Concretely, KVM-Unit-Test's existing "apic" test fails the subtests that
expect accesses to the APIC base region to not be emulated when x2APIC is
enabled.

Furthermore, allowing the guest to trigger MMIO emulation in a mode where
KVM doesn't expect such emulation to occur is all kinds of dangerous.

Tweak the restriction so that it only inhibits AVIC if x2APIC is actually
enabled instead of inhibiting AVIC is x2APIC is exposed to the guest.

This reverts commit 0e311d33bfbef86da130674e8528cc23e6acfe16.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm/avic.c         | 21 ++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..1f51411f3112 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1128,6 +1128,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_PIT_REINJ,
 
+	/*
+	 * AVIC is inhibited because the vCPU has x2apic enabled and x2AVIC is
+	 * not supported.
+	 */
+	APICV_INHIBIT_REASON_X2APIC,
+
 	/*
 	 * AVIC is disabled because SEV doesn't support it.
 	 */
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f3a74c8284cb..1d516d658f9a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -71,22 +71,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-
-	/* Note:
-	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
-	 * MSR accesses, while interrupt injection to a running vCPU
-	 * can be achieved using AVIC doorbell. The AVIC hardware still
-	 * accelerate MMIO accesses, but this does not cause any harm
-	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
-	 */
-	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
-	    avic_mode == AVIC_MODE_X2) {
+	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
-		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
@@ -537,6 +527,14 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu))
 		return APICV_INHIBIT_REASON_NESTED;
+
+	/*
+	 * AVIC must be disabled if x2AVIC isn't supported and the guest has
+	 * x2APIC enabled.
+	 */
+	if (avic_mode != AVIC_MODE_X2 && apic_x2apic_mode(vcpu->arch.apic))
+		return APICV_INHIBIT_REASON_X2APIC;
+
 	return 0;
 }
 
@@ -993,6 +991,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV)      |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
-- 
2.37.2.672.g94769d06f0-goog

