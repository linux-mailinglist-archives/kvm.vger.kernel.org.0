Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502AF2FA8D1
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436803AbhARS3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:29:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436737AbhARS32 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610994481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RO9BQ4gIYT4Y+WIqNDUp5CVyTFzspTWs4LN/9aBCM0E=;
        b=aEPzIHn8QZzCdNvxGGa2CqvMu6T/VjjpwtVMOoDXD5eSh33iRSIpso34lez5f6fRPOxjgP
        sAnK6ZHSakWiaQ1itcmkDaEwpGKXYIZb+EV/iCfaj+R6B6grHn5vD8FKspiUIuk4XRMuXU
        07yqd4AGF8HWax69Y5z9WZ9tWsFmjis=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-MutdUdqyO76D_emxKd6iNg-1; Mon, 18 Jan 2021 13:27:57 -0500
X-MC-Unique: MutdUdqyO76D_emxKd6iNg-1
Received: by mail-wr1-f70.google.com with SMTP id v7so8666781wra.3
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RO9BQ4gIYT4Y+WIqNDUp5CVyTFzspTWs4LN/9aBCM0E=;
        b=Ak5Zd7iJNkfNj1FZDsFKCD+uGYJGms/kwZjqpm1y42F/9xZcqf+KdEQUZqrfy3rRnq
         hvScdJo2WF3iQ0bl7Ym/rEweAbYwjeeS5WBwPsmHwQvASAx16Zd/RZ2b7TAWvE6d5V8W
         dDGCNWsLaMSQXxOnWC6wBJim8XSx70gyiq1U6dXl8MI8yWmZ7p1Fgmi1AyHODA9cCqlU
         TNY2M33Lh0Xy7kvaZhc8YAJI4Ita1i8/8GFGgXs6p8cvEGmvuO0stQnShIGsiYLPmXZe
         1CxIW8TftUab9jllx/Tf4Y2F1Wn4UkSS3Quh9EKw2w4hvLrLUgFhuRq7WjYmkxanlDdK
         fA+A==
X-Gm-Message-State: AOAM530qahkj/mBbXmz8bZWrnAzyrFrewNujhADpeTeQH6Rx7NbNgEph
        EiA8swFSnXhSd7baKF0tGXqmMsJ0zt/R1jnTqBrL0SqXStJ7klU7RHBYjRHxxgcUNWC7vRgQk8h
        fj1M/ekLkTYBZ
X-Received: by 2002:a1c:730f:: with SMTP id d15mr579269wmb.135.1610994476796;
        Mon, 18 Jan 2021 10:27:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy52T6muva6uT/9VQbA/e19xDfw5pSrtXU3K2BnaH0bn9AQwT88sgb/wNBjl14VGUD8FoztSg==
X-Received: by 2002:a1c:730f:: with SMTP id d15mr579259wmb.135.1610994476605;
        Mon, 18 Jan 2021 10:27:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q6sm258757wmj.32.2021.01.18.10.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:27:55 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for PKS
To:     Thomas Huth <thuth@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
 <20201105081805.5674-9-chenyi.qiang@intel.com>
 <6174185b-25e0-f2a2-3f71-d8bbe6ca889d@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7aa67008-a72f-f6e3-2de4-4b9b9e62cd86@redhat.com>
