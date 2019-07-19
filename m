Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88596E8BC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfGSQZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 12:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfGSQZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 12:25:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC83B3364D;
        Fri, 19 Jul 2019 16:25:20 +0000 (UTC)
Received: from x1.home (ovpn-116-35.phx2.redhat.com [10.3.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C67DE1001B02;
        Fri, 19 Jul 2019 16:25:17 +0000 (UTC)
Date:   Fri, 19 Jul 2019 10:25:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kechen Lu <kechen.lu@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tina Zhang <tina.zhang@intel.com>,
        kraxel@redhat.com, zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 2/6] vfio: Introduce vGPU display irq type
Message-ID: <20190719102516.60af527f@x1.home>
In-Reply-To: <20190718155640.25928-3-kechen.lu@intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
        <20190718155640.25928-3-kechen.lu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 19 Jul 2019 16:25:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Jul 2019 23:56:36 +0800
Kechen Lu <kechen.lu@intel.com> wrote:

> From: Tina Zhang <tina.zhang@intel.com>
> 
> Introduce vGPU specific irq type VFIO_IRQ_TYPE_GFX, and
> VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ as the subtype for vGPU display
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/uapi/linux/vfio.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index be6adab4f759..df28b17a6e2e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -469,6 +469,9 @@ struct vfio_irq_info_cap_type {
>  	__u32 subtype;  /* type specific */
>  };
>  
> +#define VFIO_IRQ_TYPE_GFX				(1)
> +#define VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ		(1)
> +

Please include a description defining exactly what this IRQ is intended
to signal.  For instance, if another vGPU vendor wanted to implement
this in their driver and didn't have the QEMU code for reference to
what it does with the IRQ, what would they need to know?  Thanks,

Alex 

>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
>   *

