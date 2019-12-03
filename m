Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4C510FE87
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLCNTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:19:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726186AbfLCNTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 08:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575379163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RsqTwzDz1hPQy7QgqBrZxDGgK8E7PuyP6TQRTEXbU4o=;
        b=hojQ93NvPSaOXjXTjjx4bJzcWS1kp3x7LezPqca7TBbUn7SZOZNR8aEDe71Z6kss5GlAqY
        Goio/UgDGIJdP37Mnxcuv/S8DNjiJHTyVRXftbu7pTFtAGuKoVBX++T5vWMZovPgDnOamt
        npOBS+Q3Z49cyl+xF2popNMtmcPUT6U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-P5fOB97TPySH2PaHKHafWw-1; Tue, 03 Dec 2019 08:19:20 -0500
Received: by mail-wm1-f71.google.com with SMTP id l11so1408801wmi.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R+4oYdpXVhG27DrGdRFr0rgKSjpFlrL/zqNo6puEy68=;
        b=V/e3SERLxfD3ytr6qGl67dyHOMhOdn2EHUEdNqknvmM9eMs0HRb+pZWOLO4WD8zIHb
         TSYFCmjfelIIx0O/QYvh7HGyCqtgpU6UXoHMWH2NCteMeNMjqyJruIdfgYK3e53AKsHt
         mr0LpScL2Dt42nkGPe9YRKRN3BhQwqwr4cxfzTWC/+dC6ATrljfcJts/yezG5o1ovvpZ
         qwVHRxdTZ3zak9GkSktPqSxlDPJetL9irpOt4ih5KKfko+i0efOFY9fuVeZS9JWE+Iqd
         CT1tmDW7lqWKr3DUsZfXHM0O05KC9ORK1O775nvXH+FSLSUKKGY7Ko8xhHHfOqNIurmr
         Hj0A==
X-Gm-Message-State: APjAAAUguv4dLzBrLXfsie9ix3j/kvV4hswWxpIcXn4EZtB3a7WJtKNv
        lt/Ybi4HriFyFMChzOIamzryli5L1iRxKyL66elug3kVCBbXt/tqxg09N1H5IQSzbdynJO4cVF/
        qJJbDmZzIEeaj
X-Received: by 2002:a05:600c:54b:: with SMTP id k11mr17828551wmc.63.1575379158962;
        Tue, 03 Dec 2019 05:19:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9ey1HX98M6op+nW7G5+PeaFJJEIB66tjCaDd5HPacoO8E3rkc9kHYHItztc2JTgSAWe0t6Q==
X-Received: by 2002:a05:600c:54b:: with SMTP id k11mr17828539wmc.63.1575379158731;
        Tue, 03 Dec 2019 05:19:18 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z64sm3195018wmg.30.2019.12.03.05.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 05:19:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
In-Reply-To: <20191202201314.543-5-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com> <20191202201314.543-5-peterx@redhat.com>
Date:   Tue, 03 Dec 2019 14:19:16 +0100
Message-ID: <87tv6hbl7v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: P5fOB97TPySH2PaHKHafWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> We have both APIC_SHORT_MASK and KVM_APIC_SHORT_MASK defined for the
> shorthand mask.  Similarly, we have both APIC_DEST_MASK and
> KVM_APIC_DEST_MASK defined for the destination mode mask.
>
> Drop the KVM_APIC_* macros and replace the only user of them to use
> the APIC_DEST_* macros instead.  At the meantime, move APIC_SHORT_MASK
> and APIC_DEST_MASK from lapic.c to lapic.h.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 3 ---
>  arch/x86/kvm/lapic.h | 5 +++--
>  arch/x86/kvm/svm.c   | 4 ++--
>  3 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 1eabe58bb6d5..805c18178bbf 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -56,9 +56,6 @@
>  #define APIC_VERSION=09=09=09(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
>  #define LAPIC_MMIO_LENGTH=09=09(1 << 12)
>  /* followed define is not in apicdef.h */
> -#define APIC_SHORT_MASK=09=09=090xc0000
> -#define APIC_DEST_NOSHORT=09=090x0
> -#define APIC_DEST_MASK=09=09=090x800
>  #define MAX_APIC_VECTOR=09=09=09256
>  #define APIC_VECTORS_PER_REG=09=0932
> =20
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 0b9bbadd1f3c..5a9f29ed9a4b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -10,8 +10,9 @@
>  #define KVM_APIC_SIPI=09=091
>  #define KVM_APIC_LVT_NUM=096
> =20
> -#define KVM_APIC_SHORT_MASK=090xc0000
> -#define KVM_APIC_DEST_MASK=090x800
> +#define APIC_SHORT_MASK=09=09=090xc0000
> +#define APIC_DEST_NOSHORT=09=090x0
> +#define APIC_DEST_MASK=09=09=090x800
> =20
>  #define APIC_BUS_CYCLE_NS       1
>  #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 362e874297e4..65a27a7e9cb1 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4519,9 +4519,9 @@ static int avic_incomplete_ipi_interception(struct =
vcpu_svm *svm)
>  =09=09 */
>  =09=09kvm_for_each_vcpu(i, vcpu, kvm) {
>  =09=09=09bool m =3D kvm_apic_match_dest(vcpu, apic,
> -=09=09=09=09=09=09     icrl & KVM_APIC_SHORT_MASK,
> +=09=09=09=09=09=09     icrl & APIC_SHORT_MASK,
>  =09=09=09=09=09=09     GET_APIC_DEST_FIELD(icrh),
> -=09=09=09=09=09=09     icrl & KVM_APIC_DEST_MASK);
> +=09=09=09=09=09=09     icrl & APIC_DEST_MASK);
> =20
>  =09=09=09if (m && !avic_vcpu_is_running(vcpu))
>  =09=09=09=09kvm_vcpu_wake_up(vcpu);

Personal taste but I would've preserved KVM_ prefix. The patch itself
looks correct, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

