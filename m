Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE22C161500
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgBQOrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:47:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729076AbgBQOrb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:47:31 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEi9SL094323
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:47:30 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6dq5ypxs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:47:30 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 17 Feb 2020 14:47:28 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 14:47:26 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HElN4G32833848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:47:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6DDEAE04D;
        Mon, 17 Feb 2020 14:47:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FF3FAE053;
        Mon, 17 Feb 2020 14:47:22 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 14:47:22 +0000 (GMT)
Subject: Re: [PATCH v2 20/42] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-21-borntraeger@de.ibm.com>
 <ad84934a-3d18-d56e-5658-1d8b8292f6b3@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 17 Feb 2020 15:47:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ad84934a-3d18-d56e-5658-1d8b8292f6b3@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IkuIXpRklqXzRNnAQahw4MRfuWI3zCvXn"
X-TM-AS-GCONF: 00
x-cbid: 20021714-0012-0000-0000-00000387A5DB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021714-0013-0000-0000-000021C43344
Message-Id: <d16b7ba2-38fc-5128-bd40-587d96e7936f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=11 impostorscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IkuIXpRklqXzRNnAQahw4MRfuWI3zCvXn
Content-Type: multipart/mixed; boundary="mYNSzJHYaFYGc2zZRNKkMgoP2vJy4rek4"

--mYNSzJHYaFYGc2zZRNKkMgoP2vJy4rek4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/17/20 12:08 PM, David Hildenbrand wrote:
>> @@ -4460,6 +4489,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vc=
pu *vcpu,
>> =20
>>  	switch (mop->op) {
>>  	case KVM_S390_MEMOP_LOGICAL_READ:
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D -EINVAL;
>> +			break;
>> +		}
>=20
> Could we have a possible race with disabling code, especially while
> concurrently freeing? (sorry if I ask again, there was just a flood of
> emails)
>=20
>>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>>  					    mop->size, GACC_FETCH);
>> @@ -4472,6 +4505,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vc=
pu *vcpu,
>>  		}
>>  		break;
>>  	case KVM_S390_MEMOP_LOGICAL_WRITE:
>> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r =3D -EINVAL;
>> +			break;
>> +		}
>=20
> dito
>=20
>>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>>  					    mop->size, GACC_STORE);
>> @@ -4483,6 +4520,11 @@ static long kvm_s390_guest_mem_op(struct kvm_vc=
pu *vcpu,
>>  		}
>>  		r =3D write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>>  		break;
>> +	case KVM_S390_MEMOP_SIDA_READ:
>> +	case KVM_S390_MEMOP_SIDA_WRITE:
>> +		/* we are locked against sida going away by the vcpu->mutex */
>> +		r =3D kvm_s390_guest_sida_op(vcpu, mop);
>> +		break;
>>  	default:
>>  		r =3D -EINVAL;
>>  	}
>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>> index 09573e36c329..80169a9b43ec 100644
>> --- a/arch/s390/kvm/pv.c
>> +++ b/arch/s390/kvm/pv.c
>> @@ -92,6 +92,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u=
16 *rc, u16 *rrc)
>> =20
>>  	free_pages(vcpu->arch.pv.stor_base,
>>  		   get_order(uv_info.guest_cpu_stor_len));
>> +	free_page(sida_origin(vcpu->arch.sie_block));
>>  	vcpu->arch.sie_block->pv_handle_cpu =3D 0;
>>  	vcpu->arch.sie_block->pv_handle_config =3D 0;
>>  	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
>> @@ -121,6 +122,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu,=
 u16 *rc, u16 *rrc)
>>  	uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
>>  	uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
>> =20
>> +	/* Alloc Secure Instruction Data Area Designation */
>> +	vcpu->arch.sie_block->sidad =3D __get_free_page(GFP_KERNEL | __GFP_Z=
ERO);
>> +	if (!vcpu->arch.sie_block->sidad) {
>> +		free_pages(vcpu->arch.pv.stor_base,
>> +			   get_order(uv_info.guest_cpu_stor_len));
>> +		return -ENOMEM;
>> +	}
>> +
>>  	cc =3D uv_call(0, (u64)&uvcb);
>>  	*rc =3D uvcb.header.rc;
>>  	*rrc =3D uvcb.header.rrc;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 207915488502..0fdee1bc3798 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -475,11 +475,15 @@ struct kvm_s390_mem_op {
>>  	__u32 op;		/* type of operation */
>>  	__u64 buf;		/* buffer in userspace */
>>  	__u8 ar;		/* the access register number */
>> -	__u8 reserved[31];	/* should be set to 0 */
>> +	__u8 reserved21[3];	/* should be set to 0 */
>> +	__u32 sida_offset;	/* offset into the sida */
>> +	__u8 reserved28[24];	/* should be set to 0 */
>>  };
>=20
> As discussed, I'd prefer an overlaying layout for the sida, as the ar
> does not make any sense (correct me if I'm wrong :) )

That wouldn't work, because we still check mop->ar < 16 in
kvm_s390_guest_mem_op(). Also we currently check mop contents twice
because we overload mem_op() with the SIDA operations.

Using a separate IOCTL is cleaner...

>=20
> __u32 op;		/* type of operation */
> __u64 buf;		/* buffer in userspace */
> uinon {
> 	__u8 ar;		/* the access register number */
> 	__u32 sida_offset;	/* offset into the sida */
> 	__u8 reserved[32];	/* should be set to 0 */
> };
>=20
> With something like that
>=20
> Reviewed-by: David Hildenbrand <david@redhat.com>


--mYNSzJHYaFYGc2zZRNKkMgoP2vJy4rek4--

--IkuIXpRklqXzRNnAQahw4MRfuWI3zCvXn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl5Kp3oACgkQ41TmuOI4
ufgs6Q//aDV6FqgoBX20jYAgoT6m9sEyCYx2T19DB7kB3E1nnmL1FQtRu/M+0pX8
lsHAD6pFor40xWvlmsWMbaZ9bfhLf5dv34TYPz3anU50FND4a0N+1MLMUJUrzjYo
R6dvT9qfcvelv9LmZlcrZE4sQY4ZZP2E3u5e5hls47setDMm1mrNGv2YO/0GFea4
vnWUuWAJTiTO99ICYin7NYgHdO8doXPhH1LNSdTQUogkJ0WBJi5QoWoq5o6H7G9f
Q6dA93OJNrLI31Y+Ft9GXhm3KBet2b2IGIIt2p0r9QX0pIeRQ2eouSzUVifcTeHf
L4m1CGSI18rBqbVZxLWwTqk2m3KKwB61g8V8cn0p46ZS4l8GMj8d/UGPNR+4h/jl
7nfUNkQ6W62Hgb72ezqSz6l/WRKMV2sieLHGBUqJSyJb2i9DzuXsHlJ1EqTex6rG
Izno9ZDp2+YglqNoYqnTpEKcF/4rWob5r5YDf8qBkF+Psj8m2AcIzruP/2I+Q27n
1+piMp/NOi3m/n2EJm40VrPLU0lKhiPzZ7EAhknLq2zySDsIu6xSFC4fUMURThYN
Y56dMhaSnd+MLEmOuFNav3UxWKwbjrKUz+1qyGo5cqcrXAbZQUiiASEJk+Q8yOII
Yw4B388ctnkL3cn095itQUB0ubw3uw+C4sGK55YdW6sjMGG57zE=
=G8op
-----END PGP SIGNATURE-----

--IkuIXpRklqXzRNnAQahw4MRfuWI3zCvXn--

