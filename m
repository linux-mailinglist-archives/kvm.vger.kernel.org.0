Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D09108965
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 08:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYHpX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 25 Nov 2019 02:45:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:32531 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfKYHpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 02:45:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 23:45:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,240,1571727600"; 
   d="scan'208";a="382728426"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2019 23:45:21 -0800
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 24 Nov 2019 23:45:21 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 24 Nov 2019 23:45:21 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.215]) with mapi id 14.03.0439.000;
 Mon, 25 Nov 2019 15:45:19 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Topic: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables)
 to host
Thread-Index: AQHVimn49qwPncOwpUK3oA3gYR4tBqd/6QGAgAdz7JCAAASEAIABX3gg//++iYCAEx7LIA==
Date:   Mon, 25 Nov 2019 07:45:18 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A10D40B@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
 <1571919983-3231-4-git-send-email-yi.l.liu@intel.com>
 <20191107162041.31e620a4@x1.home>
 <A2975661238FB949B60364EF0F2C25743A0F6894@SHSMSX104.ccr.corp.intel.com>
 <20191112102534.75968ccd@x1.home>
 <A2975661238FB949B60364EF0F2C25743A0F8A70@SHSMSX104.ccr.corp.intel.com>
 <20191113102913.GA40832@lophozonia>
In-Reply-To: <20191113102913.GA40832@lophozonia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzU5MzZlYjgtNzg1Zi00OGE3LTlhNWEtOWQ5MGJjYzk0NjU0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSFpSTXFqN1BObFJNa1VobjZBZHhwb2pZS1ZuWjN1R01LVXV0bHIxTnhmT0hoOWdBUVR4VmtHeEhcL2psYTFcL00xIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Thanks for the review. Here I'd like to conclude the major opens in this
thread and see if we can get some agreements to prepare a new version.

a) IOCTLs for BIND_GPASID and BIND_PROCESS, share a single IOCTL or two
   separate IOCTLs?
   Yi: It may be helpful to have separate IOCTLs. The bind data conveyed
   for BIND_GPASID and BIND_PROCESS are totally different, and the struct
   iommu_gpasid_bind_data has vendor specific data and may even have more
   versions in future. To better maintain it, I guess separate IOCTLs for
   the two bind types would be better. The structure for BIND_GPASID is
   as below:

        struct vfio_iommu_type1_bind {
                __u32                           argsz;
                struct iommu_gpasid_bind_data   bind_data;
        };

b) how kernel-space learns the number of bytes to be copied (a.k.a. the
   usage of @version field and @format field of struct
   iommu_gpasid_bind_data)
   Yi: Jean has an excellent recap in prior reply on the plan of future
   extensions regards to @version field and @format field. Based on the
   plan, kernel space needs to parse the @version field and @format field
   to get the length of the current BIND_GPASID request. Also kernel needs
   to maintain the new and old structure versions. Follow specific
   deprecation policy in future.

c) how can vIOMMU emulator know that the vfio interface supports to config
   dual stage translation for vIOMMU?
   Yi: may do it via VFIO_IOMMU_GET_INFO.

