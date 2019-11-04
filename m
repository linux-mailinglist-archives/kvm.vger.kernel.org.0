Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C955EEDAAD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 09:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfKDIlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 03:41:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726441AbfKDIlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 03:41:31 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA48eYrw018028
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 03:41:30 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w2dr15ws3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:41:29 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 08:41:27 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 08:41:25 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA48fOXI28573954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 08:41:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25A9452051;
        Mon,  4 Nov 2019 08:41:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9D14252057;
        Mon,  4 Nov 2019 08:41:23 +0000 (GMT)
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-5-frankja@linux.ibm.com>
 <d87e2322-2dc6-0633-b64b-e3286186ea4c@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 4 Nov 2019 09:41:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <d87e2322-2dc6-0633-b64b-e3286186ea4c@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cmgjGry7htCKaf8L3hCrXC6JvZwASoIyh"
X-TM-AS-GCONF: 00
x-cbid: 19110408-0020-0000-0000-000003824B77
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110408-0021-0000-0000-000021D86DC7
Message-Id: <44dde437-a73b-8a57-ab7f-c2d9e9ea4b4e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cmgjGry7htCKaf8L3hCrXC6JvZwASoIyh
Content-Type: multipart/mixed; boundary="M4JPJqBAkan5Ymz4Lu2q2exZXUYC2Qx3r"

--M4JPJqBAkan5Ymz4Lu2q2exZXUYC2Qx3r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/4/19 9:18 AM, Christian Borntraeger wrote:
>=20
>=20
> On 24.10.19 13:40, Janosch Frank wrote:
>> Let's add a KVM interface to create and destroy protected VMs.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  24 +++-
>>  arch/s390/include/asm/uv.h       | 110 ++++++++++++++
>>  arch/s390/kvm/Makefile           |   2 +-
>>  arch/s390/kvm/kvm-s390.c         | 173 +++++++++++++++++++++-
>>  arch/s390/kvm/kvm-s390.h         |  47 ++++++
>>  arch/s390/kvm/pv.c               | 237 ++++++++++++++++++++++++++++++=
+
>>  include/uapi/linux/kvm.h         |  33 +++++
>>  7 files changed, 622 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/s390/kvm/pv.c
> [...]
>=20
>> +	case KVM_PV_VM_UNPACK: {
>> +		struct kvm_s390_pv_unp unp =3D {};
>> +
>> +		r =3D -EFAULT;
>> +		if (copy_from_user(&unp, argp, sizeof(unp)))
>> +			break;
>> +
>> +		r =3D kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
>> +		break;
>> +	}
>=20
>=20
>=20
> [....]
>=20
>> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned =
long size,
>> +		       unsigned long tweak)
>> +{
>> +	int i, rc =3D 0;
>> +	struct uv_cb_unp uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_UNPACK_IMG,
>> +		.header.len =3D sizeof(uvcb),
>> +		.guest_handle =3D kvm_s390_pv_handle(kvm),
>> +		.tweak[0] =3D tweak
>> +	};
>> +
>> +	if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
>> +		return -EINVAL;
>> +
>> +
>> +	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
>> +		 addr, size);
>=20
> Does it make sense to check for addr and addr+size to be within the mem=
ory
> size of the guest? The uv_call or gmap_fault will fail later on, but we=
=20
> could do an early exit if the the site is wrong.=20

Yeah, Marc already brought that up because of a testcase of his.
I'll add a check, but before that I need to understand what makes us
loop so long that we get RCU warnings.

>=20
>=20
>=20
>=20
>> +	for (i =3D 0; i < size / PAGE_SIZE; i++) {
>> +		uvcb.gaddr =3D addr + i * PAGE_SIZE;
>> +		uvcb.tweak[1] =3D i * PAGE_SIZE;
>=20
>=20
>> +retry:
>=20
>> +		rc =3D uv_call(0, (u64)&uvcb);
>> +		if (!rc)
>> +			continue;
>> +		/* If not yet mapped fault and retry */
>> +		if (uvcb.header.rc =3D=3D 0x10a) {
>> +			rc =3D gmap_fault(kvm->arch.gmap, uvcb.gaddr,
>> +					FAULT_FLAG_WRITE);
>> +			if (rc)
>> +				return rc;
>> +			goto retry;
>> +		}
>> +		VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x=
",
>> +			 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
>> +		break;
>> +	}
> [...]
>=20



--M4JPJqBAkan5Ymz4Lu2q2exZXUYC2Qx3r--

--cmgjGry7htCKaf8L3hCrXC6JvZwASoIyh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2/5DMACgkQ41TmuOI4
ufgNxg/+JxkvbvHXrscDwohfLjwfM+h/g+/GSON95MHAjYH84YuNYTgW7Jcd1GM5
96VCYbAq3J0WlRKf7LV1vAOoyiVuRev1v2g++inBRGEHA1PmseShfQiaWSsxQTWg
pJ/dC4W6blmw83LuK3lW8upQNhcD55D7M5g1rMdTeSmdn4pitAjqinRViu0pO7hb
zr1YTufhw5AtfznamFcQWCbZbkXW2vEPNUJ+r65d9Jma/Gd/7h086e+Cqprnf49p
1oY+VkgRjazA6OHJ4L9r2vs4G5yI+yuVSUV/Y+eZdR3V+suNGF9fbd+YWxeXkRkO
/ShQwgOFGFFHDWsXlDx/SLQXmSuHe7YHi4GRoT88NOm4dtfYKlWZ4/UC8nzwtbku
iPL2tAeQiCkNZdvjAqh7UIvP2s3ZEOfPY7Z9qgwZxagxYf9Dmb3W/xVq1Gg2Mly1
vG5KxSbUqrx/pH16wcnteX31ZURDRYwf0J0OxWdBAggkfoULmYSCYVHGVoIQbjWn
bXR72tm05k8yyJh4/O9EiydlwlyRhduGciicAxH3iKw7+tZPO73seL1dBOmBWMJq
K+GCOZpfOvj1yzX9Dmxtmtj+mT9RDuF7Chk3Qhc1H6x7RvkxjvylVGYvvBFtIzS3
Ec6F6ZRN1ofsxYBmpNgNpjF3CbuiZU7HgU4Lo6edGr1mEtyOwiU=
=mlqE
-----END PGP SIGNATURE-----

--cmgjGry7htCKaf8L3hCrXC6JvZwASoIyh--

