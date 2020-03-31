Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A2198A13
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 04:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgCaCkb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Mar 2020 22:40:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:46432 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgCaCkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 22:40:31 -0400
IronPort-SDR: XBogqaVPaikgKWsYjSsOsruWGbaPKiJ/86h9V5oGKCR7XKSC/fgtt+iSoTMmsyDbMCi5xcEnIV
 UOiQfdnTywCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 19:40:29 -0700
IronPort-SDR: 8774qk7ovZyIeQOHD+dAk7yCVvJ6wSblEcSBfNficJl6yvmLxG77BrvObnkBtSLc9uQa4VeztR
 ZtxysoFm33yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,326,1580803200"; 
   d="scan'208";a="272588777"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2020 19:40:29 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 19:40:29 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 19:40:28 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.138]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 10:40:25 +0800
From:   "Zhao, Yan Y" <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
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
Subject: RE: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Thread-Topic: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Thread-Index: AQHWAiaCBWEyOsc9okK1y3RUgVyKz6hYkR2AgAJSZoCAALYkgP//zPSAgAUakoCAAChxgIABLlqA//+LSYCAAIVFAP//gBmAABDhq4D//5DGAP//eW8A
Date:   Tue, 31 Mar 2020 02:40:24 +0000
Message-ID: <F22B14EC3CFBB843AD3E03B6B78F2C6A4C4B1627@shsmsx102.ccr.corp.intel.com>
References: <20200325021135.GB20109@joy-OptiPlex-7040>
        <33d38629-aeaf-1c30-26d4-958b998620b0@nvidia.com>
        <20200327003055.GB26419@joy-OptiPlex-7040>
        <deb8b18f-aa79-70d3-ce05-89b607f813c4@nvidia.com>
        <20200330032437.GD30683@joy-OptiPlex-7040>
        <e91dbf70-05bf-977f-208b-0fb5988af3a8@nvidia.com>
        <20200330235131.GB6478@joy-OptiPlex-7040>
        <20200330185347.58b1ab93@x1.home>
        <20200331005046.GB6631@joy-OptiPlex-7040>
        <20200330191259.42c560ee@x1.home>
        <20200331011621.GC6631@joy-OptiPlex-7040>
 <20200330203816.4c26ae53@x1.home>
