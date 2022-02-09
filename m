Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703DA4AFFF3
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiBIWNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 17:13:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiBIWNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 17:13:30 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F1DC0F8699
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 14:13:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y18so141623plb.11
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 14:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fx5b1qQwMlFVs21l/OX+krSp/uyB0q/jyfgtOYhq7dE=;
        b=gBEeF6BpUfDehwTkVhoxki42M0jD+d2SYRr6MRurSmkaOqBYNiYhFzzkd6FV5TcBZu
         3tBHQnb/hoBUkZh3ETyhokeD1Stsny6DlY/sSqk6MM8Ezr8zG4856oxqpBSfDvRMbQDj
         d6YE+VRTxybzzUiiVaDavG6L263fQJxSgDpymFr9AdVDZdPzBhqY18G7T5MtUxVf4n8n
         ObxuUFKf0kK/0FQki1M8PYWLtA3x55wE+f1+8EqVErr/3Edt2aTNqeoYAtdffwgvvZzQ
         DdYeS/sMNmmFgdi+iWsuO0Ny1daPsfjQ5OTabfQSCVsI8YiSTWJBC277nrTYnChiyJaY
         d1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fx5b1qQwMlFVs21l/OX+krSp/uyB0q/jyfgtOYhq7dE=;
        b=BmCP9T4xTMHyBChNvxCj8Bhbm1LPNoS572ozdwsJiEi/gT8Yo5BMM7WAWdoP2izlCj
         lK+VATR6e3avX0DxWGHg046XOCWsjh2kvVbXPXcYJgH4wWt9XBTr08ss9HVcKJ6qeOIc
         WcWIwMEGuhAqY+t3rbN6ox1tBzrHBc0RYRqHwq/WchgR2CB+BuRnFRIU2nXlGzaTfCRQ
         eaQ9r6E0TeKngNwTOcXiG8Uer45jAX2MvPHZZDWhunrFT8FtM0qRw5ez1e5E8DX18YRC
         YI+uducs5Vy1ZaxP0txO3ONKedtN68/EosN/VSWJASDpJ0zbviPsivPrutKesAL1wOkV
         xyTA==
X-Gm-Message-State: AOAM5334vGmP2krc/owcikhwgT3AslfQgCH1noxZEv8x+l969blBKKCm
        s2b8a6yx0kpNmtbgJNE2m5Jcgg==
X-Google-Smtp-Source: ABdhPJyVWs179jhP3AmLib7RzOT6sQbU88hEXWZ2jFNwsTrIFheQfrVrkfxWLnT5HErIbA2UNXcT0Q==
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr4334931pln.18.1644444811938;
        Wed, 09 Feb 2022 14:13:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h25sm19265617pfn.208.2022.02.09.14.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:13:31 -0800 (PST)
Date:   Wed, 9 Feb 2022 22:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] x86/emulator: Add some tests for
 ljmp instruction emulation
Message-ID: <YgQ8hx8PZFkI+U5J@google.com>
References: <cover.1644311445.git.houwenlong.hwl@antgroup.com>
 <4d8a505095cc6106371462db2513fbbe000d8b4d.1644311445.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8a505095cc6106371462db2513fbbe000d8b4d.1644311445.git.houwenlong.hwl@antgroup.com>
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

On Tue, Feb 08, 2022, Hou Wenlong wrote:
> Per Intel's SDM on the "Instruction Set Reference", when
> loading segment descriptor for ljmp, not-present segment
> check should be after all type and privilege checks. However,
> __load_segment_descriptor() in x86's emulator does not-present
> segment check first, so it would trigger #NP instead of #GP
> if type or privilege checks fail and the segment is not present.
> 
> So add some tests for ljmp instruction, and it will test
> those tests in hardware and emulator. Enable
> kvm.force_emulation_prefix when try to test them in emulator.

Many of the same comments from patch 01 apply here.  A few more below.

> @@ -1007,6 +1034,27 @@ static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
>  	handle_exception(NP_VECTOR, 0);
>  }
>  
> +static void test_ljmp(uint64_t *mem)

test_far_jmp(), the existing code is wrong ;-)

