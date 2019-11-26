Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227F410A39B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 18:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKZRyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 12:54:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21988 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbfKZRyL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Nov 2019 12:54:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQHruoL164556;
        Tue, 26 Nov 2019 12:54:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wf0f89tu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 12:54:06 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAQHs34J165159;
        Tue, 26 Nov 2019 12:54:03 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wf0f89tsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 12:54:03 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAQHoStJ006855;
        Tue, 26 Nov 2019 17:54:02 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2wevd6mkbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 17:54:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAQHs1Rb44761562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 17:54:01 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8273112064;
        Tue, 26 Nov 2019 17:54:01 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C537112061;
        Tue, 26 Nov 2019 17:54:00 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Nov 2019 17:54:00 +0000 (GMT)
Message-ID: <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Nov 2019 14:53:59 -0300
In-Reply-To: <20191126171416.GA22233@linux.intel.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
         <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-idWXaYDfYe+W0o1IqKu9"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_05:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-idWXaYDfYe+W0o1IqKu9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-26 at 09:14 -0800, Sean Christopherson wrote:
> On Tue, Nov 26, 2019 at 01:44:14PM -0300, Leonardo Bras wrote:
> > On Mon, 2019-10-21 at 15:58 -0700, Sean Christopherson wrote:
>=20
> ...
>=20
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 67ef3f2e19e8..b8534c6b8cf6 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -772,6 +772,18 @@ void kvm_put_kvm(struct kvm *kvm)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_put_kvm);
> > >=20
> > > +/*
> > > + * Used to put a reference that was taken on behalf of an object
> > > associated
> > > + * with a user-visible file descriptor, e.g. a vcpu or device,
> > > if installation
> > > + * of the new file descriptor fails and the reference cannot be
> > > transferred to
> > > + * its final owner.  In such cases, the caller is still actively
> > > using @kvm and
> > > + * will fail miserably if the refcount unexpectedly hits zero.
> > > + */
> > > +void kvm_put_kvm_no_destroy(struct kvm *kvm)
> > > +{
> > > +	WARN_ON(refcount_dec_and_test(&kvm->users_count));
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
> > >=20
> > >  static int kvm_vm_release(struct inode *inode, struct file
> > > *filp)
> > >  {
> > > @@ -2679,7 +2691,7 @@ static int kvm_vm_ioctl_create_vcpu(struct
> > > kvm
> > > *kvm, u32 id)
> > >  	kvm_get_kvm(kvm);
> > >  	r =3D create_vcpu_fd(vcpu);
> > >  	if (r < 0) {
> > > -		kvm_put_kvm(kvm);
> > > +		kvm_put_kvm_no_destroy(kvm);
> > >  		goto unlock_vcpu_destroy;
> > >  	}
> > >=20
> > > @@ -3117,7 +3129,7 @@ static int kvm_ioctl_create_device(struct
> > > kvm
> > > *kvm,
> > >  	kvm_get_kvm(kvm);
> > >  	ret =3D anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR
> > > > O_CLOEXEC);
> > >  	if (ret < 0) {
> > > -		kvm_put_kvm(kvm);
> > > +		kvm_put_kvm_no_destroy(kvm);
> > >  		mutex_lock(&kvm->lock);
> > >  		list_del(&dev->vm_node);
> > >  		mutex_unlock(&kvm->lock);
> >=20
> > Hello,
> >=20
> > I see what are you solving here, but would not this behavior cause
> > the
> > refcount to reach negative values?
> >=20
> > If so, is not there a problem? I mean, in some archs (powerpc
> > included)
> > refcount_dec_and_test() will decrement and then test if the value
> > is
> > equal 0. If we ever reach a negative value, this will cause that
> > memory
> > to never be released.=20
> >=20
> > An example is that refcount_dec_and_test(), on other archs than
> > x86,
> > will call atomic_dec_and_test(), which on include/linux/atomic-
> > fallback.h will do:
> >=20
> > return atomic_dec_return(v) =3D=3D 0;
> >=20
> > To change this behavior, it would mean change the whole
> > atomic_*_test
> > behavior, or do a copy function in order to change this '=3D=3D 0' to=
=20
> > '<=3D 0'.=20
> >=20
> > Does it make sense? Do you need any help on this?
>=20
> I don't think so.  refcount_dec_and_test() will WARN on an underflow
> when
> the kernel is built with CONFIG_REFCOUNT_FULL=3Dy.  I see no value in
> duplicating those sanity checks in KVM.
>=20
> This new helper and WARN is to explicitly catch @users_count
> unexpectedly
> hitting zero, which is orthogonal to an underflow (although odds are
> good
> that a bug that triggers the WARN in kvm_put_kvm_no_destroy() will
> also
> lead to an underflow).  Leaking the memory is deliberate as the
> alternative
> is a guaranteed use-after-free, i.e. kvm_put_kvm_no_destroy() is
> intended
> to be used when users_count is guaranteed to be valid after it is
> decremented.


I agree an use-after-free more problem than a memory leak, but I think
that there is a way to solve this without leaking the memory also.

One option would be reordering the kvm_put_kvm(), like in this patch:
https://lkml.org/lkml/2019/11/26/517

And the other would be creating a new atomic operation that checks if
the counter is less than zero:

atomic_dec_and_test_negative(atomic_t *v)
{
	return atomic_dec_return(v) <=3D 0;
}=20

And apply it to generic refcount.

Do you think that would work?

Best regards,

Leonardo Bras

--=-idWXaYDfYe+W0o1IqKu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3dZrcACgkQlQYWtz9S
ttQzNg/+NwFWS0Z2zks2F8xdJJ0gpjjxdtntNMare2JzrS1nYbtjNcbVphDlczKl
IdWKkjdZqS7AwqkcXcCVFWnSdMdHs+B3AAQz4FncjZQag5NLy+pmUJ9mlTf+LB7V
IFmyqTrqGCCxA3VXfVP3qJzOxHRZWu2L/1v8dtzbi95+oqqpHd8GKByctTujoRS+
vcS3nMRaXW71/acTNWQa0bEjtMFTrBNO3o9qlOejor3nQUaS1xb3HiiPSc1pZcYr
LInWHiiKsMzu/yZYg3s48Q8zNel6CkJ/MNrxwohR3A7SjYyvkxxP5SR6uc4Tb03V
dnXcV0z1dzWG6GSy9K9Pg5Q1SdY+gELKngZrVC9zXGw6rXkVimX0LLDFeDznISz5
ljedofj2m7YExs4zo9K267YbNiTz5ZzHsom0OiKZzNrXNEBJTCcjwCpdcdA8I+Lt
qHnl7CcHYqfnOY3bRSG1iBcX1kmpOHWRfBHw7GHqCDAyw/Hxls6KVqid/C5nzx+j
ipQZddMtqC7cpwKpngQ/XErx7yvAlq390AjjMuZnxTK8vOWmrtjTU1V+zqt4TUwK
O0equPiTbfImxBgk2HzxdplmKszkhV85ECCt67s3mnODCqbq2EBuTYpBl5AG5f5C
3BzZ6i/9Vspyz4mPQ6TNY9cIQ1NJIzMCZW7vzoiF9gH10UepuZg=
=FgOf
-----END PGP SIGNATURE-----

--=-idWXaYDfYe+W0o1IqKu9--

