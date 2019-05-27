Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2202B4ED
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfE0MWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfE0MWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 08:22:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A1FE309265A;
        Mon, 27 May 2019 12:22:40 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B84B46466;
        Mon, 27 May 2019 12:22:38 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 57F9211AAB; Mon, 27 May 2019 14:22:37 +0200 (CEST)
Date:   Mon, 27 May 2019 14:22:37 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     Tina Zhang <tina.zhang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: Re: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Message-ID: <20190527122237.uhd7qm62h6wfv5w7@sirius.home.kraxel.org>
References: <20190527084312.8872-1-tina.zhang@intel.com>
 <20190527084312.8872-2-tina.zhang@intel.com>
 <20190527090741.GE29553@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527090741.GE29553@zhen-hp.sh.intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 27 May 2019 12:22:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 05:07:41PM +0800, Zhenyu Wang wrote:
> On 2019.05.27 16:43:11 +0800, Tina Zhang wrote:
> > Add VFIO_DEVICE_SET_GFX_FLIP_EVENTFD ioctl command to set eventfd
> > based signaling mechanism to deliver vGPU framebuffer page flip
> > event to userspace.
> 
> Should we add probe to see if driver can support gfx flip event?

Userspace can simply call VFIO_DEVICE_SET_GFX_FLIP_EVENTFD and see if it
worked.  If so -> use the eventfd.  Otherwise take the fallback path
(timer based polling).  I can't see any advantage a separate feature
probe steps adds.

cheers,
  Gerd

