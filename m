Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD98112FBC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 17:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfLDQMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 11:12:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728564AbfLDQMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 11:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575475967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iBPKZZ1S6h+pflfRLsbt4YQvZfduXk93viwFWwQMor4=;
        b=aGSA02pwwzytN8y3tE4HRa5Prop91D5RQcHkzqEKQUWG74dsOjwZ4mWy7xvt5ul9pgrsvu
        q3Y/8oTQNQPGZPab2R6sVXq+r4pAM1V5gyOClhxVwFpP8Rgh/IRwdNm29YW7yTIZziO5OE
        ToWQA/EM+SdH1wscfLqvnH237NX7JBQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-xANbEaMvMmm7smrQHkwycA-1; Wed, 04 Dec 2019 11:12:46 -0500
Received: by mail-wr1-f72.google.com with SMTP id l20so67595wrc.13
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 08:12:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=az7yGx5mjj6saclgmtqUq3bomG8Y9h4yXQPUO7zazjU=;
        b=BmUjQifRx16oqCIfhfppwff7jnQ6FF/fIr4YBR6xbs/VXgUENBb0Y/Ftyf2S73PbB3
         A5p5nu1inXBZnBODEjG/vROjtaRihScZGWqploJ8ynzDOinDXLiAHtfEhE8eGfj8bb3H
         Qn+FZkBr6Qq5u7TWQFz67Xkph9CcSYTegZnXY4t4DhvFQDlipskaDw0II6Pj73MtWvAf
         QJYf5AzPpWKGmhGOVDOD8KbOoKbySdxBBbGESCVAlu7R9DJE4NNNRwKXYtheilScdCqa
         SR4PpJr79JG2jAkGDpWxOzWrO/xEavG85OEOsO+w/YaDI/vcssXHK0DNySvJWQPr/BaJ
         fQlg==
X-Gm-Message-State: APjAAAVR453o9E5deJy6q6QENDWDwimb7HljHRs81YaxuNpTz43Iy9Fb
        g42PAzmiYViP23ciD/xDCeCckrZeji2j9Uc5qzUliA62kdsmdTdpQUcmmQMMU8yqyO/I4qNMRk5
        jJewa6o14iDY9
X-Received: by 2002:adf:f18b:: with SMTP id h11mr4779045wro.56.1575475964972;
        Wed, 04 Dec 2019 08:12:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTJH5SA3fe8QAEzL29ciROHFyN3zU3Fi4M6fp77QL0tF0/UnHDFahXlLgvuujaCUbQPRN9pw==
X-Received: by 2002:adf:f18b:: with SMTP id h11mr4779023wro.56.1575475964785;
        Wed, 04 Dec 2019 08:12:44 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f1sm8745843wrp.93.2019.12.04.08.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 08:12:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] KVM: X86: Conert the last users of "shorthand = 0" to use macros
In-Reply-To: <20191203165903.22917-7-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com> <20191203165903.22917-7-peterx@redhat.com>
Date:   Wed, 04 Dec 2019 17:12:43 +0100
Message-ID: <875ziwt6h0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: xANbEaMvMmm7smrQHkwycA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Change the last users of "shorthand =3D 0" to use APIC_DEST_NOSHORT.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c   | 4 ++--
>  arch/x86/kvm/irq_comm.c | 2 +-
>  arch/x86/kvm/x86.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index f53daeaaeb37..77538fd77dc2 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -330,7 +330,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *=
ioapic, u32 val)
>  =09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
>  =09=09=09struct kvm_lapic_irq irq;
> =20
> -=09=09=09irq.shorthand =3D 0;
> +=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
>  =09=09=09irq.vector =3D e->fields.vector;
>  =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>  =09=09=09irq.dest_id =3D e->fields.dest_id;
> @@ -379,7 +379,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, =
int irq, bool line_status)
>  =09irqe.trig_mode =3D entry->fields.trig_mode;
>  =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
>  =09irqe.level =3D 1;
> -=09irqe.shorthand =3D 0;
> +=09irqe.shorthand =3D APIC_DEST_NOSHORT;
>  =09irqe.msi_redir_hint =3D false;
> =20
>  =09if (irqe.trig_mode =3D=3D IOAPIC_EDGE_TRIG)
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 7d083f71fc8e..9d711c2451c7 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -121,7 +121,7 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kern=
el_irq_routing_entry *e,
>  =09irq->msi_redir_hint =3D ((e->msi.address_lo
>  =09=09& MSI_ADDR_REDIRECTION_LOWPRI) > 0);
>  =09irq->level =3D 1;
> -=09irq->shorthand =3D 0;
> +=09irq->shorthand =3D APIC_DEST_NOSHORT;
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
> =20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b00d662dc14..f6d778436e15 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7355,7 +7355,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, uns=
igned long flags, int apicid)
>  {
>  =09struct kvm_lapic_irq lapic_irq;
> =20
> -=09lapic_irq.shorthand =3D 0;
> +=09lapic_irq.shorthand =3D APIC_DEST_NOSHORT;
>  =09lapic_irq.dest_mode =3D APIC_DEST_PHYSICAL;
>  =09lapic_irq.level =3D 0;
>  =09lapic_irq.dest_id =3D apicid;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

And, while on it, and if you're not yet tired I just noticed that
kvm_apic_match_dest()'s parameter is called 'short_hand' while
everywhere else we use 'shorthand'. Value the consistency we should :-)

--=20
Vitaly

