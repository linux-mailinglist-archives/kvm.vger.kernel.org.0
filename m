Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6AABDA04
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406899AbfIYIkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406947AbfIYIkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:40:19 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E8F211A23
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:40:18 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id v18so1964146wro.16
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4bXVG8rG63RRdivHFVgYwdhQLE7BFDAw2IIkR800VUc=;
        b=X1M1gZI4St/TBA9982HqOkEeoilz34vuyRhGzJqe1TCCkXdTGr2xAFYm4I81A8Q+Ie
         klwfyPvDVGyZpkOXQv0SYElVb+iQ7os1wmzx7zFBhBrGND0r2VFlXvVyHaSqFPdfe1Bw
         NBZ6nEQMpq/wmOuFTM9kJqOp68CEAUEM9VCHvvWJMM5cQrYJOORSdT3TzgWptcsSNBtR
         EUA5AuvcDajSoM01aL8pyq2A/a+gE7q+6WK09fHVBoIPpZhbp/cg9ukIxPCizCH2xr07
         cq8SSZA5o6z8ZNqARs8P9wLDuuTS1HioozeeMbUCoXStm9fQraK5/TnY8HYBJfWyRZhZ
         AluQ==
X-Gm-Message-State: APjAAAU9hVPzfUYurVS5XEmgyNW8mTF5NboVzQKfkcUQ96aibj7ZDB4d
        elk0C9U88eVbD334EFHUBNs8cz2VvIPB80Eq/mfDO8BllE2q1yZFv4yrcGLqUTHUtk1HxAIkyca
        DeILGNCZtBInb
X-Received: by 2002:a5d:5592:: with SMTP id i18mr7787753wrv.316.1569400816774;
        Wed, 25 Sep 2019 01:40:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy6InE01KCSIgG6LkFA8WJSjztS/3DwfUBnCsq0RGxy1GJ8STDnpt0XVvElcURKW6gqBLkh1g==
X-Received: by 2002:a5d:5592:: with SMTP id i18mr7787718wrv.316.1569400816576;
        Wed, 25 Sep 2019 01:40:16 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id x16sm3664590wrl.32.2019.09.25.01.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 01:40:15 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com> <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com>
Date:   Wed, 25 Sep 2019 10:40:13 +0200
Message-ID: <87ftkksr9u.fsf@redhat.com>
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

> On 25/09/19 07:49, Sergio Lopez wrote:
>>>> +serving as a stepping stone
>>>> +for future projects aiming at improving boot times, reducing the
>>>> +attack surface and slimming down QEMU's footprint.
>>>
>>> "Microvm also establishes a baseline for benchmarking QEMU and operating
>>> systems, since it is optimized for both boot time and footprint".
>>=20
>> Well, I prefer my paragraph, but I'm good with either.
>
> You're right my version sort of missed the point.  What about
> s/benchmarking/benchmarking and optimizing/?
>
>>>> +The microvm machine type supports the following devices:
>>>> +
>>>> + - ISA bus
>>>> + - i8259 PIC
>>>> + - LAPIC (implicit if using KVM)
>>>> + - IOAPIC (defaults to kernel_irqchip_split =3D true)
>>>> + - i8254 PIT
>>>
>>> Do we need the PIT?  And perhaps the PIC even?
>>=20
>> We need the PIT for non-KVM accel (if present with KVM and
>> kernel_irqchip_split =3D off, it basically becomes a placeholder)
>
> Why?

Perhaps I'm missing something. Is some other device supposed to be
acting as a HW timer while running with TCG acceleration?

>> and the
>> PIC for both the PIT and the ISA serial port.
>
> Can't the ISA serial port work with the IOAPIC?

Hm... I'm not sure. I wanted to give it a try, but then noticed that
multiple places in the code (like hw/intc/apic.c:560) do expect to have
an ISA PIC present through the isa_pic global variable.

I guess we should be able to work around this, but I'm not sure if it's
really worth it. What do you think?

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LJ+0ACgkQ9GknjS8M
AjXcGA/+IYeN5JXsg5RjjhgQaQBE10F9NW4wT0FJkcXyzGlUk88RucLVjRw7mRP2
G2wfE81DPRXoJDFPfXebHUOpgpfN/dT53VLi2K1xBUNOdQ3yT5oWr5W/c22eyCZ6
6In5k+9WMKhT1HzDElhhlLK8A5u/soQHSJmFpNLQLWWmXuVjQ9wkfBNG5WsyfaOW
NHGus2A6lv5bUkcAerVcQukHcBuTs/9+nsDC3pCfrizVv03UivK36wrhf6br5vxO
9G+u/v5eFyn3fCQu1m8RFdRdQQ36Sze4HuB+79AM/Jin0mpVqpnTzn+cPd6mgypg
YdEb5Qraj+baxsAC3/+si3byinX4yeJRWcLektI5pt3TrZaMu3MdAGhkIw+CZrf+
6i2JMZCwdKJgdapESQz/O/nv/vEdWzHf9CZ35DfmtVMKzWXIE3MmFgVaLBpIi7Kb
xNu6U0zJtZr7aMJL/m7ZC7RfN2BDXdAPsB4SCvoBtALCTc6Kcm8v3tKBDFHcAwCp
/QGisQtJ2mMtrGtaVXNymumqPdBWygHVJ7O5vTGpghmAq2/zcTS1mAnx1whZwE1P
ppyu+mGMsVNGEaW//UEQt84hUdCVdDGCC7luRPEh1R7KUBaIJjArhAcDv1hcx+K4
86j0lSFsaPDxE1Qlj9LKdqPftzRIORZaN0t4619iOX3KY72xWQ4=
=A1ya
-----END PGP SIGNATURE-----
--=-=-=--
