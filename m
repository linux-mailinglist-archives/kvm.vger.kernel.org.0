Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45A1F37B0
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgFIKMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 06:12:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726286AbgFIKMR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 06:12:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 059A1wVu074043;
        Tue, 9 Jun 2020 06:11:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31huupw61h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 06:11:56 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 059A29iP075302;
        Tue, 9 Jun 2020 06:11:56 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31huupw60j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 06:11:55 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 059AAGCR024323;
        Tue, 9 Jun 2020 10:11:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 31g2s7taq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 10:11:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 059ABphK61079622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 10:11:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C2B5A4053;
        Tue,  9 Jun 2020 10:11:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57D2EA405B;
        Tue,  9 Jun 2020 10:11:50 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.129.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 10:11:50 +0000 (GMT)
Date:   Tue, 9 Jun 2020 12:11:05 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, dgilbert@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory
 protection
Message-ID: <20200609121105.50588db9.pasic@linux.ibm.com>
In-Reply-To: <20200606084409.GL228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <20200605125505.3fdd7de8.cohuck@redhat.com>
        <20200606084409.GL228651@umbus.fritz.box>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CoZk+LM8X6kReIB/IhxDgVN"; protocol="application/pgp-signature"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_03:2020-06-08,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/CoZk+LM8X6kReIB/IhxDgVN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jun 2020 18:44:09 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Fri, Jun 05, 2020 at 12:55:05PM +0200, Cornelia Huck wrote:
> > On Thu, 21 May 2020 13:42:46 +1000
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >=20
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > >=20
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > >=20
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > >=20
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > >=20
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "guest-memory-protection" property pointing to a platform specific
> > > object which configures and manages the specific details.
> > >=20
> > > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > > can be extended to cover the Intel and s390 mechanisms as well,
> > > though.
> >=20
> > For s390, there's the 'unpack' cpu facility bit, which is indicated iff
> > the kernel indicates availability of the feature (depending on hardware
> > support). If that cpu facility is available, a guest can choose to
> > transition into protected mode. The current state (protected mode or
> > not) is tracked in the s390 ccw machine.
> >=20
> > If I understand the series here correctly (I only did a quick
> > read-through), the user has to instruct QEMU to make protection
> > available, via a new machine property that links to an object?
>=20
> Correct.  We used to have basically the same model for POWER - the
> guest just talks to the ultravisor to enter secure mode.  But we
> realized that model is broken.  You're effectively advertising
> availability of a guest hardware feature based on host kernel or
> hardware properties.  That means if you try to migrate from a host
> with the facility to one without, you won't know there's a problem
> until too late.
>=20

Sorry, I don't quite understand the migration problem described here. If
you have this modeled via a CPU model facility, then you can't migrate
from a host with the facility to one without, except if the user
specified CPU model does not include the facility in question. Or am I
missing something?

Regards,
Halil

--Sig_/CoZk+LM8X6kReIB/IhxDgVN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJe32BkAAoJEA0vhuyXGx0A2kUP/3IWsX5UoEZG4KLEc6liNvYl
HmmJnWiDl2huRI52xTcakzydBggGxi1j1vb8e4s1C2sEL/2uqvbM8Tyi4intDGrb
Kw86lk66hj11hjQ4ix+Bi5Ow4EBE6RtUbzraFl3fjhxsOlSYQOLwkvGb9gDpkOM2
9BaHUGaWv6fxNoVZK+poGrHBnb8nGq2n1GhZc2bTalE8urH+/Fp0ufT4sTtE9del
jhPeR7338e7X44BC6mO1J+8gwiOcgy3EYRhfzfxeSLQr9cg/cRSiZCqZokqt53ok
c9ATeqAxJwR1/r0lA71nS3HY2s8zjw4GZA0ozKa4Rpac+2NDQVp04NXTktPvkN1c
y/UBDL5Qq1vQep1Rf+GLQk1Va0ajEkZShubrb6PmKKNidL4WTeJhdP1oKGU9rDUG
B+z0j2nylbCz9oSiYvh5FuUu4MIiTYQJS31yT85jajsFClIWKLkMWC0JrCvqUP2B
F8tTb3lI3xU5kHyuC/kA4OSDfI1rPS6gd64zU9VJjH7NlaVbYkYXZG9//PDXOt8z
/FG/j1l4TlqtPpiWdTKj9XfzsLRg9/+wyGcsX16nUJwhK6bk2yl71zbCVv8/QZ5L
CMSGx8occBo1lgFw1Q6squxO7EoosSa1KKlx1MdzavIwyqRCRok8d+wPGose/kd7
pKf6d5b6DYzBjpSdXo40
=ooSD
-----END PGP SIGNATURE-----

--Sig_/CoZk+LM8X6kReIB/IhxDgVN--

