Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D528BA7CD8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 09:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfIDHdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 03:33:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbfIDHdy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Sep 2019 03:33:54 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x847XI6E003957
        for <kvm@vger.kernel.org>; Wed, 4 Sep 2019 03:33:52 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ut5vw5pdw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 03:33:52 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 4 Sep 2019 08:33:50 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Sep 2019 08:33:48 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x847Xl2v44564858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 07:33:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04E5952051;
        Wed,  4 Sep 2019 07:33:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.72])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 881FA52050;
        Wed,  4 Sep 2019 07:33:46 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Disallow invalid bits in kvm_valid_regs and
 kvm_dirty_regs
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190904071308.25683-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 4 Sep 2019 09:33:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190904071308.25683-1-thuth@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KCJXWAnzrD8uRwAanjK8DKax8UhWoz0bJ"
X-TM-AS-GCONF: 00
x-cbid: 19090407-0016-0000-0000-000002A67A96
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090407-0017-0000-0000-00003306E66B
Message-Id: <3b1666ee-0b7f-a775-3622-5ca7f938aeb0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=967 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KCJXWAnzrD8uRwAanjK8DKax8UhWoz0bJ
Content-Type: multipart/mixed; boundary="xPn7lGCZnSVGl0FJB37AXdkF6Z4YI95iy";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <3b1666ee-0b7f-a775-3622-5ca7f938aeb0@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: Disallow invalid bits in kvm_valid_regs and
 kvm_dirty_regs
References: <20190904071308.25683-1-thuth@redhat.com>
In-Reply-To: <20190904071308.25683-1-thuth@redhat.com>

--xPn7lGCZnSVGl0FJB37AXdkF6Z4YI95iy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/4/19 9:13 AM, Thomas Huth wrote:
> If unknown bits are set in kvm_valid_regs or kvm_dirty_regs, this
> clearly indicates that something went wrong in the KVM userspace
> application. The x86 variant of KVM already contains a check for
> bad bits (and the corresponding kselftest checks this), so let's
> do the same on s390x now, too.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

I think it would make sense to split the kvm changes from the test.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/include/uapi/asm/kvm.h              |  6 ++++
>  arch/s390/kvm/kvm-s390.c                      |  4 +++
>  .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++=

>  3 files changed, 40 insertions(+)
>=20
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/=
asm/kvm.h
> index 47104e5b47fd..436ec7636927 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -231,6 +231,12 @@ struct kvm_guest_debug_arch {
>  #define KVM_SYNC_GSCB   (1UL << 9)
>  #define KVM_SYNC_BPBC   (1UL << 10)
>  #define KVM_SYNC_ETOKEN (1UL << 11)
> +
> +#define KVM_SYNC_S390_VALID_FIELDS \
> +	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
> +	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \=

> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
> +
>  /* length and alignment of the sdnx as a power of two */
>  #define SDNXC 8
>  #define SDNXL (1UL << SDNXC)
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 49d7722229ae..a7d7dedfe527 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3998,6 +3998,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u, struct kvm_run *kvm_run)
>  	if (kvm_run->immediate_exit)
>  		return -EINTR;
> =20
> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
> +	    kvm_run->kvm_dirty_regs & ~KVM_SYNC_S390_VALID_FIELDS)
> +		return -EINVAL;
> +
>  	vcpu_load(vcpu);
> =20
>  	if (guestdbg_exit_pending(vcpu)) {
> diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools=
/testing/selftests/kvm/s390x/sync_regs_test.c
> index bbc93094519b..d5290b4ad636 100644
> --- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> @@ -85,6 +85,36 @@ int main(int argc, char *argv[])
> =20
>  	run =3D vcpu_state(vm, VCPU_ID);
> =20
> +	/* Request reading invalid register set from VCPU. */
> +	run->kvm_valid_regs =3D INVALID_SYNC_FIELD;
> +	rv =3D _vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(rv < 0 && errno =3D=3D EINVAL,
> +		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d=
\n",
> +		    rv);
> +	vcpu_state(vm, VCPU_ID)->kvm_valid_regs =3D 0;
> +
> +	run->kvm_valid_regs =3D INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
> +	rv =3D _vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(rv < 0 && errno =3D=3D EINVAL,
> +		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d=
\n",
> +		    rv);
> +	vcpu_state(vm, VCPU_ID)->kvm_valid_regs =3D 0;
> +
> +	/* Request setting invalid register set into VCPU. */
> +	run->kvm_dirty_regs =3D INVALID_SYNC_FIELD;
> +	rv =3D _vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(rv < 0 && errno =3D=3D EINVAL,
> +		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d=
\n",
> +		    rv);
> +	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs =3D 0;
> +
> +	run->kvm_dirty_regs =3D INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
> +	rv =3D _vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(rv < 0 && errno =3D=3D EINVAL,
> +		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d=
\n",
> +		    rv);
> +	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs =3D 0;
> +
>  	/* Request and verify all valid register sets. */
>  	run->kvm_valid_regs =3D TEST_SYNC_FIELDS;
>  	rv =3D _vcpu_run(vm, VCPU_ID);
>=20



--xPn7lGCZnSVGl0FJB37AXdkF6Z4YI95iy--

--KCJXWAnzrD8uRwAanjK8DKax8UhWoz0bJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1vaNoACgkQ41TmuOI4
ufjW5xAAqrwQio0Wlchvkb6AmqBKX2hwY0bGnw4oALIkbpoEMQIKLp1Ka88r55wt
cZAk90yeT7AMHNpeerBsMqkXRn5FhWkCdGGcowmjPNLHImCCwq8YztzNmps+yvxR
S25XUoTODXHPXZFVxUyvLsA2wQPuKuo1nt9jvT9Ecbfoi4IFs/Hr/9+cIBWb4Dx4
Cci6QnW/dLpEkgZ195hgZOif+ENGbd7fod5y73zkCI/sVrUPWyhM/di3afS2pDOZ
7+Ckf9ydQDbGP1dfEPK5tsi/bYmKpHHqH5ORhemKJRGgBjaLqEPBq5pzxvYkVM50
TPP3SpukZmDHzFX7VvIWMuGApyxE+IEC3+u2zGBabZTE+hMIAlRDrW6LplmV42dt
ZyhPr9tJCYRLiMdzBZLzL1lBPm9EqbBhV47/WM66iu7256ljJ03eN6KeBlBOT8PC
KdpR7LmyB5EoNTYMZ6XgBmBefFKb/JTcigTtIaXNXIOrlbVT2kreYpp2KIN/lwif
DAFiTJptZX9W+tIBV6A0b9SXQBeovLiDCBjMlSZy08Edm18dr5TVeUbhoQGtpYyY
7/jf6WVewzjn4YO/1hX2a1uL5dkCDLoIhx18IuQ+V7MPlbELoYZQuB7+P074xR7e
UiQmR8/qS29kOKEpaMx75rk9N2BRmyahWRjo7mCbjsNC0mB479Q=
=bXog
-----END PGP SIGNATURE-----

--KCJXWAnzrD8uRwAanjK8DKax8UhWoz0bJ--

