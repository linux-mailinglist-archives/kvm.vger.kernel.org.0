Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D737E40790A
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhIKP1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 11:27:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbhIKP1g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Sep 2021 11:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631373982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xl+oqwnwvaxEHmP4vvNsBIhqBf7vlnAMAg0d7V640wo=;
        b=bBcqpuZ1NouwCUaxRZWlnqBr2lrRJjiw/L5sVXhRvk1TFqplNZeQTTaphwh5CRaMUq6UBV
        ow1Vp1z+R9UnRa5H1EYmmKPB1N3Zvdc10WPvxJdTqsZeHEwH4FRktGyNSAovbQXXFZFr7l
        auX45SsZ0jTZbNobtkyDzXxV7S0qR7I=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-F7gUoVoTOz2iqmJfvNcKzQ-1; Sat, 11 Sep 2021 11:26:19 -0400
X-MC-Unique: F7gUoVoTOz2iqmJfvNcKzQ-1
Received: by mail-lj1-f200.google.com with SMTP id p11-20020a2ea40b000000b001d68cffb055so1799345ljn.6
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 08:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xl+oqwnwvaxEHmP4vvNsBIhqBf7vlnAMAg0d7V640wo=;
        b=33ymdF8T1Vl32zveW++zWHSOzFWPL/bV5OuVbXeuQSQCa4uRWFx0cxfnv2Ltb9bbQ9
         Lbss5MGgBev7RRjC3Rfgn5lqXeGHf3AIO3JOb88Co0YYQeO8lyBCvXpbgUk5HduZ3YyM
         TbM7nIPNXT0hhfGFnYuvMsW4CtPl5l8k3m8zebsYZHbKaHgVhKW1EsMadsmrS1mPGQQy
         y41mnqDwrqRXxgrzo66dwjWYjCYfw4dz6HzqPpaQJ3UmjMoWqrKDsX/Wj+fK36eJypwL
         2DLc0iiLULFn5WtCxX8jy8a1j6K2DkTGsWlpQ3qhzyLhA9le0Mlre2wbL1zW578iwT8a
         rQpQ==
X-Gm-Message-State: AOAM532l4UY1uAh82SQ65Q1RRsbkSQ0u+Y9vtMBMCbD/s8QL6/P4yUoA
        PX6538KEa+fkQuv2rD4QUBymHZlUZ89W62h6AnRHZiEzyOQy/cpGD682KimTVGU0gVGAgH1frBK
        x8O1W680BqsOsWEYLWx+VR4P7i7jq
X-Received: by 2002:ac2:4d57:: with SMTP id 23mr2359165lfp.493.1631373977465;
        Sat, 11 Sep 2021 08:26:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0FsdHGxiCkwOlRM7elTNZJQzMhOhalIj40meqAu34NJPBi0bEAORuK2tgt+z51M2CRS1qILAoO1Qq7TQbwDc=
X-Received: by 2002:ac2:4d57:: with SMTP id 23mr2359143lfp.493.1631373977147;
 Sat, 11 Sep 2021 08:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210903211600.2002377-1-ehabkost@redhat.com> <1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com>
 <YTv4rgPol5vILWay@google.com>
In-Reply-To: <YTv4rgPol5vILWay@google.com>
From:   Eduardo Habkost <ehabkost@redhat.com>
Date:   Sat, 11 Sep 2021 11:26:01 -0400
Message-ID: <CAOpTY_ony8uDquFQR3=hRvzpGHic6O_0qhocbHCz7-swyNc-QQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] kvm: x86: Set KVM_MAX_VCPUS=1024, KVM_SOFT_MAX_VCPUS=710
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 8:30 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Mon, Sep 06, 2021, Paolo Bonzini wrote:
> > On 03/09/21 23:15, Eduardo Habkost wrote:
> > > - Increases KVM_MAX_VCPU_ID from 1023 to 4096.
>
> ...
>
> > > Eduardo Habkost (3):
> > >    kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS
>
> ...
>
> > >    kvm: x86: Increase MAX_VCPUS to 1024
> > >    kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710
> > >
> > >   arch/x86/include/asm/kvm_host.h | 18 +++++++++++++++---
> > >   1 file changed, 15 insertions(+), 3 deletions(-)
> > >
> >
> > Queued, thanks.
>
> Before we commit to this, can we sort out the off-by-one mess that is KVM=
_MAX_VCPU_ID?
> As Eduardo pointed out[*], Juergen's commit 76b4f357d0e7 ("x86/kvm: fix v=
cpu-id
> indexed array sizes") _shouldn't_ be necessary because kvm_vm_ioctl_creat=
e_vcpu()
> rejects attempts to create id=3D=3DKVM_MAX_VCPU_ID
>
>         if (id >=3D KVM_MAX_VCPU_ID)
>                 return -EINVAL;
>
> which aligns with the docs for KVM_CREATE_VCPU:
>
>         The vcpu id is an integer in the range [0, max_vcpu_id)
>
> but the fix is "needed" because rtc_irq_eoi_tracking_reset() does
>
>         bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1)=
;
>
> and now we have this
>
>         DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
>         u8 vectors[KVM_MAX_VCPU_ID + 1];
>
> which is wrong as well.  The "right" fix would have been to change
> rtc_irq_eoi_tracking_reset(), but that looks all kinds of wrong on the su=
rface.
>
> Non-x86 really mucks it up because generic code does:
>
>         #ifndef KVM_MAX_VCPU_ID
>         #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
>         #endif
>
> which means pretty much everything else can create more vCPUs than vCPU I=
Ds.
>
> Maybe fix KVM's internal KVM_MAX_VCPU_ID so that it's incluse, and handle=
 the
