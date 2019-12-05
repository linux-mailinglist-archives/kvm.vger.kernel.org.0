Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE9113BDC
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 07:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLEGlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 01:41:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbfLEGlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 01:41:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575528061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYykLxeRNbyvgufiP1yhUOFKxyTi8jvErN3SBjZGj7c=;
        b=TElHbqcrjtbyLdVE3oLfqGC+PPMCSpAFbW0VSvnL4nY4P00iaTC4gTq4W5znzBV5vzGaSJ
        H2x2Cz9Mu1YinAzqaq6mttnSUqVwIY5RqseW+9w41sMLuVoxBYX6aBUG/uvWX9XgvEdw0P
        ZIQ+ES683ZQteLCbAgxhWtNuO6CZNHU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-UHfvQywvMD2vF9lOKjgKrA-1; Thu, 05 Dec 2019 01:40:18 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CED88017DF;
        Thu,  5 Dec 2019 06:40:15 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A54B600F2;
        Thu,  5 Dec 2019 06:40:13 +0000 (UTC)
Date:   Wed, 4 Dec 2019 23:40:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
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
Message-ID: <20191204234012.25f6159e@x1.home>
In-Reply-To: <77538a77-91ec-8a60-1f87-3fc18bd1cfe4@nvidia.com>
References: <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
        <20191113130705.32c6b663@x1.home>
        <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
        <20191114140625.213e8a99@x1.home>
        <20191126005739.GA31144@joy-OptiPlex-7040>
        <20191203110412.055c38df@x1.home>
        <cce08ca5-79df-2839-16cd-15723b995c07@nvidia.com>
        <20191204113457.16c1316d@x1.home>
        <20191205012835.GB31791@joy-OptiPlex-7040>
        <fc7e8cf2-d5e6-0fe6-7466-7bdde55ff7d6@nvidia.com>
        <20191204225637.382db416@x1.home>
        <77538a77-91ec-8a60-1f87-3fc18bd1cfe4@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: UHfvQywvMD2vF9lOKjgKrA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Dec 2019 11:49:00 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 12/5/2019 11:26 AM, Alex Williamson wrote:
