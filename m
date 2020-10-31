Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760D82A183D
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgJaOhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:37:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgJaOhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604155058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81OeoFgvj7jGYk9lp3ONcJOadZLtJIkMKBE3/aF6Srs=;
        b=YJPs8NyPPFBpnn9pRwNNLe7RK7WEIRXyYeL++b2m+ZHUuQpXw3X1/6nNmAO6TGmgGsUqkK
        ObDeZUcMmeJkKteKBJWHO2TVR8HZlDzgTJAG7fX3eeKaeu28lac6Z3ttWV7UkdiUMIu+RK
        XWJlayYprummHovYYRHiaMBpYAzDGfY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-ddml4gSdP4mNQO7LtineEA-1; Sat, 31 Oct 2020 10:37:31 -0400
X-MC-Unique: ddml4gSdP4mNQO7LtineEA-1
Received: by mail-wr1-f71.google.com with SMTP id 11so2965310wrc.3
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:37:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=81OeoFgvj7jGYk9lp3ONcJOadZLtJIkMKBE3/aF6Srs=;
        b=qdCiLnROBUf+zXpx74G3uciVF/Nlbv50B1O11Rbi8den1qzKDVuzQEovQZyKm/Lxeh
         ZQJGltIQdTjC8kLNd86g9UitYOMlPXMk+WdcSNLbbtSZEjaNy5BjfbVQXRrW86+0Cs7X
         PV5TpWTMDN9AT9jYIAV8OeJIH3P7xAvjl1naZpIWcDpMWOXvengmZL5z1e57obmEtpO1
         BDr1VoYc7LYdOm3fAUWNfUD5oNHYlYDLvVzYDrFz4rUj5yz2jG42HUhM9LTLXf0VxN+F
         ndwmBPR2USVMy2YcHLSSjDt/efZp71IPCyTFsEtk/XRyK3FdvJqp0L1OYu8jxgJAiHE8
         R8+A==
X-Gm-Message-State: AOAM531rDU2eu9sFy3EImWiztSoVzEPPFHh7OMTCcIEIoY4tOPyO5le6
        zDNAG0MzN4+N++5j2lLgvhrS/rOZT9wNV1/tIXmG6/Yf5EoNO9yE4djCYzN9YYIOcWSHwmHA3Gf
        +bbnglKfrIHXB
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3176832wma.48.1604155047416;
        Sat, 31 Oct 2020 07:37:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQSBf4yApDIZM8VxbrMOl7OZfX2U9sGk18a7zdfi4wuSTTDdsB6pa7iwh5jfIIVLP/y4ukpg==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr3176817wma.48.1604155047142;
        Sat, 31 Oct 2020 07:37:27 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id y4sm14670058wrp.74.2020.10.31.07.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:37:26 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] x86: vmx: Add test for SIPI signal
 processing
