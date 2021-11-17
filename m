Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C734547C2
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhKQNw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKQNwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:55 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B375EC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:56 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso3855508wmh.0
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YxFIHjc8AG0GZMKJ1URezlzAo6i1y61Dhgx501f5h2U=;
        b=CW0xY8wMgnkOjkxbvfvpehZUSK5hvs1qlboLCMq+/OX2tsLaPyAoRqFMzdLbmVjJzF
         qII/vM5nX8Lvba6bi3N4n4/CwrXEJQ/MTUxjY3AmNFH3LRZku1396vDEjVpHAbqpqqpg
         bEhcGWC2RVDpAQYdneIIoCLwzdw0EqudbLZmSLApOJW3LXtFiGOV4HcpaXVqTqF/r3gi
         Z6W1sivu1CNqOaGWPckmh5HOxcU4VHhzHmOcwpx+/qFr/GY1QH8Z3lFolDiR5ORaP7Mr
         9UvPDE4dqPfnZfuqg/Ib4ZiRT9D3RguaaOdwdTOP1XHysrb/UpKpiJ8YUyb5x6KtAo/Y
         ODoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YxFIHjc8AG0GZMKJ1URezlzAo6i1y61Dhgx501f5h2U=;
        b=qBhykRpFuDSIpA3PnSHcoE2OgrlW45vQKMY5h4GtK5jM8feALY1qHslCyTZWvetVx8
         9TUOCHs6hBsVZrY6C9aQ2Orzrlx76PAWlD4/9/le8u6ki9V2HIMyWQoW7QaNme4EErF0
         mxQxfQr4ANeVCh8yZ9vOzc8+NMZsU2HiHQF9QZLlsATT/qL9RQWepf+kcBYyP9AYbQ0N
         HF1Sfa9WfI9FjY3LEwyv+j9JwYaA7P80jdvkSB092SMytGU+FaMv4J9txHvV604YK/sV
         FHnB30SvotHgxNRMVzbZsQ/xCW23m75LDcGNo7hlZTN8/oVq9q7XT/GPx071gXSypw0S
         Nn1A==
X-Gm-Message-State: AOAM532exFmbAP4BTUI1vaIOfo0sm64p0ANHNJ7d7faraFN7bkfnHIb0
        5X24rZZLhTtZBvK+IkYma5bvyzS1Rhk+4Q==
X-Google-Smtp-Source: ABdhPJy71ZX+JyVMU+7RUDDHi0E/1h+FMUb9PrakZVYc46qQITEwmmVEyq84c0FRzuUtrLoRPJ5UcA==
X-Received: by 2002:a1c:7e41:: with SMTP id z62mr51971886wmc.62.1637156995007;
        Wed, 17 Nov 2021 05:49:55 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:54 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 04/12] x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
Date:   Wed, 17 Nov 2021 14:47:44 +0100
Message-Id: <20211117134752.32662-5-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87

Suppress -Waddress-of-packed-member to allow taking addresses on struct
ghcb / struct vmcb_save_area fields.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev.h   | 106 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/svm.h       |  37 ++++++++++++++++
 x86/Makefile.x86_64 |   1 +
 3 files changed, 144 insertions(+)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index afbacf3..ed71c18 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -18,6 +18,49 @@
 #include "desc.h"
 #include "asm/page.h"
 #include "efi.h"
