Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACF52345DA
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 14:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733256AbgGaMbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 08:31:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733237AbgGaMbb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 08:31:31 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VC3MxT044631;
        Fri, 31 Jul 2020 08:31:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32md5bjba5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 08:31:29 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06VCVTDj182796;
        Fri, 31 Jul 2020 08:31:29 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32md5bjb9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 08:31:29 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06VCFJnw028026;
        Fri, 31 Jul 2020 12:31:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 32gcy4q873-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 12:31:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06VCVOh924379810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 12:31:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CBAAA4054;
        Fri, 31 Jul 2020 12:31:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93A30A405F;
        Fri, 31 Jul 2020 12:31:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.62.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 12:31:23 +0000 (GMT)
Subject: Re: [kvm-unit-tests GIT PULL 00/11] s390x patches
To:     Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20200731094607.15204-1-frankja@linux.ibm.com>
 <dfce14f4-5e7b-9060-6520-06e7dd69cfa4@redhat.com>
 <524d5b00-94ec-da47-601a-a5909e3ed63e@linux.ibm.com>
 <00cc99d2-6020-3111-38a4-232991ffcf0d@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <31ec90d3-1544-eb38-536e-33f39e060a41@linux.ibm.com>
Date:   Fri, 31 Jul 2020 14:31:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <00cc99d2-6020-3111-38a4-232991ffcf0d@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fhN9CTEG2DAnrIodH8gVbQnWBBpXCm6pL"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_04:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fhN9CTEG2DAnrIodH8gVbQnWBBpXCm6pL
Content-Type: multipart/mixed; boundary="sA81tUxVgk4uonqrQ41gPFOXfXtOpD0pT"

--sA81tUxVgk4uonqrQ41gPFOXfXtOpD0pT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/31/20 2:09 PM, Thomas Huth wrote:
> On 31/07/2020 13.31, Janosch Frank wrote:
>> On 7/31/20 12:31 PM, Paolo Bonzini wrote:
>>> On 31/07/20 11:45, Janosch Frank wrote:
>>>>   https://github.com/frankjaa/kvm-unit-tests.git tags/s390x-2020-31-=
07
>>>
>>> Pulled, thanks.  FWIW you may want to gitlab in order to get the CI.
>>>
>>> Paolo
>>>
>>
>> Hey Paolo, that repository is hooked up to travis already:
>> https://travis-ci.com/github/frankjaa/kvm-unit-tests/builds/177931162
>>
>> I'll consider it if it has any benefit.
>> @Thomas: Are there differences in the CI?
>=20
> Not that much, you get a good build test coverage with both. Travis use=
s
> real (nested) KVM tests, but the compiler and QEMU versions are a littl=
e
> bit backlevel (still using Ubuntu bionic). Gitlab-CI uses newer version=
s
> (thanks to Fedora 32), but there is no KVM support here, so the tests
> run with TCG only (I'm thinking of adding the cirrus-run script to the
> Gitlab-CI, maybe we could get some KVM-coverage that way there, too, bu=
t
> that will certainly take some time to figure it out).
>=20
>  Thomas
>=20

Thanks for the answer!

For now I'll stay with github/travis until I have a real reason to move
over. Maybe if the qemu CI run doesn't take ~2h on gitlab I'll start
considering moving.


--sA81tUxVgk4uonqrQ41gPFOXfXtOpD0pT--

--fhN9CTEG2DAnrIodH8gVbQnWBBpXCm6pL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8kDxoACgkQ41TmuOI4
ufiXGQ/+KvPwwK+au4V2vlSexDOAnkm8wU/NiV8K/icGkl4ZPWmD+DcWVn0JU9v8
jMuJs9OLGpqQ1KlZCwVi2mYiiUm0G5RCPHQfabfWUhItIIzAq2ht3qmd1KLrSSvt
Onp+XHBrhXw0NSEZmEGyebQjCDnQ5Zkj3oiR8xvPhVUZ2tyjHoy0gh34csIfkW5j
khBZl0ANNlPDnSC0lURK+oKXXR6jAmlTFbnK9+qQr7/U3g7YLfVzNV5InNLgx6zz
0Y+kdmi9EgABcIAsqBecR+w+jfWOqRTIH+5r1hy/74oPm+GRdeOBKDzprJp1qOgw
EbFE8rk74+Ji4RXgmfTz0gT7D9E294DRG+qzO3Ha7r5x6jYsyel4Ivz26oC+KUMe
sjvr3swe8HzGKiS1W1+bpRZetKa8ulfJRxnDGb1RvqUZdKjAEFcqn/m7uA7C79+5
GQcNP8UG3OKXRzUo6fafaZIgsoJxvm15adctqj3yheycYAw+4F2DrZ+rURlxvSCI
b8vcTY54O06IZig/9APFHYJP/XGW/ubkesHIWpzDdaGxqFYmXHtO07u0tl5M9ESg
IRUoz2+ev42lIljNg56DM2rPzlLc5MyZFJ8ShuvqWNwWa1TkDh1UVA5mcvwirmRR
WfibpvrDzA2Y/UZu5ABpokHPvB9EXuoGHgOP4mNWAyxCOC0qcT0=
=oVbK
-----END PGP SIGNATURE-----

--fhN9CTEG2DAnrIodH8gVbQnWBBpXCm6pL--

