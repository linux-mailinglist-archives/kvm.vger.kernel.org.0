Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2193E5F17FF
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiJABON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiJABNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6191D649
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:06 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902d2c900b001782ad97c7aso4231903plc.8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=L7bh3Ac0kjb6/oF6iY0CRuTKzYWvq2kqC1Vz5yM6wMI=;
        b=lBiP/b6t5qfAITn6VtqHDJ3w/Y7jGtIo/HBqtZXwA2lQ9O3NlXAfr16j1aVCy5IZlx
         uih6WzlS3m4pAbGdHbfS13XRiV6xo3TspOJulEQCQERqbXRWAbhvgiVZiKoLc3C7ay56
         gTni6cwU6WPSkALsIihc9wDiV1vyqIkAWhudD6DeozMMKXvsUYOEQLb5oUrtgRNRhpzY
         iaY+ny+llxuFDNzTm7eqV47TvnAlvIGDxtw8jthb6XVNf8Dwp+VI8ubTVMFOuf/4AFbF
         DUHuuKE9onXhQCbIUB+Jp0CBLX5Y0+5+Rpt9FgF1Mep5zkBkPbgq57S8BqQipeQ0Pi6z
         Menw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=L7bh3Ac0kjb6/oF6iY0CRuTKzYWvq2kqC1Vz5yM6wMI=;
        b=cGs41ygN7j/4xgTcYMKWvuXvvYFRvcdZqjXY5RRS1C/XRqCJKj3MdVyTIEFdXjvCeL
         N0VhCkzZJO8+D9z6JTmTlftwWpW8Fr/2Lfn76w/Z/PNQx99iAEreAhWzNjg+szwZS1xW
         bCbAVehKkALBnfPLlSd/7hdicaEeHsngfqI7xW7jdl2W6NvdSUPQ+CxBD1/iMt622q+h
         HKXRcBKWmgCFjAxRHaf4I9Er1xycfBBzFFaw+Tj7yuCOIjqtfqwN7jWFRBkmbNMWyXxX
         faxA/JpA7X2oWDHWumaCI9uJKXLGF839FWQ2SVp87eqrCRM5Gi5x8OEpg6sFoU+jDnIM
         Y9KQ==
X-Gm-Message-State: ACrzQf0pU8YUcPky39luM7DmJU8Um6bKR/MSiAthn4DN7oE54TmdtnZe
        9IOLWwKVQVN8AtLP+Jl+Mmr4MHO72W4=
X-Google-Smtp-Source: AMsMyM6BOjaeOfHKKOjYsdQzcqdZBRkdq0D2qllSfkr4La0x5rl5OjwhuSa9CqEv4cZc/gq0dRtUENlyobw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d145:0:b0:443:c25f:5dd5 with SMTP id
 c5-20020a63d145000000b00443c25f5dd5mr2239041pgj.554.1664586786518; Fri, 30
 Sep 2022 18:13:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:54 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/9] x86/apic: Replaces spaces with tabs to fix
 indentation in apic.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Fix spaces vs. tabs indentation in apic.c to make enhancing the test
slightly less painful.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 661 ++++++++++++++++++++++++++---------------------------
 1 file changed, 327 insertions(+), 334 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index 23508ad..f038198 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -12,11 +12,11 @@
 
 static void test_lapic_existence(void)
 {
-    u8 version;
+	u8 version;
 
-    version = (u8)apic_read(APIC_LVR);
-    printf("apic version: %x\n", version);
-    report(version >= 0x10 && version <= 0x15, "apic existence");
+	version = (u8)apic_read(APIC_LVR);
+	printf("apic version: %x\n", version);
+	report(version >= 0x10 && version <= 0x15, "apic existence");
 }
 
 #define TSC_DEADLINE_TIMER_VECTOR 0xef
