Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32114502E91
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 20:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbiDOSKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 14:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiDOSKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 14:10:08 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DD461A07
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:07:39 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q19so7995871pgm.6
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 11:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x7MJWRHYqPOGLxGYrHJRBQ18uYlAWV+WiE2aYsYAhKk=;
        b=TDqQrjSWbrc/qWZKYE+ZL9qEMgr3JFbdCC5NwNrMtMNHhf8TscyW3PhBnVfP4WaPkT
         j5+OIId99pY99sZwfDSy+LslcAUQnV/zPWwFDmGM/oKmYKGA/zLurwSajY85jKuV8mRV
         ftphn0q8vcR4Q+tm7rdON54HxyOiUicz/fPPq5LUcM0E2RKyx576gih3wB/m+UKgpwFL
         BsgGO8/SZvdOMzaoIe/za3ezYZrCYxMpPJYXrbJDUpcTeVlSYKrC5CiriTNNKcEPyGP+
         Xv6NsHs6O6wO2z4IUbZlwDy0OJQkh1jDk18/IfpJ/NRB8pixM5Jv88BzrBg7ZdYSF8I9
         fBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x7MJWRHYqPOGLxGYrHJRBQ18uYlAWV+WiE2aYsYAhKk=;
        b=7Jjwd70jJAn5+oR0dr/LKRsBs+hkM5d2X89OGiSRgq3sdjE6LRo4gm+uWO1EgTpe9i
         HgjnPubX1kuoOFuZAEmc1moT/TziFsFZSDvvaEfFPF88acxyXU/YOmZyZRxklWVzHCBa
         Ws85qfvDYXemGU6WfaNABIAFwi7m1qoCfktUI6QSA3zbBfE+4qevwLpmHrSkKgSEDS+9
         j7uosVUVSvLDF91NoqPcvnrvhwVlF9TB8OwwlDfiBbR9YuTRuMEG0JAL3BWGd1ILwHdl
         o0GjVpSLdar1PZgRJrM7q13T6twMVvQgOTP86prtHAFy0FoPjZArlHHjk3zlAXuoq5i4
         9w+w==
X-Gm-Message-State: AOAM530+O5iVscjs4EbvfydRRajHuYji6O3kRkkzt40x+Hf4fwEK53JX
        lZaCOXLro2QHBsrRsPbvfrJzuQ==
X-Google-Smtp-Source: ABdhPJyEhp9HVzCTtqUMom7iE/i0F79qKdGpCFuSvwUzGRvHneEFJ4RtsNqujZvf23MLo9USwireEw==
X-Received: by 2002:a05:6a00:1512:b0:505:da8c:26ba with SMTP id q18-20020a056a00151200b00505da8c26bamr317564pfu.63.1650046058784;
        Fri, 15 Apr 2022 11:07:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm3682370pfl.140.2022.04.15.11.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 11:07:38 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:07:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder
 from Linux
Message-ID: <Ylm0ZmhaklG9AqND@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-5-varad.gautam@suse.com>
 <YkzuvuLYjira8iOW@google.com>
 <Yk/nUINKexK5mpa0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk/nUINKexK5mpa0@suse.de>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022, Joerg Roedel wrote:
> On Wed, Apr 06, 2022 at 01:37:02AM +0000, Sean Christopherson wrote:
> > Do we really need Linux's decoder for this?  Linux needs a more robust decoder
> > because it has to deal with userspace crud, but KUT should have full control over
> > what code it encounters in a #VC handler, e.g. we should never have to worry about
> > ignore prefixes on a WRMSR.  And looking at future patches, KUT is still looking
> > at raw opcode bytes, e.g. 
> > 
> > 	/* Is it a WRMSR? */
> > 	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
> > 
> > and the giant switch in vc_ioio_exitinfo().
> > 
> > The decoder does bring a bit of cleanliness, but 2k+ lines of code that's likely
> > to get stale fairly quickly is going to be a maintenance burden.  And we certainly
> > don't need things like VEX prefix handling :-)
> > 
> > Do you happen to have data on how often each flavors of instructions is encountered?
> > E.g. can we get away with a truly minimal "decoder" by modifying select tests to
> > avoid hard-to-decode instructions?  Or even patch them to do VMGEXIT directly?
> 
> Is it really less pain to have this code in KUT than not having it? The
> code for the instruction decoder is maintained in the kernel source
> tree, and KUT just can pull in a new version if needed.

