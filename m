Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5366D9198
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbjDFIbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjDFIbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:31:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979D818E
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:31:18 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t10so147290341edd.12
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680769877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bTitVUSzXB6ufjRcEveYNa8booBFdwIcqlx3BS+PZwQ=;
        b=ACsXj3MPvuDeFxtHIZBjkPFCB7Y1SQH8OvnjbwwawJvZYNwff6CBi2EMk049vR8pw9
         2lUAsNUjKeFjyflK95ecRvf0aDx+U6CTVYbEZtXnIqo1xXIlCHSlNKQzgHNEr0RtrkTu
         2pT6HIf2lSrqx+6y4UneDK1FA0t/Gp64S2OJ97GMCPFSEmO07nN6H+38G63kfh2/NPFt
         vMAUxyU/EPxsYQjUStyzRileEkewEqztbUy+yhtOOUNUAvTsKhC2Yyf/tzUDAxjo0slB
         kgM6YU8Gin7syfO5psrKVBHesVlFtgKkrESrasrUMhj9bv9+ElOQZlUhvoLaEsGs9zen
         RxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTitVUSzXB6ufjRcEveYNa8booBFdwIcqlx3BS+PZwQ=;
        b=KoXrlOm9PaBqOcif8ROGGdGw/NTzB7FRriFTz7fO4znDxKd9ecT2I66aczaVXgwEfS
         74LcwvbYLUFoRuFcHAuF8V3aNR5se3sREEWilkr/5jj+Ka0oQI2o1sn/+qsSQ6eptdBF
         PJ8tUSAQKQVQhpzMkXGGLKi4ZCBbehUA6I8KOeaEcWewahJOQjiWXuXasrCI5K7d+Wjv
         jIexsoy1XWhF/q89nWiiDcEb9z98lzrI0iEZHTNvYEzyOAcS2Oc8fHwMOdN0p9S4nblC
         qu5Vw6ROg0So/1u45vhjNZEJGdpA1lFl6pVYhfQGHSJVOUOoXGnwM4D6axcGA6o1bOQh
         +NhA==
X-Gm-Message-State: AAQBX9d97uney0FKy2CJr0sV7rBf3GMMtFZ8t7gskAO6vZfO/oFmFkKF
        eFkdysgp4AvC6vvL8abPsC6ksP+aL97YLo3mX3U=
X-Google-Smtp-Source: AKy350bZLfLcXlVfUNxL+uvn4dRYMN4kztS0hzjw5y/gAZu2R6S5oqt3VRrbgAl88X/HAHSb7RD/Kw==
X-Received: by 2002:a17:906:d791:b0:92e:d6e6:f3ad with SMTP id pj17-20020a170906d79100b0092ed6e6f3admr5895368ejb.6.1680769877064;
        Thu, 06 Apr 2023 01:31:17 -0700 (PDT)
Received: from ?IPV6:2003:f6:af05:3700:e3dd:8565:18f3:3982? (p200300f6af053700e3dd856518f33982.dip0.t-ipconnect.de. [2003:f6:af05:3700:e3dd:8565:18f3:3982])
        by smtp.gmail.com with ESMTPSA id s7-20020a170906a18700b00929fc8d264dsm514708ejy.17.2023.04.06.01.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 01:31:16 -0700 (PDT)
Message-ID: <a2ff46e7-748a-0cd2-d973-8ce1cdbfa004@grsecurity.net>
Date:   Thu, 6 Apr 2023 10:31:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v4 1/2] nSVM: Add helper to report fatal
 errors in guest
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230405205138.525310-1-seanjc@google.com>
 <20230405205138.525310-2-seanjc@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230405205138.525310-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.04.23 22:51, Sean Christopherson wrote:
