Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F838A9C2D
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 09:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfIEHtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 03:49:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbfIEHtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 03:49:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8233630044CE;
        Thu,  5 Sep 2019 07:49:01 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-117-72.ams2.redhat.com [10.36.117.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C87695C219;
        Thu,  5 Sep 2019 07:48:58 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 066DE937E; Thu,  5 Sep 2019 09:48:58 +0200 (CEST)
Date:   Thu, 5 Sep 2019 09:48:57 +0200
From:   "kraxel@redhat.com" <kraxel@redhat.com>
To:     "Zhang, Tina" <tina.zhang@intel.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: Re: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Message-ID: <20190905074857.n3akutnoarnfvg4y@sirius.home.kraxel.org>
References: <20190816023528.30210-1-tina.zhang@intel.com>
 <237F54289DF84E4997F34151298ABEBC8771E7AE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <237F54289DF84E4997F34151298ABEBC8771E7AE@SHSMSX101.ccr.corp.intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 05 Sep 2019 07:49:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> Option 2: QEMU provides the emulated display refresh event to the
> vgpus provided by vendor driver. For vgpus, the display refresh event
> can be considered as the vblank event which is leveraged by guest
> window manager to do the plane update or mode-setting.

> People are asking if option 2 could be a better choice.

Certainly worth trying, maybe it even makes sense to implement both and
let qemu pick one, possibly even switch them at runtime.

qemu can change the refresh rate.  vnc and sdl use that to reduce the
refresh rate in case nobody is looking (no vnc client connected, sdl
window minimized).  It surely makes sense to make that visible to the
guest so it can throttle display updates too.  I'm not sure vblank is
the way to go though, guests might run into vblank irq timeouts in case
the refresh rate is very low ...

cheers,
  Gerd