@@ -26,313 +26,311 @@ static int tdt_count;
 
 static void tsc_deadline_timer_isr(isr_regs_t *regs)
 {
-    ++tdt_count;
-    eoi();
+	++tdt_count;
+	eoi();
 }
 
 static void __test_tsc_deadline_timer(void)
 {
-    handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
-    irq_enable();
+	handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
+	irq_enable();
 
-    wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
-    asm volatile ("nop");
-    report(tdt_count == 1, "tsc deadline timer");
-    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
+	wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
+	asm volatile ("nop");
+	report(tdt_count == 1, "tsc deadline timer");
+	report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
 }
 
 static int enable_tsc_deadline_timer(void)
 {
-    uint32_t lvtt;
+	uint32_t lvtt;
 
-    if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
-        lvtt = APIC_LVT_TIMER_TSCDEADLINE | TSC_DEADLINE_TIMER_VECTOR;
-        apic_write(APIC_LVTT, lvtt);
-        return 1;
-    } else {
-        return 0;
-    }
+	if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
+		lvtt = APIC_LVT_TIMER_TSCDEADLINE | TSC_DEADLINE_TIMER_VECTOR;
+		apic_write(APIC_LVTT, lvtt);
+		return 1;
+	} else {
+		return 0;
+	}
 }
 
 static void test_tsc_deadline_timer(void)
 {
-    if(enable_tsc_deadline_timer()) {
-        __test_tsc_deadline_timer();
-    } else {
-        report_skip("tsc deadline timer not detected");
-    }
+	if(enable_tsc_deadline_timer())
+		__test_tsc_deadline_timer();
+	else
+		report_skip("tsc deadline timer not detected");
 }
 
 static void do_write_apicbase(void *data)
 {
-    wrmsr(MSR_IA32_APICBASE, *(u64 *)data);
+	wrmsr(MSR_IA32_APICBASE, *(u64 *)data);
 }
 
 static bool test_write_apicbase_exception(u64 data)
 {
-    return test_for_exception(GP_VECTOR, do_write_apicbase, &data);
+	return test_for_exception(GP_VECTOR, do_write_apicbase, &data);
 }
 
 static void test_enable_x2apic(void)
 {
-    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
-    u64 apicbase;
+	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 apicbase;
 
-    if (enable_x2apic()) {
-        printf("x2apic enabled\n");
+	if (enable_x2apic()) {
+		printf("x2apic enabled\n");
 
-        apicbase = orig_apicbase & ~(APIC_EN | APIC_EXTD);
-        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
-               "x2apic enabled to invalid state");
-        report(test_write_apicbase_exception(apicbase | APIC_EN),
-               "x2apic enabled to apic enabled");
+		apicbase = orig_apicbase & ~(APIC_EN | APIC_EXTD);
+		report(test_write_apicbase_exception(apicbase | APIC_EXTD),
+			"x2apic enabled to invalid state");
+		report(test_write_apicbase_exception(apicbase | APIC_EN),
+			"x2apic enabled to apic enabled");
 
-        report(!test_write_apicbase_exception(apicbase | 0),
-               "x2apic enabled to disabled state");
-        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
-               "disabled to invalid state");
-        report(test_write_apicbase_exception(apicbase | APIC_EN | APIC_EXTD),
-               "disabled to x2apic enabled");
+		report(!test_write_apicbase_exception(apicbase | 0),
+			"x2apic enabled to disabled state");
+		report(test_write_apicbase_exception(apicbase | APIC_EXTD),
+			"disabled to invalid state");
+		report(test_write_apicbase_exception(apicbase | APIC_EN | APIC_EXTD),
+			"disabled to x2apic enabled");
 
-        report(!test_write_apicbase_exception(apicbase | APIC_EN),
-               "apic disabled to apic enabled");
-        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
-               "apic enabled to invalid state");
+		report(!test_write_apicbase_exception(apicbase | APIC_EN),
+			"apic disabled to apic enabled");
+		report(test_write_apicbase_exception(apicbase | APIC_EXTD),
+			"apic enabled to invalid state");
 
-        if (orig_apicbase & APIC_EXTD)
-            enable_x2apic();
-        else
-            reset_apic();
+		if (orig_apicbase & APIC_EXTD)
+			enable_x2apic();
+		else
+			reset_apic();
 
