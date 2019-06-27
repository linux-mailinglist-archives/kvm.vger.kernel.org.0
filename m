Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756FA57E75
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfF0IoT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Jun 2019 04:44:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:17919 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0IoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:44:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 01:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="185197942"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2019 01:44:18 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 01:44:18 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.87]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 16:44:16 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
 userspace
Thread-Topic: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
 userspace
Thread-Index: AQHVLJqUUSM/9sKZ/UyimYY5z7yeLaaughWAgACsmuA=
Date:   Thu, 27 Jun 2019 08:44:15 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
In-Reply-To: <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGRkMjk1OGYtYWY4My00ODBkLWFlNTMtYjZhZjIwM2Y5NTVlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSjliTHc4bVZ4QTlUZWp0ZVwvd1dydjhaTW42UVZqWmt3bFVEVWVSRU1ZelJxXC9YWXB1Ymw0T3Y5XC82S2hOZ0QrSyJ9
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
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Thursday, June 27, 2019 2:23 PM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; zhenyuw@linux.intel.com; Lv, Zhiyuan
> <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian, Kevin
> <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>;
> alex.williamson@redhat.com
> Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
> userspace
> 
>   Hi,
> 
> > Instead of delivering page flip events, we choose to post display
> > vblank event. Handling page flip events for both primary plane and
> > cursor plane may make user space quite busy, although we have the
> > mask/unmask mechansim for mitigation. Besides, there are some cases
> > that guest app only uses one framebuffer for both drawing and display.
> > In such case, guest OS won't do the plane page flip when the
> > framebuffer is updated, thus the user land won't be notified about the
> updated framebuffer.
> 
> What happens when the guest is idle and doesn't draw anything to the
> framebuffer?
The vblank event will be delivered to userspace as well, unless guest OS disable the pipe.
Does it make sense to vfio/display?
Thanks.

BR,
Tina
> 
> cheers,
>   Gerd

