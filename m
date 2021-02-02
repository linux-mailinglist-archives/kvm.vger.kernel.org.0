Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340B30C7D2
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhBBRcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:32:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237561AbhBBRaG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CZkdNh61O7le0CbHECAB8sfr0Bx+Thk2P3sjc3N/bKQ=;
        b=F2Tqun9qTWK+CfXWcZaPRhBwAdKZmv6HuKQnkxkvYErI6Udga1f/ZcRG3UZgZCsOkMpOwR
        mEAhTk5xNmyLeFFgfDGt1UeX4AsZYoTWI9JRomEAqFZ0sG6J5SDDGE9cj9VTBE9pjed/wD
        sEwGYkvASNj6ff7sYAQx/eCACbZLgR0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-FyCuG9QGO26RZv9JQ83a3A-1; Tue, 02 Feb 2021 12:28:34 -0500
X-MC-Unique: FyCuG9QGO26RZv9JQ83a3A-1
Received: by mail-ej1-f69.google.com with SMTP id by20so10334859ejc.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:28:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZkdNh61O7le0CbHECAB8sfr0Bx+Thk2P3sjc3N/bKQ=;
        b=TscQWD7zf1pxaowtCymoOXR06HcycHiq5CMVm1YYzUSYTYY1kfuWu8qknIO/FovO3+
         lMs1w75fJhnlgVEs8U85fdtN8739pyoA53F4vZbWW0jvZYolQrh0mExUtDmkJKCXPGLr
         ZslOOxlqwFe7SVEJs3Z9zJq794trUEPBvVHBDyIo1XJL7YREP2FpaRFXYozh87Zi5EnM
         OVdLPydiBMxEoQDEYb/FsIq5pL10oRNYUcR2n9U9qzdd65hzpJhXe9TBrDPsvHGuxrBJ
         zBdIzsRLiCw+CN1tvyWkuKrGbcBNLnNiecTpEB5OOmVb1XAbQaMrpkVb36VFaoQtmXDz
         CRIw==
X-Gm-Message-State: AOAM531LMWoGxVIcatEgWDEmDhYYqWB8pivDUVYk7u/3BLEFMj4AaoLs
        1MSl+oDZZjxRICVPIUrbE9ussHN5PCUzFfOn1bfp4C562010B7p4AI3blbJg33pqJ6J2PF5kSMN
        rBCBcdqPNTYKK
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr17416edd.322.1612286912971;
        Tue, 02 Feb 2021 09:28:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3wB1DHggt7jgM7wccWOCPC8sNCjgSGwqoQ/n0BFQduRsVxo/1gSOcdilioMNVN5ZJ4yK1XA==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr17392edd.322.1612286912688;
        Tue, 02 Feb 2021 09:28:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a15sm3505783edy.86.2021.02.02.09.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:28:31 -0800 (PST)
