Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92F2A7766
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 07:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgKEGO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 01:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgKEGOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 01:14:52 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315FBC0613D2;
        Wed,  4 Nov 2020 22:14:52 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n129so658426iod.5;
        Wed, 04 Nov 2020 22:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=effOrioQNE1vajsHCexkvnssUb5VjgqMIBeIbqbweW0=;
        b=reLLABWv8oBwgzXdQvGaPjfoWs0iLQHMy8Lmvd50vLavFYVxBbIOKw+/rudOj31OFM
         k/0XneJcXCxdc37THbeUCv8SWWkNxwsea7YVLBJVcBax4axSHMytbLspNOkFZV7h0ta2
         UIy4b7SGVokWDhBmKx1GvV7cEyK6xW2DCqR2e5oCb7Ow6v1CAjPWsorRcK02JY//r3C+
         KaEJWxCdcrRaxP3ZDh5g/k9SAThESgMdxiCMSo907gVGxcnpHbGrmw7YjFVGn2TUdgZ4
         3+iht6MiwPKnALkkVDeSIcPXVmx7VlZz11HgfrOL/A3FQqlklfxKbqRP+ZIX5wS46a/N
         s8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=effOrioQNE1vajsHCexkvnssUb5VjgqMIBeIbqbweW0=;
        b=LA1PUEKjFlj6bg6oCuwUOmOQZpAnhyhN21QWfgkq3Ipfukm/UyQp1wQq5iEqomLUZg
         OJPtKcnCq7VT3wjGQ4C46DOi/S3+ErxVcMkxxe2NHHNB5BIb0czLOAyXfh23HHrt8m+Y
         kI7v6mpfJkANeimeH5z7ULn4slxZ4cr33ZlMFRqzkDwJn736DGj0F9IoHVsUO5os0YIR
         vsfYaa49G5z+t+Da45Y1d8jL/FEXgnCT6zOfARPSncPSLPZq5dkSgFZHBIkOH3mBnkGZ
         /piU1lpLW9SEmpYiexlwZ3sc/U4/BdFCDrHxRsrVYQgYLUFA/LP1wKCdo8p4pVIoQ2VC
         mxwg==
X-Gm-Message-State: AOAM530N4ZYSXVynlYbWcWx8YJ8S7ppiunXVTk/CwlTu/qmRxqnM7DJa
        jHquW3f5nwTSGl62NPpAEB0+BYw+Q0WXlAe6KHI=
X-Google-Smtp-Source: ABdhPJxuT/21iy+We+9FUZuZafk4UqfzPqItuvnr3wqiwYFj/17TCCDMk+NpsTv9/XG5o0XP531PZW7dSoKjAqpjVSs=
X-Received: by 2002:a02:5b09:: with SMTP id g9mr847501jab.89.1604556891487;
 Wed, 04 Nov 2020 22:14:51 -0800 (PST)
