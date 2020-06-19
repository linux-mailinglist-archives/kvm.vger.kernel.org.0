Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20820200772
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbgFSLDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:03:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57630 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732461AbgFSLCz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 07:02:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JB259W010133;
        Fri, 19 Jun 2020 07:02:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rmmeveuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 07:02:52 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05JB2A72010589;
        Fri, 19 Jun 2020 07:02:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rmmevetn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 07:02:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JB05Tb025832;
        Fri, 19 Jun 2020 11:02:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 31qur62vmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 11:02:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JB2l4810682728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 11:02:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD19FA405C;
        Fri, 19 Jun 2020 11:02:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 200F1A405B;
        Fri, 19 Jun 2020 11:02:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.7.233])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jun 2020 11:02:47 +0000 (GMT)
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200618222222.23175-1-walling@linux.ibm.com>
 <20200618222222.23175-3-walling@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f4b49098-e417-eafe-ff9f-df9ba2004fd9@linux.ibm.com>
Date:   Fri, 19 Jun 2020 13:02:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618222222.23175-3-walling@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RRRZ5c3ABQteSpgVnZr0tUVzEK3YTbqxF"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_08:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 cotscore=-2147483648
 impostorscore=0 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RRRZ5c3ABQteSpgVnZr0tUVzEK3YTbqxF
Content-Type: multipart/mixed; boundary="fB9DzA5oDNNIQeDGi72HUd5TnGPQIdR7k"

--fB9DzA5oDNNIQeDGi72HUd5TnGPQIdR7k
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/19/20 12:22 AM, Collin Walling wrote:
> DIAGNOSE 0x318 (diag318) sets information regarding the environment
> the VM is running in (Linux, z/VM, etc) and is observed via
> firmware/service events.
>=20
> This is a privileged s390x instruction that must be intercepted by
> SIE. Userspace handles the instruction as well as migration. Data
> is communicated via VCPU register synchronization.
>=20
> The Control Program Name Code (CPNC) is stored in the SIE block. The
> CPNC along with the Control Program Version Code (CPVC) are stored
> in the kvm_vcpu_arch struct.
>=20
> The CPNC is shadowed/unshadowed in VSIE.
>=20
> This data is reset on load normal and clear resets.
>=20
> Signed-off-by: Collin Walling <walling@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Could you extend the s390 kvm selftests sync_regs test with diag318 pleas=
e?

I'd also like to have it added to the kvm unit tests. You can either do
that yourself or I'll add it when I go over my pending patches. Since we
can't retrieve these values from the VM, a simple check for the sclp
feature bit and an execution of the instruction would be enough.

