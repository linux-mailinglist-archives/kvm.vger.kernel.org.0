Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04F02B73B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 16:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfE0OEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 10:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52159 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfE0OEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 10:04:42 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A91430833B5;
        Mon, 27 May 2019 14:04:37 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2777410027C5;
        Mon, 27 May 2019 14:04:31 +0000 (UTC)
Date:   Mon, 27 May 2019 08:04:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kraxel@redhat.com,
        zhenyuw@linux.intel.com, hang.yuan@intel.com, zhiyuan.lv@intel.com
Subject: Re: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Message-ID: <20190527080430.28f40888@x1.home>
In-Reply-To: <20190527084312.8872-2-tina.zhang@intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
        <20190527084312.8872-2-tina.zhang@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 27 May 2019 14:04:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 May 2019 16:43:11 +0800
Tina Zhang <tina.zhang@intel.com> wrote:

> Add VFIO_DEVICE_SET_GFX_FLIP_EVENTFD ioctl command to set eventfd
> based signaling mechanism to deliver vGPU framebuffer page flip
> event to userspace.
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 02bb7ad6e986..27300597717f 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -696,6 +696,18 @@ struct vfio_device_ioeventfd {
>  
>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_DEVICE_SET_GFX_FLIP_EVENTFD - _IOW(VFIO_TYPE, VFIO_BASE + 17, __s32)
> + *
> + * Set eventfd based signaling mechanism to deliver vGPU framebuffer page
> + * flip event to userspace. A value of -1 is used to stop the page flip
> + * delivering.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +
> +#define VFIO_DEVICE_SET_GFX_FLIP_EVENTFD _IO(VFIO_TYPE, VFIO_BASE + 17)
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

Why can't we use VFIO_DEVICE_SET_IRQS for this?  We can add a
capability to vfio_irq_info in the same way that we did for regions to
describe device specific IRQ support.  Thanks,

Alex
