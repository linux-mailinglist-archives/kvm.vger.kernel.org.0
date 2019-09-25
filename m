Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31139BE2BF
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392001AbfIYQqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387922AbfIYQqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:46:49 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9DB33B738
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 16:46:48 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id t185so2332231wmg.4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=X7YFzOfAVchCcxH3XWuVQGSUW6YbXNCaigLfeevxIPY=;
        b=Drg7bjTa2rX0m/mC1sTj6txPSiD2LxlkcFRU59g2N01bq/JnNWS9tXd1EWyMTadFzb
         71fP2xtSqNvq12KgJkxstIu24pGSCb2CPIvAy+NIj2Zj6Ro+XWYIejvi94Eh/OZyN5cE
         7ym0Nz0pqkvqbJme+3nKhOuzjT1ehxCmE71gZiDTRIY0u/CVIx3saHq8t2jC9PWLnROG
         vl7FGmm6ky6IxwdpBZgzFL9uwn3TgFaBynj49S0beQqoZcZ6K/5TLMQr0zmQGrk8KROC
         KFNEypW5eP9T/scCBkfUrsakH5pwoxeRg+rOAGYIUH2WXMVHTquGB7PBOcGYpW3oIcpj
         8PpA==
X-Gm-Message-State: APjAAAV7DbKbHo6d840m0MZ3N7hie9bT0ZMU6JWxAlozkCRgEd0Zuh+P
        tAFa9RiYNyA0UXUQOJppqbX4JyK2d0OyhMwbc6DQk/VapW+y17Be1lSSDkJberff2L/DZcFycSe
        cp9H+TtLL81Ug
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr8463366wmc.106.1569430007211;
        Wed, 25 Sep 2019 09:46:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8IsSisqpRcgtpgERV145uk+s8N3VwCIWAluVOchilJzAHSd7C/X2cu8rzzW6vh4FC5bgxWg==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr8463347wmc.106.1569430006958;
        Wed, 25 Sep 2019 09:46:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id b22sm4959864wmj.36.2019.09.25.09.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:46:46 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d70d3812-fd84-b248-7965-cae15704e785@redhat.com>
Date:   Wed, 25 Sep 2019 18:46:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87a7ass9ho.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5tm1M1F58Yf5lz0Wk21bqJMURQODhbHNR"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5tm1M1F58Yf5lz0Wk21bqJMURQODhbHNR
Content-Type: multipart/mixed; boundary="D1wog4nmJbRr7fGJTC0s1dm5JzKzjOYCT";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <d70d3812-fd84-b248-7965-cae15704e785@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com>
In-Reply-To: <87a7ass9ho.fsf@redhat.com>

--D1wog4nmJbRr7fGJTC0s1dm5JzKzjOYCT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/09/19 17:04, Sergio Lopez wrote:
> I'm going back to this level of the thread, because after your
> suggestion I took a deeper look at how things work around the PIC, and
> discovered I was completely wrong about my assumptions.
>=20
> For virtio-mmio devices, given that we don't have the ability to
> configure vectors (as it's done in the PCI case) we're stuck with the
> ones provided by the platform PIC, which in the x86 case is the i8259
> (at least from Linux's perspective).
>=20
> So we can get rid of the IOAPIC, but we need to keep the i8259 (we have=

> both a userspace and a kernel implementation too, so it should be fine)=
=2E

Hmm...  I would have thought the vectors are just GSIs, which will be
configured to the IOAPIC if it is present.  Maybe something is causing
Linux to ignore the IOAPIC?

> As for the PIT, we can omit it if we're running with KVM acceleration,
> as kvmclock will be used to calculate loops per jiffie and avoid the
> calibration, leaving it enabled otherwise.

Can you make it an OnOffAuto property, and default to on iff !KVM?

Paolo


--D1wog4nmJbRr7fGJTC0s1dm5JzKzjOYCT--

--5tm1M1F58Yf5lz0Wk21bqJMURQODhbHNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2LmfQACgkQv/vSX3jH
roPqLgf/fADq+4BmYtHUsUQhtxvhNQ/Ampl+pdfcB814jrw6Q21Gdb7VzD4rHFYl
gH/1euoSW8GArThQtAVDp4cvJscvDCx7vL0gusl0lJniMFMc9ZJWivRbVTTxBfYW
k0/ZZYJ12HoMQcP0OAhAjdTbJANxk7gK2V5mNNT0K7jhkWbUoN1ku8nMHjMPoM/i
PrlEAyA1Og/j4jVN84aV3wnbyG6zT4G0Dze6ObLUY9e9JZoaUwDrrCivegaNmsiQ
fofPlZMHtlbkEL1EshbNy16pHR9hN5YH4A/YuhNSgcxIGdolkEdOVD1yeqrZWDn/
Ojnl7ZLgcl55HHhvwMFK/QJ3r2vUZA==
=mPMS
-----END PGP SIGNATURE-----

--5tm1M1F58Yf5lz0Wk21bqJMURQODhbHNR--
