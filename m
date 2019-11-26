Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7101910A265
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 17:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfKZQoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 11:44:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727532AbfKZQoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Nov 2019 11:44:30 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQGKAHu148718;
        Tue, 26 Nov 2019 11:44:24 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfjyyfs6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 11:44:24 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAQGLuw6154598;
        Tue, 26 Nov 2019 11:44:23 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfjyyfs67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 11:44:23 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAQGgIH5022856;
        Tue, 26 Nov 2019 16:44:23 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2wevd6ky33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 16:44:22 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAQGiM4A51904772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 16:44:22 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29B4AAC059;
        Tue, 26 Nov 2019 16:44:22 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BA2EAC05F;
        Tue, 26 Nov 2019 16:44:21 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Nov 2019 16:44:20 +0000 (GMT)
Message-ID: <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Nov 2019 13:44:14 -0300
In-Reply-To: <20191021225842.23941-1-sean.j.christopherson@intel.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-52kbVxCF+8CnJXvXqmiD"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_04:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911260139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-52kbVxCF+8CnJXvXqmiD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-10-21 at 15:58 -0700, Sean Christopherson wrote:
> Add a new helper, kvm_put_kvm_no_destroy(), to handle putting a
> borrowed
> reference[*] to the VM when installing a new file descriptor
> fails.  KVM
> expects the refcount to remain valid in this case, as the in-progress
> ioctl() has an explicit reference to the VM.  The primary motiviation
> for the helper is to document that the 'kvm' pointer is still valid
> after putting the borrowed reference, e.g. to document that doing
> mutex(&kvm->lock) immediately after putting a ref to kvm isn't
> broken.
>=20
> [*] When exposing a new object to userspace via a file descriptor,
> e.g.
>     a new vcpu, KVM grabs a reference to itself (the VM) prior to
> making
>     the object visible to userspace to avoid prematurely freeing the
> VM
>     in the scenario where userspace immediately closes file
> descriptor.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |  2 +-
>  arch/powerpc/kvm/book3s_64_vio.c    |  2 +-
>  include/linux/kvm_host.h            |  1 +
>  virt/kvm/kvm_main.c                 | 16 ++++++++++++++--
>  4 files changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 9a75f0e1933b..68678e31c84c 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -2000,7 +2000,7 @@ int kvm_vm_ioctl_get_htab_fd(struct kvm *kvm,
> struct kvm_get_htab_fd *ghf)
>  	ret =3D anon_inode_getfd("kvm-htab", &kvm_htab_fops, ctx, rwflag
> | O_CLOEXEC);
>  	if (ret < 0) {
>  		kfree(ctx);
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		return ret;
>  	}
>=20
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c
> b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..883a66e76638 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -317,7 +317,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm
> *kvm,
>  	if (ret >=3D 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
>  	else
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>=20
>  	mutex_unlock(&kvm->lock);
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 719fc3e15ea4..90a2102605ef 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -622,6 +622,7 @@ void kvm_exit(void);
>=20
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +void kvm_put_kvm_no_destroy(struct kvm *kvm);
>=20
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm,
> int as_id)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ef3f2e19e8..b8534c6b8cf6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -772,6 +772,18 @@ void kvm_put_kvm(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_put_kvm);
>=20
> +/*
> + * Used to put a reference that was taken on behalf of an object
> associated
> + * with a user-visible file descriptor, e.g. a vcpu or device, if
> installation
> + * of the new file descriptor fails and the reference cannot be
> transferred to
> + * its final owner.  In such cases, the caller is still actively
> using @kvm and
> + * will fail miserably if the refcount unexpectedly hits zero.
> + */
> +void kvm_put_kvm_no_destroy(struct kvm *kvm)
> +{
> +	WARN_ON(refcount_dec_and_test(&kvm->users_count));
> +}
> +EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
>=20
>  static int kvm_vm_release(struct inode *inode, struct file *filp)
>  {
> @@ -2679,7 +2691,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm
> *kvm, u32 id)
>  	kvm_get_kvm(kvm);
>  	r =3D create_vcpu_fd(vcpu);
>  	if (r < 0) {
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		goto unlock_vcpu_destroy;
>  	}
>=20
> @@ -3117,7 +3129,7 @@ static int kvm_ioctl_create_device(struct kvm
> *kvm,
>  	kvm_get_kvm(kvm);
>  	ret =3D anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR
> | O_CLOEXEC);
>  	if (ret < 0) {
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		mutex_lock(&kvm->lock);
>  		list_del(&dev->vm_node);
>  		mutex_unlock(&kvm->lock);

Hello,

I see what are you solving here, but would not this behavior cause the
refcount to reach negative values?

If so, is not there a problem? I mean, in some archs (powerpc included)
refcount_dec_and_test() will decrement and then test if the value is
equal 0. If we ever reach a negative value, this will cause that memory
to never be released.=20

An example is that refcount_dec_and_test(), on other archs than x86,
will call atomic_dec_and_test(), which on include/linux/atomic-
fallback.h will do:

return atomic_dec_return(v) =3D=3D 0;

To change this behavior, it would mean change the whole atomic_*_test
behavior, or do a copy function in order to change this '=3D=3D 0' to=20
'<=3D 0'.=20

Does it make sense? Do you need any help on this?

Kind regards,
Leonardo Br=C3=A1s

--=-52kbVxCF+8CnJXvXqmiD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3dVl4ACgkQlQYWtz9S
ttQDdg/9GGVFNwax4jGA9g0X5EW/+VauOibm5CHqZcbdKz3PVLkrQjVZGNqi928L
SZQ/Bi0Tt7dNBYiKoAPkC4Z8WdjvTyfzPb7lqAL/6JVpcTeI69i1n+PBmitv1olg
+dBHG+sls0+S6ZeNdxfT+hPvpNU0L5FHq6TMKm6QL97uWNaPCmqZ0sFqfWxa9yIb
ZzuytXBggfaS1cqt5LFNKyq70pwegzateV7WnwR6g2CyVqorx0/J8wUK0AcNy5r1
+W/ouKccefa3dIq85ilHyPucwDmV2XdDxosYClhzfcKdJSoHvcAN4+v3Tbiavwh9
47//sUx2XxoLY5b7+chy0vamRPyeODmb+w6uczA654j040Npsw+j7JO5rWJATWVE
0ODbJ2jnLuMEHlPSu724//omXiE0wErv61kw7GqTsRh+Sz+jt7nQm1dTUMQGHctJ
DSg1+mxZJWppXwdzYwc/KGthRiY9hgvB3LrXmWOj7F7ADqIV0kc9D1oTmLNhIADK
06yNYQnAh50HDpjTK5I+6teE90qgxRCiPVso0g+krXyUYhWNvYT+WO8vCqqhSRR9
mczORHdFwEp6GcJD9iheLqNruQ1CrAdoPoot3zMWJlSSjjFbGfK6ZU9dn0iDryOZ
gXf3YFU4yGrcqKtblB8fHbpW0ZIMLPtYJb0Oza8skMKdjlMBlSg=
=rGtj
-----END PGP SIGNATURE-----

--=-52kbVxCF+8CnJXvXqmiD--

