Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF0A5A723B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiHaAH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHaAHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:07:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE447F081
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:07:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t13-20020a170902e84d00b00174b03be629so5098244plg.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=ibGBauM7dB+b2q4t6hN7wBjsjDMwsLdLonLhHf6UFbI=;
        b=j/esEMEECs5PPWq+WEOufYXO0eWpHu6bcK/vZ9znIN1jActMDhRPM6oJZLrwYix5uW
         KnmP4wBkp62lRCHYn9fyUENvwf7oKtUJCs71aKfIPTtw5m+0p8s7M0jKYzNjFBhZzkzr
         nivtj2rGjoN89JIkZ8PWVRIT5MvNonhnZgcG2NjQ2RkavzqN8N83E6oSIp6sC3+J2IFR
         SATvMwTEtF3kXRNlbONjHLcai/Qo/sF7v5D94IhiRTaI5/kuGpjwTljuGaxD+g6hYc3b
         vrsxL/ks2TVT/oPkRDalO98uttR7zPQm8NozQJMsCYAHuQp/DRUWC5HV+RRD75AirGrG
         VvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=ibGBauM7dB+b2q4t6hN7wBjsjDMwsLdLonLhHf6UFbI=;
        b=XQJCegap0RT+/Mj2ebYVDt02Z5cfMM+uyQcGDMRIIHF5gsQ1um8AQnFuUclnKTCRwN
         DwhU7nQuwtcYV836IjMir4HFKxMx/js0HrDtscg6AKh/MIeOOyB1exMiwFrREPGz1Ui4
         bwMBlQQoI5sCISja1Px9K0w663lKb5/ubCPsqhjQ/KHnCo4ZmwlWf7EtRQ3UkaFSa9iW
         TI6Fs+hnnGnNEr4MT2uaOROUNGGAzSkTdQpannAike5i5bu3iFo8x1OYfpS2yLA2GJ2u
         AIkLP3/bPnpCTYuhI8yzhUzFuBy923LtFQkWaqWd/mvB/sVCtISQRolkFyBfy85RttFU
         7kjg==
X-Gm-Message-State: ACgBeo0JT/GQcN6/amNFMBJIWguuf8QCtMADInmTR93Qgu5foYuwd0af
        zY0XZHcc2KhtM9/moayMDAuripklC9w=
X-Google-Smtp-Source: AA6agR6/bWnv23ydQU/ZUAtt/EE/KOKYUSU+9s4gBIkF4/781UMMDPK9sKLq+MjOlyHSuaze7+7KpZiBZF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1b66:b0:1fa:bbb5:8a5 with SMTP id
 q93-20020a17090a1b6600b001fabbb508a5mr530364pjq.216.1661904443892; Tue, 30
 Aug 2022 17:07:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:07:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831000721.4066617-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Reword comments about generating nested CR0/4 read shadows
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
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

Reword the comments that (attempt to) document nVMX's overrides of the
CR0/4 read shadows for L2 after calling vmx_set_cr0/4().  The important
behavior that needs to be documented is that KVM needs to override the
shadows to account for L1's masks even though the shadows are set by the
common helpers (and that setting the shadows first would result in the
correct shadows being clobbered).

This also fixes a repeated "we we" reported by Jason.

Cc: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++------
 arch/x86/kvm/vmx/nested.h | 7 ++++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..12f57a99f725 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2566,12 +2566,9 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		nested_ept_init_mmu_context(vcpu);
 
 	/*
-	 * This sets GUEST_CR0 to vmcs12->guest_cr0, possibly modifying those
-	 * bits which we consider mandatory enabled.
-	 * The CR0_READ_SHADOW is what L2 should have expected to read given
-	 * the specifications by L1; It's not enough to take
-	 * vmcs12->cr0_read_shadow because on our cr0_guest_host_mask we we
-	 * have more bits than L1 expected.
+	 * Override the CR0/CR4 read shadows after setting the effective guest
+	 * CR0/CR4.  The common helpers also set the shadows, but they don't
+	 * account for vmcs12's cr0/4_guest_host_mask.
 	 */
 	vmx_set_cr0(vcpu, vmcs12->guest_cr0);
 	vmcs_writel(CR0_READ_SHADOW, nested_read_cr0(vmcs12));
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 88b00a7359e4..8b700ab4baea 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -79,9 +79,10 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Return the cr0 value that a nested guest would read. This is a combination
- * of the real cr0 used to run the guest (guest_cr0), and the bits shadowed by
- * its hypervisor (cr0_read_shadow).
+ * Return the cr0/4 value that a nested guest would read. This is a combination
+ * of L1's "real" cr0 used to run the guest (guest_cr0), and the bits shadowed
+ * by the L1 hypervisor (cr0_read_shadow).  KVM must emulate CPU behavior as
+ * the value+mask loaded into vmcs02 may not match the vmcs12 fields.
  */
 static inline unsigned long nested_read_cr0(struct vmcs12 *fields)
 {

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.672.g94769d06f0-goog

