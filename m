Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EBB1DC9FE
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 11:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgEUJ1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 05:27:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728686AbgEUJ1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 05:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590053266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quQuJBMGTdzqpuGt7zo1zAzJESra8VWBn2to1tNTbPo=;
        b=dpbcq2d1ASBwyu9G4HX5j+c1R/mUjGulvkw98Yw5G55+gmv1PPRslWTIFaQYPEZ//NZeFi
        UPAe+KUtuwExLhQie2PMjjSK87E9J3px5tdNxigA9cBEdLqOuOS7tKA8SGNUEuKUR06aRn
        nwMPs5VtnZo+g/i1XsDdsWHMoZ4kfao=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-dfYLe2rYOxy3QsicfUXF-w-1; Thu, 21 May 2020 05:27:43 -0400
X-MC-Unique: dfYLe2rYOxy3QsicfUXF-w-1
Received: by mail-ej1-f71.google.com with SMTP id c9so2526757ejr.16
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 02:27:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=quQuJBMGTdzqpuGt7zo1zAzJESra8VWBn2to1tNTbPo=;
        b=YPgIQDsx7NpkjToUP6FOWRTdJr6fsW3TaFgNNQpsE8DBYxOLJ3YNRM/I88PANF4Zbx
         oPanM2vW7VO+gSz79f56FZc+YQinal8GVvgYMkczKyYCcFxQPxXX68s2alN6XHb1ZgXg
         rqMSlvkntzET5khXIG4H2R/DKtuPg0u1rFAs3mrYlsagZjBzGnb9d60vqWtSAscaSQD5
         S4O4hDMEqx3Pbytz8Z7WvUwCTngnRy23kIUtOFyUETDXMLMmdes9xXgs4SlYL2EtnSSa
         HiicPWenZ+qHWGqXAwX3dH0kSVFYbf4lFWqK6s2rQ8XeUUehJd+W9W5BXVwvn4wb8XXm
         /Hvg==
X-Gm-Message-State: AOAM53264766jsnD40eO5b/ZqXP/127Jkw9NEqsDZ/alq/FIbTYqkjEw
        wRhys9vP3mfrXLoPfqRShjJzuGnExmYH20z/Vr0AsseaTFcFlhsYdDG1bFJa2MEJEW0GgNfOQXP
        A69DU4n/j9kvL
X-Received: by 2002:a17:907:1199:: with SMTP id uz25mr2867005ejb.24.1590053262459;
        Thu, 21 May 2020 02:27:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu3tvSOXBKIaoKCExELL7QWl8a/0QYfX9s5r0nE2gAfdwL6HfdVLGHlArhNH733Qdd+RR40w==
X-Received: by 2002:a17:907:1199:: with SMTP id uz25mr2866989ejb.24.1590053262172;
        Thu, 21 May 2020 02:27:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k9sm4639051edf.26.2020.05.21.02.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 02:27:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     =?utf-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
Cc:     "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] kvm/x86 : Remove redundant function implement
In-Reply-To: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
References: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
Date:   Thu, 21 May 2020 11:27:40 +0200
Message-ID: <87h7w9skmr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=E5=BD=AD=E6=B5=A9(Richard) <richard.peng@oppo.com> writes:

> pic_in_kernel(),ioapic_in_kernel() and irqchip_kernel() have the
> same implementation.

'pic_in_kernel()' name is misleading, one may think this is about lapic
and it's not. Also, ioapic_in_kernel() doesn't have that many users, can
we maybe converge on using irqchip_*() functions everywhere?

