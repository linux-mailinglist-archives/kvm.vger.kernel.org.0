Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F9035AC1
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfFEK7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:59:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41450 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEK7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:59:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id 107so296454otj.8;
        Wed, 05 Jun 2019 03:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1TtCwBfFQyXH/AsYB9gz6ChIKS/EqRpApjVyf81CS/g=;
        b=D2mv7v7hNMhlC9bMraAxG/He3p9EsUtRxsdsqeYIbbCxi9Dcy+kNWf8mJfHCxM7uL+
         svJBNa9wykvm1h6CM/4MzRA2ldCJfJmfnWvyXZxl/o1lUurDplWMXuoChk+Xi/pbbNyS
         DK5WiCLPeniOcMyMLPTvh3TvfQYThXhZsBkkp7lV/M4kpDw7vpazE4i3TUm67dGMSgJ1
         LQzBrNcmgV+EJCVqZby5FmlWCKh0Vt+EJsMvGTq5IZM2Nxuq/DepBdy30iUkWtifSiY1
         FPvDYu7Q+OkHMmURwsMbsLXgLj3+9Xjpba8dpaTWDjCk7TNr47Yb8Dql/p0VtOBrv6z1
         ah5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1TtCwBfFQyXH/AsYB9gz6ChIKS/EqRpApjVyf81CS/g=;
        b=QD4QRohOA43Rlz/Qr+lfcBEQyoJt+l5DBLIkDAlIVyMp0zk5UQ5rGYVYss4/adNgMR
         hzCC17G6TwnEfL6eK8o05DHt8LXnhD3+YzXmouYvq1JzvqO1pEqKYGQkmfGQz5knWOGH
         jMvcx1X78K1WlBbUJS09K71uar40fBnMQkzPFB6yOBNVuKOp3d9Fx8fpSWyGeoilk3+P
         qmZjObLHxJgXbM2+yzCfEcmOoyCHX2gYzTbTXF36UFNnCzjvnVT92Vu0WROiVKpopQca
         w+WgsdXR162RGN2g1XNE9TIXRfBYL927bO7sO7qyjzNCTJIIHTy7aufatqzz77fQEmPf
         IQgQ==
X-Gm-Message-State: APjAAAWyBuEzp0B79Bte9EaiP7cPFckWiVFYoa/bO0BfrYOcC0Z2E+Rl
        YVYtwCZMOpfBDW2s8VqVHBKAgN2jOcco9x5cThg=
X-Google-Smtp-Source: APXvYqwQE4ag1aM6TUkGURtCIXQYTok7BQJnPWzUcNd6HQ4Zi0w5zXKIhcOyHknnj9LeSh4MJFyZ++ZnbVOeWAy0WHg=
X-Received: by 2002:a9d:6f05:: with SMTP id n5mr3011494otq.56.1559732384717;
 Wed, 05 Jun 2019 03:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-3-git-send-email-wanpengli@tencent.com> <501ef28f-7463-7f49-c219-1c3fdd8cc476@redhat.com>
In-Reply-To: <501ef28f-7463-7f49-c219-1c3fdd8cc476@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 5 Jun 2019 19:00:10 +0800
Message-ID: <CANRm+Czco7J1M2gskwgqjtbxcD+R5SkGx_2Lbfi=Z3yQZRwBkQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Emulate MSR_IA32_MISC_ENABLE MWAIT bit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Jun 2019 at 00:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/05/19 08:06, Wanpeng Li wrote:
> >
> > The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit,
> > CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
> > kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
> > guest visibility.
>
> This needs some adjustment so that the default is backwards-compatible:
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index e3ae96b52a16..f9b021e16ebc 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -378,11 +378,11 @@ struct kvm_sync_regs {
>         struct kvm_vcpu_events events;
>  };
>
> -#define KVM_X86_QUIRK_LINT0_REENABLED  (1 << 0)
> -#define KVM_X86_QUIRK_CD_NW_CLEARED    (1 << 1)
> -#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE  (1 << 2)
> -#define KVM_X86_QUIRK_OUT_7E_INC_RIP   (1 << 3)
> -#define KVM_X86_QUIRK_MISC_ENABLE_MWAIT (1 << 4)
> +#define KVM_X86_QUIRK_LINT0_REENABLED     (1 << 0)
> +#define KVM_X86_QUIRK_CD_NW_CLEARED       (1 << 1)
> +#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE     (1 << 2)
> +#define KVM_X86_QUIRK_OUT_7E_INC_RIP      (1 << 3)
> +#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
>
>  #define KVM_STATE_NESTED_GUEST_MODE    0x00000001
>  #define KVM_STATE_NESTED_RUN_PENDING   0x00000002
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f54d266fd3b5..bfa1341ce6f1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -137,10 +137,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>                 (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>                 best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>
> -       if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT)) {
> +       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>                 best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
>                 if (best) {
> -                       if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT)
> +                       if (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_NO_MWAIT)
>                                 best->ecx |= F(MWAIT);
>                         else
>                                 best->ecx &= ~F(MWAIT);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 528935733fe0..0c1498da46c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2548,17 +2548,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 }
>                 break;
>         case MSR_IA32_MISC_ENABLE:
> -               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_MWAIT) &&
> -                       ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
> -                       if ((vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT) &&
> -                               !(data & MSR_IA32_MISC_ENABLE_MWAIT)) {
> -                               if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> -                                       return 1;
> -                       }
> +               if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
> +                   ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_NO_MWAIT)) {
> +                       if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> +                               return 1;
>                         vcpu->arch.ia32_misc_enable_msr = data;
>                         kvm_update_cpuid(vcpu);
> +               } else {
> +                       vcpu->arch.ia32_misc_enable_msr = data;
>                 }
> -               vcpu->arch.ia32_misc_enable_msr = data;
>                 break;
>         case MSR_IA32_SMBASE:
>                 if (!msr_info->host_initiated)
>
> Please double check, in the meanwhile I've queued the patch.

Looks good to me, thanks. :)

Regards,
Wanpeng Li
