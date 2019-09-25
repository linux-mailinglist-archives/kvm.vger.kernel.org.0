Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4216BDAD9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfIYJXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbfIYJXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:23:05 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55FAA88305
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:23:04 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h6so2036696wrh.6
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 02:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=75vP+2MJBvefGCrTVRy48ER1COE2HocqUBh4GlZTNZY=;
        b=e5zYyTjzANdpdMCX+X355IhDJ2XzfNFUCk6ykajxBe+5S2NR+Ipcba2T0CWMs4mm5H
         i6yGfAZYlhrd/lhqEvfc1k20CvXLa0PrFV33N2vxd0f8hA6g1PV5jQELSXM+O/5FB9Dg
         Aj0F/GIMlCyerGxXojE3KhSE2h0/6i0j0YG7HDclYtl8+5P/snI7yE7G95vFOoOLS1co
         RoH9OXszNQURg0Yz+t7hJ1/HRXaAJSx7EEVpkCvjcMyMtvaztGZ9gZ1RCzfJJbp4Xw+O
         QPWLwT3/jJ2DAtJPeigDcSiy21r2cGFcBXi+RYVPGnosejTqbO1qhlxxPcsUMX8DS3jb
         Bdtg==
X-Gm-Message-State: APjAAAXgeUR/URDTxdGWG5ZTCSte6z48GmGgouhbDWNcqUOn75v4yZM2
        zvhlRdpQfob12E9+sbA2Cjx5HQIcSxuOvIlUSePx4gkQ7YLrdxc8PobSOPkZPX7L6p3htu3NSkQ
        uXRbVnQWfBpb1
X-Received: by 2002:a05:600c:141:: with SMTP id w1mr6426421wmm.75.1569403382658;
        Wed, 25 Sep 2019 02:23:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzZKlzMKTnmLQOSNwFctg98fghNWCdft5r5Y+uT0gchhbRWTBvSTQxcFm4yUaKLHRaab7uVYQ==
X-Received: by 2002:a05:600c:141:: with SMTP id w1mr6426384wmm.75.1569403382370;
        Wed, 25 Sep 2019 02:23:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id v8sm9511508wra.79.2019.09.25.02.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 02:23:01 -0700 (PDT)
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
 <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com> <87ftkksr9u.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com>
Date:   Wed, 25 Sep 2019 11:22:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87ftkksr9u.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Go22DeJ8CHMJ33w8s3bLyNTlICVs4vuRO"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Go22DeJ8CHMJ33w8s3bLyNTlICVs4vuRO
Content-Type: multipart/mixed; boundary="PKple2CdXrRnry8nK6YiAvZHZLK0YEOQr";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com>
 <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com> <87ftkksr9u.fsf@redhat.com>
In-Reply-To: <87ftkksr9u.fsf@redhat.com>

--PKple2CdXrRnry8nK6YiAvZHZLK0YEOQr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/09/19 10:40, Sergio Lopez wrote:
>>> We need the PIT for non-KVM accel (if present with KVM and
>>> kernel_irqchip_split =3D off, it basically becomes a placeholder)
>> Why?
>=20
> Perhaps I'm missing something. Is some other device supposed to be
> acting as a HW timer while running with TCG acceleration?

Sure, the LAPIC timer.  I wonder if Linux, however, wants to use the PIT
in order to calibrate the LAPIC timer if TSC deadline mode is unavailable=
=2E

>>> and the PIC for both the PIT and the ISA serial port.
>>
>> Can't the ISA serial port work with the IOAPIC?
>=20
> Hm... I'm not sure. I wanted to give it a try, but then noticed that
> multiple places in the code (like hw/intc/apic.c:560) do expect to have=

> an ISA PIC present through the isa_pic global variable.
>=20
> I guess we should be able to work around this, but I'm not sure if it's=

> really worth it. What do you think?

You can add a paragraph saying that in the future the list could be
reduced further.  I think that the direction we want to go is to only
leave the IOAPIC around (the ISA devices in this respect are no
different from the virtio-mmio devices).

But you're right about isa_pic.  I wonder if it's as easy as this:

diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index bce89911dc..5d03e48a19 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -610,7 +610,7 @@ int apic_accept_pic_intr(DeviceState *dev)

     if ((s->apicbase & MSR_IA32_APICBASE_ENABLE) =3D=3D 0 ||
         (lvt0 & APIC_LVT_MASKED) =3D=3D 0)
-        return 1;
+        return isa_pic !=3D NULL;

     return 0;
 }

Thanks,

Paolo


--PKple2CdXrRnry8nK6YiAvZHZLK0YEOQr--

--Go22DeJ8CHMJ33w8s3bLyNTlICVs4vuRO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2LMfMACgkQv/vSX3jH
roM12ggAkABdlQ9In+GxchMSxRw6z+yooeM6sT88LkAIxns3RvIA49BsUv/nOsPs
UNm/jI50Fw78LYTykv4x4qHHJRnoV7L3WFCwc/9q1ZZXEwT1miQhkV+lmBJk+jQR
HQq4uqH6wzeSDN8YiXsKCMWPt+Jhfw/ufWFZgGtsz2EpxCo3UN9aXyFh5HaR8HAJ
/ohH19TEEVtizMSW7oUX017bUlVoNARRwShXMjKWLGQHUH6vJnaNmYg4LPH2pXSU
YfxaNcff+35K+TabjJIv0pS/W9OYTepc/kHl1nlv6XJsxVuoOp5/g7a2WKmrtm2m
Y//wA/icK/7P7YYr2+HGnZsj0u2quw==
=BQuh
-----END PGP SIGNATURE-----

--Go22DeJ8CHMJ33w8s3bLyNTlICVs4vuRO--
