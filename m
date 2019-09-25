Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C22CBD96C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442657AbfIYH5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35565 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438033AbfIYH5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:57:49 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23C22796EF
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 07:57:49 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id j2so1914738wre.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 00:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=BBQ1WGoO/qpGXB8rTiM/z99z3rGQOB6O69irsJbKsnU=;
        b=XvVMaIca/2Lu6cJEuuXqYreH1d633a856TNVXTH7OVRF/nvDgcXNmwQ+asKk9WJY1u
         9enb5Tz+fjdtigDW0wYIBHki51cKdFdoQpE3fi7KZ3/Hw+lJvsEZowVdIrALPDuFfFvD
         eiTN2/i9sX8hRbHzoDj/UhAeYhcedPS3W2CPtkm77UULcRvLalCNoGiKHCoKDFNgCind
         TzZi+9/4ynCQVc3a9zxQ3sPBbO1zcpJ2lt2e+2uF/UIcfbV2Xb3MaK4vnCtskBXwOQ6T
         SD4LsXKkpr8R3PhUoBazTUh5KOPqq+nOWlH9PjDwJyUb0oVGm7FgoAunbu37/oQ+nX1i
         3XlQ==
X-Gm-Message-State: APjAAAWoFPUuQDProqcZoElpWUOqyEaEg0QJ58vRHRwGTo9OjMDJRUwk
        xzPJg1lAAEsIuwye4Bw9aY+PWB9dV2SNCHs5XfGp9IsfS8GWtxxK8z8QCmXMOBIJQWNGbTVh8zL
        w11KjZaj3Wtyt
X-Received: by 2002:adf:e612:: with SMTP id p18mr7411325wrm.218.1569398267322;
        Wed, 25 Sep 2019 00:57:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwd4+QLxS9sts/MKqAeE/q13HOjkkPx3B9bGMmHMxIRdr2EEBa0pQkRo+6Kv7Nvkky4+4R+sg==
X-Received: by 2002:adf:e612:: with SMTP id p18mr7411287wrm.218.1569398267049;
        Wed, 25 Sep 2019 00:57:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id y5sm3056418wma.14.2019.09.25.00.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 00:57:46 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com>
Date:   Wed, 25 Sep 2019 09:57:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87r245rkld.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mDVZVal97fA1LjnG3jStglsB6w8rGOwz9"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mDVZVal97fA1LjnG3jStglsB6w8rGOwz9
Content-Type: multipart/mixed; boundary="9K0MbSTT8fXB0xcZQYs5vcslLqWEvV6qU";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com>
In-Reply-To: <87r245rkld.fsf@redhat.com>

--9K0MbSTT8fXB0xcZQYs5vcslLqWEvV6qU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/09/19 07:49, Sergio Lopez wrote:
>>> +serving as a stepping stone
>>> +for future projects aiming at improving boot times, reducing the
>>> +attack surface and slimming down QEMU's footprint.
>>
>> "Microvm also establishes a baseline for benchmarking QEMU and operati=
ng
>> systems, since it is optimized for both boot time and footprint".
>=20
> Well, I prefer my paragraph, but I'm good with either.

You're right my version sort of missed the point.  What about
s/benchmarking/benchmarking and optimizing/?

>>> +The microvm machine type supports the following devices:
>>> +
>>> + - ISA bus
>>> + - i8259 PIC
>>> + - LAPIC (implicit if using KVM)
>>> + - IOAPIC (defaults to kernel_irqchip_split =3D true)
>>> + - i8254 PIT
>>
>> Do we need the PIT?  And perhaps the PIC even?
>=20
> We need the PIT for non-KVM accel (if present with KVM and
> kernel_irqchip_split =3D off, it basically becomes a placeholder)

Why?

> and the
> PIC for both the PIT and the ISA serial port.

Can't the ISA serial port work with the IOAPIC?

Paolo


--9K0MbSTT8fXB0xcZQYs5vcslLqWEvV6qU--

--mDVZVal97fA1LjnG3jStglsB6w8rGOwz9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2LHfgACgkQv/vSX3jH
roOpQgf/aiQvLFYTNQI5a6Bco3E6++pojDnNgz29HoMJn52fu5lGxi5AVMra2FjG
uMSNDat8wB1yUkCIbjMGPmhFf2pcYfRu+AP7iN1ULr4Xg9EEdD1piIJPaKPry8PU
qdrNFe1TYgZeTrjRaxCedEYl9y9u68y0YnqGGgfXuNz/hGgSrpKj9psBs9V6oJnZ
QYU26ahyJ5w7SV0BnIK//TkNwhme4XBNwKMjAiicm8hfkY8PwdM6QkHzvyOuKvHn
50rjvAR+jlaHJiJTbn4Z7+XYrGIZrPq0mYWU3NU0TBk/aOpTRUVRKx3DmJQzM3vI
s3W5rayLrNXsf14sKp/hfxpwQ1Utlg==
=dw3J
-----END PGP SIGNATURE-----

--mDVZVal97fA1LjnG3jStglsB6w8rGOwz9--
