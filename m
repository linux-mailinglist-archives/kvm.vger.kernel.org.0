Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A48F3341
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfKGPdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 10:33:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbfKGPdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 10:33:06 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7FSvJY026727
        for <kvm@vger.kernel.org>; Thu, 7 Nov 2019 10:33:05 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w4kdd0r60-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 10:33:05 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 7 Nov 2019 15:33:02 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 7 Nov 2019 15:32:59 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7FWMnw41681268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 15:32:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83ECF11C054;
        Thu,  7 Nov 2019 15:32:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1973911C052;
        Thu,  7 Nov 2019 15:32:57 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.191.136])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 15:32:57 +0000 (GMT)
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-4-frankja@linux.ibm.com>
 <20191107162831.489e0591.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 7 Nov 2019 16:32:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191107162831.489e0591.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JpbuKnP5e1iSLMr9fWmMMCNdvdwameHl3"
X-TM-AS-GCONF: 00
x-cbid: 19110715-0020-0000-0000-000003837541
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110715-0021-0000-0000-000021D9AA59
Message-Id: <357da80d-64a5-ce48-ccea-72073479fd92@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JpbuKnP5e1iSLMr9fWmMMCNdvdwameHl3
Content-Type: multipart/mixed; boundary="g5iiKXWAa131t1DMSKjuvaDP7c8Zpn49Z"

--g5iiKXWAa131t1DMSKjuvaDP7c8Zpn49Z
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/7/19 4:28 PM, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:25 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> From: Vasily Gorbik <gor@linux.ibm.com>
>>
>> Before being able to host protected virtual machines, donate some of
>> the memory to the ultravisor. Besides that the ultravisor might impose=

>> addressing limitations for memory used to back protected VM storage. T=
reat
>> that limit as protected virtualization host's virtual memory limit.
>>
>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/uv.h | 16 ++++++++++++
>>  arch/s390/kernel/setup.c   |  3 +++
>>  arch/s390/kernel/uv.c      | 53 +++++++++++++++++++++++++++++++++++++=
+
>>  3 files changed, 72 insertions(+)
>=20
> (...)
>=20
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index 35ce89695509..f7778493e829 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -45,4 +45,57 @@ static int __init prot_virt_setup(char *val)
>>  	return rc;
>>  }
>>  early_param("prot_virt", prot_virt_setup);
>> +
>> +static int __init uv_init(unsigned long stor_base, unsigned long stor=
_len)
>> +{
>> +	struct uv_cb_init uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_INIT_UV,
>> +		.header.len =3D sizeof(uvcb),
>> +		.stor_origin =3D stor_base,
>> +		.stor_len =3D stor_len,
>> +	};
>> +	int cc;
>> +
>> +	cc =3D uv_call(0, (uint64_t)&uvcb);
>> +	if (cc || uvcb.header.rc !=3D UVC_RC_EXECUTED) {
>> +		pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
>> +		       uvcb.header.rc);
>> +		return -1;
>=20
> Is there any reasonable case where that call might fail if we have the
> facility installed? Bad stor_base, maybe?

Yes, wrong storage locations, length, etc...
Also if we are running with more than one CPU or the Ultravisor
encountered some internal error.

>=20
>> +	}
>> +	return 0;
>> +}
>> +
>> +void __init setup_uv(void)
>> +{
>> +	unsigned long uv_stor_base;
>> +
>> +	if (!prot_virt_host)
>> +		return;
>> +
>> +	uv_stor_base =3D (unsigned long)memblock_alloc_try_nid(
>> +		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
>> +		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
>> +	if (!uv_stor_base) {
>> +		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n"=
,
>> +			uv_info.uv_base_stor_len);
>> +		goto fail;
>> +	}
>> +
>> +	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
>> +		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
>> +		goto fail;
>> +	}
>> +
>> +	pr_info("Reserving %luMB as ultravisor base storage\n",
>> +		uv_info.uv_base_stor_len >> 20);
>> +	return;
>> +fail:
>> +	prot_virt_host =3D 0;
>=20
> So, what happens if the user requested protected virtualization and any=

> of the above failed? We turn off host support, so any attempt to start
> a protected virtualization guest on that host will fail (hopefully with=

> a meaningful error), I guess.
>=20

STFLE 161, and the associated diag308 subcodes 8-10 will not be
available to any VM. So yes, the stuv that starts a protected guest will
print a message.

> Is there any use case where we'd want to make failure to set this up
> fatal?

Not really.

>=20
>> +}
>> +
>> +void adjust_to_uv_max(unsigned long *vmax)
>> +{
>> +	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>> +		*vmax =3D uv_info.max_sec_stor_addr;
>> +}
>>  #endif
>=20



--g5iiKXWAa131t1DMSKjuvaDP7c8Zpn49Z--

--JpbuKnP5e1iSLMr9fWmMMCNdvdwameHl3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3EOSgACgkQ41TmuOI4
ufjddxAAk1Rs3zetVKPU6WpKo7OxFN0s/FP97Ru+lm8JcO49baidUFjAr9x8llwA
0jeoKqAt+XqAzb7A7Wa8kg6k+yTKvXLzSOtG3bOe6vmwz4/PLTgCB9t/zpjKk24L
OqJ/1BV0M8xmTpn7fFYOXMnaI2Es3hQkX3HLGBgwe8xGzSji6OBvtdEfrJ82/QWu
mI0aueASgUBcU93eKBViyfXFN+qdR5qz6+D3t1fVfecyPctL6nRngVjEztAlL2KZ
KuqpNvhKajNzWH+NXD3ZluXxjGtTruvVK9ilNCMQ2z5pF8pwR7Qfruz4ayurfbQk
XzIlTCvv0H7z4qxR8lWpRRcqr4Y4kftZP1aXg1IQOHCru9/3WjWfI1jj4fcf8Jnm
lvpXLsk9dvHWAwJRUmwgiQjoxTj8lXbXMgXQk5tXP+xUlIjSSqjaozMjG5Ek9Iqs
bh6s/gxITYMU5VizXnxCk0IYBrCPyvUe0Ehu+g7/yDgO6j+AVt9gMQYZ16XZMpR+
j87aX6k/qGYXS9RnxqR0rmz/hgjMYdHQTgAHFtm+n5B40IMyDQbndniAsxMMhLrf
RUQ9SHIqn8FImGBr/ECmVmVW9ha2viUkF3D+sULbKL2MQineDuK+DaGFH3gw+iTp
1Ah3lBVsIH9CbQIPqmgKT1M57pdT/HxGl7uJeT3+BlbuY2ppTtc=
=7e7D
-----END PGP SIGNATURE-----

--JpbuKnP5e1iSLMr9fWmMMCNdvdwameHl3--

