Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764AE57E65
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfF0IkH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Jun 2019 04:40:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:57246 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0IkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:40:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 01:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="245743492"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 27 Jun 2019 01:40:05 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 01:40:05 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 01:40:05 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.87]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.225]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 16:40:03 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH v3 1/4] vfio: Define device specific irq type
 capability
Thread-Topic: [RFC PATCH v3 1/4] vfio: Define device specific irq type
 capability
Thread-Index: AQHVLJqY892xL/jYXUCHg0oNNo51Q6auXGaAgADSDfA=
Date:   Thu, 27 Jun 2019 08:40:03 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC876835C6@SHSMSX101.ccr.corp.intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
        <20190627033802.1663-2-tina.zhang@intel.com>
 <20190626220739.578c518b@x1.home>
In-Reply-To: <20190626220739.578c518b@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTAyNTlkNDctMGNhZC00Y2Q4LWI3OGUtODYyODM4MzBkZDkyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQThXNStVZE1cL2ViRzJFRXVRa0pwbVZSVjdXY2Z5bTQ3UEhlUmVPdUU1MVczWmlCTEVRZmJ1dnpEcmh0bFZvdEgifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
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
> Sent: Thursday, June 27, 2019 12:08 PM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; kraxel@redhat.com; zhenyuw@linux.intel.com; Lv,
> Zhiyuan <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian,
> Kevin <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> Subject: Re: [RFC PATCH v3 1/4] vfio: Define device specific irq type
> capability
> 
> On Thu, 27 Jun 2019 11:37:59 +0800
> Tina Zhang <tina.zhang@intel.com> wrote:
> 
> > Cap the number of irqs with fixed indexes and use capability chains to
> > chain device specific irqs.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > ---
> >  include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 02bb7ad6e986..600784acc4ac 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -444,11 +444,27 @@ struct vfio_irq_info {
> >  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
> >  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
> >  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> > +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info
> supports caps */
> >  	__u32	index;		/* IRQ index */
> > +	__u32	cap_offset;	/* Offset within info struct of first cap */
> >  	__u32	count;		/* Number of IRQs within this index */
> >  };
> 
> 
> This cannot be inserted into the middle of the structure, it breaks
> compatibility with all existing userspace binaries.  I must be added to the end
> of the structure.
Indeed. Thanks.

BR,
Tina
> 
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

