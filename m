Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0221E643189
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiLETP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiLETOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:54 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BA824096
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id l2-20020a17090add8200b00218daa1a812so10007994pjv.3
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=donvtmRXhJx6Qdl50uwZ2nazOP14VAH1UfTJOeFekzk=;
        b=Gjk/kte37ihLGZ4QnRHQ9zR9cyytJcoNRvAup/HT8Pe1cMJYWkBTXLQsffGvHiRJhJ
         q5ncz+G1695JZ3Q5d9AvRFOpVq2YECCbMO4xFpxHwC+B8kc00Fy8t1Cvo9SR7lSAeOL8
         0edPl3U66aoxAD7i9iu+6VmQ2F83pCiZnWdq4Z4bollkfTGUXivvaub00o4knCi8B4Ly
         eR9GSIBMFrfI12o+i8LfmviIasGo+uCe0gsd4XpeqR2JSICjG9fGFcyRv4xTKx76z68c
         RS4iTvOVDEtxwK/SjUoldLtCvIcpEwjb3OzfX8cpSPu8tZ7afeNVb5AhOKNRBrLJukmp
         EmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=donvtmRXhJx6Qdl50uwZ2nazOP14VAH1UfTJOeFekzk=;
        b=O4r8m0yvJEEd2SkTIo9CYg7ksxIw+E1pohLB/ltqPSeXdda2u2iUPoGw2woCuLLDy6
         7XKuGjW1hANBy4oz4tyNteAnGLfs+MRnPv3NpnW8t/Qj4jEAuVWag3Avd4poCfJXXNkl
         qnhNnF9PusHYXr73r8dUzy7w68mSgHd+JR/kpCPFwo0xZJNyal0X6Q1h7XImEYYiGgC+
         vtDtXeBCevC+2Fz53xD2SniTPSpDnIU7Y8kZLsthurd1cd2tZvlnWDDxVlDnAKJ5kyRQ
         Poq32iTn29dvRZTpCHU8PhwcJUUAiYtFNKoHHSPxN2rwjuQzXu02gcHq4rHhKSdNJHvP
         XF1g==
X-Gm-Message-State: ANoB5pnCduac3Z8T3oqw3GHQR6PGEKCv5E1Y+f5klus0cGZLgR+GtNMU
        fr4ZcqkAHqZXZrQ3xx1AvwI5v3kgNugQ
X-Google-Smtp-Source: AA0mqf77JBd1YGv1XrWKNVQpUpOM872FQObe7gzf4L/qUUKxH/3cX+wPN2688LF2ssoH9u+eLdO/CGnMVPI6
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:507:b0:213:7030:f6c1 with SMTP id
 r7-20020a17090b050700b002137030f6c1mr94445012pjz.184.1670267686465; Mon, 05
 Dec 2022 11:14:46 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:21 -0800
In-Reply-To: <20221205191430.2455108-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-5-vipinsh@google.com>
Subject: [Patch v3 04/13] KVM: selftests: Rename 'msr->available' to
 'msr->fault_exepected' in hyperv_features test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

It may not be clear what 'msr->available' means. The test actually
checks that accessing the particular MSR doesn't cause #GP, rename
the variable accordingly.

While on it, use 'true'/'false' instead of '1'/'0' for 'write'/
'fault_expected' as these are boolean.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 184 +++++++++---------
 1 file changed, 92 insertions(+), 92 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 3163c3e8db0a..4cf1368af48a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -15,7 +15,7 @@
 
 struct msr_data {
 	uint32_t idx;
-	bool available;
+	bool fault_expected;
 	bool write;
 	u64 write_val;
 };
@@ -38,10 +38,10 @@ static void guest_msr(struct msr_data *msr)
 	else
 		vector = wrmsr_safe(msr->idx, msr->write_val);
 
-	if (msr->available)
-		GUEST_ASSERT_2(!vector, msr->idx, vector);
-	else
+	if (msr->fault_expected)
 		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
+	else
+		GUEST_ASSERT_2(!vector, msr->idx, vector);
 	GUEST_DONE();
 }
 
