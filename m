Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303EC76442E
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 05:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjG0DMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 23:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjG0DMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 23:12:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075BA26B8
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 20:11:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1b8ad907ba4so3196555ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 20:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690427518; x=1691032318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CN7mtwMLwzGNRkYoXnqLDtVOrDjX5Jstg5X9irO09x8=;
        b=Goby0hzVRsGWxLHhWzRZQr5o3/290OtueP7i/VzkV+0ZxcrwaiX6p3l3jtu2aJ/Ne6
         3EUViOjISEjWP+eufey/2+A5T+p58rKT2mwOUsWP9AK7yVhLiZ7ZjljGnHjsvsByM8Ew
         6HETBuqrZyjUGAFhOfQVifAl+hveaP5hS+rqy+OSucQwcREM2hikfiDtYfXan0z9ZI+4
         No3zHYiouv7BL4cjJ25Xh8BbPyidqiCxJnneJ3sHvSo+Y7duOfALn5C35uONZl9GTX2H
         kHJF5DHKxhG3scKYj47VoJu2TyA89HrH9ogeTFNhOoRMR7Yqv2ufVRhKS1+bO6KFphNU
         l3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690427518; x=1691032318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CN7mtwMLwzGNRkYoXnqLDtVOrDjX5Jstg5X9irO09x8=;
        b=llhDD2ZB9EkJkj79WVh6wJYjHi4TOHHHPDU0IUJrs77LDrXd580vk0B7vZc6ZZfIRp
         8+jILZOpMSMFqt0NBFbsA9kq1iOH3pYAFisLG8/8aZbIW36km7Ca6KNzIN32fiWmh7R8
         Lka5L9CPJhKDJS/kIiPj1JyA4ZYZcl5xwBck5SUQiUQYBfmJWFLG09f6rut+u2WVJBPV
         MHv1p33Wl7TI8Rn4JZClaSIwQbJBJROg9AqLGZY5deLANpqnL3nGZlj3qLgp+3VGDiZC
         bwoNptyl7blE0cvcL7+Zrb/vpN9mV4trg0ByRAI7Abo3kBBNJivtdTJJ0toZBb4FS++E
         hK+A==
X-Gm-Message-State: ABy/qLbu5vrmqIV9FM1eHPxYr8ZclrnOP8Ffj+ipiE3bqh95w+nX3Eqo
        j6Hajmz6kyNaN7azlOoYNP9pqo4iONIQ4mwp1IU=
X-Google-Smtp-Source: APBJJlEwo1elr2ruvbBNcfZ7ZRQ9WLx6MTx93f6D2a/uM04fPB0vZcFR1SYUG0hmDH5XIWmsA0waMA==
X-Received: by 2002:a17:902:bf02:b0:1b6:72af:623d with SMTP id bi2-20020a170902bf0200b001b672af623dmr3087402plb.55.1690427518271;
        Wed, 26 Jul 2023 20:11:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id kb14-20020a170903338e00b001bba1188c8esm280501plb.271.2023.07.26.20.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 20:11:57 -0700 (PDT)
Message-ID: <14c0e28b-1a90-5d61-6758-7a25bd317405@gmail.com>
Date:   Thu, 27 Jul 2023 11:11:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
To:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20230607224520.4164598-1-aaronlewis@google.com>
 <ZMGhJAMqtFa6sTkl@google.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <ZMGhJAMqtFa6sTkl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/7/27 06:41, Sean Christopherson 写道:
> On Wed, Jun 07, 2023, Aaron Lewis wrote:
>> Extend the ucall framework to offer GUEST_PRINTF() and GUEST_ASSERT_FMT()
>> in selftests.  This will allow for better and easier guest debugging.
> 
> This. Is.  Awesome.  Seriously, this is amazing!
> 
> I have one or two nits, but theyre so minor I already forgot what they were.
> 
> The one thing I think we should change is the final output of the assert.  Rather
> than report the host TEST_FAIL as the assert:
> 
>    # ./svm_nested_soft_inject_test
>    Running soft int test
>    ==== Test Assertion Failure ====
>      x86_64/svm_nested_soft_inject_test.c:191: false
>      pid=169827 tid=169827 errno=4 - Interrupted system call
>         1	0x0000000000401b52: run_test at svm_nested_soft_inject_test.c:191
>         2	0x00000000004017d2: main at svm_nested_soft_inject_test.c:212
>         3	0x00000000004159d3: __libc_start_call_main at libc-start.o:?
>         4	0x000000000041701f: __libc_start_main_impl at ??:?
>         5	0x0000000000401660: _start at ??:?
>      Failed guest assert: regs->rip != (unsigned long)l2_guest_code_int at x86_64/svm_nested_soft_inject_test.c:39
>      Expected IRQ at RIP 0x401e80, received IRQ at 0x401e80
> 
> show the guest assert as the primary assert.
> 
>    Running soft int test
>    ==== Test Assertion Failure ====
>      x86_64/svm_nested_soft_inject_test.c:39: regs->rip != (unsigned long)l2_guest_code_int
>      pid=214104 tid=214104 errno=4 - Interrupted system call
>         1	0x0000000000401b35: run_test at svm_nested_soft_inject_test.c:191
>         2	0x00000000004017d2: main at svm_nested_soft_inject_test.c:212
>         3	0x0000000000415b03: __libc_start_call_main at libc-start.o:?
>         4	0x000000000041714f: __libc_start_main_impl at ??:?
>         5	0x0000000000401660: _start at ??:?
>      Expected IRQ at RIP 0x401e50, received IRQ at 0x401e50
> 
> That way users don't have to manually find the "real" assert.  Ditto for any kind
> of automated reporting.  The site of the test_fail() invocation in the host is
> still captured in the stack trace (though that too could be something to fix over
> time), so unless I'm missing something, there's no information lost.
> 
> The easiest thing I can think of is to add a second buffer to hold the exp+file+line.
> Then, test_assert() just needs to skip that particular line of formatting.
> 
> If you don't object, I'll post a v4 with the below folded in somewhere (after
> more testing), and put this on the fast track for 6.6.
> 
> Side topic, if anyone lurking out there wants an easy (but tedious and boring)
> starter project, we should convert all tests to the newfangled formatting and
> drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_ASSERT_FMT()
> and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.

