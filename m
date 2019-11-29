Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8210D6F0
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 15:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfK2OXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 09:23:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29682 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726824AbfK2OXo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 09:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575037422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjGu5Y9IqwjrSunQ/XOztUtwME2j3+eRCCCFohsV410=;
        b=h30soEZEoD8mbS1wIiA2nAapoN6RnKGOIA1TOtCyPQs3E4MIgShNsdPxCEaUyDp3M06S09
        bOfVMgUs6f59w4XL5zV3him2F3phTlIuzzAb74qslK3uvJmc9+fu6+SmVEuHycRDm5rtOo
        QRZ2IjZECCPB2epEI78Oduq0khbPCHA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-GgCdLEEKPKK0vlNZutJVyg-1; Fri, 29 Nov 2019 09:23:39 -0500
Received: by mail-wr1-f71.google.com with SMTP id q6so15638377wrv.11
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 06:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kaxeE+6S8sCxKLrCWJSud3mrPDlPxV80NahWl909qwo=;
        b=c0UPwPMrU2PVw+26ybVpb/Rg3uoqAv8W0PpstUdWz56TuYOtGZ7EgQPx5aG+A5hNV0
         JeVGpJpFPyievIKW3E6CQfl50ZACwdDHpXiXXJKtJd2JGTOELSGVWjGU7pqiLPgK7spt
         qTqRGsUWyjpp2V/VQDpjctct2uokv9MisuW5egoJqMHWUJpXcZPfcaZSOMQMiESM9rSj
         f5D8JI7ChNjM0bWGUjThNO5tla28Qh7Bj42MU4dRyPWCkQsDmIaXPqvjgrcshngu6Hnt
         ciDrjlzw+HCgWAQz2E5DHCOElRgXR8uN44Cqo/c+lNI/HdjmfrR2jVtyGYhe431TMMLq
         qljQ==
X-Gm-Message-State: APjAAAXyvEggVBzwNoEbqXL5X9legmCM+p1p/cJS6o3v69NPaOjdvPsi
        VnSslXBN1LVxo9W565PlvO8XyTOUCh+0tAVa0FTslg6B9EY355cGh3n292CukD4s8iM04P2FWtu
        jYva6wvKWJXue
X-Received: by 2002:adf:f5c2:: with SMTP id k2mr54051080wrp.118.1575037418920;
        Fri, 29 Nov 2019 06:23:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVv1y+4A+y/39GNkVZoElT6z5O0Pek/hv4gLlJdL8U5Xgc64spiRBOkAodEg1rJHQ8THPcgg==
X-Received: by 2002:adf:f5c2:: with SMTP id k2mr54051050wrp.118.1575037418670;
        Fri, 29 Nov 2019 06:23:38 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b17sm3023411wrx.15.2019.11.29.06.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 06:23:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Subject: Re: [PATCH] KVM: X86: Use APIC_DEST_* macros properly
In-Reply-To: <20191128193211.32684-1-peterx@redhat.com>
References: <20191128193211.32684-1-peterx@redhat.com>
Date:   Fri, 29 Nov 2019 15:23:36 +0100
Message-ID: <87sgm6damv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: GgCdLEEKPKK0vlNZutJVyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Previously we were using either APIC_DEST_PHYSICAL|APIC_DEST_LOGICAL
> or 0|1 to fill in kvm_lapic_irq.dest_mode, and it's done in an adhoc
> way.  It's fine imho only because in most cases when we check against
> dest_mode it's against APIC_DEST_PHYSICAL (which equals to 0).
> However, that's not consistent, majorly because APIC_DEST_LOGICAL does
> not equals to 1, so if one day we check irq.dest_mode against
> APIC_DEST_LOGICAL we'll probably always get a false returned.
>
> This patch replaces the 0/1 settings of irq.dest_mode with the macros
> to make them consistent.
>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <sean.j.christopherson@intel.com>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Nitesh Narayan Lal <nitesh@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c   | 9 ++++++---
>  arch/x86/kvm/irq_comm.c | 7 ++++---
>  arch/x86/kvm/x86.c      | 2 +-
>  3 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 9fd2dd89a1c5..1e091637d5d5 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -331,7 +331,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09=09irq.vector =3D e->fields.vector;
>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>  =09=09=09irq.dest_id =3D e->fields.dest_id;
> -=09=09=09irq.dest_mode =3D e->fields.dest_mode;
> +=09=09=09irq.dest_mode =3D e->fields.dest_mode ?
> +=09=09=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>  =09=09=09bitmap_zero(&vcpu_bitmap, 16);
>  =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  =09=09=09=09=09=09 &vcpu_bitmap);
> @@ -343,7 +344,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09=09=09 * keep ioapic_handled_vectors synchronized.
>  =09=09=09=09 */
>  =09=09=09=09irq.dest_id =3D old_dest_id;
> -=09=09=09=09irq.dest_mode =3D old_dest_mode;
> +=09=09=09=09irq.dest_mode =3D old_dest_mode ?
> +=09=09=09=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>  =09=09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>  =09=09=09=09=09=09=09 &vcpu_bitmap);
>  =09=09=09}
> @@ -369,7 +371,8 @@ static int ioapic_service(struct kvm_ioapic *ioapic, =
int irq, bool line_status)
> =20
>  =09irqe.dest_id =3D entry->fields.dest_id;
>  =09irqe.vector =3D entry->fields.vector;
> -=09irqe.dest_mode =3D entry->fields.dest_mode;
> +=09irqe.dest_mode =3D entry->fields.dest_mode ?
> +=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>  =09irqe.trig_mode =3D entry->fields.trig_mode;
>  =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
>  =09irqe.level =3D 1;
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d31800..673b6afd6dbf 100644
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
> +=09irq->dest_mode =3D (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_l=
o ?
> +=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
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

dest_mode is being passed to kvm_apic_match_dest() where we do:

=09case APIC_DEST_NOSHORT:
=09=09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
=09=09=09return kvm_apic_match_physical_addr(target, mda);
=09=09else
=09=09=09return kvm_apic_match_logical_addr(target, mda);

I'd suggest we fix this too then (and BUG() in case it's neither).

--=20
Vitaly

