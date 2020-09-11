Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EA7266372
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIKQQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:16:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgIKPbQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 11:31:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BDgNSv069419;
        Fri, 11 Sep 2020 09:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type; s=pp1; bh=TAjECWESllAlOomMZIFGVVsAc5NWFOWvghzfgEVEYYU=;
 b=pWIujJ2Ic6ohVoRrbenfL4/m+KGeXsJonp/YQuiYA/2zbr73cEh1K0/XkZuKoMJy7MFv
 f8aCZRz67SG5+oUFSMHc1Cooiy3IjxOUk6xrgJxOeRk2ZMBv50+L0xYUexaWV+V3UUGr
 BS2PfETEg5ULYHENP8SP8GELztBqyQLzM7/FcX4fEc+bbnQL10XgxBcc1Q1npdvBIJCL
 25zZtbkOiv5Kv9D9F2l/EItfrtSK7FSeGNT3xFfQVTBSjEpRcdT80slWXW40vN9gP4OE
 1nkepFTJFOCPN+liUerUmZ2a+IrfKX+J9OOag02ktNpPRPJJ3R0e2edL5fWF5uZPicbM Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33gabr074e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 09:49:51 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BDgcJr069967;
        Fri, 11 Sep 2020 09:49:50 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33gabr0737-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 09:49:50 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BDfuB8021472;
        Fri, 11 Sep 2020 13:49:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a8797m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 13:49:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BDnj2m21692810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 13:49:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C788EA405C;
        Fri, 11 Sep 2020 13:49:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B84F9A405B;
        Fri, 11 Sep 2020 13:49:44 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.148.109])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 13:49:44 +0000 (GMT)
Date:   Fri, 11 Sep 2020 15:49:27 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>
Subject: Re: [for-5.2 v4 09/10] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200911154927.7e9c205c.pasic@linux.ibm.com>
In-Reply-To: <20200911020442.GH66834@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-10-david@gibson.dropbear.id.au>
        <20200907171046.18211111.pasic@linux.ibm.com>
        <20200911020442.GH66834@yekko.fritz.box>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QP4pqatRr_SF8yFacXyZVo7"; protocol="application/pgp-signature"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_04:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/QP4pqatRr_SF8yFacXyZVo7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Sep 2020 12:04:42 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Mon, Sep 07, 2020 at 05:10:46PM +0200, Halil Pasic wrote:
> > On Fri, 24 Jul 2020 12:57:43 +1000
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >=20
> > > The default behaviour for virtio devices is not to use the platforms =
normal
> > > DMA paths, but instead to use the fact that it's running in a hypervi=
sor
> > > to directly access guest memory.  That doesn't work if the guest's me=
mory
> > > is protected from hypervisor access, such as with AMD's SEV or POWER'=
s PEF.
> > >=20
> > > So, if a host trust limitation mechanism is enabled, then apply the
> > > iommu_platform=3Don option so it will go through normal DMA mechanism=
s.
> > > Those will presumably have some way of marking memory as shared with =
the
> > > hypervisor or hardware so that DMA will work.
> >=20
> > Sorry for being this late. I had to do some high priority debugging,
> > which made me drop everything else, and after that I had some vacation.
> >=20
> > I have some questions about the bigger picture. The promised benefit of
> > this patch for users that invoke QEMU manually is relatively clear: it
> > alters the default value of some virtio properties, so that using the
> > defaults does not result in a bugous configuration.
>=20
> Right.
>=20
> > This comes at a price. I used to think of device property default values
> > like this. If I don't specify it and I use the default machine, I will
> > effectively get the the default value of of the property (as reported by
> > qemu -device dev-name,?). If I use a compat machine, then I will get the
> > compatibility default value: i.e. the what is reported as the default
> > value, if I invoke the binary whose default machine is my compat machin=
e.
>=20
> Hm, ok.  My mental model has always been that defaults were
> essentially per-machine-type.  Which, I grant you isn't really
> consistent with the existence of the -device dev,? probing.  On the
> other hand, it's possible for a machine/platforms to impose
> restrictions on almost any property of almost any device, and it would
> suck for the user to have to know all of them just in order to start
> things up with default options.
>=20
> Given that model, extending that to per-machine-variant, including
> machine options like htl seemed natural.
>=20

Yesterday I got some more education on the matters of Libvirt by Boris.
I think now we both agree that this complicates the mental model, but
that it simplifies usage, and is worth it.

> > With this patch, that reasoning is not valid any more. Did we do
> > something like this before, or is this the first time we introduce this
> > complication?
>=20
> I don't know off hand if we have per-machine differences for certain
> options in practice, or only in theory.
>=20
> > In any case, I suppose, this change needs a documentation update, which=
 I
> > could not find in the series.
>=20
> Uh.. fair enough.. I just need to figure out where.
>=20
> > How are things supposed to pan out when QEMU is used with management
> > software?
> >=20
> > I was told that libvirt's policy is to be explicit and not let QEMU use
> > defaults. But this policy does not seem to apply to iommu_platform -- at
> > least not on s390x. Why is this? Is this likely to change in the future?
>=20
> Ugh.. so.  That policy of libvirt's is very double edged.  It's there
> because it allows libvirt to create consistent machines that can be
> migrated properly and so forth.  However, it basically locks libvirt
> into having to know about every option of qemu, ever.  Unsurprisingly
> there are some gaps, hence things like this.
>=20
> Unfortunately that can't be fixed without substantially redesigning
> libvirt in a way that can't maintain compatibility.
>=20

