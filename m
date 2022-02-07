Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF04ACAD1
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiBGVBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiBGVAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:00:52 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C117C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:00:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id s14so147609pfw.3
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LdZpI+kJPy2X1ZYyqgEb1wIki5Qnd92pO9Fsm7IrFs0=;
        b=WgUnwHessgA2kbtpTeHG/JQ2+tj9ku65bi7aZAkN1/PWHbIalzPbKKTflOa45Vk6IB
         as3DEBX9/60u/zYqzwv1eHtcJ/jPkV/Xsf0jHY5kMVMHs03qiNhgCOhZZjAvDck0P5xm
         BkyyE3tl3hwUc1o/kSHMEaYULk56LhkfzV8DSkoyfgwCF0Wm9eK/D2ez4w3/LJH6bbOE
         OzSnlV50TPdfCjXt6pUZGYvgFbO7ZBl9a5dhCYyZwa30Jz01y9UqMZaeg+CQv0JgNcir
         0uHsurdzW0RbAK+SV3BVDO4QUkma/ElXu87rxjLSF/ZA9QahM0i0rQ6U5n8SrvG/QO+G
         INWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LdZpI+kJPy2X1ZYyqgEb1wIki5Qnd92pO9Fsm7IrFs0=;
        b=0Lwz3ypyQfmWyKbtOGmGbj0M1vVRd/49ufuLhO5PFLyrFb6dHyS3lzbvJC9xYce8x3
         CZt2BmXtWnX2v8yzTgPLyPMRQRc37HxngfgB98YhrWi5OPQICwhgs6mcG3OUlpU9UAvB
         /gplLuD3LhrkvdLsWM2tsYSpHABoH9BOEUTMyBAZl6FEzoZNk32DhKLGq5L+ALzsReWt
         NEAJ/4n1Zn6epjh48yElMdwQ43nEGssx4a5a6v1FxAUWdtPWd00EoMqg/POsmbT5brHR
         VUWhHgmCyqdcx4V4udfykg5WTzpefEuQNOMQgiIG+RQsoBJQ/MM78AuCMpvrw9UNq/JS
         mHIw==
X-Gm-Message-State: AOAM533NGHEGaYi/rvI3G/Vzn0IoLMr9uqq/FYhnm0NsD6o4TQ6mBKQj
        VulXou13TiMI+/avhhW+Xg/gMQ==
X-Google-Smtp-Source: ABdhPJykfFRlVsG61CqaoDUatpkpzzZgQuAjW7Y0kvzB8ekqzpKaF971Aps4sC9kQ1UAsTwFkh6+IQ==
X-Received: by 2002:aa7:84d5:: with SMTP id x21mr1197632pfn.72.1644267650268;
        Mon, 07 Feb 2022 13:00:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 38sm9226129pgl.82.2022.02.07.13.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:00:49 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:00:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/emulator: Add some tests for lret
 instruction emulation
Message-ID: <YgGIfoX907fi5Woi@google.com>
References: <cover.1642669912.git.houwenlong.hwl@antgroup.com>
 <70e1054ea95f1935d5fbee417bbc6e88696287c3.1642669912.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70e1054ea95f1935d5fbee417bbc6e88696287c3.1642669912.git.houwenlong.hwl@antgroup.com>
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

On Thu, Jan 20, 2022, Hou Wenlong wrote:
> Per Intel's SDM on the "Instruction Set Reference", when
> loading segment descriptor for far return, not-present segment
> check should be after all type and privilege checks. However,
> __load_segment_descriptor() in x86's emulator does not-present
> segment check first, so it would trigger #NP instead of #GP
> if type or privilege checks fail and the segment is not present.
> 
> And if RPL < CPL, it should trigger #GP, but the check is missing
> in emulator.
> 
> So add some tests for lret instruction, and it will test
> those tests in hardware and emulator. Enable
> kvm.force_emulation_prefix when try to test them in emulator.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  x86/emulator.c | 181 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 181 insertions(+)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index c5f584a9d8cc..480333a40eba 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -19,6 +19,88 @@ static int exceptions;
>  #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
>  #define KVM_FEP_LENGTH 5
>  static int fep_available = 1;
> +static unsigned int fep_vector = -1;
> +static unsigned int fep_error_code = -1;