Date:   Mon, 18 Jan 2021 19:27:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6174185b-25e0-f2a2-3f71-d8bbe6ca889d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/21 18:45, Thomas Huth wrote:
> On 05/11/2020 09.18, Chenyi Qiang wrote:
>> This unit-test is intended to test the KVM support for Protection Keys
>> for Supervisor Pages (PKS). If CR4.PKS is set in long mode, supervisor
>> pkeys are checked in addition to normal paging protections and Access or
>> Write can be disabled via a MSR update without TLB flushes when
>> permissions change.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   lib/x86/msr.h       |   1 +
>>   lib/x86/processor.h |   2 +
>>   x86/Makefile.x86_64 |   1 +
>>   x86/pks.c           | 146 ++++++++++++++++++++++++++++++++++++++++++++
>>   x86/unittests.cfg   |   5 ++
>>   5 files changed, 155 insertions(+)
>>   create mode 100644 x86/pks.c
>>
>> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
>> index 6ef5502..e36934b 100644
>> --- a/lib/x86/msr.h
>> +++ b/lib/x86/msr.h
>> @@ -209,6 +209,7 @@
>>   #define MSR_IA32_EBL_CR_POWERON        0x0000002a
>>   #define MSR_IA32_FEATURE_CONTROL        0x0000003a
>>   #define MSR_IA32_TSC_ADJUST        0x0000003b
>> +#define MSR_IA32_PKRS            0x000006e1
>>   #define FEATURE_CONTROL_LOCKED                (1<<0)
>>   #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX    (1<<1)
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 74a2498..985fdd0 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -50,6 +50,7 @@
>>   #define X86_CR4_SMEP   0x00100000
>>   #define X86_CR4_SMAP   0x00200000
>>   #define X86_CR4_PKE    0x00400000
>> +#define X86_CR4_PKS    0x01000000
>>   #define X86_EFLAGS_CF    0x00000001
>>   #define X86_EFLAGS_FIXED 0x00000002
>> @@ -157,6 +158,7 @@ static inline u8 cpuid_maxphyaddr(void)
>>   #define    X86_FEATURE_RDPID        (CPUID(0x7, 0, ECX, 22))
>>   #define    X86_FEATURE_SPEC_CTRL        (CPUID(0x7, 0, EDX, 26))
>>   #define    X86_FEATURE_ARCH_CAPABILITIES    (CPUID(0x7, 0, EDX, 29))
>> +#define    X86_FEATURE_PKS            (CPUID(0x7, 0, ECX, 31))
>>   #define    X86_FEATURE_NX            (CPUID(0x80000001, 0, EDX, 20))
>>   #define    X86_FEATURE_RDPRU        (CPUID(0x80000008, 0, EBX, 4))
>> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
>> index af61d85..3a353df 100644
>> --- a/x86/Makefile.x86_64
>> +++ b/x86/Makefile.x86_64
>> @@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
>>   tests += $(TEST_DIR)/intel-iommu.flat
>>   tests += $(TEST_DIR)/vmware_backdoors.flat
>>   tests += $(TEST_DIR)/rdpru.flat
>> +tests += $(TEST_DIR)/pks.flat
>>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>> diff --git a/x86/pks.c b/x86/pks.c
>> new file mode 100644
>> index 0000000..a3044cf
>> --- /dev/null
>> +++ b/x86/pks.c
>> @@ -0,0 +1,146 @@
>> +#include "libcflat.h"
>> +#include "x86/desc.h"
>> +#include "x86/processor.h"
>> +#include "x86/vm.h"
>> +#include "x86/msr.h"
>> +
>> +#define CR0_WP_MASK      (1UL << 16)
>> +#define PTE_PKEY_BIT     59
>> +#define SUPER_BASE        (1 << 24)
>> +#define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) 
>> + SUPER_BASE)))
>> +
>> +volatile int pf_count = 0;
>> +volatile unsigned save;
>> +volatile unsigned test;
>> +
>> +static void set_cr0_wp(int wp)
>> +{
>> +    unsigned long cr0 = read_cr0();
>> +
>> +    cr0 &= ~CR0_WP_MASK;
>> +    if (wp)
>> +        cr0 |= CR0_WP_MASK;
>> +    write_cr0(cr0);
>> +}
>> +
>> +void do_pf_tss(unsigned long error_code);
>> +void do_pf_tss(unsigned long error_code)
>> +{
>> +    printf("#PF handler, error code: 0x%lx\n", error_code);
>> +    pf_count++;
>> +    save = test;
>> +    wrmsr(MSR_IA32_PKRS, 0);
>> +}
>> +
>> +extern void pf_tss(void);
>> +
>> +asm ("pf_tss: \n\t"
>> +#ifdef __x86_64__
>> +    // no task on x86_64, save/restore caller-save regs
>> +    "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
>> +    "push %r8; push %r9; push %r10; push %r11\n"
>> +    "mov 9*8(%rsp), %rdi\n"
>> +#endif
>> +    "call do_pf_tss \n\t"
>> +#ifdef __x86_64__
>> +    "pop %r11; pop %r10; pop %r9; pop %r8\n"
>> +    "pop %rdi; pop %rsi; pop %rdx; pop %rcx; pop %rax\n"
>> +#endif
>> +    "add $"S", %"R "sp\n\t" // discard error code
>> +    "iret"W" \n\t"
>> +    "jmp pf_tss\n\t"
>> +    );
>> +
>> +static void init_test(void)
>> +{
>> +    pf_count = 0;
>> +
>> +    invlpg(&test);
>> +    invlpg(&SUPER_VAR(test));
>> +    wrmsr(MSR_IA32_PKRS, 0);
>> +    set_cr0_wp(0);
>> +}
>> +
>> +int main(int ac, char **av)
>> +{
>> +    unsigned long i;
>> +    unsigned int pkey = 0x2;
>> +    unsigned int pkrs_ad = 0x10;
>> +    unsigned int pkrs_wd = 0x20;
>> +
>> +    if (!this_cpu_has(X86_FEATURE_PKS)) {
>> +        printf("PKS not enabled\n");
>> +        return report_summary();
>> +    }
>> +
>> +    setup_vm();
>> +    setup_alt_stack();
>> +    set_intr_alt_stack(14, pf_tss);
>> +    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
>> +
>> +    // First 16MB are user pages
>> +    for (i = 0; i < SUPER_BASE; i += PAGE_SIZE) {
>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= 
>> ((unsigned long)pkey << PTE_PKEY_BIT);
>> +        invlpg((void *)i);
>> +    }
>> +
>> +    // Present the same 16MB as supervisor pages in the 16MB-32MB range
>> +    for (i = SUPER_BASE; i < 2 * SUPER_BASE; i += PAGE_SIZE) {
>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= 
>> ~SUPER_BASE;
>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= 
>> ~PT_USER_MASK;
>> +        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= 
>> ((unsigned long)pkey << PTE_PKEY_BIT);
>> +        invlpg((void *)i);
>> +    }
>> +
>> +    write_cr4(read_cr4() | X86_CR4_PKS);
>> +    write_cr3(read_cr3());
>> +
>> +    init_test();
>> +    set_cr0_wp(1);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>> +    SUPER_VAR(test) = 21;
>> +    report(pf_count == 1 && test == 21 && save == 0,
>> +           "write to supervisor page when pkrs is ad and wp == 1");
>> +
>> +    init_test();
>> +    set_cr0_wp(0);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>> +    SUPER_VAR(test) = 22;
>> +    report(pf_count == 1 && test == 22 && save == 21,
>> +           "write to supervisor page when pkrs is ad and wp == 0");
>> +
>> +    init_test();
>> +    set_cr0_wp(1);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>> +    SUPER_VAR(test) = 23;
>> +    report(pf_count == 1 && test == 23 && save == 22,
>> +           "write to supervisor page when pkrs is wd and wp == 1");
>> +
>> +    init_test();
>> +    set_cr0_wp(0);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>> +    SUPER_VAR(test) = 24;
>> +    report(pf_count == 0 && test == 24,
>> +           "write to supervisor page when pkrs is wd and wp == 0");
>> +
>> +    init_test();
>> +    set_cr0_wp(0);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>> +    test = 25;
>> +    report(pf_count == 0 && test == 25,
>> +           "write to user page when pkrs is wd and wp == 0");
>> +
>> +    init_test();
>> +    set_cr0_wp(1);
>> +    wrmsr(MSR_IA32_PKRS, pkrs_wd);
>> +    test = 26;
>> +    report(pf_count == 0 && test == 26,
>> +           "write to user page when pkrs is wd and wp == 1");
>> +
>> +    init_test();
>> +    wrmsr(MSR_IA32_PKRS, pkrs_ad);
>> +    (void)((__typeof__(&(test))) (((unsigned long)&test)));
>> +    report(pf_count == 0, "read from user page when pkrs is ad");
>> +
>> +    return report_summary();
>> +}
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index 3a79151..b75419e 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -127,6 +127,11 @@ file = pku.flat
>>   arch = x86_64
>>   extra_params = -cpu host
>> +[pks]
>> +file = pks.flat
>> +arch = x86_64
>> +extra_params = -cpu host
>> +
>>   [asyncpf]
>>   file = asyncpf.flat
>>   extra_params = -m 2048
>>
> 
> Ping? ... Paolo, I think this one fell through the cracks?
> 
>   Thomas
> 

No, it's just that the KVM patches haven't been merged yet (and there's 
no QEMU implementation yet).  But I'm getting to it.

Paolo

