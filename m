Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC0CC469
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 22:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJDUsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 16:48:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36874 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJDUsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 16:48:47 -0400
Received: by mail-io1-f68.google.com with SMTP id b19so16463247iob.4
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 13:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXk0BhWuyKY9S12hwt/zCXZNfl9ZEoSf4e1tOm5hhII=;
        b=tQ4sUy8vYR3a4AXx7+UJpcvRAeHNAccGQPbGW21Oe8vTIXfVWZPUTS0y02UggATI+b
         PsNffFy9iHz3o+uLD9chOgD1+asrq5hluSMCBR3syuyh9MYktmZ/SVoQ50HX9j4NPCmO
         vjnC4ZVs2jGoHCtol+takXB6fJmvIIqke3s8sOwIdbcS9rJ2v9x0E4BNO3IO+lU7hmmy
         kHWGqWfgyexhZO2fUFTBukvPPEn5zV3nRIjHsIn5DszX6clrmwnEynoYeSkoQOBcvj4F
         o7Clnn3A5lF2UXKERyV/B8K6BR2ZkHE3RLtP1kf1DlMD7eCZdSBG4m6eSnmP7SBeZYyR
         yndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXk0BhWuyKY9S12hwt/zCXZNfl9ZEoSf4e1tOm5hhII=;
        b=fZpAPB7tDdY28x/HBIXeKbRno8tMpqw1qU4BPKsXVF8jqlGKTv8aT2Exjauw9tq0t/
         8qnn+s44Y2m5vHkkBwd8dvtrf8+xC/ZdN3WrWjF1YQ59Vm1D3Km6Bj/s3wJxWypeE9h6
         6b8IU98HaOYA2aKhLEhtTUYrAnKJJ/IAYEekmddMtmlhCd7NqSZj21Z91hCCGwjWvuhA
         vHzid8sRT0rJwTF6uoeAks8r9U3DQDLHSQTj0GWqbGKUwJOQSwY4aDDyXZNGQub09yXm
         7oz+nGZKImSVwpPomBYMBrjA0j2GkLHzU5HZR4irfViuXDDNzU7Bdd50xyucIEphixjU
         oduQ==
X-Gm-Message-State: APjAAAUXNedHsgmdo2SIXL2jT9Xfj2mdg5zv62P0UgpH+NlnnhcLjGK6
        FZTXc9GzNKsAaAQ9kkrc4zyAQFk05a0YXWAv4xYHVQ==
X-Google-Smtp-Source: APXvYqz7XSZPboz6oE6U0NNJCWB5vYvylBWKnU9bLb5Jyo8VAudlfs/WwEJoxxwmFAfYvVhiWGHTlibup+DMmCRUeKU=
X-Received: by 2002:a6b:1606:: with SMTP id 6mr15851427iow.108.1570222125924;
 Fri, 04 Oct 2019 13:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190917085304.16987-1-weijiang.yang@intel.com> <20190917085304.16987-3-weijiang.yang@intel.com>
In-Reply-To: <20190917085304.16987-3-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Oct 2019 13:48:34 -0700
Message-ID: <CALMp9eSEkZiFq3RhTuJSUCx3WDJy4EfYHk7GDoN=MO9tRt4=hQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] vmx: spp: Add control flags for Sub-Page Protection(SPP)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> Check SPP capability in MSR_IA32_VMX_PROCBASED_CTLS2, its 23-bit
> indicates SPP capability. Enable SPP feature bit in CPU capabilities
> bitmap if it's supported.
>
> Co-developed-by: He Chen <he.chen@linux.intel.com>
> Signed-off-by: He Chen <he.chen@linux.intel.com>
> Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/vmx.h         |  1 +
>  arch/x86/kernel/cpu/intel.c        |  4 ++++
>  arch/x86/kvm/mmu.h                 |  2 ++
>  arch/x86/kvm/vmx/capabilities.h    |  5 +++++
>  arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
>  6 files changed, 23 insertions(+)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index e880f2408e29..ee2c76fdadf6 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -228,6 +228,7 @@
>  #define X86_FEATURE_FLEXPRIORITY       ( 8*32+ 2) /* Intel FlexPriority */
>  #define X86_FEATURE_EPT                        ( 8*32+ 3) /* Intel Extended Page Table */
>  #define X86_FEATURE_VPID               ( 8*32+ 4) /* Intel Virtual Processor ID */
> +#define X86_FEATURE_SPP                        ( 8*32+ 5) /* Intel EPT-based Sub-Page Write Protection */
>
>  #define X86_FEATURE_VMMCALL            ( 8*32+15) /* Prefer VMMCALL to VMCALL */
>  #define X86_FEATURE_XENPV              ( 8*32+16) /* "" Xen paravirtual guest */
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..e1137807affc 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -68,6 +68,7 @@
>  #define SECONDARY_EXEC_XSAVES                  0x00100000
>  #define SECONDARY_EXEC_PT_USE_GPA              0x01000000
>  #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC     0x00400000
> +#define SECONDARY_EXEC_ENABLE_SPP              0x00800000
>  #define SECONDARY_EXEC_TSC_SCALING              0x02000000
>
>  #define PIN_BASED_EXT_INTR_MASK                 0x00000001
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 8d6d92ebeb54..27617e522f01 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -503,6 +503,7 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
>  #define X86_VMX_FEATURE_PROC_CTLS2_EPT         0x00000002
>  #define X86_VMX_FEATURE_PROC_CTLS2_VPID                0x00000020
>  #define x86_VMX_FEATURE_EPT_CAP_AD             0x00200000
> +#define X86_VMX_FEATURE_PROC_CTLS2_SPP         0x00800000
>
>         u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
>         u32 msr_vpid_cap, msr_ept_cap;
> @@ -513,6 +514,7 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
>         clear_cpu_cap(c, X86_FEATURE_EPT);
>         clear_cpu_cap(c, X86_FEATURE_VPID);
>         clear_cpu_cap(c, X86_FEATURE_EPT_AD);
> +       clear_cpu_cap(c, X86_FEATURE_SPP);
>
>         rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
>         msr_ctl = vmx_msr_high | vmx_msr_low;
> @@ -536,6 +538,8 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
>                 }
>                 if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
>                         set_cpu_cap(c, X86_FEATURE_VPID);
> +               if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_SPP)
> +                       set_cpu_cap(c, X86_FEATURE_SPP);

