Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EAC1CC1C8
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 15:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgEIN0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 09:26:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29064 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726951AbgEIN0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 May 2020 09:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TlnBYyi5Kb5wJEzteFDXUEttDNp+YUqUivl5lRzgCSY=;
        b=JySETmHOphOd0gj3rvYMTM6A6OMAOhEzrXxYLE89MhaMnF6o8moyrvHYhRULy3hz9OCQ4Q
        Ql/9BvrCrJIOGSY+a6An4AVQusAU3lZ9hSuQYsMRnsVmDwUIzeDf3gjymdNvnZ/oirvhii
        kghS8Z3sQAQ0N0oISf+37fRI4YFt4gg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-CRFjMNe3MNaWqH2VUh5Kpw-1; Sat, 09 May 2020 09:26:42 -0400
X-MC-Unique: CRFjMNe3MNaWqH2VUh5Kpw-1
Received: by mail-wr1-f70.google.com with SMTP id f15so2397537wrj.2
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 06:26:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TlnBYyi5Kb5wJEzteFDXUEttDNp+YUqUivl5lRzgCSY=;
        b=Mh75s9q+Ao9up3YKGYxYaroY/Nho57/ApAjTIt2M258bivvT/RS/YAPjkjQvZQEzkD
         5UA9OpgY8acQSv0N5znmAp4wJtWWvMBnGAXi7viCp8cK5mz9/Hi83Or1lXi3C7HYfNp0
         5LzwdvWBLqaxHJgK0K9hw9zrfz5XgagjQCqr7BPpl3rjlTWwFG7LDQpFkwAq9ReV+KBM
         9GldPr9ozrYFjde3lMtrI8w+omy/f3K1xTSG0DYHvAI+BgEp9Y6mNWZWBFqCobkLSfaX
         wcg1qAI+CGqfH9hifRfOtXmkiPGAqyl6ZrBnpF2AjKAMIddfPOO2z0wJREgYiC7JKeoj
         ZUDA==
X-Gm-Message-State: AGi0PuZBXsmRCZlcXDM4V/h9CKg7fuavR0qTGxDSErhghxelSuRJ5M4e
        XRqvuMj2lUkHnTsP8cBAHoBb+JgN3e1xFUuY7aGLK43RjQhmKKOv0eO/58/lbY5fAbyFJ7/38K7
        JuOg2OZmlKSXC
X-Received: by 2002:adf:9264:: with SMTP id 91mr8414214wrj.362.1589030800991;
        Sat, 09 May 2020 06:26:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypIuTBtK43w80Rw1QGRu4mCp6VqKfgiVz/31oIU+LQz0mS6OhmKcYWeXX8ksMgJn+sYT9eOukA==
X-Received: by 2002:adf:9264:: with SMTP id 91mr8414198wrj.362.1589030800675;
        Sat, 09 May 2020 06:26:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id n9sm7885904wrv.43.2020.05.09.06.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 06:26:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20200508203938.88508-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a91a13e9-3499-1e4e-48a4-87ab89a67fa3@redhat.com>
