Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E2A31A2A8
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhBLQ0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 11:26:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhBLQ0M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 11:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613147075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AEhU2g4edUykQP1EilIJTjjqCzDqbCg1Qo9rDd+6lLw=;
        b=S1aLVwq42+KpI5TObSTJJmnS0XCigurCpwI+lA+craaVGu8FP5F0lSgLZUbbbD9JLezrTP
        MKw9cahjWelTbT+dbgL1pyc1TEMOcaeIfCCaLKCe4KIXMbgfOI+wNBnDSZolxmN9i/LVNW
        as2gzw0QURpXSx9+3Q+N2Y0sXcE+5aA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-ReMf_mUFPC25-kD7P4KTFg-1; Fri, 12 Feb 2021 11:24:33 -0500
X-MC-Unique: ReMf_mUFPC25-kD7P4KTFg-1
Received: by mail-ed1-f72.google.com with SMTP id j10so300540edv.5
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 08:24:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AEhU2g4edUykQP1EilIJTjjqCzDqbCg1Qo9rDd+6lLw=;
        b=BOwjHoNmNGAQQNc7NKxbq3tW0Kw/ZsXGcKWlLZOBN1+bs3TT80TvDdMI5qLGHbfY68
         1n1JTjBeXDVwgrXjV14kM7hUL6AjvU0nzyoPfqffpmmhfzudbUlNRtC298h3GsuW5uq0
         ym9o8/cNNvrJfMSpesUukyPPnWrTtORhS2EFNsAq+TE5Qw876q4nerLODBaVg05npd3X
         oYyoYKYJAHFHJpWO8RCaTHtoEkDn6wnEtSDppdS6daB3B5gUZFOc/sMT22ve5LkjEmcC
         8cpxEOJVi7y+5Z7WbJRO9cPYLWuqd5Vpw1/CtKNHNK81ZPHiu+7mz7xmTsiW/ABuOaBD
         3ZTw==
X-Gm-Message-State: AOAM531OUnOcH2Mbv8uJ7x6bCPpcJfl836PEktYiVG1XD6v+tjUIElbR
        FUAYsh9NPUBXuFO7qGx0o+Kit6vtrtCTJBpPYH104CylxnfzgPUP4yeqWC7bE+pc4j6CG10TLFK
        6t9xVB371S5FE
X-Received: by 2002:a17:906:7fca:: with SMTP id r10mr3802944ejs.242.1613147071453;
        Fri, 12 Feb 2021 08:24:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUoIIpvIext07j2KdWmGqKYKwVP/MDe4WIR+YP2feyQgQwq50Q4z+f73FlLvwpRRgFwel5dQ==