-        /*
-         * Disabling the APIC resets various APIC registers, restore them to
-         * their desired values.
-         */
-        apic_write(APIC_SPIV, 0x1ff);
-    } else {
-        printf("x2apic not detected\n");
+		/*
+		 * Disabling the APIC resets various APIC registers, restore
+		 * them to their desired values.
+		 */
+		apic_write(APIC_SPIV, 0x1ff);
+	} else {
+		printf("x2apic not detected\n");
 
-        report(test_write_apicbase_exception(APIC_EN | APIC_EXTD),
-               "enable unsupported x2apic");
-    }
+		report(test_write_apicbase_exception(APIC_EN | APIC_EXTD),
+		       "enable unsupported x2apic");
+	}
 }
 
 static void verify_disabled_apic_mmio(void)
 {
-    volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
-    volatile u32 *tpr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_TASKPRI);
-    u32 cr8 = read_cr8();
+	volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
+	volatile u32 *tpr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_TASKPRI);
+	u32 cr8 = read_cr8();
 
-    memset((void *)APIC_DEFAULT_PHYS_BASE, 0xff, PAGE_SIZE);
-    report(*lvr == ~0, "*0xfee00030: %x", *lvr);
-    report(read_cr8() == cr8, "CR8: %lx", read_cr8());
-    write_cr8(cr8 ^ MAX_TPR);
-    report(read_cr8() == (cr8 ^ MAX_TPR), "CR8: %lx", read_cr8());
-    report(*tpr == ~0, "*0xfee00080: %x", *tpr);
-    write_cr8(cr8);
+	memset((void *)APIC_DEFAULT_PHYS_BASE, 0xff, PAGE_SIZE);
+	report(*lvr == ~0, "*0xfee00030: %x", *lvr);
+	report(read_cr8() == cr8, "CR8: %lx", read_cr8());
+	write_cr8(cr8 ^ MAX_TPR);
+	report(read_cr8() == (cr8 ^ MAX_TPR), "CR8: %lx", read_cr8());
+	report(*tpr == ~0, "*0xfee00080: %x", *tpr);
+	write_cr8(cr8);
 }
 
 static void test_apic_disable(void)
 {
-    volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
-    volatile u32 *tpr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_TASKPRI);
-    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
-    u32 apic_version = apic_read(APIC_LVR);
-    u32 cr8 = read_cr8();
-
-    report_prefix_push("apic_disable");
-    assert_msg(orig_apicbase & APIC_EN, "APIC not enabled.");
-
-    disable_apic();
-    report(!(rdmsr(MSR_IA32_APICBASE) & APIC_EN), "Local apic disabled");
-    report(!this_cpu_has(X86_FEATURE_APIC),
-           "CPUID.1H:EDX.APIC[bit 9] is clear");
-    verify_disabled_apic_mmio();
-
-    reset_apic();
-    report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
-           "Local apic enabled in xAPIC mode");
-    report(this_cpu_has(X86_FEATURE_APIC), "CPUID.1H:EDX.APIC[bit 9] is set");
-    report(*lvr == apic_version, "*0xfee00030: %x", *lvr);
-    report(*tpr == cr8, "*0xfee00080: %x", *tpr);
-    write_cr8(cr8 ^ MAX_TPR);
-    report(*tpr == (cr8 ^ MAX_TPR) << 4, "*0xfee00080: %x", *tpr);
-    write_cr8(cr8);
-
-    if (enable_x2apic()) {
-	apic_write(APIC_SPIV, 0x1ff);
-	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
-               "Local apic enabled in x2APIC mode");
-	report(this_cpu_has(X86_FEATURE_APIC),
-               "CPUID.1H:EDX.APIC[bit 9] is set");
+	volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
+	volatile u32 *tpr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_TASKPRI);
+	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u32 apic_version = apic_read(APIC_LVR);
+	u32 cr8 = read_cr8();
+
+	report_prefix_push("apic_disable");
+	assert_msg(orig_apicbase & APIC_EN, "APIC not enabled.");
+
+	disable_apic();
+	report(!(rdmsr(MSR_IA32_APICBASE) & APIC_EN), "Local apic disabled");
+	report(!this_cpu_has(X86_FEATURE_APIC),
+	       "CPUID.1H:EDX.APIC[bit 9] is clear");
 	verify_disabled_apic_mmio();
