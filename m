Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4F614EBD5
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 12:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgAaLmK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 31 Jan 2020 06:42:10 -0500
Received: from mga18.intel.com ([134.134.136.126]:2835 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgAaLmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 06:42:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 03:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,385,1574150400"; 
   d="scan'208";a="233379394"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 31 Jan 2020 03:42:09 -0800
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 03:42:09 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 03:42:08 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.202]) with mapi id 14.03.0439.000;
 Fri, 31 Jan 2020 19:42:07 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
Thread-Topic: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
Thread-Index: AQHV1p1Ior1b1toJXUar/sR4t0nROqgDokMAgADaZHA=
Date:   Fri, 31 Jan 2020 11:42:06 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1992F1@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-3-git-send-email-yi.l.liu@intel.com>
 <20200131035914.GF15210@umbus.fritz.box>
In-Reply-To: <20200131035914.GF15210@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDVhYTM4OWMtMTk4Zi00Y2Q5LWIxNGYtN2E0ZjczZjY3NDdmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicmJJM2tSdGw2NHpXTENaeWdKNnVcL0xTSkxSbmwxdkNQRTY3dWc3d3NWd2tEbGZXditDb1FqQzl4bGNFZkg0RncifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

> From: David Gibson [mailto:david@gibson.dropbear.id.au]
> Sent: Friday, January 31, 2020 11:59 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
> 
> On Wed, Jan 29, 2020 at 04:16:33AM -0800, Liu, Yi L wrote:
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > Currently, many platform vendors provide the capability of dual stage
> > DMA address translation in hardware. For example, nested translation
> > on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> > and etc. In dual stage DMA address translation, there are two stages
> > address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> > second-level) translation structures. Stage-1 translation results are
> > also subjected to stage-2 translation structures. Take vSVA (Virtual
> > Shared Virtual Addressing) as an example, guest IOMMU driver owns
> > stage-1 translation structures (covers GVA->GPA translation), and host
> > IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> > translation). VMM is responsible to bind stage-1 translation structures
> > to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> > translation. For more background on SVA, refer the below links.
> >  - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
> >  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> > Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
> >
> > As above, dual stage DMA translation offers two stage address mappings,
> > which could have better DMA address translation support for passthru
> > devices. This is also what vIOMMU developers are doing so far. Efforts
> > includes vSVA enabling from Yi Liu and SMMUv3 Nested Stage Setup from
> > Eric Auger.
> > https://www.spinics.net/lists/kvm/msg198556.html
> > https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg02842.html
> >
> > Both efforts are aiming to expose a vIOMMU with dual stage hardware
> > backed. As so, QEMU needs to have an explicit object to stand for
> > the dual stage capability from hardware. Such object offers abstract
> > for the dual stage DMA translation related operations, like:
> >
> >  1) PASID allocation (allow host to intercept in PASID allocation)
> >  2) bind stage-1 translation structures to host
> >  3) propagate stage-1 cache invalidation to host
> >  4) DMA address translation fault (I/O page fault) servicing etc.
> >
> > This patch introduces DualStageIOMMUObject to stand for the hardware
> > dual stage DMA translation capability. PASID allocation/free are the
> > first operation included in it, in future, there will be more operations
> > like bind_stage1_pgtbl and invalidate_stage1_cache and etc.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> 
> Several overall queries about this:
> 
> 1) Since it's explicitly handling PASIDs, this seems a lot more
>    specific to SVM than the name suggests.  I'd suggest a rename.

It is not specific to SVM in future. We have efforts to move guest
IOVA support based on host IOMMU's dual-stage DMA translation
capability. Then, guest IOVA support will also re-use the methods
provided by this abstract layer. e.g. the bind_guest_pgtbl() and
flush_iommu_iotlb().

For the naming, how about HostIOMMUContext? This layer is to provide
explicit methods for setting up dual-stage DMA translation in host.

> 
> 2) Why are you hand rolling structures of pointers, rather than making
>    this a QOM class or interface and putting those things into methods?

Maybe the name is not proper. Although I named it as DualStageIOMMUObject,
it is actually a kind of abstract layer we discussed in previous email. I
think this is similar with VFIO_MAP/UNMAP. The difference is that VFIO_MAP/
UNMAP programs mappings to host iommu domain. While the newly added explicit
method is to link guest page table to host iommu domain. VFIO_MAP/UNMAP
is exposed to vIOMMU emulators via MemoryRegion layer. right? Maybe adding a
similar abstract layer is enough. Is adding QOM really necessary for this
case?

> 3) It's not really clear to me if this is for the case where both
>    stages of translation are visible to the guest, or only one of
>    them.

For this case, vIOMMU will only expose a single stage translation to VM.
e.g. Intel VT-d, vIOMMU exposes first-level translation to guest. Hardware
IOMMUs with the dual-stage translation capability lets guest own stage-1
translation structures and host owns the stage-2 translation structures.
VMM is responsible to bind guest's translation structures to host and
enable dual-stage translation. e.g. on Intel VT-d, config translation type
to be NESTED.

Take guest SVM as an example, guest iommu driver owns the gVA->gPA mappings,
which is treated as stage-1 translation from host point of view. Host itself
owns the gPA->hPPA translation and called stage-2 translation when dual-stage
translation is configured.

For guest IOVA, it is similar with guest SVM. Guest iommu driver owns the
gIOVA->gPA mappings, which is treated as stage-1 translation. Host owns the
gPA->hPA translation.

Regards,
Yi Liu
