Return-Path: <kvm+bounces-4100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC37B80D9CA
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FC8D1F219A5
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 638E152F9A;
	Mon, 11 Dec 2023 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ay9WgdUX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4DFB8
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:21 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5de8c2081d1so39045227b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 10:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702320980; x=1702925780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Po2NuzeRSr6e6XvJUH45J91ZQBQs42rgxiRE1lTRmPo=;
        b=ay9WgdUXrLyoG+M3jfRPqmx1nRYxndPXXLP1q2CO9IWAXyGVomyMhUyBZo+UgtpzrL
         LG/Yla83y7OhdVGnMiEBwhItJD8/akhwkueH83YOZ6ZigBAQTJ07+oqpZ7ZkPqnFbhW+
         b7EFI7dOaa2SdH10bYTjyQKouCmJQsMU5LG/p1jgELqn1qioUW1+L/fI9nPA9OVpvBzU
         nREzjDZ5Sq66TXV/aoDXw9JJZf7HjC3W4zlEznN0FJtsx21wc68XN3vYzLq9smgRtPa3
         0mE/r4cgWQ3b9oRG139oMlJaRh1PBJ1m7q5QHuAqJY9IHxfPRkr5fHUFihvRzcuFcCl8
         0vHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702320980; x=1702925780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Po2NuzeRSr6e6XvJUH45J91ZQBQs42rgxiRE1lTRmPo=;
        b=QdsFW39iqJuMO5t5EnLILcZ5nN3hzZk4vJhWYaShSwJCzxwVc1VxMC2SNeFNXixCgb
         3IgL5pYZ4+hlWshZtcMKYity7Bw/jBuSD/fkc9aBV/WTHLB/OyNjFmw+/S1cvwEcs49K
         PrKN1a4n/gfxjEDoT4ik/f0viOva08kr2NIN5CUt1yi2+f42IXlpQA4RW99eYkWgqHIN
         fPQMtjRh53I7XPPL4f5oK7TYyKzTmh3KOBLOzyY15hBCfYYccyMnuOHQRTsNQxP7bJiP
         CUYt0psfAMH4nG6M2+ICeaBu4omnEZYyyyFIVYeDxWGpFlheUhcVz05tomoFAYkmG7kA
         PA1g==
X-Gm-Message-State: AOJu0YwXYMHGr50EC77NbzL0b+2to7dYHDnCENQXwsCtOc0sICA2Qawf
	7dYm1qgrlph5RgwC8SvcfSzTNTdm/ntmpA==
X-Google-Smtp-Source: AGHT+IGwoNxDxJen0x0iEmE/EAOpNBvnKl0zodWypqrdQw7SMOVqC4Y0UwsgY+IsGJ0sQ0pBpg5+/v+okoPmKA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6902:dc5:b0:db4:5d34:fa5 with SMTP id
 de5-20020a0569020dc500b00db45d340fa5mr40161ybb.0.1702320980637; Mon, 11 Dec
 2023 10:56:20 -0800 (PST)
Date: Mon, 11 Dec 2023 10:55:52 -0800
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211185552.3856862-1-jmattson@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231211185552.3856862-6-jmattson@google.com>
Subject: [kvm-unit-tests PATCH 5/5] nVMX: add test for posted interrupts
From: Jim Mattson <jmattson@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: Oliver Upton <oliver.upton@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

Test virtual posted interrupts under the following conditions:

    - vTPR[7:4] >= VECTOR[7:4]: Expect the L2 interrupt to be blocked.
      The bit corresponding to the posted interrupt should be set in L2's
      vIRR. Test with a running guest.

    - vTPR[7:4] < VECTOR[7:4]: Expect the interrupt to be delivered and the
      ISR to execute once. Test with a running and halted guest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/asm/bitops.h |   8 +++
 x86/unittests.cfg    |   8 +++
 x86/vmx_tests.c      | 133 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)

diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
index 13a25ec9853d..54ec9c424cd6 100644
--- a/lib/x86/asm/bitops.h
+++ b/lib/x86/asm/bitops.h
@@ -13,4 +13,12 @@
 
 #define HAVE_BUILTIN_FLS 1
 
