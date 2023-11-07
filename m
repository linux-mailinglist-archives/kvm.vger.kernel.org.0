Return-Path: <kvm+bounces-1064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0887E497D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FA99280DC1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5DD36B12;
	Tue,  7 Nov 2023 19:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yFOXsXQ+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A936AED
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 19:59:52 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED081D79
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 11:59:51 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so2947a12.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 11:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699387190; x=1699991990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+aCF6ULDMg/XOjHyxbeWWkePu+REPLzYwpuMpkko7I=;
        b=yFOXsXQ+y0AvUobGlI5pqwSY65lvAixWHMPnRsTtdUxAw9kYZM0pUHZoZ6mNXMtLyi
         Mce9qGyBf02J6izJYbKhB/n9qY/GrOAAA/PZh4bCYmCVrD0U5Nei5ye3tOmOUDpymYcC
         yVdLrFlTRTAvtDWzPQvcf3rhn9RGbOVzMVTParSRqZ6Jq9RHiwJ1TgQ7AN3DU9x4cHON
         +XsN6OfCkSR0sp/K2Is7OQeCHGsjIQ8pLvuROPdMkeZT2mBkUozrQgKRSDO+p/bXD5NC
         mlK0FtIVvbDDGPaH7rDsna+7unBA1vQp061l7FyWG35umjQnui7LH+nM32OEKPsnqCa2
         BrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699387190; x=1699991990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+aCF6ULDMg/XOjHyxbeWWkePu+REPLzYwpuMpkko7I=;
        b=JFH680be8f6P9tj69vB6QywFCPl3KSSEYWvzAjT/vGcCu01H0JHRMyvfRHCoVx4HUu
         6oFSZN4oEM0aHEpf936Zq3ILV11vc3mL8EVdwgu9us3Uy4ik+6dEe7eCGWwUN1YY5/Im
         cA1AB2trA7TY3rrrjmcuXp0rqMKpwuugCrIfrAKFLceb5zlIpncUrQI3UHQiSDrp0L8c
         oealVy7fyQzQWeH5X0uRB0g9kF9hBHFY91ZF8Xu0GdKeSbEobjaQhNMteRFwZ3SqR7iQ
         0ugynx/xBmYJM6dOmfwrgKdLPGchKd1WskIIaWYKWPdt1H/By2IJGve8bmY2CGsmTZzU
         kQkA==
X-Gm-Message-State: AOJu0YzleVTrJji2LCHRkOEze+P4JCjfQDZ3TljgXxkJKHiXAW5yFVS4
	7eatlcTR5FnEhQf7EM38l83n8bIyKm1re82pnRwkYDu9wHfje/Yj4cp2Rg==
X-Google-Smtp-Source: AGHT+IH7BAVJnd9DnBGdZzH7qdTmTHkZHgjHoGwbTfKaLJVMNtKduWpbzOakXWM323cR6oOspubsW00/4+AG4z8+M20=
X-Received: by 2002:a05:6402:528e:b0:544:e37e:d597 with SMTP id
 en14-20020a056402528e00b00544e37ed597mr157454edb.7.1699387190260; Tue, 07 Nov
 2023 11:59:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699383993.git.isaku.yamahata@intel.com> <70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata@intel.com>
In-Reply-To: <70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 7 Nov 2023 11:59:35 -0800
Message-ID: <CALMp9eTG8CbWZaDumKsBsr0qQgrre-_=Fn5jzs7GqHB+MZ-E_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: X86: Add a capability to configure bus frequency
 for APIC timer
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 11:24=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
> KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
Nit: FREQUENCY
> frequency.  When using this capability, the user space VMM should configu=
re
> CPUID[0x15] to advertise the frequency.

Is it necessary to advertise the frequency in CPUID.15H? No hardware
that I know of has a 1 GHz crystal clock, but the current
implementation works fine without CPUID.15H.

> TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
> x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
Nit: frequency
> causes the vAPIC timer to fire earlier than the guest expects. [1] The KV=
M
> APIC timer emulation uses hrtimer, whose unit is nanosecond.  Make the
> parameter configurable for conversion from the TMICT value to nanosecond.
>
> This patch doesn't affect the TSC deadline timer emulation.  The TSC
> deadline emulation path records its expiring TSC value and calculates the
> expiring time in nanoseconds.  The APIC timer emulation path calculates t=
he
> TSC value from the TMICT register value and uses the TSC deadline timer
> path.  This patch touches the APIC timer-specific code but doesn't touch
> common logic.
>
> [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@goog=
le.com/
> Reported-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/x86.c       | 14 ++++++++++++++
>  include/uapi/linux/kvm.h |  1 +
>  2 files changed, 15 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a9f4991b3e2e..20849d2cd0e8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>         case KVM_CAP_ENABLE_CAP:
>         case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>         case KVM_CAP_IRQFD_RESAMPLE:
> +       case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:

This capability should be documented in Documentation/virtual/kvm/api.txt.

>                 r =3D 1;
>                 break;
>         case KVM_CAP_EXIT_HYPERCALL:
> @@ -6616,6 +6617,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
> +       case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
> +               u64 bus_frequency =3D cap->args[0];
> +               u64 bus_cycle_ns;
> +

To avoid potentially bizarre behavior, perhaps we should disallow
changing the APIC bus frequency once a vCPU has been created?

> +               if (!bus_frequency)
> +                       return -EINVAL;
> +               bus_cycle_ns =3D 1000000000UL / bus_frequency;
> +               if (!bus_cycle_ns)
> +                       return -EINVAL;
> +               kvm->arch.apic_bus_cycle_ns =3D bus_cycle_ns;
> +               kvm->arch.apic_bus_frequency =3D bus_frequency;
> +               return 0;

Should this be disallowed if !lapic_in_kernel?

> +       }
>         default:
>                 r =3D -EINVAL;
>                 break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 211b86de35ac..d74a057df173 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1201,6 +1201,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
>  #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
>  #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
> +#define KVM_CAP_X86_BUS_FREQUENCY_CONTROL 231
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> --
> 2.25.1
>
>