I'd prefer we keep "Forced Emulation Prefix" out of the enums, macros, etc...
It's an implementation detail that has no impact on the functionality being tested.
Even more confusing is that e.g. test_lret() doesn't utilize the force prefix,
which makes all the "fep" nomenclature wrong.

Maybe far_xfer_* for the prefix?

> +struct fep_test_case {
> +	uint16_t rpl;
> +	uint16_t type;

Maybe s/type/insn?  "type" might be misconstrued as the type of segment, e.g. a
call gate, as opposed to the instruction.

> +	uint16_t dpl;
> +	uint16_t p;
> +	unsigned int vector;
> +	unsigned int error_code;
> +	const char *msg;
> +};
> +
> +enum fep_test_inst_type {

"insn" is generally preferred over "inst".

> +	FEP_TEST_LRET,

I strongly prefer FAR_RET over LRET to better match the SDM.  Ditto for FAR_JMP or LJMP.

> +};
> +
> +struct fep_test {
> +	enum fep_test_inst_type type;
> +	unsigned long rip_advance;
> +	struct fep_test_case *kernel_testcases;
> +	unsigned int kernel_testcases_count;
> +	struct fep_test_case *user_testcases;
> +	unsigned int user_testcases_count;

Add a flag to struct far_jmp_test_case to track user vs. kernel.  More below.

> +};
> +
> +#define NON_CONFORM_CS_TYPE	0xb
> +#define CONFORM_CS_TYPE		0xf
> +#define DS_TYPE			0x3
> +
> +static struct fep_test_case lret_kernel_testcases[] = {
> +	{0, DS_TYPE, 0, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret desc.type!=code && desc.p=0"},
> +	{0, NON_CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret non-conforming && dpl!=rpl && desc.p=0"},
> +	{0, CONFORM_CS_TYPE, 3, 0, GP_VECTOR, FIRST_SPARE_SEL, "lret conforming && dpl>rpl && desc.p=0"},
> +	{0, NON_CONFORM_CS_TYPE, 0, 0, NP_VECTOR, FIRST_SPARE_SEL, "lret desc.p=0"},
> +};
> +
> +static struct fep_test_case lret_user_testcases[] = {
> +	{0, NON_CONFORM_CS_TYPE, 3, 1, GP_VECTOR, FIRST_SPARE_SEL, "lret rpl<cpl"},
> +};
> +
> +static struct fep_test fep_test_lret = {
> +	.type = FEP_TEST_LRET,
> +	.kernel_testcases = lret_kernel_testcases,
> +	.kernel_testcases_count = sizeof(lret_kernel_testcases) / sizeof(struct fep_test_case),
> +	.user_testcases = lret_user_testcases,
> +	.user_testcases_count = sizeof(lret_user_testcases) / sizeof(struct fep_test_case),
> +};
> +
> +static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type type);
> +
> +#define TEST_LRET_ASM(seg, prefix)		\
> +	asm volatile("pushq %[asm_seg]\n\t"	\
> +		     "pushq $1f\n\t"		\
> +		      prefix "lretq\n\t"	\
> +		     "addq $16, %%rsp\n\t"	\
> +		     "1:"			\
> +		     : : [asm_seg]"r"(seg)	\
> +		     : "memory");
> +
> +#define TEST_FEP_RESULT(vector, error_code, msg)	\
> +	report(fep_vector == vector &&			\
> +	       fep_error_code == error_code,msg);	\
> +	fep_vector = -1;				\
> +	fep_error_code = -1;

These should really be set _before_ running a test, not after.

> +#define TEST_FEP_INST(emulate, inst, seg, vector, error_code, msg) \
> +	do {							   \
> +		if (emulate) {					   \
> +			TEST_##inst##_ASM(seg, KVM_FEP);	   \
> +		} else {					   \
> +			TEST_##inst##_ASM(seg, "");		   \
> +		}						   \
> +		TEST_FEP_RESULT(vector, error_code, msg);	   \
> +	} while (0)
> +
> +#define TEST_FEP_INST_IN_USER(inst, emulate, rpl, dummy, vector, error_code, msg)\
> +	do {								\
> +		run_in_user((usermode_func)test_in_user, UD_VECTOR,	\
> +			     emulate, rpl, FEP_TEST_##inst, 0, dummy);	\
> +		TEST_FEP_RESULT(vector, error_code, msg);		\
> +	} while (0)

I love macro frameworks, but this is gratutious and makes the code hard to follow.
Low level macros to emit the assembly is necessary to deal with the prefix, but
everything else can be handled by refactoring the test loop.

> +static void test_in_user(bool emulate, uint16_t rpl, enum fep_test_inst_type type)

Here and elsewhere, s/emulate/force_emulation to clarity who/what is doing the
emulation.

> +{
> +	uint16_t seg = FIRST_SPARE_SEL | rpl;
> +
> +	switch (type) {
> +	case FEP_TEST_LRET:
> +		if (emulate) {
> +			TEST_LRET_ASM(seg, KVM_FEP);
> +		} else {
> +			TEST_LRET_ASM(seg, "");
> +		}

		TEST_FAR_RET_ASM(seg, emulate ? KVM_FEP : "");


Actually, assuming there are no string concatenation tricks we can play, even
better would be to make the current TEST_LRET_ASM __TEST_FAR_RET_ASM, and then
have TEST_FAR_RET_ASM() be:

#define TEST_FAR_RET_ASM(seg, force_emulation)	\
	__TEST_FAR_RET_ASM(seg, (force_emulation) ? KVM_FEP : "" )


> +		break;

This would ideally have a "default" path to fire on unknown instructions.

> +	}
> +}
> +
> +static void test_fep_common(bool emulate, struct fep_test *test)
> +{
> +	int i;
> +	bool dummy;
> +	struct fep_test_case *t;
> +	uint16_t seg = FIRST_SPARE_SEL;
> +
> +	handle_exception(GP_VECTOR, fep_exception_handler);
> +	handle_exception(NP_VECTOR, fep_exception_handler);
> +	rip_advance = test->rip_advance;
> +
> +	gdt[seg / 8] = gdt[KERNEL_CS / 8];
> +	t = test->kernel_testcases;
> +	for (i = 0; i < test->kernel_testcases_count; i++) {
> +		seg = FIRST_SPARE_SEL | t[i].rpl;
> +		gdt[seg / 8].type = t[i].type;
> +		gdt[seg / 8].dpl = t[i].dpl;
> +		gdt[seg / 8].p = t[i].p;
> +
> +		switch (test->type) {
> +		case FEP_TEST_LRET:
> +			TEST_FEP_INST(emulate, LRET, seg, t[i].vector,
> +				      t[i].error_code, t[i].msg);
> +			break;
> +		}
> +	}
> +
> +	gdt[seg / 8] = gdt[USER_CS64 / 8];
> +	t = test->user_testcases;
> +	for (i = 0; i < test->user_testcases_count; i++) {
> +		gdt[seg / 8].type = t[i].type;
> +		gdt[seg / 8].dpl = t[i].dpl;
> +		gdt[seg / 8].p = t[i].p;
> +
> +		switch (test->type) {
> +		case FEP_TEST_LRET:
> +			TEST_FEP_INST_IN_USER(LRET, emulate, t[i].rpl,
> +					      &dummy, t[i].vector,
> +				              t[i].error_code, t[i].msg);
> +			break;
> +		}
> +	}
> +
> +	handle_exception(GP_VECTOR, 0);
> +	handle_exception(NP_VECTOR, 0);
> +}

To avoid a bunch of macros, this can be refactored to (completely untested):

static void __test_far_xfer(enum far_xfer_insn insn, uint16_t seg,
			    bool force_emulation)
{
	switch (insn) {
	case FAR_XFER_RET:
		TEST_FAR_RET_ASM(seg, force_emulation);
		break;
	case FAR_XFER_JMP:
		TEST_FAR_JMP_ASM(seg, force_emulation);
		break;
	default:
		report_fail(...);
		break;
	}
}

static void test_far_xfer(bool force_emulation, struct far_xfer_test *test)
{
	struct far_xfer_test_case *t;
	uint16_t seg;
	bool ign;
	int i;

	handle_exception(GP_VECTOR, far_xfer_exception_handler);
	handle_exception(NP_VECTOR, far_xfer_exception_handler);

	for (i = 0; i < test->nr_testcases; i++) {
		t = test->testases[i];

		seg = FIRST_SPARE_SEL | t->rpl;
		gdt[seg / 8] = gdt[(t->usermode ? USER_CS64 : KERNEL_CS) / 8];
		gdt[seg / 8].type = t->type;
		gdt[seg / 8].dpl = t->dpl;
		gdt[seg / 8].p = t->p;

		far_xfer_vector = -1;
		far_error_code = -1;

		if (t->usermode)
			run_in_user((usermode_func)__test_far_xfer, UD_VECTOR,
				    t->insn, seg, force_emulation, 0, &ign);
		else
			__test_far_xfer(t->insn, seg, force_emulation);

		report(far_xfer_vector == vector &&
		       far_xfer_error_code == error_code, t->msg);
	}

	handle_exception(GP_VECTOR, 0);
	handle_exception(NP_VECTOR, 0);
}

> +
> +static unsigned long get_lret_rip_advance(void)
> +{
> +	extern char lret_start, lret_end;
> +	unsigned long lret_rip_advance = &lret_end - &lret_start;
> +
> +	asm volatile("data16 mov %%cs, %%rax\n\t"
> +		     "pushq %%rax\n\t"
> +		     "pushq $1f\n\t"
> +		     "lret_start: lretq; lret_end:\n\t"
> +		     "1:\n\t"
> +		     : : : "ax", "memory");

Hrm, this is probably fine in practice, but I don't love assuming that the compiler
will emit identical instructions.  I think we can instead use a hardcoded GPR to
store the target, e.g.

static void far_xfer_exception_handler(struct ex_regs *regs)
{
	far_xfer_vector = regs->vector;
	far_xfer_error_code = regs->error_code;
	regs->rip = regs->rax;
}

and then in the asm

#define __TEST_FAR_RET_ASM(seg, prefix)		\
	asm volatile("lea 1f(%%rip), %%rax\n\t"	\
		     "pushq %[asm_seg]\n\t"	\
		     "pushq $1f\n\t"		\
		      prefix "lretq\n\t"	\
		     "addq $16, %%rsp\n\t"	\
		     "1:"			\
		     : : [asm_seg]"r"(seg)	\
		     : "eax", "memory");

> +
> +	return lret_rip_advance;
> +}
> +
> +static void test_lret(uint64_t *mem)
> +{
> +	printf("test lret in hw\n");
> +	fep_test_lret.rip_advance = get_lret_rip_advance();
> +	test_fep_common(false, &fep_test_lret);
> +}
> +
> +static void test_em_lret(uint64_t *mem)
> +{
> +	printf("test lret in emulator\n");

This will fail if run in isolation, no?  I.e. fep_test_lret.rip_advance won't be
set.  Test should really be standalone, though KUT does a poor job on that front :-(

Moot point if we can find a way to avoid using a global for the post-fault RIP.

> +	test_fep_common(true, &fep_test_lret);
> +}
> +
>  static void test_push16(uint64_t *mem)
>  {
>  	uint64_t rsp1, rsp2;
> @@ -1164,6 +1343,7 @@ int main(void)
>  	test_smsw(mem);
>  	test_lmsw();
>  	test_ljmp(mem);
> +	test_lret(mem);
>  	test_stringio();
>  	test_incdecnotneg(mem);
>  	test_btc(mem);
> @@ -1188,6 +1368,7 @@ int main(void)
>  		test_smsw_reg(mem);
>  		test_nop(mem);
>  		test_mov_dr(mem);
> +		test_em_lret(mem);
>  	} else {
>  		report_skip("skipping register-only tests, "
>  			    "use kvm.force_emulation_prefix=1 to enable");
> -- 
> 2.31.1
> 
