Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E4102FD2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 00:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKSXRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 18:17:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726025AbfKSXRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 18:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574205428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OoXfzTSIVHc5bwx2UX7oXD7UrQWTXgyEkgrqUucDgMg=;
        b=Mm80rdid8SWEeD+5zf3+8XcF4r9xTqvNNCQSCfQ1UJ4kIQ3hntiIpfBUQjCjSghYdhpN17
        gAxzUiYKHE1/xz1x+ZojRelkPlKOzF/7X3qvjPRGnugZhZ7+wlLhiPcxGflRw2vyIz6Hp/
        RZpWOEPaAbxggNTNvgiYpmn6tSGJu5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-6MjhXcEkONO8tv7bdaXtug-1; Tue, 19 Nov 2019 18:17:04 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9F5F107ACC6;
        Tue, 19 Nov 2019 23:17:01 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C051503CE;
        Tue, 19 Nov 2019 23:16:59 +0000 (UTC)
Date:   Tue, 19 Nov 2019 16:16:59 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Message-ID: <20191119161659.50b7fa50@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5F6A83@SHSMSX104.ccr.corp.intel.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
        <20191113130705.32c6b663@x1.home>
        <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
        <20191114140625.213e8a99@x1.home>
        <20191115024035.GA24163@joy-OptiPlex-7040>
        <20191114202133.4b046cb9@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D5F6A83@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 6MjhXcEkONO8tv7bdaXtug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 05:10:53 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Friday, November 15, 2019 11:22 AM
> >=20
> > On Thu, 14 Nov 2019 21:40:35 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >  =20
> > > On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote: =20
> > > > On Fri, 15 Nov 2019 00:26:07 +0530
> > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > =20
> > > > > On 11/14/2019 1:37 AM, Alex Williamson wrote: =20
> > > > > > On Thu, 14 Nov 2019 01:07:21 +0530
> > > > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > > =20
> > > > > >> On 11/13/2019 4:00 AM, Alex Williamson wrote: =20
> > > > > >>> On Tue, 12 Nov 2019 22:33:37 +0530
> > > > > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > >>> =20
> > > > > >>>> All pages pinned by vendor driver through vfio_pin_pages API=
 =20
> > should be =20
> > > > > >>>> considered as dirty during migration. IOMMU container =20
> > maintains a list of =20
> > > > > >>>> all such pinned pages. Added an ioctl defination to get bitm=
ap of =20
> > such =20
> > > > > >>>
> > > > > >>> definition
> > > > > >>> =20
> > > > > >>>> pinned pages for requested IO virtual address range. =20
> > > > > >>>
> > > > > >>> Additionally, all mapped pages are considered dirty when =20
> > physically =20
> > > > > >>> mapped through to an IOMMU, modulo we discussed devices =20
> > opting in to =20
> > > > > >>> per page pinning to indicate finer granularity with a TBD =20
> > mechanism to =20
> > > > > >>> figure out if any non-opt-in devices remain.
> > > > > >>> =20
> > > > > >>
> > > > > >> You mean, in case of device direct assignment (device pass =20
> > through)? =20
> > > > > >
> > > > > > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are =
=20
> > fully =20
> > > > > > pinned and mapped, then the correct dirty page set is all mappe=
d =20
> > pages. =20
> > > > > > We discussed using the vpfn list as a mechanism for vendor driv=
ers =20
> > to =20
> > > > > > reduce their migration footprint, but we also discussed that we=
 =20
> > would =20
> > > > > > need a way to determine that all participants in the container =
have
> > > > > > explicitly pinned their working pages or else we must consider =
the
> > > > > > entire potential working set as dirty.
> > > > > > =20
> > > > >
> > > > > How can vendor driver tell this capability to iommu module? Any =
=20
> > suggestions? =20
> > > >
> > > > I think it does so by pinning pages.  Is it acceptable that if the
> > > > vendor driver pins any pages, then from that point forward we consi=
der
> > > > the IOMMU group dirty page scope to be limited to pinned pages? =20
> > There =20
> > > > are complications around non-singleton IOMMU groups, but I think =
=20
> > we're =20
> > > > already leaning towards that being a non-worthwhile problem to solv=
e.
> > > > So if we require that only singleton IOMMU groups can pin pages and=
 =20
> > we =20
> > > > pass the IOMMU group as a parameter to
> > > > vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
> > > > flag on its local vfio_group struct to indicate dirty page scope is
> > > > limited to pinned pages.  We might want to keep a flag on the
> > > > vfio_iommu struct to indicate if all of the vfio_groups for each
> > > > vfio_domain in the vfio_iommu.domain_list dirty page scope limited =
to
> > > > pinned pages as an optimization to avoid walking lists too often.  =
Then
> > > > we could test if vfio_iommu.domain_list is not empty and this new f=
lag
> > > > does not limit the dirty page scope, then everything within each
> > > > vfio_dma is considered dirty.
> > > > =20
> > >
> > > hi Alex
> > > could you help clarify whether my understandings below are right?
> > > In future,
> > > 1. for mdev and for passthrough device withoug hardware ability to tr=
ack
> > > dirty pages, the vendor driver has to explicitly call
> > > vfio_pin_pages()/vfio_unpin_pages() + a flag to tell vfio its dirty p=
age set. =20
> >=20
> > For non-IOMMU backed mdevs without hardware dirty page tracking,
> > there's no change to the vendor driver currently.  Pages pinned by the
> > vendor driver are marked as dirty. =20
>=20
> What about the vendor driver can figure out, in software means, which
> pinned pages are actually dirty? In that case, would a separate mark_dirt=
y
> interface make more sense? Or introduce read/write flag to the pin_pages
> interface similar to DMA API? Existing drivers always set both r/w flags =
but
> just in case then a specific driver may set read-only or write-only...

