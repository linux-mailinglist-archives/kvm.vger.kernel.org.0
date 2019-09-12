Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD65B0E74
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfILMCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 08:02:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731106AbfILMCo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Sep 2019 08:02:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8CBwTRJ124636
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 08:02:43 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uyktpmka0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 08:02:42 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 12 Sep 2019 13:02:40 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Sep 2019 13:02:34 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8CC2XSN38469942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 12:02:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8AB4AE9DF;
        Thu, 12 Sep 2019 11:36:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C3C7AE9D8;
        Thu, 12 Sep 2019 11:36:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.92.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Sep 2019 11:36:49 +0000 (GMT)
Subject: Re: [PATCH 05/13] KVM: Refactor error handling for setting memory
 region
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-6-sean.j.christopherson@intel.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 12 Sep 2019 13:36:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190911185038.24341-6-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bm0JecVlrjrc0FKCyusctXhutbwL6ZTpe"
X-TM-AS-GCONF: 00
x-cbid: 19091212-0016-0000-0000-000002AA674A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091212-0017-0000-0000-0000330AF860
Message-Id: <9773a72d-2a58-fbb1-ed2b-82af0bb5f49a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909120129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bm0JecVlrjrc0FKCyusctXhutbwL6ZTpe
Content-Type: multipart/mixed; boundary="6J8eeynfSebyZsyGavbEUWKxUSMvfibQv";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 James Hogan <jhogan@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>,
 Suzuki K Pouloze <suzuki.poulose@arm.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Message-ID: <9773a72d-2a58-fbb1-ed2b-82af0bb5f49a@linux.ibm.com>
Subject: Re: [PATCH 05/13] KVM: Refactor error handling for setting memory
 region
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-6-sean.j.christopherson@intel.com>
In-Reply-To: <20190911185038.24341-6-sean.j.christopherson@intel.com>

--6J8eeynfSebyZsyGavbEUWKxUSMvfibQv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/11/19 8:50 PM, Sean Christopherson wrote:
> Replace a big pile o' gotos with returns to make it more obvious what
> error code is being returned, and to prepare for refactoring the
> functional, i.e. post-checks, portion of __kvm_set_memory_region().
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Definitely necessary
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  virt/kvm/kvm_main.c | 40 ++++++++++++++++++----------------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ea8f2f37096f..8306ce3345a6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -929,34 +929,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
> =20
>  	r =3D check_memory_region_flags(mem);
>  	if (r)
> -		goto out;
> +		return r;
> =20
> -	r =3D -EINVAL;
>  	as_id =3D mem->slot >> 16;
>  	id =3D (u16)mem->slot;
> =20
>  	/* General sanity checks */
>  	if (mem->memory_size & (PAGE_SIZE - 1))
> -		goto out;
> +		return -EINVAL;
>  	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
> -		goto out;
> +		return -EINVAL;
>  	/* We can read the guest memory with __xxx_user() later on. */
>  	if ((id < KVM_USER_MEM_SLOTS) &&
>  	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
>  	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>  			mem->memory_size)))
> -		goto out;
> +		return -EINVAL;
>  	if (as_id >=3D KVM_ADDRESS_SPACE_NUM || id >=3D KVM_MEM_SLOTS_NUM)
> -		goto out;
> +		return -EINVAL;
>  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> -		goto out;
> +		return -EINVAL;
> =20
>  	slot =3D id_to_memslot(__kvm_memslots(kvm, as_id), id);
>  	base_gfn =3D mem->guest_phys_addr >> PAGE_SHIFT;
>  	npages =3D mem->memory_size >> PAGE_SHIFT;
> =20
>  	if (npages > KVM_MEM_MAX_NR_PAGES)
> -		goto out;
> +		return -EINVAL;
> =20
>  	new =3D old =3D *slot;
> =20
> @@ -973,20 +972,18 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			if ((new.userspace_addr !=3D old.userspace_addr) ||
>  			    (npages !=3D old.npages) ||
>  			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
> -				goto out;
> +				return -EINVAL;
> =20
>  			if (base_gfn !=3D old.base_gfn)
>  				change =3D KVM_MR_MOVE;
>  			else if (new.flags !=3D old.flags)
>  				change =3D KVM_MR_FLAGS_ONLY;
> -			else { /* Nothing to change. */
> -				r =3D 0;
> -				goto out;
> -			}
> +			else /* Nothing to change. */
> +				return 0;
>  		}
>  	} else {
>  		if (!old.npages)
> -			goto out;
> +			return -EINVAL;
> =20
>  		change =3D KVM_MR_DELETE;
>  		new.base_gfn =3D 0;
> @@ -995,29 +992,29 @@ int __kvm_set_memory_region(struct kvm *kvm,
> =20
>  	if ((change =3D=3D KVM_MR_CREATE) || (change =3D=3D KVM_MR_MOVE)) {
>  		/* Check for overlaps */
> -		r =3D -EEXIST;
>  		kvm_for_each_memslot(slot, __kvm_memslots(kvm, as_id)) {
>  			if (slot->id =3D=3D id)
>  				continue;
>  			if (!((base_gfn + npages <=3D slot->base_gfn) ||
>  			      (base_gfn >=3D slot->base_gfn + slot->npages)))
> -				goto out;
> +				return -EEXIST;
>  		}
>  	}
> =20
> -	r =3D -ENOMEM;
> -
>  	/* Allocate/free page dirty bitmap as needed */
>  	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
>  		new.dirty_bitmap =3D NULL;
>  	else if (!new.dirty_bitmap) {
> -		if (kvm_create_dirty_bitmap(&new) < 0)
> -			goto out;
> +		r =3D kvm_create_dirty_bitmap(&new);
> +		if (r)
> +			return r;
>  	}
> =20
>  	slots =3D kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> -	if (!slots)
> +	if (!slots) {
> +		r =3D -ENOMEM;
>  		goto out_bitmap;
> +	}
>  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots)=
);
> =20
>  	if ((change =3D=3D KVM_MR_DELETE) || (change =3D=3D KVM_MR_MOVE)) {
> @@ -1068,7 +1065,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  out_bitmap:
>  	if (new.dirty_bitmap && !old.dirty_bitmap)
>  		kvm_destroy_dirty_bitmap(&new);
> -out:
>  	return r;
>  }
>  EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
>=20



