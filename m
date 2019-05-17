Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B68217E3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 13:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEQLth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 07:49:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46210 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfEQLth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 07:49:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id t187so3187157pgb.13
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 04:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qjpZSW9P86hUhxCXQpbZYJLTAJv9t1jQ7A46fddIkiA=;
        b=c37tIkL5L7g63ADe0AWuEu0kp57Gj2pkRm566pgvGASQEvsa2Bl+zojm/fcbBd4GBc
         p1Hn0ed1MDLl3wSko9So/VkRmZFrB0NwBim6Fi56xodpH9FX9QgpEg7zLjzY4i1fTp1t
         NV8LeVy5oBWqXbgXQn5vuUWL5a12fFc8p2rxRavFkSfCDei9hu04PbsPwCnC99i7Z5V5
         o2Hjq0wkKo8MDetlQXbqDi+wIaj3QqG27IMjaL4A8Lw480dRwHoD/uMnvu761N9t/X8Y
         Hwvk8xU3ro3qXDyRjQaDEx6y6d4+Bo2QD71XAgKA0R/4cac/K1hx3twboFqv7PKWyVzI
         0Eew==
X-Gm-Message-State: APjAAAUfaCvh9rHod0u+EpmbZh1E+D0OhXn/Uk1K6C/18HQOWQyfD+ah
        EUoBUerv8IkJT+jmOP+KkUEmH3LWAr8=
X-Google-Smtp-Source: APXvYqy3OmP/a8Gvw7GrWFbJxOIprB9wNBP4LNhgib6Y9emzTZAqgh4TdJZx/l+wp5UNgszQx6m5PQ==
X-Received: by 2002:a63:4f16:: with SMTP id d22mr13102896pgb.148.1558093775894;
        Fri, 17 May 2019 04:49:35 -0700 (PDT)
Received: from [172.27.174.155] (23-24-245-129-static.hfc.comcastbusiness.net. [23.24.245.129])
        by smtp.gmail.com with ESMTPSA id l7sm4565036pfl.9.2019.05.17.04.49.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 04:49:35 -0700 (PDT)
Subject: Re: [GIT PULL] KVM changes for 5.2 merge window
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, kvm@vger.kernel.org
References: <1558065576-21115-1-git-send-email-pbonzini@redhat.com>
 <20190517062214.GA127599@archlinux-epyc>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8170dab-7c7d-de3d-9461-9eecb73026ff@redhat.com>
