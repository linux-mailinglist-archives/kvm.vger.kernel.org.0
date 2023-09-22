Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEAA7AB635
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjIVQm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjIVQmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:42:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FE7122
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f1be93bd4so22572797b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400966; x=1696005766; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gS/EQHYi/KQyzYHqX4dTpWj9wynOrPY51BidveykKDI=;
        b=ZDfrko/qlPaFPByPuWJuhdfyYYJopvM4dl0N8WYwCtEBnRdyLk211dv+qufZ7IKfZV
         xjdl/Q2H2wdu2LCH4MAPf71Ehtj88w+s0sgWyxvsGeNdGDvsUSSrdF2vE4K3ErB8b7rJ
         +LzDR6VJpcbVxXa6NU7ZrKNSvg2GkQGz6+qUKT3PMhkyfJK6aX9AGdtKsA1iidD7guj5
         SCGgLwCyU8HQQjtfG/IlgDdlhbChbfDno0p6fby1sjtgW9weiHIlxqw9XSAGRilGgPMJ
         yGBhJeFAqkk3EHstMIrNvdQd2xuvrRtyfADrob9vN8nA4AH/7WeuT1dx2GPHKHVvc+K/
         lGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400966; x=1696005766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gS/EQHYi/KQyzYHqX4dTpWj9wynOrPY51BidveykKDI=;
        b=CKGIhVy5NaqzPGTRi7zv8EuIUfXtzmygfLANsq4jxylb/NPND9Nb4mWIncA6/p7Ewp
         D22SMTc3fshmtbl3xtOX6QK4LpYRnoEJmQTdAp9lfDnuTgNLfpxDgzkGuHQn48oBZ0e9
         cFaTobahhQhtNoL4xM1CBUOpvfvKy+4b86JiDAyLngakMBjYHX+tqZKCi2Q38ixW099j
         cImKfkZETCBzG220H3fqV1CLOvXCAzkuUyKllPWNQ1aRVRK5ixdmYXDi8u+xZV0Q+h4v
         QVrQqKu/W0q1oYWn2/znopsKXgA2CY6lZ2XRSvE4EpZTukNbl/JqiE8wTVJ36xgrbEvv
         n9fw==
X-Gm-Message-State: AOJu0YxMgsr0RcLKyM6gxhdeFEf05qhjg+IXig9UW3QDTLTnr9utapVW
        OY1+UciR0MXsbdyfbxaaDCrhv3R5vNm5+VHsnNMlUYfqRVz/X5N4LsuMnuBkytnJcTKIRuEBL6m
        /Z7pI7sBOqAyKAAsgwKunbOmjog953lWIKhAhuCN51jXhivYkWqjUWaYpN+XmViY=
X-Google-Smtp-Source: AGHT+IHwrJwHgk5OOWHGMByRAntOMRr0FoHbgHj6vlHWJyoSGD/rVZXIv7s7YAOYiVhj6dgCIDqLYFpkFiWWGA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:e30d:0:b0:59b:fe3b:411 with SMTP id
 q13-20020a81e30d000000b0059bfe3b0411mr4242ywl.2.1695400966353; Fri, 22 Sep
 2023 09:42:46 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:42:38 -0700
In-Reply-To: <20230922164239.2253604-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230922164239.2253604-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230922164239.2253604-2-jmattson@google.com>
Subject: [PATCH 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
set. If it isn't set, they complain:
	[Firmware Bug]: TSC doesn't count with P0 frequency!

Eliminate this complaint by setting the bit on virtual processors for
which Linux guests expect it to be set.

Note that this bit is read-only on said processors.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 10 ++++++++++
 arch/x86/kvm/x86.c   |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..2d7dcd13dcc3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -373,6 +373,16 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
+	/*
+	 * HWCR.TscFreqSel[bit 24] has a reset value of 1 on some processors.
+	 */
+	if (guest_cpuid_is_amd_or_hygon(vcpu) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_CONSTANT_TSC) &&
+	    (guest_cpuid_family(vcpu) > 0x10 ||
+	     (guest_cpuid_family(vcpu) == 0x10 &&
+	      guest_cpuid_model(vcpu) >= 2)))
+		vcpu->arch.msr_hwcr |= BIT(24);
+
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3421ed7fcee0..cb02a7c2938b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3699,12 +3699,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
+		data &= ~(u64)0x1000000;/* ignore TscFreqSel */
 
 		/* Handle McStatusWrEn */
 		if (data & ~BIT_ULL(18)) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+
+		/*
+		 * When set, TscFreqSel is read-only. Attempts to
+		 * clear it are ignored.
+		 */
+		data |= vcpu->arch.msr_hwcr & BIT_ULL(24);
 		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
-- 
2.42.0.515.g380fc7ccd1-goog