But how will we know when a new version is needed?  I agree that the actual update
will likely be trivial, but if something does go awry, debugging will be painful.

If we drop string I/O decoding, this boils down to CPUID, MSR, and port I/O.

Very unsurprisingly, objdump+grep shows that CPUID and {RD,WR}MSR never have any
prefixes, i.e. they can be hardcoded to expect the exact 2-byte opcode.

Port I/O does use the operand size prefix, but that's trivial to handle.  At that
point, the only decoding beyond the base opcode is the imm8 for the non-DX versions
of IN and OUT.

Compile tested only, and I've no idea if the exception forwarding will actually
work, but IMO this shows that for at least basic support, the kernel's full
decoder is overkill.

If/when we get to MMIO, then 100% agree we need a more formal decoder.  But even
then, I would prefer to more judiciously pull in the bits we need, e.g. it's
not like insn_decode_mmio() is doing anything clever.  The pieces we really need
are for decoding ModR/M and SIB.

---
 lib/x86/amd_sev.h    |  23 ----
 lib/x86/amd_sev_vc.c | 300 +++++++++++++------------------------------
 2 files changed, 89 insertions(+), 234 deletions(-)

diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 17d0957..66abc75 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -19,7 +19,6 @@
 #include "asm/page.h"
 #include "efi.h"
 #include "processor.h"
-#include "insn/insn.h"
 #include "svm.h"
 
 struct __attribute__ ((__packed__)) ghcb {
@@ -39,28 +38,6 @@ struct __attribute__ ((__packed__)) ghcb {
 
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
-enum es_result {
-	ES_OK,			/* All good */
-	ES_UNSUPPORTED,		/* Requested operation not supported */
-	ES_VMM_ERROR,		/* Unexpected state from the VMM */
-	ES_DECODE_FAILED,	/* Instruction decoding failed */
-	ES_EXCEPTION,		/* Instruction caused exception */
-	ES_RETRY,		/* Retry instruction emulation */
-};
-
-struct es_fault_info {
-	unsigned long vector;
-	unsigned long error_code;
-	unsigned long cr2;
-};
-
-/* ES instruction emulation context */
-struct es_em_ctxt {
-	struct ex_regs *regs;
-	struct insn insn;
-	struct es_fault_info fi;
-};
-
 /*
  * AMD Programmer's Manual Volume 3
  *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index e8285f2..1784edb 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -5,7 +5,6 @@
  * - arch/x86/kernel/sev-shared.c
  *
  * SPDX-License-Identifier: GPL-2.0 */
-
 #include "amd_sev.h"
 #include "svm.h"
 #include "x86/xsave.h"
@@ -18,59 +17,21 @@ static void vc_ghcb_invalidate(struct ghcb *ghcb)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static bool vc_decoding_needed(unsigned long exit_code)
-{
-	/* Exceptions don't require to decode the instruction */
-	return !(exit_code >= SVM_EXIT_EXCP_BASE &&
-		 exit_code <= SVM_EXIT_LAST_EXCP);
-}
-
-static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
-{
-	unsigned char buffer[MAX_INSN_SIZE];
-	int ret;
-
-	memcpy(buffer, (unsigned char *)ctxt->regs->rip, MAX_INSN_SIZE);
-
-	ret = insn_decode(&ctxt->insn, buffer, MAX_INSN_SIZE, INSN_MODE_64);
-	if (ret < 0)
-		return ES_DECODE_FAILED;
-	else
-		return ES_OK;
-}
-
-static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
-				      struct ex_regs *regs,
-				      unsigned long exit_code)
-{
-	enum es_result ret = ES_OK;
-
-	memset(ctxt, 0, sizeof(*ctxt));
-	ctxt->regs = regs;
-
-	if (vc_decoding_needed(exit_code))
-		ret = vc_decode_insn(ctxt);
-
-	return ret;
-}
-
-static void vc_finish_insn(struct es_em_ctxt *ctxt)
-{
-	ctxt->regs->rip += ctxt->insn.length;
-}
-
 static inline void sev_es_wr_ghcb_msr(u64 val)
 {
 	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
 }
 
-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-					  struct es_em_ctxt *ctxt,
-					  u64 exit_code, u64 exit_info_1,
-					  u64 exit_info_2)
+static uint8_t vc_get_insn_byte(struct ex_regs *regs, int idx)
 {
-	enum es_result ret;
+	return ((uint8_t *)regs->rip)[idx];
+}
 
