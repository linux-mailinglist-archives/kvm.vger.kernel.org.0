Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98BBD70ED9
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 03:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbfGWBy6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 22 Jul 2019 21:54:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:16022 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfGWBy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 21:54:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jul 2019 18:54:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,297,1559545200"; 
   d="scan'208";a="192911251"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jul 2019 18:54:56 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jul 2019 18:54:56 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jul 2019 18:54:56 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.134]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.60]) with mapi id 14.03.0439.000;
 Tue, 23 Jul 2019 09:54:54 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Lu, Kechen" <kechen.lu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Thread-Topic: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Thread-Index: AQHVPT54hV4tNMEB+k2gOpC4yrLztKbRnH8AgAP/hYCAAO5GAIAA1wdg//+HKACAAI378A==
Date:   Tue, 23 Jul 2019 01:54:54 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC876BCAAE@SHSMSX101.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
        <20190718155640.25928-3-kechen.lu@intel.com>
        <20190719102516.60af527f@x1.home>
        <31185F57AF7C4B4F87C41E735C23A6FE64E06F@shsmsx102.ccr.corp.intel.com>
        <20190722134124.16c55c2f@x1.home>
        <237F54289DF84E4997F34151298ABEBC876BC9AD@SHSMSX101.ccr.corp.intel.com>
 <20190722191830.425d1593@x1.home>
In-Reply-To: <20190722191830.425d1593@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2UwMjFiNjEtZDlhMC00NWM2LTgxNGItMDdjYmFiOGE2ZGMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWnR2Q3g0djluaVpMT0lrVmgrM2JYbU1oNUFhSG9XZXZzbnpLZEtaaExkZit0V2h0ems5K2lEalNjNmtcL1FrUEwifQ==
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
> Sent: Tuesday, July 23, 2019 9:19 AM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: Lu, Kechen <kechen.lu@intel.com>; intel-gvt-dev@lists.freedesktop.org;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; kraxel@redhat.com;
> zhenyuw@linux.intel.com; Lv, Zhiyuan <zhiyuan.lv@intel.com>; Wang, Zhi A
> <zhi.a.wang@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Yuan, Hang
> <hang.yuan@intel.com>
> Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
> 
> On Tue, 23 Jul 2019 01:08:19 +0000
> "Zhang, Tina" <tina.zhang@intel.com> wrote:
> 
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Tuesday, July 23, 2019 3:41 AM
> > > To: Lu, Kechen <kechen.lu@intel.com>
> > > Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> > > kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan
> > > <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian,
> > > Kevin <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> > > Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq
> > > type
> > >
> > > On Mon, 22 Jul 2019 05:28:35 +0000
> > > "Lu, Kechen" <kechen.lu@intel.com> wrote:
> > >
> > > > Hi,
> > > >
> > > > > -----Original Message-----
> > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > Sent: Saturday, July 20, 2019 12:25 AM
> > > > > To: Lu, Kechen <kechen.lu@intel.com>
> > > > > Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org;
> > > > > linux- kernel@vger.kernel.org; Zhang, Tina
> > > > > <tina.zhang@intel.com>; kraxel@redhat.com;
> > > > > zhenyuw@linux.intel.com; Lv, Zhiyuan <zhiyuan.lv@intel.com>;
> > > > > Wang, Zhi A <zhi.a.wang@intel.com>; Tian, Kevin
> > > > > <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>
> > > > > Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq
> > > > > type
> > > > >
> > > > > On Thu, 18 Jul 2019 23:56:36 +0800 Kechen Lu
> > > > > <kechen.lu@intel.com> wrote:
> > > > >
> > > > > > From: Tina Zhang <tina.zhang@intel.com>
> > > > > >
> > > > > > Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> > > > > > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU
> > > > > > display
> > > > > >
> > > > > > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > > > > > ---
> > > > > >  include/uapi/linux/vfio.h | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/vfio.h
> > > > > > b/include/uapi/linux/vfio.h index be6adab4f759..df28b17a6e2e
> > > > > > 100644
> > > > > > --- a/include/uapi/linux/vfio.h
> > > > > > +++ b/include/uapi/linux/vfio.h
> > > > > > @@ -469,6 +469,9 @@ struct vfio_irq_info_cap_type {
> > > > > >  	__u32 subtype;  /* type specific */  };
> > > > > >
> > > > > > +#define VFIO_IRQ_TYPE_GFX				(1)
> > > > > > +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
> > > > > > +
> > > > >
> > > > > Please include a description defining exactly what this IRQ is
> > > > > intended to
> > > signal.
> > > > > For instance, if another vGPU vendor wanted to implement this in
> > > > > their driver and didn't have the QEMU code for reference to what
> > > > > it does with the IRQ, what would they need to know?  Thanks,
> > > > >
> > > > > Alex
> > > > >
> > > >
> > > > Yes, that makes more sense. I'll add the description for it at
> > > > next version
> > > patch.
> > > >
> > > > BTW, may I have one more question? In the current design ideas, we
> > > > partitioned the vGPU display eventfd counted 8-byte value into at
> > > > most
> > > > 8 events to deliver multiple display events, so we need different
> > > > increasement counter value to differentiate the events. As this is
> > > > the exposed thing the QEMU has to know, we plan adds a macro here
> > > > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_EVENTFD_BASE_SHIFT to make sure
> > > the
> > > > partitions shift in 1 byte, does it make sense putting here?
> > > > Looking forward
> > > to your and Gerd's comments. Thanks!
> > >
> > > Couldn't you expose this as another capability within the IRQ_INFO
> > > return data?  If you were to define it as a macro, I assume that
> > > means it would be hard coded, in which case this probably becomes an
> > > Intel specific IRQ, rather than what appears to be framed as a
> > > generic graphics IRQ extension.  A new capability could instead
> > > allow the vendor to specify their own value, where we could define how
> userspace should interpret and make use of this value.
> > > Thanks,
> > Good suggestion. Currently, vfio_irq_info is used to save one irq
> > info. What we need here is to use it to save several events info.
> > Maybe we could figure out a general layout of this capability so that
> > it can be leveraged by others, not only for display irq/events.
> 
> You could also expose a device specific IRQ with count > 1 (ie. similar to
> MSI/X) and avoid munging the eventfd value, which is not something we do
> elsewhere, at least in vfio.  Thanks,
Actually, we had this implementation before. At that time, we got the suggestion that count > 1 means more than one eventfd which might be not necessary.
Anyway, we can consider the "count > 1" again if anyone is agree on this. Thanks

BR,
Tina

> 
> Alex