Boris told me that virtio properties are a notable exception from the
aforementioned Libvirt rule. He showed me the code, and libvirt seems to
be intentionally non-explicit on iommu and other virtio properties, in a
sense that if nothing is specified in the xml, nothing is specified on
the generated command line, and we get the default. Unfortunately, we
didn't manage to figure out the reason.

> > Furthermore, the libvirt documentation is IMHO not that great when it
> > comes to iommu_platform. All I've found is=20
> >=20
> > """
> > Virtio-related options
> >=20
> >=20
> > QEMU's virtio devices have some attributes related to the virtio transp=
ort under the driver element: The iommu attribute enables the use of emulat=
ed IOMMU by the device.=20
> > """
> >=20
> > which:
> > * Is not explicit about the default, but suggests that default is off
> >   (because it needs to be enabled), which would reflect the current sta=
te
> >   of affairs (without this patch).
> > * Makes me wonder, to what extent does the libvirt concept correspond
> >   to the virtio semantics of _F_ACCESS_PLATFORM. I.e. we don't really
> >   do any IOMMU emulation with virtio-ccw.
> >=20
> > I guess host trust limitation is something that is to be expressed in
> > libvirt, or? Do we have a design for that?
>=20
> Yeah, I guess we'd need to.  See "having to know about every option"
> above :/.  No, I haven't thought about a design for that.
>=20
> > I was also reflecting on how does this patch compare to on/off/auto, but
> > this email is already too long, so decided keep my thoughts for myself
> > -- for now.
>=20
> on/off/auto works for your case on s390, but I don't think it works
> for POWER, though I forget the details, so maybe I'm wrong about that.
>=20

If management software/libvirt will let us use the defaults, I see this
patch as a big usability improvement. Thus

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

I believe on/off/auto could work for POWER as well, just not the way I
intended it to work for s390, which is basically changing the value as
we transition the plain VM to a PV VM.

I see a potential semantic benefit to on/off/auto, compared to some
machine properties affecting the default value of some device properties.

The semantic I would like to have for on/off/auto seems to be a bit
different than the semantic the community seems to associate with auto
right now.

What I would like to have is a 'be as intelligent about it as you can'
type of 'auto'. Let me bring some examples outside QEMU. For instance
the intel_gpu_frequency tool lets one lock the GPU frequency to certain
values
(http://manpages.ubuntu.com/manpages/xenial/man1/intel_gpu_frequency.1.html=
).
I guess there are scenarios where that can be useful. But for normal
usage, I guess both for CPU and GPU frequency the user does not want to
have a rigid value, but it expects the system to balance the trade-offs
and tweak the frequency according to the current situation.

So in by book, auto would allow libvirt and the user to be explicit
about not wanting to control that aspect of the VM, and QEMU to step
beyond 'sane defaults'.

The current semantics of auto seems to be: if you specify auto you may
end up with something different that if you specify default, possibly
based on some environment considerations, but the 'auto' seems to be
resolved to 'on' or 'off' once, and (it seems preferably) at
initialization time.

Given all that, I'm pretty happy with your current solution. Doing
on/off/auto and resolving 'auto' based on host_trust_limitation_enabled()=20
would IMHO not be much different from your current solution, so I see no
big benefit to that. Maybe a tad cleaner UI, but more code, and more
complicated initialization interdependency (we would need to have
host_trust_limitation_enabled() armed when we resolve iommu_platform,
don't know if that's natural).

Regards,
Halil


--Sig_/QP4pqatRr_SF8yFacXyZVo7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJfW4B2AAoJEA0vhuyXGx0ALvQQANLUKHk+jerLOxj7N7eCxeGJ
vXhbT89rjoKKccreSy4jwf5+KheeGByYlqViitpMfRgFuXtsafyRcHs+MeWW/k+o
zDhTy+LZAHcxC8/kjxxbHpRh+FKGQbk5Btllu2CF4Sx/EGMbaDsp45pnklAXb3PQ
WskCiE+fLd5S3IN4VoXG/QeZa9Rz4V1fyj7N1JYDtzNMytQW8sF1WWco9kO/5gEW
cGbaHNJ0KZ70PrdoFM4uQKMU4bjGLaXRJbk0+y/2FovBXFoyx6ibz/4UAOQl4nxF
iqkmh7Kys6R9ugQPubBt5DY0aRgPoUw4lNysqsdvGv3Uk5WtmdAlk0J3zT9eTf7R
bHrk6Zy53hYVnlfBpNMOFKD9yqNngl/MKnTfmb4eDG0MPQpSHhhkukt544lvzuQw
x3Cvmha0UWXXjFcRZ/wvY7sCLsfsYpzvBRHf/IvwsZ+M21D0LXfFk4EN/R/Dmr1W
eO9ZaZFQBlG0u7krmHWOo+g2YWkKhW2NRmOY2zGShvlCPpteUVE6FD6Jy7K7+i8M
4e+UQsz1ca6tMeFOYZgkJLImll8+geghoRorzK5t668aUkA1QFFWwiMiG9r2cxc2
IYcJpBj7FiiDuPAz0iGgZ6KCoxjPP7V8plMDEd6zbUtQAdJcs26VqIiDwGk5a6nC
85quUnQ4XqWwRmM4V/jI
=5sX3
-----END PGP SIGNATURE-----

--Sig_/QP4pqatRr_SF8yFacXyZVo7--

