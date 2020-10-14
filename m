Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ADB28E91A
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgJNXLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 19:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbgJNXLO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 19:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602717070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/Ufxgp8PHjDjKNkSG1bS0DXXAqsCkWUrrQf4aL9aLQ=;
        b=DNN3615CE9ITV/CANNd0ZF3b3V60EtVqNt4HqeyGAIktRYW7sWFGU5Kd3sbRYzA5FnPKTo
        Udp4DWbMFsfSfNgGhnab4XHkMDH+waGVEweofbUeP0xb2yjpJCRMGQSv+as711JKAxa2zd
        04QesYju/fAjVoUxZUjGe7Bmr/WWyWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-w5HkWwf4N7i60GAk6iiLWQ-1; Wed, 14 Oct 2020 19:11:08 -0400
X-MC-Unique: w5HkWwf4N7i60GAk6iiLWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52729186840B;
        Wed, 14 Oct 2020 23:11:06 +0000 (UTC)
Received: from w520.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A98760C07;
        Wed, 14 Oct 2020 23:10:56 +0000 (UTC)
Date:   Wed, 14 Oct 2020 17:10:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201014171055.328a52f4@w520.home>
In-Reply-To: <MWHPR11MB1645CF252CF3493F4A9487508C050@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
        <45faf89a-0a40-2a7a-0a76-d7ba76d0813b@redhat.com>
        <MWHPR11MB1645CF252CF3493F4A9487508C050@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Oct 2020 03:08:31 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Tuesday, October 13, 2020 2:22 PM
