Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8018F473A1E
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbhLNBSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 20:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 20:18:54 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D39BC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:54 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso10908208pjf.9
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 17:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R8GOKUJD5KjxnzxKOwN2AHS+VSxxmSefbq0jTCQOOEQ=;
        b=M6rUvCcSGYuIzqsJM0SRdqwWtvnGvzceknHH2Qau5Quv1Fel/aPljQBlWjQ4puHdR8
         cD0yqjpIqiV6X0cHkeuzoWvDOF4aVgxhO/95VWBoV3NRFicTpNUtFoFDUO+v6sZPdcPv
         kbf94lw0D++c+MnASm9vuUPhS1YrjW/z5/Ao3ON91zhv1//1fPykcbKoZVrmvh+ZJAb0
         CetKKdbsEXzqWX+aPAObT6ax9CG6gxppRPPi69RTirZ10WXvCvDloGGVPXJxxlQYCD8M
         Zq9eIRo3Zfe84BLcmyslsd7COWZo2bkomMOPIaX+JTYaEJCOFvuEEqPuZ0f5rTDADe49
         nqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R8GOKUJD5KjxnzxKOwN2AHS+VSxxmSefbq0jTCQOOEQ=;
        b=Sw8NooRzp1MR2/KlpEmlTcjsGapLCok/mU1u2Ji0EnrInArQY+kGHkZUNDrpMjLC+L
         BYaf0dgEihBUPX+EMkjmTFlsk4y0ksl3hjjh5NrOLvbEWjksxwEGhSnstjHearMShc29
         3o1CHAk3McoI7nNV3EmFVnsDeb4XUIM1FmEgwybcy90VQpsNVPirXYX/57avuuh3hbAi
         Waz3JkUiaFrDppIai3XNeKCzd5RihsbFKL2HdMng3hih62FjVcmlTtUI/jBkaoe991Rx
         yYRsPMDsAaE4QW+FEPX+tOQVBjnxiLx+VojXM7O0T94AAEujg6c8BlFE9Ug/GKzKn1Xj
         6Q/w==
X-Gm-Message-State: AOAM530sEXEPeYvYVvrhDdk8H1oST9/ni1WHOjf3VQKM1JzaxXPuvO2F
        AmoZvJz+jNaDG9xqE7snv8mgfuZxHS7dgbxRAvg7FvUUQkflJrc3eEn3igC/SMZFP4jE5uw9mGh
        fhm/T4t4JfezrP3/MC3Y8A0/qxY0A+432yLa9kD6kI0MTqX9u3IjYMIZBdycw+KN8Vet0
X-Google-Smtp-Source: ABdhPJwGftOJYUnGVYIhOV3ymgUlIz+rKRjqMn701Ecxlz6I8CTZFe7+fWv/XUiYpLKbAGvoSv+RJnPb2f/oF5S/
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:1c5:b0:141:fbe2:56c1 with SMTP
 id e5-20020a17090301c500b00141fbe256c1mr1953589plh.52.1639444733544; Mon, 13
 Dec 2021 17:18:53 -0800 (PST)
Date:   Tue, 14 Dec 2021 01:18:23 +0000
In-Reply-To: <20211214011823.3277011-1-aaronlewis@google.com>
Message-Id: <20211214011823.3277011-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211214011823.3277011-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH v2 4/4] x86: Add test coverage for
 nested_vmx_reflect_vmexit() testing
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add test cases to ensure exceptions that occur in L2 are forwarded to
the correct place.  Add testing for exceptions: #GP, #UD, #DE, #DB, #BP,
and #AC.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx_tests.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 018db2f..f795330 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -21,6 +21,7 @@
 #include "smp.h"
 #include "delay.h"
 #include "access.h"
+#include "x86/usermode.h"
 
 #define VPID_CAP_INVVPID_TYPES_SHIFT 40
 
@@ -10701,6 +10702,72 @@ static void vmx_pf_vpid_test(void)
 	__vmx_pf_vpid_test(invalidate_tlb_new_vpid, 1);
 }
 
+static void vmx_l2_gp_test(void)
+{
+	*(volatile u64 *)NONCANONICAL = 0;
+}
+
+static void vmx_l2_ud_test(void)
+{
+	asm volatile ("ud2");
+}
+
+static void vmx_l2_de_test(void)
+{
+	asm volatile (
+		"xor %%eax, %%eax\n\t"
+		"xor %%ebx, %%ebx\n\t"
+		"xor %%edx, %%edx\n\t"
+		"idiv %%ebx\n\t"
+		::: "eax", "ebx", "edx");
+}
+
+static void vmx_l2_bp_test(void)
+{
+	asm volatile ("int3");
+}
+
+static void vmx_db_init(void)
+{
+	enable_tf();
+}
+
+static void vmx_db_uninit(void)
+{
+	disable_tf();
+}
+
+static void vmx_l2_db_test(void)
+{
+}
+
+static uint64_t usermode_callback(void)
+{
+	/* Trigger an #AC by writing 8 bytes to a 4-byte aligned address. */
+	asm volatile(
+		"sub $0x10, %rsp\n\t"
+		"movq $0, 0x4(%rsp)\n\t"
+		"add $0x10, %rsp\n\t");
+
+	return 0;
+}
+
+static void vmx_l2_ac_test(void)
+{
+	u64 old_cr0  = read_cr0();
+	u64 old_rflags = read_rflags();
+	bool raised_vector = false;
+
+	write_cr0(old_cr0 | X86_CR0_AM);
+	write_rflags(old_rflags | X86_EFLAGS_AC);
+
+	run_in_user(usermode_callback, AC_VECTOR, 0, 0, 0, 0, &raised_vector);
+	report(raised_vector, "#AC vector raised from usermode in L2");
+
+	write_cr0(old_cr0);
+	write_rflags(old_rflags);
+}
+
 struct vmx_exception_test {
 	u8 vector;
 	void (*guest_code)(void);
@@ -10709,6 +10776,12 @@ struct vmx_exception_test {
 };
 
 struct vmx_exception_test vmx_exception_tests[] = {
+	{ GP_VECTOR, vmx_l2_gp_test },
+	{ UD_VECTOR, vmx_l2_ud_test },
+	{ DE_VECTOR, vmx_l2_de_test },
+	{ DB_VECTOR, vmx_l2_db_test, vmx_db_init, vmx_db_uninit },
+	{ BP_VECTOR, vmx_l2_bp_test },
+	{ AC_VECTOR, vmx_l2_ac_test },
 };
 
 static u8 vmx_exception_test_vector;
-- 
2.34.1.173.g76aa8bc2d0-goog

