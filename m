Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107B5210AAC
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgGAMA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 08:00:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730133AbgGAMA0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 08:00:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061BVOVN123781;
        Wed, 1 Jul 2020 07:59:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8assag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jul 2020 07:59:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 061BWWqW128662;
        Wed, 1 Jul 2020 07:59:54 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8ass9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jul 2020 07:59:53 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 061BwXBM003895;
        Wed, 1 Jul 2020 11:59:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 31wwr8a95k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jul 2020 11:59:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 061BxnJh786834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jul 2020 11:59:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDD8FA4062;
        Wed,  1 Jul 2020 11:59:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3F3AA405C;
        Wed,  1 Jul 2020 11:59:47 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.149.130])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Jul 2020 11:59:47 +0000 (GMT)
Date:   Wed, 1 Jul 2020 13:59:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
        mdroth@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200701135930.3d8bb1dc.pasic@linux.ibm.com>
In-Reply-To: <02a4d0c2-0009-470c-274f-d57bad5e063a@linux.ibm.com>
References: <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
        <20200622140254.0dbe5d8c.cohuck@redhat.com>
        <20200625052518.GD172395@umbus.fritz.box>
        <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
        <20200626044259.GK172395@umbus.fritz.box>
        <892533f8-cd3c-e282-58c2-4212eb3a84b8@redhat.com>
        <a3c05575-6fb2-8d1b-f6d9-2eabf3f4082d@linux.ibm.com>
        <20200626093257.GC1028934@redhat.com>
        <558e8978-01ba-d8e8-9986-15efbbcbca96@linux.ibm.com>
        <20200626102903.GD3087@work-vm>
        <20200626105846.GF1028934@redhat.com>
        <02a4d0c2-0009-470c-274f-d57bad5e063a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/We5mDa4tzwsjBOZY1NGd6NI"; protocol="application/pgp-signature"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_07:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 cotscore=-2147483648 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007010082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/We5mDa4tzwsjBOZY1NGd6NI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jun 2020 14:49:37 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/26/20 12:58 PM, Daniel P. Berrang=C3=A9 wrote:
> > On Fri, Jun 26, 2020 at 11:29:03AM +0100, Dr. David Alan Gilbert wrote:
> >> * Janosch Frank (frankja@linux.ibm.com) wrote:
> >>> On 6/26/20 11:32 AM, Daniel P. Berrang=C3=83=C2=A9 wrote:
> >>>> On Fri, Jun 26, 2020 at 11:01:58AM +0200, Janosch Frank wrote:
> >>>>> On 6/26/20 8:53 AM, David Hildenbrand wrote:
> >>>>>>>>>> Does this have any implications when probing with the 'none' m=
achine?
> >>>>>>>>>
> >>>>>>>>> I'm not sure.  In your case, I guess the cpu bit would still sh=
ow up
> >>>>>>>>> as before, so it would tell you base feature availability, but =
not
> >>>>>>>>> whether you can use the new configuration option.
> >>>>>>>>>
> >>>>>>>>> Since the HTL option is generic, you could still set it on the =
"none"
> >>>>>>>>> machine, though it wouldn't really have any effect.  That is, i=
f you
> >>>>>>>>> could create a suitable object to point it at, which would depe=
nd on
> >>>>>>>>> ... details.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> The important point is that we never want the (expanded) host cp=
u model
> >>>>>>>> look different when either specifying or not specifying the HTL
> >>>>>>>> property.
> >>>>>>>
> >>>>>>> Ah, yes, I see your point.  So my current suggestion will satisfy
> >>>>>>> that, basically it is:
> >>>>>>>
> >>>>>>> cpu has unpack (inc. by default) && htl specified
> >>>>>>> 	=3D> works (allowing secure), as expected
> >>>>>>
> >>>>>> ack
> >>>>>>
> >>>>>>>
> >>>>>>> !cpu has unpack && htl specified
> >>>>>>> 	=3D> bails out with an error
> >>>>>>
> >>>>>> ack
> >>>>>>
> >>>>>>>
> >>>>>>> !cpu has unpack && !htl specified
> >>>>>>> 	=3D> works for a non-secure guest, as expected
> >>>>>>> 	=3D> guest will fail if it attempts to go secure
> >>>>>>
> >>>>>> ack, behavior just like running on older hw without unpack
> >>>>>>
> >>>>>>>
> >>>>>>> cpu has unpack && !htl specified
> >>>>>>> 	=3D> works as expected for a non-secure guest (unpack feature is
> >>>>>>> 	   present, but unused)
> >>>>>>> 	=3D> secure guest may work "by accident", but only if all virtio
> >>>>>>> 	   properties have the right values, which is the user's
> >>>>>>> 	   problem
> >>>>>>>
> >>>>>>> That last case is kinda ugly, but I think it's tolerable.
> >>>>>>
> >>>>>> Right, we must not affect non-secure guests, and existing secure s=
etups
> >>>>>> (e.g., older qemu machines). Will have to think about this some mo=
re,
> >>>>>> but does not sound too crazy.
> >>>>>
> >>>>> I severely dislike having to specify things to make PV work.
> >>>>> The IOMMU is already a thorn in our side and we're working on makin=
g the
> >>>>> whole ordeal completely transparent so the only requirement to make=
 this
