Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53526E30C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfGSJCi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 Jul 2019 05:02:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:19218 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfGSJCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 05:02:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 02:02:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="195888255"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jul 2019 02:02:36 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:02:36 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:02:36 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.60]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 17:02:34 +0800
From:   "Lu, Kechen" <kechen.lu@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Zhang, Tina" <tina.zhang@intel.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: RE: [RFC PATCH v4 1/6] vfio: Define device specific irq type
 capability
Thread-Topic: [RFC PATCH v4 1/6] vfio: Define device specific irq type
 capability
Thread-Index: AQHVPfh+laa+mTOUHUqdBIkmECCN6KbRmVnQ
Date:   Fri, 19 Jul 2019 09:02:33 +0000
Message-ID: <31185F57AF7C4B4F87C41E735C23A6FE64DFC7@shsmsx102.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
 <20190718155640.25928-2-kechen.lu@intel.com>
 <20190719060540.GC28809@zhen-hp.sh.intel.com>
In-Reply-To: <20190719060540.GC28809@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTA2Nzc3ZWUtZDM0Ny00MDhmLTk3OWYtMjRlYWExMjQwYjEyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicEVwaUZEbVBtSzBnYUpWMnY4clwvV201N2c0MlNWQlZZOTlSM0FlN2NNMElKb1g2VzVFUGVtVlNxSEp4MWJcL0JTIn0=
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

Hi,

> -----Original Message-----
> From: Zhenyu Wang [mailto:zhenyuw@linux.intel.com]
> Sent: Friday, July 19, 2019 2:06 PM
> To: Lu, Kechen <kechen.lu@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux- 
> kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>; 
> kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan 
> <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian, 
> Kevin <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>; 
> alex.williamson@redhat.com; Eric Auger <eric.auger@redhat.com>
> Subject: Re: [RFC PATCH v4 1/6] vfio: Define device specific irq type 
> capability
> 
> On 2019.07.18 23:56:35 +0800, Kechen Lu wrote:
> > From: Tina Zhang <tina.zhang@intel.com>
> >
> > Cap the number of irqs with fixed indexes and use capability chains 
> > to chain device specific irqs.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > ---
> >  include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h 
> > index 8f10748dac79..be6adab4f759 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -448,11 +448,27 @@ struct vfio_irq_info {
> >  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
> >  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
> >  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> > +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps
> */
> >  	__u32	index;		/* IRQ index */
> >  	__u32	count;		/* Number of IRQs within this index */
> > +	__u32	cap_offset;	/* Offset within info struct of first cap */
> 
> This still breaks ABI as argsz would be updated with this new field, 
> so it would cause compat issue. I think my last suggestion was to 
> assume cap list starts after vfio_irq_info.
>
 
In the common practice, the general logic is first use the "count" as the "minsz" boundary to perform copy from user, and then perform following logic, so that the incompatibility issue would not happen. BTW, this patch has been double checked by Eric Auger before included in his patch-set. 

Best Regards,
Kechen

> >  };
> >  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
> >
> > +/*
> > + * The irq type capability allows irqs unique to a specific device 
> > +or
> > + * class of devices to be exposed.
> > + *
> > + * The structures below define version 1 of this capability.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_TYPE      3
> > +
> > +struct vfio_irq_info_cap_type {
> > +	struct vfio_info_cap_header header;
> > +	__u32 type;     /* global per bus driver */
> > +	__u32 subtype;  /* type specific */ };
> > +
> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct
> vfio_irq_set)
> >   *
> > @@ -554,7 +570,8 @@ enum {
> >  	VFIO_PCI_MSIX_IRQ_INDEX,
> >  	VFIO_PCI_ERR_IRQ_INDEX,
> >  	VFIO_PCI_REQ_IRQ_INDEX,
> > -	VFIO_PCI_NUM_IRQS
> > +	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5 use
> */
> > +				/* device specific cap to define content */
> >  };
> >
> >  /*
> > --
> > 2.17.1
> >
> 
> --
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
