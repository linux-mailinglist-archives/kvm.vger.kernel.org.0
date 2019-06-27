Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6357C15
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 08:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfF0GWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 02:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0GWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 02:22:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CEF1356CD;
        Thu, 27 Jun 2019 06:22:35 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-96.ams2.redhat.com [10.36.116.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC06B5D719;
        Thu, 27 Jun 2019 06:22:32 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id EB94016E08; Thu, 27 Jun 2019 08:22:31 +0200 (CEST)
Date:   Thu, 27 Jun 2019 08:22:31 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com, zhi.a.wang@intel.com, kevin.tian@intel.com,
        hang.yuan@intel.com, alex.williamson@redhat.com
Subject: Re: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to userspace
Message-ID: <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
References: <20190627033802.1663-1-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627033802.1663-1-tina.zhang@intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 27 Jun 2019 06:22:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> Instead of delivering page flip events, we choose to post display vblank
> event. Handling page flip events for both primary plane and cursor plane
> may make user space quite busy, although we have the mask/unmask mechansim
> for mitigation. Besides, there are some cases that guest app only uses
> one framebuffer for both drawing and display. In such case, guest OS won't
> do the plane page flip when the framebuffer is updated, thus the user
> land won't be notified about the updated framebuffer.

What happens when the guest is idle and doesn't draw anything to the
framebuffer?

cheers,
  Gerd