--6J8eeynfSebyZsyGavbEUWKxUSMvfibQv--

--Bm0JecVlrjrc0FKCyusctXhutbwL6ZTpe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl16LdAACgkQ41TmuOI4
ufiqdRAAk7Fq5LoAJLqJFxnCihIQRlcl8vo542WY/o9SIjSW82ULb9ja3jx/IZOo
zXJt4+l9ZwKB3cwu3Z9pkvcu+D7PgbVSHyCAraimR8rk/TznU4esmSGNZX//BmaX
AfSdajjNFNRXP+HsOlR0OVsvX6JBWQqfikSvqUv+GGzhOOB5TT7QIlNGTUFJhTuj
DWsP4KnnRlxI8a6Tz0mXfcJLDABMu2Ypl8IjtEkAS57byfjVuy1fP3/WtiWW8QST
2BeoiY5FQH/syqW0oXYO6Ov2rlS2gKMPwaL5nQwuHrOxd+A1qZv9rX7NU1P3+eZq
+Xutlm/mQHajvO6FfiuUf2pG/YuwfCyhX/ENMcmohw5TO1sdZDcY/BSHop0UYv+F
8RkUxxstxRot67kTQvjZ1p60Tz/SYmxszldFM2noNPjzitbwUoiHrLl9Ti1MeMJ3
QXb1ZCuTA8/F138tNGVL52JIOrsbIqvdLoc1/4qxJPLYbHzF/HMSqJ0nHl8tFa5Y
D9N8xdr1pdQoHKNVLDVI8b5Jt5yMaeN4WrBqOFxTVme6XCxGu2eNRxyNWZbA2+Z3
nDkoU2HaEDH3QbH2LuZy9wDTHlPb1dnO3XatbDqCf32/gsChlKjuEcKOcNnBVntM
Izb7sxZStgMuHCrkgWweUjFkyR93+8JboW1iJKcFYtR1FWfffyU=
=pPrb
-----END PGP SIGNATURE-----

--Bm0JecVlrjrc0FKCyusctXhutbwL6ZTpe--