> >=20
> >=20
> > On 2020/10/12 =E4=B8=8B=E5=8D=884:38, Tian, Kevin wrote: =20
> > >> From: Jason Wang <jasowang@redhat.com>
> > >> Sent: Monday, September 14, 2020 12:20 PM
> > >> =20
> > > [...] =20
> > >   > If it's possible, I would suggest a generic uAPI instead of a VFIO
> > >> specific one.
> > >>
> > >> Jason suggest something like /dev/sva. There will be a lot of other
> > >> subsystems that could benefit from this (e.g vDPA).
> > >>
> > >> Have you ever considered this approach?
> > >> =20
> > > Hi, Jason,
> > >
> > > We did some study on this approach and below is the output. It's a
> > > long writing but I didn't find a way to further abstract w/o losing
> > > necessary context. Sorry about that.
> > >
> > > Overall the real purpose of this series is to enable IOMMU nested
> > > translation capability with vSVA as one major usage, through
> > > below new uAPIs:
> > > 	1) Report/enable IOMMU nested translation capability;
> > > 	2) Allocate/free PASID;
> > > 	3) Bind/unbind guest page table;
> > > 	4) Invalidate IOMMU cache;
> > > 	5) Handle IOMMU page request/response (not in this series);
> > > 1/3/4) is the minimal set for using IOMMU nested translation, with
> > > the other two optional. For example, the guest may enable vSVA on
> > > a device without using PASID. Or, it may bind its gIOVA page table
> > > which doesn't require page fault support. Finally, all operations can
> > > be applied to either physical device or subdevice.
> > >
> > > Then we evaluated each uAPI whether generalizing it is a good thing
> > > both in concept and regarding to complexity.
> > >
> > > First, unlike other uAPIs which are all backed by iommu_ops, PASID
> > > allocation/free is through the IOASID sub-system. =20
> >=20
> >=20
> > A question here, is IOASID expected to be the single management
> > interface for PASID? =20
>=20
> yes
>=20
> >=20
> > (I'm asking since there're already vendor specific IDA based PASID
> > allocator e.g amdgpu_pasid_alloc()) =20
>=20
> That comes before IOASID core was introduced. I think it should be
> changed to use the new generic interface. Jacob/Jean can better
> comment if other reason exists for this exception.
>=20
> >=20
> >  =20
> > >   From this angle
> > > we feel generalizing PASID management does make some sense.
> > > First, PASID is just a number and not related to any device before
> > > it's bound to a page table and IOMMU domain. Second, PASID is a
> > > global resource (at least on Intel VT-d), =20
> >=20
> >=20
> > I think we need a definition of "global" here. It looks to me for vt-d
> > the PASID table is per device. =20
>=20
> PASID table is per device, thus VT-d could support per-device PASIDs
> in concept. However on Intel platform we require PASIDs to be managed=20
> in system-wide (cross host and guest) when combining vSVA, SIOV, SR-IOV=20
> and ENQCMD together. Thus the host creates only one 'global' PASID=20
> namespace but do use per-device PASID table to assure isolation between=20
> devices on Intel platforms. But ARM does it differently as Jean explained=
.=20
> They have a global namespace for host processes on all host-owned=20
> devices (same as Intel), but then per-device namespace when a device=20
> (and its PASID table) is assigned to userspace.
>=20
> >=20
> > Another question, is this possible to have two DMAR hardware unit(at
> > least I can see two even in my laptop). In this case, is PASID still a
> > global resource? =20
>=20
> yes
>=20
> >=20
> >  =20
> > >   while having separate VFIO/
> > > VDPA allocation interfaces may easily cause confusion in userspace,
> > > e.g. which interface to be used if both VFIO/VDPA devices exist.
> > > Moreover, an unified interface allows centralized control over how
> > > many PASIDs are allowed per process. =20
> >=20
> >=20
> > Yes.
> >=20
> >  =20
> > >
> > > One unclear part with this generalization is about the permission.
> > > Do we open this interface to any process or only to those which
> > > have assigned devices? If the latter, what would be the mechanism
> > > to coordinate between this new interface and specific passthrough
> > > frameworks? =20
> >=20
> >=20
> > I'm not sure, but if you just want a permission, you probably can
> > introduce new capability (CAP_XXX) for this.
> >=20
> >  =20
> > >   A more tricky case, vSVA support on ARM (Eric/Jean
> > > please correct me) plans to do per-device PASID namespace which
> > > is built on a bind_pasid_table iommu callback to allow guest fully
> > > manage its PASIDs on a given passthrough device. =20
> >=20
> >=20
> > I see, so I think the answer is to prepare for the namespace support
> > from the start. (btw, I don't see how namespace is handled in current
> > IOASID module?) =20
>=20
> The PASID table is based on GPA when nested translation is enabled=20
> on ARM SMMU. This design implies that the guest manages PASID
> table thus PASIDs instead of going through host-side API on assigned=20
> device. From this angle we don't need explicit namespace in the host=20
> API. Just need a way to control how many PASIDs a process is allowed=20
> to allocate in the global namespace. btw IOASID module already has=20
> 'set' concept per-process and PASIDs are managed per-set. Then the=20
> quota control can be easily introduced in the 'set' level.
>=20
> >=20
> >  =20
> > >   I'm not sure
> > > how such requirement can be unified w/o involving passthrough
> > > frameworks, or whether ARM could also switch to global PASID
> > > style...
> > >
> > > Second, IOMMU nested translation is a per IOMMU domain
> > > capability. Since IOMMU domains are managed by VFIO/VDPA
> > >   (alloc/free domain, attach/detach device, set/get domain attribute,
> > > etc.), reporting/enabling the nesting capability is an natural
> > > extension to the domain uAPI of existing passthrough frameworks.
> > > Actually, VFIO already includes a nesting enable interface even
> > > before this series. So it doesn't make sense to generalize this uAPI
> > > out. =20
> >=20
> >=20
> > So my understanding is that VFIO already:
> >=20
> > 1) use multiple fds
> > 2) separate IOMMU ops to a dedicated container fd (type1 iommu)
> > 3) provides API to associated devices/group with a container

This is not really correct, or at least doesn't match my mental model.
A vfio container represents a set of groups (one or more devices per
group), which share an IOMMU model and context.  The user separately
opens a vfio container and group device files.  A group is associated
to the container via ioctl on the group, providing the container fd.
The user then sets the IOMMU model on the container, which selects the
vfio IOMMU uAPI they'll use.  We support multiple IOMMU models where
each vfio IOMMU backend registers a set of callbacks with vfio-core.

> > And all the proposal in this series is to reuse the container fd. It
> > should be possible to replace e.g type1 IOMMU with a unified module. =20
>=20
> yes, this is the alternative option that I raised in the last paragraph.

"[R]euse the container fd" is where I get lost here.  The container is
a fundamental part of vfio.  Does this instead mean to introduce a new
vfio IOMMU backend model?  The module would need to interact with vfio
via vfio_iommu_driver_ops callbacks, so this "unified module" requires
a vfio interface.  I don't understand how this contributes to something
that vdpa would also make use of.