MIME-Version: 1.0
References: <20201101115523.115780-1-mlevitsk@redhat.com>
In-Reply-To: <20201101115523.115780-1-mlevitsk@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 5 Nov 2020 07:14:40 +0100
Message-ID: <CAM9Jb+ivbM-_8ht9w2JptoHH-64=J_TvdLvm0Re+KAAuPeeGfg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: use positive error values for msr emulation
 that causes #GP
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Qian Cai <cai@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Recent introduction of the userspace msr filtering added code that uses
> negative error codes for cases that result in either #GP delivery to
> the guest, or handled by the userspace msr filtering.
>
> This breaks an assumption that a negative error code returned from the
> msr emulation code is a semi-fatal error which should be returned
> to userspace via KVM_RUN ioctl and usually kill the guest.
>
> Fix this by reusing the already existing KVM_MSR_RET_INVALID error code,
> and by adding a new KVM_MSR_RET_FILTERED error code for the
> userspace filtered msrs.
>
> Fixes: 291f35fb2c1d1 ("KVM: x86: report negative values from wrmsr emulation to userspace")
> Reported-by: Qian Cai <cai@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 29 +++++++++++++++--------------
>  arch/x86/kvm/x86.h |  8 +++++++-
>  2 files changed, 22 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 397f599b20e5a..537130d78b2af 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -255,11 +255,10 @@ static struct kmem_cache *x86_emulator_cache;
>
>  /*
>   * When called, it means the previous get/set msr reached an invalid msr.
> - * Return 0 if we want to ignore/silent this failed msr access, or 1 if we want
> - * to fail the caller.
> + * Return true if we want to ignore/silent this failed msr access.
>   */
> -static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> -                                u64 data, bool write)
> +static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> +                                 u64 data, bool write)
>  {
>         const char *op = write ? "wrmsr" : "rdmsr";
>
> @@ -267,12 +266,11 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
>                 if (report_ignored_msrs)
>                         vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
>                                     op, msr, data);
> -               /* Mask the error */
> -               return 0;
> +               return true;
>         } else {
>                 vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
>                                        op, msr, data);
> -               return -ENOENT;
> +               return false;
>         }
>  }
>
> @@ -1416,7 +1414,8 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>         if (r == KVM_MSR_RET_INVALID) {
>                 /* Unconditionally clear the output for simplicity */
>                 *data = 0;
> -               r = kvm_msr_ignored_check(vcpu, index, 0, false);
> +               if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +                       r = 0;
>         }
>
>         if (r)
> @@ -1540,7 +1539,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>         struct msr_data msr;
>
>         if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
> -               return -EPERM;
> +               return KVM_MSR_RET_FILTERED;
>
>         switch (index) {
>         case MSR_FS_BASE:
> @@ -1581,7 +1580,8 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
>         int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
>
>         if (ret == KVM_MSR_RET_INVALID)
> -               ret = kvm_msr_ignored_check(vcpu, index, data, true);
> +               if (kvm_msr_ignored_check(vcpu, index, data, true))
> +                       ret = 0;
>
>         return ret;
>  }
> @@ -1599,7 +1599,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>         int ret;
>
>         if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
> -               return -EPERM;
> +               return KVM_MSR_RET_FILTERED;
>
>         msr.index = index;
>         msr.host_initiated = host_initiated;
> @@ -1618,7 +1618,8 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>         if (ret == KVM_MSR_RET_INVALID) {
>                 /* Unconditionally clear *data for simplicity */
>                 *data = 0;
> -               ret = kvm_msr_ignored_check(vcpu, index, 0, false);
> +               if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +                       ret = 0;
>         }
>
>         return ret;
> @@ -1662,9 +1663,9 @@ static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
>  static u64 kvm_msr_reason(int r)
>  {
>         switch (r) {
> -       case -ENOENT:
> +       case KVM_MSR_RET_INVALID:
>                 return KVM_MSR_EXIT_REASON_UNKNOWN;
> -       case -EPERM:
> +       case KVM_MSR_RET_FILTERED:
>                 return KVM_MSR_EXIT_REASON_FILTER;
>         default:
>                 return KVM_MSR_EXIT_REASON_INVAL;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3900ab0c6004d..e7ca622a468f5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -376,7 +376,13 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>  int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
>  bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>
> -#define  KVM_MSR_RET_INVALID  2
> +/*
> + * Internal error codes that are used to indicate that MSR emulation encountered
> + * an error that should result in #GP in the guest, unless userspace
> + * handles it.
> + */
> +#define  KVM_MSR_RET_INVALID   2       /* in-kernel MSR emulation #GP condition */
> +#define  KVM_MSR_RET_FILTERED  3       /* #GP due to userspace MSR filter */
>
>  #define __cr4_reserved_bits(__cpu_has, __c)             \
>  ({                                                      \

This looks good to me. This should solve "-EPERM" return by "__kvm_set_msr" .

A question I have, In the case of "kvm_emulate_rdmsr()",  for "r" we
are injecting #GP.
Is there any possibility of this check to be hit and still result in #GP?

int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
{
       ....
        r = kvm_get_msr(vcpu, ecx, &data);

        /* MSR read failed? See if we should ask user space */
        if (r && kvm_get_msr_user_space(vcpu, ecx, r)) {
                /* Bounce to user space */
                return 0;
        }

        /* MSR read failed? Inject a #GP */
        if (r) {
                trace_kvm_msr_read_ex(ecx);
                kvm_inject_gp(vcpu, 0);
                return 1;
        }
    ....
}

Apart from the question above, feel free to add:
Reviewed-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
