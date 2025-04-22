Return-Path: <kvm+bounces-43762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBFFA96298
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68D4C188C9A8
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E3F25A2C4;
	Tue, 22 Apr 2025 08:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="BHi1R6Ay"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD64424888E;
	Tue, 22 Apr 2025 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310230; cv=none; b=IdBjpFyCnkHeFGGWgNQoRgy49aLDlYEzsyrpntVWA88WTNzIk8AGmZVieE6O1VDiaY7P8vrg6bo5RWnb5Fj3Xjmym1Vu4nwBnkA8xRkEbrSbtq9ya5kTp6R5GChtvV9y58pw2PmROzZlHX4dywY5BEfRLRsM36nqLERdGK7dOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310230; c=relaxed/simple;
	bh=A7Q4uoK84rHePUBM6dp9wvO4znc2GXZoSCPZjM8WRTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSyMvNoZQ1lzKR5ZHU58f/vYqaEh54xdgeToV+hLB2HmnHdHZ846ZItawdpeBrU5NwnEAFEztaRywMEczUakKMAT0Ctg/EZbg739g1I4IDm82kQUcfl0G3ozwDf2xmpsF61qimVk3KxjVcVbKhJl63wKVwOvLEC7ISrUdsLgjDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=BHi1R6Ay; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9Y1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9Y1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310183;
	bh=C6RK2fGRo87/f3fhWDh3Rej6GAV9BaF6uT8JNGWqWns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHi1R6AyC9e0eh53/qDzjqBE+qQb4RzEZPU1rW+urzk4SW5zJKcQ990fyyFIzp3Ny
	 +ZO85XRSMlAItHcKxgVVuJ6bIFtxLdCzXCHEgZWwiSSp0I8ycHoE0kJWCt5vzx+Pgh
	 awTbjmxkSsaICsvEZ+f3G2x+NbMFPXt07P3uzry3qjGx+2+6ti08zGvKxuLOJ51QP+
	 Ze0/EZLEQhvkUUadlbZ9OJhPmV9dDJYOW9+dzQ1lM8BWN9kqIMaDRpHZAdWmrJFL7Y
	 OlvBsHTB19+9i+iy38t2OKh1xVb6wdoxeXiicjINWboz+d3fS/QhnsGL7tMDSnNgRM
	 ZbLi44P9yvsYw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 20/34] x86/extable: Implement EX_TYPE_FUNC_REWIND
Date: Tue, 22 Apr 2025 01:22:01 -0700
Message-ID: <20250422082216.1954310-21-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add a new exception type, which allows emulating an exception as if it
had happened at or near the call site of a function.  This allows a
function call inside an alternative for instruction emulation to "kick
back" the exception into the alternatives pattern, possibly invoking a
different exception handling pattern there, or at least indicating the
"real" location of the fault.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/asm.h                 |   6 +
 arch/x86/include/asm/extable_fixup_types.h |   1 +
 arch/x86/mm/extable.c                      | 135 +++++++++++++--------
 3 files changed, 91 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index a9f07799e337..722340d7c1af 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -243,5 +243,11 @@ register unsigned long current_stack_pointer asm(_ASM_SP);
 #define _ASM_EXTABLE_FAULT(from, to)				\
 	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_FAULT)
 
+#define _ASM_EXTABLE_FUNC_REWIND(from, ipdelta, spdelta)	\
+	_ASM_EXTABLE_TYPE(from, from /* unused */,		\
+			  EX_TYPE_FUNC_REWIND |			\
+			  EX_DATA_REG(spdelta) |		\
+			  EX_DATA_IMM(ipdelta))
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_ASM_H */
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 906b0d5541e8..9cd1cea45052 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -67,5 +67,6 @@
 #define	EX_TYPE_ZEROPAD			20 /* longword load with zeropad on fault */
 
 #define	EX_TYPE_ERETU			21
+#define	EX_TYPE_FUNC_REWIND		22
 
 #endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index f1743babafc8..6bf4c2a43c2c 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -319,6 +319,27 @@ static bool ex_handler_eretu(const struct exception_table_entry *fixup,
 }
 #endif
 
