Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6CC6F8DF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 07:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfGVF2j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 22 Jul 2019 01:28:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:5444 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbfGVF2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 01:28:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jul 2019 22:28:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,293,1559545200"; 
   d="scan'208";a="163063514"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 21 Jul 2019 22:28:38 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 21 Jul 2019 22:28:37 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 21 Jul 2019 22:28:37 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.240]) with mapi id 14.03.0439.000;
 Mon, 22 Jul 2019 13:28:35 +0800
From:   "Lu, Kechen" <kechen.lu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Tina" <tina.zhang@intel.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Thread-Topic: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Thread-Index: AQHVPk6Tjcq5grzPBEGxRHokEzi0nabV959w
Date:   Mon, 22 Jul 2019 05:28:35 +0000
Message-ID: <31185F57AF7C4B4F87C41E735C23A6FE64E06F@shsmsx102.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
        <20190718155640.25928-3-kechen.lu@intel.com>
 <20190719102516.60af527f@x1.home>
In-Reply-To: <20190719102516.60af527f@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTQ3NTYyM2QtZWZmYy00Yzg5LTk3NWItM2E0OWRkNjc0YTAxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoib0pcL0ttdkRHOW1FZGVHQlo4Tko2WEZKNWEyMWRBNm4zSVhncnJCSk92azViVWZXZkhNbHZzV2RZVXRac1JzT04ifQ==
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
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Saturday, July 20, 2019 12:25 AM
> To: Lu, Kechen <kechen.lu@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan
> <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian, Kevin
> <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
> 
> On Thu, 18 Jul 2019 23:56:36 +0800
> Kechen Lu <kechen.lu@intel.com> wrote:
> 
> > From: Tina Zhang <tina.zhang@intel.com>
> >
> > Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > ---
> >  include/uapi/linux/vfio.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index be6adab4f759..df28b17a6e2e 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -469,6 +469,9 @@ struct vfio_irq_info_cap_type {
> >  	__u32 subtype;  /* type specific */
> >  };
> >
> > +#define VFIO_IRQ_TYPE_GFX				(1)
> > +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
> > +
> 
> Please include a description defining exactly what this IRQ is intended to signal.
> For instance, if another vGPU vendor wanted to implement this in their driver
> and didn't have the QEMU code for reference to what it does with the IRQ, what
> would they need to know?  Thanks,
> 
> Alex
> 

Yes, that makes more sense. I'll add the description for it at next version patch.

BTW, may I have one more question? In the current design ideas, we partitioned 
the vGPU display eventfd counted 8-byte value into at most 8 events to deliver 
multiple display events, so we need different increasement counter value to 
differentiate the events. As this is the exposed thing the QEMU has to know, we
plan adds a macro here VFIO_IRQ_SUBTYPE_GFX_DISPLAY_EVENTFD_BASE_SHIFT to
make sure the partitions shift in 1 byte, does it make sense putting here? Looking  
forward to your and Gerd's comments. Thanks!


Best Regards,
Kechen

> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct
> vfio_irq_set)
> >   *

