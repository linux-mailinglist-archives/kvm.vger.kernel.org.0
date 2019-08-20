Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1006A95DC8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 13:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfHTLtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 07:49:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729672AbfHTLtZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Aug 2019 07:49:25 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KBlfKr027833
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 07:49:25 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugdc5rder-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 07:49:21 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 20 Aug 2019 12:49:14 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 12:49:11 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KBnAJb59899972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 11:49:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A27711C04A;
        Tue, 20 Aug 2019 11:49:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36E9511C054;
        Tue, 20 Aug 2019 11:49:10 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 11:49:10 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 0/3] s390x: More emulation tests
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <cc5291cd-0bd8-73aa-dfdc-f0cf9de4f405@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 20 Aug 2019 13:49:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cc5291cd-0bd8-73aa-dfdc-f0cf9de4f405@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="M99FZaYYGJU8BNewfv04iLvxa4mqMb1GY"
X-TM-AS-GCONF: 00
x-cbid: 19082011-0008-0000-0000-0000030B0750
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082011-0009-0000-0000-00004A292E51
Message-Id: <0f6187b2-9ff1-c645-9d64-5e3384999306@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M99FZaYYGJU8BNewfv04iLvxa4mqMb1GY
Content-Type: multipart/mixed; boundary="BcuBR1rCJGFE5Yoic7kElnlTvUCqllWco";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <0f6187b2-9ff1-c645-9d64-5e3384999306@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] s390x: More emulation tests
References: <20190820105550.4991-1-frankja@linux.ibm.com>
 <cc5291cd-0bd8-73aa-dfdc-f0cf9de4f405@redhat.com>
In-Reply-To: <cc5291cd-0bd8-73aa-dfdc-f0cf9de4f405@redhat.com>

--BcuBR1rCJGFE5Yoic7kElnlTvUCqllWco
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/20/19 1:11 PM, David Hildenbrand wrote:
> On 20.08.19 12:55, Janosch Frank wrote:
>> The first patch allows for CECSIM booting via PSW restart.
>> The other ones add diag288 and STSI tests.
>>
>> I chose to start with these since they are low controversy. My queue
>> still contains the sclp patches and a simple smp library with
>> tests. They will follow later.
>>
>> Janosch Frank (3):
>>   s390x: Support PSW restart boot
>>   s390x: Diag288 test
>>   s390x: STSI tests
>>
>>  s390x/Makefile      |   2 +
>>  s390x/diag288.c     | 111 +++++++++++++++++++++++++++++++++++++++
>>  s390x/flat.lds      |  14 +++--
>>  s390x/stsi.c        | 123 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |   7 +++
>>  5 files changed, 252 insertions(+), 5 deletions(-)
>>  create mode 100644 s390x/diag288.c
>>  create mode 100644 s390x/stsi.c
>>
>=20
> Just wondering, did you try them with TCG as well? (or do I have to tes=
t)
>=20

No, they are also pending for z/VM and LPAR testing (well at least for
STSI).
They have been running with a fmt2 and a fmt4 SIE description though.

I'll speak with the CI people here to add a TCG test.


--BcuBR1rCJGFE5Yoic7kElnlTvUCqllWco--

--M99FZaYYGJU8BNewfv04iLvxa4mqMb1GY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1b3jUACgkQ41TmuOI4
ufinuA//fObB7Gdszy9q12aONuQupTKA4MlIT34Vq/Lz2/M2qgPWXaQQVHCaSLSx
xtkYwfibMw7mdOYU1IbBPZEsEDiznqjLiKJHFwVCM+DosPPoqSjvpclYqYYFvoHW
nheJpUpcujFFhTj1HP2HZ6nKF92E1b0lu7a16/F/7dKPmMouVzQDBY3eQaVXlkD0
bukuOl7DwZg5aXvbHdj8SpyNdw+oH1rI/YrpguZ7rtSmEWlKyll7AAtKi2MYVLQG
ZqokRofDc0gjD/mPNqRU/PKHUWkonou0i/ymRCF1S3qJ92lz46husI0luxzUFJ6X
HzwneS6FaR6Eb7QFAC/tocT0CT4ouwhi55/VfRK6fkx7zqe2hAvfV11ftRy+FD1Y
9nXEHG4MW5mfK5dZ95ZwaGiwHVN0kthtZK06cjwxgO/Y7+Co51ExiE5UeP+Fn9S1
MA+JDwzla2ANZpKZcfglLRSbEzVkwwsO+0JU3F+GmzOjZ/3LnSF++ntZ49+3CUD9
Q8ZalgL02XIscJ7Xrs4DXWntctgd5vczaDhwfj8aNCmFtCTRDjJQz5UNFXzOLLlp
ouauT1l0HMOod+q5iiOj686jc4yNl0iw1wTzjuXvLyYtpJFyxOOLm2+Sup2loY+l
UCqOWPeqbAFDw0lWqZ4UZH/nT7/A9aORxcyUlAWchNecxdVIbVg=
=Vvpw
-----END PGP SIGNATURE-----

--M99FZaYYGJU8BNewfv04iLvxa4mqMb1GY--

