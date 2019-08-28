Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D79FC4B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 09:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1H4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 03:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfH1H4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 03:56:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F8DF30821C2;
        Wed, 28 Aug 2019 07:56:14 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07DBB60CC0;
        Wed, 28 Aug 2019 07:56:10 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Add storage key removal
 facility
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-4-frankja@linux.ibm.com>
 <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
 <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <b0349845-b759-2b28-7ba3-d3fbf6515dda@redhat.com>
Date:   Wed, 28 Aug 2019 09:56:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lAkWFrPUpj7JIzAfSAVxW3cfqTXNRv8ND"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 28 Aug 2019 07:56:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lAkWFrPUpj7JIzAfSAVxW3cfqTXNRv8ND
Content-Type: multipart/mixed; boundary="4Ug9b7HK1I31AlMdcC4gl1BOzabphiKlO";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <b0349845-b759-2b28-7ba3-d3fbf6515dda@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Add storage key removal
 facility
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-4-frankja@linux.ibm.com>
 <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
 <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>
In-Reply-To: <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>

--4Ug9b7HK1I31AlMdcC4gl1BOzabphiKlO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/08/2019 08.26, Janosch Frank wrote:
> On 8/27/19 7:58 PM, Thomas Huth wrote:
[...]
>> Anyway, I've now also checked this patch in the CI:
>>
>> diff a/s390x/Makefile b/s390x/Makefile
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -25,7 +25,7 @@ CFLAGS +=3D -std=3Dgnu99
>>  CFLAGS +=3D -ffreestanding
>>  CFLAGS +=3D -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
>>  CFLAGS +=3D -O2
>> -CFLAGS +=3D -march=3Dz900
>> +CFLAGS +=3D -march=3Dz10
>>  CFLAGS +=3D -fno-delete-null-pointer-checks
>>  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
>>
>> ... and it also seems to work fine with the TCG there:
>>
>> https://gitlab.com/huth/kvm-unit-tests/-/jobs/281450598
>>
>> So I think you can simply change it in the Makefile instead.
>=20
> z10 or directly something higher?

zEC12 seems to work, too:

https://gitlab.com/huth/kvm-unit-tests/-/jobs/281833366

 Thomas


--4Ug9b7HK1I31AlMdcC4gl1BOzabphiKlO--

--lAkWFrPUpj7JIzAfSAVxW3cfqTXNRv8ND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl1mM5kACgkQLtnXdP5w
LbVwIBAAo0UyIwnQvKYm/yFMdni7unGlRLXkdtQhESAU+JClqh4NyRl1qd8Vlh77
1dl0lzfLfo2jcZvvzVD3qjgI72ie43R0tsgrZBsehz3kxPXFkHS+8Pj9SqXFnOy5
JfLTq4H0hVs0G4w5yO4FgctVbpAeQryLqrG95De6UfLkN0yRu/NfiFn2M14NUecB
PAzhiccJOl8BtnTCNik589AmSYw6E74Hi1qSUsjm+tgqd8GISLUMlQPamQOUVgTE
5cqbaqrJWFI6JHnSK0k5jKCmh/34uRtfHXdiecxhBfycJ+4QPTZe0ORSElNbCNXT
fystxZp9RhZLQeO+fi90pmN+ERApuC71ejIclsTlowmVbOhes6AMVaI7QS4w3mUn
mEY/jF1WlNAGuPUi67zk1dmfDHHyA5I+I2KaTDSVzaqA+B5nJiyXyVQz7MrKUwxW
7WHfyGiz9JxhMXxJhmSfyHD+Xqc/BE0aA1pBN8W/zHvOEkXJDqmWYZpH/OtP48WN
pTBYzxaIioGJRk2Re8/rLsKj4Y8SVd/rTR6TvYODNjzESyIXMI6LsM6TFzlE9kGG
cpemx4vvyMWTdR3L/gTMkIfew3ww01NX2K085hXpJJh/LatKdiCa+8khCCX7StSw
zXCXExe85994hjkSYk531BdEIf1o5DoMJLgVZRsgKr9ZB9lmbok=
=Io3o
-----END PGP SIGNATURE-----

--lAkWFrPUpj7JIzAfSAVxW3cfqTXNRv8ND--