You're jumping ahead to 2. below, where my reply is that we need to
extend the interface to allow the vendor driver to manipulate
clean/dirty state.  I don't know exactly what those interfaces should
look like, but yes, something should exist to allow that control.  If
the default is to mark pinned pages dirty, then we might need a
separate pin_pages_clean callback.

> > For any IOMMU backed device, mdev or direct assignment, all mapped
> > memory would be considered dirty unless there are explicit calls to pin
> > pages on top of the IOMMU page pinning and mapping.  These would likely
> > be enabled only when the device is in the _SAVING device_state.
> >  =20
> > > 2. for those devices with hardware ability to track dirty pages, will=
 still
> > > provide a callback to vendor driver to get dirty pages. (as for those=
 =20
> > devices, =20
> > > it is hard to explicitly call vfio_pin_pages()/vfio_unpin_pages())
> > >
> > > 3. for devices relying on dirty bit info in physical IOMMU, there
> > > will be a callback to physical IOMMU driver to get dirty page set fro=
m
> > > vfio. =20
> >=20
> > The proposal here does not cover exactly how these would be
> > implemented, it only establishes the container as the point of user
> > interaction with the dirty bitmap and hopefully allows us to maintain
> > that interface regardless of whether we have dirty tracking at the
> > device or the system IOMMU.  Ideally devices with dirty tracking would
> > make use of page pinning and we'd extend the interface to allow vendor
> > drivers the ability to indicate the clean/dirty state of those pinned =
=20
>=20
> I don't think "dirty tracking" =3D=3D "page pinning". It's possible that =
a device
> support tracking/logging dirty page info into a driver-registered buffer,=
=20
> then the host vendor driver doesn't need to mediate fast-path operations.=
=20
> In such case, the entire guest memory is always pinned and we just need=
=20
> a log-sync like interface for vendor driver to fill dirty bitmap.

An mdev device only has access to the pages that have been pinned on
behalf of the device, so just as we assume that any page pinned and
mapped through the IOMMU might be dirtied by a device, we can by
default assume that an page pinned for an mdev device is dirty.  This
maps fairly well to our existing mdev devices that don't seem to have
finer granularity dirty page tracking.  As I state above though, I
certainly don't expect this to be the final extent of dirty page
tracking.  I'm reluctant to commit to a log-sync interface though as
that seems to put the responsibility on the container to poll every
attached device whereas I was rather hoping that making the container
the central interface for dirty tracking would have devices marking
dirty pages in the container asynchronous to the user polling.

> > pages.  For system IOMMU dirty page tracking, that potentially might
> > mean that we support IOMMU page faults and the container manages
> > those
> > faults such that the container is the central record of dirty pages. =
=20
>=20
> IOMMU dirty-bit is not equivalent to IOMMU page fault. The latter
> is much more complex which requires support both in IOMMU and in
> device. Here similar to above device-dirty-tracking case, we just need a
> log-sync interface calling into iommu driver to get dirty info filled for
> requested address range.
>=20
> > Until these interfaces are designed, we can only speculate, but the
> > goal is to design a user interface compatible with how those features
> > might evolve.  If you identify something that can't work, please raise
> > the issue.  Thanks,
> >=20
> > Alex =20
>=20
> Here is the desired scheme in my mind. Feel free to correct me. :-)
>=20
> 1. iommu log-buf callback is preferred if underlying IOMMU reports
> such capability. The iommu driver walks IOMMU page table to find
> dirty pages for requested address range;
> 2. otherwise vendor driver log-buf callback is preferred if the vendor
> driver reports such capability when registering mdev types. The
> vendor driver calls device-specific interface to fill dirty info;
> 3. otherwise pages pined by vfio_pin_pages (with WRITE flag) are
> considered dirty. This covers normal mediated devices or using
> fast-path mediation for migrating passthrough device;
> 4. otherwise all mapped pages are considered dirty;
>=20
> Currently we're working on 1) based on VT-d rev3.0. I know some
> vendors implement 2) in their own code base. 3) has real usages=20
> already. 4) is the fall-back.
>=20
> Alex, are you willing to have all the interfaces ready in one batch,
> or support them based on available usages? I'm fine with either
> way, but even just doing 3/4 in this series, I'd prefer to having
> above scheme included in the code comment, to give the whole=20
> picture of all possible situations. :-)

My intention was to cover 3 & 4 given the current state of device and
IOMMU dirty tracking.  I expect the user interface to remain unchanged
for 1 & 2 but the API between vfio, the vendor drivers, and the IOMMU
is internal to the kernel and more flexible.  Thanks,

Alex

