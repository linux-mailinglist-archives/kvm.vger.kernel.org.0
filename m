Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD32F952E3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 02:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfHTA5Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 19 Aug 2019 20:57:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:10636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbfHTA5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 20:57:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 17:57:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="189698451"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga002.jf.intel.com with ESMTP; 19 Aug 2019 17:57:01 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 17:57:00 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 17:57:00 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.80]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.249]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 08:56:58 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: RE: [PATCH v5 1/6] vfio: Define device specific irq type capability
Thread-Topic: [PATCH v5 1/6] vfio: Define device specific irq type capability
Thread-Index: AQHVU9tUIz4Q7mJ8IEmdvE8aJrot1ab9uvyAgAV/ddA=
Date:   Tue, 20 Aug 2019 00:56:58 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC876F9935@SHSMSX101.ccr.corp.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
        <20190816023528.30210-2-tina.zhang@intel.com>
 <20190816145141.6e56c6cb@x1.home>
In-Reply-To: <20190816145141.6e56c6cb@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWNmMmMzZWItMDVkNC00OTJiLTgxZTAtZDNjYjU4MDgwYTI0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUW91RGRwMHR6Y1lXeGtJUEE0M2szUDNxVWllUEJOTmI4Qkx1djlqSFkzejdHcGk2bFV0QmlnOXFsTWdFZDFrZSJ9
x-ctpclassification: CTP_NT
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
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Saturday, August 17, 2019 4:52 AM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kraxel@redhat.com;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Yuan, Hang
> <hang.yuan@intel.com>; Lv, Zhiyuan <zhiyuan.lv@intel.com>; Eric Auger
> <eric.auger@redhat.com>
> Subject: Re: [PATCH v5 1/6] vfio: Define device specific irq type capability
> 
> On Fri, 16 Aug 2019 10:35:23 +0800
> Tina Zhang <tina.zhang@intel.com> wrote:
> 
> > Cap the number of irqs with fixed indexes and use capability chains to
> > chain device specific irqs.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > ---
> >  include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 02bb7ad6e986..d83c9f136a5b 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -444,11 +444,27 @@ struct vfio_irq_info {
> >  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
> >  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
> >  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> > +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info
> supports caps */
> >  	__u32	index;		/* IRQ index */
> >  	__u32	count;		/* Number of IRQs within this index */
> > +	__u32	cap_offset;	/* Offset within info struct of first cap */
> >  };
> >  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE +
> 9)
> >
> > +/*
> > + * The irq type capability allows irqs unique to a specific device or
> > + * class of devices to be exposed.
> > + *
> > + * The structures below define version 1 of this capability.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_TYPE      3
> 
> Why 3?  What's using 1 and 2 of this newly defined info cap ID?  Thanks,
There was an assumption that there were two kinds of CAP_TYPE: VFIO_REGION_INFO_CAP_TYPE and VFIO_IRQ_INFO_CAP_TYPE. Since VFIO_REGION_INFO_CAP_TYPE was defined as 1, VFIO_IRQ_INFO_CAP_TYPE was defined after it.
OK. I see this isn't a good idea. Let's give VFIO_REGION_INFO_CAP_TYPE a new space. Thanks.

BR,
Tina
> 
> Alex
> 
> > +
> > +struct vfio_irq_info_cap_type {
> > +	struct vfio_info_cap_header header;
> > +	__u32 type;     /* global per bus driver */
> > +	__u32 subtype;  /* type specific */
> > +};
> > +
> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct
> vfio_irq_set)
> >   *
> > @@ -550,7 +566,8 @@ enum {
> >  	VFIO_PCI_MSIX_IRQ_INDEX,
> >  	VFIO_PCI_ERR_IRQ_INDEX,
> >  	VFIO_PCI_REQ_IRQ_INDEX,
> > -	VFIO_PCI_NUM_IRQS
> > +	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5
> use   */
> > +				/* device specific cap to define content */
> >  };
> >
> >  /*

