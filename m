Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0549642E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfHTPV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 11:21:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730130AbfHTPV6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 11:21:58 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KF5ZwQ018089
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 11:21:57 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugjtsjd2y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 11:21:56 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 16:21:54 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 16:21:53 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KFLqrG56295550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 15:21:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EECDA4C052;
        Tue, 20 Aug 2019 15:21:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C45934C04E;
        Tue, 20 Aug 2019 15:21:51 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 15:21:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-3-frankja@linux.ibm.com>
 <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
 <caf41bc6-6dcf-fa68-6b44-d8bcc1479acb@linux.ibm.com>
 <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 20 Aug 2019 17:21:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KGIenJggKsyvV3ktyUQxtar3dawNrqlpr"
X-TM-AS-GCONF: 00
x-cbid: 19082015-0016-0000-0000-000002A0BE79
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082015-0017-0000-0000-00003300EE7E
Message-Id: <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KGIenJggKsyvV3ktyUQxtar3dawNrqlpr
Content-Type: multipart/mixed; boundary="MenTVVnVuYMPd55LzSSs1GcY7NAvaVN7W";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <56dad820-ea3c-27e0-c56c-7acc38632296@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Diag288 test
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <20190820105550.4991-3-frankja@linux.ibm.com>
 <6f25a51e-136e-1afb-215d-a2639fbd5510@redhat.com>
 <caf41bc6-6dcf-fa68-6b44-d8bcc1479acb@linux.ibm.com>
 <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>
In-Reply-To: <7e9f7043-14d9-8fc5-9302-cce8acdd5351@redhat.com>

--MenTVVnVuYMPd55LzSSs1GcY7NAvaVN7W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/20/19 2:55 PM, Thomas Huth wrote:
> On 8/20/19 2:25 PM, Janosch Frank wrote:
>> On 8/20/19 1:59 PM, Thomas Huth wrote:
>>> On 8/20/19 12:55 PM, Janosch Frank wrote:
[...]
>>> ... maybe we could also introduce such a variable as a global variabl=
e
>>> in lib/s390x/ since this is already the third or fourth time that we =
use
>>> it in the kvm-unit-tests...
>>
>> Sure I also thought about that, any particular place?
>=20
> No clue. Maybe lib/s390x/mmu.c ? Or a new file called lowcore.c ?
>=20
>>>> +static inline void diag288_uneven(void)
>>>> +{
>>>> +	register unsigned long fc asm("1") =3D 0;
>>>> +	register unsigned long time asm("1") =3D 15;
>>>
>>> So you're setting register 1 twice? And "time" is not really used in =
the
>>> inline assembly below? How's that supposed to work? Looks like a bug =
to
>>> me... if not, please explain with a comment in the code here.
>>
>> Well I'm waiting for a spec exception here, so it doesn't have to work=
=2E> I'll probably just remove the register variables and do a:
>>
>> "diag %r1,%r2,0x288"
>=20
> Yes, I think that's easier to understand.
>=20
> BTW, is there another documentation of diag 288 beside the "CP
> programming services" manual? At least my version of that specification=

> does not say that the fc register has to be even...

I used the non-public lpar documentation...

>=20
>>>> +static void test_bite(void)
>>>> +{
>>>> +	if (lc->restart_old_psw.addr) {
>>>> +		report("restart", true);
>>>> +		return;
>>>> +	}
>>>> +	lc->restart_new_psw.addr =3D (uint64_t)test_bite;
>>>> +	diag288(CODE_INIT, 15, ACTION_RESTART);
>>>> +	while(1) {};
>>>
>>> Should this maybe timeout after a minute or so?
>>
>> Well run_tests.sh does timeout externally.
>> Do you need it backed into the test?
>=20
> I sometimes also run the tests without the wrapper script, so in that
> case it would be convenient ... but I can also quit QEMU manually in
> that case, so it's not a big issue.

How about setting the clock comparator, that should trigger an
unexpected external interrupt?

>=20
>  Thomas
>=20



--MenTVVnVuYMPd55LzSSs1GcY7NAvaVN7W--

--KGIenJggKsyvV3ktyUQxtar3dawNrqlpr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1cEA8ACgkQ41TmuOI4
ufhoLw/+PBVaPVICGthwlZ0MYf2PxShJtfLYaioSsLKuuQcwezUrrWQwwIX1J4A6
Ez/fwEWDqh4QghPt+zhgxYYndmA6fT1Kvj80+ye26g8nHshhqlJS7p3/SEqj/Xoz
27uIRm0uUyZXvx3czYpViL60RqWXk+mgeeD13c5N4hGoPaUQ/3z/bjV/dKNNNeRZ
iPJkWVmvmHZncJqcdToKbLGRcWxH0Wrvh0P9HOzuMtYim62dWG9iqWgvwyI4gn1P
1Qf0PTcTtKrxt0zKD+pPoq6E7+KHuMJePsipPS+Fpef/W8163Gw1XILY6JqaiRrN
5150qoWBdVtriY6q0Y4C9nSbIrjMXPNmLDWRhqvdmPrXb8IpSmNLYTY/OuK+/iOC
Lfz1zvJS5MXJAT0OCFD4ytfBQhirZ9FNPyFVz5FYfID6HV8KkwsjjEbreltxSRgk
jT+Mx9aejWNvrTwf3yn6l0/aZTY1r17hNnlsAGJyv9prTZqRXXW/QJ8kfcM6dtx3
8RusQIOl9wyVoeOzRxMMj6eBrRbRtlktAGHbvSPqIsUaad7REimUtxclEM43kTIT
DPWls6oby3O2wNIY72B0tpPABq3Y4JbdlB+gXm1dIyGFsviOXK90xHQEVKAVoQMc
kOI82/wPrBAgvb6a1sFFtBY+L1HTCRDmLcbFOn7rDG5ucHyPPcY=
=OROU
-----END PGP SIGNATURE-----

--KGIenJggKsyvV3ktyUQxtar3dawNrqlpr--

