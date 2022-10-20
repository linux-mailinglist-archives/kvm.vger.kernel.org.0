Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A313C606971
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiJTUYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 16:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJTUYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 16:24:03 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6BD1A850A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:24:02 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m6so661160pfb.0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MlYE73Gpls20Usxo+vMgw+yRD+OC4HHmmE4OqT/8ZI8=;
        b=nYm9AKlGtDUparxY3XHN81p+g+0zj5eomH7LuCJABPnYvT1z1SRAqUJM97LAyG36UD
         d4uj6jvj+SwUnhck+CGaTDT/6AbUlxF5IYbC6wGzhUyRUnfJBI2t5Rqrjgd+IO9mIeK6
         n37GWdoNbnYQls2vtyVScu9y5r2EowD2rpoqx+eqiq8gnVotJ2xAO7fZfStuBnqSekfh
         XKbo7g3SN9zQaV8EM14phgaaPOo5+cUgY+qUBSi/HQbrfj9aMgoKytVh0nLJB61FZNhq
         MLP272E4pcaQ2beBCmFprdiEUJZ3DNu2v5zsYKhptC9pwXJ1umKRCWQVtNPQkhsg28WB
         pkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlYE73Gpls20Usxo+vMgw+yRD+OC4HHmmE4OqT/8ZI8=;
        b=fTeEYsU/QGlxSYn6Vz9Ss5rUs7eKcIEmMdWnF9ppIfbE60i7Dqd9RWpukb0KxMv6Fo
         QWfbnCtMXOColsfEqEZJHwp3OszqNn8tKtcgIAHv5UESAHmveYQEI/We63fgzM8kcnNb
         xIKeCXAZ/TJuaiD6ejAXdLrnXR5OCsuuLjBckcYuEVBOhdgb4IiEczPxs++yWLKy+55d
         M8N4/BPHkOwJpR87wwXXoGLaDTL+E6b7DvIKS0mGMJgQNQ2aNpZa2NKorTvQhDSjMn3R
         VGY4ZvQO5mVUTsz/3AcXNPCThPwfqdvuAi1hTWzl9J09xWExEWHRKWT+klXM8Bkjn6qE
         by8w==
X-Gm-Message-State: ACrzQf2lGpUJFEhfNu5MO9yI/GHLQsbaUEmcIbnwTgfwn3crhtjNgQNM
        +VWOAoujjdyWCyGHMIVAz3MI5g==
X-Google-Smtp-Source: AMsMyM4/v7nWXrlFM6IGkvGtvLhbmEkz+mYK8uPX7feokF0jdEki2ViUEm+3L/SuBUom0kTYaF4H6g==
X-Received: by 2002:a63:1349:0:b0:44b:2240:b311 with SMTP id 9-20020a631349000000b0044b2240b311mr13136976pgt.405.1666297441803;
        Thu, 20 Oct 2022 13:24:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090a6acf00b00205fafa6768sm342238pjm.6.2022.10.20.13.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 13:24:01 -0700 (PDT)
Date:   Thu, 20 Oct 2022 20:23:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
Message-ID: <Y1GuXoYm6JLpkUvq@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-17-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-17-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> +u64 num_iterations = -1;

"Run indefinitely" is an odd default.  Why not set the default number of iterations
to something reasonable and then let the user override that if the user wants to
run for an absurdly long time?

> +
> +volatile u64 *isr_counts;
> +bool use_svm;
> +int hlt_allowed = -1;

These can all be static.

