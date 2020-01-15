Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07A13BA8C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 08:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAOH5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 02:57:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40998 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbgAOH5h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 02:57:37 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F7vKad115771
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 02:57:36 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfvq7d2em-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 02:57:35 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 15 Jan 2020 07:57:33 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Jan 2020 07:57:30 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00F7vT9m63176814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 07:57:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A6252059;
        Wed, 15 Jan 2020 07:57:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.31.155])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ECE8A52050;
        Wed, 15 Jan 2020 07:57:28 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: smp: Test all CRs on initial
 reset
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-4-frankja@linux.ibm.com>
 <2f190b0a-e403-51e6-27da-7f8f1f6289ac@de.ibm.com>
 <f120ad03-aab1-a863-636b-b11898d634f5@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 15 Jan 2020 08:57:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f120ad03-aab1-a863-636b-b11898d634f5@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vBBbXmGcok3QF50FuB84aEgrJ7w3XsN9e"
X-TM-AS-GCONF: 00
x-cbid: 20011507-0012-0000-0000-0000037D755F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011507-0013-0000-0000-000021B9A504
Message-Id: <3ee92240-56dc-69af-4fca-a4a2156e7749@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=974
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vBBbXmGcok3QF50FuB84aEgrJ7w3XsN9e
Content-Type: multipart/mixed; boundary="AFAUkDHrXccdbAl0TboW8fxUjDYvGY1Q1"

--AFAUkDHrXccdbAl0TboW8fxUjDYvGY1Q1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/15/20 7:17 AM, Thomas Huth wrote:
> On 14/01/2020 19.42, Christian Borntraeger wrote:
>>
>>
>> On 14.01.20 16:30, Janosch Frank wrote:
>>> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
>>> so we also need to test 1-13 and 15 for 0.
>>>
>>> And while we're at it, let's also set some values to cr 1, 7 and 13, =
so
>>> we can actually be sure that they will be zeroed.
>>
>> While it does not hurt to have it here, I think the register check for=
 the reset
>> would be better in a kselftest. This allows to check userspace AND gue=
st at the
>> same time.
>=20
> Agreed. Especially it also allows to test the kernel ioctl on its own,
> without QEMU in between (which might also clear some registers), so for=

> getting the new reset ioctls right, the selftests are certainly the
> better place.

Selftests are in development and will be up for discussion this week if
all goes well...

While the selftest leaves QEMU out of the picture, we're still using
kernel APIs to fetch and reset data, so actually getting guests'
register values requires some fiddling in the guest code. So I rather
have a test that tells me if KVM + QEMU are correct at the beginning of
testing, since that's what most people are using anyways.



--AFAUkDHrXccdbAl0TboW8fxUjDYvGY1Q1--

--vBBbXmGcok3QF50FuB84aEgrJ7w3XsN9e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4exegACgkQ41TmuOI4
ufjYLA/+NNuT0cVRCYpHl1I5cZ9RScsSBF7Nwg5DlhFADBp2wmnAiJ3cBWuKxPA7
J1vb1HVI2KGjAw7xbLMbxh0cZRkogM/6oJG7wfnBPwYxCHD/K4uYiuaEdAQ/9C7a
Y+0TUVJM0fpvZourC1s7QooQTIsoLXwdexYEhlfVjYRfAJDJ0bCUJvk2R2W7LdeF
8qBdB0mb8UNqhlKvZw/Ey4hfykOEgAfrNLc/cGmg1UWtpYr8M0p5Z6W7Df96zBVG
Y3zIiBOX5gFLpdz5LLey0wdWtu5c3mNrAoR+6EN3s+nwmxBm0ueIrxCSKL288vAK
hNXto970AZgiN4I3yvOzvgvFg6PXK57CPbjO1T+enXpsLouwgNPWz9a1Cz7wKRrv
JNClvOmJ09Jy4liFC9ZcDP1Fi32+yWGaYzznV52sXDOMHFjouxH3L0V9MO5nHSCL
5RqbsDGdWam8m4/cZtah3FA6BEgeHBoFg8erCVFHagiyYJGTwujEyp8rGOEyteHD
VqDRbyp6QHWLmF70gNeXqSpzYxVs6NJ1xpOhBGRXR8Ki8aYPjhQbAR1AfLSSF7PA
UDD7WAfwks9cjGIYQMuXzwc2E0POk0B8giJCpoP4xOUTpqWgCBDAb1gyAk6/XqjS
Lwq9XYvkfAH6s0vxSM+x2t9gezIuB0rjJ7F8pCUeHclNdlYo46w=
=4inW
-----END PGP SIGNATURE-----

--vBBbXmGcok3QF50FuB84aEgrJ7w3XsN9e--

