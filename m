Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEB0FD344
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 04:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKODZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 22:25:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48283 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfKODZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 22:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573788318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBp4FmTFndoV2E6Z2nSTSST44p0wLfI37SUsgMQuKGo=;
        b=g8F1dkDZeG1L/fjiShtL8HKGpGI8I9NU/jIrKVn1Gof5VPHApNHKTrvpClSZxvOqXZHX1q
        FBNfgcq2JTA4BJ+dQjy6AdQ2ikZbipGM00xn0M3JQiMG11G9XG2uQbpi9CW86uX5Oentka
        3CVC3PkSqPkmsyhP+w7zvHYOxInRl0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-Ww_qgsfoNW2x5uLx9PHSHg-1; Thu, 14 Nov 2019 22:25:15 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C806802695;
        Fri, 15 Nov 2019 03:25:12 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B81F4101F6CA;
        Fri, 15 Nov 2019 03:25:09 +0000 (UTC)
Date:   Thu, 14 Nov 2019 20:21:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20191114202133.4b046cb9@x1.home>
In-Reply-To: <20191115024035.GA24163@joy-OptiPlex-7040>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
        <20191113130705.32c6b663@x1.home>
        <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
        <20191114140625.213e8a99@x1.home>
        <20191115024035.GA24163@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Ww_qgsfoNW2x5uLx9PHSHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 21:40:35 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
> > On Fri, 15 Nov 2019 00:26:07 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >  =20
> > > On 11/14/2019 1:37 AM, Alex Williamson wrote: =20
> > > > On Thu, 14 Nov 2019 01:07:21 +0530
> > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > >    =20
> > > >> On 11/13/2019 4:00 AM, Alex Williamson wrote:   =20
> > > >>> On Tue, 12 Nov 2019 22:33:37 +0530
> > > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > >>>       =20
> > > >>>> All pages pinned by vendor driver through vfio_pin_pages API sho=
uld be
> > > >>>> considered as dirty during migration. IOMMU container maintains =
a list of
> > > >>>> all such pinned pages. Added an ioctl defination to get bitmap o=
f such   =20
> > > >>>
> > > >>> definition
> > > >>>       =20
> > > >>>> pinned pages for requested IO virtual address range.   =20
> > > >>>
> > > >>> Additionally, all mapped pages are considered dirty when physical=
ly
> > > >>> mapped through to an IOMMU, modulo we discussed devices opting in=
 to
> > > >>> per page pinning to indicate finer granularity with a TBD mechani=
sm to
> > > >>> figure out if any non-opt-in devices remain.
> > > >>>       =20
> > > >>
> > > >> You mean, in case of device direct assignment (device pass through=
)?   =20
> > > >=20
> > > > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are full=
y
> > > > pinned and mapped, then the correct dirty page set is all mapped pa=
ges.
> > > > We discussed using the vpfn list as a mechanism for vendor drivers =
to
> > > > reduce their migration footprint, but we also discussed that we wou=
ld
> > > > need a way to determine that all participants in the container have
> > > > explicitly pinned their working pages or else we must consider the
> > > > entire potential working set as dirty.
> > > >    =20
> > >=20
> > > How can vendor driver tell this capability to iommu module? Any sugge=
stions? =20
> >=20
> > I think it does so by pinning pages.  Is it acceptable that if the
> > vendor driver pins any pages, then from that point forward we consider
> > the IOMMU group dirty page scope to be limited to pinned pages?  There
> > are complications around non-singleton IOMMU groups, but I think we're
> > already leaning towards that being a non-worthwhile problem to solve.
> > So if we require that only singleton IOMMU groups can pin pages and we
> > pass the IOMMU group as a parameter to
> > vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
> > flag on its local vfio_group struct to indicate dirty page scope is
> > limited to pinned pages.  We might want to keep a flag on the
> > vfio_iommu struct to indicate if all of the vfio_groups for each
> > vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
> > pinned pages as an optimization to avoid walking lists too often.  Then
> > we could test if vfio_iommu.domain_list is not empty and this new flag
> > does not limit the dirty page scope, then everything within each
> > vfio_dma is considered dirty.
> > =20
>=20
> hi Alex
> could you help clarify whether my understandings below are right?
> In future,
> 1. for mdev and for passthrough device withoug hardware ability to track
> dirty pages, the vendor driver has to explicitly call
> vfio_pin_pages()/vfio_unpin_pages() + a flag to tell vfio its dirty page =
set.

For non-IOMMU backed mdevs without hardware dirty page tracking,
there's no change to the vendor driver currently.  Pages pinned by the
vendor driver are marked as dirty.

For any IOMMU backed device, mdev or direct assignment, all mapped
memory would be considered dirty unless there are explicit calls to pin
pages on top of the IOMMU page pinning and mapping.  These would likely
be enabled only when the device is in the _SAVING device_state.

> 2. for those devices with hardware ability to track dirty pages, will sti=
ll
> provide a callback to vendor driver to get dirty pages. (as for those dev=
ices,
> it is hard to explicitly call vfio_pin_pages()/vfio_unpin_pages())
>
> 3. for devices relying on dirty bit info in physical IOMMU, there
> will be a callback to physical IOMMU driver to get dirty page set from
> vfio.

The proposal here does not cover exactly how these would be
implemented, it only establishes the container as the point of user
interaction with the dirty bitmap and hopefully allows us to maintain
that interface regardless of whether we have dirty tracking at the
device or the system IOMMU.  Ideally devices with dirty tracking would
make use of page pinning and we'd extend the interface to allow vendor
drivers the ability to indicate the clean/dirty state of those pinned
pages.  For system IOMMU dirty page tracking, that potentially might
mean that we support IOMMU page faults and the container manages those
faults such that the container is the central record of dirty pages.
Until these interfaces are designed, we can only speculate, but the
goal is to design a user interface compatible with how those features
might evolve.  If you identify something that can't work, please raise
the issue.  Thanks,

Alex

