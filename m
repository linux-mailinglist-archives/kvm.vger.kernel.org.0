Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AFA6472
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbfICI4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 04:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfICI4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 04:56:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CB543018761;
        Tue,  3 Sep 2019 08:56:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-51.ams2.redhat.com [10.36.117.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F23FA19D70;
        Tue,  3 Sep 2019 08:56:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: SMP test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-7-frankja@linux.ibm.com>
 <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
 <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <5281efbb-d236-17b7-0ae2-c9d8302e14b0@redhat.com>
Date:   Tue, 3 Sep 2019 10:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UOyCBDMZOfgwkr6L19nMhEPyZVXnBVnCu"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 03 Sep 2019 08:56:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UOyCBDMZOfgwkr6L19nMhEPyZVXnBVnCu
Content-Type: multipart/mixed; boundary="xr0S2C29r069nSfoX3CbZt3tKGL1mrofX";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <5281efbb-d236-17b7-0ae2-c9d8302e14b0@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: SMP test
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-7-frankja@linux.ibm.com>
 <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
 <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>
In-Reply-To: <03b3850b-ad7d-3b2c-957e-f236849d37b3@linux.ibm.com>

--xr0S2C29r069nSfoX3CbZt3tKGL1mrofX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 03/09/2019 10.44, Janosch Frank wrote:
> On 9/2/19 5:40 PM, Thomas Huth wrote:
>> On 29/08/2019 14.14, Janosch Frank wrote:
[...]
>>> +	smp_cpu_stop_store_status(1);
>>> +	mb();
>>> +	report("stop store status",
>>> +	       lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore);
>>
>> That confused me. Why does the prefix_sa of the lowcore of CPU 0 match=

>> the prefix of CPU 1 ? I'd rather expect cpu->lowcore->prefix_sa to
>> contain this value?
>=20
> Store status saves at absolute 0, i.e. we get the status in cpu0's lowc=
ore.

Ah, now that you mention it, the PoP indeed talks about "absolut"
locations here. TIL, thanks for the explanation!

 Thomas


--xr0S2C29r069nSfoX3CbZt3tKGL1mrofX--

--UOyCBDMZOfgwkr6L19nMhEPyZVXnBVnCu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl1uKscACgkQLtnXdP5w
LbV1fw/+LHwrrm4CJeHP3+vC4hbfWxe/paS0rEoUWt9SsqN5WPfXJNuHnSy4wzwp
eNW/93YXrSbQHIltGX859BmMQBqxQBwg14LgZkhtqh9mgMi/NJcDK6O0Hl0H/XMC
/HfpF9cFv3OkqZ0V50OmiidnHV+K7p9mpD+dYsA/hsIMf/FLM+2kaTYGkV1jKW8V
c1ZHU+ZrNBTwUIizB6Po8M6uXvC0LidNy3Ly86LWIE2XpEai1vezpm8+atRKvQD6
gNdh7O0Mfi1dMqDw0vWv1xJRmzxNCEkmDBX4WVfqiigmnu0Co/Ke/jf6OLstmz2R
8O3btLmYKZpInReu5LQxBzZyXIdgfmIYRnp2jHEoXVyENtzB7LE+5FMPMs0NGkfZ
x7y+h+q4W4dmTwm6+SiE3MhD8Po/+iY3wcal7wroRaMlUqS7s1uxyVLca94iP5Kv
xQSzT3nylSU9rTyQzSYKmkHoRW3suEtXa3uezDEZyNiDv9mKsM3XnZCc72QYUEmf
Q3ZbYuYODOQ/VQFDC+LxQRyLGHgKqSHS9pKX5GJGm4wyMiaeGqX24YoabV+OUhm7
nRh9BEEl4rNaOsb0ySA7HabEnaJKQ6s9um4sA6eht+X2X7A0cU5bCVFv0SxgnQEA
YOIXE6OplrTZ4OETtr77fFRDNdNSqL/T+vOdA+ew9YePw+IW0X4=
=Akpx
-----END PGP SIGNATURE-----

--UOyCBDMZOfgwkr6L19nMhEPyZVXnBVnCu--
