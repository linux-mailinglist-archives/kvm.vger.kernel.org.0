Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817A8BDC28
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfIYK0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 06:26:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729779AbfIYK0U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Sep 2019 06:26:20 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8PAO2Tx063924
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:26:19 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v85j22bx6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:26:18 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 25 Sep 2019 11:26:16 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Sep 2019 11:26:15 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8PAQEBd50593822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:26:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1E304204C;
        Wed, 25 Sep 2019 10:26:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9FC142045;
        Wed, 25 Sep 2019 10:26:13 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Sep 2019 10:26:13 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: SMP test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-7-frankja@linux.ibm.com>
 <ddb43c9c-e6d9-fbc0-b7a5-ec440756b0ec@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 25 Sep 2019 12:26:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ddb43c9c-e6d9-fbc0-b7a5-ec440756b0ec@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pj9nTxLZm4mFPpyjpdWzQ3JzvSAH1wHk4"
X-TM-AS-GCONF: 00
x-cbid: 19092510-0008-0000-0000-0000031ABF0E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092510-0009-0000-0000-00004A395649
Message-Id: <ea43c712-ca82-f7c6-08da-576fcb5857b7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909250106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pj9nTxLZm4mFPpyjpdWzQ3JzvSAH1wHk4
Content-Type: multipart/mixed; boundary="H2XvNqqhTF6cv6d8M0E2B7oYxIZWM236W";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <ea43c712-ca82-f7c6-08da-576fcb5857b7@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: SMP test
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-7-frankja@linux.ibm.com>
 <ddb43c9c-e6d9-fbc0-b7a5-ec440756b0ec@redhat.com>
In-Reply-To: <ddb43c9c-e6d9-fbc0-b7a5-ec440756b0ec@redhat.com>

--H2XvNqqhTF6cv6d8M0E2B7oYxIZWM236W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/25/19 10:49 AM, Thomas Huth wrote:
> On 20/09/2019 10.03, Janosch Frank wrote:
>> Testing SIGP emulation for the following order codes:
>> * start
>> * stop
>> * restart
>> * set prefix
>> * store status
>> * stop and store status
>> * reset
>> * initial reset
>> * external call
>> * emegergency call
>>
>> restart and set prefix are part of the library and needed to start
>> other cpus.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/smp.c         | 242 +++++++++++++++++++++++++++++++++++++++++++=
+
> [...]
>> +int main(void)
>> +{
>> +	report_prefix_push("smp");
>> +
>> +	if (smp_query_num_cpus() =3D=3D 1) {
>> +		report_abort("need at least 2 cpus for this test");
>=20
> nit: report_abort() aborts immediately, so the "goto done" below is dea=
d
> code. Did you mean report_skip() instead?

That would make more sense, yes

>=20
>> +		goto done;
>> +	}
>> +
>> +	test_start();
>> +	test_stop();
>> +	test_stop_store_status();
>> +	test_store_status();
>> +	test_ecall();
>> +	test_emcall();
>> +	test_reset();
>> +	test_reset_initial();
>> +
>> +done:
>> +	report_prefix_pop();
>> +	return report_summary();
>> +}
>=20
> Apart from the nit, the patch looks fine to me. Since this is IIRC the
> only nit that is left in this series, I can also fix it up when picking=

> up the patch, if you like - just tell me whether you prefer report_skip=

> or deletion of the goto.

Well, that might depend on how much weight David's latest comment has.
:-) If you want to, you can pick and fix.

>=20
>  Thomas
>=20



--H2XvNqqhTF6cv6d8M0E2B7oYxIZWM236W--

--Pj9nTxLZm4mFPpyjpdWzQ3JzvSAH1wHk4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2LQMUACgkQ41TmuOI4
ufjPWQ/+NieuZNgiK72dfPZdM69ZAK2RBISdcfh0Wh6hchlYvNUA1VusNdHq4EvC
88JcuqDuUwczU/Yk3ZxBi7obyxGCgWWRlhebYr0U4xWo8HtC2HfLd4p7QR2iwjHu
TgnKOOC8w47gSyvX+Yec6HnM0AMAub+cuS6Kq7fDSYPHq+G/xoOMrocS1UMELh/x
EJuibLUdsOrGMpGTQw7Txvwan7MiKzimKXH9dLouoG05pSLtnZxxZw9y5S86bsf2
HlCaIwBkkGb/JVMlEaomHbHUfv15vZfT9WyAhqBXtYUu3oR41FWdTkhfFDk/db4T
b6dmkNKsNj41/FXdm3SP+PqV5Kbgy4MqShgpqnzZDASKmCz8uo4b/7M22eduurxA
Qet8nUxVuC6eLFrWaE3YN0XEGqt+i2VsNV8TARZ/5UxXT9ZbMppVk42cq1Zwfp8H
d/V46fW37pugR9gMVuAnF+x5Ls7+eGGTpjlXxFU41dGb0D4E6Sz8lC5TI8Ano/Tj
J/ycmdGuhIinfsHIFgH2DmGx+wfexDMElGjFa/GbRx5Ric9pl66sATTfIwJ+qeQB
jKpL4uMsGb9xkkSNZwEAj6Y8sn4CTcZuJBtF0knh3SjA9IIZ5vLWXa89ekf8IEuv
gq0sbZGnS9WVj38njeItP/31O9aj3s0q6eEY0bUYVFi30ihnlNc=
=e4TN
-----END PGP SIGNATURE-----

--Pj9nTxLZm4mFPpyjpdWzQ3JzvSAH1wHk4--

