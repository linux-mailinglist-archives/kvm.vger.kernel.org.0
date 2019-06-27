Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9080E57BF1
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 08:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfF0GUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 02:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbfF0GUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 02:20:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F19034627A;
        Thu, 27 Jun 2019 06:20:46 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-96.ams2.redhat.com [10.36.116.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AC13608CA;
        Thu, 27 Jun 2019 06:20:44 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 7676611AAF; Thu, 27 Jun 2019 08:20:43 +0200 (CEST)
Date:   Thu, 27 Jun 2019 08:20:43 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com, zhi.a.wang@intel.com, kevin.tian@intel.com,
        hang.yuan@intel.com, alex.williamson@redhat.com
Subject: Re: [RFC PATCH v3 2/4] vfio: Introduce vGPU display irq type
Message-ID: <20190627062043.63wpwgefbsnackbg@sirius.home.kraxel.org>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627033802.1663-3-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627033802.1663-3-tina.zhang@intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 27 Jun 2019 06:20:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 27, 2019 at 11:38:00AM +0800, Tina Zhang wrote:
> Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 600784acc4ac..c3e9c821a5cb 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -465,6 +465,9 @@ struct vfio_irq_info_cap_type {
>  	__u32 subtype;  /* type specific */
>  };
>  
> +#define VFIO_IRQ_TYPE_GFX				(1)
> +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)

VFIO_IRQ_TYPE_GFX_VBLANK ?

cheers,
  Gerd

