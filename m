Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C527C001
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgI2ItW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:49:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7210 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2ItV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 04:49:21 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T8VTXR004512
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=SYc5DGcSlWLMzLOEnsdk/fRMtp6hFOEeZkDIVAPDc9A=;
 b=oGGltBTrlJ4uHFw0XvRZNNHh54iwt7KQWju+3EVyawvl2Txtm6KUZ/34zi26NheecByN
 Z55Gx5Z4oua1M+HnFhzpHx6RqnkXtkiCtE61pRatS9ABI+x0ucTPjg8zPMiF4ypH2x6R
 gBH/ONeX5Woww51oiWj1h9vR0LFtgdb0VrrRGIhzuuQp09IGyB85GDmlhhQ3zp5pxorm
 99ACBZ7UwXiM9xFcKem7XILj11peRo0398Gef5mm+v7obrTps2vC1QIiiYYeVCnvay33
 sy08kdHLZgSUkIf1C6gEMf0CGB/liIxQZQNFuxtOZMLxUnwgKJGZwG/3AFAJtvgvqnUm LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v19d0vv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:49:20 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08T8gj3J040184
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:49:19 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v19d0vuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 04:49:19 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08T8hnX5003107;
        Tue, 29 Sep 2020 08:49:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw9831n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 08:49:17 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08T8nFRs29425956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 08:49:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8553EA405C;
        Tue, 29 Sep 2020 08:49:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4796FA4054;
        Tue, 29 Sep 2020 08:49:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 08:49:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200928174958.26690-1-thuth@redhat.com>
 <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b143b9d8-6c5f-b850-ba96-34b9bb337d22@linux.ibm.com>
Date:   Tue, 29 Sep 2020 10:49:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QEwQKDHX7O9xzNeMjlCxLNy8YiZnpSw75"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QEwQKDHX7O9xzNeMjlCxLNy8YiZnpSw75
Content-Type: multipart/mixed; boundary="DavEAR6NLRNjdyBasKtfLEfxvJYehOQft"

--DavEAR6NLRNjdyBasKtfLEfxvJYehOQft
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/29/20 10:38 AM, Paolo Bonzini wrote:
> On 28/09/20 19:49, Thomas Huth wrote:
>>  Hi Paolo,
>>
>> the following changes since commit 58c94d57a51a6927a68e3f09627b2d85e34=
04c0f:
>>
>>   travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory (2020=
-09-25 10:00:36 +0200)
>>
>> are available in the Git repository at:
>>
>>   https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-09=
-28
>>
>> for you to fetch changes up to b508e1147055255ecce93a95916363bda8c8f29=
9:
>>
>>   scripts/arch-run: use ncat rather than nc. (2020-09-28 15:03:50 +020=
0)
>>
>> ----------------------------------------------------------------
>> - s390x protected VM support
>> - Some other small s390x improvements
>> - Generic improvements in the scripts (better TAP13 names, nc -> ncat,=
 ...)
>> ----------------------------------------------------------------
>>
>> Jamie Iles (1):
>>       scripts/arch-run: use ncat rather than nc.
>>
>> Marc Hartmayer (6):
>>       runtime.bash: remove outdated comment
>>       Use same test names in the default and the TAP13 output format
>>       common.bash: run `cmd` only if a test case was found
>>       scripts: add support for architecture dependent functions
>>       run_tests/mkstandalone: add arch_cmd hook
>>       s390x: add Protected VM support
>>
>> Thomas Huth (4):
>>       configure: Add a check for the bash version
>>       travis.yml: Update from Bionic to Focal
>>       travis.yml: Update the list of s390x tests
>>       s390x/selftest: Fix constraint of inline assembly
>>
>>  .travis.yml             |  7 ++++---
>>  README.md               |  3 ++-
>>  configure               | 14 ++++++++++++++
>>  run_tests.sh            | 18 +++++++++---------
>>  s390x/Makefile          | 15 ++++++++++++++-
>>  s390x/selftest.c        |  2 +-
>>  s390x/selftest.parmfile |  1 +
>>  s390x/unittests.cfg     |  1 +
>>  scripts/arch-run.bash   |  6 +++---
>>  scripts/common.bash     | 21 +++++++++++++++++++--
>>  scripts/mkstandalone.sh |  4 ----
>>  scripts/runtime.bash    |  9 +++------
>>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>>  13 files changed, 106 insertions(+), 30 deletions(-)
>>  create mode 100644 s390x/selftest.parmfile
>>  create mode 100644 scripts/s390x/func.bash
>>
>=20
> Pulled, thanks (for now to my clone; waiting for CI to complete).
> Should we switch to Gitlab merge requests for pull requests only (i.e.
> patches still go on the mailing list)?
>=20
> Paolo
>=20

Hrm, that would force everyone to use Gitlab and I see some value in
having pull request mails on the lists. You just opened the Pandora's
box of discussions :-)

If it's easier for you I'd be open to open a marge request and send out
pull mails at the same time so people can comment without login to Gitlab=
=2E


--DavEAR6NLRNjdyBasKtfLEfxvJYehOQft--

--QEwQKDHX7O9xzNeMjlCxLNy8YiZnpSw75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9y9QoACgkQ41TmuOI4
ufiDPxAAkOLftf48kL8FDnE9oOPMP15AfVJxzu6O8jxmsYoH3UUImpea6zOlv1nz
5tNdfCLLY3TJsGXM+EcE7DNoM4u2ZJqFy8W3v/Y6VHI3QAcQcm3BWlBIaidOLwi1
5/ax9Sz50DgpCX3ytfqRjQWizxAlTPNMX2yX0+J8ZT0+HTVG/W4gUXzZW8rbMvKq
lfWQqF+o5IBn+kIo81vIJh+pTFBU5ocxIayCjvIxmRm+65/9pvevS86GzzRBDhO+
s3NGCW8al8fI+aBy2bgo2aX84gzvjG2iOzuhTPKkh88Gu/7ygIwzvktIIluXvIkC
9VBlyQC0f+ZQ7OJW3xbCmoJW/POg9lEwxEAWAw0UHd/oyrSZHCw5k76vIw7f4OGj
dMgM11RlXO9BUU6cH5nU1JDtULGu7iowvj0pDaq9H9WeChb11QTKW8yNS3mPae+K
oDnC4K09VmT9DRfg9GTAzoIsDgLUdqMCjYbNi2T//JE1TF/f4yETL5mDZ7jQXIyf
rzDYSJIqe+MLGmpfj6XWsvaEBk8tQZYisLcBqxFSrncGEYf/S06/l1/GF4ITK8KZ
fFCBZbivu4Py135F8BdivPjpGDYg1XzUVqE5n6O0IMIhjZRN+e4FoOUrpVDzWMJq
FfMzBf/8Fwri1F9fb0Bw35sEQduIECwsI0em+c0SQBG0Wco8SX8=
=cjcq
-----END PGP SIGNATURE-----

--QEwQKDHX7O9xzNeMjlCxLNy8YiZnpSw75--