> +
> +static int get_random(int min, int max)
> +{
> +	/* TODO : use rdrand to seed an PRNG instead */
> +	u64 random_value = rdtsc() >> 4;
> +
> +	return min + random_value % (max - min + 1);
> +}
> +
> +static void ipi_interrupt_handler(isr_regs_t *r)
> +{
> +	isr_counts[smp_id()]++;
> +	eoi();
> +}
> +
> +static void wait_for_ipi(volatile u64 *count)
> +{
> +	u64 old_count = *count;
> +	bool use_halt;
> +
> +	switch (hlt_allowed) {
> +	case -1:
> +		use_halt = get_random(0,10000) == 0;

Randomly doing "halt" is going to be annoying to debug.  What about tying the
this decision to the iteration and then providing a knob to let the user specify
the frequency?  It seems unlikely that this test will expose a bug that occurs
if and only if the halt path is truly random.

> +		break;
> +	case 0:
> +		use_halt = false;
> +		break;
> +	case 1:
> +		use_halt = true;
> +		break;
> +	default:
> +		use_halt = false;
> +		break;
> +	}
> +
> +	do {
> +		if (use_halt)
> +			asm volatile ("sti;hlt;cli\n");

safe_halt();

> +		else
> +			asm volatile ("sti;nop;cli");

sti_nop_cli();

> +
> +	} while (old_count == *count);

There's no need to loop in the use_halt case.  If KVM spuriously wakes the vCPU
from halt, then that's a KVM bug.  Kinda ugly, but it does provide meaningfully
coverage for the HLT case.

	if (use_halt) {
		safe_halt();
		cli();
	} else {
		do {
			sti_nop_cli();
		} while (old_count == *count);
	}

	assert(*count == old_count + 1);

> +}
> +
> +/******************************************************************************************************/
> +
> +#ifdef __x86_64__
> +
> +static void l2_guest_wait_for_ipi(volatile u64 *count)
> +{
> +	wait_for_ipi(count);
> +	asm volatile("vmmcall");
> +}
> +
> +static void l2_guest_dummy(void)
> +{
> +	asm volatile("vmmcall");
> +}
> +
> +static void wait_for_ipi_in_l2(volatile u64 *count, struct svm_vcpu *vcpu)
> +{
> +	u64 old_count = *count;
> +	bool irq_on_vmentry = get_random(0,1) == 0;

Same concerns about using random numbers.

> +
> +	vcpu->vmcb->save.rip = (ulong)l2_guest_wait_for_ipi;
> +	vcpu->regs.rdi = (u64)count;
> +
> +	vcpu->vmcb->save.rip = irq_on_vmentry ? (ulong)l2_guest_dummy : (ulong)l2_guest_wait_for_ipi;
> +
> +	do {
> +		if (irq_on_vmentry)
> +			vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
> +		else
> +			vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
> +
> +		asm volatile("clgi;nop;sti");

Why a NOP between CLGI and STI?  And why re-enable GIF on each iteration?

> +		// GIF is set by VMRUN
> +		SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
> +		// GIF is cleared by VMEXIT
> +		asm volatile("cli;nop;stgi");

Why re-enable GIF on every exit?

> +
> +		assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +
> +	} while (old_count == *count);

Isn't the loop only necessary in the irq_on_vmentry case?

static void run_svm_l2(...)
{
	SVM_VMRUN(vcpu->vmcb, &vcpu->regs);
	assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
}

E.g. can't this be:

	bool irq_on_vmentry = ???;
	u64 old_count = *count;

	clgi();
	sti();

	vcpu->regs.rdi = (u64)count;

	if (!irq_on_vmentry) {
		vcpu->vmcb->save.rip = (ulong)l2_guest_wait_for_ipi;
		vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
		run_svm_l2(...);
	} else {
		vcpu->vmcb->save.rip = (ulong)l2_guest_dummy
		vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
		do {
			run_svm_l2(...);
		} while (old_count == *count);
	}

	assert(*count == old_count + 1);
	cli();
	stgi();

> +}
> +#endif
> +
> +/******************************************************************************************************/
> +
> +#define FIRST_TEST_VCPU 1
> +
> +static void vcpu_init(void *data)
> +{
> +	/* To make it easier to see iteration number in the trace */
> +	handle_irq(0x40, ipi_interrupt_handler);
> +	handle_irq(0x50, ipi_interrupt_handler);

Why not make it even more granular?  E.g. do vector == 32 + (iteration % ???)
Regardless, a #define for the (base) vector would be helpful, the usage in
vcpu_code() is a bit magical.


> +}
> +
> +static void vcpu_code(void *data)
> +{
> +	int ncpus = cpu_count();
> +	int cpu = (long)data;
> +#ifdef __x86_64__
> +	struct svm_vcpu vcpu;
> +#endif
> +
> +	u64 i;
> +
> +#ifdef __x86_64__
> +	if (cpu == 2 && use_svm)

Why only CPU2?

> +		svm_vcpu_init(&vcpu);
> +#endif
> +
> +	assert(cpu != 0);
> +
> +	if (cpu != FIRST_TEST_VCPU)
> +		wait_for_ipi(&isr_counts[cpu]);
> +
> +	for (i = 0; i < num_iterations; i++)
> +	{
> +		u8 physical_dst = cpu == ncpus -1 ? 1 : cpu + 1;

Space after the '-'.

> +
> +		// send IPI to a next vCPU in a circular fashion
> +		apic_icr_write(APIC_INT_ASSERT |
> +				APIC_DEST_PHYSICAL |
> +				APIC_DM_FIXED |
> +				(i % 2 ? 0x40 : 0x50),
> +				physical_dst);
> +
> +		if (i == (num_iterations - 1) && cpu != FIRST_TEST_VCPU)
> +			break;
> +
> +#ifdef __x86_64__
> +		// wait for the IPI interrupt chain to come back to us
> +		if (cpu == 2 && use_svm) {
> +				wait_for_ipi_in_l2(&isr_counts[cpu], &vcpu);

Indentation is funky.

> +				continue;
> +		}
> +#endif
> +		wait_for_ipi(&isr_counts[cpu]);
> +	}
> +}
> +
> +int main(int argc, void** argv)
> +{
> +	int cpu, ncpus = cpu_count();
> +
> +	assert(ncpus > 2);
> +
> +	if (argc > 1)
> +		hlt_allowed = atol(argv[1]);
> +
> +	if (argc > 2)
> +		num_iterations = atol(argv[2]);
> +
> +	setup_vm();
> +
> +#ifdef __x86_64__
> +	if (svm_supported()) {
> +		use_svm = true;
> +		setup_svm();
> +	}
> +#endif
> +
> +	isr_counts = (volatile u64 *)calloc(ncpus, sizeof(u64));
> +
> +	printf("found %d cpus\n", ncpus);
> +	printf("running for %lld iterations - test\n",
> +		(long long unsigned int)num_iterations);
> +
> +
> +	for (cpu = 0; cpu < ncpus; ++cpu)
> +		on_cpu_async(cpu, vcpu_init, (void *)(long)cpu);
> +
> +	/* now let all the vCPUs end the IPI function*/
> +	while (cpus_active() > 1)
> +		  pause();
> +
> +	printf("starting test on all cpus but 0...\n");
> +
> +	for (cpu = ncpus-1; cpu >= FIRST_TEST_VCPU; cpu--)

Spaces around the '-'.

> +		on_cpu_async(cpu, vcpu_code, (void *)(long)cpu);

Why not use smp_id() in vcpu_code()?  ipi_interrupt_handler() already relies on
that being correct.

> +
> +	printf("test started, waiting to end...\n");
> +
> +	while (cpus_active() > 1) {
> +
> +		unsigned long isr_count1, isr_count2;
> +
> +		isr_count1 = isr_counts[1];
> +		delay(5ULL*1000*1000*1000);

Please add a macro or two for nanoseconds/milliseconds/seconds or whatever this
expands to.

> +		isr_count2 = isr_counts[1];
> +
> +		if (isr_count1 == isr_count2) {
> +			printf("\n");
> +			printf("hang detected!!\n");
> +			break;
> +		} else {
> +			printf("made %ld IPIs \n", (isr_count2 - isr_count1)*(ncpus-1));
> +		}
> +	}
> +
> +	printf("\n");
> +
> +	for (cpu = 1; cpu < ncpus; ++cpu)
> +		report(isr_counts[cpu] == num_iterations,
> +				"Number of IPIs match (%lld)",

Indentation.

> +				(long long unsigned int)isr_counts[cpu]);

Print num_iterations, i.e. expected vs. actual?

> +
> +	free((void*)isr_counts);
> +	return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index ebb3fdfc..7655d2ba 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -61,6 +61,11 @@ smp = 2
>  file = smptest.flat
>  smp = 3
>  
> +[ipi_stress]
> +file = ipi_stress.flat
> +extra_params = -cpu host,-x2apic,-svm,-hypervisor -global kvm-pit.lost_tick_policy=discard -machine kernel-irqchip=on -append '0 50000'

Why add all the SVM and HLT stuff and then effectively turn them off by default?
There's basically zero chance any other configuration will get regular testing.

And why not have multi configs, e.g. to run with and without x2APIC?

> +smp = 4
> +
>  [vmexit_cpuid]
>  file = vmexit.flat
>  extra_params = -append 'cpuid'
> -- 
> 2.26.3
> 