@@ -134,13 +134,13 @@ static void guest_test_msrs_access(void)
 			 * Only available when Hyper-V identification is set
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 1:
 			msr->idx = HV_X64_MSR_HYPERCALL;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 2:
 			feat->eax |= HV_MSR_HYPERCALL_AVAILABLE;
@@ -149,118 +149,118 @@ static void guest_test_msrs_access(void)
 			 * HV_X64_MSR_HYPERCALL available.
 			 */
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = HYPERV_LINUX_OS_ID;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 		case 3:
 			msr->idx = HV_X64_MSR_GUEST_OS_ID;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 4:
 			msr->idx = HV_X64_MSR_HYPERCALL;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 
 		case 5:
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 6:
 			feat->eax |= HV_MSR_VP_RUNTIME_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 7:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_RUNTIME;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 
 		case 8:
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 9:
 			feat->eax |= HV_MSR_TIME_REF_COUNT_AVAILABLE;
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 10:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TIME_REF_COUNT;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 
 		case 11:
 			msr->idx = HV_X64_MSR_VP_INDEX;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 12:
 			feat->eax |= HV_MSR_VP_INDEX_AVAILABLE;
 			msr->idx = HV_X64_MSR_VP_INDEX;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 13:
 			/* Read only */
 			msr->idx = HV_X64_MSR_VP_INDEX;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 
 		case 14:
 			msr->idx = HV_X64_MSR_RESET;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 15:
 			feat->eax |= HV_MSR_RESET_AVAILABLE;
 			msr->idx = HV_X64_MSR_RESET;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 16:
 			msr->idx = HV_X64_MSR_RESET;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 17:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 18:
 			feat->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 19:
 			msr->idx = HV_X64_MSR_REFERENCE_TSC;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 20:
 			msr->idx = HV_X64_MSR_EOM;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 21:
 			/*
@@ -268,146 +268,146 @@ static void guest_test_msrs_access(void)
 			 * capability enabled and guest visible CPUID bit unset.
 			 */
 			msr->idx = HV_X64_MSR_EOM;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 22:
 			feat->eax |= HV_MSR_SYNIC_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOM;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 23:
 			msr->idx = HV_X64_MSR_EOM;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 24:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 25:
 			feat->eax |= HV_MSR_SYNTIMER_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 26:
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 		case 27:
 			/* Direct mode test */
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1 << 12;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 		case 28:
 			feat->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 			msr->idx = HV_X64_MSR_STIMER0_CONFIG;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1 << 12;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 29:
 			msr->idx = HV_X64_MSR_EOI;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 30:
 			feat->eax |= HV_MSR_APIC_ACCESS_AVAILABLE;
 			msr->idx = HV_X64_MSR_EOI;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 31:
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 32:
 			feat->eax |= HV_ACCESS_FREQUENCY_MSRS;
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 33:
 			/* Read only */
 			msr->idx = HV_X64_MSR_TSC_FREQUENCY;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 
 		case 34:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 35:
 			feat->eax |= HV_ACCESS_REENLIGHTENMENT;
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 36:
 			msr->idx = HV_X64_MSR_REENLIGHTENMENT_CONTROL;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 		case 37:
 			/* Can only write '0' */
 			msr->idx = HV_X64_MSR_TSC_EMULATION_STATUS;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 0;
+			msr->fault_expected = true;
 			break;
 
 		case 38:
 			msr->idx = HV_X64_MSR_CRASH_P0;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 39:
 			feat->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
 			msr->idx = HV_X64_MSR_CRASH_P0;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 40:
 			msr->idx = HV_X64_MSR_CRASH_P0;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 1;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 41:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
-			msr->write = 0;
-			msr->available = 0;
+			msr->write = false;
+			msr->fault_expected = true;
 			break;
 		case 42:
 			feat->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
 			dbg->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
-			msr->write = 0;
-			msr->available = 1;
+			msr->write = false;
+			msr->fault_expected = false;
 			break;
 		case 43:
 			msr->idx = HV_X64_MSR_SYNDBG_STATUS;
-			msr->write = 1;
+			msr->write = true;
 			msr->write_val = 0;
-			msr->available = 1;
+			msr->fault_expected = false;
 			break;
 
 		case 44:
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