> ---
>  arch/s390/include/asm/kvm_host.h |  4 +++-
>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>  arch/s390/kvm/vsie.c             |  3 +++
>  include/uapi/linux/kvm.h         |  1 +
>  5 files changed, 21 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index 3d554887794e..8bdf6f1607ca 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -260,7 +260,8 @@ struct kvm_s390_sie_block {
>  	__u32	scaol;			/* 0x0064 */
>  	__u8	sdf;			/* 0x0068 */
>  	__u8    epdx;			/* 0x0069 */
> -	__u8    reserved6a[2];		/* 0x006a */
> +	__u8	cpnc;			/* 0x006a */
> +	__u8	reserved6b;		/* 0x006b */
>  	__u32	todpr;			/* 0x006c */
>  #define GISA_FORMAT1 0x00000001
>  	__u32	gd;			/* 0x0070 */
> @@ -745,6 +746,7 @@ struct kvm_vcpu_arch {
>  	bool gs_enabled;
>  	bool skey_enabled;
>  	struct kvm_s390_pv_vcpu pv;
> +	union diag318_info diag318_info;
>  };
> =20
>  struct kvm_vm_stat {
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/=
asm/kvm.h
> index 436ec7636927..2ae1b660086c 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>  #define KVM_SYNC_GSCB   (1UL << 9)
>  #define KVM_SYNC_BPBC   (1UL << 10)
>  #define KVM_SYNC_ETOKEN (1UL << 11)
> +#define KVM_SYNC_DIAG318 (1UL << 12)
> =20
>  #define KVM_SYNC_S390_VALID_FIELDS \
>  	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>  	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \=

> -	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
> +	 KVM_SYNC_DIAG318)
> =20
>  /* length and alignment of the sdnx as a power of two */
>  #define SDNXC 8
> @@ -254,6 +256,7 @@ struct kvm_sync_regs {
>  	__u64 pft;	/* pfault token [PFAULT] */
>  	__u64 pfs;	/* pfault select [PFAULT] */
>  	__u64 pfc;	/* pfault compare [PFAULT] */
> +	__u64 diag318;	/* diagnose 0x318 info */
>  	union {
>  		__u64 vrs[32][2];	/* vector registers (KVM_SYNC_VRS) */
>  		__u64 fprs[16];		/* fp registers (KVM_SYNC_FPRS) */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d0ff26d157bc..b05ad718b64b 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -545,6 +545,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>  	case KVM_CAP_S390_AIS_MIGRATION:
>  	case KVM_CAP_S390_VCPU_RESETS:
>  	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_S390_DIAG318:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_S390_HPAGE_1M:
> @@ -3267,7 +3268,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  				    KVM_SYNC_ACRS |
>  				    KVM_SYNC_CRS |
>  				    KVM_SYNC_ARCH0 |
> -				    KVM_SYNC_PFAULT;
> +				    KVM_SYNC_PFAULT |
> +				    KVM_SYNC_DIAG318;
>  	kvm_s390_set_prefix(vcpu, 0);
>  	if (test_kvm_facility(vcpu->kvm, 64))
>  		vcpu->run->kvm_valid_regs |=3D KVM_SYNC_RICCB;
> @@ -3562,6 +3564,7 @@ static void kvm_arch_vcpu_ioctl_initial_reset(str=
uct kvm_vcpu *vcpu)
>  		vcpu->arch.sie_block->pp =3D 0;
>  		vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
>  		vcpu->arch.sie_block->todpr =3D 0;
> +		vcpu->arch.sie_block->cpnc =3D 0;
>  	}
>  }
> =20
> @@ -3579,6 +3582,7 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struc=
t kvm_vcpu *vcpu)
> =20
>  	regs->etoken =3D 0;
>  	regs->etoken_extension =3D 0;
> +	regs->diag318 =3D 0;
>  }
> =20
>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_reg=
s *regs)
> @@ -4194,6 +4198,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu=
, struct kvm_run *kvm_run)
>  		if (vcpu->arch.pfault_token =3D=3D KVM_S390_PFAULT_TOKEN_INVALID)
>  			kvm_clear_async_pf_completion_queue(vcpu);
>  	}
> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
> +		vcpu->arch.diag318_info.val =3D kvm_run->s.regs.diag318;
> +		vcpu->arch.sie_block->cpnc =3D vcpu->arch.diag318_info.cpnc;
> +	}
>  	/*
>  	 * If userspace sets the riccb (e.g. after migration) to a valid stat=
e,
>  	 * we should enable RI here instead of doing the lazy enablement.
> @@ -4295,6 +4303,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu=
, struct kvm_run *kvm_run)
>  	kvm_run->s.regs.pp =3D vcpu->arch.sie_block->pp;
>  	kvm_run->s.regs.gbea =3D vcpu->arch.sie_block->gbea;
>  	kvm_run->s.regs.bpbc =3D (vcpu->arch.sie_block->fpf & FPF_BPBC) =3D=3D=
 FPF_BPBC;
> +	kvm_run->s.regs.diag318 =3D vcpu->arch.diag318_info.val;
>  	if (MACHINE_HAS_GS) {
>  		__ctl_set_bit(2, 4);
>  		if (vcpu->arch.gs_enabled)
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 9e9056cebfcf..ba83d0568bc7 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -423,6 +423,8 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, str=
uct vsie_page *vsie_page)
>  		break;
>  	}
> =20
> +	scb_o->cpnc =3D scb_s->cpnc;
> +
>  	if (scb_s->ihcpu !=3D 0xffffU)
>  		scb_o->ihcpu =3D scb_s->ihcpu;
>  }
> @@ -548,6 +550,7 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct=
 vsie_page *vsie_page)
>  		scb_s->ecd |=3D scb_o->ecd & ECD_ETOKENF;
> =20
>  	scb_s->hpid =3D HPID_VSIE;
> +	scb_s->cpnc =3D scb_o->cpnc;
> =20
>  	prepare_ibc(vcpu, vsie_page);
>  	rc =3D shadow_crycb(vcpu, vsie_page);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..35cdb4307904 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_S390_DIAG318 184
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
>=20



--fB9DzA5oDNNIQeDGi72HUd5TnGPQIdR7k--

--RRRZ5c3ABQteSpgVnZr0tUVzEK3YTbqxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7sm1YACgkQ41TmuOI4
ufiVIhAArKah8H1/B1uJdDpob+k2WdcP0DWMgwfSRtAUOxv0534e6p6VzUCzvCwW
/V1j26UiHAVaQmVxTrj0TLvnz4zv9kqF/jGANTdCnJlAe1YOU/yohJghSoWH6upK
NIJqjWE3Q4kh71UQBQ3k1Y1QaB8Q+yTEiv24mtygTM7V60z3icn5BJwEt8MplExW
kdX9zc1+mzb7pzPWa8pyegndVtINSgKWfc9Q1U0kNExbN0LXDxgtccZLjaNwtvDp
WIbZZRH/SJ/ex1Oc/ItvGtI7ZFWnlfuA//67vzkBD50zfYw5/72qksIa42sa60Lj
4keVMzto+gO6zzoIuFt5j/yn3fyeL1GErQ7vkNeaWcEB3pdBCCV+z15rsHp1BjKo
EAQHFruJil8H/yeWa0fS6l85bQhnq18iKQB3CTVsaJJjd6ZoXXpXu+s+1nLBYh9x
YPVeNuxPtF4enZcNoElMNZiHInssaII1mRQOzdwtj/jZ3F9TgRodCDglM00vm5Z7
eDTaGiGipvGrT9cat/nc64PeZC97FzoXOj9zxqIrMEGTpdJWVYhLIIlqR6zvI9ue
eoiMiKwfl55YmYzeQGxwgPxU+goUEM1LPHjUvlcqmBhblDTOzuMLLS+SjrSE4cGc
lwdhVJn8aKZbPTRWIJugImKt0mN3cv1rxnn4zrp9r6mV1zYM1H4=
=YZNC
-----END PGP SIGNATURE-----

--RRRZ5c3ABQteSpgVnZr0tUVzEK3YTbqxF--

