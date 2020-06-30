Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076E720FC78
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 21:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgF3TKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 15:10:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbgF3TKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 15:10:13 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UJ2OFN016735;
        Tue, 30 Jun 2020 15:10:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32042eyb3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 15:10:13 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05UJ5WUr025379;
        Tue, 30 Jun 2020 15:10:12 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32042eyb2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 15:10:12 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05UIiPV3023640;
        Tue, 30 Jun 2020 19:10:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 31wwr8tcvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Jun 2020 19:10:11 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05UJAB2H5636508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 19:10:11 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EED0EB2068;
        Tue, 30 Jun 2020 19:10:10 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74718B2064;
        Tue, 30 Jun 2020 19:10:10 +0000 (GMT)
Received: from [9.160.30.88] (unknown [9.160.30.88])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 30 Jun 2020 19:10:10 +0000 (GMT)
Subject: Re: [RFC PATCH v3 0/3] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200616195053.99253-1-farman@linux.ibm.com>
 <5ae6151b-31de-eca6-2917-4e23ecd4f0df@linux.ibm.com>
 <20200629165629.24f21585.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Autocrypt: addr=farman@linux.ibm.com; keydata=
 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
Message-ID: <02b20850-55cd-331a-8fb5-e9bec3386c2a@linux.ibm.com>
Date:   Tue, 30 Jun 2020 15:10:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629165629.24f21585.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DZ377plPwm31pIgKpRukNuGMwGNiL2quw"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 cotscore=-2147483648 spamscore=0 phishscore=0 mlxscore=0 suspectscore=2
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006300127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DZ377plPwm31pIgKpRukNuGMwGNiL2quw
Content-Type: multipart/mixed; boundary="dG7ZCo16tKZbI45eZdHNLXssd8jJzdNZy"

--dG7ZCo16tKZbI45eZdHNLXssd8jJzdNZy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 6/29/20 10:56 AM, Cornelia Huck wrote:
> On Wed, 17 Jun 2020 07:24:17 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
>=20
>> On 6/16/20 3:50 PM, Eric Farman wrote:
>>> Let's continue our discussion of the handling of vfio-ccw interrupts.=

>>>
>>> The initial fix [1] relied upon the interrupt path's examination of t=
he
>>> FSM state, and freeing all resources if it were CP_PENDING. But the
>>> interface used by HALT/CLEAR SUBCHANNEL doesn't affect the FSM state.=

>>> Consider this sequence:
>>>
>>>     CPU 1                           CPU 2
>>>     CLEAR (state=3DIDLE/no change)
>>>                                     START [2]
>>>     INTERRUPT (set state=3DIDLE)
>>>                                     INTERRUPT (set state=3DIDLE)
>>>
>>> This translates to a couple of possible scenarios:
>>>
>>>  A) The START gets a cc2 because of the outstanding CLEAR, -EBUSY is
>>>     returned, resources are freed, and state remains IDLE
>>>  B) The START gets a cc0 because the CLEAR has already presented an
>>>     interrupt, and state is set to CP_PENDING
>>>
>>> If the START gets a cc0 before the CLEAR INTERRUPT (stacked onto a
>>> workqueue by the IRQ context) gets a chance to run, then the INTERRUP=
T
>>> will release the channel program memory prematurely. If the two
>>> operations run concurrently, then the FSM state set to CP_PROCESSING
>>> will prevent the cp_free() from being invoked. But the io_mutex
>>> boundary on that path will pause itself until the START completes,
>>> and then allow the FSM to be reset to IDLE without considering the
>>> outstanding START. Neither scenario would be considered good.
>>>
>>> Having said all of that, in v2 Conny suggested [3] the following:
>>>  =20
>>>> - Detach the cp from the subchannel (or better, remove the 1:1
>>>>   relationship). By that I mean building the cp as a separately
>>>>   allocated structure (maybe embedding a kref, but that might not be=

>>>>   needed), and appending it to a list after SSCH with cc=3D0. Discar=
d it
>>>>   if cc!=3D0.
>>>> - Remove the CP_PENDING state. The state is either IDLE after any
>>>>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
>>>>   special state for SSCH.
>>>> - A successful CSCH removes the first queued request, if any.
>>>> - A final interrupt removes the first queued request, if any. =20
>>>
>>> What I have implemented here is basically this, with a few changes:
>>>
>>>  - I don't queue cp's. Since there should only be one START in proces=
s
>>>    at a time, and HALT/CLEAR doesn't build a cp, I didn't see a press=
ing
>>>    need to introduce that complexity.
>>>  - Furthermore, while I initially made a separately allocated cp, add=
ing
>>>    an alloc for a cp on each I/O AND moving the guest_cp alloc from t=
he
>>>    probe path to the I/O path seems excessive. So I implemented a
>>>    "started" flag to the cp, set after a cc0 from the START, and exam=
ine
>>>    that on the interrupt path to determine whether cp_free() is neede=
d. =20
>>
>> FYI... After a day or two of running, I sprung a kernel debug oops for=

>> list corruption in ccwchain_free(). I'm going to blame this piece, sin=
ce
>> it was the last thing I changed and I hadn't come across any such dama=
ge
>> since v2. So either "started" is a bad idea, or a broken one. Or both.=
 :)
>=20
> Have you come to any conclusion wrt 'started'? Not wanting to generate
> stress, just asking :)
>=20

I've talked myself out of it, and gone back to your original proposal of
a separately allocated cp. (Still no queuing.) Too early to pass
judgement though.

Yesterday, when running with a cp_free() call after a CSCH, I was
getting all sorts of errors very early on, so at the moment I've pulled
that back out again. If it looks good in this form, I'll put that as a
separate patch and write up some doc for a discussion on that point.


--dG7ZCo16tKZbI45eZdHNLXssd8jJzdNZy--

--DZ377plPwm31pIgKpRukNuGMwGNiL2quw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJe+44SAAoJELljG2S8dU+pJ6IH/1bQKIXTrFJFkdtKcDbNA9LK
C91575EJj5ErIBSU93JCuwCg6OByfkdF0No7g4KgwBTcg3CXa9rIO2+LcxHK4vBu
Z97E35nL0ghSLFQDvAuptiuw+11eZjrwws9h97QzV1xiMOq1d2WLJGR/vfjkdlDU
EGwY5/gSMMlLkB26ib2w//gHqMEpJghujSMCczQ6zLxIBH0en8pAd6mLdjH1/vba
5dVlkxBefYOSF3a6vTH/vX32ryKhj5Eqm13ofxWlpVUixevlToXzkOjty2N3KNSX
01KLq2RcfOjqMRNsXU84vWY7gYnq+DNUiTBtRK7J6FIvf/BqpC88MVpIZeF1KLM=
=uLzm
-----END PGP SIGNATURE-----

--DZ377plPwm31pIgKpRukNuGMwGNiL2quw--

