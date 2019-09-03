Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1E4A5ED0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 03:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfICB0l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 2 Sep 2019 21:26:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:40447 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfICB0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 21:26:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 18:26:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,461,1559545200"; 
   d="scan'208";a="181984609"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 02 Sep 2019 18:26:40 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 2 Sep 2019 18:26:40 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 2 Sep 2019 18:26:38 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 2 Sep 2019 18:26:38 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.92]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.86]) with mapi id 14.03.0439.000;
 Tue, 3 Sep 2019 09:26:37 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Thread-Topic: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Thread-Index: AQHVU9tUM+mrk1EK3UW2FOPyJRIR1KcZNxag
Date:   Tue, 3 Sep 2019 01:26:36 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC8771E7AE@SHSMSX101.ccr.corp.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
In-Reply-To: <20190816023528.30210-1-tina.zhang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzMwZmIxMjYtMzQzMC00MjllLTk2MjItZjc5ZjJhMzNiNjFkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibUlvalB4MW1UUGIrSlwvSXZMV2VpdVV0VldVTXh4ZW40a00xM2NSNjExUWo2XC9sdEdPNjFkXC9UNFB4V3hqc1dSaiJ9
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

Hi,

Some people are asking whether the display refresh irq could be provided by qemu vfio display?

Some background: currently, we have two display timers. One is provided by QEMU UI and the other one is provided by the vgpu. The vgpu display framebuffer consumers (i.e. QEMU UIs) depend on the UI timer to consume the contents in the vgpu display framebuffer, meanwhile the display framebuffer producer (e.g. gvt-g display model) updates the framebuffer content according to the vblank timer provided by gpu vendor driver. Since these two timers are not synced, tearing could be noticed. 

So, theoretically to solve this tearing problem, we could have two options:

Option 1: Like what we have in this patch set: stop the QEMU UI timer and let both the framebuffer consumers and the framebuffer producer sync to the display refresh event provided by vendor driver. So, QEMU UI can do the refresh depending on this display refresh event to make sure to have a tear-free framebuffer.

Option 2: QEMU provides the emulated display refresh event to the vgpus provided by vendor driver. For vgpus, the display refresh event can be considered as the vblank event which is leveraged by guest window manager to do the plane update or mode-setting.

People are asking if option 2 could be a better choice.

Thanks.

BR,
Tina

> -----Original Message-----
> From: Zhang, Tina
> Sent: Friday, August 16, 2019 10:35 AM
> To: intel-gvt-dev@lists.freedesktop.org
> Cc: Zhang, Tina <tina.zhang@intel.com>; kraxel@redhat.com;
> alex.williamson@redhat.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Yuan, Hang <hang.yuan@intel.com>; Lv, Zhiyuan
> <zhiyuan.lv@intel.com>
> Subject: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
> 
> This series tries to send the vGPU display refresh event to user land.
> 
> Instead of delivering page flip events only or vblank events only, we choose
> to combine two of them, i.e. post display refresh event at vblanks and skip
> some of them when no page flip happens. Vblanks as upper bound are safe
> and skipping no-page-flip vblanks guarantees both trivial performance
> impacts and good user experience without screen tearing. Plus, we have the
> mask/unmask mechansim providing user space flexibility to switch between
> event-notified refresh and classic timer-based refresh.
> 
> In addition, there are some cases that guest app only uses one framebuffer
> for both drawing and display. In such case, guest OS won't do the plane page
> flip when the framebuffer is updated, thus the user land won't be notified
> about the updated framebuffer. Hence, in single framebuffer case, we apply
> a heuristic to determine whether it is the case or not. If it is, notify user land
> when each vblank event triggers.
> 
> v5:
> - Introduce a vGPU display irq cap which can notify user space with
>   both primary and cursor plane update events through one eventfd. (Gerd &
> Alex)
> v4:
> - Deliver page flip event and single framebuffer refresh event bounded by
> display vblanks. (Kechen)
> v3:
> - Deliver display vblank event instead of page flip event. (Zhenyu)
> v2:
> - Use VFIO irq chain to get eventfds from userspace instead of adding a new
> ABI. (Alex)
> v1:
> - https://patchwork.kernel.org/cover/10962341/
> 
> Kechen Lu (2):
>   drm/i915/gvt: Deliver async primary plane page flip events at vblank
>   drm/i915/gvt: Add cursor plane reg update trap emulation handler
> 
> Tina Zhang (4):
>   vfio: Define device specific irq type capability
>   vfio: Introduce vGPU display irq type
>   drm/i915/gvt: Register vGPU display event irq
>   drm/i915/gvt: Deliver vGPU refresh event to userspace
> 
>  drivers/gpu/drm/i915/gvt/cmd_parser.c |   6 +-
>  drivers/gpu/drm/i915/gvt/display.c    |  49 +++++-
>  drivers/gpu/drm/i915/gvt/display.h    |   3 +
>  drivers/gpu/drm/i915/gvt/gvt.h        |   6 +
>  drivers/gpu/drm/i915/gvt/handlers.c   |  32 +++-
>  drivers/gpu/drm/i915/gvt/hypercall.h  |   1 +
>  drivers/gpu/drm/i915/gvt/interrupt.c  |   7 +
>  drivers/gpu/drm/i915/gvt/interrupt.h  |   3 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 230 +++++++++++++++++++++++++-
>  drivers/gpu/drm/i915/gvt/mpt.h        |  17 ++
>  include/uapi/linux/vfio.h             |  40 ++++-
>  11 files changed, 375 insertions(+), 19 deletions(-)
> 
> --
> 2.17.1

