Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46EC75FD6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 09:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZH31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 03:29:27 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34417 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfGZH31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 03:29:27 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 45w11J3h8Bz9sMQ; Fri, 26 Jul 2019 17:29:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1564126164;
        bh=JUajiAa7S0x82VcrOnFR99fgStWmrqETSqVlkjY5W3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bf6J+Fdn+egiGe4vfDRdgA0vtDmBPXk6Be427QaWwIv9CIT6nZR8YVDGVNpSHL1qF
         ZPqY+YPBJwIAlJ5Lw9Nq5KQqTSgoMHC6kgXUxMPlW9w4sGE4VrL1Rqc5S56fYy7Z6N
         1EjV8krXF2srwROE9Gic0xEFOesOMhSlqViqj2ro=
Date:   Thu, 25 Jul 2019 13:40:17 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Message-ID: <20190725034017.GF28601@umbus>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
 <20190715025519.GE3440@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A00D8BB@SHSMSX104.ccr.corp.intel.com>
 <20190717030640.GG9123@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A0140E0@SHSMSX104.ccr.corp.intel.com>
 <20190723035741.GR25073@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A0160C9@SHSMSX104.ccr.corp.intel.com>
 <abf336b6-4c51-7742-44aa-5b51c8ea4af7@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <abf336b6-4c51-7742-44aa-5b51c8ea4af7@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2019 at 11:33:06AM +0200, Auger Eric wrote:
> Hi Yi, David,
>=20
> On 7/24/19 6:57 AM, Liu, Yi L wrote:
> >> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On =
Behalf
> >> Of David Gibson
> >> Sent: Tuesday, July 23, 2019 11:58 AM
> >> To: Liu, Yi L <yi.l.liu@intel.com>
> >> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementat=
ion
> >>
> >> On Mon, Jul 22, 2019 at 07:02:51AM +0000, Liu, Yi L wrote:
> >>>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> >>>> On Behalf Of David Gibson
> >>>> Sent: Wednesday, July 17, 2019 11:07 AM
> >>>> To: Liu, Yi L <yi.l.liu@intel.com>
> >>>> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free
> >>>> implementation
> >>>>
> >>>> On Tue, Jul 16, 2019 at 10:25:55AM +0000, Liu, Yi L wrote:
> >>>>>> From: kvm-owner@vger.kernel.org
> >>>>>> [mailto:kvm-owner@vger.kernel.org] On
> >>>> Behalf
> >>>>>> Of David Gibson
> >>>>>> Sent: Monday, July 15, 2019 10:55 AM
> >>>>>> To: Liu, Yi L <yi.l.liu@intel.com>
> >>>>>> Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free
> >>>>>> implementation
> >>>>>>
> >>>>>> On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> >>>>>>> This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_=
pasid().
> >>>>>>> These two functions are used to propagate guest pasid
> >>>>>>> allocation and free requests to host via vfio container ioctl.
> >>>>>>
> >>>>>> As I said in an earlier comment, I think doing this on the
> >>>>>> device is conceptually incorrect.  I think we need an explcit
> >>>>>> notion of an SVM context (i.e. the namespace in which all the
> >>>>>> PASIDs live) - which will IIUC usually be shared amongst
> >>>>>> multiple devices.  The create and free PASID requests should be on=
 that object.