d) how can vIOMMU emulator know what @version and @format should be set
   in struct iommu_gpasid_bind_data?
   Yi: currently, we have two ways. First one, may do it via
   VFIO_IOMMU_GET_INFO. This is a natural idea as here @version and @format
   are used in vfio apis. It makes sense to let vfio to provide related info
   to vIOMMU emulator after checking with vendor specific iommu driver. Also,
   there is idea to do it via sysfs (/sys/class/iommu/dmar#) as we have plan
   to do IOMMU capability sync between vIOMMU and pIOMMU via sysfs. I have
   two concern on this option. Current iommu sysfs only provides vendor
   specific hardware infos. I'm not sure if it is good to expose infos
   defined in IOMMU generic layer via iommu sysfs. If this concern is not
   a big thing, I'm fine with both options.

Thoughts? Would also be happy to know more from you guys.

Regards,
Yi Liu

> From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
> Sent: Wednesday, November 13, 2019 6:29 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> 
> On Wed, Nov 13, 2019 at 07:43:43AM +0000, Liu, Yi L wrote:
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, November 13, 2019 1:26 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to host
> > >
> > > On Tue, 12 Nov 2019 11:21:40 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Alex Williamson < alex.williamson@redhat.com >
> > > > > Sent: Friday, November 8, 2019 7:21 AM
> > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Subject: Re: [RFC v2 3/3] vfio/type1: bind guest pasid (guest page tables) to
> host
> > > > >
> > > > > On Thu, 24 Oct 2019 08:26:23 -0400
> > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > This patch adds vfio support to bind guest translation structure
> > > > > > to host iommu. VFIO exposes iommu programming capability to user-
> > > > > > space. Guest is a user-space application in host under KVM solution.
> > > > > > For SVA usage in Virtual Machine, guest owns GVA->GPA translation
> > > > > > structure. And this part should be passdown to host to enable nested
> > > > > > translation (or say two stage translation). This patch reuses the
> > > > > > VFIO_IOMMU_BIND proposal from Jean-Philippe Brucker, and adds new
> > > > > > bind type for binding guest owned translation structure to host.
> > > > > >
> > > > > > *) Add two new ioctls for VFIO containers.
> > > > > >
> > > > > >   - VFIO_IOMMU_BIND: for bind request from userspace, it could be
> > > > > >                    bind a process to a pasid or bind a guest pasid
> > > > > >                    to a device, this is indicated by type
> > > > > >   - VFIO_IOMMU_UNBIND: for unbind request from userspace, it could be
> > > > > >                    unbind a process to a pasid or unbind a guest pasid
> > > > > >                    to a device, also indicated by type
> > > > > >   - Bind type:
> > > > > > 	VFIO_IOMMU_BIND_PROCESS: user-space request to bind a
> process
> > > > > >                    to a device
> > > > > > 	VFIO_IOMMU_BIND_GUEST_PASID: bind guest owned translation
> > > > > >                    structure to host iommu. e.g. guest page table
> > > > > >
> > > > > > *) Code logic in vfio_iommu_type1_ioctl() to handle
> > > VFIO_IOMMU_BIND/UNBIND
> > > > > >
> > [...]
> > > > > > +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> > > > > > +					    void __user *arg,
> > > > > > +					    struct vfio_iommu_type1_bind
> *bind)
> > > > > > +{
> > > > > > +	struct iommu_gpasid_bind_data gbind_data;
> > > > > > +	unsigned long minsz;
> > > > > > +	int ret = 0;
> > > > > > +
> > > > > > +	minsz = sizeof(*bind) + sizeof(gbind_data);
> > > > > > +	if (bind->argsz < minsz)
> > > > > > +		return -EINVAL;
> > > > >
> > > > > But gbind_data can change size if new vendor specific data is added to
> > > > > the union, so kernel updates break existing userspace.  Fail.
> 
> I guess we could take minsz up to the vendor-specific data, copy @format,
> and then check the size of vendor-specific data?
> 
> > > >
> > > > yes, we have a version field in struct iommu_gpasid_bind_data. How
> > > > about doing sanity check per versions? kernel knows the gbind_data
> > > > size of specific versions. Does it make sense? If yes, I'll also apply it
> > > > to the other sanity check in this series to avoid userspace fail after
> > > > kernel update.
> > >
> > > Has it already been decided that the version field will be updated for
> > > every addition to the union?
> >
> > No, just my proposal. Jacob may help to explain the purpose of version
> > field. But if we may be too  "frequent" for an uapi version number updating
> > if we inc version for each change in the union part. I may vote for the
> > second option from you below.
> >
> > > It seems there are two options, either
> > > the version definition includes the possible contents of the union,
> > > which means we need to support multiple versions concurrently in the
> > > kernel to maintain compatibility with userspace and follow deprecation
> > > protocols for removing that support, or we need to consider version to
> > > be the general form of the structure and interpret the format field to
> > > determine necessary length to copy from the user.
> >
> > As I mentioned above, may be better to let @version field only over the
> > general fields and let format to cover the possible changes in union. e.g.
> > IOMMU_PASID_FORMAT_INTEL_VTD2 may means version 2 of Intel
> > VT-d bind. But either way, I think we need to let kernel maintain multiple
> > versions to support compatible userspace. e.g. may have multiple versions
> > iommu_gpasid_bind_data_vtd struct in the union part.
> 
> I couldn't find where the @version field originated in our old
> discussions, but I believe our plan for allowing future extensions was:
> 
> * Add new vendor-specific data by introducing a new format
>   (IOMMU_PASID_FORMAT_INTEL_VTD2,
> IOMMU_PASID_FORMAT_ARM_SMMUV2...), and
>   extend the union.
> 
> * Add a new common field, if it fits in the existing padding bytes, by
>   adding a flag (IOMMU_SVA_GPASID_*).
> 
> * Add a new common field, if it doesn't fit in the current padding bytes,
>   or completely change the structure layout, by introducing a new version
>   (IOMMU_GPASID_BIND_VERSION_2). In that case the kernel has to handle
>   both new and old structure versions. It would have both
>   iommu_gpasid_bind_data and iommu_gpasid_bind_data_v2 structs.
> 
> I think iommu_cache_invalidate_info and iommu_page_response use the same
> scheme. iommu_fault is a bit more complicated because it's
> kernel->userspace and requires some negotiation:
> https://lore.kernel.org/linux-iommu/77405d39-81a4-d9a8-5d35-
> 27602199867a@arm.com/
> 
> [...]
> > > If the ioctls have similar purpose and form, then re-using a single
> > > ioctl might make sense, but BIND_PROCESS is only a place-holder in this
> > > series, which is not acceptable.  A dual purpose ioctl does not
> > > preclude that we could also use a union for the data field to make the
> > > structure well specified.
> >
> > yes, BIND_PROCESS is only a place-holder here. From kernel p.o.v., both
> > BIND_GUEST_PASID and BIND_PROCESS are bind requests from userspace.
> > So the purposes are aligned. Below is the content the @data[] field
> > supposed to convey for BIND_PROCESS. If we use union, it would leave
> > space for extending it to support BIND_PROCESS. If only data[], it is a little
> > bit confusing why we define it in such manner if BIND_PROCESS is included
> > in this series. Please feel free let me know which one suits better.
> >
> > +struct vfio_iommu_type1_bind_process {
> > +	__u32	flags;
> > +#define VFIO_IOMMU_BIND_PID		(1 << 0)
> > +	__u32	pasid;
> > +	__s32	pid;
> > +};
> > https://patchwork.kernel.org/patch/10394927/
> 
> Note that I don't plan to upstream BIND_PROCESS at the moment. It was
> useful for testing but I don't know of anyone actually needing it.
> 
> > > > > That bind data
> > > > > structure expects a format (ex. IOMMU_PASID_FORMAT_INTEL_VTD).  How
> > > does
> > > > > a user determine what formats are accepted from within the vfio API (or
> > > > > even outside of the vfio API)?
> > > >
> > > > The info is provided by vIOMMU emulator (e.g. virtual VT-d). The vSVA patch
> > > > from Jacob has a sanity check on it.
> > > > https://lkml.org/lkml/2019/10/28/873
> > >
> > > The vIOMMU emulator runs at a layer above vfio.  How does the vIOMMU
> > > emulator know that the vfio interface supports virtual VT-d?  IMO, it's
> > > not acceptable that the user simply assume that an Intel host platform
> > > supports VT-d.  For example, consider what happens when we need to
> > > define IOMMU_PASID_FORMAT_INTEL_VTDv2.  How would the user learn that
> > > VTDv2 is supported and the original VTD format is not supported?
> >
> > I guess this may be another info VFIO_IOMMU_GET_INFO should provide.
> > It makes sense that vfio be aware of what platform it is running on. right?
> > After vfio gets the info, may let vfio fill in the format info. Is it the correct
> > direction?
> 
> I thought you were planning to put that information in sysfs?  We last
> discussed this over a year ago so I don't remember where we left it. I
> know Alex isn't keen on putting in sysfs what can be communicated through
> VFIO, but it is a convenient way to describe IOMMU features:
> http://www.linux-arm.org/git?p=linux-
> jpb.git;a=commitdiff;h=665370d5b5e0022c24b2d2b57975ef6fe7b40870;hp=7ce780
> d838889b53f5e04ba5d444520621261eda
> 
> My problem with GET_INFO was that it could be difficult to extend, and
> to describe things like variable-size list of supported page table
> formats, but I guess the new info capabilities make this easier.
> 
> Thanks,
> Jean