Date:   Sat, 9 May 2020 15:26:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508203938.88508-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 22:39, Jim Mattson wrote:
> When the VMX-preemption timer is activated, code executing in VMX
> non-root operation should never be able to record a TSC value beyond
> the deadline imposed by adding the scaled VMX-preemption timer value
> to the first TSC value observed by the guest after VM-entry.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  lib/x86/processor.h | 23 +++++++++++++
>  x86/vmx.h           | 21 ++++++++++++
>  x86/vmx_tests.c     | 81 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 125 insertions(+)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 804673b..cf3acf6 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -479,6 +479,29 @@ static inline unsigned long long rdtsc(void)
>  	return r;
>  }
>  
> +/*
> + * Per the advice in the SDM, volume 2, the sequence "mfence; lfence"
> + * executed immediately before rdtsc ensures that rdtsc will be
> + * executed only after all previous instructions have executed and all
> + * previous loads and stores are globally visible. In addition, the
> + * lfence immediately after rdtsc ensures that rdtsc will be executed
> + * prior to the execution of any subsequent instruction.
> + */
> +static inline unsigned long long fenced_rdtsc(void)
> +{
> +	unsigned long long tsc;
> +
> +#ifdef __x86_64__
> +	unsigned int eax, edx;
> +
> +	asm volatile ("mfence; lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> +	tsc = eax | ((unsigned long long)edx << 32);
> +#else
> +	asm volatile ("mfence; lfence; rdtsc; lfence" : "=A"(tsc));
> +#endif
> +	return tsc;
> +}
> +
>  static inline unsigned long long rdtscp(u32 *aux)
>  {
>         long long r;
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 08b354d..71fdaa0 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -118,6 +118,27 @@ union vmx_ctrl_msr {
>  	};
>  };
>  
> +union vmx_misc {
> +	u64 val;
> +	struct {
> +		u32 pt_bit:5,
> +		    stores_lma:1,
> +		    act_hlt:1,
> +		    act_shutdown:1,
> +		    act_wfsipi:1,
> +		    :5,
> +		    vmx_pt:1,
> +		    smm_smbase:1,
> +		    cr3_targets:9,
> +		    msr_list_size:3,
> +		    smm_mon_ctl:1,
> +		    vmwrite_any:1,
> +		    inject_len0:1,
> +		    :1;
> +		u32 mseg_revision;
> +	};
> +};
> +
>  union vmx_ept_vpid {
>  	u64 val;
>  	struct {
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 0909adb..991c317 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8555,6 +8555,86 @@ static void vmx_preemption_timer_tf_test(void)
>  	handle_exception(DB_VECTOR, old_db);
>  }
>  
> +#define VMX_PREEMPTION_TIMER_EXPIRY_CYCLES 1000000
> +
> +static u64 vmx_preemption_timer_expiry_start;
> +static u64 vmx_preemption_timer_expiry_finish;
> +
> +static void vmx_preemption_timer_expiry_test_guest(void)
> +{
> +	vmcall();
> +	vmx_preemption_timer_expiry_start = fenced_rdtsc();
> +
> +	while (vmx_get_test_stage() == 0)
> +		vmx_preemption_timer_expiry_finish = fenced_rdtsc();
> +}
> +
> +/*
> + * Test that the VMX-preemption timer is not excessively delayed.
> + *
> + * Per the SDM, volume 3, VM-entry starts the VMX-preemption timer
> + * with the unsigned value in the VMX-preemption timer-value field,
> + * and the VMX-preemption timer counts down by 1 every time bit X in
> + * the TSC changes due to a TSC increment (where X is
> + * IA32_VMX_MISC[4:0]). If the timer counts down to zero in any state
> + * other than the wait-for-SIPI state, the logical processor
> + * transitions to the C0 C-state and causes a VM-exit.
> + *
> + * The guest code above reads the starting TSC after VM-entry. At this
> + * point, the VMX-preemption timer has already been activated. Next,
> + * the guest code reads the current TSC in a loop, storing the value
> + * read to memory.
> + *
> + * If the RDTSC in the loop reads a value past the VMX-preemption
> + * timer deadline, then the VMX-preemption timer VM-exit must be
> + * delivered before the next instruction retires. Even if a higher
> + * priority SMI is delivered first, the VMX-preemption timer VM-exit
> + * must be delivered before the next instruction retires. Hence, a TSC
> + * value past the VMX-preemption timer deadline might be read, but it
> + * cannot be stored. If a TSC value past the deadline *is* stored,
> + * then the architectural specification has been violated.
> + */
> +static void vmx_preemption_timer_expiry_test(void)
> +{
> +	u32 preemption_timer_value;
> +	union vmx_misc misc;
> +	u64 tsc_deadline;
> +	u32 reason;
> +
> +	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
> +		report_skip("'Activate VMX-preemption timer' not supported");
> +		return;
> +	}
> +
> +	test_set_guest(vmx_preemption_timer_expiry_test_guest);
> +
> +	enter_guest();
> +	skip_exit_vmcall();
> +
> +	misc.val = rdmsr(MSR_IA32_VMX_MISC);
> +	preemption_timer_value =
> +		VMX_PREEMPTION_TIMER_EXPIRY_CYCLES >> misc.pt_bit;
> +
> +	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
> +	vmcs_write(PREEMPT_TIMER_VALUE, preemption_timer_value);
> +	vmx_set_test_stage(0);
> +
> +	enter_guest();
> +	reason = (u32)vmcs_read(EXI_REASON);
> +	TEST_ASSERT(reason == VMX_PREEMPT);
> +
> +	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> +	vmx_set_test_stage(1);
> +	enter_guest();
> +
> +	tsc_deadline = ((vmx_preemption_timer_expiry_start >> misc.pt_bit) <<
> +			misc.pt_bit) + (preemption_timer_value << misc.pt_bit);
> +
> +	report(vmx_preemption_timer_expiry_finish < tsc_deadline,
> +	       "Last stored guest TSC (%lu) < TSC deadline (%lu)",
> +	       vmx_preemption_timer_expiry_finish, tsc_deadline);
> +}
> +
>  static void vmx_db_test_guest(void)
>  {
>  	/*
> @@ -9861,6 +9941,7 @@ struct vmx_test vmx_tests[] = {
>  	TEST(vmx_store_tsc_test),
>  	TEST(vmx_preemption_timer_zero_test),
>  	TEST(vmx_preemption_timer_tf_test),
> +	TEST(vmx_preemption_timer_expiry_test),
>  	/* EPT access tests. */
>  	TEST(ept_access_test_not_present),
>  	TEST(ept_access_test_read_only),
> 

Queued, thanks.

Paolo

