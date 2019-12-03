Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACAAE10FE7B
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLCNQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:16:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725957AbfLCNQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 08:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575378967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fEQnMm9l2voQ0J2ySJrhOuYQvNTgK+ssK7Iqm4yZa/E=;
        b=OZbFSGDbuwIzKApw0qcxpOT8JK8bfu3jPzF+rCWUiZuvEF8dd4uyeLeBQxiUXc7WZd9ZxR
        I2Y+P0C3aLZrFAxWWMPDIGaNhYeal6FlFOq8pUOhW5MLpvqLShNgwF5qzB8XxFUdKPLiLM
        JUiqoilC0nOokjaXYsw9FfI0kGSPFk4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-8bZ3roLKPp2Surpa5E168A-1; Tue, 03 Dec 2019 08:16:05 -0500
Received: by mail-wm1-f70.google.com with SMTP id f191so970038wme.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+B5QIazI4Ie4a7nGrqp3wfpkLneKCu2xyGaxRW5rTQ0=;
        b=FvFFg/S4H+2bxrcbUp3tVoQxFzpw62CiAxSwaNvcNgk/+T6FaVOwJ4gLpW12KsA3aS
         H4aqORK5L4q9cCCdUKnLhDaXyEkMHM0EvcOKHiWXszezJyZuRvSFdKnvCK9M7MAbfblZ
         isLn9A69Vj9mjvtdpmh+vtvaanOYfA7BXAKAPcWoQjHQQCfvEJxQpsYaDegyU/P9l/Ko
         YwMq4n/Jza1MED6IBN27wAUAEtisfsoA7yz2gEl9JsShT0rOV1yZ4NTU0kAPBtou+CMw
         QpU1ShXR70F7WG/zeMjplsUJ+6jysVrY0kzrQrTx29UdBgU99ZcobEM9dXxCyptqCk4q
         nVKw==
X-Gm-Message-State: APjAAAX0txORJlnildyNm9z51W6+l0iUAwu07s9/k3S3xkVVQSPMJ3al
        +imSWD0sW8Jv90r59bzyKTkEBEdKGM1PrNaznr6vZqnCq+QN3UiFp/ClktR/TzOEF6z7SHJjgS/
        MvLwZc4ZXDWkT
X-Received: by 2002:a7b:cf2d:: with SMTP id m13mr13176987wmg.163.1575378963917;
        Tue, 03 Dec 2019 05:16:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqx20PxwcKm/6OsHkVy+Mn1dllQJFtm8ala5wHB808COFtj4Q6UoP/+5NJY7Jwe7grE84SU2cQ==
X-Received: by 2002:a7b:cf2d:: with SMTP id m13mr13176962wmg.163.1575378963645;
        Tue, 03 Dec 2019 05:16:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w17sm3631956wrt.89.2019.12.03.05.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 05:16:02 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com
Subject: Re: [PATCH v3 3/5] KVM: X86: Use APIC_DEST_* macros properly in kvm_lapic_irq.dest_mode
In-Reply-To: <20191202201314.543-4-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com> <20191202201314.543-4-peterx@redhat.com>
Date:   Tue, 03 Dec 2019 14:16:01 +0100
Message-ID: <87wobdblda.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: 8bZ3roLKPp2Surpa5E168A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> We were using either APIC_DEST_PHYSICAL|APIC_DEST_LOGICAL or 0|1 to
> fill in kvm_lapic_irq.dest_mode.  It's fine only because in most cases
> when we check against dest_mode it's against APIC_DEST_PHYSICAL (which
> equals to 0).  However, that's not consistent.  We'll have problem
> when we want to start checking against APIC_DEST_PHYSICAL

APIC_DEST_LOGICAL

