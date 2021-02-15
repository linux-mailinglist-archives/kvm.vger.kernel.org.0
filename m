Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2B731B633
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 10:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBOJJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 04:09:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64846 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhBOJJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 04:09:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11F8pYXM182157;
        Mon, 15 Feb 2021 04:08:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=zhzD6lzfk/9hR7ZxhwdE3wefpwG7G2ibfeJIZDszfjw=;
 b=VjVOuuynu40rgYoIAlF3J2Btvi+xJNbBwtlq3W0kFMAnRMt/wTj2geElUHEpW8dE38TC
 uYCZMdEU53sYwwMQuOGgOHLJd2kKz/b+NDIP6iUP/I7nvGzsTMl4fJTdsQQtHAix2Flq
 GdtzdQkW2wch9T61TDWQIWAlmEkEKviEM1IeJR6OGgA3vKr/YvM2F507XIAd+TXiMBgA
 gIuYCV7u05GK6QNKHPU9zIiTRsd6dg8vRwI2WlahZKEV7jbn5FsK+4ap2IvfDcosp1cs
 nvGdlzLXXo6tRb6FepZbAOxpKMXnir6WNbmeiiuLL8uw8tG1rXmtpgBvdg3mJhMh9UcH ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36qntn8dta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 04:08:26 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11F8qTwY183967;
        Mon, 15 Feb 2021 04:08:25 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36qntn8dss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 04:08:25 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11F97N4T017948;
        Mon, 15 Feb 2021 09:08:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d89nvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 09:08:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11F98KGs39387582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 09:08:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACD3DA4060;
        Mon, 15 Feb 2021 09:08:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C7F4A405B;
        Mon, 15 Feb 2021 09:08:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.82.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 09:08:19 +0000 (GMT)
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, borntraeger@de.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
References: <20210213153227.1640682-1-unixbhaskar@gmail.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] arch: s390: kvm: Fix oustanding to outstanding in the
 file kvm-s390.c
Message-ID: <f90e91a5-7bc0-2489-51d4-6004eef9db7a@linux.ibm.com>
Date:   Mon, 15 Feb 2021 10:08:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210213153227.1640682-1-unixbhaskar@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zYdbmPEWRcp4fnBKDtNJQJxFmauwtBTRZ"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-15_02:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxscore=0 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102150072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zYdbmPEWRcp4fnBKDtNJQJxFmauwtBTRZ
Content-Type: multipart/mixed; boundary="cMR6E0UzQFHfdCrb6Mp7D2cFWBX3LPQo3";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Bhaskar Chowdhury <unixbhaskar@gmail.com>, borntraeger@de.ibm.com,
 david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org
Message-ID: <f90e91a5-7bc0-2489-51d4-6004eef9db7a@linux.ibm.com>
Subject: Re: [PATCH] arch: s390: kvm: Fix oustanding to outstanding in the
 file kvm-s390.c
References: <20210213153227.1640682-1-unixbhaskar@gmail.com>
In-Reply-To: <20210213153227.1640682-1-unixbhaskar@gmail.com>

--cMR6E0UzQFHfdCrb6Mp7D2cFWBX3LPQo3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/13/21 4:32 PM, Bhaskar Chowdhury wrote:
>=20
> s/oustanding/outstanding/

Hey Bhaskar,

while I do encourage anyone to send in changes I'm not a big fan of
comment fixes if they are only a couple of characters and when the
meaning is still intact despite the spelling mistake.

You're creating more work for me than you had writing this patch and the
improvement is close to zero.

Be warned that I might not pick up such patches in the future.


If you're ok with it I'll fix up the subject to this and pick up the patc=
h:
"kvm: s390: Fix comment spelling in kvm_s390_vcpu_start()"

Cheers,
Janosch

>=20
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index dbafd057ca6a..1d01afaca9fe 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4545,7 +4545,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>  		/*
>  		 * As we are starting a second VCPU, we have to disable
>  		 * the IBS facility on all VCPUs to remove potentially
> -		 * oustanding ENABLE requests.
> +		 * outstanding ENABLE requests.
>  		 */
>  		__disable_ibs_on_all_vcpus(vcpu->kvm);
>  	}
> --
> 2.30.1
>=20



--cMR6E0UzQFHfdCrb6Mp7D2cFWBX3LPQo3--

--zYdbmPEWRcp4fnBKDtNJQJxFmauwtBTRZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAmAqOgMFAwAAAAAACgkQ41TmuOI4ufiN
JBAAyRHM+AND+KcsBaVD4lhw/E3DfIHRYfDsRubZlqe+wqdw7u5umTX9IY0j9tMnOy4oM7Q4UuX1
nwHMjCNtAGqm68FkfpfxqfZfIH9fTeYpDP/iPmQqgAPuoNJoCc8vwjJm75YylQL6bfh7Q+/+tAAi
p7fvsb7/sXVJKTl4DxAeftlbi5ObK2Y/7zDIJ1Rj9RmiUAu46kPsYHo3Lw/A7VaE/QFcfneRJGdt
sm3Jvlc4elPO1QMU4ZE2ezekAqQSBdxNkhEDyEC92mNmujNF39/ARNYQjfS0asTjrnAaoNPAbyq0
TnO5peeO7YBMtbRwCvVyaXVDjgirZX68Yi70ONOshAu8ckS6kJC6RmURTrZPnlnMmh0+rQOxL6eP
OAtxd5J/34cAKGkPJnXes5qNbiI7GkfH+93wW2w7ifBjilnbIU6daOgk6rtQFAFuhoTaJx5YbhE0
gtzZl+wF0sZ7BBCxgIC321ffXdQXUz2kiOfX1E0oQcj5613/yO7lSmvlYpC64PKBNF6bR7hSbrt+
Y9XwUVnss9oMoqcXapLtACV/sT5oxyIohnxxpZ0N0r1VDQtLJrgW/SQlA/5GHOFsHfRhhq/cRFJW
ZGlSBemWG7HAGounlYbQ6MAN5bm49L2OI8e7GRAJj2bxEaxHimtmWG5jCj8yctjvzSX9/BK3SLhg
vLA=
=g++n
-----END PGP SIGNATURE-----

--zYdbmPEWRcp4fnBKDtNJQJxFmauwtBTRZ--

