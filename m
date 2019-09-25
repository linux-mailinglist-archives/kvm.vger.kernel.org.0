Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C056EBDCA3
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390973AbfIYLFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbfIYLFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:05:05 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 746D999C48
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 11:05:04 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id t11so2173592wro.10
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 04:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KxRwgO8UaCBnFIEi2sgboQnxhDI72sZg4D5dYSN7E8U=;
        b=VyqlrGvyuwX4MU1eduKuSkIGXZXpOdPJpeROpekqE+J0UyMqNG0NLjeehGqz+xcSMM
         MKTuQRu7xesD6WoFQVRmY0yQioh91klAOwgk3duwZ7UY92ePKWvUii3VwAljHdECnNYu
         BKxHccbWygVTDbxUPiQiqs3MrJtogVRYLopChJv9fPsu1LAiFxn1qkvf+46StOVxe/63
         nk0oEX2TkRa0dRLrph46m/Ba8u35VvH9krWDUvk+hath1GHCb7Am5lwzBgSxXOu3YZqZ
         W5NIuQRoj92ejTFo19F49lHTjP4ieaKWcuxq5thvV7b/TQFm2Xi8kaXKTh9BAQKfSqJw
         qcwA==
X-Gm-Message-State: APjAAAWVC+7B1tnlOHL+q6EABjjl6EmeQuIVEOqpJvSb7jWVcto1jDsc
        fHhvM/I+vrqRE3rWHNA6zGOZeO5l8zuH78ACeiGkwpxl3lRPobUATNE5+iOLFu9XKNKlJW1ZpSZ
        7UciFs9Ibbk00
X-Received: by 2002:a5d:4102:: with SMTP id l2mr9024765wrp.348.1569409502877;
        Wed, 25 Sep 2019 04:05:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxv1RufwRVO2Xz4p1EG14MxB+VuyP/Md0SOkzT/jp9eOLo90iZxFL2+IAwrPoZbDP+pE5YWrg==
X-Received: by 2002:a5d:4102:: with SMTP id l2mr9024735wrp.348.1569409502623;
        Wed, 25 Sep 2019 04:05:02 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id z12sm4092835wmf.27.2019.09.25.04.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 04:05:01 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com> <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com> <87ftkksr9u.fsf@redhat.com> <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com>
Date:   Wed, 25 Sep 2019 13:04:59 +0200
Message-ID: <87blv8skkk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 25/09/19 10:40, Sergio Lopez wrote:
>>>> We need the PIT for non-KVM accel (if present with KVM and
>>>> kernel_irqchip_split =3D off, it basically becomes a placeholder)
>>> Why?
>>=20
>> Perhaps I'm missing something. Is some other device supposed to be
>> acting as a HW timer while running with TCG acceleration?
>
> Sure, the LAPIC timer.  I wonder if Linux, however, wants to use the PIT
> in order to calibrate the LAPIC timer if TSC deadline mode is unavailable.

Ah, yes. I was so confused by the nomenclature that I assumed we didn't
have a userspace implementation of it.

On the other hand, as you suspect, without the PIT Linux does hang in
TSC calibration with TCG accel.

A simple option could be adding it only if we're running without KVM.

>>>> and the PIC for both the PIT and the ISA serial port.
>>>
>>> Can't the ISA serial port work with the IOAPIC?
>>=20
>> Hm... I'm not sure. I wanted to give it a try, but then noticed that
>> multiple places in the code (like hw/intc/apic.c:560) do expect to have
>> an ISA PIC present through the isa_pic global variable.
>>=20
>> I guess we should be able to work around this, but I'm not sure if it's
>> really worth it. What do you think?
>
> You can add a paragraph saying that in the future the list could be
> reduced further.  I think that the direction we want to go is to only
> leave the IOAPIC around (the ISA devices in this respect are no
> different from the virtio-mmio devices).
>
> But you're right about isa_pic.  I wonder if it's as easy as this:
>
> diff --git a/hw/intc/apic.c b/hw/intc/apic.c
> index bce89911dc..5d03e48a19 100644
> --- a/hw/intc/apic.c
> +++ b/hw/intc/apic.c
> @@ -610,7 +610,7 @@ int apic_accept_pic_intr(DeviceState *dev)
>
>      if ((s->apicbase & MSR_IA32_APICBASE_ENABLE) =3D=3D 0 ||
>          (lvt0 & APIC_LVT_MASKED) =3D=3D 0)
> -        return 1;
> +        return isa_pic !=3D NULL;
>
>      return 0;
>  }

Yes, that would do the trick. There's another use of it at
hw/intc/ioapic.c:78, but we should be safe as, at least in the case of
Linux, DM_EXTINT is only used in check_timer(), which is only called if
it detects a i8259 PIC.

We should probably add an assertion with an informative message, just in
case.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LSdsACgkQ9GknjS8M
AjWegQ/9EE2PiYv9DBCPjcqLuNsTK5uyafPLtPc7FThRuBiqycTswI/DZ+oVZrZh
RNxP0g1o603hHzlSF+NqsXbfGMpI0w/6okW1lYYDe9o4yNyUeA1yx9VRGsQXl2+R
vUYFtcevHW5BJzdKp2Y13z9COsNeO18XtkupAq3mzDaadAoZNNZKKqIP7lC456mJ
4A7aheIUzwG7vuwQICz7gkyKPlcSrmgSptCob9cY9y9EiCKxpGMIOlqUh89o2QPS
9QrU3+MwgbK99Olqf4byEaUt0ktrO9kgaLHiST2mYNb4ptU083ucq+M09vyS6oxd
L9yFVrRs1LXCgyaMzw90Qq0P6liG3/GLMnXRq+itA+ks4NFibbENIVp4gF/1idb8
X59T8/ond3oGC/2LhYJ2hKJB6LF6kIwfLb+Ia2MVnqwhas9kjDFw0HuuonNOP/k+
0xB9ln5BD9Zg1ukVbc9vg1I9uT4Gdo1Grhpa1UZEMlJrJLFGVAkGvANRFyYYK3lU
57x0IHSrbhqwjI8R2GbeKR9N2631+qWqdq6biD2UW3EHgYvH3i+OIMj/8uvCHETl
IhqCxle7kfxB09WFlgtE7U0gnirp+t7+iBlWDg5soAA2n+zJCfuN9PsZ/PtLE8Sz
f7nM6pva96rAry+RUYTuLpv9a2Mrwxl/YGmtvc1eAYwIKMe9Pzk=
=umGR
-----END PGP SIGNATURE-----
--=-=-=--
