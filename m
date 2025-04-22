Return-Path: <kvm+bounces-43785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B59FFA961DC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BA747A6E4D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5C2277023;
	Tue, 22 Apr 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OxFRBToW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2912626738D;
	Tue, 22 Apr 2025 08:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310242; cv=none; b=FnqSINWqW0kCwbkgt/EEMkleDT+/OOEJVTnRtYj3TPAMovtxiN2BUmbINDrPaGzZP3tI5zSizrMYhFzqi13KKW/hC0a5iNy9HcAZ78TryrC5ajdL9Z8bIU2EsNW+4B08wI+RlYI3zpdVU9tkQXZ/mFh8GWAZqFBja/C6nxNj6Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310242; c=relaxed/simple;
	bh=yBGZYj6e60Xkd31sxfmX0SXfJgjyWcQUtEfLxC+yd5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7vZAOKpSiFbdQoagPIJfrgtaLH7IBNr3iU/t/KwZMSJ9zhuNoYy6oklTMAeg9sqSBdlmknnxRtnmOfje1f1pG46V7zd2n0C/vq2vS23bC42v4mq4DNHVkjRbcuZq5iqDf53A39wPGLTt73btvW48KWGSseL/poyC/Wg8gfPn1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=OxFRBToW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9b1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:07 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9b1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310189;
	bh=1txH+adcfOwIr5LH/ZlSlDHGsa/VNPa8LSISbt9l4Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxFRBToWvEqJ0D8+VHe17wCVzLMgXTwVfmryl84uMGCcCa1OR1gcYgk3F9JimIkEm
	 Id/7hCRonS1tRSe3XbDtDY2rOOSRAECeUFgk8SnqUTUQVMI7fMsmlmLdA+V1Isnccx
	 NyOxGoeye8+rFjFY7d/LaanWDAMzgutZnK7I8bQcQOzDgKbXuT2nLEFt3l17FoQjbN
	 0MBd1FBVWKYzzM4HdY+mKWx4rA3pjbiDgR4YfpiXTsRCo/G4/quQSJEIDnLLYiZ/pn
	 +gaaR0PJHyRUhR9gBfrfjXO0nxpya9KvdRYx5dSosavK3jrRh2vDAAe1RpFOl3uFKb
	 EUpT5J98djaIA==
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
Subject: [RFC PATCH v2 23/34] x86/extable: Remove new dead code in ex_handler_msr()
Date: Tue, 22 Apr 2025 01:22:04 -0700
Message-ID: <20250422082216.1954310-24-xin@zytor.com>
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

The MSR read APIs no longer expect RAX or EDX:EAX to be cleared upon
returning from #GP caused by MSR read instructions.

The MSR safe APIs no longer assume -EIO being returned in a register
from #GP caused by MSR instructions.

Remove new dead code due to above changes.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/mm/extable.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 6bf4c2a43c2c..ea3fe7f32772 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -165,7 +165,7 @@ static bool ex_handler_uaccess(const struct exception_table_entry *fixup,
 }
 
 static bool ex_handler_msr(const struct exception_table_entry *fixup,
-			   struct pt_regs *regs, bool wrmsr, bool safe, int reg)
+			   struct pt_regs *regs, bool wrmsr, bool safe)
 {
 	bool imm_insn = is_msr_imm_insn((void *)regs->ip);
 	u32 msr;
@@ -207,17 +207,6 @@ static bool ex_handler_msr(const struct exception_table_entry *fixup,
 		show_stack_regs(regs);
 	}
 
-	if (!wrmsr) {
-		/* Pretend that the read succeeded and returned 0. */
-		regs->ax = 0;
-
-		if (!imm_insn)
-			regs->dx = 0;
-	}
-
-	if (safe)
-		*pt_regs_nr(regs, reg) = -EIO;
-
 	return ex_handler_default(fixup, regs);
 }
 
@@ -395,13 +384,13 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		case EX_TYPE_BPF:
 			return ex_handler_bpf(e, regs);
 		case EX_TYPE_WRMSR:
-			return ex_handler_msr(e, regs, true, false, reg);
+			return ex_handler_msr(e, regs, true, false);
 		case EX_TYPE_RDMSR:
-			return ex_handler_msr(e, regs, false, false, reg);
+			return ex_handler_msr(e, regs, false, false);
 		case EX_TYPE_WRMSR_SAFE:
-			return ex_handler_msr(e, regs, true, true, reg);
+			return ex_handler_msr(e, regs, true, true);
 		case EX_TYPE_RDMSR_SAFE:
-			return ex_handler_msr(e, regs, false, true, reg);
+			return ex_handler_msr(e, regs, false, true);
 		case EX_TYPE_WRMSR_IN_MCE:
 			ex_handler_msr_mce(regs, true);
 			break;
-- 
2.49.0