+static inline void test_and_set_bit(long nr, unsigned long *addr)
+{
+	asm volatile("lock; bts %1,%0"
+		     : "+m" (*addr)
+		     : "Ir" (nr)
+		     : "memory");
+}
+
 #endif
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f307168b0e01..9598c61ef7ac 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -366,6 +366,14 @@ arch = x86_64
 groups = vmx
 timeout = 10
 
+[vmx_posted_intr_test]
+file = vmx.flat
+smp = 2
+extra_params = -cpu max,+vmx -append "vmx_posted_interrupts_test"
+arch = x86_64
+groups = vmx
+timeout = 10
+
 [vmx_apic_passthrough_thread]
 file = vmx.flat
 smp = 2
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a26f77e92f72..1a3da59632dc 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -65,6 +65,11 @@ static u32 *get_vapic_page(void)
 	return (u32 *)phys_to_virt(vmcs_read(APIC_VIRT_ADDR));
 }
 
+static u64 *get_pi_desc(void)
+{
+	return (u64 *)phys_to_virt(vmcs_read(POSTED_INTR_DESC_ADDR));
+}
+
 static void basic_guest_main(void)
 {
 	report_pass("Basic VMX test");
@@ -9327,6 +9332,18 @@ static void enable_vid(void)
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VINTD | CPU_VIRT_X2APIC);
 }
 
+#define	PI_VECTOR	255
+
+static void enable_posted_interrupts(void)
+{
+	void *pi_desc = alloc_page();
+
+	vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
+	vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
+	vmcs_write(PINV, PI_VECTOR);
+	vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
+}
+
 static void trigger_ioapic_scan_thread(void *data)
 {
 	/* Wait until other CPU entered L2 */
@@ -10722,12 +10739,18 @@ enum Vid_op {
 	VID_OP_SET_CR8,
 	VID_OP_SELF_IPI,
 	VID_OP_TERMINATE,
+	VID_OP_SPIN,
+	VID_OP_HLT,
 };
 
 struct vmx_basic_vid_test_guest_args {
 	enum Vid_op op;
 	u8 nr;
 	u32 isr_exec_cnt;
+	u32 *virtual_apic_page;
+	u64 *pi_desc;
+	u32 dest;
+	bool in_guest;
 } vmx_basic_vid_test_guest_args;
 
 /*
@@ -10743,6 +10766,14 @@ static void set_virr_bit(volatile u32 *virtual_apic_page, u8 nr)
 	virtual_apic_page[page_offset] |= mask;
 }
 
+static void clear_virr_bit(volatile u32 *virtual_apic_page, u8 nr)
+{
+	u32 page_offset = (0x200 | ((nr & 0xE0) >> 1)) / sizeof(u32);
+	u32 mask = 1 << (nr & 0x1f);
+
+	virtual_apic_page[page_offset] &= ~mask;
+}
+
 static bool get_virr_bit(volatile u32 *virtual_apic_page, u8 nr)
 {
 	u32 page_offset = (0x200 | ((nr & 0xE0) >> 1)) / sizeof(u32);
@@ -10783,6 +10814,24 @@ static void vmx_basic_vid_test_guest(void)
 		case VID_OP_SELF_IPI:
 			vmx_x2apic_write(APIC_SELF_IPI, nr);
 			break;
+		case VID_OP_HLT:
+			cli();
+			barrier();
+			args->in_guest = true;
+			barrier();
+			safe_halt();
+			break;
+		case VID_OP_SPIN: {
+			u32 *virtual_apic_page = args->virtual_apic_page;
+			u32 prev_cnt = args->isr_exec_cnt;
+			u8 nr = args->nr;
+
+			args->in_guest = true;
+			while (args->isr_exec_cnt == prev_cnt &&
+			       !get_virr_bit(virtual_apic_page, nr))
+				pause();
+			clear_virr_bit(virtual_apic_page, nr);
+		}
 		default:
 			break;
 		}
@@ -10803,6 +10852,7 @@ static void set_isrs_for_vmx_basic_vid_test(void)
 	 */
 	for (nr = 0x21; nr < 0x100; nr++) {
 		vmcs_write(GUEST_INT_STATUS, 0);
+		args->virtual_apic_page = get_vapic_page();
 		args->op = VID_OP_SET_ISR;
 		args->nr = nr;
 		args->isr_exec_cnt = 0;
@@ -10812,6 +10862,27 @@ static void set_isrs_for_vmx_basic_vid_test(void)
 	report(true, "Set ISR for vectors 33-255.");
 }
 
+static void post_interrupt(u8 vector, u32 dest)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+
+	test_and_set_bit(vector, args->pi_desc);
+	test_and_set_bit(256, args->pi_desc);
+	apic_icr_write(PI_VECTOR, dest);
+}
+
+static void vmx_posted_interrupts_test_worker(void *data)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+
+	while (!args->in_guest)
+		pause();
+
+	post_interrupt(args->nr, args->dest);
+}
+
 /*
  * Test virtual interrupt delivery (VID) at VM-entry or TPR virtualization
  *
@@ -10843,6 +10914,7 @@ static void test_basic_vid(u8 nr, u8 tpr, enum Vid_op op, u32 isr_exec_cnt_want,
 	 * delivery, sets VPPR to VTPR, when SVI is 0.
 	 */
 	args->isr_exec_cnt = 0;
