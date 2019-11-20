Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6CC1030ED
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 02:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKTBEi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 19 Nov 2019 20:04:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:47737 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfKTBEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 20:04:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 17:04:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="407950786"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga006.fm.intel.com with ESMTP; 19 Nov 2019 17:04:36 -0800
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 17:04:35 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 Nov 2019 17:04:35 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.41]) with mapi id 14.03.0439.000;
 Wed, 20 Nov 2019 09:04:34 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
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
Subject: RE: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Thread-Topic: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Thread-Index: AQHVmX9T7ifKT6t+r02nKr4nCxrVM6eHmG0AgAFiAICAAAhOgIABfoGAgAAkaICAAF1egIAAC3KAgACYZPCABv7vgIAAn4Ew
Date:   Wed, 20 Nov 2019 01:04:33 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D6059A5@SHSMSX104.ccr.corp.intel.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
        <20191113130705.32c6b663@x1.home>
        <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
        <20191114140625.213e8a99@x1.home>       <20191115024035.GA24163@joy-OptiPlex-7040>
        <20191114202133.4b046cb9@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D5F6A83@SHSMSX104.ccr.corp.intel.com>
 <20191119161659.50b7fa50@x1.home>
In-Reply-To: <20191119161659.50b7fa50@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmRhYzJjMzktMzE3MC00ODIyLTkyMTAtNjIzZTVhNWViNDdiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZEVVWDI0R3p3NWVCZjBOSXo1ZXM0bUhYbWdsczRZSmhNQkFyTlUrb0EzVGhRYTNqejZvZ0lhQUVvaXJnZHhORiJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, November 20, 2019 7:17 AM
> 
> On Fri, 15 Nov 2019 05:10:53 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson
> > > Sent: Friday, November 15, 2019 11:22 AM
> > >
> > > On Thu, 14 Nov 2019 21:40:35 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > > On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
> > > > > On Fri, 15 Nov 2019 00:26:07 +0530
> > > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > >
> > > > > > On 11/14/2019 1:37 AM, Alex Williamson wrote:
> > > > > > > On Thu, 14 Nov 2019 01:07:21 +0530
> > > > > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > > >
> > > > > > >> On 11/13/2019 4:00 AM, Alex Williamson wrote:
> > > > > > >>> On Tue, 12 Nov 2019 22:33:37 +0530
> > > > > > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > > >>>
> > > > > > >>>> All pages pinned by vendor driver through vfio_pin_pages
> API
> > > should be
> > > > > > >>>> considered as dirty during migration. IOMMU container
> > > maintains a list of
> > > > > > >>>> all such pinned pages. Added an ioctl defination to get
> bitmap of
> > > such
> > > > > > >>>
> > > > > > >>> definition
> > > > > > >>>
> > > > > > >>>> pinned pages for requested IO virtual address range.
> > > > > > >>>
> > > > > > >>> Additionally, all mapped pages are considered dirty when
> > > physically
> > > > > > >>> mapped through to an IOMMU, modulo we discussed devices
> > > opting in to
> > > > > > >>> per page pinning to indicate finer granularity with a TBD
> > > mechanism to
> > > > > > >>> figure out if any non-opt-in devices remain.
> > > > > > >>>
> > > > > > >>
> > > > > > >> You mean, in case of device direct assignment (device pass
> > > through)?
> > > > > > >
> > > > > > > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are
> > > fully
> > > > > > > pinned and mapped, then the correct dirty page set is all
> mapped
> > > pages.
> > > > > > > We discussed using the vpfn list as a mechanism for vendor
> drivers
> > > to
> > > > > > > reduce their migration footprint, but we also discussed that we
> > > would
> > > > > > > need a way to determine that all participants in the container
> have
> > > > > > > explicitly pinned their working pages or else we must consider
> the
> > > > > > > entire potential working set as dirty.
> > > > > > >
> > > > > >
> > > > > > How can vendor driver tell this capability to iommu module? Any
> > > suggestions?
> > > > >
> > > > > I think it does so by pinning pages.  Is it acceptable that if the
> > > > > vendor driver pins any pages, then from that point forward we
> consider
> > > > > the IOMMU group dirty page scope to be limited to pinned pages?
> > > There
> > > > > are complications around non-singleton IOMMU groups, but I think
> > > we're
> > > > > already leaning towards that being a non-worthwhile problem to
> solve.
> > > > > So if we require that only singleton IOMMU groups can pin pages
> and
> > > we
> > > > > pass the IOMMU group as a parameter to
> > > > > vfio_iommu_driver_ops.pin_pages(), then the type1 backend can
> set a
> > > > > flag on its local vfio_group struct to indicate dirty page scope is
> > > > > limited to pinned pages.  We might want to keep a flag on the
> > > > > vfio_iommu struct to indicate if all of the vfio_groups for each
> > > > > vfio_domain in the vfio_iommu.domain_list dirty page scope limited
> to
> > > > > pinned pages as an optimization to avoid walking lists too often.
> Then
> > > > > we could test if vfio_iommu.domain_list is not empty and this new
> flag
> > > > > does not limit the dirty page scope, then everything within each
> > > > > vfio_dma is considered dirty.
> > > > >
> > > >
> > > > hi Alex
> > > > could you help clarify whether my understandings below are right?
> > > > In future,
> > > > 1. for mdev and for passthrough device withoug hardware ability to
> track
> > > > dirty pages, the vendor driver has to explicitly call
> > > > vfio_pin_pages()/vfio_unpin_pages() + a flag to tell vfio its dirty page
> set.
> > >
> > > For non-IOMMU backed mdevs without hardware dirty page tracking,
> > > there's no change to the vendor driver currently.  Pages pinned by the
> > > vendor driver are marked as dirty.
> >
> > What about the vendor driver can figure out, in software means, which
> > pinned pages are actually dirty? In that case, would a separate mark_dirty
> > interface make more sense? Or introduce read/write flag to the
> pin_pages
> > interface similar to DMA API? Existing drivers always set both r/w flags
> but
> > just in case then a specific driver may set read-only or write-only...
> 
> You're jumping ahead to 2. below, where my reply is that we need to

