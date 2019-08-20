Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859A095414
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfHTCMP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 19 Aug 2019 22:12:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:56067 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbfHTCMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 22:12:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 19:12:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="183045244"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 19 Aug 2019 19:12:13 -0700
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 19:12:13 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX114.amr.corp.intel.com (10.18.116.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 19 Aug 2019 19:12:12 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.80]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.65]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 10:12:11 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Thread-Topic: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
Thread-Index: AQHVU9tUpO+/ySaKfEaxbwCEdeDfRab9uwQAgAWEU9A=
Date:   Tue, 20 Aug 2019 02:12:10 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC876F9AD3@SHSMSX101.ccr.corp.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
        <20190816023528.30210-3-tina.zhang@intel.com>
 <20190816145148.307408dc@x1.home>
In-Reply-To: <20190816145148.307408dc@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTNmZWI2YzMtZDBhNy00ZmFhLTlmZGItMGY2YmQzMDQ3YjIxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieENzdFN2UVk0WVo3cmtzTGIzNit3bEV5eVQrTzNObkdPZ05VS1lVMFZcL1hud0k1Z3diQkJSUXVVbFZSYUhcL0pVIn0=
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
> <hang.yuan@intel.com>; Lv, Zhiyuan <zhiyuan.lv@intel.com>
> Subject: Re: [PATCH v5 2/6] vfio: Introduce vGPU display irq type
> 
> On Fri, 16 Aug 2019 10:35:24 +0800
> Tina Zhang <tina.zhang@intel.com> wrote:
> 
> > Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> > VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display.
> >
> > Introduce vfio_irq_info_cap_display_plane_events capability to notify
> > user space with the vGPU's plane update events
> >
> > v2:
> > - Add VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ description. (Alex & Kechen)
> > - Introduce vfio_irq_info_cap_display_plane_events. (Gerd & Alex)
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > ---
> >  include/uapi/linux/vfio.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index d83c9f136a5b..21ac69f0e1a9 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -465,6 +465,27 @@ struct vfio_irq_info_cap_type {
> >  	__u32 subtype;  /* type specific */
> >  };
> >
> > +#define VFIO_IRQ_TYPE_GFX				(1)
> > +/*
> > + * vGPU vendor sub-type
> > + * vGPU device display related interrupts e.g. vblank/pageflip  */
> > +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
> 
> If this is a GFX/DISPLAY IRQ, why are we talking about a "vGPU" in the
> description?  It's not specific to a vGPU implementation, right?  Is this
> related to a physical display or a virtual display?  If it's related to the GFX
> PLANE ioctls, it should state that.  It's not well specified what this interrupt
> signals.  Is it vblank?  Is it pageflip?
> Is it both?  Neither?  Something else?

Sorry for the confusion caused here. 

The original idea here was to use VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ to notify user space with the display refresh event. The display refresh event is general. When notified, user space can use VFIO_DEVICE_QUERY_GFX_PLANE and VFIO_DEVICE_GET_GFX_DMABUF to get the updated framebuffer, instead of polling them all the time.

In order to give user space more choice to do the optimization, vfio_irq_info_cap_display_plane_events is proposed to tell user space the different plane refresh event values. So when notified by VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ, user space can get the value of the eventfd counter and understand which plane the event refresh event comes from and choose to get the framebuffer on that plane instead of all the planes.

So, from the VFIO user point of view, there is only the display refresh event (i.e. no other events like vblank, pageflip ...). For GTV-g, this display refresh event is implemented by both vblank and pageflip, which is only the implementation thing and can be transparent to the user space. Again sorry about the confusion cased here, I'll correct the comments in the next version.

BTW, IIRC, we might also have one question waiting to be replied:
- Can we just use VFIO_IRQ_TYPE_GFX w/o proposing a new sub type (i.e. VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ)?
    Well, only if we can agree on that we don't have any other GFX IRQ requirements in future. Otherwise, we might need a sub type to differentiate them.

Thanks.

BR,
Tina
> 
> > +
> > +/*
> > + * Display capability of using one eventfd to notify user space with
> > +the
> > + * vGPU's plane update events.
> > + * cur_event_val: eventfd value stands for cursor plane change event.
> > + * pri_event_val: eventfd value stands for primary plane change event.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_DISPLAY	4
> > +
> > +struct vfio_irq_info_cap_display_plane_events {
> > +	struct vfio_info_cap_header header;
> > +	__u64 cur_event_val;
> > +	__u64 pri_event_val;
> > +};
> 
> Again, what display?  Does this reference a GFX plane?  The event_val data is
> not well specified, examples might be necessary.  They seem to be used as a
> flag bit, so should we simply define a bit index for the flag rather than a u64
> value?  Where are the actual events per plane defined?
> 
> I'm not sure this patch shouldn't be rolled back into 1, I couldn't find the
> previous discussion that triggered it to be separate.  Perhaps simply for
> sharing with the work Eric is doing?  If so, that's fine, but maybe make note
> of it in the cover letter.  Thanks,
> 
> Alex