>
> Signed-off-by: Peng Hao <richard.peng@oppo.com>
> ---
>  arch/x86/kvm/ioapic.h  |  8 ++------
>  arch/x86/kvm/irq.h     | 14 ++++----------
>  arch/x86/kvm/lapic.c   |  1 +
>  arch/x86/kvm/mmu/mmu.c |  1 +
>  arch/x86/kvm/x86.c     |  1 +
>  5 files changed, 9 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 2fb2e3c..7a3c53b 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -5,7 +5,7 @@
>  #include <linux/kvm_host.h>
>
>  #include <kvm/iodev.h>
> -
> +#include "irq.h"
>  struct kvm;
>  struct kvm_vcpu;
>
> @@ -108,11 +108,7 @@ do {\
>
>  static inline int ioapic_in_kernel(struct kvm *kvm)
>  {
> -int mode =3D kvm->arch.irqchip_mode;
> -
> -/* Matches smp_wmb() when setting irqchip_mode */
> -smp_rmb();
> -return mode =3D=3D KVM_IRQCHIP_KERNEL;
> +return irqchip_kernel(kvm);
>  }
>
>  void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index f173ab6..e133c1a 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -16,7 +16,6 @@
>  #include <linux/spinlock.h>
>
>  #include <kvm/iodev.h>
> -#include "ioapic.h"
>  #include "lapic.h"
>
>  #define PIC_NUM_PINS 16
> @@ -66,15 +65,6 @@ void kvm_pic_destroy(struct kvm *kvm);
>  int kvm_pic_read_irq(struct kvm *kvm);
>  void kvm_pic_update_irq(struct kvm_pic *s);
>
> -static inline int pic_in_kernel(struct kvm *kvm)
> -{
> -int mode =3D kvm->arch.irqchip_mode;
> -
> -/* Matches smp_wmb() when setting irqchip_mode */
> -smp_rmb();
> -return mode =3D=3D KVM_IRQCHIP_KERNEL;
> -}
> -
>  static inline int irqchip_split(struct kvm *kvm)
>  {
>  int mode =3D kvm->arch.irqchip_mode;
> @@ -93,6 +83,10 @@ static inline int irqchip_kernel(struct kvm *kvm)
>  return mode =3D=3D KVM_IRQCHIP_KERNEL;
>  }
>
> +static inline int pic_in_kernel(struct kvm *kvm)
> +{
> +return irqchip_kernel(kvm);
> +}
>  static inline int irqchip_in_kernel(struct kvm *kvm)
>  {
>  int mode =3D kvm->arch.irqchip_mode;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9af25c9..de4d046 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -36,6 +36,7 @@
>  #include <linux/jump_label.h>
>  #include "kvm_cache_regs.h"
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "trace.h"
>  #include "x86.h"
>  #include "cpuid.h"
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8071952..6133f69 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -16,6 +16,7 @@
>   */
>
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "mmu.h"
>  #include "x86.h"
>  #include "kvm_cache_regs.h"
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d..c8b62ac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -18,6 +18,7 @@
>
>  #include <linux/kvm_host.h>
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "mmu.h"
>  #include "i8254.h"
>  #include "tss.h"
> --
> 2.7.4
>
> ________________________________
> OPPO
>
> =E6=9C=AC=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=
=E4=BB=B6=E5=90=AB=E6=9C=89OPPO=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=
=86=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E9=82=AE=E4=BB=B6=
=E6=8C=87=E6=98=8E=E7=9A=84=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=EF=
=BC=88=E5=8C=85=E5=90=AB=E4=B8=AA=E4=BA=BA=E5=8F=8A=E7=BE=A4=E7=BB=84=EF=BC=
=89=E3=80=82=E7=A6=81=E6=AD=A2=E4=BB=BB=E4=BD=95=E4=BA=BA=E5=9C=A8=E6=9C=AA=
=E7=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E4=BB=A5=E4=
=BB=BB=E4=BD=95=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=E3=80=82=E5=A6=82=E6=9E=
=9C=E6=82=A8=E9=94=99=E6=94=B6=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=
=E8=AF=B7=E7=AB=8B=E5=8D=B3=E4=BB=A5=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E9=
=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=
=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E3=80=82
>
> This e-mail and its attachments contain confidential information from OPP=
O, which is intended only for the person or entity whose address is listed =
above. Any use of the information contained herein in any way (including, b=
ut not limited to, total or partial disclosure, reproduction, or disseminat=
ion) by persons other than the intended recipient(s) is prohibited. If you =
receive this e-mail in error, please notify the sender by phone or email im=
mediately and delete it!

--=20
Vitaly

