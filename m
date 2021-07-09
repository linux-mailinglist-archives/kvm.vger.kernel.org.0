Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228263C2A6A
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhGIUib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 16:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGIUib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 16:38:31 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02483C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 13:35:47 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u11so13756218oiv.1
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHHhyfCEkW/Vi1HiAXRAzBDCaqb5jnujVXbqXt6B/VI=;
        b=QBAo5MrAzeb+QjdnVM+fmnW1p7a8EJaQumd0VGQeb8KCkDetUWM1EvEaTgEfhpIZVQ
         PuD4ss+l6YpCGpcPMojzvU60kJB5+bEHC4suvelLBwX2x40IE0ABrAcDmCNMFy16hcYQ
         knCM5AWV0Op7FTMN9qaT97LNFHcTnKOLrFJpqL26hENd0UDXTL19Y1jbSho/Cq38SpPZ
         b4O92u7O0Ee4iqGnUfoeJkwYdM3HZlFIVyVQVlROigLaYcalSa1Ymze3DHdQo3tVvw9W
         cvgU7RWXFXl5dPtv4SFB94N5RaSx7GRLGsbScr4Z95gzvQr52CrixacaGDujxJerv1Uq
         xPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHHhyfCEkW/Vi1HiAXRAzBDCaqb5jnujVXbqXt6B/VI=;
        b=Hc5cVO9CHELwzM29hVnfAwQ3SRCQiizUbL3ccphpbRmq/ZglyM75vhb3SncOrojnJb
         eosWG8grV43cEKGsYj3Dd8l7JRWUSVRYCd8cMyOKhfkakQv1vyJ4Go/iHNfZsrZX6Gt7
         jVWdgh9GOHNL+Mg7VD0TrOIo3amUS9APddHWtGGA2wigp9aqZ/YXwW2ubAfEHQ4ArajA
         akx/TjS4tjpXGHnvc2PLnEVjgCDYtUGCC2b3Nd1ze12pzS6NhUnmMXw/yKdUkgXG74cX
         Rz6+ioiZsfdkxNloPnMFlRmja6NJBe8EM32u/oCUaT1xmM7jVYGWQN7EbTL3FkRKLm5A
         qCoA==
X-Gm-Message-State: AOAM533fhE64qt/tmKZWAlZ7nUJ8ErQdI0FfRS4G5S7JzSG6V/OmJJ1e
        ivoc5bPyUvpbuuoeae0xiuqK0hf5zRDPzJzf6+jyTA==
X-Google-Smtp-Source: ABdhPJzayDEww+4shroJsd3DihWck//F1i010OrV/1OXo/8pneLuwkfxzMR5eKSwVek9gvCLe2W9VqCbqA7PQP/apCI=
X-Received: by 2002:a05:6808:355:: with SMTP id j21mr618879oie.13.1625862945597;
 Fri, 09 Jul 2021 13:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com> <1625825111-6604-5-git-send-email-weijiang.yang@intel.com>
In-Reply-To: <1625825111-6604-5-git-send-email-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 13:35:34 -0700
Message-ID: <CALMp9eQveWT=5fzRe_T6BaDbgpeP+kvxBfWmooEPscqcT8KvBg@mail.gmail.com>
Subject: Re: [PATCH v5 04/13] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> From: Like Xu <like.xu@linux.intel.com>
>
> The number of Arch LBR entries available is determined by the value
> in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> supported.
>
> On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> KVM emulates the reset behavior by introducing lbr_desc->arch_lbr_reset.
> KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> (this is safe because the two values will be the same) when the Arch LBR
> records MSRs are pass-through to the guest.
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---

> @@ -393,6 +417,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>         struct kvm_pmc *pmc;
> +       struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>         u32 msr = msr_info->index;
>         u64 data = msr_info->data;
>
> @@ -427,6 +452,12 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                         return 0;
>                 }
>                 break;
> +       case MSR_ARCH_LBR_DEPTH:
> +               if (!arch_lbr_depth_is_valid(vcpu, data))
> +                       return 1;

Does this imply that, when restoring a vCPU, KVM_SET_CPUID2 must be
called before KVM_SET_MSRS, so that arch_lbr_depth_is_valid() knows
what to do? Is this documented anywhere?

> +               lbr_desc->records.nr = data;
> +               lbr_desc->arch_lbr_reset = true;

Doesn't this make it impossible to restore vCPU state, since the LBRs
will be reset on the next VM-entry? At the very least, you probably
shouldn't set arch_lbr_reset when the MSR write is host-initiated.

However, there is another problem: arch_lbr_reset isn't serialized
anywhere. If you fix the host-initiated issue, then you still have a
problem if the last guest instruction prior to suspending the vCPU was
a write to IA32_LBR_DEPTH. If there is no subsequent VM-entry prior to
saving the vCPU state, then the LBRs will be saved/restored as part of
the guest XSAVE state, and they will not get cleared on resuming the
vCPU.

> +               return 0;
>         default:
>                 if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>                     (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -566,6 +597,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>         lbr_desc->records.nr = 0;
>         lbr_desc->event = NULL;
>         lbr_desc->msr_passthrough = false;
> +       lbr_desc->arch_lbr_reset = false;

I'm not sure this is entirely correct. If the last guest instruction
prior to a warm reset was a write to IA32_LBR_DEPTH, then the LBRs
should be cleared (and arch_lbr_reset will be true). However, if you
clear that flag here, the LBRs will never get cleared.

>  }
>
