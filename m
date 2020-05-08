Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20A01CA6D0
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgEHJIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 05:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgEHJIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 05:08:19 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF07C05BD43;
        Fri,  8 May 2020 02:08:17 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k12so9412609wmj.3;
        Fri, 08 May 2020 02:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JzI6LAP1zoUeKot6isI3+BO4Na+tU0cljRsHIjo61GU=;
        b=OvK4n0IsbyOunXsGB4paXl0Ht9xLjnDvoS0JQ+Lg5Jnulq4mw2vlMCp0iv2ZzsC30d
         kulkh9NWUU6T4qG8sN2qdGBBHMAD2WpCZigIu9fWrPjk+T36L+NfehsK5JcAqrLvgWAA
         dbr+tUu3t8qwRJRSLprFMq1v4vxzx3+Rj1KT16knT46cYzwifes/PMGjJjicnX+oVQLO
         ZegQ4HQ5N8Qku/J/18y6lOx7e33ZiwM4bREmjo2gGDWU3onnd4SFBKNB7HnZxBgiMLob
         YvvlfDst3d+DV7LZf/GuaVEXvmYbT1NQni8kWF9GDFmZDkDPq8De62K09jY4rdtHvR/J
         GX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JzI6LAP1zoUeKot6isI3+BO4Na+tU0cljRsHIjo61GU=;
        b=VXU3Dvi7gerpfofrWThe1bbbhStL2Ghog1y+FK6pPmpMr88+3e/pEJ19xOcn4hb7mF
         T4pMDRMAck9JbHHyapoYDTFne/HyUoG1JmAM3GIIhRaqz6KPSV8k/QOlDL8cGHBSv0rL
         xmxUHjTJ/U1pPKpQQligkIUQeiQJ3lZn/eaAq5Pwri5cCM/xzSHzszXpKAgN0AH6R1P6
         jreP2o6EF50/NaWVU+TXXY99mgN5xMPLnapICiw+B0aX7LM/PtN/dARBSmrnHIvhPYA0
         OVvhxFswVjtAszRP0oBfO8xBsqH6AHYir+kXNU/n3Pmql/kHuFeokOPp2cT34WhnXhIy
         osHw==
X-Gm-Message-State: AGi0PuZsiJELVumRIa3FzF0o59cjCJ48eUivyeqq3tLjAwrCOPiqj4je
        ZXVBX1vd07zF39oNirFVkND248++f/WjcJKKgfY=
X-Google-Smtp-Source: APiQypL+TtVereE1I//l5Bzks/74WidhVtXG4Qu3XA5evGg97EAKix88YgG4PPxNdqCAODIT4H16tHzJixIQvsfveno=
X-Received: by 2002:a7b:c74d:: with SMTP id w13mr14504118wmk.36.1588928896212;
 Fri, 08 May 2020 02:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-5-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-5-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 11:08:03 +0200
Message-ID: <CAHiYmc42QJ_XzHxoBKyccocb7sJCn42UtOuQ-2LNCzK=RqkEVQ@mail.gmail.com>
Subject: Re: [PATCH V3 04/14] KVM: MIPS: Add EVENTFD support which is needed
 by VHOST
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:09 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Add EVENTFD support for KVM/MIPS, which is needed by VHOST. Tested on
> Loongson-3 platform.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---

Perhaps this patch needs rebasing to land cleanly into master.

But, in general, for what is worth:

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>


>  arch/mips/kvm/Kconfig     | 1 +
>  arch/mips/kvm/Makefile    | 2 +-
>  arch/mips/kvm/trap_emul.c | 3 +++
>  arch/mips/kvm/vz.c        | 3 +++
>  4 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
> index b91d145..d697752 100644
> --- a/arch/mips/kvm/Kconfig
> +++ b/arch/mips/kvm/Kconfig
> @@ -22,6 +22,7 @@ config KVM
>         select EXPORT_UASM
>         select PREEMPT_NOTIFIERS
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +       select HAVE_KVM_EVENTFD
>         select HAVE_KVM_VCPU_ASYNC_IOCTL
>         select KVM_MMIO
>         select MMU_NOTIFIER
> diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
> index 01affc1..0a3cef6 100644
> --- a/arch/mips/kvm/Makefile
> +++ b/arch/mips/kvm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for KVM support for MIPS
>  #
>
> -common-objs-y =3D $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_m=
mio.o)
> +common-objs-y =3D $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_m=
mio.o eventfd.o)
>
>  EXTRA_CFLAGS +=3D -Ivirt/kvm -Iarch/mips/kvm
>
> diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> index 5a11e83..f464506b 100644
> --- a/arch/mips/kvm/trap_emul.c
> +++ b/arch/mips/kvm/trap_emul.c
> @@ -529,6 +529,9 @@ static int kvm_trap_emul_check_extension(struct kvm *=
kvm, long ext)
>         case KVM_CAP_MIPS_TE:
>                 r =3D 1;
>                 break;
> +       case KVM_CAP_IOEVENTFD:
> +               r =3D 1;
> +               break;
>         default:
>                 r =3D 0;
>                 break;
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index dde2088..17932ab 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -2927,6 +2927,9 @@ static int kvm_vz_check_extension(struct kvm *kvm, =
long ext)
>                 r =3D 2;
>                 break;
>  #endif
> +       case KVM_CAP_IOEVENTFD:
> +               r =3D 1;
> +               break;
>         default:
>                 r =3D 0;
>                 break;
> --
> 2.7.0
>