+#include "processor.h"
+#include "insn/insn.h"
+#include "svm.h"
+
+struct __attribute__ ((__packed__)) ghcb {
+	struct vmcb_save_area save;
+	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
+
+	u8 shared_buffer[2032];
+
+	u8 reserved_1[10];
+	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
+	u32 ghcb_usage;
+};
+
+/* SEV definitions from linux's include/asm/sev.h */
+#define GHCB_PROTO_OUR		0x0001UL
+#define GHCB_PROTOCOL_MAX	1ULL
+#define GHCB_DEFAULT_USAGE	0ULL
+
+#define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
+
+enum es_result {
+	ES_OK,			/* All good */
+	ES_UNSUPPORTED,		/* Requested operation not supported */
+	ES_VMM_ERROR,		/* Unexpected state from the VMM */
+	ES_DECODE_FAILED,	/* Instruction decoding failed */
+	ES_EXCEPTION,		/* Instruction caused exception */
+	ES_RETRY,		/* Retry instruction emulation */
+};
+
+struct es_fault_info {
+	unsigned long vector;
+	unsigned long error_code;
+	unsigned long cr2;
+};
+
+/* ES instruction emulation context */
+struct es_em_ctxt {
+	struct ex_regs *regs;
+	struct insn insn;
+	struct es_fault_info fi;
+};
 
 /*
  * AMD Programmer's Manual Volume 3
@@ -59,6 +102,69 @@ void handle_sev_es_vc(struct ex_regs *regs);
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
+static int _test_bit(int nr, const volatile unsigned long *addr)
+{
+	const volatile unsigned long *word = addr + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+
+	return (*word & mask) != 0;
+}
+
+/* GHCB Accessor functions from Linux's include/asm/svm.h */
+
+#define GHCB_BITMAP_IDX(field)							\
+	(offsetof(struct vmcb_save_area, field) / sizeof(u64))
+
+#define DEFINE_GHCB_ACCESSORS(field)						\
+	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)	\
+	{									\
+		return _test_bit(GHCB_BITMAP_IDX(field),				\
+				(unsigned long *)&ghcb->save.valid_bitmap);	\
+	}									\
+										\
+	static inline u64 ghcb_get_##field(struct ghcb *ghcb)			\
+	{									\
+		return ghcb->save.field;					\
+	}									\
+										\
+	static inline u64 ghcb_get_##field##_if_valid(struct ghcb *ghcb)	\
+	{									\
+		return ghcb_##field##_is_valid(ghcb) ? ghcb->save.field : 0;	\
+	}									\
+										\
+	static inline void ghcb_set_##field(struct ghcb *ghcb, u64 value)	\
+	{									\
+		set_bit(GHCB_BITMAP_IDX(field),				\
+			  (u8 *)&ghcb->save.valid_bitmap);		\
+		ghcb->save.field = value;					\
+	}
+
+DEFINE_GHCB_ACCESSORS(cpl)
+DEFINE_GHCB_ACCESSORS(rip)
+DEFINE_GHCB_ACCESSORS(rsp)
+DEFINE_GHCB_ACCESSORS(rax)
+DEFINE_GHCB_ACCESSORS(rcx)
+DEFINE_GHCB_ACCESSORS(rdx)
+DEFINE_GHCB_ACCESSORS(rbx)
+DEFINE_GHCB_ACCESSORS(rbp)
+DEFINE_GHCB_ACCESSORS(rsi)
+DEFINE_GHCB_ACCESSORS(rdi)
+DEFINE_GHCB_ACCESSORS(r8)
+DEFINE_GHCB_ACCESSORS(r9)
+DEFINE_GHCB_ACCESSORS(r10)
+DEFINE_GHCB_ACCESSORS(r11)
+DEFINE_GHCB_ACCESSORS(r12)
+DEFINE_GHCB_ACCESSORS(r13)
+DEFINE_GHCB_ACCESSORS(r14)
+DEFINE_GHCB_ACCESSORS(r15)
+DEFINE_GHCB_ACCESSORS(sw_exit_code)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
+DEFINE_GHCB_ACCESSORS(sw_scratch)
+DEFINE_GHCB_ACCESSORS(xcr0)
+
+#define MSR_AMD64_SEV_ES_GHCB          0xc0010130
+
 #endif /* TARGET_EFI */
 
 #endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index f74b13a..f046455 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -197,6 +197,42 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
+
+	/*
+	 * The following part of the save area is valid only for
+	 * SEV-ES guests when referenced through the GHCB or for
+	 * saving to the host save area.
+	 */
+	u8 reserved_7[72];
+	u32 spec_ctrl;          /* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_7b[4];
+	u32 pkru;
+	u8 reserved_7a[20];
+	u64 reserved_8;         /* rax already available at 0x01f8 */
+	u64 rcx;
+	u64 rdx;
+	u64 rbx;
+	u64 reserved_9;         /* rsp already available at 0x01d8 */
+	u64 rbp;
+	u64 rsi;
+	u64 rdi;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u8 reserved_10[16];
+	u64 sw_exit_code;
+	u64 sw_exit_info_1;
+	u64 sw_exit_info_2;
+	u64 sw_scratch;
+	u8 reserved_11[56];
+	u64 xcr0;
+	u8 valid_bitmap[16];
+	u64 x87_state_gpa;
 };
 
 struct __attribute__ ((__packed__)) vmcb {
@@ -297,6 +333,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_EXIT_WRITE_DR6 	0x036
 #define	SVM_EXIT_WRITE_DR7 	0x037
 #define SVM_EXIT_EXCP_BASE      0x040
+#define SVM_EXIT_LAST_EXCP     0x05f
 #define SVM_EXIT_INTR		0x060
 #define SVM_EXIT_NMI		0x061
 #define SVM_EXIT_SMI		0x062
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index fe6457c..cffd4b3 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -13,6 +13,7 @@ endif
 
 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
 COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
+COMMON_CFLAGS += -Wno-address-of-packed-member
 
 cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
-- 
2.32.0

