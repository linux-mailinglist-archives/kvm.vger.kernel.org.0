Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85935D443
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbhDMAFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239502AbhDMAFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:05:30 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C78C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:09 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b17so12608377ilh.6
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbLoFUpoxerbXfuk2REVmj1RRI8UwcgqsaxvxzI7hpw=;
        b=cH6M00A/hS5cg68oevSxPkKfKG7PoZAmIKU+FYlK1ynBNBCjpe2EkboP42tCoQyZaa
         uhtau93gk3xG+REnWcl6csQ92Fi3HEVPOTUWGBRT4aGSe03IQoXIcMjMQrrw/RhnyryC
         lViirhY+X76K1WuZTGCSc87rbRtKQfu9vOYCYrL3pI9Kslvw8QVuPv14reDNge/QF3pV
         P6Wd1jNulcX5yiuREpObRVBofo+eJ6X9f666bBrWDr6D8xVSnFw85O08XY5i5bkEEo67
         Ds2V33CpE4GSk/S6NsM49sH2ba0OyUDRbJqx5tiMgtp1xoAZZUQpi8iBIuGbia5iZNTU
         Dqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbLoFUpoxerbXfuk2REVmj1RRI8UwcgqsaxvxzI7hpw=;
        b=qHggZvIPhChMz4rh12Gffij1QZUrNW5dWXJjMeZrTfoxBFzgYsj8KT3z7owsg9ERAE
         VgRyc0SEUCgRJ3DeRUT1jG8ilIteWh6NooLu8bmLRzm4m50dRLFu9ATHADd37rEZveCW
         I5Z6hMyC5IgYnZYVHy+hmtqlWS2BV2tTa2pNNJ3Zu7Nwk6njqVx521xELtJPkEf5RNr+
         dSJgI6hv8mCG86dMvCFfcA9JCf9RNI7VoYI8u/zMXNbl3F1lPSO1WcHRa1sIZjgFugyW
         DRaxUbcmGRtpFNC5Bd7BMXvLmqF2nRkISeQTAocZIkf3fZyi/dh2YDC430wkm5raY8g0
         kEiw==
X-Gm-Message-State: AOAM531ZCjpq9EEFpbU2Mt1eAMdV9T/ngRt3JZO5oztkHHRCTydgbslG
        zMkXU6ckjYi0fbE1QvXu+pfU7aEWCjZu+d/nNI3efg==
X-Google-Smtp-Source: ABdhPJzaSPc8kah7NjLxLNlk20ABmq2QETcJfTvvVfrco19YKAPKYHF5kaQ7ON3bozf2W/gIa+O2DLB7jXW4fbKm1Ak=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr25429324ila.176.1618272309261;
 Mon, 12 Apr 2021 17:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <3232806199b2f4b307d28f6fd4f756d487b4e482.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <3232806199b2f4b307d28f6fd4f756d487b4e482.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:04:33 -0700
Message-ID: <CABayD+fX516CLTPDW7xkRZoVEWWLFE1jNL8n-O7KxUhmcRGTfQ@mail.gmail.com>
Subject: Re: [PATCH v12 10/13] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
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

On Mon, Apr 12, 2021 at 12:46 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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
>  4 files changed, 23 insertions(+), 1 deletion(-)
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
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