I'd be happy to get the job done.

However, before I proceed, could you please provide a more detailed 
example or further guidance on the desired formatting and the specific 
changes you would like to see?

Thanks

Jinrong Liang

> 
> ---
>   .../selftests/kvm/include/ucall_common.h      | 19 ++++++++---------
>   tools/testing/selftests/kvm/lib/assert.c      | 13 +++++++-----
>   .../testing/selftests/kvm/lib/ucall_common.c  | 21 +++++++++++++++++++
>   3 files changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index b4f4c88e8d84..3bc4e62bec1b 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -25,6 +25,7 @@ struct ucall {
>   	uint64_t cmd;
>   	uint64_t args[UCALL_MAX_ARGS];
>   	char buffer[UCALL_BUFFER_LEN];
> +	char aux_buffer[UCALL_BUFFER_LEN];
>   
>   	/* Host virtual address of this struct. */
>   	struct ucall *hva;
> @@ -36,6 +37,8 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>   
>   void ucall(uint64_t cmd, int nargs, ...);
>   void ucall_fmt(uint64_t cmd, const char *fmt, ...);
> +void ucall_assert(uint64_t cmd, const char *exp, const char *file,
> +		  unsigned int line, const char *fmt, ...);
>   uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>   void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
>   int ucall_nr_pages_required(uint64_t page_size);
> @@ -63,15 +66,10 @@ enum guest_assert_builtin_args {
>   	GUEST_ASSERT_BUILTIN_NARGS
>   };
>   
> -#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)			\
> -do {										\
> -	char fmt[UCALL_BUFFER_LEN];						\
> -										\
> -	if (!(_condition)) {							\
> -		guest_snprintf(fmt, sizeof(fmt), "%s\n  %s",			\
> -			     "Failed guest assert: " _str " at %s:%ld", _fmt);	\
> -		ucall_fmt(UCALL_ABORT, fmt, __FILE__, __LINE__, ##_args);	\
> -	}									\
> +#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)				\
> +do {											\
> +	if (!(_condition)) 								\
> +		ucall_assert(UCALL_ABORT, _str, __FILE__, __LINE__, _fmt, ##_args);	\
>   } while (0)
>   
>   #define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
> @@ -102,7 +100,8 @@ do {									\
>   
>   #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>   
> -#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
> +#define REPORT_GUEST_ASSERT_FMT(ucall)					\
> +	test_assert(false, (ucall).aux_buffer, NULL, 0, "%s", (ucall).buffer);
>   
>   #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
>   	TEST_FAIL("%s at %s:%ld\n" fmt,					\
> diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
> index 2bd25b191d15..74d94a34cf1a 100644
> --- a/tools/testing/selftests/kvm/lib/assert.c
> +++ b/tools/testing/selftests/kvm/lib/assert.c
> @@ -75,11 +75,14 @@ test_assert(bool exp, const char *exp_str,
>   	if (!(exp)) {
>   		va_start(ap, fmt);
>   
> -		fprintf(stderr, "==== Test Assertion Failure ====\n"
> -			"  %s:%u: %s\n"
> -			"  pid=%d tid=%d errno=%d - %s\n",
> -			file, line, exp_str, getpid(), _gettid(),
> -			errno, strerror(errno));
> +		fprintf(stderr, "==== Test Assertion Failure ====\n");
> +		/* If @file is NULL, @exp_str contains a preformatted string. */
> +		if (file)
> +			fprintf(stderr, "  %s:%u: %s\n", file, line, exp_str);
> +		else
> +			fprintf(stderr, "  %s\n", exp_str);
> +		fprintf(stderr, "  pid=%d tid=%d errno=%d - %s\n",
> +			getpid(), _gettid(), errno, strerror(errno));
>   		test_dump_stack();
>   		if (fmt) {
>   			fputs("  ", stderr);
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index b507db91139b..e7741aadf2ce 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -75,6 +75,27 @@ static void ucall_free(struct ucall *uc)
>   	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
>   }
>   
> +void ucall_assert(uint64_t cmd, const char *exp, const char *file,
> +		  unsigned int line, const char *fmt, ...)
> +{
> +	struct ucall *uc;
> +	va_list va;
> +
> +	uc = ucall_alloc();
> +	uc->cmd = cmd;
> +
> +	guest_snprintf(uc->aux_buffer, sizeof(uc->aux_buffer),
> +		       "%s:%u: %s", file, line, exp);
> +
> +	va_start(va, fmt);
> +	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
> +	va_end(va);
> +
> +	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> +
> +	ucall_free(uc);
> +}
> +
>   void ucall_fmt(uint64_t cmd, const char *fmt, ...)
>   {
>   	struct ucall *uc;
> 
> base-commit: 8dc29dfc010293957c5ca24271748a3c8f047a76
