Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB12310FAD0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 10:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfLCJgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 04:36:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29462 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725907AbfLCJgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 04:36:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575365806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7W/BEttJw33HncNG+QW+oMA8U8SyQxme1y4KXgd/4w=;
        b=XlUXLFyfYJq8tfcghw0aIEM/oeb9Q8SMasiHGFHurUwStLn1QrJb4xZW/peEXIgc6LuSIB
        kfvHQi01dxKxKpcjMM8LH5n+sDsRJpGT2zE9HFEbPS7bSANbKzxmWy+NlARLmVmV/eZdGy
        k9RcXcc4W2z4kcNk2C4reIIFR6BSQ2U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-xgYVQ0LxOEGpW1aTO68YJQ-1; Tue, 03 Dec 2019 04:36:45 -0500
Received: by mail-wr1-f71.google.com with SMTP id h7so1490529wrb.2
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 01:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PYrn284OnyQbwOX3aztUCmwgxQvrGOQTIkrwcm0f+tU=;
        b=ib2z3JDpPuBEe7KtN4lDfr0MPxA5peJKy8x6Nq1/eb7aBwSJqF5F/3pR1+cX+VuKa9
         lYaOPY3LI8uju+DS1qzyEVrKgj6iywLvej05AmaOewBchuY064sQW6cpoG8AViJIPXEC
         W3YVEqX4i4svrsy/M7aliWnZUwzk4dsK/iSeQCLd4/PAjZPoUXgXicsTdHEIsj8qVqLu
         vZU1FJ9wfghdfd1JS0K9z/GR/evj0m9XylLPKwogRmfnX5156zjVi9JPXo5KPk7z4xWU
         C3ALyaPt8oBGiyjtsEoc6/5ucfEaOIeyKtJFa99HXwYkkKC7tf7rJhkilRFgiAO1LK0p
         P1Fg==
X-Gm-Message-State: APjAAAWAdM6Piu87OmNyI4gCSjuCFDSjA/ceKM25Yu2t/SxX9V7q3wF0
        Cd59KPTuNkJuzfQFEucdC8igelMJibvLSYeX96XZ0jm8gmTEWXhtWnPkPSQiF2aZxX2XZ4KB7rW
        B51bswVX0dTLb
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr4327213wrr.74.1575365804430;
        Tue, 03 Dec 2019 01:36:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPFWXKDRpoZf/KCKfb5i8PwcpIMWn5vZ9LAaSrgN4RGhU6QMmDMyKz6URhOnw9kJ41TEjIhQ==
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr4327192wrr.74.1575365804191;
        Tue, 03 Dec 2019 01:36:44 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c136sm2517681wme.23.2019.12.03.01.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 01:36:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com
Subject: Re: [PATCH v3 2/5] KVM: X86: Move irrelevant declarations out of ioapic.h
In-Reply-To: <20191202201314.543-3-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com> <20191202201314.543-3-peterx@redhat.com>
Date:   Tue, 03 Dec 2019 10:36:42 +0100
Message-ID: <8736e1da39.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: xgYVQ0LxOEGpW1aTO68YJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> kvm_apic_match_dest() is declared in both ioapic.h and lapic.h.
> Removing the declaration in ioapic.h.
>
> kvm_apic_compare_prio() is declared in ioapic.h but defined in
> lapic.c.  Moving the declaration to lapic.h.
>
> kvm_irq_delivery_to_apic() is declared in ioapic.h but defined in
> irq_comm.c.  Moving the declaration to irq.h.

Nitpicking: 'imperative mode' requested by Sean would be "remove the
declaration", "move the declaration",...

>
> While at it, include irq.h in hyperv.c because it needs to use
> kvm_irq_delivery_to_apic().

"While at it" is being used when you are trying to squeeze in a (small)
unrelated change (fix a typo, rename a variable,...) but here it's not
the case: including irq.h to hyperv.c is mandatory (to not break the
build).

"Include irq.h in hyperv.c to support the change" would do (but honestly
I don't see much value in the statement so I'd rather omit in in the
changelog).

>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 1 +
>  arch/x86/kvm/ioapic.h | 6 ------
>  arch/x86/kvm/irq.h    | 3 +++
>  arch/x86/kvm/lapic.h  | 2 +-
>  4 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 23ff65504d7e..c7d4640b7b1c 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -33,6 +33,7 @@
>  #include <trace/events/kvm.h>
> =20
>  #include "trace.h"
> +#include "irq.h"
> =20
>  #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
> =20
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index ea1a4e0297da..2fb2e3c80724 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -116,9 +116,6 @@ static inline int ioapic_in_kernel(struct kvm *kvm)
>  }
> =20
>  void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
> -bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source=
,
> -=09=09int short_hand, unsigned int dest, int dest_mode);
> -int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2=
);
>  void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
>  =09=09=09int trigger_mode);
>  int kvm_ioapic_init(struct kvm *kvm);
> @@ -126,9 +123,6 @@ void kvm_ioapic_destroy(struct kvm *kvm);
>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_sourc=
e_id,
>  =09=09       int level, bool line_status);
>  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
> -int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> -=09=09=09     struct kvm_lapic_irq *irq,
> -=09=09=09     struct dest_map *dest_map);
>  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index 7c6233d37c64..f173ab6b407e 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -113,5 +113,8 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu);
> =20
>  int kvm_setup_default_irq_routing(struct kvm *kvm);
>  int kvm_setup_empty_irq_routing(struct kvm *kvm);
> +int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> +=09=09=09     struct kvm_lapic_irq *irq,
> +=09=09=09     struct dest_map *dest_map);
> =20
>  #endif
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 39925afdfcdc..0b9bbadd1f3c 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -83,7 +83,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offs=
et, int len,
>  =09=09       void *data);
>  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source=
,
>  =09=09=09   int short_hand, unsigned int dest, int dest_mode);
> -
> +int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2=
);
>  bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
>  bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
>  void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

