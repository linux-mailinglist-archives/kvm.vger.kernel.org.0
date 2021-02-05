Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664983101E9
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBEA5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhBEA5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:57:51 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7B3C0613D6
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 16:57:11 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id e7so4394163ile.7
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 16:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ssmka4LJX1Roe9XM2pcTrQY64a1fpByz7eF+X9Qof78=;
        b=PEErTdvQPplYTREOdkVK4aWHlUMxIBxmd9Q0pBwSpkzE+oYq43H544KfAgT6kx3dak
         5tHIrCPXEOOnZqU2IMVbxcKMYVcaTCQAJ1nRxZV6zkKjRWH8y0jWN2A59/2TnuhcUXqr
         DfQUXTzQQXMxBE6ejyUSl4BNXcTuaNwCQLBB4GeMGJfztTNgU8CxiWcaelXHm3bWjged
         Oy3or0SJdAXje418PpFenNZpibFQsU31FlS2Tz2O25BUqpUI4bpBCZ26s/TAn4D7wQRg
         boNRJqhPGpWvhDz4vsHn/Slc28oG80GaoD76yNON+WXZqqhHMilcI3CNe1ICL50OvCdj
         rnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ssmka4LJX1Roe9XM2pcTrQY64a1fpByz7eF+X9Qof78=;
        b=YhIyIF53ClAa+B3T459G5DzfntuzNzbs/MVfMhyktDC5m+2iSOfD0mmqGOdjgaIztj
         os7dCnlzWRvBRYra3tYAIx6XpaUcQt8bnSUxAaVJZY0QN31XRZ84A2mDx5yZFD2Wbi4v
         OJehyuHhopSYEyR/nkVGvl7P9Fobm3e+cJCjjiIOZom/yFccFCOicvC8U0Gh+IdUUpJi
         uMG8dSe6elXq2JbSUQVPoNQLVpXIj89KhLFp40YE+94dACy3T10/w5s7+DsEXNgVAciF
         Eo8irhI4ICZ71FkJG7l/8vfvJA/ZvVwv9OxPiAh7OvIi2Pip5BfDZGCDNcxtiJHYN/AA
         q3Ag==
X-Gm-Message-State: AOAM533GsFvt3M3tiSf08HVuhAmaT9sRKSpGxb0x3e6+XgivvMd0ZgRa
        3jh6v0go/9j1Ry/A0PUW22Ep/pFeBUhE/BlMDsrPYA==
X-Google-Smtp-Source: ABdhPJzI7lWNHwm27hXb+ieRBL5WDAeEvu0ryG4fKl4HNHao0djMSq+6f3sbAtgwCnfzqidWO4Jl59ASF3OljDOdnVA=
X-Received: by 2002:a05:6e02:1608:: with SMTP id t8mr1670751ilu.79.1612486630923;
 Thu, 04 Feb 2021 16:57:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
In-Reply-To: <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 4 Feb 2021 16:56:35 -0800
Message-ID: <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
Subject: Re: [PATCH v10 12/16] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> feature.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     |  5 +++++
>  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
>  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
>  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
>  arch/x86/kvm/svm/svm.h               |  2 ++
>  6 files changed, 52 insertions(+)
>
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index cf62162d4be2..0bdb6cdb12d3 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
>                                                 before using extended destination
>                                                 ID bits in MSI address bits 11-5.
>
> +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> +                                               using the page encryption state
> +                                               hypercall to notify the page state
> +                                               change
> +
>  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                 per-cpu warps are expected in
>                                                 kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index e37a14c323d2..020245d16087 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -376,3 +376,15 @@ data:
>         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
>         and check if there are more notifications pending. The MSR is available
>         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> +
> +MSR_KVM_SEV_LIVE_MIGRATION:
> +        0x4b564d08
> +
> +       Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> +        in other words, this is guest->host communication that it's properly
> +        handling the shared pages list.
> +
> +        All other bits are reserved.
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..f6bfa138874f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>  #define KVM_FEATURE_PV_SCHED_YIELD     13
>  #define KVM_FEATURE_ASYNC_PF_INT       14
>  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
>
>  #define KVM_HINTS_REALTIME      0
>
> @@ -54,6 +55,7 @@
>  #define MSR_KVM_POLL_CONTROL   0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
>
>  struct kvm_steal_time {
>         __u64 steal;
> @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b0d324aed515..93f42b3d3e33 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>         return ret;
>  }
>
> +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +       if (!sev_guest(kvm))
> +               return;

This should assert that userspace wanted the guest to be able to make
these calls (see more below).

>
> +
> +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> +}
> +
>  int svm_get_shared_pages_list(struct kvm *kvm,
>                               struct kvm_shared_pages_list *list)
>  {
> @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
>         if (!sev_guest(kvm))
>                 return -ENOTTY;
>
> +       if (!sev->live_migration_enabled)
> +               return -EINVAL;
> +
>         if (!list->size)
>                 return -EINVAL;
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58f89f83caab..43ea5061926f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 svm->msr_decfg = data;
>                 break;
>         }
> +       case MSR_KVM_SEV_LIVE_MIGRATION:
> +               sev_update_migration_flags(vcpu->kvm, data);
> +               break;
>         case MSR_IA32_APICBASE:
>                 if (kvm_vcpu_apicv_active(vcpu))
>                         avic_update_vapic_bar(to_svm(vcpu), data);
> @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
>         }
>
> +       /*
> +        * If SEV guest then enable the Live migration feature.
> +        */
> +       if (sev_guest(vcpu->kvm)) {
> +               struct kvm_cpuid_entry2 *best;
> +
> +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> +               if (!best)
> +                       return;
> +
> +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> +       }
> +

Looking at this, I believe the only way for this bit to get enabled is
if userspace toggles it. There needs to be a way for userspace to
identify if the kernel underneath them does, in fact, support SEV LM.
I'm at risk for having misread these patches (it's a long series), but
I don't see anything that communicates upwards.

This could go upward with the other paravirt features flags in
cpuid.c. It could also be an explicit KVM Capability (checked through
check_extension).

Userspace should then have a chance to decide whether or not this
should be enabled. And when it's not enabled, the host should return a
GP in response to the hypercall. This could be configured either
through userspace stripping out the LM feature bit, or by calling a VM
scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).

I believe the typical path for a feature like this to be configured
would be to use ENABLE_CAP.

>
>         if (!kvm_vcpu_apicv_active(vcpu))
>                 return;
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 066ca2a9f1e6..e1bffc11e425 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,7 @@ struct kvm_sev_info {
>         unsigned long pages_locked; /* Number of pages locked */
>         struct list_head regions_list;  /* List of registered regions */
>         u64 ap_jump_table;      /* SEV-ES AP Jump Table address */
> +       bool live_migration_enabled;
>         /* List and count of shared pages */
>         int shared_pages_list_count;
>         struct list_head shared_pages_list;
> @@ -592,6 +593,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> +void sev_update_migration_flags(struct kvm *kvm, u64 data);
>  void sev_free_vcpu(struct kvm_vcpu *vcpu);
>  int sev_handle_vmgexit(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
> --
> 2.17.1
>