> +{
> +	unsigned char *m = (unsigned char *)mem;
> +	volatile int res = 1;
> +
> +	*(unsigned long**)m = &&jmpf;
> +	asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
> +	asm volatile ("rex64 ljmp *%0"::"m"(*m));
> +	res = 0;
> +jmpf:
> +	report(res, "ljmp");

It'd be helfup to explain what this is doing (took me a while to decipher...), e.g.

	report(res, "far jmp, via emulated MMIO");

And as a delta patch...

---
 x86/emulator.c | 55 ++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 4e7c6d1..110d10d 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -66,16 +66,17 @@ static struct far_xfer_test far_ret_test = {
 };

 static struct far_xfer_test_case far_jmp_testcases[] = {
-	{0, DS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.type!=code && desc.p=0"},
-	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "jmp non-conforming && dpl!=cpl && desc.p=0"},
-	{3, NON_CONFORM_CS_TYPE, 0, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && rpl>cpl && desc.p=0"},
-	{0, CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, FIRST_SPARE_SEL, "ljmp conforming && dpl>cpl && desc.p=0"},
-	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, FIRST_SPARE_SEL, "ljmp desc.p=0"},
-	{3, CONFORM_CS_TYPE, 0, 1, true, -1, -1, "ljmp dpl<cpl"},
+	{0, DS_TYPE,		 0, 0, false, GP_VECTOR, "desc.type!=code && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 3, 0, false, GP_VECTOR, "non-conforming && dpl!=cpl && desc.p=0"},
+	{3, NON_CONFORM_CS_TYPE, 0, 0, false, GP_VECTOR, "conforming && rpl>cpl && desc.p=0"},
+	{0, CONFORM_CS_TYPE,	 3, 0, false, GP_VECTOR, "conforming && dpl>cpl && desc.p=0"},
+	{0, NON_CONFORM_CS_TYPE, 0, 0, false, NP_VECTOR, "desc.p=0"},
+	{3, CONFORM_CS_TYPE,	 0, 1, true, -1,	 "dpl<cpl"},
 };

 static struct far_xfer_test far_jmp_test = {
 	.insn = FAR_XFER_JMP,
+	.insn_name = "far jmp",
 	.testcases = &far_jmp_testcases[0],
 	.nr_testcases = sizeof(far_jmp_testcases) / sizeof(struct far_xfer_test_case),
 };
@@ -95,23 +96,16 @@ static unsigned long *fep_jmp_buf_ptr = &fep_jmp_buf[0];
 		     : "eax", "memory");	\
 })

-#define TEST_FAR_JMP_ASM(seg, prefix)		\
-	*(uint16_t *)(&fep_jmp_buf[1]) = seg;	\
-	asm volatile("lea 1f(%%rip), %%rax\n\t" \
-		     "movq $1f, (%[mem])\n\t"	\
-		      prefix "rex64 ljmp *(%[mem])\n\t"\
-		     "1:"			\
-		     : : [mem]"r"(fep_jmp_buf_ptr)\
-		     : "eax", "memory");
-
-static inline void test_far_jmp_asm(uint16_t seg, bool force_emulation)
-{
-	if (force_emulation) {
-		TEST_FAR_JMP_ASM(seg, KVM_FEP);
-	} else {
-		TEST_FAR_JMP_ASM(seg, "");
-	}
-}
+#define TEST_FAR_JMP_ASM(seg, prefix)			\
+({							\
+	*(uint16_t *)(&fep_jmp_buf[1]) = seg;		\
+	asm volatile("lea 1f(%%rip), %%rax\n\t"		\
+		     "movq $1f, (%[mem])\n\t"		\
+		      prefix "rex64 ljmp *(%[mem])\n\t"	\
+		     "1:"				\
+		     : : [mem]"r"(fep_jmp_buf_ptr)	\
+		     : "eax", "memory");		\
+})

 struct regs {
 	u64 rax, rbx, rcx, rdx;
@@ -991,7 +985,10 @@ static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
 			TEST_FAR_RET_ASM(seg, "");
 		break;
 	case FAR_XFER_JMP:
-		test_far_jmp_asm(seg, force_emulation);
+		if (force_emulation)
+			TEST_FAR_JMP_ASM(seg, KVM_FEP);
+		else
+			TEST_FAR_JMP_ASM(seg, "");
 		break;
 	default:
 		report_fail("Unexpected insn enum = %d\n", insn);
@@ -1039,7 +1036,7 @@ static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
 	handle_exception(NP_VECTOR, 0);
 }

-static void test_ljmp(uint64_t *mem)
+static void test_far_jmp(uint64_t *mem)
 {
 	unsigned char *m = (unsigned char *)mem;
 	volatile int res = 1;
@@ -1049,12 +1046,12 @@ static void test_ljmp(uint64_t *mem)
 	asm volatile ("rex64 ljmp *%0"::"m"(*m));
 	res = 0;
 jmpf:
-	report(res, "far jmp, self-modifying code");
+	report(res, "far jmp, via emulated MMIO");

 	test_far_xfer(false, &far_jmp_test);
 }

-static void test_em_ljmp(uint64_t *mem)
+static void test_em_far_jmp(uint64_t *mem)
 {
 	test_far_xfer(true, &far_jmp_test);
 }
@@ -1341,7 +1338,7 @@ int main(void)

 	test_smsw(mem);
 	test_lmsw();
-	test_ljmp(mem);
+	test_far_jmp(mem);
 	test_far_ret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
@@ -1367,7 +1364,7 @@ int main(void)
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
-		test_em_ljmp(mem);
+		test_em_far_jmp(mem);
 		test_em_far_ret(mem);
 	} else {
 		report_skip("skipping register-only tests, "

base-commit: 57a0e341f906f09df1ce45ef7bf080e9737eeff2
--