To:     yadong.qi@intel.com, kvm@vger.kernel.org
Cc:     nadav.amit@gmail.com
References: <20201013052845.249113-1-yadong.qi@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8180e042-44e1-9925-d11d-a88d83baa378@redhat.com>
Date:   Sat, 31 Oct 2020 15:37:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201013052845.249113-1-yadong.qi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/20 07:28, yadong.qi@intel.com wrote:
> From: Yadong Qi <yadong.qi@intel.com>
> 
> The test verifies the following functionality:
> A SIPI signal received when CPU is in VMX non-root mode:
>     if ACTIVITY_STATE == WAIT_SIPI
>         VMExit with (reason == 4)
>     else
>         SIPI signal is ignored
> 
> The test cases depends on IA32_VMX_MISC:bit(8), if this bit is 1
> then the test cases would be executed, otherwise the test cases
> would be skiped.
> 
> Signed-off-by: Yadong Qi <yadong.qi@intel.com>
> ---
> v1->v2:
>  * update CR3 on AP
> 
> ---
>  lib/x86/msr.h       |   1 +
>  lib/x86/processor.h |   5 ++
>  x86/apic.c          |   5 --
>  x86/ioapic.c        |   5 --
>  x86/unittests.cfg   |   8 +++
>  x86/vmx.c           |   2 +-
>  x86/vmx.h           |   3 +
>  x86/vmx_tests.c     | 138 ++++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 156 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index 6ef5502..29e3947 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -421,6 +421,7 @@
>  #define MSR_IA32_VMX_TRUE_ENTRY		0x00000490
>  
>  /* MSR_IA32_VMX_MISC bits */
> +#define MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI		(1ULL << 8)
>  #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS	(1ULL << 29)
>  
>  #define MSR_IA32_TSCDEADLINE		0x000006e0
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index c2c487c..849554f 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -359,6 +359,11 @@ static inline ulong read_cr3(void)
>      return val;
>  }
>  
> +static inline void update_cr3(void *cr3)
> +{
> +    write_cr3((ulong)cr3);
> +}
> +
>  static inline void write_cr4(ulong val)
>  {
>      asm volatile ("mov %0, %%cr4" : : "r"(val) : "memory");
> diff --git a/x86/apic.c b/x86/apic.c
> index a7681fe..b57345b 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -318,11 +318,6 @@ static void nmi_handler(isr_regs_t *regs)
>      nmi_hlt_counter += regs->rip == (ulong)post_sti;
>  }
>  
> -static void update_cr3(void *cr3)
> -{
> -    write_cr3((ulong)cr3);
> -}
> -
>  static void test_sti_nmi(void)
>  {
>      unsigned old_counter;
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index b9f6dd2..7cbccd7 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -463,11 +463,6 @@ static void test_ioapic_logical_destination_mode(void)
>  	report(g_isr_86 == nr_vcpus, "ioapic logical destination mode");
>  }
>  
> -static void update_cr3(void *cr3)
> -{
> -	write_cr3((ulong)cr3);
> -}
> -
>  int main(void)
>  {
>  	setup_vm();
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 872d679..c035c79 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -305,6 +305,14 @@ arch = x86_64
>  groups = vmx
>  timeout = 10
>  
> +[vmx_sipi_signal_test]
> +file = vmx.flat
> +smp = 2
> +extra_params = -cpu host,+vmx -m 2048 -append vmx_sipi_signal_test
> +arch = x86_64
> +groups = vmx
> +timeout = 10
> +
>  [vmx_apic_passthrough_tpr_threshold_test]
>  file = vmx.flat
>  extra_params = -cpu host,+vmx -m 2048 -append vmx_apic_passthrough_tpr_threshold_test
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 1a84a74..f0b853a 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1369,7 +1369,7 @@ static void init_vmcs_guest(void)
>  	vmcs_write(GUEST_INTR_STATE, 0);
>  }
>  
> -static int init_vmcs(struct vmcs **vmcs)
> +int init_vmcs(struct vmcs **vmcs)
>  {
>  	*vmcs = alloc_page();
>  	(*vmcs)->hdr.revision_id = basic.revision;
> diff --git a/x86/vmx.h b/x86/vmx.h
> index e29301e..7e39b84 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -697,6 +697,8 @@ enum vm_entry_failure_code {
>  
>  #define ACTV_ACTIVE		0
>  #define ACTV_HLT		1
> +#define ACTV_SHUTDOWN		2
> +#define ACTV_WAIT_SIPI		3
>  
>  /*
>   * VMCS field encoding:
> @@ -856,6 +858,7 @@ static inline bool invvpid(unsigned long type, u64 vpid, u64 gla)
>  
>  void enable_vmx(void);
>  void init_vmx(u64 *vmxon_region);
> +int init_vmcs(struct vmcs **vmcs);
>  
>  const char *exit_reason_description(u64 reason);
>  void print_vmexit_info(union exit_reason exit_reason);
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index d2084ae..4e8215e 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9855,6 +9855,143 @@ static void vmx_init_signal_test(void)
>  	 */
>  }
>  
> +#define SIPI_SIGNAL_TEST_DELAY	100000000ULL
> +
> +static void vmx_sipi_test_guest(void)
> +{
> +	if (apic_id() == 0) {
> +		/* wait AP enter guest with activity=WAIT_SIPI */
> +		while (vmx_get_test_stage() != 1)
> +			;
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* First SIPI signal */
> +		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
> +		report(1, "BSP(L2): Send first SIPI to cpu[%d]", id_map[1]);
> +
> +		/* wait AP enter guest */
> +		while (vmx_get_test_stage() != 2)
> +			;
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* Second SIPI signal should be ignored since AP is not in WAIT_SIPI state */
> +		apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_STARTUP | APIC_INT_ASSERT, id_map[1]);
> +		report(1, "BSP(L2): Send second SIPI to cpu[%d]", id_map[1]);
> +
> +		/* Delay a while to check whether second SIPI would cause VMExit */
> +		delay(SIPI_SIGNAL_TEST_DELAY);
> +
> +		/* Test is done, notify AP to exit test */
> +		vmx_set_test_stage(3);
> +
> +		/* wait AP exit non-root mode */
> +		while (vmx_get_test_stage() != 5)
> +			;
> +	} else {
> +		/* wait BSP notify test is done */
> +		while (vmx_get_test_stage() != 3)
> +			;
> +
> +		/* AP exit guest */
> +		vmx_set_test_stage(4);
> +	}
> +}
> +
> +static void sipi_test_ap_thread(void *data)
> +{
> +	struct vmcs *ap_vmcs;
> +	u64 *ap_vmxon_region;
> +	void *ap_stack, *ap_syscall_stack;
> +	u64 cpu_ctrl_0 = CPU_SECONDARY;
> +	u64 cpu_ctrl_1 = 0;
> +
> +	/* Enter VMX operation (i.e. exec VMXON) */
> +	ap_vmxon_region = alloc_page();
> +	enable_vmx();
> +	init_vmx(ap_vmxon_region);
> +	_vmx_on(ap_vmxon_region);
> +	init_vmcs(&ap_vmcs);
> +	make_vmcs_current(ap_vmcs);
> +
> +	/* Set stack for AP */
> +	ap_stack = alloc_page();
> +	ap_syscall_stack = alloc_page();
> +	vmcs_write(GUEST_RSP, (u64)(ap_stack + PAGE_SIZE - 1));
> +	vmcs_write(GUEST_SYSENTER_ESP, (u64)(ap_syscall_stack + PAGE_SIZE - 1));
> +
> +	/* passthrough lapic to L2 */
> +	disable_intercept_for_x2apic_msrs();
> +	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
> +	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
> +
> +	/* Set guest activity state to wait-for-SIPI state */
> +	vmcs_write(GUEST_ACTV_STATE, ACTV_WAIT_SIPI);
> +
> +	vmx_set_test_stage(1);
> +
> +	/* AP enter guest */
> +	enter_guest();
> +
> +	if (vmcs_read(EXI_REASON) == VMX_SIPI) {
> +		report(1, "AP: Handle SIPI VMExit");
> +		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
> +		vmx_set_test_stage(2);
> +	} else {
> +		report(0, "AP: Unexpected VMExit, reason=%ld", vmcs_read(EXI_REASON));
> +		vmx_off();
> +		return;
> +	}
> +
> +	/* AP enter guest */
> +	enter_guest();
> +
> +	report(vmcs_read(EXI_REASON) != VMX_SIPI,
> +		"AP: should no SIPI VMExit since activity is not in WAIT_SIPI state");
> +
> +	/* notify BSP that AP is already exit from non-root mode */
> +	vmx_set_test_stage(5);
> +
> +	/* Leave VMX operation */
> +	vmx_off();
> +}
> +
> +static void vmx_sipi_signal_test(void)
> +{
> +	if (!(rdmsr(MSR_IA32_VMX_MISC) & MSR_IA32_VMX_MISC_ACTIVITY_WAIT_SIPI)) {
> +		printf("\tACTIVITY_WAIT_SIPI state is not supported.\n");
> +		return;
> +	}
> +
> +	if (cpu_count() < 2) {
> +		report_skip(__func__);
> +		return;
> +	}
> +
> +	u64 cpu_ctrl_0 = CPU_SECONDARY;
> +	u64 cpu_ctrl_1 = 0;
> +
> +	/* passthrough lapic to L2 */
> +	disable_intercept_for_x2apic_msrs();
> +	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
> +	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
> +
> +	test_set_guest(vmx_sipi_test_guest);
> +
> +	/* update CR3 on AP */
> +	on_cpu(1, update_cr3, (void *)read_cr3());
> +
> +	/* start AP */
> +	on_cpu_async(1, sipi_test_ap_thread, NULL);
> +
> +	vmx_set_test_stage(0);
> +
> +	/* BSP enter guest */
> +	enter_guest();
> +}
> +
> +
>  enum vmcs_access {
>  	ACCESS_VMREAD,
>  	ACCESS_VMWRITE,
> @@ -10492,6 +10629,7 @@ struct vmx_test vmx_tests[] = {
>  	TEST(vmx_apic_passthrough_thread_test),
>  	TEST(vmx_apic_passthrough_tpr_threshold_test),
>  	TEST(vmx_init_signal_test),
> +	TEST(vmx_sipi_signal_test),
>  	/* VMCS Shadowing tests */
>  	TEST(vmx_vmcs_shadow_test),
>  	/* Regression tests */
> 

Queued, thanks.

Paolo