In-Reply-To: <20200330203816.4c26ae53@x1.home>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Alex Williamson
> Sent: Tuesday, March 31, 2020 10:38 AM
> To: Zhao, Yan Y <yan.y.zhao@intel.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>; cjia@nvidia.com; Tian, Kevin
> <kevin.tian@intel.com>; Yang, Ziye <ziye.yang@intel.com>; Liu, Changpeng
> <changpeng.liu@intel.com>; Liu, Yi L <yi.l.liu@intel.com>;
> mlevitsk@redhat.com; eskultet@redhat.com; cohuck@redhat.com;
> dgilbert@redhat.com; jonathan.davies@nutanix.com; eauger@redhat.com;
> aik@ozlabs.ru; pasic@linux.ibm.com; felipe@nutanix.com;
> Zhengxiao.zx@Alibaba-inc.com; shuangtai.tst@alibaba-inc.com;
> Ken.Xue@amd.com; Wang, Zhi A <zhi.a.wang@intel.com>; qemu-
> devel@nongnu.org; kvm@vger.kernel.org
> Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
> dirty pages tracking.
> 
> On Mon, 30 Mar 2020 21:16:21 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, Mar 31, 2020 at 09:12:59AM +0800, Alex Williamson wrote:
> > > On Mon, 30 Mar 2020 20:50:47 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > > On Tue, Mar 31, 2020 at 08:53:47AM +0800, Alex Williamson wrote:
> > > > > On Mon, 30 Mar 2020 19:51:31 -0400 Yan Zhao
> > > > > <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > > On Mon, Mar 30, 2020 at 09:49:21PM +0800, Kirti Wankhede wrote:
> > > > > > >
> > > > > > >
> > > > > > > On 3/30/2020 8:54 AM, Yan Zhao wrote:
> > > > > > > > On Fri, Mar 27, 2020 at 01:28:13PM +0800, Kirti Wankhede wrote:
> > > > > > > >> Hit send button little early.
> > > > > > > >>
> > > > > > > >>   >
> > > > > > > >>   > I checked v12, it's not like what I said.
> > > > > > > >>   > In v12, bitmaps are generated per vfio_dma, and
> combination of the
> > > > > > > >>   > bitmaps are required in order to generate a big bitmap
> suiting for dirty
> > > > > > > >>   > query. It can cause problem when offset not aligning.
> > > > > > > >>   > But what I propose here is to generate an rb tree orthogonal
> to the tree
> > > > > > > >>   > of vfio_dma.
> > > > > > > >>   >
> > > > > > > >>   > as to CPU cycles saving, I don't think iterating/translating
> page by page
> > > > > > > >>   > would achieve that purpose.
> > > > > > > >>   >
> > > > > > > >>
> > > > > > > >> Instead of creating one extra rb tree for dirty pages
> > > > > > > >> tracking in v10 tried to use dma->pfn_list itself, we
> > > > > > > >> tried changes in v10, v11 and v12, latest version is
> > > > > > > >> evolved version with best possible approach after discussion.
> Probably, go through v11 as well.
> > > > > > > >> https://patchwork.kernel.org/patch/11298335/
> > > > > > > >>
> > > > > > > > I'm not sure why all those previous implementations are
> > > > > > > > bound to vfio_dma. for vIOMMU on, in most cases, a
> > > > > > > > vfio_dma is only for a page, so generating a one-byte bitmap for
> a single page in each vfio_dma ?
> > > > > > > > is it possible to creating one extra rb tree to keep dirty
> > > > > > > > ranges, and one fixed length kernel bitmap whose content
> > > > > > > > is generated on query, serving as a bouncing buffer for
> > > > > > > > copy_to_user
> > > > > > > >
> > > > > > >
> > > > > > > One fixed length? what should be fixed value? then isn't it
> > > > > > > better to fix the size to dma->size?
> > > > > > >
> > > > > > > This is also to prevent DoS attack, user space application
> > > > > > > can query a very large range.
> > > > > > >
> > > > > > > >>
> > > > > > > >> On 3/27/2020 6:00 AM, Yan Zhao wrote:
> > > > > > > >>> On Fri, Mar 27, 2020 at 05:39:01AM +0800, Kirti Wankhede
> wrote:
> > > > > > > >>>>
> > > > > > > >>>>
> > > > > > > >>>> On 3/25/2020 7:41 AM, Yan Zhao wrote:
> > > > > > > >>>>> On Wed, Mar 25, 2020 at 05:18:52AM +0800, Kirti
> Wankhede wrote:
> > > > > > > >>>>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three
> operations:
> > > > > > > >>>>>> - Start dirty pages tracking while migration is
> > > > > > > >>>>>> active
> > > > > > > >>>>>> - Stop dirty pages tracking.
> > > > > > > >>>>>> - Get dirty pages bitmap. Its user space application's
> responsibility to
> > > > > > > >>>>>>      copy content of dirty pages from source to destination
> during migration.
> > > > > > > >>>>>>
> > > > > > > >>>>>> To prevent DoS attack, memory for bitmap is allocated
> > > > > > > >>>>>> per vfio_dma structure. Bitmap size is calculated
> > > > > > > >>>>>> considering smallest supported page size. Bitmap is
> > > > > > > >>>>>> allocated for all vfio_dmas when dirty logging is
> > > > > > > >>>>>> enabled
> > > > > > > >>>>>>
> > > > > > > >>>>>> Bitmap is populated for already pinned pages when
> > > > > > > >>>>>> bitmap is allocated for a vfio_dma with the smallest
> > > > > > > >>>>>> supported page size. Update bitmap from pinning
> > > > > > > >>>>>> functions when tracking is enabled. When user
> > > > > > > >>>>>> application queries bitmap, check if requested page
> > > > > > > >>>>>> size is same as page size used to populated bitmap. If it is
> equal, copy bitmap, but if not equal, return error.
> > > > > > > >>>>>>
> > > > > > > >>>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > > > > > > >>>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > > > > > > >>>>>> ---
> > > > > > > >>>>>>     drivers/vfio/vfio_iommu_type1.c | 266
> +++++++++++++++++++++++++++++++++++++++-
> > > > > > > >>>>>>     1 file changed, 260 insertions(+), 6 deletions(-)
> > > > > > > >>>>>>
> > > > > > > >>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c
> > > > > > > >>>>>> b/drivers/vfio/vfio_iommu_type1.c index
> > > > > > > >>>>>> 70aeab921d0f..874a1a7ae925 100644
> > > > > > > >>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > > > >>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > > > >>>>>> @@ -71,6 +71,7 @@ struct vfio_iommu {
> > > > > > > >>>>>>     	unsigned int		dma_avail;
> > > > > > > >>>>>>     	bool			v2;
> > > > > > > >>>>>>     	bool			nesting;
> > > > > > > >>>>>> +	bool			dirty_page_tracking;
> > > > > > > >>>>>>     };
> > > > > > > >>>>>>
> > > > > > > >>>>>>     struct vfio_domain { @@ -91,6 +92,7 @@ struct
> > > > > > > >>>>>> vfio_dma {
> > > > > > > >>>>>>     	bool			lock_cap;	/*
> capable(CAP_IPC_LOCK) */
> > > > > > > >>>>>>     	struct task_struct	*task;
> > > > > > > >>>>>>     	struct rb_root		pfn_list;	/* Ex-user
> pinned pfn list */
> > > > > > > >>>>>> +	unsigned long		*bitmap;
> > > > > > > >>>>>>     };
> > > > > > > >>>>>>
> > > > > > > >>>>>>     struct vfio_group { @@ -125,7 +127,21 @@ struct
> > > > > > > >>>>>> vfio_regions {
> > > > > > > >>>>>>     #define
> IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> > > > > > > >>>>>>
> 	(!list_empty(&iommu->domain_list))
> > > > > > > >>>>>>
> > > > > > > >>>>>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n,
> BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> > > > > > > >>>>>> +
> > > > > > > >>>>>> +/*
> > > > > > > >>>>>> + * Input argument of number of bits to bitmap_set()
> > > > > > > >>>>>> +is unsigned integer, which
> > > > > > > >>>>>> + * further casts to signed integer for unaligned
> > > > > > > >>>>>> +multi-bit operation,
> > > > > > > >>>>>> + * __bitmap_set().
> > > > > > > >>>>>> + * Then maximum bitmap size supported is 2^31 bits
> > > > > > > >>>>>> +divided by 2^3 bits/byte,
> > > > > > > >>>>>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 =
> > > > > > > >>>>>> +2^43 (8TB) on 4K page
> > > > > > > >>>>>> + * system.
> > > > > > > >>>>>> + */
> > > > > > > >>>>>> +#define DIRTY_BITMAP_PAGES_MAX
> 	(uint64_t)(INT_MAX - 1)
> > > > > > > >>>>>> +#define DIRTY_BITMAP_SIZE_MAX
> DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> > > > > > > >>>>>> +
> > > > > > > >>>>>>     static int put_pfn(unsigned long pfn, int prot);
> > > > > > > >>>>>> +static unsigned long vfio_pgsize_bitmap(struct
> > > > > > > >>>>>> +vfio_iommu *iommu);
> > > > > > > >>>>>>
> > > > > > > >>>>>>     /*
> > > > > > > >>>>>>      * This code handles mapping and unmapping of
> > > > > > > >>>>>> user data buffers @@ -175,6 +191,77 @@ static void
> vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> > > > > > > >>>>>>     	rb_erase(&old->node, &iommu->dma_list);
> > > > > > > >>>>>>     }
> > > > > > > >>>>>>
> > > > > > > >>>>>> +
> > > > > > > >>>>>> +static int vfio_dma_bitmap_alloc(struct vfio_dma
> > > > > > > >>>>>> +*dma, uint64_t pgsize) {
> > > > > > > >>>>>> +	uint64_t npages = dma->size / pgsize;
> > > > > > > >>>>>> +
> > > > > > > > If pgsize > dma->size, npages = 0.
> > > > > > > > wouldn't it cause problem?
> > > > > > > >
> > > > > > >
> > > > > > > This patch-set supports bitmap for smallest supported page size,
> i.e.
> > > > > > > PAGE_SIZE. vfio_dma_do_map() validates dma->size
> > > > > > > accordingly. So this case will not happen.
> > > > > > >
> > > > > > as far as I know, qemu/kvm uses 4k as the unit for dirty page
> tracking.
> > > > > > so why smallest iommu page size is used here?
> > > > > > wouldn't it cause problem?
> > > > >
> > > > > If your concern is that the IOMMU supports sub-4K page sizes,
> > > > > see vfio_pgsize_bitmap().  We actually only support PAGE_SIZE as
> > > > > our minimum mapping unit, even if the IOMMU supports less, so
> PAGE_SIZE is
> > > > > our lower bound.  Thanks,
> > > >
> > > > if we always uses PAGE_SIZE, why not use PAGE_SIZE directly?
> > > > or returning dirty bitmap unit (e.g. 1 <<
> > > > __ffs(vfio_pgsize_bitmap(iommu))) to QEMU in
> > > > VFIO_IOMMU_DIRTY_PAGES_FLAG_START, so that qemu can do
> possible conversion if it's not the same unit that QEMU uses.
> > >
> > > The vfio interface is essentially just an extension of the IOMMU API
> > > via domain->pgsize_bitmap.  intel-iommu mostly made the bitmask
> > > meaningless by reporting essentially PAGE_MASK, and we just expose
> > > the common version of that across potentially all the IOMMUs used by
> > > the domain, modulo minimum of PAGE_SIZE.  Thanks,
> >
> > ok. got it. do you think it's good to return this iommu page size when
> > turning on dirty page tracking? so when GET_BITMAP ioctl comes, we
> > don't need to quit if range.bitmap.pgsize != iommu_pgsize.
> > instead, the GET_BITMAP can success with iommu page size and qemu
> does
> > the bitmap conversion afterwards.
> 
> The bitmap is already expose to the user via
> vfio_iommu_type1_info.iova_pgsizes in the VFIO_IOMMU_GET_INFO ioctl.
> Our original intention was to allow the user to specify the dirty bitmap page
> size, which is still enabled in the ioctl via bitmap.pgsize, but for simplification
> we currently only support the smallest page size.  This could be something
> else we expose via the extension interface when more page sizes are
> supported.  Thanks,
> 
Ok. Got it .  Thanks