> which does not equals to 1.
>
> This patch firstly introduces kvm_lapic_irq_dest_mode() helper to take
> any boolean of destination mode and return the APIC_DEST_* macro.
> Then, it replaces the 0|1 settings of irq.dest_mode with the helper.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 5 +++++
>  arch/x86/kvm/ioapic.c           | 8 +++++---
>  arch/x86/kvm/irq_comm.c         | 7 ++++---
>  arch/x86/kvm/x86.c              | 2 +-
>  4 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index b79cd6aa4075..f815c97b1b57 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1022,6 +1022,11 @@ struct kvm_lapic_irq {
>  =09bool msi_redir_hint;
>  };
> =20
> +static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode)
> +{
> +=09return dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
> +}
> +
>  struct kvm_x86_ops {
>  =09int (*cpu_has_kvm_support)(void);          /* __init */
>  =09int (*disabled_by_bios)(void);             /* __init */
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 9fd2dd89a1c5..901d85237d1c 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -331,7 +331,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09=09irq.vector =3D e->fields.vector;
>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>  =09=09=09irq.dest_id =3D e->fields.dest_id;
> -=09=09=09irq.dest_mode =3D e->fields.dest_mode;
> +=09=09=09irq.dest_mode =3D
> +=09=09=09    kvm_lapic_irq_dest_mode(e->fields.dest_mode);
>  =09=09=09bitmap_zero(&vcpu_bitmap, 16);
>  =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  =09=09=09=09=09=09 &vcpu_bitmap);
> @@ -343,7 +344,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09=09=09 * keep ioapic_handled_vectors synchronized.
>  =09=09=09=09 */
>  =09=09=09=09irq.dest_id =3D old_dest_id;
> -=09=09=09=09irq.dest_mode =3D old_dest_mode;
> +=09=09=09=09irq.dest_mode =3D
> +=09=09=09=09    kvm_lapic_irq_dest_mode(e->fields.dest_mode);
>  =09=09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  =09=09=09=09=09=09=09 &vcpu_bitmap);
>  =09=09=09}
> @@ -369,7 +371,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, =
int irq, bool line_status)
> =20
>  =09irqe.dest_id =3D entry->fields.dest_id;
>  =09irqe.vector =3D entry->fields.vector;
> -=09irqe.dest_mode =3D entry->fields.dest_mode;
> +=09irqe.dest_mode =3D kvm_lapic_irq_dest_mode(entry->fields.dest_mode);
>  =09irqe.trig_mode =3D entry->fields.trig_mode;
>  =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
>  =09irqe.level =3D 1;
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d31800..5f59e5ebdbed 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -52,8 +52,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kv=
m_lapic *src,
>  =09unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>  =09unsigned int dest_vcpus =3D 0;
> =20
> -=09if (irq->dest_mode =3D=3D 0 && irq->dest_id =3D=3D 0xff &&
> -=09=09=09kvm_lowest_prio_delivery(irq)) {
> +=09if (irq->dest_mode =3D=3D APIC_DEST_PHYSICAL &&
> +=09    irq->dest_id =3D=3D 0xff && kvm_lowest_prio_delivery(irq)) {
>  =09=09printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>  =09=09irq->delivery_mode =3D APIC_DM_FIXED;
>  =09}
> @@ -114,7 +114,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kern=
el_irq_routing_entry *e,
>  =09=09irq->dest_id |=3D MSI_ADDR_EXT_DEST_ID(e->msi.address_hi);
>  =09irq->vector =3D (e->msi.data &
>  =09=09=09MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
> -=09irq->dest_mode =3D (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_l=
o;
> +=09irq->dest_mode =3D kvm_lapic_irq_dest_mode(
> +=09    (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo);

This usage is a bit fishy (I understand that it works, but),
kvm_lapic_irq_dest_mode()'s input is bool (0/1) but here we're passing
something different.

I'm not sure kvm_lapic_irq_dest_mode() is even needed here, but in case
it is I'd suggest to add '!!':

 kvm_lapic_irq_dest_mode(!!((1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.addres=
s_lo))

to make things explicit. I don't like how it looks though.

>  =09irq->trig_mode =3D (1 << MSI_DATA_TRIGGER_SHIFT) & e->msi.data;
>  =09irq->delivery_mode =3D e->msi.data & 0x700;
>  =09irq->msi_redir_hint =3D ((e->msi.address_lo
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3ed167e039e5..3b00d662dc14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7356,7 +7356,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, uns=
igned long flags, int apicid)
>  =09struct kvm_lapic_irq lapic_irq;
> =20
>  =09lapic_irq.shorthand =3D 0;
> -=09lapic_irq.dest_mode =3D 0;
> +=09lapic_irq.dest_mode =3D APIC_DEST_PHYSICAL;
>  =09lapic_irq.level =3D 0;
>  =09lapic_irq.dest_id =3D apicid;
>  =09lapic_irq.msi_redir_hint =3D false;

--=20
Vitaly