+extern void do_handle_exception(struct ex_regs *regs);
+
+static int sev_es_ghcb_hv_call(struct ghcb *ghcb, struct ex_regs *regs,
+			       u64 exit_code, u64 exit_info_1, u64 exit_info_2)
+{
 	/* Fill in protocol and format specifiers */
 	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
 	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
@@ -92,28 +53,27 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 		if ((info & SVM_EVTINJ_VALID) &&
 		    ((v == GP_VECTOR) || (v == UD_VECTOR)) &&
 		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
-			ctxt->fi.vector = v;
+			regs->vector = v;
 			if (info & SVM_EVTINJ_VALID_ERR)
-				ctxt->fi.error_code = info >> 32;
-			ret = ES_EXCEPTION;
+				regs->error_code = info >> 32;
+
+			do_handle_exception(regs);
+			return -14;
 		} else {
-			ret = ES_VMM_ERROR;
+			assert(0);
 		}
-	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
-		ret = ES_VMM_ERROR;
 	} else {
-		ret = ES_OK;
+		assert(!(ghcb->save.sw_exit_info_1 & 0xffffffff));
 	}
-
-	return ret;
+	return 0;
 }
 
-static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
-				      struct es_em_ctxt *ctxt)
+static void vc_handle_cpuid(struct ghcb *ghcb, struct ex_regs *regs)
 {
-	struct ex_regs *regs = ctxt->regs;
 	u32 cr4 = read_cr4();
-	enum es_result ret;
+
+	assert(vc_get_insn_byte(regs, 0) == 0x0f &&
+	       vc_get_insn_byte(regs, 1) == 0xa2);
 
 	ghcb_set_rax(ghcb, regs->rax);
 	ghcb_set_rcx(ghcb, regs->rcx);
@@ -128,32 +88,29 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 		ghcb_set_xcr0(ghcb, 1);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
-	if (ret != ES_OK)
-		return ret;
+	if (sev_es_ghcb_hv_call(ghcb, regs, SVM_EXIT_CPUID, 0, 0))
+		return;
 
-	if (!(ghcb_rax_is_valid(ghcb) &&
-	      ghcb_rbx_is_valid(ghcb) &&
-	      ghcb_rcx_is_valid(ghcb) &&
-	      ghcb_rdx_is_valid(ghcb)))
-		return ES_VMM_ERROR;
+	assert(ghcb_rax_is_valid(ghcb) && ghcb_rbx_is_valid(ghcb) &&
+	       ghcb_rcx_is_valid(ghcb) && ghcb_rdx_is_valid(ghcb));
 
 	regs->rax = ghcb->save.rax;
 	regs->rbx = ghcb->save.rbx;
 	regs->rcx = ghcb->save.rcx;
 	regs->rdx = ghcb->save.rdx;
 
-	return ES_OK;
+	regs->rip += 2;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static void vc_handle_msr(struct ghcb *ghcb, struct ex_regs *regs)
 {
-	struct ex_regs *regs = ctxt->regs;
-	enum es_result ret;
 	u64 exit_info_1;
 
 	/* Is it a WRMSR? */
-	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
+	assert(vc_get_insn_byte(regs, 0) == 0x0f &&
+	       (vc_get_insn_byte(regs, 1) == 0x30 || vc_get_insn_byte(regs, 1) == 0x32));
+
+	exit_info_1 = (vc_get_insn_byte(regs, 1) == 0x30) ? 1 : 0;
 
 	ghcb_set_rcx(ghcb, regs->rcx);
 	if (exit_info_1) {
@@ -161,23 +118,19 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		ghcb_set_rdx(ghcb, regs->rdx);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
+	if (sev_es_ghcb_hv_call(ghcb, regs, SVM_EXIT_MSR, exit_info_1, 0))
+		return;
 
-	if ((ret == ES_OK) && (!exit_info_1)) {
+	if (!exit_info_1) {
 		regs->rax = ghcb->save.rax;
 		regs->rdx = ghcb->save.rdx;
 	}
 
-	return ret;
+	regs->rip += 2;
 }
 
-#define IOIO_TYPE_STR  BIT(2)
 #define IOIO_TYPE_IN   1
-#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
 #define IOIO_TYPE_OUT  0
-#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
-
-#define IOIO_REP       BIT(3)
 
 #define IOIO_ADDR_64   BIT(9)
 #define IOIO_ADDR_32   BIT(8)
@@ -187,87 +140,58 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 #define IOIO_DATA_16   BIT(5)
 #define IOIO_DATA_8    BIT(4)
 
-#define IOIO_SEG_ES    (0 << 10)
-#define IOIO_SEG_DS    (3 << 10)
+#define OPERAND_SIZE_PREFIX 0x66
 
-/**
- * insn_has_rep_prefix() - Determine if instruction has a REP prefix
- * @insn:       Instruction containing the prefix to inspect
- *
- * Returns:
- *
- * 1 if the instruction has a REP prefix, 0 if not.
- */
-static int insn_has_rep_prefix(struct insn *insn)
+static uint64_t vc_ioio_exit_info(struct ex_regs *regs)
 {
-        insn_byte_t p;
-        int i;
+	bool has_op_size_prefix = vc_get_insn_byte(regs, 0) == OPERAND_SIZE_PREFIX;
+	int opcode_start = has_op_size_prefix ? 1 : 0;
+	uint64_t exit_info = IOIO_ADDR_32;
 
-        insn_get_prefixes(insn);
-
-        for_each_insn_prefix(insn, i, p) {
-                if (p == 0xf2 || p == 0xf3)
-                        return 1;
-        }
-
-        return 0;
-}
-
-static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
-{
-	struct insn *insn = &ctxt->insn;
-	*exitinfo = 0;
-
-	switch (insn->opcode.bytes[0]) {
+	switch (vc_get_insn_byte(regs, opcode_start)) {
 	/* INS opcodes */
 	case 0x6c:
 	case 0x6d:
-		*exitinfo |= IOIO_TYPE_INS;
-		*exitinfo |= IOIO_SEG_ES;
-		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
-		break;
-
 	/* OUTS opcodes */
 	case 0x6e:
 	case 0x6f:
-		*exitinfo |= IOIO_TYPE_OUTS;
-		*exitinfo |= IOIO_SEG_DS;
-		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
-		break;
+		report_fail("blah blah blah");
+		assert(0);
 
 	/* IN immediate opcodes */
 	case 0xe4:
 	case 0xe5:
-		*exitinfo |= IOIO_TYPE_IN;
-		*exitinfo |= (u8)insn->immediate.value << 16;
+		exit_info |= IOIO_TYPE_IN;
+		exit_info |= vc_get_insn_byte(regs, opcode_start + 1) << 16;
 		break;
 
 	/* OUT immediate opcodes */
 	case 0xe6:
 	case 0xe7:
-		*exitinfo |= IOIO_TYPE_OUT;
-		*exitinfo |= (u8)insn->immediate.value << 16;
+		exit_info |= IOIO_TYPE_OUT;
+		exit_info |= vc_get_insn_byte(regs, opcode_start + 1) << 16;
 		break;
 
 	/* IN register opcodes */
 	case 0xec:
 	case 0xed:
-		*exitinfo |= IOIO_TYPE_IN;
-		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		exit_info |= IOIO_TYPE_IN;
+		exit_info |= (regs->rdx & 0xffff) << 16;
 		break;
 
 	/* OUT register opcodes */
 	case 0xee:
 	case 0xef:
-		*exitinfo |= IOIO_TYPE_OUT;
-		*exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
+		exit_info |= IOIO_TYPE_OUT;
+		exit_info |= (regs->rdx & 0xffff) << 16;
 		break;
 
 	default:
-		return ES_DECODE_FAILED;
+		report_fail("blah blah blah");
+		assert(0);
 	}
 
-	switch (insn->opcode.bytes[0]) {
+	switch (vc_get_insn_byte(regs, opcode_start)) {
 	case 0x6c:
 	case 0x6e:
 	case 0xe4:
@@ -275,100 +199,50 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	case 0xec:
 	case 0xee:
 		/* Single byte opcodes */
-		*exitinfo |= IOIO_DATA_8;
+		exit_info |= IOIO_DATA_8;
 		break;
 	default:
 		/* Length determined by instruction parsing */
-		*exitinfo |= (insn->opnd_bytes == 2) ? IOIO_DATA_16
-						     : IOIO_DATA_32;
+		exit_info |= has_op_size_prefix ? IOIO_DATA_16 : IOIO_DATA_32;
 	}
-	switch (insn->addr_bytes) {
-	case 2:
-		*exitinfo |= IOIO_ADDR_16;
-		break;
-	case 4:
-		*exitinfo |= IOIO_ADDR_32;
-		break;
-	case 8:
-		*exitinfo |= IOIO_ADDR_64;
-		break;
-	}
-
-	if (insn_has_rep_prefix(insn))
-		*exitinfo |= IOIO_REP;
 
-	return ES_OK;
+	return exit_info;
 }
 
-static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static void vc_handle_ioio(struct ghcb *ghcb, struct ex_regs *regs)
 {
-	struct ex_regs *regs = ctxt->regs;
-	u64 exit_info_1;
-	enum es_result ret;
-
-	ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
-	if (ret != ES_OK)
-		return ret;
+	u64 exit_info_1 = vc_ioio_exit_info(regs);
 
-	if (exit_info_1 & IOIO_TYPE_STR) {
-		ret = ES_VMM_ERROR;
-	} else {
-		/* IN/OUT into/from rAX */
+	/* IN/OUT into/from rAX */
+	int bits = (exit_info_1 & 0x70) >> 1;
+	u64 rax = 0;
 
-		int bits = (exit_info_1 & 0x70) >> 1;
-		u64 rax = 0;
+	if (!(exit_info_1 & IOIO_TYPE_IN))
+		rax = lower_bits(regs->rax, bits);
 
-		if (!(exit_info_1 & IOIO_TYPE_IN))
-			rax = lower_bits(regs->rax, bits);
+	ghcb_set_rax(ghcb, rax);
 
-		ghcb_set_rax(ghcb, rax);
+	if (sev_es_ghcb_hv_call(ghcb, regs, SVM_EXIT_IOIO, exit_info_1, 0))
+		return;
 
-		ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
-		if (ret != ES_OK)
-			return ret;
-
-		if (exit_info_1 & IOIO_TYPE_IN) {
-			if (!ghcb_rax_is_valid(ghcb))
-				return ES_VMM_ERROR;
-			regs->rax = lower_bits(ghcb->save.rax, bits);
-		}
+	if (exit_info_1 & IOIO_TYPE_IN) {
+		assert(ghcb_rax_is_valid(ghcb));
+		regs->rax = lower_bits(ghcb->save.rax, bits);
 	}
 
-	return ret;
-}
-
-static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
-					 struct ghcb *ghcb,
-					 unsigned long exit_code)
-{
-	enum es_result result;
-
-	switch (exit_code) {
-	case SVM_EXIT_CPUID:
-		result = vc_handle_cpuid(ghcb, ctxt);
-		break;
-	case SVM_EXIT_MSR:
-		result = vc_handle_msr(ghcb, ctxt);
-		break;
-	case SVM_EXIT_IOIO:
-		result = vc_handle_ioio(ghcb, ctxt);
-		break;
-	default:
-		/*
-		 * Unexpected #VC exception
-		 */
-		result = ES_UNSUPPORTED;
-	}
+	if (vc_get_insn_byte(regs, 0) == OPERAND_SIZE_PREFIX)
+		regs->rip += 1;
 
-	return result;
+	if (exit_info_1 & IOIO_DATA_8)
+		regs->rip += 1;
+	else
+		regs->rip += 2;
 }
 
 void handle_sev_es_vc(struct ex_regs *regs)
 {
 	struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
 	unsigned long exit_code = regs->error_code;
-	struct es_em_ctxt ctxt;
-	enum es_result result;
 
 	if (!ghcb) {
 		/* TODO: kill guest */
@@ -376,15 +250,19 @@ void handle_sev_es_vc(struct ex_regs *regs)
 	}
 
 	vc_ghcb_invalidate(ghcb);
-	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
-	if (result == ES_OK)
-		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
-	if (result == ES_OK) {
-		vc_finish_insn(&ctxt);
-	} else {
-		printf("Unable to handle #VC exitcode, exit_code=%lx result=%x\n",
-		       exit_code, result);
-	}
 
-	return;
+	switch (exit_code) {
+	case SVM_EXIT_CPUID:
+		vc_handle_cpuid(ghcb, regs);
+		break;
+	case SVM_EXIT_MSR:
+		vc_handle_msr(ghcb, regs);
+		break;
+	case SVM_EXIT_IOIO:
+		 vc_handle_ioio(ghcb, regs);
+		break;
+	default:
+		report_fail("blah blah blah");
+		assert(0);
+	}
 }

base-commit: 845549433d850e408968d4bd94892593cf4a324c
-- 

