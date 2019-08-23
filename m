Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2035B9B24E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 16:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390739AbfHWOlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 10:41:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389691AbfHWOlh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Aug 2019 10:41:37 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7NEf5Cj097939
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 10:41:36 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ujgnkc4vc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 10:41:36 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 23 Aug 2019 15:41:34 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 15:41:31 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7NEfUnK37224574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 14:41:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25CD6A4060;
        Fri, 23 Aug 2019 14:41:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8DC4A405B;
        Fri, 23 Aug 2019 14:41:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.28.218])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 14:41:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190822111100.4444-1-frankja@linux.ibm.com>
 <ffc7de14-7960-5423-d984-c18ab1dfa4b2@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 23 Aug 2019 16:41:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ffc7de14-7960-5423-d984-c18ab1dfa4b2@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hd4Z68GNr1YqiR6yL7gsHmq3N1XT8ukbZ"
X-TM-AS-GCONF: 00
x-cbid: 19082314-4275-0000-0000-0000035CA08D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082314-4276-0000-0000-0000386ECA74
Message-Id: <137ffa8a-2a93-b31b-df47-6b27d566deef@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hd4Z68GNr1YqiR6yL7gsHmq3N1XT8ukbZ
Content-Type: multipart/mixed; boundary="WVpFpftxZvkmQYA0KfAMT0kCBRpV7oGWq";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <137ffa8a-2a93-b31b-df47-6b27d566deef@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
References: <20190821104736.1470-1-frankja@linux.ibm.com>
 <20190822111100.4444-1-frankja@linux.ibm.com>
 <ffc7de14-7960-5423-d984-c18ab1dfa4b2@redhat.com>
In-Reply-To: <ffc7de14-7960-5423-d984-c18ab1dfa4b2@redhat.com>

--WVpFpftxZvkmQYA0KfAMT0kCBRpV7oGWq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/23/19 4:12 PM, Thomas Huth wrote:
> On 8/22/19 1:11 PM, Janosch Frank wrote:
>> By adding a load reset routine to cstart.S we can also test the clear
>> reset done by subcode 0, as we now can restore our registers again.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>> I managed to extract this from another bigger test, so let's add it to=
 the bunch.
>> I'd be very happy about assembly review :-)
>=20
> FWIW, the assembly code looks fine to me.
>=20
>> ---
>>  s390x/cstart64.S | 27 +++++++++++++++++++++++++++
>>  s390x/diag308.c  | 31 ++++++++++---------------------
>>  2 files changed, 37 insertions(+), 21 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index dedfe80..47045e1 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -145,6 +145,33 @@ memsetxc:
>>  	.endm
>> =20
>>  .section .text
>> +/*
>> + * load_reset calling convention:
>> + * %r2 subcode (0 or 1)
>> + */
>> +.globl load_reset
>> +load_reset:
>=20
> Maybe rather name the function diag308_load_reset so that it is clear
> that it belongs to the diag308 test?

Sure

> Or are you going to re-use this function in other tests later?

I currently have no such plans
But I'm thinking about a way to check the CPU registers in combination
with smp. So it might be extended.

>=20
> Anyway,
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20

Thanks!



--WVpFpftxZvkmQYA0KfAMT0kCBRpV7oGWq--

--hd4Z68GNr1YqiR6yL7gsHmq3N1XT8ukbZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1f+xkACgkQ41TmuOI4
ufjwhg/9FHIFBTQAtWsg0n0Q0t9Mk9JSDpOX5N7qbD0FeW5z2MAX/cijuRCWoPVn
ZHWyXKHxzrP4orIF/j6u2y7STyCV4o5CA03yMBU4G4GjbEyHgy6inBoM0WCjSvBO
w20aZLv4UHMecdFCmIDkrLcAqENxnHz1GVgDVBdWJBCTcaE7D09/BPfiJ7Dj79/I
s210XhX94MpCyUeTs9mGfirAxuRlNicA0rpvYcSulH15x2lEss5N3Os3nlYkxDhP
0ffmm4glCmT27R4tJWYV3Bql5Yf69WjwpfBx/GptMwMrBVfIR4oIfz/jFyE5pTvw
gL7oOSxfPLUNgVtfP+sIGZaJu4xbZHxvHsmfk1ymTMAKvMOPhmb+HLuVmGwhd5/y
polclTNK6qgxRhwieRxwR98vwcPVe4aEy6Jr59shPv+1NxhZjwZs+xDtdm4awgO4
pG126EPOhU5XGxom7zVfxU1r8Xv6ARp3MrCZgcIZmfjyiVkjGntmkc7B9LadXGjS
8RQNbcfvnxsdHKSkf3wFRWjEdHvb+WN4dtV5c+ZrvCZ1EGK9uRvKVlpCkCmSrw3R
+SF4whihsseBU1i8yYkElznTBFQbXvCckHP63JX74zG4T2hevkBVB1pKfQjh/Eu9
yCoM+rfG8BM05y+ZgSCw0LkESE8ifUTahTQq1MqpsXhBrEi+occ=
=9LVC
-----END PGP SIGNATURE-----

--hd4Z68GNr1YqiR6yL7gsHmq3N1XT8ukbZ--