> > On Thu, 5 Dec 2019 11:12:23 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 12/5/2019 6:58 AM, Yan Zhao wrote:  
> >>> On Thu, Dec 05, 2019 at 02:34:57AM +0800, Alex Williamson wrote:  
> >>>> On Wed, 4 Dec 2019 23:40:25 +0530
> >>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>     
> >>>>> On 12/3/2019 11:34 PM, Alex Williamson wrote:  
> >>>>>> On Mon, 25 Nov 2019 19:57:39 -0500
> >>>>>> Yan Zhao <yan.y.zhao@intel.com> wrote:
> >>>>>>         
> >>>>>>> On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:  
> >>>>>>>> On Fri, 15 Nov 2019 00:26:07 +0530
> >>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>>>>            
> >>>>>>>>> On 11/14/2019 1:37 AM, Alex Williamson wrote:  
> >>>>>>>>>> On Thu, 14 Nov 2019 01:07:21 +0530
> >>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>>>>>>              
> >>>>>>>>>>> On 11/13/2019 4:00 AM, Alex Williamson wrote:  
> >>>>>>>>>>>> On Tue, 12 Nov 2019 22:33:37 +0530
> >>>>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>>>>>>>>                 
> >>>>>>>>>>>>> All pages pinned by vendor driver through vfio_pin_pages API should be
> >>>>>>>>>>>>> considered as dirty during migration. IOMMU container maintains a list of
> >>>>>>>>>>>>> all such pinned pages. Added an ioctl defination to get bitmap of such  
> >>>>>>>>>>>>
> >>>>>>>>>>>> definition
> >>>>>>>>>>>>                 
> >>>>>>>>>>>>> pinned pages for requested IO virtual address range.  
> >>>>>>>>>>>>
> >>>>>>>>>>>> Additionally, all mapped pages are considered dirty when physically
> >>>>>>>>>>>> mapped through to an IOMMU, modulo we discussed devices opting in to
> >>>>>>>>>>>> per page pinning to indicate finer granularity with a TBD mechanism to
> >>>>>>>>>>>> figure out if any non-opt-in devices remain.
> >>>>>>>>>>>>                 
> >>>>>>>>>>>
> >>>>>>>>>>> You mean, in case of device direct assignment (device pass through)?  
> >>>>>>>>>>
> >>>>>>>>>> Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
> >>>>>>>>>> pinned and mapped, then the correct dirty page set is all mapped pages.
> >>>>>>>>>> We discussed using the vpfn list as a mechanism for vendor drivers to
> >>>>>>>>>> reduce their migration footprint, but we also discussed that we would
> >>>>>>>>>> need a way to determine that all participants in the container have
> >>>>>>>>>> explicitly pinned their working pages or else we must consider the
> >>>>>>>>>> entire potential working set as dirty.
> >>>>>>>>>>              
> >>>>>>>>>
> >>>>>>>>> How can vendor driver tell this capability to iommu module? Any suggestions?  
> >>>>>>>>
> >>>>>>>> I think it does so by pinning pages.  Is it acceptable that if the
> >>>>>>>> vendor driver pins any pages, then from that point forward we consider
> >>>>>>>> the IOMMU group dirty page scope to be limited to pinned pages?  There  
> >>>>>>> we should also be aware of that dirty page scope is pinned pages + unpinned pages,
> >>>>>>> which means ever since a page is pinned, it should be regarded as dirty
> >>>>>>> no matter whether it's unpinned later. only after log_sync is called and
> >>>>>>> dirty info retrieved, its dirty state should be cleared.  
> >>>>>>
> >>>>>> Yes, good point.  We can't just remove a vpfn when a page is unpinned
> >>>>>> or else we'd lose information that the page potentially had been
> >>>>>> dirtied while it was pinned.  Maybe that vpfn needs to move to a dirty
> >>>>>> list and both the currently pinned vpfns and the dirty vpfns are walked
> >>>>>> on a log_sync.  The dirty vpfns list would be cleared after a log_sync.
> >>>>>> The container would need to know that dirty tracking is enabled and
> >>>>>> only manage the dirty vpfns list when necessary.  Thanks,
> >>>>>>         
> >>>>>
> >>>>> If page is unpinned, then that page is available in free page pool for
> >>>>> others to use, then how can we say that unpinned page has valid data?
> >>>>>
> >>>>> If suppose, one driver A unpins a page and when driver B of some other
> >>>>> device gets that page and he pins it, uses it, and then unpins it, then
> >>>>> how can we say that page has valid data for driver A?
> >>>>>
> >>>>> Can you give one example where unpinned page data is considered reliable
> >>>>> and valid?  
> >>>>
> >>>> We can only pin pages that the user has already allocated* and mapped
> >>>> through the vfio DMA API.  The pinning of the page simply locks the
> >>>> page for the vendor driver to access it and unpinning that page only
> >>>> indicates that access is complete.  Pages are not freed when a vendor
> >>>> driver unpins them, they still exist and at this point we're now
> >>>> assuming the device dirtied the page while it was pinned.  Thanks,
> >>>>
> >>>> Alex
> >>>>
> >>>> * An exception here is that the page might be demand allocated and the
> >>>>     act of pinning the page could actually allocate the backing page for
> >>>>     the user if they have not faulted the page to trigger that allocation
> >>>>     previously.  That page remains mapped for the user's virtual address
> >>>>     space even after the unpinning though.
> >>>>     
> >>>
> >>> Yes, I can give an example in GVT.
> >>> when a gem_object is allocated in guest, before submitting it to guest
> >>> vGPU, gfx cmds in its ring buffer need to be pinned into GGTT to get a
> >>> global graphics address for hardware access. At that time, we shadow
> >>> those cmds and pin pages through vfio pin_pages(), and submit the shadow
> >>> gem_object to physial hardware.
> >>> After guest driver thinks the submitted gem_object has completed hardware
> >>> DMA, it unnpinnd those pinned GGTT graphics memory addresses. Then in
> >>> host, we unpin the shadow pages through vfio unpin_pages.
> >>> But, at this point, guest driver is still free to access the gem_object
> >>> through vCPUs, and guest user space is probably still mapping an object
> >>> into the gem_object in guest driver.
> >>> So, missing the dirty page tracking for unpinned pages would cause
> >>> data inconsitency.
> >>>      
> >>
> >> If pages are accessed by guest through vCPUs, then RAM module in QEMU
> >> will take care of tracking those pages as dirty.
> >>
> >> All unpinned pages might not be used, so tracking all unpinned pages
> >> during VM or application life time would also lead to tracking lots of
> >> stale pages, even though they are not being used. Increasing number of
> >> not needed pages could also lead to increasing migration data leading
> >> increase in migration downtime.  
> > 
> > We can't rely on the vCPU also dirtying a page, the overhead is
> > unavoidable.  It doesn't matter if the migration is fast if it's
> > incorrect.  We only need to track unpinned dirty pages while the
> > migration is active and the tracking is flushed on each log_sync
> > callback.  Thanks,
> >   
> 
>  From Yan's comment, pasted below, I thought, need to track all unpinned 
> pages during application or VM's lifetime.
> 
>  > There we should also be aware of that dirty page scope is pinned   
> pages  > + unpinned pages, which means ever since a page is pinned, it 
> should
>  > be regarded as dirty no matter whether it's unpinned later.  
> 
> But if its about tracking pages which are unpinned "while the migration 
> is active", then that set would be less, will do this change.

When we first start a pre-copy, all RAM (including anything previously
pinned) is dirty anyway.  I believe the log_sync callback is only
intended to report pages dirtied since the migration was started, or
since the last log_sync callback.  We then assume that currently pinned
pages are constantly dirty and previously pinned pages are dirty until
we've reported them through log_sync.  Thanks,

Alex