Subject: Re: [PATCH] selftest: kvm: x86: test KVM_GET_CPUID2 and guest visible
 CPUIDs against KVM_GET_SUPPORTED_CPUID
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Roth <michael.roth@amd.com>
References: <20210129161821.74635-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef84a126-42bc-344c-1095-07d592197043@redhat.com>
Date:   Tue, 2 Feb 2021 18:28:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210129161821.74635-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/21 17:18, Vitaly Kuznetsov wrote:
> Commit 181f494888d5 ("KVM: x86: fix CPUID entries returned by
> KVM_GET_CPUID2 ioctl") revealed that we're not testing KVM_GET_CPUID2
> ioctl at all. Add a test for it and also check that from inside the guest
> visible CPUIDs are equal to it's output.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   tools/testing/selftests/kvm/.gitignore        |   5 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/processor.h  |  14 ++
>   .../selftests/kvm/lib/x86_64/processor.c      |  42 +++++
>   .../selftests/kvm/x86_64/get_cpuid_test.c     | 175 ++++++++++++++++++
>   5 files changed, 237 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index ce8f4ad39684..3194df487404 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -7,6 +7,7 @@
>   /x86_64/cr4_cpuid_sync_test
>   /x86_64/debug_regs
>   /x86_64/evmcs_test
> +/x86_64/get_cpuid_test
>   /x86_64/kvm_pv_test
>   /x86_64/hyperv_cpuid
>   /x86_64/mmio_warning_test
> @@ -17,6 +18,7 @@
>   /x86_64/svm_vmcall_test
>   /x86_64/sync_regs_test
>   /x86_64/tsc_msrs_test
> +/x86_64/user_msr_test
>   /x86_64/userspace_msr_exit_test
>   /x86_64/vmx_apic_access_test
>   /x86_64/vmx_close_while_nested_test
> @@ -24,8 +26,11 @@
>   /x86_64/vmx_preemption_timer_test
>   /x86_64/vmx_set_nested_state_test
>   /x86_64/vmx_tsc_adjust_test
> +/x86_64/xen_shinfo_test
> +/x86_64/xen_vmcall_test
>   /x86_64/xss_msr_test
>   /demand_paging_test
> +/clear_dirty_log_test
>   /dirty_log_test
>   /dirty_log_perf_test
>   /kvm_create_max_vcpus
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index fe41c6a0fa67..b4743fd0d37b 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -40,6 +40,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
>   
>   TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>   TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
>   TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>   TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>   TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 90cd5984751b..c8ab021a3b6e 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -263,6 +263,19 @@ static inline void outl(uint16_t port, uint32_t value)
>   	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
>   }
>   
> +static inline void cpuid(uint32_t *eax, uint32_t *ebx,
> +			 uint32_t *ecx, uint32_t *edx)
> +{
> +	/* ecx is often an input as well as an output. */
> +	asm volatile("cpuid"
> +	    : "=a" (*eax),
> +	      "=b" (*ebx),
> +	      "=c" (*ecx),
> +	      "=d" (*edx)
> +	    : "0" (*eax), "2" (*ecx)
> +	    : "memory");
> +}
> +
>   #define SET_XMM(__var, __xmm) \
>   	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
>   
> @@ -340,6 +353,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
>   struct kvm_msr_list *kvm_get_msr_index_list(void);
>   
>   struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
> +struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
>   void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
>   		    struct kvm_cpuid2 *cpuid);
>   
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 95e1a757c629..7a4dea86fad0 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -669,6 +669,48 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
>   	return cpuid;
>   }
>   
> +/*
> + * VM VCPU CPUID Set
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   vcpuid - VCPU id
> + *
> + * Output Args: None
> + *
> + * Return: KVM CPUID (KVM_GET_CPUID2)
> + *
> + * Set the VCPU's CPUID.
> + */
> +struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +	struct kvm_cpuid2 *cpuid;
> +	int rc, max_ent;
> +
> +	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
> +
> +	cpuid = allocate_kvm_cpuid2();
> +	max_ent = cpuid->nent;
> +
> +	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
> +		rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
> +		if (!rc)
> +			break;
> +
> +		TEST_ASSERT(rc == -1 && errno == E2BIG,
> +			    "KVM_GET_CPUID2 should either succeed or give E2BIG: %d %d",
> +			    rc, errno);
> +	}
> +
> +	TEST_ASSERT(rc == 0, "KVM_GET_CPUID2 failed, rc: %i errno: %i",
> +		    rc, errno);
> +
> +	return cpuid;
> +}
> +
> +
> +
>   /*
>    * Locate a cpuid entry.
>    *
> diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> new file mode 100644
> index 000000000000..9b78e8889638
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Red Hat Inc.
> + *
> + * Generic tests for KVM CPUID set/get ioctls
> + */
> +#include <asm/kvm_para.h>
> +#include <linux/kvm_para.h>
> +#include <stdint.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID 0
> +
> +/* CPUIDs known to differ */
> +struct {
> +	u32 function;
> +	u32 index;
> +} mangled_cpuids[] = {
> +	{.function = 0xd, .index = 0},
> +};
> +
> +static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
> +{
> +	int i;
> +	u32 eax, ebx, ecx, edx;
> +
> +	for (i = 0; i < guest_cpuid->nent; i++) {
> +		eax = guest_cpuid->entries[i].function;
> +		ecx = guest_cpuid->entries[i].index;
> +
> +		cpuid(&eax, &ebx, &ecx, &edx);
> +
> +		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
> +			     ebx == guest_cpuid->entries[i].ebx &&
> +			     ecx == guest_cpuid->entries[i].ecx &&
> +			     edx == guest_cpuid->entries[i].edx);
> +	}
> +
> +}
> +
> +static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
> +{
> +	u32 eax = 0x40000000, ebx, ecx = 0, edx;
> +
> +	cpuid(&eax, &ebx, &ecx, &edx);
> +
> +	GUEST_ASSERT(eax == 0x40000001);
> +}
> +
> +static void guest_main(struct kvm_cpuid2 *guest_cpuid)
> +{
> +	GUEST_SYNC(1);
> +
> +	test_guest_cpuids(guest_cpuid);
> +
> +	GUEST_SYNC(2);
> +
> +	test_cpuid_40000000(guest_cpuid);
> +
> +	GUEST_DONE();
> +}
> +
> +static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
> +{
> +	int i;
> +
> +	for (i = 0; i < sizeof(mangled_cpuids); i++) {
> +		if (mangled_cpuids[i].function == entrie->function &&
> +		    mangled_cpuids[i].index == entrie->index)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void check_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *entrie)
> +{
> +	int i;
> +
> +	for (i = 0; i < cpuid->nent; i++) {
> +		if (cpuid->entries[i].function == entrie->function &&
> +		    cpuid->entries[i].index == entrie->index) {
> +			if (is_cpuid_mangled(entrie))
> +				return;
> +
> +			TEST_ASSERT(cpuid->entries[i].eax == entrie->eax &&
> +				    cpuid->entries[i].ebx == entrie->ebx &&
> +				    cpuid->entries[i].ecx == entrie->ecx &&
> +				    cpuid->entries[i].edx == entrie->edx,
> +				    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
> +				    entrie->function, entrie->index,
> +				    cpuid->entries[i].eax, cpuid->entries[i].ebx,
> +				    cpuid->entries[i].ecx, cpuid->entries[i].edx,
> +				    entrie->eax, entrie->ebx, entrie->ecx, entrie->edx);
> +			return;
> +		}
> +	}
> +
> +	TEST_ASSERT(false, "CPUID 0x%x.%x not found", entrie->function, entrie->index);
> +}
> +
> +static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
> +{
> +	int i;
> +
> +	for (i = 0; i < cpuid1->nent; i++)
> +		check_cpuid(cpuid2, &cpuid1->entries[i]);
> +
> +	for (i = 0; i < cpuid2->nent; i++)
> +		check_cpuid(cpuid1, &cpuid2->entries[i]);
> +}
> +
> +static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
> +{
> +	struct ucall uc;
> +
> +	_vcpu_run(vm, vcpuid);
> +
> +	switch (get_ucall(vm, vcpuid, &uc)) {
> +	case UCALL_SYNC:
> +		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
> +			    uc.args[1] == stage + 1,
> +			    "Stage %d: Unexpected register values vmexit, got %lx",
> +			    stage + 1, (ulong)uc.args[1]);
> +		return;
> +	case UCALL_DONE:
> +		return;
> +	case UCALL_ABORT:
> +		TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx", (const char *)uc.args[0],
> +			    __FILE__, uc.args[1], uc.args[2], uc.args[3]);
> +	default:
> +		TEST_ASSERT(false, "Unexpected exit: %s",
> +			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
> +	}
> +}
> +
> +struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
> +{
> +	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
> +	vm_vaddr_t gva = vm_vaddr_alloc(vm, size,
> +					getpagesize(), 0, 0);
> +	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
> +
> +	memcpy(guest_cpuids, cpuid, size);
> +
> +	*p_gva = gva;
> +	return guest_cpuids;
> +}
> +
> +int main(void)
> +{
> +	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
> +	vm_vaddr_t cpuid_gva;
> +	struct kvm_vm *vm;
> +	int stage;
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +
> +	supp_cpuid = kvm_get_supported_cpuid();
> +	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
> +
> +	compare_cpuids(supp_cpuid, cpuid2);
> +
> +	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
> +
> +	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
> +
> +	for (stage = 0; stage < 3; stage++)
> +		run_vcpu(vm, VCPU_ID, stage);
> +
> +	kvm_vm_free(vm);
> +}
> 

Queued, thanks.

Paolo

