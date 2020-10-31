Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3852A180C
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgJaOE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727407AbgJaOE4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604153093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqhtiqEB1bu49kWYY3RTo+Lr7N9/OE+hsqGWxhP+PuI=;
        b=hiqsyTuMYpNU3JlfoxSQdQCHSqb0p0gT4cBv6dRVao01ejfTc4aZ4EpcGCNZpG0xSA8DB1
        e4kkBxmUdTQphe7Pe93PgonCg/N8zs6bA1/HBLBKV3XEtmiYvzd5AMyb09ajPIf8UGCLee
        8yq8YGrby0SVZZOgmpM8Evi8RMIerAY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-wPT-8wYBOnC5Zbn_4u-Z8w-1; Sat, 31 Oct 2020 10:04:50 -0400
X-MC-Unique: wPT-8wYBOnC5Zbn_4u-Z8w-1
Received: by mail-wm1-f71.google.com with SMTP id r23so889590wmh.0
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UqhtiqEB1bu49kWYY3RTo+Lr7N9/OE+hsqGWxhP+PuI=;
        b=Q/hzpvvvoWMRlqHjTMyB04rt1d5aU+ADMT3PS9dpA3pWiexK9UKeOps2Ihq/SpQYOK
         16LC+g7IzTC/tYvmlo/KoVW2tnkpUfGJj9eiyBHnMI4enVqvJ8IjQ+qmItxlhZuIBR43
         O6EzBquuG5CC9nHJI9MoliYxPBvnP6wWKTwpqAXaRrPksihH74GSXZ//HG2dMjYEooMj
         8JVWcJSA2g7wFaswI9j8KPwxEfcfWn9NCTCkz+BnslR2y/Nz6lAYRZH26YxKeZ26fS5W
         eACrV5xex8A6IfVsFR2rNNU6nGfFmtYoCXy7F2CNJ3ByW+5SAYNp0qzR/ZqnZ+UhBfLp
         2iAg==
X-Gm-Message-State: AOAM533JU+sEFuZh0GrZ60XOYY2KzKi2fK7VDe9OcWuj1tBioBzKeuCr
        2CUnJysHqYEuaKg/CBdhjkHwhRBgf8DDxanm3gyWaQZVwv+pHPW6CrbhDQvDbXY0HZgufQrfNT+
        eUPMaOpkqsyL/
X-Received: by 2002:a5d:4e48:: with SMTP id r8mr9230257wrt.141.1604153089224;
        Sat, 31 Oct 2020 07:04:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAI1TSAwokQAhbHe/PnAn3gvUyOFFcR/JsaQj7QxcgdHk9YHla/81UTpqrQMyPZLVekAnCWQ==
