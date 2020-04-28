Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE81BB9AE
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 11:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgD1JUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 05:20:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbgD1JUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 05:20:11 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S93onr057907;
        Tue, 28 Apr 2020 05:20:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhdyen6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 05:20:10 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S96aMR066964;
        Tue, 28 Apr 2020 05:20:10 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mfhdyeky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 05:20:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S99oeO017457;
        Tue, 28 Apr 2020 09:20:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5nry1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 09:20:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S9K52u42991734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 09:20:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A619911C04A;
        Tue, 28 Apr 2020 09:20:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FD8B11C050;
        Tue, 28 Apr 2020 09:20:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.94.10])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 09:20:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 08/10] s390x: define wfi: wait for
 interrupt
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-9-git-send-email-pmorel@linux.ibm.com>
 <4cc33b1c-7fa2-0775-f176-08bb31b7e68e@linux.ibm.com>
 <60b951c7-2fa2-2284-db04-33e422974626@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <84cf8f4f-4d29-8ff5-0d84-5c9b0b52ff34@linux.ibm.com>
Date:   Tue, 28 Apr 2020 11:20:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <60b951c7-2fa2-2284-db04-33e422974626@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cZmmoQzVPj1RTwcvtr6jtzPlHZtnRNM6E"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_05:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=872
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cZmmoQzVPj1RTwcvtr6jtzPlHZtnRNM6E
Content-Type: multipart/mixed; boundary="W9I43BBl8msrJMTwFXBWBH5LOYLEZo6Ux"

--W9I43BBl8msrJMTwFXBWBH5LOYLEZo6Ux
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/28/20 10:44 AM, Pierre Morel wrote:
>=20
>=20
> On 2020-04-27 14:59, Janosch Frank wrote:
>> On 4/24/20 12:45 PM, Pierre Morel wrote:
>>> wfi(irq_mask) allows the programm to wait for an interrupt.
>>
>> s/programm/program/
>=20
> Thx,
>=20
>>
>>> The interrupt handler is in charge to remove the WAIT bit
>>> when it finished handling interrupt.
>>
>> ...finished handling the interrupt.
>=20
> OK, thx
>=20
>>
>=20
>>>   }
>>>  =20
>>> +static inline void wfi(uint64_t irq_mask)
>>
>> enabled_wait()
>=20
>=20
> I do not like enabled_wait(), we do not know what is enabled and we do =

> not know what we are waiting for.
>=20
> What about wait_for_interrupt()

As long as it's not called wfi...

>=20
>>
>>> +{
>>> +	uint64_t psw_mask;
>>
>> You can directly initialize this variable.
>>
>>> +
>>> +	psw_mask =3D extract_psw_mask();
>>> +	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
>>
>> Maybe add a comment here:
>>
>> /*
>>   * After being woken and having processed the interrupt, let's restor=
e
>> the PSW mask.
>> */
>>
>>> +	load_psw_mask(psw_mask);
>>> +}
>>> +
>=20
> I can do this, but wasn't it obvious?

It took me a minute, so it will take even longer for developers that are
not yet familiar with s390 kernel development.

>=20
>=20
> Regards,
> Pierre
>=20



--W9I43BBl8msrJMTwFXBWBH5LOYLEZo6Ux--

--cZmmoQzVPj1RTwcvtr6jtzPlHZtnRNM6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6n9UQACgkQ41TmuOI4
ufgsnRAAl5jtiENoqnLZjLOtGWFIjA81tcHJrcKl5z1ZEPpjHGAucbTi8e7tDlJS
oaAYoUzbh9v+m7a1TGce7a2f9v2dFRLW/hmaBqbk1FIVDeYKw9+IZaNuSu1W1eBn
K/pgopwlnpBElFOIO3mRjIJ3cSFmOsLkOYFVRYkjcDa2i/HV3mAyFIHjm7fg4p+X
FMsucJ1ElCEaakfGuKMHwyNzEe6NJGh8eiDTXmhuapVvmqivtQMJJSDakyMy+1GT
SUjWQCUKCjspL6GWaopo8GoCZGC787Eph9hcDGsjRPaalJYkFWkD/3c9/GA148BZ
211w+tUOhoE6k56uCgLvN9E39WQv0gsgBe4mSdpgKk4EiEocEsRWMQYgmFnQiKbe
X5URqC4DizqH5C7Hz4fTPH9LxHbXMZcRxeupPJHcJDR02hmwW++qGYqugP4NyZrP
Olqqw8GUGRUagAmcZMT2Z3GeQE9iW195V7inUaM1fLxamZjEPILH524zMSaywq6z
3qbc07fZynhuBquBy4ErDI2oKpUpeoB8EImE2ZoXV4kV4P70UOQdN18Ug0dHPfvA
M9kN4bWqfWN5M2wWThALF3zI2JELkWj50oD/dIb3IXI0p7d9/iEoEh0m5f7j2YyG
aGkOHLdH7rgmb8qx+4nQglwSFOw1M+RIixITjCpAccs5EUitYpw=
=vJHW
-----END PGP SIGNATURE-----

--cZmmoQzVPj1RTwcvtr6jtzPlHZtnRNM6E--

