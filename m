Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB2161555
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 16:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgBQPAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 10:00:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729206AbgBQPAg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 10:00:36 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HExIsc106312
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 10:00:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6b55m808-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 10:00:35 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 17 Feb 2020 15:00:33 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 15:00:29 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HF0Qj738731938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 15:00:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0786AE055;
        Mon, 17 Feb 2020 15:00:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 826D0AE07B;
        Mon, 17 Feb 2020 15:00:23 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 15:00:23 +0000 (GMT)
Subject: Re: [PATCH 2/2] merge vm/cpu create
To:     Christian Borntraeger <borntraeger@de.ibm.com>, david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, cohuck@redhat.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
References: <c77dbb1b-0f4b-e40a-52a4-7110aec75e32@redhat.com>
 <20200217145302.19085-1-borntraeger@de.ibm.com>
 <20200217145302.19085-3-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 17 Feb 2020 16:00:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200217145302.19085-3-borntraeger@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="opHh495dNbr5zNDaGqk492TywDzNckW4e"
X-TM-AS-GCONF: 00
x-cbid: 20021715-0028-0000-0000-000003DBCE0C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021715-0029-0000-0000-000024A0D45A
Message-Id: <5c0b4baa-4113-d183-5bc6-c1e7b1f3032c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=955 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--opHh495dNbr5zNDaGqk492TywDzNckW4e
Content-Type: multipart/mixed; boundary="7U3dZrw8iMZ2XlITEFJGdRT8ciCVUpoBk"

--7U3dZrw8iMZ2XlITEFJGdRT8ciCVUpoBk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/17/20 3:53 PM, Christian Borntraeger wrote:
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 55 +++++++++++++++++++++++++++++-----------=

>  1 file changed, 40 insertions(+), 15 deletions(-)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index a095d9695f18..10b20e17a7fe 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2171,9 +2171,41 @@ static int kvm_s390_set_cmma_bits(struct kvm *kv=
m,
>  	return r;
>  }
> =20
> +static int kvm_s390_switch_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc)=

> +{
> +	int i, r =3D 0;
> +
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		r =3D kvm_s390_pv_destroy_cpu(vcpu, rc, rrc);
> +		if (r)
> +			break;
> +	}
> +	return r;
> +}
> +
> +static int kvm_s390_switch_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
> +{
> +	int i, r =3D 0;
> +	u16 dummy;
> +
> +	struct kvm_vcpu *vcpu;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		r =3D kvm_s390_pv_create_cpu(vcpu, rc, rrc);
> +		if (r)
> +			break;
> +	}
> +	if (r)
> +		kvm_s390_switch_from_pv(kvm,&dummy, &dummy);
> +	return r;
> +}

Why does that only affect the cpus?
If we have a switch function it should do VM and VCPUs, no?

> +
>  static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)=

>  {
>  	int r =3D 0;
> +	u16 dummy;
>  	void __user *argp =3D (void __user *)cmd->data;
> =20
>  	switch (cmd->cmd) {
> @@ -2204,6 +2236,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, s=
truct kvm_pv_cmd *cmd)
>  			break;
>  		}
>  		r =3D kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
> +		if (!r)
> +			r =3D kvm_s390_switch_to_pv(kvm, &cmd->rc, &cmd->rrc);
> +		if (r)
> +			kvm_s390_pv_destroy_vm(kvm, &dummy, &dummy);
> +
>  		kvm_s390_vcpu_unblock_all(kvm);
>  		/* we need to block service interrupts from now on */
>  		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> @@ -2215,7 +2252,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, st=
ruct kvm_pv_cmd *cmd)
>  			break;
> =20
>  		kvm_s390_vcpu_block_all(kvm);
> -		r =3D kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
> +		r =3D kvm_s390_switch_from_pv(kvm, &cmd->rc, &cmd->rrc);
> +		if (!r)
> +			r =3D kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
>  		if (!r)
>  			kvm_s390_pv_dealloc_vm(kvm);
>  		kvm_s390_vcpu_unblock_all(kvm);
> @@ -4660,20 +4699,6 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vc=
pu *vcpu,
>  		return -EINVAL;
> =20
>  	switch (cmd->cmd) {
> -	case KVM_PV_VCPU_CREATE: {
> -		if (kvm_s390_pv_handle_cpu(vcpu))
> -			return -EINVAL;
> -
> -		r =3D kvm_s390_pv_create_cpu(vcpu, &cmd->rc, &cmd->rrc);
> -		break;
> -	}
> -	case KVM_PV_VCPU_DESTROY: {
> -		if (!kvm_s390_pv_handle_cpu(vcpu))
> -			return -EINVAL;
> -
> -		r =3D kvm_s390_pv_destroy_cpu(vcpu, &cmd->rc, &cmd->rrc);
> -		break;
> -	}
>  	case KVM_PV_VCPU_SET_IPL_PSW: {
>  		if (!kvm_s390_pv_handle_cpu(vcpu))
>  			return -EINVAL;
>=20



--7U3dZrw8iMZ2XlITEFJGdRT8ciCVUpoBk--

--opHh495dNbr5zNDaGqk492TywDzNckW4e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl5KqocACgkQ41TmuOI4
ufiI8BAAoJ2QKJXrtHOE6mP66YN4euIaJRbUsWA+tWAkgAZ838vKmGdHzLituTlm
sTFIgD3/dHwaRw4geZSlAGU4nt3ItDJPEaBQLwLRJ3eBQSbrB3lTnYUBen/t7nSC
0Iv7TMXWua677v3mqMiJbEXSmmoBLAKzWMqWV7v1Z/qzJXmEKf3HCbGNosIWT/ZX
ZhYQuGMBSFHgbSHnBW7IRE0bWiTHdTNBvAnFzveVaU3xfa3RAU5HUhUmksdLRafU
Vx6DHXfOz3W90YPWLjQmVczwwUO7IIblORNX+/qFLYRPjwyVmeqUV7Us6OpQyBuM
66g+tuD8s5sKb5X0sEtKP73Xpl1sbXz7kxdaiiGLy4MMCLAL5XsTp4nUVuGDM4Kh
LHoEsNp7ZCxbUMWOZ9MnKqgPH+I0Zuv/Sh6Ww6mNllpqGAFpmgdqlI2A0lgC7mLX
CUu7d4ys1U7VNBjVoDyzbdbkIxiqENdJgA58T3ncsVAFW/FP/sEWt0OF1lhx/dAw
62UX/70FD71gOdOn3YxdV9mqjN3OgApgcQd1YGkfSuFAFfuCad2D2J4nJbuBVEHG
4cA/ts2FG5VONltw62m+mXrnK3+EblmkrCBdbg+hSQVAdib6JtMpGufT72BpI7Sl
PkJKNzwRkCLBb4rYy2UxjQrG2aDDGpvSM7OPC44cfhPef/CN0NM=
=eqy7
-----END PGP SIGNATURE-----

--opHh495dNbr5zNDaGqk492TywDzNckW4e--

