Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1CBEDEB
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 10:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfIZI6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 04:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfIZI6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 04:58:41 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E99AE89AC6
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 08:58:39 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so645332wrq.19
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 01:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=EvA5l+XTOz8/RuEyrxw/ntlMCxz7WCbSgf2f1bKTXbI=;
        b=jGmoKwoiIJ9dKysFwGjJwydJWx/in3vuyR6MGms/56qsOPQoOqQnf4W8Nb07MAHeeu
         FKv7jLVkaa7eCLW0RfjjodOPwGV43NK5+bWVMlrF1OIWJU2qcY1fcqZuqQQghLq6zdRd
         HX32M4BhcV1NcnrKsmaxUuMiXF6KsfU30qM8PhO+ncgUsQZ3DHDSb9ulL0x/MidmjiL9
         kr1A8gAsz7NJ88JlMJlN07n68Dv8L1LFFisZw+bQXKw5W82O7Fymia2eXusSBXQn1qP8
         wwt628aIK/WDI65pk2HZTOmDBwvuBlO67OxW/ArriL6sT6n5UE6uGQvpWvGiP8cY9i8+
         jLHA==
X-Gm-Message-State: APjAAAWuBShtgLLNElhXGAho+xkDDEhl3gt/cWRP2y1P/VsMbXos5QeH
        6E7Fs0tKfr3wAEQPTDTpX7f4eMEEef6M1emw9rDbbGtYkR9oVuOxCTI2ZaNUVRObTO3NojYMt+c
        XznMr4FMjHUCL
X-Received: by 2002:adf:cf06:: with SMTP id o6mr1982974wrj.366.1569488318312;
        Thu, 26 Sep 2019 01:58:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzs4ac9R/2flZPy2xnzFFvSU65JOwFaYfb7vTKzGoGLGNYWNbzHGcdCuw8kvSw70+PexCh6AQ==
X-Received: by 2002:adf:cf06:: with SMTP id o6mr1982963wrj.366.1569488317995;
        Thu, 26 Sep 2019 01:58:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id a14sm1908827wmm.44.2019.09.26.01.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:58:36 -0700 (PDT)
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
 <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com>
Date:   Thu, 26 Sep 2019 10:58:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87o8z737am.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xs2VwYdKVKnb7nurjqEof2Su9l6q21oE1"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xs2VwYdKVKnb7nurjqEof2Su9l6q21oE1
Content-Type: multipart/mixed; boundary="SPDh8eKColRzEIIRfqlV7zIrkQOX5Kuzf";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com>
 <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com>
In-Reply-To: <87o8z737am.fsf@redhat.com>

--SPDh8eKColRzEIIRfqlV7zIrkQOX5Kuzf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/09/19 08:23, Sergio Lopez wrote:
>=20
> There's still one problem. If the Guest doesn't have TSC_DEADLINE_TIME,=

> Linux hangs on APIC timer calibration. I'm looking for a way to work
> around this. Worst case scenario, we can check for that feature and add=

> both PIC and PIT if is missing.
>=20

Huh, that's a silly thing that Linux is doing!  If KVM is in use, the
LAPIC timer frequency is known to be 1 GHz.

arch/x86/kernel/kvm.c can just set

	lapic_timer_period =3D 1000000000 / HZ;

and that should disabled LAPIC calibration if TSC deadline is absent.

Paolo


--SPDh8eKColRzEIIRfqlV7zIrkQOX5Kuzf--

--xs2VwYdKVKnb7nurjqEof2Su9l6q21oE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2MfbsACgkQv/vSX3jH
roPPkAf+M4M4xIhSXRUCGoCldxLPjeNZIek0gwMJyFLyJ2vln4OheCw3nYGJnm47
MYH45FPudx02mPPrukiYuZlsnLJqNJpIPyiWKCUbYlysCEIZon90tkRbSkgraomS
7R2SJhikKL1Ad6kujFGObebFSR3aZmDPNX04Cg6Rk0CA5akpvSh+hOkI4uWu9CrW
E9nk0wUZLRl8trf0t3HxJ0eeTtKcMmoOdryDtGUYvYTBKCKwiPClNbx4Ai5ML4zy
B5Ja3/xRwrlWfOW8WeKu21nUY/eTSmPJOK2V1+yTq9ekJ3hPCzp4a3XxXPy5kD/h
MenB4Am7dnVVGxq6/IUkyeD6+RGR+Q==
=bWFM
-----END PGP SIGNATURE-----

--xs2VwYdKVKnb7nurjqEof2Su9l6q21oE1--
