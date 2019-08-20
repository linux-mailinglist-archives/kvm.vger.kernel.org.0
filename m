Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F4C96462
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 17:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfHTP3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 11:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTP3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 11:29:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A43D308339B;
        Tue, 20 Aug 2019 15:29:16 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-232.ams2.redhat.com [10.36.116.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAFED5C206;
        Tue, 20 Aug 2019 15:29:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-3-frankja@linux.ibm.com>
 <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
 <caf41bc6-6dcf-fa68-6b44-d8bcc1479acb@linux.ibm.com>
 <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>
 <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <f07aa0b4-5ac1-ab09-0989-352ee6681436@redhat.com>
Date:   Tue, 20 Aug 2019 17:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z611oqS51spBhIIZNB9c5A6ps16KGaJhE"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 20 Aug 2019 15:29:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z611oqS51spBhIIZNB9c5A6ps16KGaJhE
Content-Type: multipart/mixed; boundary="xKoALVO9E6hDsP41gbRBNNxuUCLMWjMdg";
 protected-headers="v1"
From: Thomas Huth <thuth@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <f07aa0b4-5ac1-ab09-0989-352ee6681436@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-3-frankja@linux.ibm.com>
 <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
 <caf41bc6-6dcf-fa68-6b44-d8bcc1479acb@linux.ibm.com>
 <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>
 <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>
In-Reply-To: <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>

--xKoALVO9E6hDsP41gbRBNNxuUCLMWjMdg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/20/19 5:21 PM, Janosch Frank wrote:
> On 8/20/19 2:55 PM, Thomas Huth wrote:
>> On 8/20/19 2:25 PM, Janosch Frank wrote:
>>> On 8/20/19 1:59 PM, Thomas Huth wrote:
>>>> On 8/20/19 12:55 PM, Janosch Frank wrote:
> [...]
>>>> ... maybe we could also introduce such a variable as a global variab=
le
>>>> in lib/s390x/ since this is already the third or fourth time that we=
 use
>>>> it in the kvm-unit-tests...
>>>
>>> Sure I also thought about that, any particular place?
>>
>> No clue. Maybe lib/s390x/mmu.c ? Or a new file called lowcore.c ?
>>
>>>>> +static inline void diag288_uneven(void)
>>>>> +{
>>>>> +	register unsigned long fc asm("1") =3D 0;
>>>>> +	register unsigned long time asm("1") =3D 15;
>>>>
>>>> So you're setting register 1 twice? And "time" is not really used in=
 the
>>>> inline assembly below? How's that supposed to work? Looks like a bug=
 to
>>>> me... if not, please explain with a comment in the code here.
>>>
>>> Well I'm waiting for a spec exception here, so it doesn't have to wor=
k.> I'll probably just remove the register variables and do a:
>>>
>>> "diag %r1,%r2,0x288"
>>
>> Yes, I think that's easier to understand.
>>
>> BTW, is there another documentation of diag 288 beside the "CP
>> programming services" manual? At least my version of that specificatio=
n
>> does not say that the fc register has to be even...
>=20
> I used the non-public lpar documentation...

Ok, if it's specified there, then the check is fine with me.

>>>>> +static void test_bite(void)
>>>>> +{
>>>>> +	if (lc->restart_old_psw.addr) {
>>>>> +		report("restart", true);
>>>>> +		return;
>>>>> +	}
>>>>> +	lc->restart_new_psw.addr =3D (uint64_t)test_bite;
>>>>> +	diag288(CODE_INIT, 15, ACTION_RESTART);
>>>>> +	while(1) {};
>>>>
>>>> Should this maybe timeout after a minute or so?
>>>
>>> Well run_tests.sh does timeout externally.
>>> Do you need it backed into the test?
>>
>> I sometimes also run the tests without the wrapper script, so in that
>> case it would be convenient ... but I can also quit QEMU manually in
>> that case, so it's not a big issue.
>=20
> How about setting the clock comparator, that should trigger an
> unexpected external interrupt?

Sounds like an idea (if this is not getting too complicated... otherwise
just leave it as it is).

 Thomas



--xKoALVO9E6hDsP41gbRBNNxuUCLMWjMdg--

--z611oqS51spBhIIZNB9c5A6ps16KGaJhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7iIR+7gJQEY8+q5LtnXdP5wLbUFAl1cEcIACgkQLtnXdP5w
LbUSqA//avTRXV83gD2C7fHipO/1h+CwVDyWpTb3IROAgKSipiUOrlX3nvLNgps8
PLV4LW6TpqMkdvN9pgu56br66ylMoXuSaNkVmwj13EfRIzxxajz8RfTf6vDnkQV7
JJAJAnjRlcpdkiIjoEeETgfgmQ1HR06P1e5P2Y766GVQWuwYceBm0DWQh+wPjXIR
uMwOVzCle79Jdbhx1wiV/Ev7UEbt7e2WJlHuQtNaU62zxCIlcj+KXWenKIqKzM/d
SalDiPCq+62cX4IuTrQf9jbGeNeL1oNhUTKN5a6OQgXkToB94GSFkSP7S6oo/OHB
c6biVYSZ+M1Xv/9Wx8NoMcwoTg4QL/K7hxMoUIDBpir4Dn5cbIE85veAgJakmA8L
p9w3t5Gwnsye6C9a1QGxe1Y1vBXXSP3/yLt1CCUJrH6Tdy0J1EiOVorQ55Dlr37h
o6vwHI3bAZsINg8R77LiMWi3nNH4xi0InJxp2Ko1jAbufVLOR8Fi6mR9yttGa3Be
FCe5Xh8358gh7glQeIr3uo/C6z66hDPA6wa9pUSXWCtpjtKYkJl9jEkarC4kNIlG
OpqvWatl0XJ2rk5OqhD/Gt0p5SojhIZdcgucvau+dDgEkM2J/IIXJANIR+xkNJ4L
k0XK4LpiFzW2hdKnPML5MqY6SKZkbhHjxYR5sjTFo3+M2Nyc6lY=
=j4c8
-----END PGP SIGNATURE-----

--z611oqS51spBhIIZNB9c5A6ps16KGaJhE--