-	if (!(orig_apicbase & APIC_EXTD))
-	    reset_apic();
-    }
-    report_prefix_pop();
+
+	reset_apic();
+	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
+	       "Local apic enabled in xAPIC mode");
+	report(this_cpu_has(X86_FEATURE_APIC), "CPUID.1H:EDX.APIC[bit 9] is set");
+	report(*lvr == apic_version, "*0xfee00030: %x", *lvr);
+	report(*tpr == cr8, "*0xfee00080: %x", *tpr);
+	write_cr8(cr8 ^ MAX_TPR);
+	report(*tpr == (cr8 ^ MAX_TPR) << 4, "*0xfee00080: %x", *tpr);
+	write_cr8(cr8);
+
+	if (enable_x2apic()) {
+		apic_write(APIC_SPIV, 0x1ff);
+		report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
+		       "Local apic enabled in x2APIC mode");
+		report(this_cpu_has(X86_FEATURE_APIC),
+		       "CPUID.1H:EDX.APIC[bit 9] is set");
+		verify_disabled_apic_mmio();
+		if (!(orig_apicbase & APIC_EXTD))
+			reset_apic();
+	}
+	report_prefix_pop();
 }
 
 #define ALTERNATE_APIC_BASE	0xfed40000
 
 static void test_apicbase(void)
 {
-    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
-    u32 lvr = apic_read(APIC_LVR);
-    u64 value;
+	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u32 lvr = apic_read(APIC_LVR);
+	u64 value;
 
-    wrmsr(MSR_IA32_APICBASE, orig_apicbase & ~(APIC_EN | APIC_EXTD));
-    wrmsr(MSR_IA32_APICBASE, ALTERNATE_APIC_BASE | APIC_BSP | APIC_EN);
+	wrmsr(MSR_IA32_APICBASE, orig_apicbase & ~(APIC_EN | APIC_EXTD));
+	wrmsr(MSR_IA32_APICBASE, ALTERNATE_APIC_BASE | APIC_BSP | APIC_EN);
 
-    report_prefix_push("apicbase");
+	report_prefix_push("apicbase");
 
-    report(*(volatile u32 *)(ALTERNATE_APIC_BASE + APIC_LVR) == lvr,
-           "relocate apic");
+	report(*(volatile u32 *)(ALTERNATE_APIC_BASE + APIC_LVR) == lvr,
+	       "relocate apic");
 
-    value = orig_apicbase | (1UL << cpuid_maxphyaddr());
-    report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
-           "reserved physaddr bits");
+	value = orig_apicbase | (1UL << cpuid_maxphyaddr());
+	report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
+	       "reserved physaddr bits");
 
-    value = orig_apicbase | 1;
-    report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
-           "reserved low bits");
+	value = orig_apicbase | 1;
+	report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
+	       "reserved low bits");
 
-    wrmsr(MSR_IA32_APICBASE, orig_apicbase);
-    apic_write(APIC_SPIV, 0x1ff);
+	wrmsr(MSR_IA32_APICBASE, orig_apicbase);
+	apic_write(APIC_SPIV, 0x1ff);
 
