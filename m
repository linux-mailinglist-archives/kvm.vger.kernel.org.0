Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAFB23CD6B
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgHERaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:30:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbgHER1o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 13:27:44 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 13:27:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596648463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=536n/y6iFl/5D6nOT9vy92U02GWyC/k+fDxzVf0r1Qs=;
        b=TjnvaBPBIes1NbQTYGxLBRVwUPD10nlCjzsAlKXDh5XiTgsT/6/u8ivmR1DVrAWUSNYnq4
        9AHtZYDeEcXOZ3t9NCcUsyjSyQj2T1R4tAcDmUn06nLXYS7Eqicl/KUDWLD0r4xCoXeY+r
        9aBMeavVsqNMlzMbPv5PA8U/thmVA/c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-NMfO7Z-ZNJOZuHjipPzLLg-1; Wed, 05 Aug 2020 07:53:46 -0400
X-MC-Unique: NMfO7Z-ZNJOZuHjipPzLLg-1
Received: by mail-wr1-f72.google.com with SMTP id t3so12465262wrr.5
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 04:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=536n/y6iFl/5D6nOT9vy92U02GWyC/k+fDxzVf0r1Qs=;
        b=dbJdK4nrbii7idhoGEu5p8CIXwQTdimzTq1LQWdk97K/L9c8URFo7jqG+GPhwBa8t/
         a03xoOFSxp1+YiP4PBSbaajFedifcc0nqK8UCxlPkGcttVx/JOfwdBwhU9B2zENxkLed
         w82/1/LczVcjmuwJs7TqBlX/DyNHdfgGC4A55EZSO+bn3+siYHFNBWmXo7ObN7bJy+sV
         8HdX8KzgZVmCi+VCgV21zUdKQr9zDBC5vaC+hWPoEjjqu+g+7sugCHXx8peDpE/QHhK4
         alfSo5th44JoC3s7n33iE7Z5q2x7X3co3JywFlfp9HAfrmY5JXBrwSaftJr8Jsy1nlau
         WnQg==
X-Gm-Message-State: AOAM533jJV0VO5/VwNfkMF1esYeMfykoT/UIhJU1b+WZB5xdpb+/nIWS
        tNQ/Z/PJu3Jt6f4cNfS8VwiW8zNHyG664prOuOOPBKDC4XwAkTg+9/Xke3Ck4vMg8k70Q/sSOU/
        c4e0Rpky/ZeZK
X-Received: by 2002:a1c:c345:: with SMTP id t66mr2959880wmf.0.1596628424846;
        Wed, 05 Aug 2020 04:53:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+wbkOm3jDct7STQrMsu6ZusEOvveaPFmID5XQoyiqlXiOd8CqLKRq0y1l+w8OoRQyu4N5ow==
X-Received: by 2002:a1c:c345:: with SMTP id t66mr2959868wmf.0.1596628424612;
        Wed, 05 Aug 2020 04:53:44 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id v15sm2493810wrm.23.2020.08.05.04.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 04:53:43 -0700 (PDT)
Date:   Wed, 5 Aug 2020 07:53:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, eli@mellanox.com,
        shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH 2/2] vhost_vdpa: unified set_vq_irq() and update_vq_irq()
Message-ID: <20200805075253-mutt-send-email-mst@kernel.org>
References: <20200805113832.3755-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805113832.3755-1-lingshan.zhu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 07:38:32PM +0800, Zhu Lingshan wrote:
> This commit merge vhost_vdpa_update_vq_irq() logics into
> vhost_vdpa_setup_vq_irq(), so that code are unified.
> 
> In vhost_vdpa_setup_vq_irq(), added checks for the existence
> for get_vq_irq().
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

which commit should I squash this into?

commit f8e695e9dbd88464bc3d1f01769229dedf8f30d6
Author: Zhu Lingshan <lingshan.zhu@intel.com>
Date:   Fri Jul 31 14:55:31 2020 +0800

    vhost_vdpa: implement IRQ offloading in vhost_vdpa
    

this one?

> ---
>  drivers/vhost/vdpa.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 26f166a8192e..044e1f54582a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -122,8 +122,12 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	struct vdpa_device *vdpa = v->vdpa;
>  	int ret, irq;
>  
> -	spin_lock(&vq->call_ctx.ctx_lock);
> +	if (!ops->get_vq_irq)
> +		return;
> +
>  	irq = ops->get_vq_irq(vdpa, qid);
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>  	if (!vq->call_ctx.ctx || irq < 0) {
>  		spin_unlock(&vq->call_ctx.ctx_lock);
>  		return;
> @@ -144,26 +148,6 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	spin_unlock(&vq->call_ctx.ctx_lock);
>  }
>  
> -static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
> -{
> -	spin_lock(&vq->call_ctx.ctx_lock);
> -	/*
> -	 * if it has a non-zero irq, means there is a
> -	 * previsouly registered irq_bypass_producer,
> -	 * we should update it when ctx (its token)
> -	 * changes.
> -	 */
> -	if (!vq->call_ctx.producer.irq) {
> -		spin_unlock(&vq->call_ctx.ctx_lock);
> -		return;
> -	}
> -
> -	irq_bypass_unregister_producer(&vq->call_ctx.producer);
> -	vq->call_ctx.producer.token = vq->call_ctx.ctx;
> -	irq_bypass_register_producer(&vq->call_ctx.producer);
> -	spin_unlock(&vq->call_ctx.ctx_lock);
> -}
> -
>  static void vhost_vdpa_reset(struct vhost_vdpa *v)
>  {
>  	struct vdpa_device *vdpa = v->vdpa;
> @@ -452,7 +436,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			cb.private = NULL;
>  		}
>  		ops->set_vq_cb(vdpa, idx, &cb);
> -		vhost_vdpa_update_vq_irq(vq);
> +		vhost_vdpa_setup_vq_irq(v, idx);
>  		break;
>  
>  	case VHOST_SET_VRING_NUM:
> -- 
> 2.18.4

