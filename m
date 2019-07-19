Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1CF6E370
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 11:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGSJ2X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 Jul 2019 05:28:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:62868 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbfGSJ2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 05:28:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 02:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="170853893"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 19 Jul 2019 02:28:17 -0700
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:28:17 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 02:28:17 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.3]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.240]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 17:28:15 +0800
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
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [RFC PATCH v4 4/6] drm/i915/gvt: Deliver vGPU refresh event to
 userspace
Thread-Topic: [RFC PATCH v4 4/6] drm/i915/gvt: Deliver vGPU refresh event to
 userspace
Thread-Index: AQHVPT6A8qFpiZNcy0C8TXdH1aP6kqbQ9LMAgACusVA=
Date:   Fri, 19 Jul 2019 09:28:15 +0000
Message-ID: <31185F57AF7C4B4F87C41E735C23A6FE64DFDF@shsmsx102.ccr.corp.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
 <20190718155640.25928-5-kechen.lu@intel.com>
 <20190719062442.GD28809@zhen-hp.sh.intel.com>
In-Reply-To: <20190719062442.GD28809@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWE0NWZkNTEtZjQyOS00MjdkLTk2N2UtOGQ4Y2YxNGNjYTg0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiazh2SkVIa1BjVXIzbkx3QXFvVHZaQkd6NWI1cWwzXC9ORjBpcGRONEdka2swYTRLelp1Ymo4XC9xOGhCXC80RU9BdCJ9
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
> Sent: Friday, July 19, 2019 2:25 PM
> To: Lu, Kechen <kechen.lu@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Zhang, Tina <tina.zhang@intel.com>;
> kraxel@redhat.com; zhenyuw@linux.intel.com; Lv, Zhiyuan
> <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian, Kevin
> <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>;
> alex.williamson@redhat.com
> Subject: Re: [RFC PATCH v4 4/6] drm/i915/gvt: Deliver vGPU refresh event to
> userspace
> 
> On 2019.07.18 23:56:38 +0800, Kechen Lu wrote:
> > From: Tina Zhang <tina.zhang@intel.com>
> >
> > Deliver the display refresh events to the user land. Userspace can use
> > the irq mask/unmask mechanism to disable or enable the event delivery.
> >
> > As we know, delivering refresh event at each vblank safely avoids
> > tearing and unexpected event overwhelming, but there are still spaces
> > to optimize.
> >
> > For handling the normal case, deliver the page flip refresh event at
> > each vblank, in other words, bounded by vblanks. Skipping some events
> > bring performance enhancement while not hurting user experience.
> >
> > For single framebuffer case, deliver the refresh events to userspace
> > at all vblanks. This heuristic at each vblank leverages pageflip_count
> > incresements to determine if there is no page flip happens after a
> > certain period and so that the case is regarded as single framebuffer one.
> > Although this heuristic makes incorrect decision sometimes and it
> > depends on guest behavior, for example, when no cursor movements
> > happen, the user experience does not harm and front buffer is still correctly
> acquired.
> > Meanwhile, in actual single framebuffer case, the user experience is
> > enhanced compared with page flip events only.
> >
> > Addtionally, to mitigate the events delivering footprints, one eventfd
> > and
> > 8 byte eventfd counter partition are leveraged.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > Signed-off-by: Kechen Lu <kechen.lu@intel.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/display.c |  21 ++++
> >  drivers/gpu/drm/i915/gvt/gvt.h     |   7 ++
> >  drivers/gpu/drm/i915/gvt/kvmgt.c   | 154 +++++++++++++++++++++++++++--
> >  3 files changed, 173 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gvt/display.c
> > b/drivers/gpu/drm/i915/gvt/display.c
> > index 1a0a4ae4826e..036db8199983 100644
> > --- a/drivers/gpu/drm/i915/gvt/display.c
> > +++ b/drivers/gpu/drm/i915/gvt/display.c
> > @@ -387,6 +387,8 @@ void intel_gvt_check_vblank_emulation(struct
> intel_gvt *gvt)
> >  	mutex_unlock(&gvt->lock);
> >  }
> >
> > +#define PAGEFLIP_INC_COUNT 5
> > +
> >  static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int pipe)
> > {
> >  	struct drm_i915_private *dev_priv = vgpu->gvt->dev_priv; @@ -396,7
> > +398,10 @@ static void emulate_vblank_on_pipe(struct intel_vgpu *vgpu, int
> pipe)
> >  		[PIPE_B] = PIPE_B_VBLANK,
> >  		[PIPE_C] = PIPE_C_VBLANK,
> >  	};
> > +	int pri_flip_event = SKL_FLIP_EVENT(pipe, PLANE_PRIMARY);
> >  	int event;
> > +	u64 eventfd_signal_val = 0;
> > +	static int pageflip_count;
> >
> >  	if (pipe < PIPE_A || pipe > PIPE_C)
> >  		return;
> > @@ -407,11 +412,27 @@ static void emulate_vblank_on_pipe(struct
> intel_vgpu *vgpu, int pipe)
> >  		if (!pipe_is_enabled(vgpu, pipe))
> >  			continue;
> >
> > +		if (event == pri_flip_event) {
> > +			eventfd_signal_val +=
> DISPLAY_PRI_REFRESH_EVENT_INC;
> > +			pageflip_count += PAGEFLIP_INC_COUNT;
> > +		}
> > +
> >  		intel_vgpu_trigger_virtual_event(vgpu, event);
> >  	}
> >
> > +	if (--pageflip_count < 0) {
> > +		eventfd_signal_val += DISPLAY_PRI_REFRESH_EVENT_INC;
> > +		pageflip_count = 0;
> > +	}
> 
> If pageflip_count has been increased to a big number from page flip event for
> some time, then if guest switch for single buffer render, it would take 5x vblank
> time to send refresh then..
> 