Date:   Fri, 17 May 2019 13:49:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517062214.GA127599@archlinux-epyc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 08:22, Nathan Chancellor wrote:
> On Fri, May 17, 2019 at 05:59:36AM +0200, Paolo Bonzini wrote:
>> Linus,
>>
>> The following changes since commit 7a223e06b1a411cef6c4cd7a9b9a33c8d225b10e:
>>
>>   KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing (2019-04-16 15:38:08 +0200)
>>
>> are available in the git repository at:
>>
>>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>>
>> for you to fetch changes up to dd53f6102c30a774e0db8e55d49017a38060f6f6:
>>
>>   Merge tag 'kvmarm-for-v5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-05-15 23:41:43 +0200)
>>
>> ----------------------------------------------------------------
>>
>> * ARM: support for SVE and Pointer Authentication in guests, PMU improvements
>>
>> * POWER: support for direct access to the POWER9 XIVE interrupt controller,
>> memory and performance optimizations.
>>
>> * x86: support for accessing memory not backed by struct page, fixes and refactoring
>>
>> * Generic: dirty page tracking improvements
>>
>> ----------------------------------------------------------------
>> Aaron Lewis (5):
>>       tests: kvm: Add tests to .gitignore
>>       tests: kvm: Add tests for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_CPU_ID
>>       KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS state before setting new state
>>       tests: kvm: Add tests for KVM_SET_NESTED_STATE
>>       kvm: nVMX: Set nested_run_pending in vmx_set_nested_state after checks complete
>>
>> Alexey Kardashevskiy (3):
>>       KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest
>>       KVM: PPC: Book3S HV: Avoid lockdep debugging in TCE realmode handlers
>>       KVM: PPC: Book3S: Allocate guest TCEs on demand too
>>
>> Amit Daniel Kachhap (3):
>>       KVM: arm64: Add a vcpu flag to control ptrauth for guest
>>       KVM: arm64: Add userspace flag to enable pointer authentication
>>       KVM: arm64: Add capability to advertise ptrauth for guest
>>
>> Andrew Murray (9):
>>       arm64: arm_pmu: Remove unnecessary isb instruction
>>       arm64: KVM: Encapsulate kvm_cpu_context in kvm_host_data
>>       arm64: KVM: Add accessors to track guest/host only counters
>>       arm64: arm_pmu: Add !VHE support for exclude_host/exclude_guest attributes
>>       arm64: KVM: Enable !VHE support for :G/:H perf event modifiers
>>       arm64: KVM: Enable VHE support for :G/:H perf event modifiers
>>       arm64: KVM: Avoid isb's by using direct pmxevtyper sysreg
>>       arm64: docs: Document perf event attributes
>>       arm64: KVM: Fix perf cycle counter support for VHE
>>
>> Borislav Petkov (1):
>>       x86/kvm: Implement HWCR support
>>
>> Christian Borntraeger (9):
>>       KVM: s390: add vector enhancements facility 2 to cpumodel
>>       KVM: s390: add vector BCD enhancements facility to cpumodel
>>       KVM: s390: add MSA9 to cpumodel
>>       KVM: s390: provide query function for instructions returning 32 byte
>>       KVM: s390: add enhanced sort facilty to cpu model
>>       KVM: s390: add deflate conversion facilty to cpu model
>>       KVM: s390: enable MSA9 keywrapping functions depending on cpu model
>>       KVM: polling: add architecture backend to disable polling
>>       KVM: s390: provide kvm_arch_no_poll function
>>
>> Colin Ian King (1):
>>       KVM: PPC: Book3S HV: XIVE: Fix spelling mistake "acessing" -> "accessing"
>>
>> Cédric Le Goater (18):
>>       powerpc/xive: add OPAL extensions for the XIVE native exploitation support
>>       KVM: PPC: Book3S HV: Add a new KVM device for the XIVE native exploitation mode
>>       KVM: PPC: Book3S HV: XIVE: Introduce a new capability KVM_CAP_PPC_IRQ_XIVE
>>       KVM: PPC: Book3S HV: XIVE: add a control to initialize a source
>>       KVM: PPC: Book3S HV: XIVE: Add a control to configure a source
>>       KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration
>>       KVM: PPC: Book3S HV: XIVE: Add a global reset control
>>       KVM: PPC: Book3S HV: XIVE: Add a control to sync the sources
>>       KVM: PPC: Book3S HV: XIVE: Add a control to dirty the XIVE EQ pages
>>       KVM: PPC: Book3S HV: XIVE: Add get/set accessors for the VP XIVE state
>>       KVM: Introduce a 'mmap' method for KVM devices
>>       KVM: PPC: Book3S HV: XIVE: Add a TIMA mapping
>>       KVM: PPC: Book3S HV: XIVE: Add a mapping for the source ESB pages
>>       KVM: PPC: Book3S HV: XIVE: Add passthrough support
>>       KVM: PPC: Book3S HV: XIVE: Activate XIVE exploitation mode
>>       KVM: Introduce a 'release' method for KVM devices
>>       KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method
>>       KVM: PPC: Book3S: Remove useless checks in 'release' method of KVM device
>>
>> Dan Carpenter (1):
>>       KVM: vmx: clean up some debug output
>>
>> Dave Martin (41):
>>       KVM: Documentation: Document arm64 core registers in detail
>>       arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
>>       KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
>>       KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
>>       KVM: arm64: Add missing #includes to kvm_host.h
>>       arm64/sve: Clarify role of the VQ map maintenance functions
>>       arm64/sve: Check SVE virtualisability
>>       arm64/sve: Enable SVE state tracking for non-task contexts
>>       KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
>>       KVM: arm64: Propagate vcpu into read_id_reg()
>>       KVM: arm64: Support runtime sysreg visibility filtering
>>       KVM: arm64/sve: System register context switch and access support
>>       KVM: arm64/sve: Context switch the SVE registers
>>       KVM: Allow 2048-bit register access via ioctl interface
>>       KVM: arm64: Add missing #include of <linux/string.h> in guest.c
>>       KVM: arm64: Factor out core register ID enumeration
>>       KVM: arm64: Reject ioctl access to FPSIMD V-regs on SVE vcpus
>>       KVM: arm64/sve: Add SVE support to register access ioctl interface
>>       KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
>>       arm64/sve: In-kernel vector length availability query interface
>>       KVM: arm/arm64: Add hook for arch-specific KVM initialisation
>>       KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
>>       KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
>>       KVM: arm64/sve: Allow userspace to enable SVE for vcpus
>>       KVM: arm64: Add a capability to advertise SVE support
>>       KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
>>       KVM: arm64/sve: Document KVM API extensions for SVE
>>       arm64/sve: Clarify vq map semantics
>>       KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up SVE
>>       KVM: arm: Make vcpu finalization stubs into inline functions
>>       KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to WARNs
>>       KVM: arm64/sve: Clean up UAPI register ID definitions
>>       KVM: arm64/sve: Miscellaneous tidyups in guest.c
>>       KVM: arm64/sve: Make register ioctl access errors more consistent
>>       KVM: arm64/sve: WARN when avoiding divide-by-zero in sve_reg_to_region()
>>       KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
>>       KVM: arm64/sve: Explain validity checks in set_sve_vls()
>>       KVM: arm/arm64: Clean up vcpu finalization function parameter naming
>>       KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
>>       KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
>>       KVM: arm64: Clarify access behaviour for out-of-range SVE register slice IDs
>>
>> Eric Farman (1):
>>       KVM: s390: Fix potential spectre warnings
>>
>> Filippo Sironi (1):
>>       X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs
>>
>> Jiang Biao (1):
>>       kvm_main: fix some comments
>>
>> Kai Huang (1):
>>       kvm: x86: Fix L1TF mitigation for shadow MMU
>>
>> KarimAllah Ahmed (13):
>>       X86/nVMX: handle_vmon: Read 4 bytes from guest memory
>>       X86/nVMX: Update the PML table without mapping and unmapping the page
>>       KVM: Introduce a new guest mapping API
> 
> This commit causes a build failure on arm64 defconfig:
> 
> $ make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=out defconfig Image.gz
> ...
>     ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_map_gfn':
> ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:9: error: implicit declaration of function 'memremap'; did you mean 'memset_p'? [-Werror=implicit-function-declaration]
>    hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>          ^~~~~~~~
>          memset_p
>   CC      kernel/cgroup/rstat.o
> ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:46: error: 'MEMREMAP_WB' undeclared (first use in this function)
>    hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>                                               ^~~~~~~~~~~
> ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:46: note: each undeclared identifier is reported only once for each function it appears in
> ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vcpu_unmap':
> ../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1795:3: error: implicit declaration of function 'memunmap'; did you mean 'vm_munmap'? [-Werror=implicit-function-declaration]
>    memunmap(map->hva);
>    ^~~~~~~~
>    vm_munmap
> 
> It seems that the <asm/io.h> include should probably be converted into
> <linux/io.h>.

Ouch, thanks. :/  I'll send a new pull request as soon as I finish
testing the change you suggested.

Paolo

