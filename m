Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FBE1D48DE
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 10:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgEOIxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 04:53:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgEOIxW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 04:53:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F8X1X3040450;
        Fri, 15 May 2020 04:53:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w9ht2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 04:53:21 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F8XA6l041242;
        Fri, 15 May 2020 04:53:20 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3111w9ht19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 04:53:20 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F8p1WJ005618;
        Fri, 15 May 2020 08:53:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3100uba5wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 08:53:18 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F8q4gX65798480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 08:52:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BD6542042;
        Fri, 15 May 2020 08:53:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A907F4203F;
        Fri, 15 May 2020 08:53:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 08:53:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 07/10] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-8-git-send-email-pmorel@linux.ibm.com>
 <cff917e0-f7e0-fd48-eda5-0cbe8173ae8a@linux.ibm.com>
 <abafd691-d9ab-33b2-c522-d37fecc3e881@linux.ibm.com>
 <20200514140808.269f6485.cohuck@redhat.com>
 <de18eab3-4d0a-1b86-f6c4-27aaa7bba6bf@linux.ibm.com>
 <20200515102548.0f43419d.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e0d0d9f5-c780-404a-6cc8-31cbb077cf6f@linux.ibm.com>
Date:   Fri, 15 May 2020 10:53:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200515102548.0f43419d.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TBPAekG58od7S0E9YdejM3MOwIQgWsSbz"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 cotscore=-2147483648 clxscore=1015 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TBPAekG58od7S0E9YdejM3MOwIQgWsSbz
Content-Type: multipart/mixed; boundary="ulXHkJguE55szB728VdhNLGcWEQ1dkoyY"

--ulXHkJguE55szB728VdhNLGcWEQ1dkoyY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/15/20 10:25 AM, Cornelia Huck wrote:
> On Fri, 15 May 2020 09:11:52 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>=20
>> On 2020-05-14 14:08, Cornelia Huck wrote:
>>> On Tue, 28 Apr 2020 10:27:36 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>  =20
>>>> On 2020-04-27 15:11, Janosch Frank wrote: =20
>>>>> On 4/24/20 12:45 PM, Pierre Morel wrote: =20
>>>  =20
>>>>>> This is NOT a routine to really enable the channel, no retry is do=
ne,
>>>>>> in case of error, a report is made. =20
>>>>>
>>>>> Would we expect needing retries for the pong device? =20
>>>>
>>>> Yes it can be that we need to retry some instructions if we want the=
m to
>>>> succeed.
>>>> This is the case for example if we develop a driver for an operating=
 system.
>>>> When working with firmware, sometime, things do not work at the firs=
t
>>>> time. Mostly due to races in silicium, firmware or hypervisor or bet=
ween
>>>> them all.
>>>>
>>>> Since our purpose is to detect such problems we do not retry
>>>> instructions but report the error.
>>>>
>>>> If we detect such problem we may in the future enhance the tests. =20
>>>
>>> I think I've seen retries needed on z/VM in the past; do you know if
>>> that still happens?
>>>  =20
>>
>> I did not try the tests under z/VM, nor direct on an LPAR, only under =

>> QEMU/KVM.
>> Under QEMU/KVM, I did not encounter any need for retry, 100% of the=20
>> enabled succeeded on first try.
>=20
> Yep, QEMU/KVM should be fine. Do you plan to run this on anything else?=

>=20

I'd like to have it compatible with z/VM / LPAR as well if it isn't too
much work. You never know when you need it and having tests for all
hypervisors has been quite a help in the past.


--ulXHkJguE55szB728VdhNLGcWEQ1dkoyY--

--TBPAekG58od7S0E9YdejM3MOwIQgWsSbz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6+WHsACgkQ41TmuOI4
ufgRJg/9EJC83gtV3QKiqLQTcAo/mogQMOmZuYguxwXk3VZKFg+OdKZQuqq+plQR
jUs2dhHfhUURDm38nSRStYgjsPsYAqAZvXGHMb2rPK4GX8jyrCtKOO7QhWvlthAv
tQfusgPmSfpcL1p/L2dtIefOJ+5V4OVX9UmaWcjDZsusfB6ZHbnH7bcZMh4HRn7K
JeN99Q46j9b8V4Uug/Jyk35AvqcWqQRnGJ7aVCcWGTEby6dU1I8Q9PV0aZpZt5kI
URbqNHhION+fX9jEIhFFWGXlXA+wJVXifZn1vlL+gof31jbYAO7AWSAh1zdo3zMC
U/qLtcVZkODpp70fN6bADcXs8OUVGf/eaAavH/CjUqcTJJTyhH7PeOSR5QI3I7aD
7xyRqx789aAJMXmH/9YNK2qUNE/JOE3r06hi/mmnBwbrb1IynHRBB+I9uigB80ae
iBBxa/3aBBuUBbyydodntFeArdziZJJuU/TXovbmSBs79qayi+HZN3hKMEvqx606
y/oCDaVPRIoHbSuY2We5uU5I3GYgpWSooYjaKTLKo3m5UdNWPmQCxX/O9ipN+9zy
mnz9S6LAAoN+P5Pzpy1y+6p5+PEkq8FDuBA41N1TcOfWkINmeTDWRJMMpV4FcKhl
pN+MYffa98xgUadMNOCLyviZAXeT/7CDBDP764wHH7CscGt1Fp4=
=m650
-----END PGP SIGNATURE-----

--TBPAekG58od7S0E9YdejM3MOwIQgWsSbz--