> >>>>> work is the right machine, kernel, qemu and kernel cmd line option
> >>>>> "prot_virt=3D1". That's why we do the reboot into PV mode in the fi=
rst place.
> >>>>>
> >>>>> I.e. the goal is that if customers convert compatible guests into
> >>>>> protected ones and start them up on a z15 on a distro with PV suppo=
rt
> >>>>> they can just use the guest without having to change XML or command=
 line
> >>>>> parameters.
> >>>>
> >>>> If you're exposing new features to the guest machine, then it is usu=
ally
> >>>> to be expected that XML and QEMU command line will change. Some simp=
le
> >>>> things might be hidable behind a new QEMU machine type or CPU model,=
 but
> >>>> there's a limit to how much should be hidden that way while staying =
sane.
> >>>>
> >>>> I'd really expect the configuration to change when switching a guest=
 to
> >>>> a new hardware platform and wanting major new functionality to be en=
abled.
> >>>> The XML / QEMU config is a low level instantiation of a particular f=
eature
> >>>> set, optimized for a specific machine, rather than a high level desc=
ription
> >>>> of ideal "best" config independent of host machine.
> >>>
> >>> You still have to set the host command line and make sure that unpack=
 is
> >>> available. Currently you also have to specify the IOMMU which we like=
 to
> >>> drop as a requirement. Everything else is dependent on runtime
> >>> information which tells us if we need to take a PV or non-PV branch.
> >>> Having the unpack facility should be enough to use the unpack facilit=
y.
> >>>
> >>> Keep in mind that we have no real concept of a special protected VM to
> >>> begin with. If the VM never boots into a protected kernel it will nev=
er
> >>> be protected. On a reboot it drops from protected into unprotected mo=
de
> >>> to execute the bios and boot loader and then may or may not move back
> >>> into a protected state.
> >>
> >> My worry isn't actually how painful adding all the iommu glue is, but
> >> what happens when users forget; especially if they forget for one
> >> device.
> >>
> >> I could appreciate having a machine option to cause iommu to then get
> >> turned on with all other devices; but I think also we could do with
> >> something that failed with a nice error if an iommu flag was missing.
> >> For SEV this could be done pretty early, but for power/s390 I guess
> >> you'd have to do this when someone tried to enable secure mode, but
> >> I'm not sure you can tell.
> >=20
> > What is the cost / downside of turning on the iommu option for virtio
> > devices ? Is it something that is reasonable for a mgmt app todo
> > unconditionally, regardless of whether memory encryption is in use,
> > or will that have a negative impact on things ?
>=20
> speed, memory usage and compatibility problems.
> There might also be a problem with s390 having to use <=3D2GB iommu areas
> in the guest, I need to check with Halil if this is still true.

It is partially true. The coherent_dma_mask is 31 bit and the dma_mask
is 64. That means if iommu=3Don but !PV the coherent stuff will use <=3D 2GB
(that stuff allocated by virtio core, like virtqueues, CCWs, etc.) but
there will be no bounce buffering. We don't even initialize swiotlb if
!PV.

I agree with Janosch, we want iommu=3D'on' only when really needed. I've
tried to make that point several times.

Regards,
Halil

>=20
> Also, if the default or specified IOMMU buffer size isn't big enough for
> your IO workload the guest is gonna have a very bad time. I.e. if
> somebody has an alternative implementation of bounce buffers we'd be
> happy to take it :)
>=20
> >=20
> > Regards,
> > Daniel
> >=20
>=20
>=20


--Sig_/We5mDa4tzwsjBOZY1NGd6NI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJe/HqyAAoJEA0vhuyXGx0AZSYP/2lWCdWbDLKx2N/r+FgqRVGC
LZcERHnBp+uOH39T8+P9KmIjkiJCHYdfFXBOME9gbeM/+3EGMxVwtQ1iUmrjZtug
4b/a3DfTC2cot1o+thatRO9H/sq29jFLHH1+pF58YqnBsY6eucRu0OER+tl2Jew6
u9gMqRiZ4Y5n7292GrLNOsv1/RNOAjswTSxIZl0WiFn3QccUa2P8OcPub5kFIvdO
q9Es0wqTSJQ+VhwUVmGTviziNQ3AKViMeYhUYvP40xt8JEddLLPCsoNzC3BkWRxX
IN9zLrKXtmqvbafFnQOiRxM3GHZJkFKzUyn/SDCSU5sWyvxzhDt9yRfnthP7qV2z
msH6Fhb3DeCyygttT6gR87VXKPfQD9K+RF/C+JknKDvhR9UngO65RotxMgMB682p
bgSBu/ZNQyjiWsMe182rQ2tNECPDMWiI4uH9Zy2G5uegbfgd47g0mlfCJKbuQ6pO
Z3ESyl+x0mJPKeclkZ1nDiF6x2XQrQZYqy3RtYq3l1iJCPcZFIj9tbhrclb8doru
lwAZexBTwrVdIwaqqxVJGSPKxnabivF8UMtxF0Tv+SIUhoeevyj3OrPn+Sj1Amuw
tw7vO1qvQN87QoLXjelpF0lSVf4ruQif27jMgNOIJe6eLUVyuiu8QpjlfZFRTBki
3ZgT5MkbrRJAz/COefpi
=Cp3K
-----END PGP SIGNATURE-----

--Sig_/We5mDa4tzwsjBOZY1NGd6NI--