-    report_prefix_pop();
+	report_prefix_pop();
 }
 
 static void do_write_apic_id(void *id)
 {
-    apic_write(APIC_ID, *(u32 *)id);
+	apic_write(APIC_ID, *(u32 *)id);
 }
 
 static void __test_apic_id(void * unused)
 {
-    u32 id, newid;
-    u8  initial_xapic_id = cpuid(1).b >> 24;
-    u32 initial_x2apic_id = cpuid(0xb).d;
-    bool x2apic_mode = rdmsr(MSR_IA32_APICBASE) & APIC_EXTD;
+	u32 id, newid;
+	u8  initial_xapic_id = cpuid(1).b >> 24;
+	u32 initial_x2apic_id = cpuid(0xb).d;
+	bool x2apic_mode = rdmsr(MSR_IA32_APICBASE) & APIC_EXTD;
 
-    if (x2apic_mode)
-        reset_apic();
+	if (x2apic_mode)
+		reset_apic();
 
-    id = apic_id();
-    report(initial_xapic_id == id, "xapic id matches cpuid");
+	id = apic_id();
+	report(initial_xapic_id == id, "xapic id matches cpuid");
 
-    newid = (id + 1) << 24;
-    report(!test_for_exception(GP_VECTOR, do_write_apic_id, &newid) &&
-           (id == apic_id() || id + 1 == apic_id()),
-           "writeable xapic id");
+	newid = (id + 1) << 24;
+	report(!test_for_exception(GP_VECTOR, do_write_apic_id, &newid) &&
+	       (id == apic_id() || id + 1 == apic_id()),
+	       "writeable xapic id");
 
-    if (!enable_x2apic())
-        goto out;
+	if (!enable_x2apic())
+		goto out;
 
-    report(test_for_exception(GP_VECTOR, do_write_apic_id, &newid),
-           "non-writeable x2apic id");
-    report(initial_xapic_id == (apic_id() & 0xff), "sane x2apic id");
+	report(test_for_exception(GP_VECTOR, do_write_apic_id, &newid),
+	       "non-writeable x2apic id");
+	report(initial_xapic_id == (apic_id() & 0xff), "sane x2apic id");
 
-    /* old QEMUs do not set initial x2APIC ID */
-    report(initial_xapic_id == (initial_x2apic_id & 0xff) && 
-           initial_x2apic_id == apic_id(),
-           "x2apic id matches cpuid");
+	/* old QEMUs do not set initial x2APIC ID */
+	report(initial_xapic_id == (initial_x2apic_id & 0xff) && 
+	       initial_x2apic_id == apic_id(),
+	       "x2apic id matches cpuid");
 
 out:
-    reset_apic();
+	reset_apic();
 
-    report(initial_xapic_id == apic_id(), "correct xapic id after reset");
+	report(initial_xapic_id == apic_id(), "correct xapic id after reset");
 
-    /* old KVMs do not reset xAPIC ID */
-    if (id != apic_id())
-        apic_write(APIC_ID, id << 24);
+	/* old KVMs do not reset xAPIC ID */
+	if (id != apic_id())
+		apic_write(APIC_ID, id << 24);
 
-    if (x2apic_mode)
-        enable_x2apic();
+	if (x2apic_mode)
+		enable_x2apic();
 }
 
 static void test_apic_id(void)
 {
-    if (cpu_count() < 2)
-        return;
+	if (cpu_count() < 2)
+		return;
 
-    on_cpu(1, __test_apic_id, NULL);
+	on_cpu(1, __test_apic_id, NULL);
 }
 
 static int ipi_count;
 
 static void self_ipi_isr(isr_regs_t *regs)
 {
-    ++ipi_count;
-    eoi();
+	++ipi_count;
+	eoi();
 }
 
 static void __test_self_ipi(void)
 {
-    u64 start = rdtsc();
-    int vec = 0xf1;
+	u64 start = rdtsc();
+	int vec = 0xf1;
 
-    handle_irq(vec, self_ipi_isr);
-    irq_enable();
-    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | vec,
-                   id_map[0]);
+	handle_irq(vec, self_ipi_isr);
+	irq_enable();
+	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | vec,
+		       id_map[0]);
 
-    do {
-        pause();
-    } while (rdtsc() - start < 1000000000 && ipi_count == 0);
+	do {
+		pause();
+	} while (rdtsc() - start < 1000000000 && ipi_count == 0);
 }
 
 static void test_self_ipi_xapic(void)
 {
-    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
 
-    report_prefix_push("self_ipi_xapic");
+	report_prefix_push("self_ipi_xapic");
 
-    /* Reset to xAPIC mode. */
-    reset_apic();
-    report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
-           "Local apic enabled in xAPIC mode");
+	/* Reset to xAPIC mode. */
+	reset_apic();
+	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
+	       "Local apic enabled in xAPIC mode");
 
-    ipi_count = 0;
-    __test_self_ipi();
-    report(ipi_count == 1, "self ipi");
+	ipi_count = 0;
+	__test_self_ipi();
+	report(ipi_count == 1, "self ipi");
 
-    /* Enable x2APIC mode if it was already enabled. */
-    if (orig_apicbase & APIC_EXTD)
-        enable_x2apic();
+	/* Enable x2APIC mode if it was already enabled. */
+	if (orig_apicbase & APIC_EXTD)
+		enable_x2apic();
 
-    report_prefix_pop();
+	report_prefix_pop();
 }
 
 static void test_self_ipi_x2apic(void)
 {
-    u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
 
-    report_prefix_push("self_ipi_x2apic");
+	report_prefix_push("self_ipi_x2apic");
 
-    if (enable_x2apic()) {
-        report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) ==
-               (APIC_EN | APIC_EXTD),
-               "Local apic enabled in x2APIC mode");
+	if (enable_x2apic()) {
+		report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
+			"Local apic enabled in x2APIC mode");
 