> > > Then the tricky part comes with the remaining operations (3/4/5),
> > > which are all backed by iommu_ops thus effective only within an
> > > IOMMU domain. To generalize them, the first thing is to find a way
> > > to associate the sva_FD (opened through generic /dev/sva) with an
> > > IOMMU domain that is created by VFIO/VDPA. The second thing is
> > > to replicate {domain<->device/subdevice} association in /dev/sva
> > > path because some operations (e.g. page fault) is triggered/handled
> > > per device/subdevice. =20
> >=20
> >=20
> > Is there any reason that the #PF can not be handled via SVA fd? =20
>=20
> using per-device FDs or multiplexing all fault info through one sva_FD
> is just an implementation choice. The key is to mark faults per device/
> subdevice thus anyway requires a userspace-visible handle/tag to
> represent device/subdevice and the domain/device association must
> be constructed in this new path.
>=20
> >=20
> >  =20
> > >   Therefore, /dev/sva must provide both per-
> > > domain and per-device uAPIs similar to what VFIO/VDPA already
> > > does. Moreover, mapping page fault to subdevice requires pre-
> > > registering subdevice fault data to IOMMU layer when binding
> > > guest page table, while such fault data can be only retrieved from
> > > parent driver through VFIO/VDPA.
> > >
> > > However, we failed to find a good way even at the 1st step about
> > > domain association. The iommu domains are not exposed to the
> > > userspace, and there is no 1:1 mapping between domain and device.
> > > In VFIO, all devices within the same VFIO container share the address
> > > space but they may be organized in multiple IOMMU domains based
> > > on their bus type. How (should we let) the userspace know the
> > > domain information and open an sva_FD for each domain is the main
> > > problem here. =20
> >=20
> >=20
> > The SVA fd is not necessarily opened by userspace. It could be get
> > through subsystem specific uAPIs.
> >=20
> > E.g for vDPA if a vDPA device contains several vSVA-capable domains, we=
 can:
> >=20
> > 1) introduce uAPI for userspace to know the number of vSVA-capable
> > domain
> > 2) introduce e.g VDPA_GET_SVA_FD to get the fd for each vSVA-capable
> > domain =20
>=20
> and also new interface to notify userspace when a domain disappears
> or a device is detached? Finally looks we are creating a completely set
> of new subsystem specific uAPIs just for generalizing another set of
> subsystem specific uAPIs. Remember after separating PASID mgmt.
> out then most of remaining vSVA uAPIs are simpler wrapper of IOMMU=20
> API. Replicating them is much easier logic than developing a new glue=20
> mechanism in each subsystem.

Right, I don't see the advantage here, subsystem specific uAPIs using
common internal interfaces is what was being proposed.

> > > In the end we just realized that doing such generalization doesn't
> > > really lead to a clear design and instead requires tight coordination
> > > between /dev/sva and VFIO/VDPA for almost every new uAPI
> > > (especially about synchronization when the domain/device
> > > association is changed or when the device/subdevice is being reset/
> > > drained). Finally it may become a usability burden to the userspace
> > > on proper use of the two interfaces on the assigned device.
> > >
> > > Based on above analysis we feel that just generalizing PASID mgmt.
> > > might be a good thing to look at while the remaining operations are
> > > better being VFIO/VDPA specific uAPIs. anyway in concept those are
> > > just a subset of the page table management capabilities that an
> > > IOMMU domain affords. Since all other aspects of the IOMMU domain
> > > is managed by VFIO/VDPA already, continuing this path for new nesting
> > > capability sounds natural. There is another option by generalizing the
> > > entire IOMMU domain management (sort of the entire vfio_iommu_
> > > type1), but it's unclear whether such intrusive change is worthwhile
> > > (especially when VFIO/VDPA already goes different route even in legacy
> > > mapping uAPI: map/unmap vs. IOTLB).
> > >
> > > Thoughts? =20
> >=20
> >=20
> > I'm ok with starting with a unified PASID management and consider the
> > unified vSVA/vIOMMU uAPI later.
> >  =20
>=20
> Glad to see that we have consensus here. :)

I see the benefit in a common PASID quota mechanism rather than the
ad-hoc limits introduced for vfio, but vfio integration does have the
benefit of being tied to device access, whereas it seems it seems a
user will need to be granted some CAP_SVA capability separate from the
device to make use of this interface.  It's possible for vfio to honor
shared limits, just as we make use of locked memory limits shared by
the task, so I'm not sure yet the benefit provided by a separate
userspace interface outside of vfio.  A separate interface also throws
a kink is userspace use of vfio, where we expect the interface is
largely self contained, ie. if a user has access to the vfio group and
container device files, they can fully make use of their device, up to
limits imposed by things like locked memory.  I'm concerned that
management tools will actually need to understand the intended usage of
a device in order to grant new capabilities, file access, and limits to
a process making use of these features.  Hopefully your prototype will
clarify some of those aspects.  Thanks,

Alex