+	args->virtual_apic_page = get_vapic_page();
 	args->op = op;
 	switch (op) {
 	case VID_OP_SELF_IPI:
@@ -10855,6 +10927,15 @@ static void test_basic_vid(u8 nr, u8 tpr, enum Vid_op op, u32 isr_exec_cnt_want,
 		args->nr = task_priority_class(tpr);
 		set_vtpr(0xff);
 		break;
+	case VID_OP_SPIN:
+	case VID_OP_HLT:
+		vmcs_write(GUEST_INT_STATUS, 0);
+		args->nr = nr;
+		set_vtpr(tpr);
+		args->in_guest = false;
+		barrier();
+		on_cpu_async(1, vmx_posted_interrupts_test_worker, NULL);
+		break;
 	default:
 		vmcs_write(GUEST_INT_STATUS, nr);
 		set_vtpr(tpr);
@@ -10998,6 +11079,57 @@ static void vmx_eoi_virt_test(void)
 	assert_exit_reason(VMX_VMCALL);
 }
 
+static void vmx_posted_interrupts_test(void)
+{
+	volatile struct vmx_basic_vid_test_guest_args *args =
+		&vmx_basic_vid_test_guest_args;
+	u16 vector;
+	u8 class;
+
+	if (!cpu_has_apicv()) {
+		report_skip("%s : Not all required APICv bits supported", __func__);
+		return;
+	}
+
+	if (cpu_count() < 2) {
+		report_skip("%s : CPU count < 2", __func__);
+		return;
+	}
+
+	enable_vid();
+	enable_posted_interrupts();
+	args->pi_desc = get_pi_desc();
+	args->dest = apic_id();
+
+	test_set_guest(vmx_basic_vid_test_guest);
+	set_isrs_for_vmx_basic_vid_test();
+
+	for (class = 0; class < 16; class++) {
+		for (vector = 33; vector < 256; vector++) {
+			u32 isr_exec_cnt_want =
+					(task_priority_class(vector) > class) ?
+					1 : 0;
+
+			test_basic_vid(vector, class << 4, VID_OP_SPIN,
+				       isr_exec_cnt_want, false);
+
+			/*
+			 * Only test posted interrupts to a halted vCPU if we
+			 * expect the interrupt to be serviced. Otherwise, the
+			 * vCPU could HLT indefinitely.
+			 */
+			if (isr_exec_cnt_want)
+				test_basic_vid(vector, class << 4, VID_OP_HLT,
+					       isr_exec_cnt_want, false);
+		}
+	}
+	report(true, "Posted vectors 33-25 cross TPR classes 0-0xf, running and sometimes halted\n");
+
+	/* Terminate the guest */
+	args->op = VID_OP_TERMINATE;
+	enter_guest();
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
@@ -11054,6 +11186,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(virt_x2apic_mode_test),
 	TEST(vmx_basic_vid_test),
 	TEST(vmx_eoi_virt_test),
+	TEST(vmx_posted_interrupts_test),
 	/* APIC pass-through tests */
 	TEST(vmx_apic_passthrough_test),
 	TEST(vmx_apic_passthrough_thread_test),
-- 
2.43.0.472.g3155946c3a-goog