-        ipi_count = 0;
-        __test_self_ipi();
-        report(ipi_count == 1, "self ipi");
+		ipi_count = 0;
+		__test_self_ipi();
+		report(ipi_count == 1, "self ipi");
 
-        /* Reset to xAPIC mode unless x2APIC was already enabled. */
-        if (!(orig_apicbase & APIC_EXTD))
-            reset_apic();
-    } else {
-        report_skip("x2apic not detected");
-    }
+		/* Reset to xAPIC mode unless x2APIC was already enabled. */
+		if (!(orig_apicbase & APIC_EXTD))
+			reset_apic();
+	} else {
+		report_skip("x2apic not detected");
+	}
 
-    report_prefix_pop();
+	report_prefix_pop();
 }
 
 volatile int nmi_counter_private, nmi_counter, nmi_hlt_counter, sti_loop_active;
 
 static void sti_nop(char *p)
 {
-    asm volatile (
+	asm volatile (
 		  ".globl post_sti \n\t"
 		  "sti \n"
 		  /*
@@ -344,47 +342,44 @@ static void sti_nop(char *p)
 		  "cli"
 		  : : "m"(*p)
 		  );
-    nmi_counter = nmi_counter_private;
+	nmi_counter = nmi_counter_private;
 }
 
 static void sti_loop(void *ignore)
 {
-    unsigned k = 0;
+	unsigned k = 0;
 
-    while (sti_loop_active) {
-	sti_nop((char *)(ulong)((k++ * 4096) % (128 * 1024 * 1024)));
-    }
+	while (sti_loop_active)
+		sti_nop((char *)(ulong)((k++ * 4096) % (128 * 1024 * 1024)));
 }
 
 static void nmi_handler(isr_regs_t *regs)
 {
-    extern void post_sti(void);
-    ++nmi_counter_private;
-    nmi_hlt_counter += regs->rip == (ulong)post_sti;
+	extern void post_sti(void);
+	++nmi_counter_private;
+	nmi_hlt_counter += regs->rip == (ulong)post_sti;
 }
 
 static void test_sti_nmi(void)
 {
-    unsigned old_counter;
+	unsigned old_counter;
 
-    if (cpu_count() < 2) {
-	return;
-    }
+	if (cpu_count() < 2)
+		return;
 
-    handle_irq(2, nmi_handler);
-    on_cpu(1, update_cr3, (void *)read_cr3());
+	handle_irq(2, nmi_handler);
+	on_cpu(1, update_cr3, (void *)read_cr3());
 
-    sti_loop_active = 1;
-    on_cpu_async(1, sti_loop, 0);
-    while (nmi_counter < 30000) {
-	old_counter = nmi_counter;
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[1]);
-	while (nmi_counter == old_counter) {
-	    ;
+	sti_loop_active = 1;
+	on_cpu_async(1, sti_loop, 0);
+	while (nmi_counter < 30000) {
+		old_counter = nmi_counter;
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[1]);
+		while (nmi_counter == old_counter)
+			;
 	}
-    }
-    sti_loop_active = 0;
-    report(nmi_hlt_counter == 0, "nmi-after-sti");
+	sti_loop_active = 0;
+	report(nmi_hlt_counter == 0, "nmi-after-sti");
 }
 
 static volatile bool nmi_done, nmi_flushed;
@@ -394,140 +389,138 @@ static volatile int cpu0_nmi_ctr2, cpu1_nmi_ctr2;
 
 static void multiple_nmi_handler(isr_regs_t *regs)
 {
-    ++nmi_received;
+	++nmi_received;
 }
 
 static void kick_me_nmi(void *blah)
 {
-    while (!nmi_done) {
-	++cpu1_nmi_ctr1;
-	while (cpu1_nmi_ctr1 != cpu0_nmi_ctr1 && !nmi_done) {
-	    pause();
+	while (!nmi_done) {
+		++cpu1_nmi_ctr1;
+		while (cpu1_nmi_ctr1 != cpu0_nmi_ctr1 && !nmi_done)
+			pause();
+
+		if (nmi_done)
+			return;
+
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+		/* make sure the NMI has arrived by sending an IPI after it */
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT
+				| 0x44, id_map[0]);
+		++cpu1_nmi_ctr2;
+		while (cpu1_nmi_ctr2 != cpu0_nmi_ctr2 && !nmi_done)
+			pause();
 	}
-	if (nmi_done) {
-	    return;
-	}
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
-	/* make sure the NMI has arrived by sending an IPI after it */
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT
-		       | 0x44, id_map[0]);
-	++cpu1_nmi_ctr2;
-	while (cpu1_nmi_ctr2 != cpu0_nmi_ctr2 && !nmi_done) {
-	    pause();
-	}
-    }
 }
 
 static void flush_nmi(isr_regs_t *regs)
 {
-    nmi_flushed = true;
-    apic_write(APIC_EOI, 0);
+	nmi_flushed = true;
+	apic_write(APIC_EOI, 0);
 }
 
 static void test_multiple_nmi(void)
 {
-    int i;
-    bool ok = true;
+	int i;
+	bool ok = true;
 
-    if (cpu_count() < 2) {
-	return;
-    }
+	if (cpu_count() < 2)
+		return;
 
-    sti();
-    handle_irq(2, multiple_nmi_handler);
-    handle_irq(0x44, flush_nmi);
-    on_cpu_async(1, kick_me_nmi, 0);
-    for (i = 0; i < 100000; ++i) {
-	nmi_flushed = false;
-	nmi_received = 0;
-	++cpu0_nmi_ctr1;
-	while (cpu1_nmi_ctr1 != cpu0_nmi_ctr1) {
-	    pause();
-	}
-	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
-	while (!nmi_flushed) {
-	    pause();
-	}
-	if (nmi_received != 2) {
-	    ok = false;
-	    break;
-	}
-	++cpu0_nmi_ctr2;
-	while (cpu1_nmi_ctr2 != cpu0_nmi_ctr2) {
-	    pause();
+	sti();
+	handle_irq(2, multiple_nmi_handler);
+	handle_irq(0x44, flush_nmi);
+	on_cpu_async(1, kick_me_nmi, 0);
+	for (i = 0; i < 100000; ++i) {
+		nmi_flushed = false;
+		nmi_received = 0;
+		++cpu0_nmi_ctr1;
+		while (cpu1_nmi_ctr1 != cpu0_nmi_ctr1)
+			pause();
+
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
+		while (!nmi_flushed)
+			pause();
+
+		if (nmi_received != 2) {
+			ok = false;
+			break;
+		}
+
+		++cpu0_nmi_ctr2;
+		while (cpu1_nmi_ctr2 != cpu0_nmi_ctr2)
+			pause();
 	}
-    }
-    nmi_done = true;
-    report(ok, "multiple nmi");
+	nmi_done = true;
+	report(ok, "multiple nmi");
 }
 
 static void pending_nmi_handler(isr_regs_t *regs)
 {
-    int i;
+	int i;
 
-    if (++nmi_received == 1) {
-        for (i = 0; i < 10; ++i)
-            apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
-    }
+	if (++nmi_received == 1) {
+		for (i = 0; i < 10; ++i)
+			apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
+	}
 }
 
 static void test_pending_nmi(void)
 {
-    int i;
+	int i;
 
-    handle_irq(2, pending_nmi_handler);
-    for (i = 0; i < 100000; ++i) {
-	    nmi_received = 0;
+	handle_irq(2, pending_nmi_handler);
+	for (i = 0; i < 100000; ++i) {
+		nmi_received = 0;
 
-        apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
-        while (nmi_received < 2)
-            pause();
+		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI, 0);
+		while (nmi_received < 2)
+			pause();
 
-        if (nmi_received != 2)
-            break;
-    }
-    report(nmi_received == 2, "pending nmi");
+		if (nmi_received != 2)
+			break;
+	}
+	report(nmi_received == 2, "pending nmi");
 }
 
 static volatile int lvtt_counter = 0;
 
 static void lvtt_handler(isr_regs_t *regs)
 {
-    lvtt_counter++;
-    eoi();
+	lvtt_counter++;
+	eoi();
 }
 
 static void test_apic_timer_one_shot(void)
 {
-    uint64_t tsc1, tsc2;
-    static const uint32_t interval = 0x10000;
+	uint64_t tsc1, tsc2;
+	static const uint32_t interval = 0x10000;
 
 #define APIC_LVT_TIMER_VECTOR    (0xee)
 
-    handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
-    irq_enable();
+	handle_irq(APIC_LVT_TIMER_VECTOR, lvtt_handler);
+	irq_enable();
 
-    /* One shot mode */
-    apic_write(APIC_LVTT, APIC_LVT_TIMER_ONESHOT |
-               APIC_LVT_TIMER_VECTOR);
-    /* Divider == 1 */
-    apic_write(APIC_TDCR, 0x0000000b);
+	/* One shot mode */
+	apic_write(APIC_LVTT, APIC_LVT_TIMER_ONESHOT |
+		   APIC_LVT_TIMER_VECTOR);
+	/* Divider == 1 */
+	apic_write(APIC_TDCR, 0x0000000b);
 
-    tsc1 = rdtsc();
-    /* Set "Initial Counter Register", which starts the timer */
-    apic_write(APIC_TMICT, interval);
-    while (!lvtt_counter);
-    tsc2 = rdtsc();
+	tsc1 = rdtsc();
+	/* Set "Initial Counter Register", which starts the timer */
+	apic_write(APIC_TMICT, interval);
+	while (!lvtt_counter);
+	tsc2 = rdtsc();
 
-    /*
-     * For LVT Timer clock, SDM vol 3 10.5.4 says it should be
-     * derived from processor's bus clock (IIUC which is the same
-     * as TSC), however QEMU seems to be using nanosecond. In all
-     * cases, the following should satisfy on all modern
-     * processors.
-     */
-    report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
-           "APIC LVT timer one shot");
+	/*
+	 * For LVT Timer clock, SDM vol 3 10.5.4 says it should be
+	 * derived from processor's bus clock (IIUC which is the same
+	 * as TSC), however QEMU seems to be using nanosecond. In all
+	 * cases, the following should satisfy on all modern
+	 * processors.
+	 */
+	report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
+	       "APIC LVT timer one shot");
 }
 
 static atomic_t broadcast_counter;
