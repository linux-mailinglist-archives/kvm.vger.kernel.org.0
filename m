Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECF10B6AE
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 20:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfK0T0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 14:26:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbfK0T0M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 14:26:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARJH9IB172675;
        Wed, 27 Nov 2019 14:26:02 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2whcxppxh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 14:26:02 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xARJKBqU179923;
        Wed, 27 Nov 2019 14:26:02 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2whcxppxgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 14:26:02 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xARJPIHD009108;
        Wed, 27 Nov 2019 19:26:06 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2wevd6fge3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 19:26:06 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xARJQ17V51053022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 19:26:01 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BD72AE05F;
        Wed, 27 Nov 2019 19:26:01 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F8D9AE05C;
        Wed, 27 Nov 2019 19:26:00 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Nov 2019 19:25:59 +0000 (GMT)
Message-ID: <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 27 Nov 2019 16:25:55 -0300
In-Reply-To: <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
         <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
         <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
         <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
         <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
         <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-a9kzp034ppH43UyepBK6"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 suspectscore=2 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=779 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911270157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-a9kzp034ppH43UyepBK6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 19:32 +0100, Paolo Bonzini wrote:
> On 27/11/19 19:24, Leonardo Bras wrote:
> > By what I could undestand up to now, these functions that use borrowed
> > references can only be called while the reference (file descriptor)
> > exists.=20
> > So, suppose these threads, where:
> > - T1 uses a borrowed reference, and=20
> > - T2 is releasing the reference (close, release):
>=20
> Nit: T2 is releasing the *last* reference (as implied by your reference
> to close/release).

Correct.

>=20
> > T1				| T2
> > kvm_get_kvm()			|
> > ...				| kvm_put_kvm()
> > kvm_put_kvm_no_destroy()	|
> >=20
> > The above would not trigger a use-after-free bug, but will cause a
> > memory leak. Is my above understanding right?
>=20
> Yes, this is correct.
>=20

Then, what would not be a bug before (using kvm_put_kvm()) now is a
memory leak (using kvm_put_kvm_no_destroy()).

And it's the price to avoid use-after-free on other cases, which is a
worse bug. Ok, I get it.=20

> Paolo

On Tue, 2019-11-26 at 10:14 -0800, Sean Christopherson wrote:
> If one these kvm_put_kvm() calls did unexpectedly free @kvm (due to=20
> a bug somewhere else), KVM would still hit a use-after-free scenario=20
> as the caller still thinks @kvm is valid.  Currently, this would=20
> only happen on a subsequent ioctl() on the caller's file descriptor
> (which holds a pointer to @kvm), as the callers of these functions
> don't directly dereference @kvm after the functions return.  But,=20
> not deferencing @kvm isn't deliberate or functionally required, it's
> just how the code happens to be written.

So, testing if the kvm reference is valid before running ioctl would be
enough to avoid these bugs? Is it possible?=20

Humm, but if it frees kvm before running ->release(), would it mean the
VM is destroyed incorrectly, and will probably crash?

Thanks for the patience,

Leonardo=20





--=-a9kzp034ppH43UyepBK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3ezcMACgkQlQYWtz9S
ttQQBw//fTReHUPDTqQ3dhlnVQc6KZ76CgG2P0n8wJYLoD1w8pnrynqmlniGaIQ6
qcp+epmXKdexJ0dJm3LI8qKcOKVdQaflyUz7Krlko++aAPpO9eoJSH36wocXVfvI
v1n9GCaPstG4b8sPGvdZ+pKiIwnNoG6Z137zM1EbK8GmpfXcYfJhvHx7alvPd+E6
bKoAqlHrzsQk+wWpy9rj8PCB1q2aqE6/vVFYex2dBlQiprPwJcuoVxOeaR+t3S8q
6MuDRJZvo3PXdMXFzrUhabjIWdYz7G59f7lA8wibgdtLfQyDVx0ELwcIBgaIhgTt
2kqepMwa6D5YuSIDM2ZfF/yN/wvvNCDvSHHZexknY4Q2bisVMi8gB9DsRwqYv7aM
h1NhqxgqMjdwjBeb10hqfT7wmlny8CqTYCZYiIprnDajw5cSyV9orrKg4VknfszN
Rks2XwvyFqdu68Z6iWVml2cq3R7DuiE5JnHs3vqWP14SLlsMHJS/NC9HzTYHzEhq
2ECnt2k9g2mdL2KSG/5urNJpL3UJ0m7is/+NG3k70Cml0eL7qcBYvJGh8opHXnP5
24kOpjSWNtcLKOH3o+cDVF8g+LEQiebFzKFyIkUclhZQ+l1n2vbe9JvdPcfhvmRz
5QiAnqjECEPCwj4Fq+EDjvTOd3tFcR72H4frypRpIPrGj4Uasf4=
=AJN6
-----END PGP SIGNATURE-----

--=-a9kzp034ppH43UyepBK6--