+/*
+ * Emulate a fault taken at the call site of a function.
+ *
+ * The combined reg and flags field are used as an unsigned number of
+ * machine words to pop off the stack before the return address, then
+ * the signed imm field is used as a delta from the return IP address.
+ */
+static bool ex_handler_func_rewind(struct pt_regs *regs, int data)
+{
+	const long ipdelta = FIELD_GET(EX_DATA_IMM_MASK, data);
+	const unsigned long pops = FIELD_GET(EX_DATA_REG_MASK | EX_DATA_FLAG_MASK, data);
+	unsigned long *sp;
+
+	sp = (unsigned long *)regs->sp;
+	sp += pops;
+	regs->ip = *sp++ + ipdelta;
+	regs->sp = (unsigned long)sp;
+
+	return true;
+}
+
 int ex_get_fixup_type(unsigned long ip)
 {
 	const struct exception_table_entry *e = search_exception_tables(ip);
@@ -331,6 +352,7 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 {
 	const struct exception_table_entry *e;
 	int type, reg, imm;
+	bool again;
 
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
@@ -346,60 +368,71 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	}
 #endif
 
-	e = search_exception_tables(regs->ip);
-	if (!e)
-		return 0;
-
-	type = FIELD_GET(EX_DATA_TYPE_MASK, e->data);
-	reg  = FIELD_GET(EX_DATA_REG_MASK,  e->data);
-	imm  = FIELD_GET(EX_DATA_IMM_MASK,  e->data);
-
-	switch (type) {
-	case EX_TYPE_DEFAULT:
-	case EX_TYPE_DEFAULT_MCE_SAFE:
-		return ex_handler_default(e, regs);
-	case EX_TYPE_FAULT:
-	case EX_TYPE_FAULT_MCE_SAFE:
-		return ex_handler_fault(e, regs, trapnr);
-	case EX_TYPE_UACCESS:
-		return ex_handler_uaccess(e, regs, trapnr, fault_addr);
-	case EX_TYPE_CLEAR_FS:
-		return ex_handler_clear_fs(e, regs);
-	case EX_TYPE_FPU_RESTORE:
-		return ex_handler_fprestore(e, regs);
-	case EX_TYPE_BPF:
-		return ex_handler_bpf(e, regs);
-	case EX_TYPE_WRMSR:
-		return ex_handler_msr(e, regs, true, false, reg);
-	case EX_TYPE_RDMSR:
-		return ex_handler_msr(e, regs, false, false, reg);
-	case EX_TYPE_WRMSR_SAFE:
-		return ex_handler_msr(e, regs, true, true, reg);
-	case EX_TYPE_RDMSR_SAFE:
-		return ex_handler_msr(e, regs, false, true, reg);
-	case EX_TYPE_WRMSR_IN_MCE:
-		ex_handler_msr_mce(regs, true);
-		break;
-	case EX_TYPE_RDMSR_IN_MCE:
-		ex_handler_msr_mce(regs, false);
-		break;
-	case EX_TYPE_POP_REG:
-		regs->sp += sizeof(long);
-		fallthrough;
-	case EX_TYPE_IMM_REG:
-		return ex_handler_imm_reg(e, regs, reg, imm);
-	case EX_TYPE_FAULT_SGX:
-		return ex_handler_sgx(e, regs, trapnr);
-	case EX_TYPE_UCOPY_LEN:
-		return ex_handler_ucopy_len(e, regs, trapnr, fault_addr, reg, imm);
-	case EX_TYPE_ZEROPAD:
-		return ex_handler_zeropad(e, regs, fault_addr);
+	do {
+		e = search_exception_tables(regs->ip);
+		if (!e)
+			return 0;
+
+		again = false;
+
+		type = FIELD_GET(EX_DATA_TYPE_MASK, e->data);
+		reg  = FIELD_GET(EX_DATA_REG_MASK,  e->data);
+		imm  = FIELD_GET(EX_DATA_IMM_MASK,  e->data);
+
+		switch (type) {
+		case EX_TYPE_DEFAULT:
+		case EX_TYPE_DEFAULT_MCE_SAFE:
+			return ex_handler_default(e, regs);
+		case EX_TYPE_FAULT:
+		case EX_TYPE_FAULT_MCE_SAFE:
+			return ex_handler_fault(e, regs, trapnr);
+		case EX_TYPE_UACCESS:
+			return ex_handler_uaccess(e, regs, trapnr, fault_addr);
+		case EX_TYPE_CLEAR_FS:
+			return ex_handler_clear_fs(e, regs);
+		case EX_TYPE_FPU_RESTORE:
+			return ex_handler_fprestore(e, regs);
+		case EX_TYPE_BPF:
+			return ex_handler_bpf(e, regs);
+		case EX_TYPE_WRMSR:
+			return ex_handler_msr(e, regs, true, false, reg);
+		case EX_TYPE_RDMSR:
+			return ex_handler_msr(e, regs, false, false, reg);
+		case EX_TYPE_WRMSR_SAFE:
+			return ex_handler_msr(e, regs, true, true, reg);
+		case EX_TYPE_RDMSR_SAFE:
+			return ex_handler_msr(e, regs, false, true, reg);
+		case EX_TYPE_WRMSR_IN_MCE:
+			ex_handler_msr_mce(regs, true);
+			break;
+		case EX_TYPE_RDMSR_IN_MCE:
+			ex_handler_msr_mce(regs, false);
+			break;
+		case EX_TYPE_POP_REG:
+			regs->sp += sizeof(long);
+			fallthrough;
+		case EX_TYPE_IMM_REG:
+			return ex_handler_imm_reg(e, regs, reg, imm);
+		case EX_TYPE_FAULT_SGX:
+			return ex_handler_sgx(e, regs, trapnr);
+		case EX_TYPE_UCOPY_LEN:
+			return ex_handler_ucopy_len(e, regs, trapnr, fault_addr, reg, imm);
+		case EX_TYPE_ZEROPAD:
+			return ex_handler_zeropad(e, regs, fault_addr);
 #ifdef CONFIG_X86_FRED
-	case EX_TYPE_ERETU:
-		return ex_handler_eretu(e, regs, error_code);
+		case EX_TYPE_ERETU:
+			return ex_handler_eretu(e, regs, error_code);
 #endif
-	}
+		case EX_TYPE_FUNC_REWIND:
+			again = ex_handler_func_rewind(regs, e->data);
+			break;
+		default:
+			break;	/* Will BUG() */
+		}
+	} while (again);
+
 	BUG();
+	return 0;
 }
 
 extern unsigned int early_recursion_flag;
-- 
2.49.0


