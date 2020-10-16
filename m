Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF528FEB3
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 08:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394379AbgJPG6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 02:58:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391432AbgJPG6g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 02:58:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09G6X5bR144178
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 02:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=fAB+dBxXKCf9piY0XeftMoKfkmrEGQM8zRs2ul0oivE=;
 b=i0xTNHgbMykC6vYHsXJgQmqAAMEktrXWIg18V2z/G8LJu6tZNuiV+Iv+VEwOfkVDEEMi
 3dq1BucPWfRY1C3wimQID3vgpuRBLfXQ2Khwks4Gylt5pEvx+UbexIid/9yM6dtZt3e9
 UYwaknMr1nkjjeSAoFVQsgQzXDj6tGtjA33grb7RdEROfxIvuzleRtdgk722HL5Ee8CU
 zpKiAy4kFpivG20QHPPYNfBs7Jdza5iO3FQ4K60SUytecC+MC4ad4W67lbZH3+pHqeRY
 pFMnZXCLPuV093+U7mw1lxQGpUV1JpqkhU7ScZLjXelKP3fxhWoH18KKFdbAUz/BZNLV 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3476a0grc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 02:58:35 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09G6X9fl144586
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 02:58:35 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3476a0grbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 02:58:35 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09G6vKmv022275;
        Fri, 16 Oct 2020 06:58:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 34347gx062-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 06:58:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09G6wVnW32309634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 06:58:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11074A4040;
        Fri, 16 Oct 2020 06:58:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF879A405B;
        Fri, 16 Oct 2020 06:58:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.30.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 16 Oct 2020 06:58:30 +0000 (GMT)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Thomas Huth <thuth@redhat.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
 <d90a2c37-46b7-5fc9-efb8-c5a6bb1c6d7e@linux.ibm.com>
 <e5b92b5c-93ef-462f-e597-e5436f414f21@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <59127983-82a2-a6c7-8ad3-703577bf38b3@linux.ibm.com>
Date:   Fri, 16 Oct 2020 08:58:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e5b92b5c-93ef-462f-e597-e5436f414f21@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GaJd00UyskaZiBxM3h1vOcRdicnks61SA"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_02:2020-10-16,2020-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GaJd00UyskaZiBxM3h1vOcRdicnks61SA
Content-Type: multipart/mixed; boundary="qMoPJBRSoYcSsiQEo6TPJJo9VBaTmPyaC"

--qMoPJBRSoYcSsiQEo6TPJJo9VBaTmPyaC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/15/20 3:56 PM, Thomas Huth wrote:
> On 15/10/2020 14.40, Janosch Frank wrote:
>> On 10/14/20 9:27 PM, Collin Walling wrote:
>>> The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged cal=
l
>>> that must be intercepted via SIE, handled in userspace, and the
>>> information set by the instruction is communicated back to KVM.
>>
>> It might be nice to have a few words in here about what information ca=
n
>> be set via the diag.
>>
>>>
>>> To test the instruction interception, an ad-hoc handler is defined wh=
ich
>>> simply has a VM execute the instruction and then userspace will extra=
ct
>>> the necessary info. The handler is defined such that the instruction
>>> invocation occurs only once. It is up the the caller to determine how=
 the
>>> info returned by this handler should be used.
>>>
>>> The diag318 info is communicated from userspace to KVM via a sync_reg=
s
>>> call. This is tested during a sync_regs test, where the diag318 info =
is
>>> requested via the handler, then the info is stored in the appropriate=

>>> register in KVM via a sync registers call.
>>>
>>> The diag318 info is checked to be 0 after a normal and clear reset.
>>>
>>> If KVM does not support diag318, then the tests will print a message
>>> stating that diag318 was skipped, and the asserts will simply test
>>> against a value of 0.
>>>
>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>
>> Checkpatch throws lots of errors on this patch.
>> Could you check if my workflow misteriously introduced windows line
>> endings or if they were introduced on your side?
>=20
> How did you feed the patch into checkpatch? IIRC mails are often sent w=
ith
> CR-LF line endings by default - it's "git am" that is converting the li=
ne
> endings back to the Unix default. So for running a patch through checkp=
atch,
> you might need to do "git am" first and then export it again.

Uh right, that's why I asked in the first place
With git am checkpatch is a lot happier and it would be even happier if
I would have looked at the V1 and not at the RFC I reviewed on Monday...

>=20
>>> +uint64_t get_diag318_info(void)
>>> +{
>>> +	static uint64_t diag318_info;
>>> +	static bool printed_skip;
>>> +
>>> +	/*
>>> +	 * If KVM does not support diag318, then return 0 to
>>> +	 * ensure tests do not break.
>>> +	 */
>>> +	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
>>> +		if (!printed_skip) {
>>> +			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
>>
>> Whitespace after .
>>
>>> +				"Skipping diag318 test.\n");
>=20
> It's a multi-line text, so the whitespace is needed, isn't it?

I missed that second line as it is indented to the stdout and not to the
first string.

>=20
>>> +			printed_skip =3D true;
>>> +		}
>>> +		return 0;
>>> +	}
>=20
>  Thomas
>=20



--qMoPJBRSoYcSsiQEo6TPJJo9VBaTmPyaC--

--GaJd00UyskaZiBxM3h1vOcRdicnks61SA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl+JRJYACgkQ41TmuOI4
ufjNWw//UjBZZ+EDyHJWsRxn9riGXq2NUjRv7DUvy2L+WWW2L2DnWFLKl+Auwl8d
4ZMioozgIBthOSVt4wW8nDYaJu/bypNwTHD1exKIEJ6UWNnaaiyqVM7KGn8aFmxG
eEs1LQJMJaWeCmPJrKX2elXfWhnepqUOrU8KQ6EDlrCk5B2e1okBWJQ9PYlhVthj
kg67jXj5TtKOkcWGpFtTIdBmL2VQYh21chgiGGrQkJ9IU6Bhqye5cUd/HzfDUp2r
WOhsQOEyvKkUObQSRq1f6RHwuA/dVIe0V5xbLajU2pWpx7zyZLmDUR9iyMLc3bqU
9XMf6rzwHfT/N3S7tgsJYDZH7v80wCAnBz935g1fDoNiGOFABKVf7EFhHqhLvDNq
A4WZNvwxpOM1zrv5wavsEEjfASLPVgXlqIeMD87hpBUZGsDS3HLbXufwLK27jIx6
2aypPkAeiW8/HUbIx787Jmrn2tbhsVP2xp+B1ZoUyWegwDLU7rnmD2Nq8DbEUKR1
n5l2V/NWSjGBLduu7SoorS201csffdOpOyC0vxUAgjZFtZJDa0schnNCDOm8LPVQ
2A/35NClMQh2eMk2PSuHRJT/RX9wi0gtS6goKwWMlCSwL+UnnaGQWk/5GAKGmXg3
7RbWYbSNTxrdLGd9I1R6PAhSndBWzMj9kE4Mf5CGeAd6PsPK7ig=
=HE4c
-----END PGP SIGNATURE-----

--GaJd00UyskaZiBxM3h1vOcRdicnks61SA--

