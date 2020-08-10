Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7692409CE
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgHJPgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 11:36:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728774AbgHJP1p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 11:27:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07AFG0Mu060969;
        Mon, 10 Aug 2020 11:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=N0TqtTPh94rRUKUQZFqrIq+9xR7bUuNq+1cSC5EBaNE=;
 b=XZHFnON5Tr6Nbqv25WvshTFNLoUhxxmzKWJ3l+78aVZwd+cWuMy+kpT6dVVFwm9EBjCv
 zwlSt+pSrHek7pvWL5/nz4ZjCqlzzG8SqhXLkOfeX2v+3ZFWt982r7l1PVvrMKmFnc2T
 q/6gV/Kg6Ahb0BxWwWTcaN21U9sheltQG3Fm8dYUFrvhWkas4Ivf5SfTNLxQr7hfPKXc
 /jhDDKCWgB0ZlSj0/8rYHEVcPftw+MGXK5lskLg+MkshUVGxhCw6Gie4mxhhgVGfj1k1
 pYj1t2WeOf9aLrXD2dQBk88YI09sO6Y4goC71LHA5TjzFErWz6mAj/hAxdxzbLW+h4Af vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32u4g1rdd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Aug 2020 11:27:43 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07AFG3qj061187;
        Mon, 10 Aug 2020 11:27:43 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32u4g1rdc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Aug 2020 11:27:43 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07AFQaGF031660;
        Mon, 10 Aug 2020 15:27:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 32skp81fhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Aug 2020 15:27:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07AFQAED48955868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Aug 2020 15:26:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0371A4055;
        Mon, 10 Aug 2020 15:27:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40437A404D;
        Mon, 10 Aug 2020 15:27:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.27.22])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Aug 2020 15:27:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200807111555.11169-1-frankja@linux.ibm.com>
 <20200807111555.11169-4-frankja@linux.ibm.com>
 <20200810165004.02c4b5bf.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2b5634bf-c39b-13db-924a-5efcbaddb238@linux.ibm.com>
Date:   Mon, 10 Aug 2020 17:27:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200810165004.02c4b5bf.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XR1DH96nZb7EDCNVcSd8ZdymTl13ebfqI"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_11:2020-08-06,2020-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XR1DH96nZb7EDCNVcSd8ZdymTl13ebfqI
Content-Type: multipart/mixed; boundary="2Fh9l8zg6hqA8XpM0Gcac9IqiXAdmBFrF"