> Add a helper macro to dedup nSVM test code that handles fatal errors
> by reporting the failure, setting the test stage to a magic number, and
> invoking VMMCALL to bail to the host and terminate.
> 
> Note, the V_TPR fails if report() is invoked.  Punt on the issue for
> now as most users already report only failures, but leave a TODO for
> future developers.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/svm_tests.c | 127 ++++++++++++++++--------------------------------
>  1 file changed, 42 insertions(+), 85 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 27ce47b4..e87db3fa 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -947,6 +947,21 @@ static bool lat_svm_insn_check(struct svm_test *test)
>  	return true;
>  }
>  
> +/*
> + * Report failures from SVM guest code, and on failure, set the stage to -1 and
> + * do VMMCALL to terminate the test (host side must treat -1 as "finished").
> + * TODO: fix the tests that don't play nice with a straight report, e.g. the
> + * V_TPR test fails if report() is invoked.
> + */
> +#define report_svm_guest(cond, test, fmt, args...)	\
> +do {							\
> +	if (!(cond)) {					\

> +		report_fail("why didn't my format '" fmt "' format?", ##args);\
                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Debug artifact? Should probably be this instead (making use of C99):

   #define report_svm_guest(cond, test, fmt,...)	\
   do {							\
    	if (!(cond)) {					\
   		report_fail((fmt), ##__VA_ARGS__);	\
   		set_test_stage((test), -1);		\
   		vmmcall();				\
   	}						\
   } while (0)

> +		set_test_stage(test, -1);		\
> +		vmmcall();				\
> +	}						\
> +} while (0)
> +
>  bool pending_event_ipi_fired;
>  bool pending_event_guest_run;
>  
> @@ -1049,22 +1064,16 @@ static void pending_event_cli_prepare_gif_clear(struct svm_test *test)
>  
>  static void pending_event_cli_test(struct svm_test *test)
>  {
> -	if (pending_event_ipi_fired == true) {
> -		set_test_stage(test, -1);
> -		report_fail("Interrupt preceeded guest");
> -		vmmcall();
> -	}
> +	report_svm_guest(!pending_event_ipi_fired, test,
> +			 "IRQ should NOT be delivered while IRQs disabled");
>  
>  	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
>  	irq_enable();
>  	asm volatile ("nop");
>  	irq_disable();
>  
> -	if (pending_event_ipi_fired != true) {
> -		set_test_stage(test, -1);
> -		report_fail("Interrupt not triggered by guest");
> -	}
> -
> +	report_svm_guest(pending_event_ipi_fired, test,
> +			 "IRQ should be delivered after enabling IRQs");
>  	vmmcall();
>  
>  	/*
> @@ -1079,11 +1088,9 @@ static void pending_event_cli_test(struct svm_test *test)
>  
>  static bool pending_event_cli_finished(struct svm_test *test)
>  {
> -	if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> -		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
> -			    vmcb->control.exit_code);
> -		return true;
> -	}
> +	report_svm_guest(vmcb->control.exit_code == SVM_EXIT_VMMCALL, test,
> +			 "Wanted VMMCALL VM-Exit, got ext reason 0x%x",
> +			 vmcb->control.exit_code);
>  
>  	switch (get_test_stage(test)) {
>  	case 0:
> @@ -1158,12 +1165,8 @@ static void interrupt_test(struct svm_test *test)
>  	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
>  		asm volatile ("nop");
>  
> -	report(timer_fired, "direct interrupt while running guest");
> -
> -	if (!timer_fired) {
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(timer_fired, test,
> +			 "direct interrupt while running guest");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1174,12 +1177,8 @@ static void interrupt_test(struct svm_test *test)
>  	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
>  		asm volatile ("nop");
>  
> -	report(timer_fired, "intercepted interrupt while running guest");
> -
> -	if (!timer_fired) {
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(timer_fired, test,
> +			 "intercepted interrupt while running guest");
>  
>  	irq_enable();
>  	apic_write(APIC_TMICT, 0);
> @@ -1190,13 +1189,8 @@ static void interrupt_test(struct svm_test *test)
>  	apic_write(APIC_TMICT, 1000000);
>  	safe_halt();
>  
> -	report(rdtsc() - start > 10000 && timer_fired,
> -	       "direct interrupt + hlt");
> -
> -	if (!timer_fired) {
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(timer_fired, test, "direct interrupt + hlt");
> +	report(rdtsc() - start > 10000, "IRQ arrived after expected delay");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1207,13 +1201,8 @@ static void interrupt_test(struct svm_test *test)
>  	apic_write(APIC_TMICT, 1000000);
>  	asm volatile ("hlt");
>  
> -	report(rdtsc() - start > 10000 && timer_fired,
> -	       "intercepted interrupt + hlt");
> -
> -	if (!timer_fired) {
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(timer_fired, test, "intercepted interrupt + hlt");
> +	report(rdtsc() - start > 10000, "IRQ arrived after expected delay");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1287,10 +1276,7 @@ static void nmi_test(struct svm_test *test)
>  {
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
>  
> -	report(nmi_fired, "direct NMI while running guest");
> -
> -	if (!nmi_fired)
> -		set_test_stage(test, -1);
> +	report_svm_guest(nmi_fired, test, "direct NMI while running guest");
>  
>  	vmmcall();
>  
> @@ -1298,11 +1284,7 @@ static void nmi_test(struct svm_test *test)
>  
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
>  
> -	if (!nmi_fired) {
> -		report(nmi_fired, "intercepted pending NMI not dispatched");
> -		set_test_stage(test, -1);
> -	}
> -
> +	report_svm_guest(nmi_fired, test, "intercepted pending NMI delivered to guest");
>  }
>  
>  static bool nmi_finished(struct svm_test *test)
> @@ -1379,11 +1361,8 @@ static void nmi_hlt_test(struct svm_test *test)
>  
>  	asm volatile ("hlt");
>  
> -	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
> -	       "direct NMI + hlt");
> -
> -	if (!nmi_fired)
> -		set_test_stage(test, -1);
> +	report_svm_guest(nmi_fired, test, "direct NMI + hlt");
> +	report(rdtsc() - start > NMI_DELAY, "direct NMI after expected delay");
>  
>  	nmi_fired = false;
>  
> @@ -1395,14 +1374,8 @@ static void nmi_hlt_test(struct svm_test *test)
>  
>  	asm volatile ("hlt");
>  
> -	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
> -	       "intercepted NMI + hlt");
> -
> -	if (!nmi_fired) {
> -		report(nmi_fired, "intercepted pending NMI not dispatched");
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(nmi_fired, test, "intercepted NMI + hlt");
> +	report(rdtsc() - start > NMI_DELAY, "intercepted NMI after expected delay");
>  
>  	set_test_stage(test, 3);
>  }
> @@ -1534,37 +1507,23 @@ static void virq_inject_prepare(struct svm_test *test)
>  
>  static void virq_inject_test(struct svm_test *test)
>  {
> -	if (virq_fired) {
> -		report_fail("virtual interrupt fired before L2 sti");
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(!virq_fired, test, "virtual IRQ blocked after L2 cli");
>  
>  	irq_enable();
>  	asm volatile ("nop");
>  	irq_disable();
>  
> -	if (!virq_fired) {
> -		report_fail("virtual interrupt not fired after L2 sti");
> -		set_test_stage(test, -1);
> -	}
> +	report_svm_guest(virq_fired, test, "virtual IRQ fired after L2 sti");
>  
>  	vmmcall();
>  
> -	if (virq_fired) {
> -		report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
> -		set_test_stage(test, -1);
> -		vmmcall();
> -	}
> +	report_svm_guest(!virq_fired, test, "intercepted VINTR blocked after L2 cli");
>  
>  	irq_enable();
>  	asm volatile ("nop");
>  	irq_disable();
>  
> -	if (!virq_fired) {
> -		report_fail("virtual interrupt not fired after return from VINTR intercept");
> -		set_test_stage(test, -1);
> -	}
> +	report_svm_guest(virq_fired, test, "intercepted VINTR fired after L2 sti");
>  
>  	vmmcall();
>  
> @@ -1572,10 +1531,8 @@ static void virq_inject_test(struct svm_test *test)
>  	asm volatile ("nop");
>  	irq_disable();
>  
> -	if (virq_fired) {
> -		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
> -		set_test_stage(test, -1);
> -	}
> +	report_svm_guest(!virq_fired, test,
> +			  "virtual IRQ blocked V_IRQ_PRIO less than V_TPR");
>  
>  	vmmcall();
>  	vmmcall();
