Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD8354A3E
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 03:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbhDFBjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 21:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhDFBjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 21:39:47 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5F4C06174A
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 18:39:40 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e8so13878080iok.5
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 18:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kshdm0ap+EBevJYwNXWZ87A2dwWzJNSVhby0IFpKUjE=;
        b=DANlQeYZz2ut86OoHojEBFv6NeBzzNzeZxzDJDo2dYnDuY7a3P8SCSfkMLU8rHFzCV
         sMYHOF/i0EdlmUpxfTWUrNAwPTFLQRgIktXI2/9olm76w+XkfK4QhCuD2bXXfwZg7GSw
         jJEgfCdlsG5Y1XpUNkOpuCkba5Mq0ZqqPqKaKvYU4gk7YJcSXGRVLPx8roBpl7U/xXgY
         D/LWVsarb/dQEM9chZpX639Ym030NOR3f02wVWLQWXG/zIQtEg6z1FjJAo3xh09h+WJm
         XbK4sRLFPkIt3lWHW5GLsNtvqVRSHLAtGSVvev+x420lJksca8V7cZESQFY5hM3c5Gyd
         hgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kshdm0ap+EBevJYwNXWZ87A2dwWzJNSVhby0IFpKUjE=;
        b=gSWQjxyEdNP/QUqLtG7ayELgnRTYPz2kz+T+AeFGwb1rEFcryI05Bhi/gluWmaP4eX
         t0+GfRcILdq+hspqHFWRBjH5gMQeeWqTq76QHQrdqj4fYPiAIiTyYB2PbFM1NZAd/E5m
         ghoMGhBMZg6fdmrbL1WPLrKd9N70lhO5px8fjVlbrmCE1pszf6vfPWA3kQaekjp3BXk5
         JW4KLHuKrLiJrsh87nK/EAyR85K4XM8Misva2LX4SsaIHHyH4iQFfgDzBiQOLvzwN25W
         vt9mRoL4AU44sGyA8GL5A0OHFChHhLnay9JFrOTIGRTTMZi5I/UT7xFzkBkGG0YTe3au
         kMxw==
X-Gm-Message-State: AOAM530JLH8NmUkKtk1akb6Mi56jjg5y3ynCOF1hjeh+yMhBjK+kMK3m
        W2FAfLxJuCKoXd/MLsM7CbHC2m0N52nGyudTcWyIXQ==
X-Google-Smtp-Source: ABdhPJxN+N9O0aLCS3WWAmy/8YPy6PoL8hK8sPoE9FoGWSPGhStJwZR8kNYyAYdEvnB/f7i+RQZUrBw18wjhFiWIncU=
X-Received: by 2002:a6b:3118:: with SMTP id j24mr21659489ioa.205.1617673179308;
 Mon, 05 Apr 2021 18:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617302792.git.ashish.kalra@amd.com> <69dd6d5c4f467e6c8a0f4f1065f7f2a3d25f37f8.1617302792.git.ashish.kalra@amd.com>
In-Reply-To: <69dd6d5c4f467e6c8a0f4f1065f7f2a3d25f37f8.1617302792.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 5 Apr 2021 18:39:03 -0700
Message-ID: <CABayD+f3RhXUTnsGRYEnkiJ7Ncr0whqowqujvU+VJiSJx0xrtg@mail.gmail.com>
Subject: Re: [PATCH v11 10/13] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
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

On Mon, Apr 5, 2021 at 7:30 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> feature.
>
> MSR is handled by userspace using MSR filters.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     |  5 +++++
>  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
>  arch/x86/kvm/cpuid.c                 |  3 ++-
>  arch/x86/kvm/svm/svm.c               | 22 ++++++++++++++++++++++
>  5 files changed, 45 insertions(+), 1 deletion(-)
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
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6bd2f8b830e4..4e2e69a692aa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                              (1 << KVM_FEATURE_PV_SEND_IPI) |
>                              (1 << KVM_FEATURE_POLL_CONTROL) |
>                              (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> -                            (1 << KVM_FEATURE_ASYNC_PF_INT);
> +                            (1 << KVM_FEATURE_ASYNC_PF_INT) |
> +                            (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
>
>                 if (sched_info_on())
>                         entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3cbf000beff1..1ac79e2f2a6c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2800,6 +2800,17 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case MSR_F10H_DECFG:
>                 msr_info->data = svm->msr_decfg;
>                 break;
> +       case MSR_KVM_SEV_LIVE_MIGRATION:
> +               if (!sev_guest(vcpu->kvm))
> +                       return 1;
> +
> +               if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
> +                       return 1;
> +
> +               /*
> +                * Let userspace handle the MSR using MSR filters.
> +                */
> +               return KVM_MSR_RET_FILTERED;
>         default:
>                 return kvm_get_msr_common(vcpu, msr_info);
>         }
> @@ -2996,6 +3007,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 svm->msr_decfg = data;
>                 break;
>         }
> +       case MSR_KVM_SEV_LIVE_MIGRATION:
> +               if (!sev_guest(vcpu->kvm))
> +                       return 1;
> +
> +               if (!guest_cpuid_has(vcpu, KVM_FEATURE_SEV_LIVE_MIGRATION))
> +                       return 1;
> +
> +               /*
> +                * Let userspace handle the MSR using MSR filters.
> +                */
> +               return KVM_MSR_RET_FILTERED;

It's a little unintuitive to see KVM_MSR_RET_FILTERED here, since
userspace can make this happen on its own without having an entry in
this switch statement (by setting it in the msr filter bitmaps). When
using MSR filters, I would only expect to get MSR filter exits for
MSRs I specifically asked for.

Not a huge deal, just a little unintuitive. I'm not sure other options
are much better (you could put KVM_MSR_RET_INVALID, or you could just
not have these entries in svm_{get,set}_msr).


--Steve