--2Fh9l8zg6hqA8XpM0Gcac9IqiXAdmBFrF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/10/20 4:50 PM, Cornelia Huck wrote:
> On Fri,  7 Aug 2020 07:15:55 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>      * Query Ultravisor information
>>      * Set shared access
>>      * Remove shared access
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++
>>  s390x/Makefile      |   1 +
>>  s390x/unittests.cfg |   3 +
>>  s390x/uv-guest.c    | 162 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  4 files changed, 240 insertions(+)
>>  create mode 100644 lib/s390x/asm/uv.h
>>  create mode 100644 s390x/uv-guest.c
>=20
> (...)
>=20
>> +static inline int uv_call(unsigned long r1, unsigned long r2)
>> +{
>> +	int cc;
>> +
>> +	/*
>> +	 * The brc instruction will take care of the cc 2/3 case where
>> +	 * we need to continue the execution because we were
>> +	 * interrupted. The inline assembly will only return on
>> +	 * success/error i.e. cc 0/1.
>> +	*/
>=20
> Thanks, that is helpful.
>=20
>> +	asm volatile(
>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>> +		"		brc	3,0b\n"
>> +		"		ipm	%[cc]\n"
>> +		"		srl	%[cc],28\n"
>> +		: [cc] "=3Dd" (cc)
>> +		: [r1] "a" (r1), [r2] "a" (r2)
>> +		: "memory", "cc");
>> +	return cc;
>> +}
>> +
>> +#endif
>=20
> (...)
>=20
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> new file mode 100644
>> index 0000000..1aaf7ca
>> --- /dev/null
>> +++ b/s390x/uv-guest.c
>> @@ -0,0 +1,162 @@
>> +/*
>> + * Guest Ultravisor Call tests
>> + *
>> + * Copyright (c) 2020 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify =
it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <asm/uv.h>
>> +
>> +static unsigned long page;
>> +
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +	struct uv_cb_share uvcb =3D {
>> +		.header.cmd =3D cmd,
>> +		.header.len =3D sizeof(uvcb),
>> +		.paddr =3D addr
>> +	};
>> +
>> +	uv_call(0, (u64)&uvcb);
>> +	return uvcb.header.rc;
>=20
> Any reason why you're not checking rc and cc here...

Well, this is a helper function not a test function.
Since I can only return one value and since I'm lazy, I chose to ignore
the CC and went for the uvcb rc. That's basically also the answer for
your following questions.


Alright, I'll remove the helpers and execute those tests the hard way.

>=20
>> +}
>> +
>> +static inline int uv_set_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
>> +}
>> +
>> +static inline int uv_remove_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>> +}
>=20
> (...)
>=20
>> +static void test_sharing(void)
>> +{
>> +	struct uv_cb_share uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_SET_SHARED_ACCESS,
>> +		.header.len =3D sizeof(uvcb) - 8,
>> +	};
>> +	int cc;
>> +
>> +	report_prefix_push("share");
>> +	cc =3D uv_call(0, (u64)&uvcb);
>> +	report(cc =3D=3D 1 && uvcb.header.rc =3D=3D UVC_RC_INV_LEN, "length"=
);
>=20
> ...while you do it for this command (as for all the others)?
>=20
>> +	report(uv_set_shared(page) =3D=3D UVC_RC_EXECUTED, "share");
>=20
> So, is that one of the cases where something is actually indicated in
> rc on success? Or does cc=3D0/1 have a different meaning for these call=
s?
>=20
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("unshare");
>> +	uvcb.header.cmd =3D UVC_CMD_REMOVE_SHARED_ACCESS;
>> +	cc =3D uv_call(0, (u64)&uvcb);
>> +	report(cc =3D=3D 1 && uvcb.header.rc =3D=3D UVC_RC_INV_LEN, "length"=
);
>> +	report(uv_remove_shared(page) =3D=3D UVC_RC_EXECUTED, "unshare");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>=20
> (...)
>=20



--2Fh9l8zg6hqA8XpM0Gcac9IqiXAdmBFrF--

--XR1DH96nZb7EDCNVcSd8ZdymTl13ebfqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8xZ2gACgkQ41TmuOI4
ufgqXRAAhgnFVP+qfwdn134ONC6Oxhq4xHN6tooSsGKZ3E+XBaAS7R8nH9xVYk/1
5XEoV590p8U85JIjjWmntWwBQkhhgoSO+1ngr0TvcMfECnA2+9401JNsRWintvRM
YpVHP+RiJsCBMuIBM5keq/dG8A4od4XUbYbAsFaweR03TghleILQ6YnDRiT6PV5f
XMNgVZNzpe2ZMjnM12rE6H08n2MKQLME1Md7gO48xyk7MDDpH1WEHuuQO9HxrDQS
JFBvfLQKRO8QY50FS0E89oHrSBPiPw3Jt7T0FQ6CkelZPlS0I66gmRgEAIHO55xl
bbuR4pWGQVp21YATHEWn50U+Vlxt48r3esIfVpoM5ytVF587S7tEK+DbpFjcGByL
bZqRjXR1EkPyVyk15ar7m+FKNojc6J/FfBvmq5zlyX01/QlvNr0aEfRyX/DGAbHW
cqndC4B4uKmkUXcV3mZ7J6kQFFRYkyVcPmEtDQbOgb50P9F4tNiwUjoAwRl2CClW
RSBVZWG7q+zL4UsYVYxnLX0gpZVFuLQYdDI73FmSE75eM64O4+VAE5oBc+bqDAyC
cyVfwCJ40d5e7G/kSXIMJeL+mVKCD443C7Ck1WkuKqefA36aYaoqX2K6xjsDyvZS
jANbYANomFWAfkoGcF5al2AffBM4Gke1aT9oLTkQvWQZLoQWdzc=
=HxVR
-----END PGP SIGNATURE-----

--XR1DH96nZb7EDCNVcSd8ZdymTl13ebfqI--

