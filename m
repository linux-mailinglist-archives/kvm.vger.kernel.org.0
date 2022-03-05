Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99F04CE275
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 04:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiCEDkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 22:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCEDkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 22:40:06 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBFF2287E2;
        Fri,  4 Mar 2022 19:39:16 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 195so9072377pgc.6;
        Fri, 04 Mar 2022 19:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aj7PS2hXPyaa9puVitet5Icmmj5tsznj4dT1jIvn+qM=;
        b=nWHDa6pgjZb9b6IN90MrXP4ZE0YjsJ3ldMM+N0Z+O88pvnupOqSZKNCDmDu3D5TI+C
         BFnimuoByzt8t6jcy54e9JtnkNQNWT0vOwnsyvr0LsonXJsuPMOQ3697FW0kVR7sKmFc
         KRQC53R/toR1SnHKocF9xt6Ik8HZoHPldISR/i/pGvY8jKY8q0pGIbWLeglZyySddgul
         PLiZX/08ilTrhCYAoPJlK86/ursJakRymROwDV5OwIOlguFIVuHLheE3YEn1x1evTESm
         ho/EfM3umIX8XSsaWXR2p2YvVFYp4gq+JQLe+YQJ+l66Mz/KpcYGAoluNAX5shxuQi4B
         wx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aj7PS2hXPyaa9puVitet5Icmmj5tsznj4dT1jIvn+qM=;
        b=HgXNa06j8BNpxD/Qj9AcFLciAKJGuL5WrM1NHzdTNLBH9/ks17CuirLaOjFNDPvUfu
         PSq5LpM0tqfhlLRef+WLDhiPMP0PNs+cKHl+e+ZU3fHaP016sdRHHXtWM/ZMiREz3Zg4
         5CntClz5qKCAFJP0+vifoNGfsdTgGIP1n1XNGwpILsJb9MrFSukjqTzE2pnnjv86Z3ws
         LG1GMAYOHAwi2O3FgAPV2FO6xsxwLNBPk2Eg+02mMGu0JsRAMQYb5YR6HkgI3v/WWCik
         8LiJcrVUKhEboOt77ulDNrCvV/tHNuJ705xs4U32xNrg/CxsSXqamVhHQBhVsVM6TSEu
         eFhg==
X-Gm-Message-State: AOAM532FF335JOHH6oJuiXWe3k46K/uuLZ5ATtmq8QwdmazeYkDLVm2j
        tVCZZ+Cdj7oVW3+bIf5SVGE=
X-Google-Smtp-Source: ABdhPJy93aws6w0QRnyfv6a10CaYKtx2W1IDeHH5sAUMqoMJZHTmHTVCGwPh060dFfcJGWy+NLw7Ag==
X-Received: by 2002:a65:6251:0:b0:374:6621:9fe8 with SMTP id q17-20020a656251000000b0037466219fe8mr1330188pgv.254.1646451555521;
        Fri, 04 Mar 2022 19:39:15 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id p25-20020a637419000000b0037fa57520adsm1540282pgc.27.2022.03.04.19.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 19:39:15 -0800 (PST)
Date:   Sat, 5 Mar 2022 03:39:08 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        roman.gushchin@linux.dev
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Message-ID: <YiLbXMQTAXTf0Mrd@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220223052223.1202152-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 09:21:36PM -0800, Junaid Shahid wrote:
> This patch series is a proof-of-concept RFC for an end-to-end implementation of 
> Address Space Isolation for KVM. It has similar goals and a somewhat similar 
> high-level design as the original ASI patches from Alexandre Chartre 
> ([1],[2],[3],[4]), but with a different underlying implementation. This also 
> includes several memory management changes to help with differentiating between 
> sensitive and non-sensitive memory and mapping of non-sensitive memory into the 
> ASI restricted address spaces. 
> 
> This RFC is intended as a demonstration of what a full ASI implementation for 
> KVM could look like, not necessarily as a direct proposal for what might 
> eventually be merged. In particular, these patches do not yet implement KPTI on 
> top of ASI, although the framework is generic enough to be able to support it. 
> Similarly, these patches do not include non-sensitive annotations for data 
> structures that did not get frequently accessed during execution of our test 
> workloads, but the framework is designed such that new non-sensitive memory 
> annotations can be added trivially.
> 
> The patches apply on top of Linux v5.16. These patches are also available via 
> gerrit at https://linux-review.googlesource.com/q/topic:asi-rfc.

