Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528171C1802
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgEAOlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 10:41:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728724AbgEAOk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 10:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588344057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMCVUX3SZIQcfGxvWeP6Mw5R9IcHL0EXZloLxMg4CEI=;
        b=fxc/6spGL1Uj0j7d0nuT9sDjNIhdT3Z7CRVpx6S7sHHEqI0DzZ+qG/f4BlDJcTOD7i0iwF
        svwA5IQcUspbhUxhuxH6m1PX7xJi9jOgFlVMX56fMsuxbc7klClDKTuUbdaWKnOiADk2uX
        GCKT43J9GQ/FL0lxooud4GmbtAtEgjE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-L0gyVnmKMSiSP4H7BPZOeg-1; Fri, 01 May 2020 10:40:56 -0400
X-MC-Unique: L0gyVnmKMSiSP4H7BPZOeg-1
Received: by mail-wm1-f69.google.com with SMTP id f81so2126892wmf.2
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 07:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FMCVUX3SZIQcfGxvWeP6Mw5R9IcHL0EXZloLxMg4CEI=;
        b=QC22Tcv6gNS2eH3nOCqJ7pTdHpDhGbqc7Yd171X4xL0onmIE/gUN59vb3gvPikqtH9
         qbQYEiRb/Q+VbehXzoUmdn5FZ1y+9PwojVmABR0KM8xap+Xpg6lVy2lRF9nP5WpHrhCj
         h/0yWwtr4meeXOk7zsr66Zg3faIzY5AV3dCTa7Irud3n/2entXUGaqk3haRLd3hN2UHS
         HFTxYNetVHbdAlYLvCWG6SIxj7Nkxg5299kU7CzzJZASkn8dMopZbM1VgfVpRsBmz1eN
         IMHc84Jb/jbasJNi0bBcE/T+8xzIKh8rOJEpMmnvVCYtPcUNQsQO2G7HsrG/QWQhZyQL
         S0Ww==
X-Gm-Message-State: AGi0PuZrHzRJ3AJhRxp/+74Lb9aB2o2sRL0b+ktB97W5KK/orIL05vuK
        4fZr8mGaSHc4PAylpBBttu2ulYr0+cbEsp0wngreCJcBltku11vy/CfuT8y1YEjurelXq7PynW8
        7PF5VoAqYIcPM
X-Received: by 2002:adf:df82:: with SMTP id z2mr4930983wrl.58.1588344054920;
        Fri, 01 May 2020 07:40:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypIlKvu49W7Dejd9vm/UPweyZkYbpJJGe7ZlU91a4UNN1ZrYUoJL1vdxXdT4Bd7iUQNCZUPcMg==
X-Received: by 2002:adf:df82:: with SMTP id z2mr4930967wrl.58.1588344054718;
        Fri, 01 May 2020 07:40:54 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id j13sm4611452wrq.24.2020.05.01.07.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:40:53 -0700 (PDT)
Date:   Fri, 1 May 2020 16:40:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaly Xin <Kaly.Xin@arm.com>
Subject: Re: [PATCH v2] vhost: vsock: kick send_pkt worker once device is
 started
Message-ID: <20200501144051.aotbofpyuy5tqcfp@steredhat>
References: <20200501043840.186557-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501043840.186557-1-justin.he@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 12:38:40PM +0800, Jia He wrote:
> Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
> The unconditional timeout was caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
> connecting from the client side. The vhost vsock client tries to connect
> an initializing virtio vsock server.
> 
> The abnormal flow looks like:
> host-userspace           vhost vsock                       guest vsock
> ==============           ===========                       ============
> connect()     -------->  vhost_transport_send_pkt_work()   initializing
>    |                     vq->private_data==NULL
>    |                     will not be queued
>    V
> schedule_timeout(2s)
>                          vhost_vsock_start()  <---------   device ready
>                          set vq->private_data
> 
> wait for 2s and failed
> connect() again          vq->private_data!=NULL         recv connecting pkt
> 
> Details:
> 1. Host userspace sends a connect pkt, at that time, guest vsock is under
>    initializing, hence the vhost_vsock_start has not been called. So
>    vq->private_data==NULL, and the pkt is not been queued to send to guest
> 2. Then it sleeps for 2s
> 3. After guest vsock finishes initializing, vq->private_data is set
> 4. When host userspace wakes up after 2s, send connecting pkt again,
>    everything is fine.
> 
> As suggested by Stefano Garzarella, this fixes it by additional kicking the
> send_pkt worker in vhost_vsock_start once the virtio device is started. This
> makes the pending pkt sent again.
> 
> After this patch, kata-runtime (with vsock enabled) boot time is reduced
> from 3s to 1s on a ThunderX2 arm64 server.
> 
> [1] https://github.com/kata-containers/runtime/issues/1917
> 
> Reported-by: Ning Bo <n.b@live.com>
> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> v2: new solution suggested by Stefano Garzarella
> 
>  drivers/vhost/vsock.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index e36aaf9ba7bd..0716a9cdffee 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
>  		mutex_unlock(&vq->mutex);
>  	}
>  
> +	/* Some packets may have been queued before the device was started,
> +	 * let's kick the send worker to send them.
> +	 */
> +	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> +
>  	mutex_unlock(&vsock->dev.mutex);
>  	return 0;
>  
> -- 
> 2.17.1
> 

