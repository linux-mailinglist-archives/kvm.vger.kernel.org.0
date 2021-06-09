Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94B43A17DA
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhFIOvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:51:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233986AbhFIOvt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPADNTwFpZwmZXzzAXUXoQL6rJ0SbSv3Bmha0yUuchE=;
        b=c8ROV6IxsTv7KVxEsVKo9En8MdajHnC/U4NNQRcubjHkYxjIDDcjasxOuLi/AsO36TL6ZA
        et79ROIyp8v7r45ttWzFuv4/FLjQJzFBPJ/j092lq892VB9gP9pOaay3jT3GGRS/jOHdzt
        BxvVjfYsr/0NsUwSWWGwfNhIK6u79aE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-9tnI9XAqNQukGia4VUCscw-1; Wed, 09 Jun 2021 10:49:53 -0400
X-MC-Unique: 9tnI9XAqNQukGia4VUCscw-1
Received: by mail-wm1-f72.google.com with SMTP id m33-20020a05600c3b21b02901a44b1d2d87so2026435wms.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kPADNTwFpZwmZXzzAXUXoQL6rJ0SbSv3Bmha0yUuchE=;
        b=Lbo+1x3HFvitPHYU57mHxjHbOEN9NU4nNHEpkARGYEiPPPJZf89auzmGyZSUFn0fJq
         HCby0ybyxxMM9itICql7TC7cTR4gv+Xjqp4XvylAUrkmJItDP++dCwAm5TIHkkok33P0
         irbVq3oiZDZ+Z+x08GB3+WYNaFqtS+CIUhMNeYNNwG500MPObG92TFs/Q2zgr8YslWgv
         YIX0l6BsxTPTNzED5PAUHuukRsNpHli9u1dfeDWKQT7kJMyzU0ECcVms1mQuXD5A64ko
         HE4ZRiOiOy5tR7PGYvrrjPh1yBDq7M3dlla7RANipDUoB84ITiskQzkG/h3IcSIYqe8y
         QiwA==
X-Gm-Message-State: AOAM532cfLUe7cp0XzyzbpBFVoD0hh2Ft/KkD7742Z8O963+LPzGPVV+
        nbn/g6Du1e60ba9maRVHyuhbHBcrpBuX4aOlxETIojYOD3mfmJcn12xX3U5fMUjbzTOduYZ0a2h
        cVsfHOSvcvXgn
X-Received: by 2002:a5d:530c:: with SMTP id e12mr174477wrv.165.1623250192090;
        Wed, 09 Jun 2021 07:49:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJAsLUfwPAV8SKw7A8bkaIzr0yv/5tACaMMA+I4d9ATGwios9zxjytr9KkgtaI+kSa11VRog==
X-Received: by 2002:a5d:530c:: with SMTP id e12mr174435wrv.165.1623250191798;
        Wed, 09 Jun 2021 07:49:51 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id r4sm158876wre.84.2021.06.09.07.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:49:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 7/7] x86: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-8-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <661ee535-bdac-aa1d-7b29-a271f698e778@redhat.com>