[+Cc slab maintainers/reviewers]

Please Cc relevant people.
patch 14, 24, 31 need to be reviewed by slab people :)

> Background
> ==========
> Address Space Isolation is a comprehensive security mitigation for several types 
> of speculative execution attacks. Even though the kernel already has several 
> speculative execution vulnerability mitigations, some of them can be quite 
> expensive if enabled fully e.g. to fully mitigate L1TF using the existing 
> mechanisms requires doing an L1 cache flush on every single VM entry as well as 
> disabling hyperthreading altogether. (Although core scheduling can provide some 
> protection when hyperthreading is enabled, it is not sufficient by itself to 
> protect against all leaks unless sibling hyperthread stunning is also performed 
> on every VM exit.) ASI provides a much less expensive mitigation for such 
> vulnerabilities while still providing an almost similar level of protection.
> 
> There are a couple of basic insights/assumptions behind ASI:
> 
> 1. Most execution paths in the kernel (especially during virtual machine 
> execution) access only memory that is not particularly sensitive even if it were 
> to get leaked to the executing process/VM (setting aside for a moment what 
> exactly should be considered sensitive or non-sensitive).
> 2. Even when executing speculatively, the CPU can generally only bring memory 
> that is mapped in the current page tables into its various caches and internal 
> buffers.
> 
> Given these, the idea of using ASI to thwart speculative attacks is that we can 
> execute the kernel using a restricted set of page tables most of the time and 
> switch to the full unrestricted kernel address space only when the kernel needs 
> to access something that is not mapped in the restricted address space. And we 
> keep track of when a switch to the full kernel address space is done, so that 
> before returning back to the process/VM, we can switch back to the restricted 
> address space. In the paths where the kernel is able to execute entirely while 
> remaining in the restricted address space, we can skip other mitigations for 
> speculative execution attacks (such as L1 cache / micro-arch buffer flushes, 
> sibling hyperthread stunning etc.). Only in the cases where we do end up 
> switching the page tables, we perform these more expensive mitigations. Assuming 
> that happens relatively infrequently, the performance can be significantly 
> better compared to performing these mitigations all the time.
> 
> Please note that although we do have a sibling hyperthread stunning 
> implementation internally, which is fully integrated with KVM-ASI, it is not 
> included in this RFC for the time being. The earlier upstream proposal for 
> sibling stunning [6] could potentially be integrated into an upstream ASI 
> implementation.
> 
> Basic concepts
> ==============
> Different types of restricted address spaces are represented by different ASI 
> classes. For instance, KVM-ASI is an ASI class used during VM execution. KPTI 
> would be another ASI class. An ASI instance (struct asi) represents a single 
> restricted address space. There is a separate ASI instance for each untrusted 
> context (e.g. a userspace process, a VM, or even a single VCPU etc.) Note that 
> there can be multiple untrusted security contexts (and thus multiple restricted 
> address spaces) within a single process e.g. in the case of VMs, the userspace 
> process is a different security context than the guest VM, and in principle, 
> even each VCPU could be considered a separate security context (That would be 
> primarily useful for securing nested virtualization).
> 
> In this RFC, a process can have at most one ASI instance of each class, though 
> this is not an inherent limitation and multiple instances of the same class 
> should eventually be supported. (A process can still have ASI instances of 
> different classes e.g. KVM-ASI and KPTI.) In fact, in principle, it is not even 
> entirely necessary to tie an ASI instance to a process. That is just a 
> simplification for the initial implementation.
> 
> An asi_enter operation switches into the restricted address space represented by 
> the given ASI instance. An asi_exit operation switches to the full unrestricted 
> kernel address space. Each ASI class can provide hooks to be executed during 
> these operations, which can be used to perform speculative attack mitigations 
> relevant to that class. For instance, the KVM-ASI hooks would perform a 
> sibling-hyperthread-stun operation in the asi_exit hook, and L1-flush/MDS-clear 
> and sibling-hyperthread-unstun operations in the asi_enter hook. On the other 
> hand, the hooks for the KPTI class would be NO-OP, since the switching of the 
> page tables is enough mitigation in that case.
> 
> If the kernel attempts to access memory that is not mapped in the currently 
> active ASI instance, the page fault handler automatically performs an asi_exit 
> operation. This means that except for a few critical pieces of memory, leaving 
> something out of an unrestricted address space will result in only a performance 
> hit, rather than a catastrophic failure. The kernel can also perform explicit 
> asi_exit operations in some paths as needed.
> 
> Apart from the page fault handler, other exceptions and interrupts (even NMIs) 
> do not automatically cause an asi_exit and could potentially be executed 
> completely within a restricted address space if they don't end up accessing any 
> sensitive piece of memory.
> 
> The mappings within a restricted address space are always a subset of the full 
> kernel address space and each mapping is always the same as the corresponding 
> mapping in the full kernel address space. This is necessary because we could 
> potentially end up performing an asi_exit at any point.
> 
> Although this RFC only includes an implementation of the KVM-ASI class, a KPTI 
> class could also be implemented on top of the same infrastructure. Furthermore, 
> in the future we could also implement a KPTI-Next class that actually uses the 
> ASI model for userspace processes i.e. mapping non-sensitive kernel memory in 
> the restricted address space and trying to execute most syscalls/interrupts 
> without switching to the full kernel address space, as opposed to the current 
> KPTI which requires an address space switch on every kernel/user mode 
> transition.
> 
> Memory classification
> =====================
> We divide memory into three categories.
> 
> 1. Sensitive memory
> This is memory that should never get leaked to any process or VM. Sensitive 
> memory is only mapped in the unrestricted kernel page tables. By default, all 
> memory is considered sensitive unless specifically categorized otherwise.
> 
> 2. Globally non-sensitive memory
> This is memory that does not present a substantial security threat even if it 
> were to get leaked to any process or VM in the system. Globally non-sensitive 
> memory is mapped in the restricted address spaces for all processes.
> 
> 3. Locally non-sensitive memory
> This is memory that does not present a substantial security threat if it were to 
> get leaked to the currently running process or VM, but would present a security 
> issue if it were to get leaked to any other process or VM in the system. 
> Examples include userspace memory (or guest memory in the case of VMs) or kernel 
> structures containing userspace/guest register context etc. Locally 
> non-sensitive memory is mapped only in the restricted address space of a single 
> process.
> 
> Various mechanisms are provided to annotate different types of memory (static, 
> buddy allocator, slab, vmalloc etc.) as globally or locally non-sensitive. In 
> addition, the ASI infrastructure takes care to ensure that different classes of 
> memory do not share the same physical page. This includes separation of 
> sensitive, globally non-sensitive and locally non-sensitive memory into 
> different pages and also separation of locally non-sensitive memory for 
> different processes into different pages as well.
> 
> What exactly should be considered non-sensitive (either globally or locally) is 
> somewhat open-ended. Some things are clearly sensitive or non-sensitive, but 
> many things also fall into a gray area, depending on how paranoid one wants to 
> be. For this proof of concept, we have generally treated such things as 
> non-sensitive, though that may not necessarily be the ideal classification in 
> each case. Similarly, there is also a gray area between globally and locally 
> non-sensitive classifications in some cases, and in those cases this RFC has 
> mostly erred on the side of marking them as locally non-sensitive, even though 
> many of those cases could likely be safely classified as globally non-sensitive.
> 
> Although this implementation includes fairly extensive support for marking most 
> types of dynamically allocated memory as locally non-sensitive, it is possibly 
> feasible, at least for KVM-ASI, to get away with a simpler implementation (such 
> as [5]), if we are very selective about what memory we treat as locally 
> non-sensitive (as opposed to globally non-sensitive). Nevertheless, the more 
> general mechanism is included in this proof of concept as an illustration for 
> what could be done if we really needed to treat any arbitrary kernel memory as 
> locally non-sensitive.
> 
> It is also possible to have ASI classes that do not utilize the above described 
> infrastructure and instead manage all the memory mappings inside the restricted 
> address space on their own.
> 
> 
> References
> ==========
> [1] https://lore.kernel.org/lkml/1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com
> [2] https://lore.kernel.org/lkml/1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com
> [3] https://lore.kernel.org/lkml/1582734120-26757-1-git-send-email-alexandre.chartre@oracle.com
> [4] https://lore.kernel.org/lkml/20200504144939.11318-1-alexandre.chartre@oracle.com
> [5] https://lore.kernel.org/lkml/20190612170834.14855-1-mhillenb@amazon.de
> [6] https://lore.kernel.org/lkml/20200815031908.1015049-1-joel@joelfernandes.org
> 
> Cc: Paul Turner <pjt@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Alexandre Chartre <alexandre.chartre@oracle.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andy Lutomirski <luto@kernel.org>
> 
> 
> Junaid Shahid (32):
>   mm: asi: Introduce ASI core API
>   mm: asi: Add command-line parameter to enable/disable ASI
>   mm: asi: Switch to unrestricted address space when entering scheduler
>   mm: asi: ASI support in interrupts/exceptions
>   mm: asi: Make __get_current_cr3_fast() ASI-aware
>   mm: asi: ASI page table allocation and free functions
>   mm: asi: Functions to map/unmap a memory range into ASI page tables
>   mm: asi: Add basic infrastructure for global non-sensitive mappings
>   mm: Add __PAGEFLAG_FALSE
>   mm: asi: Support for global non-sensitive direct map allocations
>   mm: asi: Global non-sensitive vmalloc/vmap support
>   mm: asi: Support for global non-sensitive slab caches
>   mm: asi: Disable ASI API when ASI is not enabled for a process
>   kvm: asi: Restricted address space for VM execution
>   mm: asi: Support for mapping non-sensitive pcpu chunks
>   mm: asi: Aliased direct map for local non-sensitive allocations
>   mm: asi: Support for pre-ASI-init local non-sensitive allocations
>   mm: asi: Support for locally nonsensitive page allocations
>   mm: asi: Support for locally non-sensitive vmalloc allocations
>   mm: asi: Add support for locally non-sensitive VM_USERMAP pages
>   mm: asi: Add support for mapping all userspace memory into ASI
>   mm: asi: Support for local non-sensitive slab caches
>   mm: asi: Avoid warning from NMI userspace accesses in ASI context
>   mm: asi: Use separate PCIDs for restricted address spaces
>   mm: asi: Avoid TLB flushes during ASI CR3 switches when possible
>   mm: asi: Avoid TLB flush IPIs to CPUs not in ASI context
>   mm: asi: Reduce TLB flushes when freeing pages asynchronously
>   mm: asi: Add API for mapping userspace address ranges
>   mm: asi: Support for non-sensitive SLUB caches
>   x86: asi: Allocate FPU state separately when ASI is enabled.
>   kvm: asi: Map guest memory into restricted ASI address space
>   kvm: asi: Unmap guest memory from ASI address space when using nested
>     virt
> 
> Ofir Weisse (15):
>   asi: Added ASI memory cgroup flag
>   mm: asi: Added refcounting when initilizing an asi
>   mm: asi: asi_exit() on PF, skip handling if address is accessible
>   mm: asi: Adding support for dynamic percpu ASI allocations
>   mm: asi: ASI annotation support for static variables.
>   mm: asi: ASI annotation support for dynamic modules.
>   mm: asi: Skip conventional L1TF/MDS mitigations
>   mm: asi: support for static percpu DEFINE_PER_CPU*_ASI
>   mm: asi: Annotation of static variables to be nonsensitive
>   mm: asi: Annotation of PERCPU variables to be nonsensitive
>   mm: asi: Annotation of dynamic variables to be nonsensitive
>   kvm: asi: Splitting kvm_vcpu_arch into non/sensitive parts
>   mm: asi: Mapping global nonsensitive areas in asi_global_init
>   kvm: asi: Do asi_exit() in vcpu_run loop before returning to userspace
>   mm: asi: Properly un/mapping task stack from ASI + tlb flush
> 
>  arch/alpha/include/asm/Kbuild            |    1 +
>  arch/arc/include/asm/Kbuild              |    1 +
>  arch/arm/include/asm/Kbuild              |    1 +
>  arch/arm64/include/asm/Kbuild            |    1 +
>  arch/csky/include/asm/Kbuild             |    1 +
>  arch/h8300/include/asm/Kbuild            |    1 +
>  arch/hexagon/include/asm/Kbuild          |    1 +
>  arch/ia64/include/asm/Kbuild             |    1 +
>  arch/m68k/include/asm/Kbuild             |    1 +
>  arch/microblaze/include/asm/Kbuild       |    1 +
>  arch/mips/include/asm/Kbuild             |    1 +
>  arch/nds32/include/asm/Kbuild            |    1 +
>  arch/nios2/include/asm/Kbuild            |    1 +
>  arch/openrisc/include/asm/Kbuild         |    1 +
>  arch/parisc/include/asm/Kbuild           |    1 +
>  arch/powerpc/include/asm/Kbuild          |    1 +
>  arch/riscv/include/asm/Kbuild            |    1 +
>  arch/s390/include/asm/Kbuild             |    1 +
>  arch/sh/include/asm/Kbuild               |    1 +
>  arch/sparc/include/asm/Kbuild            |    1 +
>  arch/um/include/asm/Kbuild               |    1 +
>  arch/x86/events/core.c                   |    6 +-
>  arch/x86/events/intel/bts.c              |    2 +-
>  arch/x86/events/intel/core.c             |    2 +-
>  arch/x86/events/msr.c                    |    2 +-
>  arch/x86/events/perf_event.h             |    4 +-
>  arch/x86/include/asm/asi.h               |  215 ++++
>  arch/x86/include/asm/cpufeatures.h       |    1 +
>  arch/x86/include/asm/current.h           |    2 +-
>  arch/x86/include/asm/debugreg.h          |    2 +-
>  arch/x86/include/asm/desc.h              |    2 +-
>  arch/x86/include/asm/disabled-features.h |    8 +-
>  arch/x86/include/asm/fpu/api.h           |    3 +-
>  arch/x86/include/asm/hardirq.h           |    2 +-
>  arch/x86/include/asm/hw_irq.h            |    2 +-
>  arch/x86/include/asm/idtentry.h          |   25 +-
>  arch/x86/include/asm/kvm_host.h          |  124 +-
>  arch/x86/include/asm/page.h              |   19 +-
>  arch/x86/include/asm/page_64.h           |   27 +-
>  arch/x86/include/asm/page_64_types.h     |   20 +
>  arch/x86/include/asm/percpu.h            |    2 +-
>  arch/x86/include/asm/pgtable_64_types.h  |   10 +
>  arch/x86/include/asm/preempt.h           |    2 +-
>  arch/x86/include/asm/processor.h         |   17 +-
>  arch/x86/include/asm/smp.h               |    2 +-
>  arch/x86/include/asm/tlbflush.h          |   49 +-
>  arch/x86/include/asm/topology.h          |    2 +-
>  arch/x86/kernel/alternative.c            |    2 +-
>  arch/x86/kernel/apic/apic.c              |    2 +-
>  arch/x86/kernel/apic/x2apic_cluster.c    |    8 +-
>  arch/x86/kernel/cpu/bugs.c               |    2 +-
>  arch/x86/kernel/cpu/common.c             |   12 +-
>  arch/x86/kernel/e820.c                   |    7 +-
>  arch/x86/kernel/fpu/core.c               |   47 +-
>  arch/x86/kernel/fpu/init.c               |    7 +-
>  arch/x86/kernel/fpu/internal.h           |    1 +
>  arch/x86/kernel/fpu/xstate.c             |   21 +-
>  arch/x86/kernel/head_64.S                |   12 +
>  arch/x86/kernel/hw_breakpoint.c          |    2 +-
>  arch/x86/kernel/irq.c                    |    2 +-
>  arch/x86/kernel/irqinit.c                |    2 +-
>  arch/x86/kernel/nmi.c                    |    6 +-
>  arch/x86/kernel/process.c                |   13 +-
>  arch/x86/kernel/setup.c                  |    4 +-
>  arch/x86/kernel/setup_percpu.c           |    4 +-
>  arch/x86/kernel/smp.c                    |    2 +-
>  arch/x86/kernel/smpboot.c                |    3 +-
>  arch/x86/kernel/traps.c                  |    2 +
>  arch/x86/kernel/tsc.c                    |   10 +-
>  arch/x86/kernel/vmlinux.lds.S            |    2 +-
>  arch/x86/kvm/cpuid.c                     |   18 +-
>  arch/x86/kvm/kvm_cache_regs.h            |   22 +-
>  arch/x86/kvm/lapic.c                     |   11 +-
>  arch/x86/kvm/mmu.h                       |   16 +-
>  arch/x86/kvm/mmu/mmu.c                   |  209 ++--
>  arch/x86/kvm/mmu/mmu_internal.h          |    2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h           |   40 +-
>  arch/x86/kvm/mmu/spte.c                  |    6 +-
>  arch/x86/kvm/mmu/spte.h                  |    2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c               |   14 +-
>  arch/x86/kvm/mtrr.c                      |    2 +-
>  arch/x86/kvm/svm/nested.c                |   34 +-
>  arch/x86/kvm/svm/sev.c                   |   70 +-
>  arch/x86/kvm/svm/svm.c                   |   52 +-
>  arch/x86/kvm/trace.h                     |   10 +-
>  arch/x86/kvm/vmx/capabilities.h          |   14 +-
>  arch/x86/kvm/vmx/nested.c                |   90 +-
>  arch/x86/kvm/vmx/vmx.c                   |  152 ++-
>  arch/x86/kvm/x86.c                       |  315 +++--
>  arch/x86/kvm/x86.h                       |    4 +-
>  arch/x86/mm/Makefile                     |    1 +
>  arch/x86/mm/asi.c                        | 1397 ++++++++++++++++++++++
>  arch/x86/mm/fault.c                      |   67 +-
>  arch/x86/mm/init.c                       |    7 +-
>  arch/x86/mm/init_64.c                    |   26 +-
>  arch/x86/mm/kaslr.c                      |   34 +-
>  arch/x86/mm/mm_internal.h                |    5 +
>  arch/x86/mm/physaddr.c                   |    8 +
>  arch/x86/mm/tlb.c                        |  419 ++++++-
>  arch/xtensa/include/asm/Kbuild           |    1 +
>  fs/binfmt_elf.c                          |    2 +-
>  fs/eventfd.c                             |    2 +-
>  fs/eventpoll.c                           |   10 +-
>  fs/exec.c                                |    7 +
>  fs/file.c                                |    3 +-
>  fs/timerfd.c                             |    2 +-
>  include/asm-generic/asi.h                |  149 +++
>  include/asm-generic/irq_regs.h           |    2 +-
>  include/asm-generic/percpu.h             |    6 +
>  include/asm-generic/vmlinux.lds.h        |   36 +-
>  include/linux/arch_topology.h            |    2 +-
>  include/linux/debug_locks.h              |    4 +-
>  include/linux/gfp.h                      |   13 +-
>  include/linux/hrtimer.h                  |    2 +-
>  include/linux/interrupt.h                |    2 +-
>  include/linux/jiffies.h                  |    4 +-
>  include/linux/kernel_stat.h              |    4 +-
>  include/linux/kvm_host.h                 |    7 +-
>  include/linux/kvm_types.h                |    3 +
>  include/linux/memcontrol.h               |    3 +
>  include/linux/mm_types.h                 |   59 +
>  include/linux/module.h                   |   15 +
>  include/linux/notifier.h                 |    2 +-
>  include/linux/page-flags.h               |   19 +
>  include/linux/percpu-defs.h              |   39 +
>  include/linux/percpu.h                   |    8 +-
>  include/linux/pgtable.h                  |    3 +
>  include/linux/prandom.h                  |    2 +-
>  include/linux/profile.h                  |    2 +-
>  include/linux/rcupdate.h                 |    4 +-
>  include/linux/rcutree.h                  |    2 +-
>  include/linux/sched.h                    |    5 +
>  include/linux/sched/mm.h                 |   12 +
>  include/linux/sched/sysctl.h             |    1 +
>  include/linux/slab.h                     |   68 +-
>  include/linux/slab_def.h                 |    4 +
>  include/linux/slub_def.h                 |    6 +
>  include/linux/vmalloc.h                  |   16 +-
>  include/trace/events/mmflags.h           |   14 +-
>  init/main.c                              |    2 +-
>  kernel/cgroup/cgroup.c                   |    9 +-
>  kernel/cpu.c                             |   14 +-
>  kernel/entry/common.c                    |    6 +
>  kernel/events/core.c                     |   25 +-
>  kernel/exit.c                            |    2 +
>  kernel/fork.c                            |   69 +-
>  kernel/freezer.c                         |    2 +-
>  kernel/irq_work.c                        |    6 +-
>  kernel/locking/lockdep.c                 |   14 +-
>  kernel/module-internal.h                 |    1 +
>  kernel/module.c                          |  210 +++-
>  kernel/panic.c                           |    2 +-
>  kernel/printk/printk.c                   |    4 +-
>  kernel/profile.c                         |    4 +-
>  kernel/rcu/srcutree.c                    |    3 +-
>  kernel/rcu/tree.c                        |   12 +-
>  kernel/rcu/update.c                      |    4 +-
>  kernel/sched/clock.c                     |    2 +-
>  kernel/sched/core.c                      |   23 +-
>  kernel/sched/cpuacct.c                   |   10 +-
>  kernel/sched/cpufreq.c                   |    3 +-
>  kernel/sched/cputime.c                   |    4 +-
>  kernel/sched/fair.c                      |    7 +-
>  kernel/sched/loadavg.c                   |    2 +-
>  kernel/sched/rt.c                        |    2 +-
>  kernel/sched/sched.h                     |   25 +-
>  kernel/sched/topology.c                  |   28 +-
>  kernel/smp.c                             |   26 +-
>  kernel/softirq.c                         |    5 +-
>  kernel/time/hrtimer.c                    |    4 +-
>  kernel/time/jiffies.c                    |    8 +-
>  kernel/time/ntp.c                        |   30 +-
>  kernel/time/tick-common.c                |    6 +-
>  kernel/time/tick-internal.h              |    6 +-
>  kernel/time/tick-sched.c                 |    4 +-
>  kernel/time/timekeeping.c                |   10 +-
>  kernel/time/timekeeping.h                |    2 +-
>  kernel/time/timer.c                      |    4 +-
>  kernel/trace/ring_buffer.c               |    5 +-
>  kernel/trace/trace.c                     |    4 +-
>  kernel/trace/trace_preemptirq.c          |    2 +-
>  kernel/trace/trace_sched_switch.c        |    4 +-
>  kernel/tracepoint.c                      |    2 +-
>  kernel/watchdog.c                        |   12 +-
>  lib/debug_locks.c                        |    5 +-
>  lib/irq_regs.c                           |    2 +-
>  lib/radix-tree.c                         |    6 +-
>  lib/random32.c                           |    3 +-
>  mm/init-mm.c                             |    2 +
>  mm/internal.h                            |    3 +
>  mm/memcontrol.c                          |   37 +-
>  mm/memory.c                              |    4 +-
>  mm/page_alloc.c                          |  204 +++-
>  mm/percpu-internal.h                     |   23 +-
>  mm/percpu-km.c                           |    5 +-
>  mm/percpu-vm.c                           |   57 +-
>  mm/percpu.c                              |  273 ++++-
>  mm/slab.c                                |   42 +-
>  mm/slab.h                                |  166 ++-
>  mm/slab_common.c                         |  461 ++++++-
>  mm/slub.c                                |  140 ++-
>  mm/sparse.c                              |    4 +-
>  mm/util.c                                |    3 +-
>  mm/vmalloc.c                             |  193 ++-
>  net/core/skbuff.c                        |    2 +-
>  net/core/sock.c                          |    2 +-
>  security/Kconfig                         |   12 +
>  tools/perf/builtin-kmem.c                |    2 +
>  virt/kvm/coalesced_mmio.c                |    2 +-
>  virt/kvm/eventfd.c                       |    5 +-
>  virt/kvm/kvm_main.c                      |   61 +-
>  211 files changed, 5727 insertions(+), 959 deletions(-)
>  create mode 100644 arch/x86/include/asm/asi.h
>  create mode 100644 arch/x86/mm/asi.c
>  create mode 100644 include/asm-generic/asi.h
> 
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)