> backwards compability mess in KVM_CAP_MAX_VCPU_ID?  Then have the max ID =
for x86
> be (4*KVM_MAX_VCPUS - 1).  E.g. something like:


Wouldn't it be simpler to just revert 76b4f357d0e7 and rename
KVM_MAX_VCPU_ID to KVM_MAX_VCPU_IDS?

As far as I can see, every single line of code in KVM (except the 3
lines touched by 76b4f357d0e7) treats both KVM_MAX_VCPU_ID and
KVM_CAP_MAX_VCPU_ID as exclusive. Including the API documentation.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..2e5c8081f72b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4061,7 +4061,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>                 r =3D KVM_MAX_VCPUS;
>                 break;
>         case KVM_CAP_MAX_VCPU_ID:
> -               r =3D KVM_MAX_VCPU_ID;
> +               /* KVM's ABI is stupid. */
> +               r =3D KVM_MAX_VCPU_ID - 1;
>                 break;
>         case KVM_CAP_PV_MMU:    /* obsolete */
>                 r =3D 0;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..ba46c42a4a6f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3460,7 +3460,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm=
, u32 id)
>         struct kvm_vcpu *vcpu;
>         struct page *page;
>
> -       if (id >=3D KVM_MAX_VCPU_ID)
> +       if (id > KVM_MAX_VCPU_ID)
>                 return -EINVAL;
>
>         mutex_lock(&kvm->lock);
> 17:23:40 =E2=9C=94 ~/go/src/kernel.org/host $ gdd
> diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include=
/asm/kvm_book3s.h
> index caaa0f592d8e..0292d8a5ce5e 100644
> --- a/arch/powerpc/include/asm/kvm_book3s.h
> +++ b/arch/powerpc/include/asm/kvm_book3s.h
> @@ -434,7 +434,7 @@ extern int kvmppc_h_logical_ci_store(struct kvm_vcpu =
*vcpu);
>  #define SPLIT_HACK_OFFS                        0xfb000000
>
>  /*
> - * This packs a VCPU ID from the [0..KVM_MAX_VCPU_ID) space down to the
> + * This packs a VCPU ID from the [0..KVM_MAX_VCPU_ID] space down to the
>   * [0..KVM_MAX_VCPUS) space, using knowledge of the guest's core stride
>   * (but not its actual threading mode, which is not available) to avoid
>   * collisions.
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/a=
sm/kvm_host.h
> index 9f52f282b1aa..beeebace8d1c 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -33,11 +33,11 @@
>
>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>  #include <asm/kvm_book3s_asm.h>                /* for MAX_SMT_THREADS */
> -#define KVM_MAX_VCPU_ID                (MAX_SMT_THREADS * KVM_MAX_VCORES=
)
> +#define KVM_MAX_VCPU_ID                (MAX_SMT_THREADS * KVM_MAX_VCORES=
) - 1
>  #define KVM_MAX_NESTED_GUESTS  KVMPPC_NR_LPIDS
>
>  #else
> -#define KVM_MAX_VCPU_ID                KVM_MAX_VCPUS
> +#define KVM_MAX_VCPU_ID                KVM_MAX_VCPUS - 1
>  #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
>
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..5c20c0bd4db6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4061,7 +4061,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>                 r =3D KVM_MAX_VCPUS;
>                 break;
>         case KVM_CAP_MAX_VCPU_ID:
> -               r =3D KVM_MAX_VCPU_ID;
> +               /* KVM's ABI is stupid. */
> +               r =3D KVM_MAX_VCPU_ID + 1;
>                 break;
>         case KVM_CAP_PV_MMU:    /* obsolete */
>                 r =3D 0;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b490b4..37ef972caf4b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -40,7 +40,7 @@
>  #include <linux/kvm_dirty_ring.h>
>
>  #ifndef KVM_MAX_VCPU_ID
> -#define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> +#define KVM_MAX_VCPU_ID KVM_MAX_VCPUS - 1
>  #endif
>
>  /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..ba46c42a4a6f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3460,7 +3460,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm=
, u32 id)
>         struct kvm_vcpu *vcpu;
>         struct page *page;
>
> -       if (id >=3D KVM_MAX_VCPU_ID)
> +       if (id > KVM_MAX_VCPU_ID)
>                 return -EINVAL;
>
>         mutex_lock(&kvm->lock);
>
>


--=20
Eduardo