Date:   Wed, 9 Jun 2021 16:49:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-8-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Standardize header guards to _ASMX86_HEADER_H_, _X86_HEADER_H_,
> and X86_HEADER_H.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/x86/acpi.h             | 4 ++--
>   lib/x86/apic-defs.h        | 6 +++---
>   lib/x86/apic.h             | 4 ++--
>   lib/x86/asm/barrier.h      | 4 ++--
>   lib/x86/asm/debugreg.h     | 6 +++---
>   lib/x86/asm/io.h           | 4 ++--
>   lib/x86/asm/memory_areas.h | 4 ++--
>   lib/x86/asm/page.h         | 4 ++--
>   lib/x86/asm/pci.h          | 4 ++--
>   lib/x86/asm/spinlock.h     | 4 ++--
>   lib/x86/asm/stack.h        | 4 ++--
>   lib/x86/atomic.h           | 4 ++--
>   lib/x86/delay.h            | 4 ++--
>   lib/x86/desc.h             | 4 ++--
>   lib/x86/fault_test.h       | 4 ++--
>   lib/x86/fwcfg.h            | 4 ++--
>   lib/x86/intel-iommu.h      | 4 ++--
>   lib/x86/isr.h              | 4 ++--
>   lib/x86/msr.h              | 6 +++---
>   lib/x86/processor.h        | 4 ++--
>   lib/x86/smp.h              | 4 ++--
>   lib/x86/usermode.h         | 4 ++--
>   lib/x86/vm.h               | 4 ++--
>   x86/hyperv.h               | 4 ++--
>   x86/ioram.h                | 4 ++--
>   x86/kvmclock.h             | 4 ++--
>   x86/svm.h                  | 4 ++--
>   x86/types.h                | 4 ++--
>   x86/vmx.h                  | 4 ++--
>   29 files changed, 61 insertions(+), 61 deletions(-)
> 
> diff --git a/lib/x86/acpi.h b/lib/x86/acpi.h
> index 08aaf57a7890..1b803740f331 100644
> --- a/lib/x86/acpi.h
> +++ b/lib/x86/acpi.h
> @@ -1,5 +1,5 @@
> -#ifndef KVM_ACPI_H
> -#define KVM_ACPI_H 1
> +#ifndef _X86_ACPI_H_
> +#define _X86_ACPI_H_
>   
>   #include "libcflat.h"
>   
> diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
> index b2014de800a7..dabefe7879ea 100644
> --- a/lib/x86/apic-defs.h
> +++ b/lib/x86/apic-defs.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_APICDEF_H
> -#define _ASM_X86_APICDEF_H
> +#ifndef _X86_APIC_DEFS_H_
> +#define _X86_APIC_DEFS_H_
>   
>   /*
>    * Abuse this header file to hold the number of max-cpus, making it available
> @@ -144,4 +144,4 @@
>   
>   #define APIC_BASE_MSR	0x800
>   
> -#endif /* _ASM_X86_APICDEF_H */
> +#endif /* _X86_APIC_DEFS_H_ */
> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
> index a7eff6354a83..c4821716b352 100644
> --- a/lib/x86/apic.h
> +++ b/lib/x86/apic.h
> @@ -1,5 +1,5 @@
> -#ifndef CFLAT_APIC_H
> -#define CFLAT_APIC_H
> +#ifndef _X86_APIC_H_
> +#define _X86_APIC_H_
>   
>   #include <stdint.h>
>   #include "apic-defs.h"
> diff --git a/lib/x86/asm/barrier.h b/lib/x86/asm/barrier.h
> index 193fb4c2e712..66c8f56f1c9a 100644
> --- a/lib/x86/asm/barrier.h
> +++ b/lib/x86/asm/barrier.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_BARRIER_H_
> -#define _ASM_X86_BARRIER_H_
> +#ifndef _ASMX86_BARRIER_H_
> +#define _ASMX86_BARRIER_H_
>   /*
>    * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
>    *
> diff --git a/lib/x86/asm/debugreg.h b/lib/x86/asm/debugreg.h
> index d95d080b30e3..e86f5a629480 100644
> --- a/lib/x86/asm/debugreg.h
> +++ b/lib/x86/asm/debugreg.h
> @@ -1,6 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -#ifndef _UAPI_ASM_X86_DEBUGREG_H
> -#define _UAPI_ASM_X86_DEBUGREG_H
> +#ifndef _ASMX86_DEBUGREG_H_
> +#define _ASMX86_DEBUGREG_H_
>   
>   
>   /* Indicate the register numbers for a number of the specific
> @@ -78,4 +78,4 @@
>    * HW breakpoint additions
>    */
>   
> -#endif /* _UAPI_ASM_X86_DEBUGREG_H */
> +#endif /* _ASMX86_DEBUGREG_H_ */
> diff --git a/lib/x86/asm/io.h b/lib/x86/asm/io.h
> index 35a5c7347411..88734320aa93 100644
> --- a/lib/x86/asm/io.h
> +++ b/lib/x86/asm/io.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_IO_H_
> -#define _ASM_X86_IO_H_
> +#ifndef _ASMX86_IO_H_
> +#define _ASMX86_IO_H_
>   
>   #define __iomem
>   
> diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> index e84016f8b060..bd47a89aba7d 100644
> --- a/lib/x86/asm/memory_areas.h
> +++ b/lib/x86/asm/memory_areas.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_MEMORY_AREAS_H_
> -#define _ASM_X86_MEMORY_AREAS_H_
> +#ifndef _ASMX86_MEMORY_AREAS_H_
> +#define _ASMX86_MEMORY_AREAS_H_
>   
>   #define AREA_NORMAL_PFN BIT(36-12)
>   #define AREA_NORMAL_NUMBER 0
> diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
> index 2cf8881e16d2..fc1416071ec9 100644
> --- a/lib/x86/asm/page.h
> +++ b/lib/x86/asm/page.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_PAGE_H_
> -#define _ASM_X86_PAGE_H_
> +#ifndef _ASMX86_PAGE_H_
> +#define _ASMX86_PAGE_H_
>   /*
>    * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
>    *
> diff --git a/lib/x86/asm/pci.h b/lib/x86/asm/pci.h
> index c937e5cd71e1..03e55c277f12 100644
> --- a/lib/x86/asm/pci.h
> +++ b/lib/x86/asm/pci.h
> @@ -1,5 +1,5 @@
> -#ifndef ASM_PCI_H
> -#define ASM_PCI_H
> +#ifndef _ASMX86_PCI_H_
> +#define _ASMX86_PCI_H_
>   /*
>    * Copyright (C) 2013, Red Hat Inc, Michael S. Tsirkin <mst@redhat.com>
>    *
> diff --git a/lib/x86/asm/spinlock.h b/lib/x86/asm/spinlock.h
> index 692020c5185c..34fadf771c11 100644
> --- a/lib/x86/asm/spinlock.h
> +++ b/lib/x86/asm/spinlock.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_SPINLOCK_H
> -#define __ASM_SPINLOCK_H
> +#ifndef _ASMX86_SPINLOCK_H_
> +#define _ASMX86_SPINLOCK_H_
>   
>   #include <asm-generic/spinlock.h>
>   
> diff --git a/lib/x86/asm/stack.h b/lib/x86/asm/stack.h
> index b14e2c0fa012..417695373801 100644
> --- a/lib/x86/asm/stack.h
> +++ b/lib/x86/asm/stack.h
> @@ -1,5 +1,5 @@
> -#ifndef _X86ASM_STACK_H_
> -#define _X86ASM_STACK_H_
> +#ifndef _ASMX86_STACK_H_
> +#define _ASMX86_STACK_H_
>   
>   #ifndef _STACK_H_
>   #error Do not directly include <asm/stack.h>. Just use <stack.h>.
> diff --git a/lib/x86/atomic.h b/lib/x86/atomic.h
> index c9ce489d3904..13e734bb464d 100644
> --- a/lib/x86/atomic.h
> +++ b/lib/x86/atomic.h
> @@ -1,5 +1,5 @@
> -#ifndef __ATOMIC_H
> -#define __ATOMIC_H
> +#ifndef _X86_ATOMIC_H_
> +#define _X86_ATOMIC_H_
>   
>   #include "asm-generic/atomic.h"
>   
> diff --git a/lib/x86/delay.h b/lib/x86/delay.h
> index a51eb34485d0..26270edb2156 100644
> --- a/lib/x86/delay.h
> +++ b/lib/x86/delay.h
> @@ -1,5 +1,5 @@
> -#ifndef __X86_DELAY__
> -#define __X86_DELAY__
> +#ifndef _X86_DELAY_H_
> +#define _X86_DELAY_H_
>   
>   #include "libcflat.h"
>   
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 77b2c59d5551..a6ffb38c79a1 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -1,5 +1,5 @@
> -#ifndef __IDT_TEST__
> -#define __IDT_TEST__
> +#ifndef _X86_DESC_H_
> +#define _X86_DESC_H_
>   
>   #include <setjmp.h>
>   
> diff --git a/lib/x86/fault_test.h b/lib/x86/fault_test.h
> index dfa715ba6720..07566365d57c 100644
> --- a/lib/x86/fault_test.h
> +++ b/lib/x86/fault_test.h
> @@ -1,5 +1,5 @@
> -#ifndef __FAULT_TEST__
> -#define __FAULT_TEST__
> +#ifndef _X86_FAULT_TEST_H_
> +#define _X86_FAULT_TEST_H_
>   
>   #include "x86/msr.h"
>   #include "x86/processor.h"
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index ac4257e5d78e..2434cf62222a 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -1,5 +1,5 @@
> -#ifndef FWCFG_H
> -#define FWCFG_H
> +#ifndef _X86_FWCFG_H_
> +#define _X86_FWCFG_H_
>   
>   #include <stdint.h>
>   #include <stdbool.h>
> diff --git a/lib/x86/intel-iommu.h b/lib/x86/intel-iommu.h
> index 05b9744b916b..e14f825e796d 100644
> --- a/lib/x86/intel-iommu.h
> +++ b/lib/x86/intel-iommu.h
> @@ -12,8 +12,8 @@
>    * (From include/linux/intel-iommu.h)
>    */
>   
> -#ifndef __INTEL_IOMMU_H__
> -#define __INTEL_IOMMU_H__
> +#ifndef _X86_INTEL_IOMMU_H_
> +#define _X86_INTEL_IOMMU_H_
>   
>   #include "libcflat.h"
>   #include "isr.h"
> diff --git a/lib/x86/isr.h b/lib/x86/isr.h
> index a50929190b64..746ac7af4a90 100644
> --- a/lib/x86/isr.h
> +++ b/lib/x86/isr.h
> @@ -1,5 +1,5 @@
> -#ifndef __ISR_TEST__
> -#define __ISR_TEST__
> +#ifndef _X86_ISR_H_
> +#define _X86_ISR_H_
>   
>   typedef struct {
>       ulong regs[sizeof(ulong)*2];
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index 5213bcd55836..5001b169cc48 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_X86_MSR_INDEX_H
> -#define _ASM_X86_MSR_INDEX_H
> +#ifndef _X86_MSR_H_
> +#define _X86_MSR_H_
>   
>   /* CPU model specific register (MSR) numbers */
>   
> @@ -435,4 +435,4 @@
>   #define MSR_VM_IGNNE                    0xc0010115
>   #define MSR_VM_HSAVE_PA                 0xc0010117
>   
> -#endif /* _ASM_X86_MSR_INDEX_H */
> +#endif /* _X86_MSR_H_ */
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index abc04b08afb0..b6068f52d850 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -1,5 +1,5 @@
> -#ifndef LIBCFLAT_PROCESSOR_H
> -#define LIBCFLAT_PROCESSOR_H
> +#ifndef _X86_PROCESSOR_H_
> +#define _X86_PROCESSOR_H_
>   
>   #include "libcflat.h"
>   #include "desc.h"
> diff --git a/lib/x86/smp.h b/lib/x86/smp.h
> index 09dfa86f123b..f74845e6903c 100644
> --- a/lib/x86/smp.h
> +++ b/lib/x86/smp.h
> @@ -1,5 +1,5 @@
> -#ifndef __SMP_H
> -#define __SMP_H
> +#ifndef _X86_SMP_H_
> +#define _X86_SMP_H_
>   #include <asm/spinlock.h>
>   
>   void smp_init(void);
> diff --git a/lib/x86/usermode.h b/lib/x86/usermode.h
> index 4e005e65f917..04e358e2a3a3 100644
> --- a/lib/x86/usermode.h
> +++ b/lib/x86/usermode.h
> @@ -1,5 +1,5 @@
> -#ifndef _USERMODE_H_
> -#define _USERMODE_H_
> +#ifndef _X86_USERMODE_H_
> +#define _X86_USERMODE_H_
>   
>   #include "x86/msr.h"
>   #include "x86/processor.h"
> diff --git a/lib/x86/vm.h b/lib/x86/vm.h
> index 3a1432f39d2a..d9753c3d4606 100644
> --- a/lib/x86/vm.h
> +++ b/lib/x86/vm.h
> @@ -1,5 +1,5 @@
> -#ifndef VM_H
> -#define VM_H
> +#ifndef _X86_VM_H_
> +#define _X86_VM_H_
>   
>   #include "processor.h"
>   #include "asm/page.h"
> diff --git a/x86/hyperv.h b/x86/hyperv.h
> index e135221fa28a..e3803e02f4dc 100644
> --- a/x86/hyperv.h
> +++ b/x86/hyperv.h
> @@ -1,5 +1,5 @@
> -#ifndef __HYPERV_H
> -#define __HYPERV_H
> +#ifndef X86_HYPERV_H
> +#define X86_HYPERV_H
>   
>   #include "libcflat.h"
>   #include "processor.h"
> diff --git a/x86/ioram.h b/x86/ioram.h
> index 2938142b36d3..9c816a83eae5 100644
> --- a/x86/ioram.h
> +++ b/x86/ioram.h
> @@ -1,5 +1,5 @@
> -#ifndef __IO_RAM_H
> -#define __IO_RAM_H
> +#ifndef X86_IORAM_H
> +#define X86_IORAM_H
>   
>   #define IORAM_BASE_PHYS 0xff000000UL
>   #define IORAM_LEN       0x10000UL
> diff --git a/x86/kvmclock.h b/x86/kvmclock.h
> index f823c6dbb65d..1a40a7c0f6bc 100644
> --- a/x86/kvmclock.h
> +++ b/x86/kvmclock.h
> @@ -1,5 +1,5 @@
> -#ifndef KVMCLOCK_H
> -#define KVMCLOCK_H
> +#ifndef X86_KVMCLOCK_H
> +#define X86_KVMCLOCK_H
>   
>   #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
>   #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
> diff --git a/x86/svm.h b/x86/svm.h
> index 593e3b0f64b1..995b0f8ccbfe 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -1,5 +1,5 @@
> -#ifndef __SVM_H
> -#define __SVM_H
> +#ifndef X86_SVM_H
> +#define X86_SVM_H
>   
>   #include "libcflat.h"
>   
> diff --git a/x86/types.h b/x86/types.h
> index 047556e854d6..56ce5ececdec 100644
> --- a/x86/types.h
> +++ b/x86/types.h
> @@ -1,5 +1,5 @@
> -#ifndef __TYPES_H
> -#define __TYPES_H
> +#ifndef X86_TYPES_H
> +#define X86_TYPES_H
>   
>   #define DE_VECTOR 0
>   #define DB_VECTOR 1
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 7e39b843cafb..2c534ca4b801 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -1,5 +1,5 @@
> -#ifndef __VMX_H
> -#define __VMX_H
> +#ifndef X86_VMX_H
> +#define X86_VMX_H
>   
>   #include "libcflat.h"
>   #include "processor.h"
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

