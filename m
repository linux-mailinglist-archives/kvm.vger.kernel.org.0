Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD68A197C7C
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 15:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgC3NKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 09:10:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59853 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730084AbgC3NKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 09:10:01 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UD3poJ126446
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 09:10:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022f2ah73-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 09:09:59 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 30 Mar 2020 14:09:49 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 14:09:47 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UD9t6I55443648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 13:09:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B8D9A4054;
        Mon, 30 Mar 2020 13:09:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F312FA4060;
        Mon, 30 Mar 2020 13:09:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.43.209])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 13:09:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add stsi 3.2.2 tests
From:   Janosch Frank <frankja@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        borntraeger@de.ibm.com
References: <20200330122035.19607-1-frankja@linux.ibm.com>
 <df745d0c-5d24-ee03-8600-ec495f1a5af6@redhat.com>
 <d42ac187-9f8f-81eb-c9b4-4d585fdef236@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 30 Mar 2020 15:09:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d42ac187-9f8f-81eb-c9b4-4d585fdef236@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yjt8yAzxRyEZUygNtV7i8jz9mz0BMlDpw"
X-TM-AS-GCONF: 00
x-cbid: 20033013-0008-0000-0000-000003672240
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033013-0009-0000-0000-00004A88A2AA
Message-Id: <727e1ed5-99ea-e559-ca9c-0f067cbcc153@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yjt8yAzxRyEZUygNtV7i8jz9mz0BMlDpw
Content-Type: multipart/mixed; boundary="EcJ0nNRUwSBidzZBJo5uQKry2GiKqCxui"

--EcJ0nNRUwSBidzZBJo5uQKry2GiKqCxui
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/30/20 3:03 PM, Janosch Frank wrote:
> On 3/30/20 2:50 PM, David Hildenbrand wrote:
>> On 30.03.20 14:20, Janosch Frank wrote:
>>> +	report(data->vm[0].total_cpus =3D=3D smp_query_num_cpus(), "cpu # t=
otal");
>>> +	report(data->vm[0].conf_cpus =3D=3D smp_query_num_cpus(), "cpu # co=
nfigured");
>>> +	report(data->vm[0].standby_cpus =3D=3D 0, "cpu # standby");
>>> +	report(data->vm[0].reserved_cpus =3D=3D 0, "cpu # reserved");
>>
>> IIRC, using -smp 1,maxcpus=3DX, you could also test the reported reser=
ved
>> CPUs.
>=20
> Will try that

Just like I thought, QEMU does not manipulate cpu counts and KVM
pre-sets standby and reserved to 0. So we have absolutely no change when
adding the smp parameter.

>=20
>>
>>
>> Also passes under TCG, nice :)
>>
>=20
>=20



--EcJ0nNRUwSBidzZBJo5uQKry2GiKqCxui--

--yjt8yAzxRyEZUygNtV7i8jz9mz0BMlDpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6B76IACgkQ41TmuOI4
ufiSvQ/+Ld3L9iNMizy2ltaQ3knlEut9vaT+TcJp+qpgUZrr9QkCvsCtMEpDyNhh
8OZLpLTk2+nALga1jfJB8y+tTP4gT4ur1hYyxS9P5rE/j0AfnuYPvwWbWsMrDQBP
MR0E8mZ4wd8C4B3zSmXIsQCaWJwmPmLzyNByZ/4D13VDj7/Y1nW8l3pAi5VxLhIU
fzuY2PO/2w7f+YrAQFl+YUmMBp6X0dFd8Kihhp8VuAZW7NhnugaojmB9JJlCfPEZ
z0860T7XBTFCQ4b3TYIUFBE00/N34cho3v9Z0c2aFRAveE+dvLjHopz8FvYJ3fc2
6bvIRnxLoQY+UUpjZ7SErTJ7tDq1a1BGpCUAfN4yyqviETswATkEtprXgQqOuNBg
STIAEJ+boeI+W/YverYYZdiNqebMvpkWYj0w/R5CFOJFi1bGjEbZGG74QkClG4FJ
E2yndP8Q5vLp05fUYO27BAOyQ6yvIFFsSHzNsH1ivdWa4RPCDjoWUrCx/OYKLgu+
BeMinxU1i1GTnC7iPvOaR5UOh449K+gF5q+Tyc2YUMtLRxRJRZ6u5IattCz6qHjG
+wdXoJYulG/psBb2bhi5DSfQrxyDjxAF8tkq994ekn0hcwgo8W3hsuAxoppQCeMV
JQ4RqsPn3f+6JqqHNrqeRdODBEHdhFqK0yjtFUnBlEYBLVIQs+0=
=EzCZ
-----END PGP SIGNATURE-----

--yjt8yAzxRyEZUygNtV7i8jz9mz0BMlDpw--