They are different. 2) is about hardware support which may collect
dirty page info in a log buffer and then report to driver when the latter
requests. Here I'm talking about software approach, i.e. when the
vendor driver intercepts certain guest operations, it may figure out
whether the captured DMA pages are used for write or read. The
hardware approach is log-based, which needs a driver callback so 
container can notify vendor driver to report. The latter is trap-based, 
which needs a VFIO API to update dirty status synchronously. 

> extend the interface to allow the vendor driver to manipulate
> clean/dirty state.  I don't know exactly what those interfaces should
> look like, but yes, something should exist to allow that control.  If
> the default is to mark pinned pages dirty, then we might need a
> separate pin_pages_clean callback.
> 
> > > For any IOMMU backed device, mdev or direct assignment, all mapped
> > > memory would be considered dirty unless there are explicit calls to pin
> > > pages on top of the IOMMU page pinning and mapping.  These would
> likely
> > > be enabled only when the device is in the _SAVING device_state.
> > >
> > > > 2. for those devices with hardware ability to track dirty pages, will still
> > > > provide a callback to vendor driver to get dirty pages. (as for those
> > > devices,
> > > > it is hard to explicitly call vfio_pin_pages()/vfio_unpin_pages())
> > > >
> > > > 3. for devices relying on dirty bit info in physical IOMMU, there
> > > > will be a callback to physical IOMMU driver to get dirty page set from
> > > > vfio.
> > >
> > > The proposal here does not cover exactly how these would be
> > > implemented, it only establishes the container as the point of user
> > > interaction with the dirty bitmap and hopefully allows us to maintain
> > > that interface regardless of whether we have dirty tracking at the
> > > device or the system IOMMU.  Ideally devices with dirty tracking would
> > > make use of page pinning and we'd extend the interface to allow
> vendor
> > > drivers the ability to indicate the clean/dirty state of those pinned
> >
> > I don't think "dirty tracking" == "page pinning". It's possible that a device
> > support tracking/logging dirty page info into a driver-registered buffer,
> > then the host vendor driver doesn't need to mediate fast-path operations.
> > In such case, the entire guest memory is always pinned and we just need
> > a log-sync like interface for vendor driver to fill dirty bitmap.
> 
> An mdev device only has access to the pages that have been pinned on
> behalf of the device, so just as we assume that any page pinned and
> mapped through the IOMMU might be dirtied by a device, we can by
> default assume that an page pinned for an mdev device is dirty.  This
> maps fairly well to our existing mdev devices that don't seem to have
> finer granularity dirty page tracking.  As I state above though, I
> certainly don't expect this to be the final extent of dirty page
> tracking.  I'm reluctant to commit to a log-sync interface though as
> that seems to put the responsibility on the container to poll every
> attached device whereas I was rather hoping that making the container
> the central interface for dirty tracking would have devices marking
> dirty pages in the container asynchronous to the user polling.