X-Received: by 2002:a17:906:7fca:: with SMTP id r10mr3802922ejs.242.1613147071262;
        Fri, 12 Feb 2021 08:24:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a15sm6011648edv.95.2021.02.12.08.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 08:24:30 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.12
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
References: <20210212143657.3312035-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a04f2c97-a7cf-eeb6-2f79-d96ae2215cdd@redhat.com>
Date:   Fri, 12 Feb 2021 17:24:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210212143657.3312035-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/21 15:36, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the initial set of KVM/arm64 updates for 5.11.
> 
> The most notable change this time is David's work to finally build the
> nVHE EL2 object as a relocatable object. This makes the code a lot
> cleaner, more reliable (we don't have to assume things about code
> generation), and allows... function pointers, with any ugly hack!
> Progress, at last, and a huge thank you to David!
> 
> We also gained support for the new TRNG standard hypercall, and a nice
> optimisation for concurrent translation faults targeting the same
> page. The rest is a small batch of fixes and other cleanups.
> 
> Note that there is another bunch of changes indirectly affecting
> KVM/arm64 that are routed via the arm64 tree, as we turn upside down
> the way we boot Linux on a VHE system. It's all good fun.
> 
> This pull request also comes with strings attached:
> - the kvmarm-fixes-5.11-2 tag in order to avoid ugly conflicts, which
>    explains a sense of déjà-vu in the short-log below
> - the arm64/for-next/misc branch because of dependencies
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 19c329f6808995b142b3966301f217c831e7cf31:
> 
>    Linux 5.11-rc4 (2021-01-17 16:37:05 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.12
> 
> for you to fetch changes up to c93199e93e1232b7220482dffa05b7a32a195fe8:
> 
>    Merge branch 'kvm-arm64/pmu-debug-fixes-5.11' into kvmarm-master/next (2021-02-12 14:08:41 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 updates for Linux 5.12
> 
> - Make the nVHE EL2 object relocatable, resulting in much more
>    maintainable code
> - Handle concurrent translation faults hitting the same page
>    in a more elegant way
> - Support for the standard TRNG hypervisor call
> - A bunch of small PMU/Debug fixes
> - Allow the disabling of symbol export from assembly code
> - Simplification of the early init hypercall handling
> 
> ----------------------------------------------------------------
> Alexandru Elisei (2):
>        KVM: arm64: Use the reg_to_encoding() macro instead of sys_reg()
>        KVM: arm64: Correct spelling of DBGDIDR register
> 
> Andrew Scull (1):
>        KVM: arm64: Simplify __kvm_hyp_init HVC detection
> 
> Ard Biesheuvel (2):
>        firmware: smccc: Add SMCCC TRNG function call IDs
>        KVM: arm64: Implement the TRNG hypervisor call
> 
> David Brazdil (9):
>        KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
>        KVM: arm64: Rename .idmap.text in hyp linker script
>        KVM: arm64: Set up .hyp.rodata ELF section
>        KVM: arm64: Add symbol at the beginning of each hyp section
>        KVM: arm64: Generate hyp relocation data
>        KVM: arm64: Apply hyp relocations at runtime
>        KVM: arm64: Fix constant-pool users in hyp
>        KVM: arm64: Remove patching of fn pointers in hyp
>        KVM: arm64: Remove hyp_symbol_addr
> 
> Marc Zyngier (20):
>        KVM: arm64: Hide PMU registers from userspace when not available
>        KVM: arm64: Simplify handling of absent PMU system registers
>        arm64: Drop workaround for broken 'S' constraint with GCC 4.9
>        KVM: arm64: Filter out v8.1+ events on v8.0 HW
>        KVM: Forbid the use of tagged userspace addresses for memslots
>        Merge branch 'arm64/for-next/misc' into kvm-arm64/hyp-reloc
>        KVM: arm64: Make gen-hyprel endianness agnostic
>        KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
>        KVM: arm64: Fix AArch32 PMUv3 capping
>        KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3 registers
>        KVM: arm64: Refactor filtering of ID registers
>        KVM: arm64: Limit the debug architecture to ARMv8.0
>        KVM: arm64: Upgrade PMU support to ARMv8.4
>        KVM: arm64: Use symbolic names for the PMU versions
>        Merge tag 'kvmarm-fixes-5.11-2' into kvmarm-master/next
>        Merge branch 'kvm-arm64/misc-5.12' into kvmarm-master/next
>        Merge branch 'kvm-arm64/concurrent-translation-fault' into kvmarm-master/next
>        Merge branch 'kvm-arm64/hyp-reloc' into kvmarm-master/next
>        Merge branch 'kvm-arm64/rng-5.12' into kvmarm-master/next
>        Merge branch 'kvm-arm64/pmu-debug-fixes-5.11' into kvmarm-master/next
> 
> Quentin Perret (2):
>        asm-generic: export: Stub EXPORT_SYMBOL with __DISABLE_EXPORTS
>        KVM: arm64: Stub EXPORT_SYMBOL for nVHE EL2 code
> 
> Steven Price (1):
>        KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag
> 
> Yanan Wang (3):
>        KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2 map
>        KVM: arm64: Filter out the case of only changing permissions from stage-2 map path
>        KVM: arm64: Mark the page dirty only if the fault is handled successfully
> 
>   Documentation/virt/kvm/api.rst           |   3 +
>   arch/arm64/include/asm/hyp_image.h       |  29 +-
>   arch/arm64/include/asm/kvm_asm.h         |  26 --
>   arch/arm64/include/asm/kvm_host.h        |   2 +
>   arch/arm64/include/asm/kvm_mmu.h         |  61 ++---
>   arch/arm64/include/asm/kvm_pgtable.h     |   5 +
>   arch/arm64/include/asm/sections.h        |   3 +-
>   arch/arm64/include/asm/sysreg.h          |   3 +
>   arch/arm64/kernel/image-vars.h           |   1 -
>   arch/arm64/kernel/smp.c                  |   4 +-
>   arch/arm64/kernel/vmlinux.lds.S          |  18 +-
>   arch/arm64/kvm/Makefile                  |   2 +-
>   arch/arm64/kvm/arm.c                     |  10 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h  |   4 +-
>   arch/arm64/kvm/hyp/nvhe/.gitignore       |   2 +
>   arch/arm64/kvm/hyp/nvhe/Makefile         |  33 ++-
>   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c     | 438 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/nvhe/host.S           |  29 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-init.S       |  19 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c       |  11 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |   4 +-
>   arch/arm64/kvm/hyp/nvhe/hyp.lds.S        |   9 +-
>   arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  37 ++-
>   arch/arm64/kvm/hyp/pgtable.c             |  83 +++---
>   arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |   2 +-
>   arch/arm64/kvm/hypercalls.c              |   6 +
>   arch/arm64/kvm/mmu.c                     |  13 +-
>   arch/arm64/kvm/pmu-emul.c                |  24 +-
>   arch/arm64/kvm/sys_regs.c                | 178 ++++++++-----
>   arch/arm64/kvm/trng.c                    |  85 ++++++
>   arch/arm64/kvm/va_layout.c               |  34 ++-
>   include/asm-generic/export.h             |   2 +-
>   include/linux/arm-smccc.h                |  31 +++
>   virt/kvm/kvm_main.c                      |   1 +
>   34 files changed, 934 insertions(+), 278 deletions(-)
>   create mode 100644 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
>   create mode 100644 arch/arm64/kvm/trng.c
> 

Pulled, thanks!

Paolo