> >>>>>
> >>>>> Actually, the allocation is not doing on this device. System wide,
> >>>>> it is done on a container. So not sure if it is the API interface
> >>>>> gives you a sense that this is done on device.
> >>>>
> >>>> Sorry, I should have been clearer.  I can see that at the VFIO level
> >>>> it is done on the container.  However the function here takes a bus
> >>>> and devfn, so this qemu internal interface is per-device, which
> >>>> doesn't really make sense.
> >>>
> >>> Got it. The reason here is to pass the bus and devfn info, so that
> >>> VFIO can figure out a container for the operation. So far in QEMU,
> >>> there is no good way to connect the vIOMMU emulator and VFIO regards
> >>> to SVM.
> >>
> >> Right, and I think that's an indication that we're not modelling somet=
hing in qemu
> >> that we should be.
> >>
> >>> hw/pci layer is a choice based on some previous discussion. But yes, I
> >>> agree with you that we may need to have an explicit notion for SVM. Do
> >>> you think it is good to introduce a new abstract layer for SVM (may
> >>> name as SVMContext).
> >>
> >> I think so, yes.
> >>
> >> If nothing else, I expect we'll need this concept if we ever want to b=
e able to
> >> implement SVM for emulated devices (which could be useful for debuggin=
g, even if
> >> it's not something you'd do in production).
> >>
> >>> The idea would be that vIOMMU maintain the SVMContext instances and
> >>> expose explicit interface for VFIO to get it. Then VFIO register
> >>> notifiers on to the SVMContext. When vIOMMU emulator wants to do PASID
> >>> alloc/free, it fires the corresponding notifier. After call into VFIO,
> >>> the notifier function itself figure out the container it is bound. In
> >>> this way, it's the duty of vIOMMU emulator to figure out a proper
> >>> notifier to fire. From interface point of view, it is no longer
> >>> per-device.
> >>
> >> Exactly.
> >=20
> > Cool, let me prepare another version with the ideas. Thanks for your
> > review. :-)
> >=20
> > Regards,
> > Yi Liu
> >=20
> >>> Also, it leaves the PASID management details to vIOMMU emulator as it
> >>> can be vendor specific. Does it make sense?
> >>> Also, I'd like to know if you have any other idea on it. That would
> >>> surely be helpful. :-)
> >>>
> >>>>> Also, curious on the SVM context
> >>>>> concept, do you mean it a per-VM context or a per-SVM usage context?
> >>>>> May you elaborate a little more. :-)
> >>>>
> >>>> Sorry, I'm struggling to find a good term for this.  By "context" I
> >>>> mean a namespace containing a bunch of PASID address spaces, those
> >>>> PASIDs are then visible to some group of devices.
> >>>
> >>> I see. May be the SVMContext instance above can include multiple PASID
> >>> address spaces. And again, I think this relationship should be
> >>> maintained in vIOMMU emulator.
> >=20
> So if I understand we now head towards introducing new notifiers taking
> a "SVMContext" as argument instead of an IOMMUMemoryRegion.
>=20
> I think we need to be clear about how both abstractions (SVMContext and
> IOMMUMemoryRegion) differ. I would also need "SVMContext" abstraction
> for 2stage SMMU integration (to notify stage 1 config changes and MSI
> bindings) so I would need this new object to be not too much tied to SVM
> use case.

That's my suggestion.  I don't really have any authority to decide..

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl05JKEACgkQbDjKyiDZ
s5IkYhAAoznqVKTCH97gCdU8czSGIHARTNoEIR17+nghgcI4+g4aRuRNrPAblwUy
6etxeHBmTwINL00BUmohJAFEoKdtTfWl72JAhI/uBZkj4OCpCVsTzXvIRR5LTs3u
EGyXJoCCBvMujEludyperNNprI5Nrw/CsUKdsqtf/yH4hlwsi+9jV5ZmIijVzWCn
KacveNOmSye4VCXUL/6urXa5JAqq/OOwUpBXLstMrunndayl9zfA311MyBH4U2hn
jmRq3v7HbFadt7W7mXd4dlqF0uiwWZhSKZkTDXB06VYZ6hRx6hSFDXzTIEMUHdso
/1AaeEE47y6vI7vdKuv5Eew4fKVU7pN3YbPuRv9cJ/P+z+GF921ez/RCTR6LV1Fl
guC9ZzaRRCG/V3F+MNP5ZpFcp/hIsN7t/FdBhG3LZD3r/x6GtRtf3i+xQIDH7emn
ZJMwBK5PuX9N4ixy6zgDefqONthiUHDxoq057TTRBtvDiQCtXpwTLjN53HKTuDeX
SL4ZIV++E700dWCMh7Xa3n40KLIJ0dqqBL8ogXg+7hsl00rjMy3h6zsSkccyKrRy
F0g49hmPI9whC1xg2MgzJKNO27cXapvsHtSCb/387AxCp3N0Y9QCtkYDFkkHD4UY
V9pxNBTML7/v+gDbvQIiYcagJt5B/z0ODidLuch2eqhxF15/FoU=
=G3BS
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
