Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832DA6E386
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 11:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGSJdv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 Jul 2019 05:33:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:19411 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfGSJdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 05:33:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 02:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="162357222"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2019 02:33:50 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:33:50 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:33:49 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.162]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 17:33:48 +0800
From:   "Lu, Kechen" <kechen.lu@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
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
        "Zhang, Tina" <tina.zhang@intel.com>
Subject: RE: [RFC PATCH v4 6/6] drm/i915/gvt: Add cursor plane reg update
 trap emulation handler
Thread-Topic: [RFC PATCH v4 6/6] drm/i915/gvt: Add cursor plane reg update
 trap emulation handler
Thread-Index: AQHVPT6GHpgHu0dxKUC491TWCC0KxabQ93+AgAC2oDA=
Date:   Fri, 19 Jul 2019 09:33:47 +0000
Message-ID: <31185F57AF7C4B4F87C41E735C23A6FE64DFF0@shsmsx102.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
 <20190718155640.25928-7-kechen.lu@intel.com>
 <20190719063443.GE28809@zhen-hp.sh.intel.com>
In-Reply-To: <20190719063443.GE28809@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTcxNDdkOGItY2Y2Zi00MDkxLWIwZTQtYTZiMjAyN2Y5YjVkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWGtqSEE0dkFIMTN4cVVmdlF5MnJYYVNFTUZNUHlPRnBzcUdnZDBvS0FmcW82Y0dsZG9ab3M5NVpkNDZPdFVteSJ9
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
> Sent: Friday, July 19, 2019 2:35 PM
> To: Lu, Kechen <kechen.lu@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux- 
> kernel@vger.kernel.org; kraxel@redhat.com; zhenyuw@linux.intel.com; 
> Lv, Zhiyuan <zhiyuan.lv@intel.com>; Wang, Zhi A 
> <zhi.a.wang@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Yuan, Hang 
> <hang.yuan@intel.com>; alex.williamson@redhat.com
> Subject: Re: [RFC PATCH v4 6/6] drm/i915/gvt: Add cursor plane reg 
> update trap emulation handler
> 
> On 2019.07.18 23:56:40 +0800, Kechen Lu wrote:
> > This patch adds the cursor plane CURBASE reg update trap handler in 
> > order to :
> >
> > - Deliver the cursor refresh event at each vblank emulation, the 
> > flip_done_event bit check is supposed to do here. If cursor plane 
> > updates happen, deliver the cursor refresh events.
> >
> > - Support the sync and async cursor plane updates and corresponding 
> > cursor plane flip interrupts reporting.
> >
> > Signed-off-by: Kechen Lu <kechen.lu@intel.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/display.c   | 11 +++++++++++
> >  drivers/gpu/drm/i915/gvt/handlers.c  | 27 
> > ++++++++++++++++++++++++--- drivers/gpu/drm/i915/gvt/interrupt.c |  
> > 7 +++++++ drivers/gpu/drm/i915/gvt/interrupt.h |  3 +++
> >  4 files changed, 45 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gvt/display.c
> > b/drivers/gpu/drm/i915/gvt/display.c
> > index df52e4b4c1b0..a0accc51d44f 100644
> > --- a/drivers/gpu/drm/i915/gvt/display.c
> > +++ b/drivers/gpu/drm/i915/gvt/display.c
> > @@ -399,6 +399,7 @@ static void emulate_vblank_on_pipe(struct 
> > intel_vgpu
> *vgpu, int pipe)
> >  		[PIPE_C] = PIPE_C_VBLANK,
> >  	};
> >  	int pri_flip_event = SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
> > +	int cur_flip_event = CURSOR_A_FLIP_DONE + pipe;
> >  	int event;
> >  	u64 eventfd_signal_val = 0;
> >  	static int pageflip_count;
> > @@ -417,6 +418,11 @@ static void emulate_vblank_on_pipe(struct
> intel_vgpu *vgpu, int pipe)
> >  			pageflip_count += PAGEFLIP_INC_COUNT;
> >  		}
> >
> > +		if (event == cur_flip_event) {
> > +			eventfd_signal_val +=
> DISPLAY_CUR_REFRESH_EVENT_INC;
> > +			pageflip_count += PAGEFLIP_INC_COUNT;
> > +		}
> > +
> >  		intel_vgpu_trigger_virtual_event(vgpu, event);
> >  	}
> >
> > @@ -430,6 +436,11 @@ static void emulate_vblank_on_pipe(struct
> intel_vgpu *vgpu, int pipe)
> >  			eventfd_signal_val +=
> DISPLAY_PRI_REFRESH_EVENT_INC;
> >  			pageflip_count += PAGEFLIP_INC_COUNT;
> >  		}
> > +
> > +		if (event == PLANE_CURSOR) {
> > +			eventfd_signal_val +=
> DISPLAY_CUR_REFRESH_EVENT_INC;
> > +			pageflip_count += PAGEFLIP_INC_COUNT;
> > +		}
> >  	}
> >
> >  	if (--pageflip_count < 0) {
> > diff --git a/drivers/gpu/drm/i915/gvt/handlers.c
> > b/drivers/gpu/drm/i915/gvt/handlers.c
> > index 6ad29c4f08e5..821ff88977d8 100644
> > --- a/drivers/gpu/drm/i915/gvt/handlers.c
> > +++ b/drivers/gpu/drm/i915/gvt/handlers.c
> > @@ -767,6 +767,27 @@ static int pri_surf_mmio_write(struct 
> > intel_vgpu
> *vgpu, unsigned int offset,
> >  	return 0;
> >  }
> >
> > +#define CURBASE_TO_PIPE(reg) \
> > +	calc_index(offset, _CURABASE, _CURBBASE, 0, CURBASE(PIPE_C))
> > +
> > +static int cur_surf_mmio_write(struct intel_vgpu *vgpu, unsigned int offset,
> > +		void *p_data, unsigned int bytes) {
> > +	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv;
> > +	u32 pipe = CURBASE_TO_PIPE(offset);
> > +	int event = CURSOR_A_FLIP_DONE + pipe;
> > +
> > +	write_vreg(vgpu, offset, p_data, bytes);
> > +
> > +	if (vgpu_vreg_t(vgpu, CURCNTR(pipe)) & PLANE_CTL_ASYNC_FLIP) {
> > +		intel_vgpu_trigger_virtual_event(vgpu, event);
> > +		set_bit(PLANE_CURSOR, vgpu->display.async_flip_event[pipe]);
> > +	} else
> > +		set_bit(event, vgpu->irq.flip_done_event[pipe]);
> > +
> > +	return 0;
> > +}
> > +
> >  #define SPRSURF_TO_PIPE(offset) \
> >  	calc_index(offset, _SPRA_SURF, _SPRB_SURF, 0, SPRSURF(PIPE_C))
> >
> > @@ -1955,9 +1976,9 @@ static int init_generic_mmio_info(struct 
> > intel_gvt
> *gvt)
> >  	MMIO_D(CURPOS(PIPE_B), D_ALL);
> >  	MMIO_D(CURPOS(PIPE_C), D_ALL);
> >
> > -	MMIO_D(CURBASE(PIPE_A), D_ALL);
> > -	MMIO_D(CURBASE(PIPE_B), D_ALL);
> > -	MMIO_D(CURBASE(PIPE_C), D_ALL);
> > +	MMIO_DH(CURBASE(PIPE_A), D_ALL, NULL, cur_surf_mmio_write);
> > +	MMIO_DH(CURBASE(PIPE_B), D_ALL, NULL, cur_surf_mmio_write);
> > +	MMIO_DH(CURBASE(PIPE_C), D_ALL, NULL, cur_surf_mmio_write);
> 
> I think we should also track cursor pos change right?
> 

Yes, this may be the case, according to the bspec, the CURPOS regs take into effects at vblanks. But in Linux i915 driver, the CURPOS regs programming companies with CURBASE regs. I'm not sure the Windows driver logic, but I can do some experiments. If that is the case, yes, we also need to trap the cursor pos change. 
Thanks.

Best Regards,
Kechen

> >
> >  	MMIO_D(CUR_FBC_CTL(PIPE_A), D_ALL);
> >  	MMIO_D(CUR_FBC_CTL(PIPE_B), D_ALL); diff --git 
> > a/drivers/gpu/drm/i915/gvt/interrupt.c
> > b/drivers/gpu/drm/i915/gvt/interrupt.c
> > index 951681813230..9c2b9d2e1529 100644
> > --- a/drivers/gpu/drm/i915/gvt/interrupt.c
> > +++ b/drivers/gpu/drm/i915/gvt/interrupt.c
> > @@ -113,6 +113,9 @@ static const char * const
> irq_name[INTEL_GVT_EVENT_MAX] = {
> >  	[SPRITE_A_FLIP_DONE] = "Sprite Plane A flip done",
> >  	[SPRITE_B_FLIP_DONE] = "Sprite Plane B flip done",
> >  	[SPRITE_C_FLIP_DONE] = "Sprite Plane C flip done",
> > +	[CURSOR_A_FLIP_DONE] = "Cursor Plane A flip done",
> > +	[CURSOR_B_FLIP_DONE] = "Cursor Plane B flip done",
> > +	[CURSOR_C_FLIP_DONE] = "Cursor Plane C flip done",
> >
> >  	[PCU_THERMAL] = "PCU Thermal Event",
> >  	[PCU_PCODE2DRIVER_MAILBOX] = "PCU pcode2driver mailbox event",
> @@
> > -593,6 +596,10 @@ static void gen8_init_irq(
> >  		SET_BIT_INFO(irq, 4, SPRITE_A_FLIP_DONE,
> INTEL_GVT_IRQ_INFO_DE_PIPE_A);
> >  		SET_BIT_INFO(irq, 4, SPRITE_B_FLIP_DONE,
> INTEL_GVT_IRQ_INFO_DE_PIPE_B);
> >  		SET_BIT_INFO(irq, 4, SPRITE_C_FLIP_DONE, 
> > INTEL_GVT_IRQ_INFO_DE_PIPE_C);
> > +
> > +		SET_BIT_INFO(irq, 6, CURSOR_A_FLIP_DONE,
> INTEL_GVT_IRQ_INFO_DE_PIPE_A);
> > +		SET_BIT_INFO(irq, 6, CURSOR_B_FLIP_DONE,
> INTEL_GVT_IRQ_INFO_DE_PIPE_B);
> > +		SET_BIT_INFO(irq, 6, CURSOR_C_FLIP_DONE, 
> > +INTEL_GVT_IRQ_INFO_DE_PIPE_C);
> >  	}
> >
> >  	/* GEN8 interrupt PCU events */
> > diff --git a/drivers/gpu/drm/i915/gvt/interrupt.h
> > b/drivers/gpu/drm/i915/gvt/interrupt.h
> > index 5313fb1b33e1..158f1c7a23f2 100644
> > --- a/drivers/gpu/drm/i915/gvt/interrupt.h
> > +++ b/drivers/gpu/drm/i915/gvt/interrupt.h
> > @@ -92,6 +92,9 @@ enum intel_gvt_event_type {
> >  	SPRITE_A_FLIP_DONE,
> >  	SPRITE_B_FLIP_DONE,
> >  	SPRITE_C_FLIP_DONE,
> > +	CURSOR_A_FLIP_DONE,
> > +	CURSOR_B_FLIP_DONE,
> > +	CURSOR_C_FLIP_DONE,
> >
> >  	PCU_THERMAL,
> >  	PCU_PCODE2DRIVER_MAILBOX,
> > --
> > 2.17.1
> >
> 
> --
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
