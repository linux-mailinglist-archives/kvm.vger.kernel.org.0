Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2728364A74F
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiLLShy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLLShb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3464212AC5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x6-20020a17090a46c600b002190cdd7bcdso366704pjg.6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YSqdrQG28I/IHf63OMr6wI2/4XSPUdzFe1lSmdr2JI0=;
        b=FSdx2lGZpI0X2xoo3/+4lKtPYr88P6dBa248tKCk25Z1FdlsbOjgSZiHMUfFjySaEt
         dBRRf9l7HPc6IcjstLTa7BRLUDiBmkp8FrLP+94NHgZqecq/pylcmziYbnwU8cWTItrv
         YuWTO7cK6HSPUTIp3NRKOuB33xgeE00MJdbdX6mjDjtVN2t53Kq+KN8orEKY9DDvm33b
         ZrowK8rJzGSqEwMazuFHCQu9PGATOIE/kpayHNe7nKrsc0plWUUu84e70WCgU+bRQ2Ts
         veL9dglRShpBoxQTqc/swjtzRj43YketgKJa5J7HhWJhAEw8rPegWjxqYaNIHuTg8igX
         i6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YSqdrQG28I/IHf63OMr6wI2/4XSPUdzFe1lSmdr2JI0=;
        b=vxenB0FCWK9IKpJSfWjmfMn2nP0S6YXKBazoIWMsTmGOfioih0kdcI3Zl6gqYF0ZN6
         G2M6CcDga3P2InS1j20t4CEKrDCKlzQz/5kHRTiRfscpE+ajcGVezHZu0UdtxQvq52ZN
         3gkxi+upZcmXaa7hw7CAlFo5vFpJ5nt5/PqtFwU78ogIlt4Qm62IeShk92pWhLCG5j2g
         Mb4c3UvF7oiEti/PF88qX4HcqW6gFfb9zspPzpuZ8ShPpGnBg5tVOlxPfrKsFjX/Aj5X
         Wfo2Zmw1ZttcMBrLBMVN5kL2CyuH+4xhrnwcnMJjnwrbHg9eKJvogUBvNd/C3WiMhrku
         gRtg==
X-Gm-Message-State: ANoB5pnOV970ff+B9Em5PVIs7f0aw5sA0LSO6BUDoICHlSrLQWoHerD5
        8IAiVNa18sCq2w3Uxw6Qw5zwvPLaLYSV
X-Google-Smtp-Source: AA0mqf5TZmh7pWHVG/fsQ1d1f+loSNxPyK6S9L9Z33d6vuaY0DC08TR1fKVvRuvWrxEJE86SoGXmsVG5IgoM
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:9389:0:b0:576:cee7:41b0 with SMTP id
 t9-20020aa79389000000b00576cee741b0mr21757354pfe.76.1670870249793; Mon, 12
 Dec 2022 10:37:29 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:11 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-5-vipinsh@google.com>
Subject: [Patch v4 04/13] KVM: selftests: Rename 'msr->available' to
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
2.39.0.rc1.256.g54fd8350bd-goog