Yep. You are right. That could be the corner case. After discussing with Tina, we can change the pageflip_count to nopageflip_count using a changed heuristic to avoid this issue and bound the delay to begin refresh. 

> > +
> > +	if (vgpu->vdev.vblank_trigger && !(vgpu->vdev.display_event_mask
> > +		& (DISPLAY_PRI_REFRESH_EVENT |
> DISPLAY_CUR_REFRESH_EVENT)) &&
> > +		eventfd_signal_val)
> > +		eventfd_signal(vgpu->vdev.vblank_trigger, eventfd_signal_val);
> > +
> >  	if (pipe_is_enabled(vgpu, pipe)) {
> >  		vgpu_vreg_t(vgpu, PIPE_FRMCOUNT_G4X(pipe))++;
> > +
> >  		intel_vgpu_trigger_virtual_event(vgpu, vblank_event[pipe]);
> >  	}
> >  }
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.h
> > b/drivers/gpu/drm/i915/gvt/gvt.h index 64d1c1aaa42a..b654b6fa0663
> > 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.h
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> > @@ -165,6 +165,11 @@ struct intel_vgpu_submission {
> >  	bool active;
> >  };
> >
> > +#define DISPLAY_PRI_REFRESH_EVENT	(1 << 0)
> > +#define DISPLAY_PRI_REFRESH_EVENT_INC	(1UL << 56)
> > +#define DISPLAY_CUR_REFRESH_EVENT	(1 << 1)
> > +#define DISPLAY_CUR_REFRESH_EVENT_INC	(1UL << 48)
> > +
> 
> As this is for eventfd interface definition, need to put in vfio header instead of
> gvt's, as this is userspace API. And better reorder for different usage on irq
> masking and eventfd value.
> 

I think I made redundant extra flags here. Currently if we are using single irq masking/unmasking, DISPLAY_XXX_REFRESH_EVENT defined is unnecessary. I'll change it in the next version patch.

> For eventfd value, this looks like counter for each plane? Or do we just need a
> flag?
> 

We need the count val for each plane here in userspace, and we need this to perform partitioned eventfd value checking logic. But it seems too specific to be defined in vfio header. After discussing with Tina, we think we can define a base mask like  VFIO_IRQ_EVENTFD_COUNT_BASE_MASK as 0xff, to read/write 1 byte of 8-byte counter of eventfd, and shifted by the drm plane specific flag, but it still needs the discussion with Gerd and Alex.
Thanks.

Best Regards,
Kechen