@@ -567,11 +560,11 @@ static void test_physical_broadcast(void)
 
 	printf("starting broadcast (%s)\n", enable_x2apic() ? "x2apic" : "xapic");
 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT |
-			BROADCAST_VECTOR, broadcast_address);
+		       BROADCAST_VECTOR, broadcast_address);
 	report(broadcast_received(ncpus), "APIC physical broadcast address");
 
 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT |
-			BROADCAST_VECTOR | APIC_DEST_ALLINC, 0);
+		       BROADCAST_VECTOR | APIC_DEST_ALLINC, 0);
 	report(broadcast_received(ncpus), "APIC physical broadcast shorthand");
 }
 
@@ -678,38 +671,38 @@ static void test_apic_change_mode(void)
 
 static void test_pv_ipi(void)
 {
-    int ret;
-    unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
+	int ret;
+	unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
 
-    asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
-    report(!ret, "PV IPIs testing");
+	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+	report(!ret, "PV IPIs testing");
 }
 
 int main(void)
 {
-    setup_vm();
+	setup_vm();
 
-    test_lapic_existence();
+	test_lapic_existence();
 
-    mask_pic_interrupts();
-    test_apic_id();
-    test_apic_disable();
-    test_enable_x2apic();
-    test_apicbase();
+	mask_pic_interrupts();
+	test_apic_id();
+	test_apic_disable();
+	test_enable_x2apic();
+	test_apicbase();
 
-    test_self_ipi_xapic();
-    test_self_ipi_x2apic();
-    test_physical_broadcast();
-    if (test_device_enabled())
-        test_pv_ipi();
+	test_self_ipi_xapic();
+	test_self_ipi_x2apic();
+	test_physical_broadcast();
+	if (test_device_enabled())
+		test_pv_ipi();
 
-    test_sti_nmi();
-    test_multiple_nmi();
-    test_pending_nmi();
+	test_sti_nmi();
+	test_multiple_nmi();
+	test_pending_nmi();
 
-    test_apic_timer_one_shot();
-    test_apic_change_mode();
-    test_tsc_deadline_timer();
+	test_apic_timer_one_shot();
+	test_apic_change_mode();
+	test_tsc_deadline_timer();
 
-    return report_summary();
+	return report_summary();
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

