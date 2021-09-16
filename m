Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37040D120
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 03:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhIPBRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 21:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhIPBRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 21:17:38 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9A4C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 18:16:18 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id q14so5007718ils.5
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 18:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLpPuYBBwu6jhlHfdJjEr/EV1Gc0Mpugp36hBO202rY=;
        b=hOuiFgqepHLEJU0JVNWirieRfpQ++zd4t85VqYPfUx6Vnfd8eG6BIvaRIHMfh4cRuS
         6itBrYCbYj7kKtG1+MkAD1fmWvhgcWj+c9t1JxJOTW4PqP/93PWMv8Dz8xzVD35N9y7k
         k+ls3nh9hyYP0Wgzi47E2sw9/xreDIDXXH7F1EGCqmm05ZiRtrx2a4lrqo5fCSnwC0f2
         0q/swfScp5mHRxvC29Po/62pYPtnO54M+mQSfzpaIYznRe89+CLhXmSlEI5t4SRRrS/F
         xZvS57Yh5vsWj3Ie3DLwUPRzbyAnpR8sAzvbJS5+t4JHyQe7FP7KlB9O5fotGMYUnyiE
         LG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLpPuYBBwu6jhlHfdJjEr/EV1Gc0Mpugp36hBO202rY=;
        b=NEy9x+5CqOX750tnS/BNZbiuv3t0F2XypUulI4Bx4L5emR+Ycs0GDls6pN0zX9J51K
         5hoBasYkeDRE6jnRNpw325UNeh3XHc2zMtJZjDlvvLYxKM9GnqgIpRPj3l3tNuDd3hQj
         kH8OiUDcIbMCOtfzQhRUIUyBatDTff+8GL5L+Pir1UVYXlUGWBHy9v0cltlFLHOYDtFg
         CfzAjMY3jctutHtS4zsJjrwyW2y/xcEnvW+7/2AVWUjujr1kgkNkjPpG4egzBDmXIAbV
         Wmkvdp3Vc5nTX0TvRWHXeo89iJuWbEuY2PcigrAnywunHoVGYXphsBVVvWmsnV9hCFII
         8FrA==
X-Gm-Message-State: AOAM5302XYspz3Du82t3eCZbehKp2m7qt7SOaG8n8kdQF1JJEFz/QHV3
        psPsQuNGe7Fk7IKGn6j1XXKhjII71/H6U+Md6VSIBg==
X-Google-Smtp-Source: ABdhPJwtEj56I6eqqZdp7QARgE4ulencEwVudq7Qz+Pk/x4XkBXCfojyXtUnz182/auTlKOb6M+d1/WiyTs1dTJoMxk=
X-Received: by 2002:a92:a307:: with SMTP id a7mr2109622ili.308.1631754977880;
 Wed, 15 Sep 2021 18:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629726117.git.ashish.kalra@amd.com> <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
In-Reply-To: <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 15 Sep 2021 18:15:41 -0700
Message-ID: <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
To:     Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com,
        dovmurik@linux.ibm.com, tobin@linux.ibm.com, jejb@linux.ibm.com,
        dgilbert@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 4:04 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative() is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
>
> To highlight the need to provide this interface, capturing the
> flow of apply_alternatives() :
> setup_arch() call init_hypervisor_platform() which detects
> the hypervisor platform the kernel is running under and then the
> hypervisor specific initialization code can make early hypercalls.
> For example, KVM specific initialization in case of SEV will try
> to mark the "__bss_decrypted" section's encryption state via early
> page encryption status hypercalls.
>
> Now, apply_alternatives() is called much later when setup_arch()
> calls check_bugs(), so we do need some kind of an early,
> pre-alternatives hypercall interface. Other cases of pre-alternatives
> hypercalls include marking per-cpu GHCB pages as decrypted on SEV-ES
> and per-cpu apf_reason, steal_time and kvm_apic_eoi as decrypted for
> SEV generally.
>
> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> will be used by the SEV guest to notify encrypted pages to the hypervisor.
>
> This kvm_sev_hypercall3() function is abstracted and used as follows :
> All these early hypercalls are made through early_set_memory_XX() interfaces,
> which in turn invoke pv_ops (paravirt_ops).
>
> This early_set_memory_XX() -> pv_ops.mmu.notify_page_enc_status_changed()
> is a generic interface and can easily have SEV, TDX and any other
> future platform specific abstractions added to it.
>
> Currently, pv_ops.mmu.notify_page_enc_status_changed() callback is setup to
> invoke kvm_sev_hypercall3() in case of SEV.
>
> Similarly, in case of TDX, pv_ops.mmu.notify_page_enc_status_changed()
> can be setup to a TDX specific callback.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 69299878b200..56935ebb1dfe 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -83,6 +83,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>         return ret;
>  }
>
> +static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
> +                                     unsigned long p2, unsigned long p3)
> +{
> +       long ret;
> +
> +       asm volatile("vmmcall"
> +                    : "=a"(ret)
> +                    : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
> +                    : "memory");
> +       return ret;
> +}
> +
>  #ifdef CONFIG_KVM_GUEST
>  void kvmclock_init(void);
>  void kvmclock_disable(void);
> --
> 2.17.1
>

Looking at these threads, this patch either:
1) Needs review/approval from a maintainer that is interested or
2) Should flip back to using alternative (as suggested by Sean). In
particular: `ALTERNATIVE("vmmcall", "vmcall",
ALT_NOT(X86_FEATURE_VMMCALL))`. My understanding is that the advantage
of this is that (after calling apply alternatives) you get exactly the
same behavior as before. But before apply alternatives, you get the
desired flipped behavior. The previous patch changed the behavior
after apply alternatives in a very slight manner (if feature flags
were not set, you'd get a different instruction).

I personally don't have strong feelings on this decision, but this
decision does need to be made for this patch series to move forward.

I'd also be curious to hear Sean's opinion on this since he was vocal
about this previously.

Thanks,
Steve
