Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D583E0020
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhHDLZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 07:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbhHDLZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 07:25:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114F3C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 04:25:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso3679263wms.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 04:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QeEtZETYB6C6EGi+j/6AKpDbpAcdQaekkMXsKFAiXbc=;
        b=Jsstn/m6fC3sozrQLIfAIditIaTso1kpDax9AXTItnsJ67phCLE5lLXPuceFgqwERT
         RQIVr9J8J30dLXwB0JUBq84pylsjWdgrpDkzL5LXlWGdhCFgYycEN1//wfPtU2gXHI4t
         DWcYJQye56821EO+yd32RJ+5cWU5wmtsmopGFtlEJRr8O5hDeT4nSBltkY8hpmDAUeSd
         Fn+dtOyy5kVoBGmAbrqnn6PltyAQaNn9S/vf9HvawvLq11mjTP9CQ41LhqClvMndHt1d
         IGxxjollix14PEWi/8EtjuNGmEKzNldmydO7HC4yPpOKdX8+C59UwSOq3+W4NOyIln5z
         IC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QeEtZETYB6C6EGi+j/6AKpDbpAcdQaekkMXsKFAiXbc=;
        b=lEui2J6KlCZg9ArF8Tbqt6+VW5WJduU4jwDUwZUrCfok4/2h31g8Owa+myhNAImSND
         IHVsFZ71odwldeDwZ/S1O21tyMkU729IvOSIvIppsB0MNMJLa8BxwXcvYDTWDWHDhbPt
         XIBL68c3XNkVunHre4ExAFoTAtcEhM4KQ1aaH2c6o3O3WLLDjRbqlU3gL569nJKtL9Jr
         QB1j1BuABa97pPViuocSiUZx3uZoFamCuRcX+gg7CwFeCh0wi903vz0P6tfQr8t+TZYi
         8TcqWx7d3pUH22VYK4MMfsgIrGT3vWbrgMEFBHprVSJceH9xwdEelUeCYy0Au2Yiew/g
         Ao9w==
X-Gm-Message-State: AOAM532HTUcKPQhchDy7C1+TNvOfZaZgQmD6s3POzFn5lqkXT/f4PqKg
        179KjxnbvkbSc84DBnqbqVE8LBDLRL1mYvIx/Bs=
X-Google-Smtp-Source: ABdhPJzax2AvCCmUMBhMGL+GW8Q0HFKOuEr6z+OBk3SAy4ZlqF5RJGp5ZfhWOYhQLXFmivbM3sjpUQ==
X-Received: by 2002:a7b:c353:: with SMTP id l19mr9015351wmj.127.1628076328656;
        Wed, 04 Aug 2021 04:25:28 -0700 (PDT)
Received: from laral.fritz.box (200116b82bd8960014b79be16de1e56b.dip.versatel-1u1.de. [2001:16b8:2bd8:9600:14b7:9be1:6de1:e56b])
        by smtp.gmail.com with ESMTPSA id z6sm1978247wmp.1.2021.08.04.04.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:25:28 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH kvm-unit-tests] nSVM: Modified canonicalization tests
Date:   Wed,  4 Aug 2021 13:25:07 +0200
Message-Id: <20210804112507.43394-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APM2 states that VMRUN and VMLOAD should canonicalize all base
addresses in the segment registers that have been loaded respectively.

Split up in test_canonicalization the TEST_CANONICAL for VMLOAD and
VMRUN. Added the respective test for KERNEL_GS.

In general the canonicalization should be from 48/57 to 64 based on LA57.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 lib/x86/processor.h |  4 +++-
 x86/svm_tests.c     | 54 +++++++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index f4d1757..ae708ac 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -619,7 +619,9 @@ static inline void write_pkru(u32 pkru)
 
 static inline bool is_canonical(u64 addr)
 {
-	return (s64)(addr << 16) >> 16 == addr;
+	int shift_amt = (this_cpu_has(X86_FEATURE_LA57)) ? 7 /* 57 bits virtual */
+                        : 16 /* 48 bits virtual */;
+	return (s64)(addr << shift_amt) >> shift_amt == addr;
 }
 
 static inline void clear_bit(int bit, u8 *addr)
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7c7b19d..273b80b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2460,32 +2460,54 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	vmcb->control.intercept = saved_intercept;
 }
 
-#define TEST_CANONICAL(seg_base, msg)					\
-	saved_addr = seg_base;						\
+#define TEST_CANONICAL_VMRUN(seg_base, msg)					\
+	saved_addr = seg_base;					\
 	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
-	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test %s.base for canonical form: %lx", msg, seg_base);							\
+	return_value = svm_vmrun(); \
+	if (is_canonical(seg_base)) { \
+		report(return_value == SVM_EXIT_VMMCALL, \
+			"Test %s.base for canonical form: %lx", msg, seg_base); \
+	} else { \
+		report(false, \
+			"Test a %s.base not canonicalized: %lx", msg, seg_base); \
+	} \
+	seg_base = saved_addr;
+
+
+#define TEST_CANONICAL_VMLOAD(seg_base, msg)					\
+	saved_addr = seg_base;					\
+	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
+	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory"); \
+	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory"); \
+	report(is_canonical(seg_base), \
+			"Test %s.base for canonical form: %lx", msg, seg_base); \
 	seg_base = saved_addr;
 
 /*
  * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
  • in the segment registers that have been loaded.
  */
-static void test_vmrun_canonicalization(void)
+static void test_canonicalization(void)
 {
 	u64 saved_addr;
-	u8 addr_limit = cpuid_maxphyaddr();
+	u64 return_value;
+	u64 addr_limit;
+	u64 vmcb_phys = virt_to_phys(vmcb);
+
+	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
 	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
 
-	TEST_CANONICAL(vmcb->save.es.base, "ES");
-	TEST_CANONICAL(vmcb->save.cs.base, "CS");
-	TEST_CANONICAL(vmcb->save.ss.base, "SS");
-	TEST_CANONICAL(vmcb->save.ds.base, "DS");
-	TEST_CANONICAL(vmcb->save.fs.base, "FS");
-	TEST_CANONICAL(vmcb->save.gs.base, "GS");
-	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
-	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
-	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
-	TEST_CANONICAL(vmcb->save.tr.base, "TR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.fs.base, "FS");
+	TEST_CANONICAL_VMLOAD(vmcb->save.gs.base, "GS");
+	TEST_CANONICAL_VMLOAD(vmcb->save.ldtr.base, "LDTR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.tr.base, "TR");
+	TEST_CANONICAL_VMLOAD(vmcb->save.kernel_gs_base, "KERNEL GS");
+	TEST_CANONICAL_VMRUN(vmcb->save.es.base, "ES");
+	TEST_CANONICAL_VMRUN(vmcb->save.cs.base, "CS");
+	TEST_CANONICAL_VMRUN(vmcb->save.ss.base, "SS");
+	TEST_CANONICAL_VMRUN(vmcb->save.ds.base, "DS");
+	TEST_CANONICAL_VMRUN(vmcb->save.gdtr.base, "GDTR");
+	TEST_CANONICAL_VMRUN(vmcb->save.idtr.base, "IDTR");
 }
 
 static void svm_guest_state_test(void)
@@ -2497,7 +2519,7 @@ static void svm_guest_state_test(void)
 	test_cr4();
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
-	test_vmrun_canonicalization();
+	test_canonicalization();
 }
 
 static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
-- 
2.25.1

