Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAACD10B747
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 21:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfK0UQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 15:16:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbfK0UQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 15:16:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARKETLf050565;
        Wed, 27 Nov 2019 15:16:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whhyg0pu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 15:16:06 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xARKEowR051905;
        Wed, 27 Nov 2019 15:16:06 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whhyg0ptk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 15:16:06 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xARKFC8u025883;
        Wed, 27 Nov 2019 20:16:05 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 2wevd7ftg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 20:16:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xARKG4r848300504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 20:16:04 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92E05AE05C;
        Wed, 27 Nov 2019 20:16:04 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 750E5AE062;
        Wed, 27 Nov 2019 20:16:03 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Nov 2019 20:16:03 +0000 (GMT)
Message-ID: <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 27 Nov 2019 17:15:59 -0300
In-Reply-To: <20191127194757.GI22227@linux.intel.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
         <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
         <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
         <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
         <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
         <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
         <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
         <20191127194757.GI22227@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xFrapZw7GF6R9331NkVz"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=2
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-xFrapZw7GF6R9331NkVz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 11:47 -0800, Sean Christopherson wrote:
> On Wed, Nov 27, 2019 at 04:25:55PM -0300, Leonardo Bras wrote:
> > On Wed, 2019-11-27 at 19:32 +0100, Paolo Bonzini wrote:
> > > On 27/11/19 19:24, Leonardo Bras wrote:
> > > > By what I could undestand up to now, these functions that use borro=
wed
> > > > references can only be called while the reference (file descriptor)
> > > > exists.=20
> > > > So, suppose these threads, where:
> > > > - T1 uses a borrowed reference, and=20
> > > > - T2 is releasing the reference (close, release):
> > >=20
> > > Nit: T2 is releasing the *last* reference (as implied by your referen=
ce
> > > to close/release).
> >=20
> > Correct.
> >=20
> > > > T1				| T2
> > > > kvm_get_kvm()			|
> > > > ...				| kvm_put_kvm()
> > > > kvm_put_kvm_no_destroy()	|
> > > >=20
> > > > The above would not trigger a use-after-free bug, but will cause a
> > > > memory leak. Is my above understanding right?
> > >=20
> > > Yes, this is correct.
> > >=20
> >=20
> > Then, what would not be a bug before (using kvm_put_kvm()) now is a
> > memory leak (using kvm_put_kvm_no_destroy()).
>=20
> No, using kvm_put_kvm_no_destroy() changes how a bug would manifest, as
> you note below.  Replacing kvm_put_kvm() with kvm_put_kvm_no_destroy()
> when the refcount is _guaranteed_ to be >1 has no impact on correctness.
>=20

Humm, so what about the above example with T1 and T2?


> > And it's the price to avoid use-after-free on other cases, which is a
> > worse bug. Ok, I get it.=20
> >=20
> > > Paolo
> >=20
> > On Tue, 2019-11-26 at 10:14 -0800, Sean Christopherson wrote:
> > > If one these kvm_put_kvm() calls did unexpectedly free @kvm (due to=
=20
> > > a bug somewhere else), KVM would still hit a use-after-free scenario=
=20
> > > as the caller still thinks @kvm is valid.  Currently, this would=20
> > > only happen on a subsequent ioctl() on the caller's file descriptor
> > > (which holds a pointer to @kvm), as the callers of these functions
> > > don't directly dereference @kvm after the functions return.  But,=20
> > > not deferencing @kvm isn't deliberate or functionally required, it's
> > > just how the code happens to be written.
> >=20
> > So, testing if the kvm reference is valid before running ioctl would be
> > enough to avoid these bugs?
>=20
> No, the only way to avoid use-after-free bugs of this nature is to not
> screw up the refcounting :-)  This funky "borrowed reference" pattern is
> not very common.  It's necessary here because KVM needs to take an extra
> reference to itself on behalf of the child device before installing the
> child's file descriptor, because once the fd is installed it can be
> closed by userspace and free the child's reference.  The error path,
> which uses kvm_put_kvm_no_destroy(), is used if and only if installing
> the fd fails, in which case the extra reference is deliberately thrown
> away.
>=20
> kvm_put_kvm_no_destroy() is asserting "N > 0" as a way to detect a
> refcounting bug that wouldn't be detected (until later) by the normal
> refcounting behavior, which asserts "N >=3D 0".
>=20
> > Is it possible?=20
>=20
> No.  Similar to above, userspace gets a fd by doing open("/dev/kvm"), and
> the semantics of KVM are such that each fd is a reference to KVM. From
> userspace's perspective, having a valid fd *is* how it knows that it has
> a valid KVM reference.
>=20
> > Humm, but if it frees kvm before running ->release(), would it mean the
> > VM is destroyed incorrectly, and will probably crash?
>=20
> More than likely the host will crash due to corrupting memory.  The guest
> will crash too, but that's a secondary concern.

Thanks for explaining, it's way more clear to me now how it works.

Best regards,

Leonardo Bras

--=-xFrapZw7GF6R9331NkVz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3e2X8ACgkQlQYWtz9S
ttSG7g//VqqPgAPZk9jWggp9bgypwMSgoU431QmrRpqZZcoUotfNp05aDaR6r7EU
8N0ZoMsWz1fgAqQO4zWZcO9cg6UQ+KRu1p7zL3C125DAWMUVHTC1nrpZDQkrWdg+
LeYaplyQg9je7zXLRfGJEP7Mqn4PuhTTFdZL7kgyu6fsBmiQAUB2eSqusDjTrtNv
AUaHoVPBXzodTdqnHyM9G3Szl4mIEC3UAP6M8a3BzE1/fsY/1LCiamd5iMSFXcHy
v0K8TS3wUKUAtARhj/xvzpwMcEnhUWbl0AlnUROpcvhWtf3iGfhab/IM8+NUZHAR
WVRSiirKi6rjY1Mmx1DMwSCbLS/skS1wbNeP9A4FdnbaNIusGhF4lm1sCbNMSm5P
xn+sUmLcfumxavG2yFBIcbLqK3ZS8L7MDiyx5g05RG8hCsc1olpmGMvObLctqP8E
QxgMCL1lbGvSSgANWrf872xR4Tzl95B2FmKn6rzKtENihvguJsrMH/3TXDnc5PYo
shFMM/w3NF2LKOgF4TTMAov05FTyebYhryQD9CUMYhjwvFiqeesMdKVsdiNJIVDH
uR+qklXfM18bDhDiEd1fNPl0lenuR4Ws7P+4iaKDWWqnJgJW93rCBt4U77cVZ9Xg
BTqQTs8NsUcfuDPvxDctqWbHCM2yBt9y6r0Ld8nps+jzPbxCuc0=
=zqVw
-----END PGP SIGNATURE-----

--=-xFrapZw7GF6R9331NkVz--