SPP requires EPT, so this could be moved up next to the EPT_AD check.
In fact, I would suggest changing 'SPP' to 'EPT_SPP' to make it clear
that this feature is *EPT* sub-page permissions.

>         }
>  }
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 54c2a377795b..3c1423526a98 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -26,6 +26,8 @@
>  #define PT_PAGE_SIZE_MASK (1ULL << PT_PAGE_SIZE_SHIFT)
>  #define PT_PAT_MASK (1ULL << 7)
>  #define PT_GLOBAL_MASK (1ULL << 8)
> +#define PT_SPP_SHIFT 61
> +#define PT_SPP_MASK (1ULL << PT_SPP_SHIFT)

Since these constants are only applicable to EPT, would it be more
appropriate to define them in paging_tmpl.h, under '#elif PTTYPE ==
PTTYPE_EPT'? If not, it seems that they should at least be renamed to
PT64_SPP_* for consistency with the other macros here.

>  #define PT64_NX_SHIFT 63
>  #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
>
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index d6664ee3d127..e3bde7a32123 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -241,6 +241,11 @@ static inline bool cpu_has_vmx_pml(void)
>         return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_PML;
>  }
>
> +static inline bool cpu_has_vmx_ept_spp(void)
> +{
> +       return vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_ENABLE_SPP;
> +}
> +
>  static inline bool vmx_xsaves_supported(void)
>  {
>         return vmcs_config.cpu_based_2nd_exec_ctrl &
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c030c96fc81a..8ecf9cb24879 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -60,6 +60,7 @@
>  #include "vmcs12.h"
>  #include "vmx.h"
>  #include "x86.h"
> +#include "spp.h"
>
>  MODULE_AUTHOR("Qumranet");
>  MODULE_LICENSE("GPL");
> @@ -113,6 +114,7 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
>
>  static bool __read_mostly dump_invalid_vmcs = 0;
>  module_param(dump_invalid_vmcs, bool, 0644);
> +static bool __read_mostly spp_supported = 0;
>
>  #define MSR_BITMAP_MODE_X2APIC         1
>  #define MSR_BITMAP_MODE_X2APIC_APICV   2
> @@ -2279,6 +2281,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                         SECONDARY_EXEC_RDSEED_EXITING |
>                         SECONDARY_EXEC_RDRAND_EXITING |
>                         SECONDARY_EXEC_ENABLE_PML |
> +                       SECONDARY_EXEC_ENABLE_SPP |
>                         SECONDARY_EXEC_TSC_SCALING |
>                         SECONDARY_EXEC_PT_USE_GPA |
>                         SECONDARY_EXEC_PT_CONCEAL_VMX |
> @@ -3931,6 +3934,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>         if (!enable_pml)
>                 exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>
> +       if (!spp_supported)
> +               exec_control &= ~SECONDARY_EXEC_ENABLE_SPP;
> +
>         if (vmx_xsaves_supported()) {
>                 /* Exposing XSAVES only when XSAVE is exposed */
>                 bool xsaves_enabled =
> @@ -7521,6 +7527,10 @@ static __init int hardware_setup(void)
>         if (!cpu_has_vmx_flexpriority())
>                 flexpriority_enabled = 0;
>
> +       if (cpu_has_vmx_ept_spp() && enable_ept &&
> +           boot_cpu_has(X86_FEATURE_SPP))
> +               spp_supported = 1;

Don't cpu_has_vmx_ept_spp() and boot_cpu_has(X86_FEATURE_SPP) test
exactly the same thing?

>         if (!cpu_has_virtual_nmis())
>                 enable_vnmi = 0;
>
> --
> 2.17.2
>