X-Received: by 2002:a5d:4e48:: with SMTP id r8mr9230226wrt.141.1604153088935;
        Sat, 31 Oct 2020 07:04:48 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id v123sm8713361wme.7.2020.10.31.07.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:04:48 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: test behavior of unmapped L2 APIC-access
 address
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>
References: <20201026180922.3120555-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a0f6ad81-8e03-f3ec-426b-093f960876d1@redhat.com>
Date:   Sat, 31 Oct 2020 15:04:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201026180922.3120555-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/20 19:09, Jim Mattson wrote:
> Add a regression test for commit 671ddc700fd0 ("KVM: nVMX: Don't leak
> L1 MMIO regions to L2").
> 
> First, check to see that an L2 guest can be launched with a valid
> APIC-access address that is backed by a page of L1 physical memory.
> 
> Next, set the APIC-access address to a (valid) L1 physical address
> that is not backed by memory. KVM can't handle this situation, so
> resuming L2 should result in a KVM exit for internal error
> (emulation).
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/vmx.h        |   6 +
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   9 ++
>  .../kvm/x86_64/vmx_apic_access_test.c         | 142 ++++++++++++++++++
>  5 files changed, 159 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 307ceaadbbb9..d2c2d6205008 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -15,6 +15,7 @@
>  /x86_64/vmx_preemption_timer_test
>  /x86_64/svm_vmcall_test
>  /x86_64/sync_regs_test
> +/x86_64/vmx_apic_access_test
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_dirty_log_test
>  /x86_64/vmx_set_nested_state_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 7ebe71fbca53..30afbad36cd5 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -49,6 +49,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 54d624dd6c10..e78d7e26ba61 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -573,6 +573,10 @@ struct vmx_pages {
>  	void *eptp_hva;
>  	uint64_t eptp_gpa;
>  	void *eptp;
> +
> +	void *apic_access_hva;
> +	uint64_t apic_access_gpa;
> +	void *apic_access;
>  };
>  
>  union vmx_basic {
> @@ -615,5 +619,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
>  			uint32_t memslot, uint32_t eptp_memslot);
>  void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>  		  uint32_t eptp_memslot);
> +void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
> +				      uint32_t eptp_memslot);
>  
>  #endif /* SELFTEST_KVM_VMX_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index f1e00d43eea2..2448b30e8efa 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -542,3 +542,12 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>  	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
>  	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
>  }
> +
> +void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
> +				      uint32_t eptp_memslot)
> +{
> +	vmx->apic_access = (void *)vm_vaddr_alloc(vm, getpagesize(),
> +						  0x10000, 0, 0);
> +	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
> +	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
> new file mode 100644
> index 000000000000..1f65342d6cb7
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
> @@ -0,0 +1,142 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vmx_apic_access_test
> + *
> + * Copyright (C) 2020, Google LLC.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * The first subtest simply checks to see that an L2 guest can be
> + * launched with a valid APIC-access address that is backed by a
> + * page of L1 physical memory.
> + *
> + * The second subtest sets the APIC-access address to a (valid) L1
> + * physical address that is not backed by memory. KVM can't handle
> + * this situation, so resuming L2 should result in a KVM exit for
> + * internal error (emulation). This is not an architectural
> + * requirement. It is just a shortcoming of KVM. The internal error
> + * is unfortunate, but it's better than what used to happen!
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "vmx.h"
> +
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "kselftest.h"
> +
> +#define VCPU_ID		0
> +
> +/* The virtual machine object. */
> +static struct kvm_vm *vm;
> +
> +static void l2_guest_code(void)
> +{
> +	/* Exit to L1 */
> +	__asm__ __volatile__("vmcall");
> +}
> +
> +static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
> +{
> +#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	uint32_t control;
> +
> +	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
> +	GUEST_ASSERT(load_vmcs(vmx_pages));
> +
> +	/* Prepare the VMCS for L2 execution. */
> +	prepare_vmcs(vmx_pages, l2_guest_code,
> +		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
> +	control |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
> +	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
> +	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
> +	control |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> +	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
> +	vmwrite(APIC_ACCESS_ADDR, vmx_pages->apic_access_gpa);
> +
> +	/* Try to launch L2 with the memory-backed APIC-access address. */
> +	GUEST_SYNC(vmreadz(APIC_ACCESS_ADDR));
> +	GUEST_ASSERT(!vmlaunch());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +
> +	vmwrite(APIC_ACCESS_ADDR, high_gpa);
> +
> +	/* Try to resume L2 with the unbacked APIC-access address. */
> +	GUEST_SYNC(vmreadz(APIC_ACCESS_ADDR));
> +	GUEST_ASSERT(!vmresume());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	unsigned long apic_access_addr = ~0ul;
> +	unsigned int paddr_width;
> +	unsigned int vaddr_width;
> +	vm_vaddr_t vmx_pages_gva;
> +	unsigned long high_gpa;
> +	struct vmx_pages *vmx;
> +	bool done = false;
> +
> +	nested_vmx_check_supported();
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
> +	high_gpa = (1ul << paddr_width) - getpagesize();
> +	if ((unsigned long)DEFAULT_GUEST_PHY_PAGES * getpagesize() > high_gpa) {
> +		print_skip("No unbacked physical page available");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
> +	prepare_virtualize_apic_accesses(vmx, vm, 0);
> +	vcpu_args_set(vm, VCPU_ID, 2, vmx_pages_gva, high_gpa);
> +
> +	while (!done) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +		if (apic_access_addr == high_gpa) {
> +			TEST_ASSERT(run->exit_reason ==
> +				    KVM_EXIT_INTERNAL_ERROR,
> +				    "Got exit reason other than KVM_EXIT_INTERNAL_ERROR: %u (%s)\n",
> +				    run->exit_reason,
> +				    exit_reason_str(run->exit_reason));
> +			TEST_ASSERT(run->internal.suberror ==
> +				    KVM_INTERNAL_ERROR_EMULATION,
> +				    "Got internal suberror other than KVM_INTERNAL_ERROR_EMULATION: %u\n",
> +				    run->internal.suberror);
> +			break;
> +		}
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> +				  __FILE__, uc.args[1]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			apic_access_addr = uc.args[1];
> +			break;
> +		case UCALL_DONE:
> +			done = true;
> +			break;
> +		default:
> +			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> 

Queued, thanks.

Paolo

