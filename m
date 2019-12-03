Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BB1102B2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLCQm2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 3 Dec 2019 11:42:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:9455 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfLCQm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:42:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 08:42:25 -0800
X-IronPort-AV: E=Sophos;i="5.69,273,1571727600"; 
   d="scan'208";a="205036965"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 08:42:20 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        Andy Walls <awalls@md.metrocast.net>, kvm@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Robin van der Gracht <robin@protonic.nl>,
        intel-gfx@lists.freedesktop.org,
        Bernie Thompson <bernie@plugable.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Noralf =?utf-8?Q?Tr?= =?utf-8?Q?=C3=B8nnes?= 
        <noralf@tronnes.org>, ivtv-devel@ivtvdriver.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Jaya Kumar <jayalk@intworks.biz>
Subject: Re: [Intel-gfx] [PATCH v3 00/12] video, drm, etc: constify fbops in struct fb_info
In-Reply-To: <cover.1575390740.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1575390740.git.jani.nikula@intel.com>
Date:   Tue, 03 Dec 2019 18:42:17 +0200
Message-ID: <87immxicnq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 03 Dec 2019, Jani Nikula <jani.nikula@intel.com> wrote:
> This is v3 of https://patchwork.freedesktop.org/series/70198/.
>
> 0day reported some build failures, and I needed to add patches 1-5 and 7

Should be, patches 1-4 and 7.