Having device to mark dirty pages asynchronous only applies to the
software approach which tracks dirty pages by mediating fast-path
guest operations. In case the device logging dirty info into a buffer,
we need a log-sync interface so vendor driver can be notified to
collect hardware-logged information. Whether to have vendor driver
directly update container's dirty bitmap, or have vendor driver to
call mark_dirty for every recorded dirty page, it's just an implementation
choice and you make the decision. :-) This is actually similar to IOMMU 
dirty-bit collection, where we also need an interface to notify IOMMU 
driver to collect its dirty bits.

> 
> > > pages.  For system IOMMU dirty page tracking, that potentially might
> > > mean that we support IOMMU page faults and the container manages
> > > those
> > > faults such that the container is the central record of dirty pages.
> >
> > IOMMU dirty-bit is not equivalent to IOMMU page fault. The latter
> > is much more complex which requires support both in IOMMU and in
> > device. Here similar to above device-dirty-tracking case, we just need a
> > log-sync interface calling into iommu driver to get dirty info filled for
> > requested address range.
> >
> > > Until these interfaces are designed, we can only speculate, but the
> > > goal is to design a user interface compatible with how those features
> > > might evolve.  If you identify something that can't work, please raise
> > > the issue.  Thanks,
> > >
> > > Alex
> >
> > Here is the desired scheme in my mind. Feel free to correct me. :-)
> >
> > 1. iommu log-buf callback is preferred if underlying IOMMU reports
> > such capability. The iommu driver walks IOMMU page table to find
> > dirty pages for requested address range;
> > 2. otherwise vendor driver log-buf callback is preferred if the vendor
> > driver reports such capability when registering mdev types. The
> > vendor driver calls device-specific interface to fill dirty info;
> > 3. otherwise pages pined by vfio_pin_pages (with WRITE flag) are
> > considered dirty. This covers normal mediated devices or using
> > fast-path mediation for migrating passthrough device;
> > 4. otherwise all mapped pages are considered dirty;
> >
> > Currently we're working on 1) based on VT-d rev3.0. I know some
> > vendors implement 2) in their own code base. 3) has real usages
> > already. 4) is the fall-back.
> >
> > Alex, are you willing to have all the interfaces ready in one batch,
> > or support them based on available usages? I'm fine with either
> > way, but even just doing 3/4 in this series, I'd prefer to having
> > above scheme included in the code comment, to give the whole
> > picture of all possible situations. :-)
> 
> My intention was to cover 3 & 4 given the current state of device and
> IOMMU dirty tracking.  I expect the user interface to remain unchanged
> for 1 & 2 but the API between vfio, the vendor drivers, and the IOMMU
> is internal to the kernel and more flexible.  Thanks,
> 

Sure. I also don't expect any change to user space API when extending
to 1 and 2. here our discussion is purely about kernel internal APIs. 

Thanks
Kevin