> >  struct intel_vgpu {
> >  	struct intel_gvt *gvt;
> >  	struct mutex vgpu_lock;
> > @@ -205,6 +210,8 @@ struct intel_vgpu {
> >  		int num_irqs;
> >  		struct eventfd_ctx *intx_trigger;
> >  		struct eventfd_ctx *msi_trigger;
> > +		struct eventfd_ctx *vblank_trigger;
> > +		u32 display_event_mask;
> >
> >  		/*
> >  		 * Two caches are used to avoid mapping duplicated pages (eg.
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 6fe825763d05..61c634618217 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1222,6 +1222,8 @@ static int intel_vgpu_get_irq_count(struct
> > intel_vgpu *vgpu, int type)  {
> >  	if (type == VFIO_PCI_INTX_IRQ_INDEX || type ==
> VFIO_PCI_MSI_IRQ_INDEX)
> >  		return 1;
> > +	else if (type < VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs)
> > +		return vgpu->vdev.irq[type - VFIO_PCI_NUM_IRQS].count;
> >
> >  	return 0;
> >  }
> > @@ -1269,7 +1271,62 @@ static int intel_vgpu_set_msi_trigger(struct
> intel_vgpu *vgpu,
> >  	return 0;
> >  }
> >
> > -static int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
> > +static int intel_vgu_set_display_irq_mask(struct intel_vgpu *vgpu,
> > +		unsigned int index, unsigned int start, unsigned int count,
> > +		u32 flags, void *data)
> > +{
> > +	if (start != 0 || count > 2)
> > +		return -EINVAL;
> > +
> > +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> > +		vgpu->vdev.display_event_mask |=
> DISPLAY_PRI_REFRESH_EVENT |
> > +			DISPLAY_CUR_REFRESH_EVENT;
> > +
> > +	return 0;
> > +}
> > +
> > +static int intel_vgu_set_display_irq_unmask(struct intel_vgpu *vgpu,
> > +		unsigned int index, unsigned int start, unsigned int count,
> > +		u32 flags, void *data)
> > +{
> > +	if (start != 0 || count > 2)
> > +		return -EINVAL;
> > +
> > +	if (flags & VFIO_IRQ_SET_DATA_NONE)
> > +		vgpu->vdev.display_event_mask &=
> ~(DISPLAY_PRI_REFRESH_EVENT |
> > +			   DISPLAY_CUR_REFRESH_EVENT);
> > +
> > +	return 0;
> > +}
> > +
> > +static int intel_vgpu_set_display_event_trigger(struct intel_vgpu *vgpu,
> > +		unsigned int index, unsigned int start, unsigned int count,
> > +		u32 flags, void *data)
> > +{
> > +	struct eventfd_ctx *trigger;
> > +
> > +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> > +		int fd = *(int *)data;
> > +
> > +		trigger = eventfd_ctx_fdget(fd);
> > +		if (IS_ERR(trigger)) {
> > +			gvt_vgpu_err("eventfd_ctx_fdget failed\n");
> > +			return PTR_ERR(trigger);
> > +		}
> > +		vgpu->vdev.vblank_trigger = trigger;
> > +		vgpu->vdev.display_event_mask = 0;
> > +	} else if ((flags & VFIO_IRQ_SET_DATA_NONE) && !count) {
> > +		trigger = vgpu->vdev.vblank_trigger;
> > +		if (trigger) {
> > +			eventfd_ctx_put(trigger);
> > +			vgpu->vdev.vblank_trigger = NULL;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int intel_vgpu_set_irqs(struct intel_vgpu *vgpu, u32 flags,
> >  		unsigned int index, unsigned int start, unsigned int count,
> >  		void *data)
> >  {
> > @@ -1302,6 +1359,35 @@ static int intel_vgpu_set_irqs(struct intel_vgpu
> *vgpu, u32 flags,
> >  			break;
> >  		}
> >  		break;
> > +	default:
> > +	{
> > +		int i;
> > +
> > +		if (index >= VFIO_PCI_NUM_IRQS +
> > +					vgpu->vdev.num_irqs)
> > +			return -EINVAL;
> > +		index =
> > +			array_index_nospec(index,
> > +						VFIO_PCI_NUM_IRQS +
> > +						vgpu->vdev.num_irqs);
> > +
> > +		i = index - VFIO_PCI_NUM_IRQS;
> > +		if (vgpu->vdev.irq[i].type == VFIO_IRQ_TYPE_GFX &&
> > +		    vgpu->vdev.irq[i].subtype ==
> > +		    VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ) {
> > +			switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > +			case VFIO_IRQ_SET_ACTION_MASK:
> > +				func = intel_vgu_set_display_irq_mask;
> > +				break;
> > +			case VFIO_IRQ_SET_ACTION_UNMASK:
> > +				func = intel_vgu_set_display_irq_unmask;
> > +				break;
> > +			case VFIO_IRQ_SET_ACTION_TRIGGER:
> > +				func = intel_vgpu_set_display_event_trigger;
> > +				break;
> > +			}
> > +		}
> > +	}
> >  	}
> >
> >  	if (!func)
> > @@ -1333,7 +1419,7 @@ static long intel_vgpu_ioctl(struct mdev_device
> *mdev, unsigned int cmd,
> >  		info.flags |= VFIO_DEVICE_FLAGS_RESET;
> >  		info.num_regions = VFIO_PCI_NUM_REGIONS +
> >  				vgpu->vdev.num_regions;
> > -		info.num_irqs = VFIO_PCI_NUM_IRQS;
> > +		info.num_irqs = VFIO_PCI_NUM_IRQS + vgpu->vdev.num_irqs;
> >
> >  		return copy_to_user((void __user *)arg, &info, minsz) ?
> >  			-EFAULT : 0;
> > @@ -1493,32 +1579,81 @@ static long intel_vgpu_ioctl(struct mdev_device
> *mdev, unsigned int cmd,
> >  			-EFAULT : 0;
> >  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
> >  		struct vfio_irq_info info;
> > +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> > +		unsigned int i;
> > +		int ret;
> >
> >  		minsz = offsetofend(struct vfio_irq_info, count);
> >
> >  		if (copy_from_user(&info, (void __user *)arg, minsz))
> >  			return -EFAULT;
> >
> > -		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
> > +		if (info.argsz < minsz)
> >  			return -EINVAL;
> >
> >  		switch (info.index) {
> >  		case VFIO_PCI_INTX_IRQ_INDEX:
> >  		case VFIO_PCI_MSI_IRQ_INDEX:
> > +			info.flags = VFIO_IRQ_INFO_EVENTFD;
> >  			break;
> > -		default:
> > +		case VFIO_PCI_MSIX_IRQ_INDEX:
> > +		case VFIO_PCI_ERR_IRQ_INDEX:
> > +		case VFIO_PCI_REQ_IRQ_INDEX:
> >  			return -EINVAL;
> > -		}
> > +		default:
> > +		{
> > +			struct vfio_irq_info_cap_type cap_type = {
> > +				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
> > +				.header.version = 1 };
> >
> > -		info.flags = VFIO_IRQ_INFO_EVENTFD;
> > +			if (info.index >= VFIO_PCI_NUM_IRQS +
> > +					vgpu->vdev.num_irqs)
> > +				return -EINVAL;
> > +			info.index =
> > +				array_index_nospec(info.index,
> > +						VFIO_PCI_NUM_IRQS +
> > +						vgpu->vdev.num_irqs);
> > +
> > +			i = info.index - VFIO_PCI_NUM_IRQS;
> > +
> > +			info.flags = vgpu->vdev.irq[i].flags;
> > +			cap_type.type = vgpu->vdev.irq[i].type;
> > +			cap_type.subtype = vgpu->vdev.irq[i].subtype;
> > +
> > +			ret = vfio_info_add_capability(&caps,
> > +						&cap_type.header,
> > +						sizeof(cap_type));
> > +			if (ret)
> > +				return ret;
> > +		}
> > +		}
> >
> >  		info.count = intel_vgpu_get_irq_count(vgpu, info.index);
> >
> >  		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
> >  			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
> >  				       VFIO_IRQ_INFO_AUTOMASKED);
> > -		else
> > -			info.flags |= VFIO_IRQ_INFO_NORESIZE;
> > +
> > +		if (caps.size) {
> > +			info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
> > +			if (info.argsz < sizeof(info) + caps.size) {
> > +				info.argsz = sizeof(info) + caps.size;
> > +				info.cap_offset = 0;
> > +			} else {
> > +				vfio_info_cap_shift(&caps, sizeof(info));
> > +				if (copy_to_user((void __user *)arg +
> > +						  sizeof(info), caps.buf,
> > +						  caps.size)) {
> > +					kfree(caps.buf);
> > +					return -EFAULT;
> > +				}
> > +				info.cap_offset = sizeof(info);
> > +				if (offsetofend(struct vfio_irq_info, cap_offset) >
> minsz)
> > +					minsz = offsetofend(struct
> vfio_irq_info, cap_offset);
> > +			}
> > +
> > +			kfree(caps.buf);
> > +		}
> >
> >  		return copy_to_user((void __user *)arg, &info, minsz) ?
> >  			-EFAULT : 0;
> > @@ -1537,7 +1672,8 @@ static long intel_vgpu_ioctl(struct mdev_device
> *mdev, unsigned int cmd,
> >  			int max = intel_vgpu_get_irq_count(vgpu, hdr.index);
> >
> >  			ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
> > -						VFIO_PCI_NUM_IRQS,
> &data_size);
> > +					VFIO_PCI_NUM_IRQS + vgpu-
> >vdev.num_irqs,
> > +								 &data_size);
> >  			if (ret) {
> >
> 	gvt_vgpu_err("intel:vfio_set_irqs_validate_and_prepare failed\n");
> >  				return -EINVAL;
> > --
> > 2.17.1
> >
> 
> --
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
