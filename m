Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E419356DAC
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhDGNpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230142AbhDGNpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 09:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617803123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bhx0J6ZxHu7gUJKkHgrAFr4iPYg1Rtg0anx/v/GSPdc=;
        b=U91DTxD0XYKNfKmHVw7rHO8cyln1pUGbmegyQhbi2n2o3wzHtzwEtrRAqQndsUREEx16ZG
        FB7kAQMllI9iwxf4+bBh/E+ajXvyYxFd3e9Qvko3pkdHuK/AIKPMAZUs0Xc2y3umRBPqf2
        bd5UY4ReAuFIm4twGqUFDDDf/nvpvzQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-7peU7CpNNA6VJTjSqOST2A-1; Wed, 07 Apr 2021 09:45:21 -0400
X-MC-Unique: 7peU7CpNNA6VJTjSqOST2A-1
Received: by mail-wr1-f72.google.com with SMTP id o11so11796193wrc.4
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bhx0J6ZxHu7gUJKkHgrAFr4iPYg1Rtg0anx/v/GSPdc=;
        b=YRYtS0VW5h2PUx9zjurmRrfUWv/tHP8SHqKVCetGZmzr0VDKdtyiVEedFKwooLg7LL
         CLb+tJgjjztU1ZrAlZHN676vqIh1v3Yzqt0OCtFQaaKUs1khK3ZC97LwXMZVyQ9MfGPX
         rIqMyrS8Otbd+xFbE0+Uoz7JswIpdERr9NeOrfTFVrbjnbbIOzPvXhVKJPyMrDSo10QN
         tndzBSEOEUWQyZ8NbdyepSE1X3ed7vp/AX6lxcJClHk46+aQzbGnMT74RKx9YqW9FIR4
         zXQegjCWpMz9LB+aauqEYfNhz+mlpYbHkjJ61s5r9l08Xk+jBBZnwOY2vTnUD/Nb4n8y
         Rpdw==
X-Gm-Message-State: AOAM5308nIlUMXDUlgOFMZptF3TFK9kTInHLQHWlKakyYevSdvuYmSdB
        ErubyheR/1VnfviJxeb6YStgY4RXq34LZHI2H9uMyqRA+mafMKoKL8SvS/fkuMgcQU3tvpal2ed
        K/amB1IiOCc4S
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr3189977wmb.106.1617803120572;
        Wed, 07 Apr 2021 06:45:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoa3hzK2qRbtyhoXwG1LeYRU4EzokhkXEsDJNaLwR4TpykE6x7fSXkSh9k7ujLZ0TaZTHxSg==
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr3189967wmb.106.1617803120419;
        Wed, 07 Apr 2021 06:45:20 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id p17sm8664990wmg.5.2021.04.07.06.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 06:45:19 -0700 (PDT)
Date:   Wed, 7 Apr 2021 09:45:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, oren@nvidia.com, nitzanc@nvidia.com
Subject: Re: [PATCH 2/3] virito_pci: add timeout to reset device operation
Message-ID: <20210407094228-mutt-send-email-mst@kernel.org>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
 <20210407120924.133294-2-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407120924.133294-2-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 12:09:23PM +0000, Max Gurtovoy wrote:
> According to the spec after writing 0 to device_status, the driver MUST
> wait for a read of device_status to return 0 before reinitializing the
> device. In case we have a device that won't return 0, the reset
> operation will loop forever and cause the host/vm to stuck. Set timeout
> for 3 minutes before giving up on the device.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index cc3412a96a17..dcee616e8d21 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>  	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
>  
>  	/* 0 status means a reset. */
>  	vp_modern_set_status(mdev, 0);
> @@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
>  	 * device_status to return 0 before reinitializing the device.
>  	 * This will flush out the status write, and flush in device writes,
>  	 * including MSI-X interrupts, if any.
> +	 * Set a timeout before giving up on the device.
>  	 */
> -	while (vp_modern_get_status(mdev))
> +	while (vp_modern_get_status(mdev)) {
> +		if (time_after(jiffies, timeout)) {
> +			dev_err(&vdev->dev, "virtio: device not ready. "
> +				"Aborting. Try again later\n");
> +			return -EAGAIN;
> +		}
>  		msleep(1);
> +	}
>  	/* Flush pending VQ/configuration callbacks. */
>  	vp_synchronize_vectors(vdev);
>  	return 0;

Problem is everyone just ignores the return code from reset.
Timing out like that has a chance to cause a lot of trouble
if the device remains active - we need to make reset robust.

What exactly is going on with the device that
get status never returns 0? E.g. maybe it's in a state
where it's returning all 1's because it's wedged permanently -
using that would be better...



> -- 
> 2.25.4

