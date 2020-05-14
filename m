Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9CC1D2908
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgENHqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgENHqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 03:46:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A9DC061A0C;
        Thu, 14 May 2020 00:46:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so2525098wrc.11;
        Thu, 14 May 2020 00:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tnd5gyBZ9btP76ArX3oPZn4dZo4wDUjakdTvDBeGETY=;
        b=HO/94Vz7T2TIY9RkH/u2EWXDgx59uk8EB72AM1s6M1B3xvvtnwHNvvChnovJ2GyJ7H
         tExXTE0oQl3+SNaEuGL33VrHofRYn3gA1Ire8FwL97xeK/hd7X7SC/aWYtawkGzsvE83
         tbdzkBs1EHXc1uBmRuK+ZxzR98Vemw5vaCTelzs7QPUZtr53kUdCkBnIRw/fDIdPVZMh
         iSAicC2wj2TmgSQeyhPJeaFBNlxMlcFzVI611CgYwe/h0aayear1TveXlbClCJsAQBe+
         IIB1OdmvFoulxy7WE75W09d1fUU9r5qcwxd5XnZWHp985tPl7pm6v58LE1gLS9GD9hSJ
         Iptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tnd5gyBZ9btP76ArX3oPZn4dZo4wDUjakdTvDBeGETY=;
        b=bzwMV+FTEnzmMshvexBiBAtR6j5mWZu5rWEiUC2iPN3Y08BNaJ6IiWZO+zwRhCnbdL
         3xx0mRuCFLHEs6OhrfJOxbKpv7jW1ONfvuQNDFfx/fBqLTDXLKscM1InjRNb3S18dNMz
         dW3QFppbyr/2Haibp5/m/eDHkLybATsz6EcTKHCgmKg+YXYOd5o7HZgvvoouCb76Aq9+
         YOypuqp23/Z1Ft8qwgSezr57m/Y11EdqQIQEfB2K1AVeeGJVqwvz+1iEqav5tquZoZUd
         cX9nMbySQl9HFRwaEosY1S2pCbumXxd2A77rffPaQys/mHbBXrS8k2FkNYX7E+GCrx0H
         FFJg==
X-Gm-Message-State: AOAM533iZvwiREDe4D3Z5OHc2Y+U4j+PCWtdj5duk70ffEIMoctJxBVE
        Nqviluq8T+r0WgLO9qqE7vdIyMn5AbQs3F+cGTk=
X-Google-Smtp-Source: ABdhPJyL0ocZWzSrFbdfvJdVqXshBzbvQF5ntcAt2V2dzVIB06b9qQUw4+w6MkW0XWfYARdB0eDDvtevnroR2Yc5eEY=
X-Received: by 2002:a5d:4e41:: with SMTP id r1mr2785707wrt.420.1589442412484;
 Thu, 14 May 2020 00:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com> <1589359366-1669-15-git-send-email-chenhc@lemote.com>
In-Reply-To: <1589359366-1669-15-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 14 May 2020 09:46:39 +0200
Message-ID: <CAHiYmc5Pd+QGGeVCtmFeGYCCGEuSmS7jBrvGREyBtZ=nMxqt7g@mail.gmail.com>
Subject: Re: [PATCH V5 14/15] KVM: MIPS: Enable KVM support for Loongson-3
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D1=81=D1=80=D0=B5, 13. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:48 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> This patch enable KVM support for Loongson-3 by selecting HAVE_KVM, but
> only enable KVM/VZ on Loongson-3A R4+ (because VZ of early processors
> are incomplete). Besides, Loongson-3 support SMP guests, so we clear the
> linked load bit of LLAddr in kvm_vz_vcpu_load() if the guest has more
> than one VCPUs.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>

>  arch/mips/Kconfig            | 1 +
>  arch/mips/kernel/cpu-probe.c | 1 +
>  arch/mips/kvm/vz.c           | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ce1aacc..3a15f2b 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -1405,6 +1405,7 @@ config CPU_LOONGSON64
>         select MIPS_L1_CACHE_SHIFT_6
>         select GPIOLIB
>         select SWIOTLB
> +       select HAVE_KVM
>         help
>                 The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of p=
rocessor
>                 cores implements the MIPS64R2 instruction set with many e=
xtensions,
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index 319c250..415fbd2 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -2008,6 +2008,7 @@ static inline void cpu_probe_loongson(struct cpuinf=
o_mips *c, unsigned int cpu)
>                 c->writecombine =3D _CACHE_UNCACHED_ACCELERATED;
>                 c->ases |=3D (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_C=
AM |
>                         MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
> +               c->ases &=3D ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 =
is incomplete */
>                 break;
>         case PRID_IMP_LOONGSON_64G:
>                 c->cputype =3D CPU_LOONGSON64;
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 73701c3..dc753d0 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -2697,7 +2697,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, =
int cpu)
>          * prevents a SC on the next VCPU from succeeding by matching a L=
L on
>          * the previous VCPU.
>          */
> -       if (cpu_guest_has_rw_llb)
> +       if (vcpu->kvm->created_vcpus > 1)
>                 write_gc0_lladdr(0);
>
>         return 0;
> --
> 2.7.0
>