> to address them. Patch 8 was amended accordingly (dropped some consts),
> but the other patches remain the same from v2, except the ones I merged
> already.
>
> BR,
> Jani.
>
>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Bernie Thompson <bernie@plugable.com>
> Cc: Bruno Prémont <bonbons@linux-vserver.org>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jaya Kumar <jayalk@intworks.biz>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
> Cc: Noralf Trønnes <noralf@tronnes.org>
> Cc: Robin van der Gracht <robin@protonic.nl>
> Cc: Steve Glendinning <steve.glendinning@shawell.net>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: ivtv-devel@ivtvdriver.org
> Cc: kvm@vger.kernel.org
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
>
> Jani Nikula (12):
>   video: fbdev: atyfb: modify the static fb_ops directly
>   video: fbdev: mb862xx: modify the static fb_ops directly
>   video: fbdev: nvidia: modify the static fb_ops directly
>   video: fbdev: uvesafb: modify the static fb_ops directly
>   video: fbdev: make fbops member of struct fb_info a const pointer
>   drm: constify fb ops across all drivers
>   video: fbdev: intelfb: use const pointer for fb_ops
>   video: constify fb ops across all drivers
>   HID: picoLCD: constify fb ops
>   media: constify fb ops across all drivers
>   samples: vfio-mdev: constify fb ops
>   auxdisplay: constify fb ops
>
>  drivers/auxdisplay/cfag12864bfb.c             |  2 +-
>  drivers/auxdisplay/ht16k33.c                  |  2 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c        |  2 +-
>  drivers/gpu/drm/armada/armada_fbdev.c         |  2 +-
>  drivers/gpu/drm/drm_fb_helper.c               |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |  2 +-
>  .../gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c |  2 +-
>  drivers/gpu/drm/i915/display/intel_fbdev.c    |  2 +-
>  drivers/gpu/drm/msm/msm_fbdev.c               |  2 +-
>  drivers/gpu/drm/nouveau/nouveau_fbcon.c       |  4 ++--
>  drivers/gpu/drm/omapdrm/omap_fbdev.c          |  2 +-
>  drivers/gpu/drm/radeon/radeon_fb.c            |  2 +-
>  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |  2 +-
>  drivers/gpu/drm/tegra/fb.c                    |  2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_fb.c            |  2 +-
>  drivers/hid/hid-picolcd_fb.c                  |  3 +--
>  drivers/media/pci/ivtv/ivtvfb.c               |  3 +--
>  drivers/media/platform/vivid/vivid-osd.c      |  3 +--
>  drivers/video/fbdev/68328fb.c                 |  2 +-
>  drivers/video/fbdev/acornfb.c                 |  2 +-
>  drivers/video/fbdev/amba-clcd.c               |  2 +-
>  drivers/video/fbdev/amifb.c                   |  2 +-
>  drivers/video/fbdev/arcfb.c                   |  2 +-
>  drivers/video/fbdev/arkfb.c                   |  2 +-
>  drivers/video/fbdev/asiliantfb.c              |  2 +-
>  drivers/video/fbdev/atmel_lcdfb.c             |  2 +-
>  drivers/video/fbdev/aty/aty128fb.c            |  2 +-
>  drivers/video/fbdev/aty/atyfb.h               |  2 +-
>  drivers/video/fbdev/aty/atyfb_base.c          |  6 +++---
>  drivers/video/fbdev/aty/mach64_cursor.c       |  4 ++--
>  drivers/video/fbdev/aty/radeon_base.c         |  2 +-
>  drivers/video/fbdev/au1100fb.c                |  2 +-
>  drivers/video/fbdev/au1200fb.c                |  2 +-
>  drivers/video/fbdev/broadsheetfb.c            |  2 +-
>  drivers/video/fbdev/bw2.c                     |  2 +-
>  drivers/video/fbdev/carminefb.c               |  2 +-
>  drivers/video/fbdev/cg14.c                    |  2 +-
>  drivers/video/fbdev/cg3.c                     |  2 +-
>  drivers/video/fbdev/cg6.c                     |  2 +-
>  drivers/video/fbdev/chipsfb.c                 |  2 +-
>  drivers/video/fbdev/cirrusfb.c                |  2 +-
>  drivers/video/fbdev/clps711x-fb.c             |  2 +-
>  drivers/video/fbdev/cobalt_lcdfb.c            |  2 +-
>  drivers/video/fbdev/controlfb.c               |  2 +-
>  drivers/video/fbdev/cyber2000fb.c             |  2 +-
>  drivers/video/fbdev/da8xx-fb.c                |  2 +-
>  drivers/video/fbdev/dnfb.c                    |  2 +-
>  drivers/video/fbdev/efifb.c                   |  2 +-
>  drivers/video/fbdev/ep93xx-fb.c               |  2 +-
>  drivers/video/fbdev/fb-puv3.c                 |  2 +-
>  drivers/video/fbdev/ffb.c                     |  2 +-
>  drivers/video/fbdev/fm2fb.c                   |  2 +-
>  drivers/video/fbdev/fsl-diu-fb.c              |  2 +-
>  drivers/video/fbdev/g364fb.c                  |  2 +-
>  drivers/video/fbdev/gbefb.c                   |  2 +-
>  drivers/video/fbdev/geode/gx1fb_core.c        |  2 +-
>  drivers/video/fbdev/geode/gxfb_core.c         |  2 +-
>  drivers/video/fbdev/geode/lxfb_core.c         |  2 +-
>  drivers/video/fbdev/goldfishfb.c              |  2 +-
>  drivers/video/fbdev/grvga.c                   |  2 +-
>  drivers/video/fbdev/gxt4500.c                 |  2 +-
>  drivers/video/fbdev/hecubafb.c                |  2 +-
>  drivers/video/fbdev/hgafb.c                   |  2 +-
>  drivers/video/fbdev/hitfb.c                   |  2 +-
>  drivers/video/fbdev/hpfb.c                    |  2 +-
>  drivers/video/fbdev/hyperv_fb.c               |  2 +-
>  drivers/video/fbdev/i740fb.c                  |  2 +-
>  drivers/video/fbdev/imsttfb.c                 |  2 +-
>  drivers/video/fbdev/imxfb.c                   |  2 +-
>  drivers/video/fbdev/intelfb/intelfb.h         |  2 +-
>  drivers/video/fbdev/intelfb/intelfbdrv.c      |  2 +-
>  drivers/video/fbdev/kyro/fbdev.c              |  2 +-
>  drivers/video/fbdev/leo.c                     |  2 +-
>  drivers/video/fbdev/macfb.c                   |  2 +-
>  drivers/video/fbdev/matrox/matroxfb_crtc2.c   |  2 +-
>  drivers/video/fbdev/maxinefb.c                |  2 +-
>  drivers/video/fbdev/mb862xx/mb862xxfb.h       |  2 +-
>  drivers/video/fbdev/mb862xx/mb862xxfb_accel.c | 15 +++++++-------
>  drivers/video/fbdev/mb862xx/mb862xxfbdrv.c    |  4 +++-
>  drivers/video/fbdev/mbx/mbxfb.c               |  2 +-
>  drivers/video/fbdev/metronomefb.c             |  2 +-
>  drivers/video/fbdev/mmp/fb/mmpfb.c            |  2 +-
>  drivers/video/fbdev/mx3fb.c                   |  5 +++--
>  drivers/video/fbdev/neofb.c                   |  2 +-
>  drivers/video/fbdev/nvidia/nvidia.c           | 20 ++++++++++---------
>  drivers/video/fbdev/ocfb.c                    |  2 +-
>  drivers/video/fbdev/offb.c                    |  2 +-
>  .../video/fbdev/omap2/omapfb/omapfb-main.c    |  2 +-
>  drivers/video/fbdev/p9100.c                   |  2 +-
>  drivers/video/fbdev/platinumfb.c              |  2 +-
>  drivers/video/fbdev/pm2fb.c                   |  2 +-
>  drivers/video/fbdev/pm3fb.c                   |  2 +-
>  drivers/video/fbdev/pmag-aa-fb.c              |  2 +-
>  drivers/video/fbdev/pmag-ba-fb.c              |  2 +-
>  drivers/video/fbdev/pmagb-b-fb.c              |  2 +-
>  drivers/video/fbdev/ps3fb.c                   |  2 +-
>  drivers/video/fbdev/pvr2fb.c                  |  2 +-
>  drivers/video/fbdev/pxa168fb.c                |  2 +-
>  drivers/video/fbdev/pxafb.c                   |  4 ++--
>  drivers/video/fbdev/q40fb.c                   |  2 +-
>  drivers/video/fbdev/riva/fbdev.c              |  2 +-
>  drivers/video/fbdev/s3c-fb.c                  |  2 +-
>  drivers/video/fbdev/s3c2410fb.c               |  2 +-
>  drivers/video/fbdev/s3fb.c                    |  2 +-
>  drivers/video/fbdev/sa1100fb.c                |  2 +-
>  drivers/video/fbdev/savage/savagefb_driver.c  |  2 +-
>  drivers/video/fbdev/sh7760fb.c                |  2 +-
>  drivers/video/fbdev/sh_mobile_lcdcfb.c        |  4 ++--
>  drivers/video/fbdev/simplefb.c                |  2 +-
>  drivers/video/fbdev/sis/sis_main.c            |  2 +-
>  drivers/video/fbdev/skeletonfb.c              |  2 +-
>  drivers/video/fbdev/sm712fb.c                 |  2 +-
>  drivers/video/fbdev/smscufx.c                 |  2 +-
>  drivers/video/fbdev/ssd1307fb.c               |  2 +-
>  drivers/video/fbdev/sstfb.c                   |  2 +-
>  drivers/video/fbdev/stifb.c                   |  2 +-
>  drivers/video/fbdev/sunxvr1000.c              |  2 +-
>  drivers/video/fbdev/sunxvr2500.c              |  2 +-
>  drivers/video/fbdev/sunxvr500.c               |  2 +-
>  drivers/video/fbdev/tcx.c                     |  2 +-
>  drivers/video/fbdev/tdfxfb.c                  |  2 +-
>  drivers/video/fbdev/tgafb.c                   |  2 +-
>  drivers/video/fbdev/tmiofb.c                  |  2 +-
>  drivers/video/fbdev/tridentfb.c               |  2 +-
>  drivers/video/fbdev/uvesafb.c                 |  4 ++--
>  drivers/video/fbdev/valkyriefb.c              |  2 +-
>  drivers/video/fbdev/vfb.c                     |  2 +-
>  drivers/video/fbdev/vga16fb.c                 |  2 +-
>  drivers/video/fbdev/vt8500lcdfb.c             |  2 +-
>  drivers/video/fbdev/vt8623fb.c                |  2 +-
>  drivers/video/fbdev/w100fb.c                  |  2 +-
>  drivers/video/fbdev/wm8505fb.c                |  2 +-
>  drivers/video/fbdev/xen-fbfront.c             |  2 +-
>  drivers/video/fbdev/xilinxfb.c                |  2 +-
>  include/linux/fb.h                            |  2 +-
>  samples/vfio-mdev/mdpy-fb.c                   |  2 +-
>  136 files changed, 163 insertions(+), 162 deletions(-)

-- 
Jani Nikula, Intel Open Source Graphics Center
