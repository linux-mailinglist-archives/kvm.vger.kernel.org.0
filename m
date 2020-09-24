Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628E4276D83
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 11:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgIXJbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 05:31:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgIXJbv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 05:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600939909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IivbX2PeE0RzW/9tWIJCPda1plSHGjAQvAPPVLRLJpk=;
        b=FZrErIp8KleXwW6+Ga2bo/0oCp74OrMdZi91u8FRXrICC19ub0j2nhbXCT1FeoZkX6kIbT
        cDr+cp28XsJWnfsJyoJzGbsYwMRl6KJj2gyfdkYOOmkhLSlVNWpSx9/OTnHJngzq6TzM/0
        0mJPPukuOy5UDrztqznIMyyu4hAUN0c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-5yU2whfXMpKNHLSdXo9o0Q-1; Thu, 24 Sep 2020 05:31:48 -0400
X-MC-Unique: 5yU2whfXMpKNHLSdXo9o0Q-1
Received: by mail-wm1-f70.google.com with SMTP id u5so1012130wme.3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 02:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IivbX2PeE0RzW/9tWIJCPda1plSHGjAQvAPPVLRLJpk=;
        b=ZDTUuIrDNA5DIrKAC3b/h2aeEkud+8ASM5wfn1MYYGuj+yPVuUpmZ1RbKmmrsk2kio
         GZTlwi/te4yNwnSJRxJ0dznor0OZVVlJSUCpwzmLPuZPI7ejd8efsU7C86N5nR+UpWJa
         6QUkx517id/hcAt53w5RBso5Jnc3PNnyMAwrJEsslv+rgDaeJlmoi/C5aR49aSONCnzD
         6Hj1gUErijgTBCIkt1Fdja5uzK/Ih6WpKRRVbticj+s78H3bIn62fbclKgiOPJP1DxEl
         zGzus6d2M/O3s4h4W6RewchPUa1xFOkJQ7YGmUjypb055fjJhyHt4Iok9+ZwC/ym/fQt
         SDQg==
X-Gm-Message-State: AOAM5307NWXQlZEvwcdnHkzIOXwB7Q0jAa6vJZFEKGJ9F5dXDgj7bb/V
        KHXK0/5KSY0Gw+ZNaEIz3KrFj1GtZ+Bi8Qh+6S+SA57D3TFo02LMWX5dIZr9PdPgvnVeQUwWSmV
        G+k3U8T4/+to6
X-Received: by 2002:adf:ec90:: with SMTP id z16mr3884969wrn.145.1600939906694;
        Thu, 24 Sep 2020 02:31:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz692FbM28SSNAgRM+pmYBV1x3+0U+/VUYbSIXGAG9tNcRIQZ9ScUUpWmMjwo9LJkxBth6P1g==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr3884952wrn.145.1600939906533;
        Thu, 24 Sep 2020 02:31:46 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id v17sm3144042wrc.23.2020.09.24.02.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 02:31:45 -0700 (PDT)
Date:   Thu, 24 Sep 2020 05:31:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: Re: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
Message-ID: <20200924053119-mutt-send-email-mst@kernel.org>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924032125.18619-3-jasowang@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 11:21:03AM +0800, Jason Wang wrote:
> We need to free vqs during the err path after it has been allocated
> since vhost won't do that for us.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

This is a bugfix too right? I don't see it posted separately ...

> ---
>  drivers/vhost/vdpa.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe979f997..9c641274b9f3 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -764,6 +764,12 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
>  	v->domain = NULL;
>  }
>  
> +static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
> +{
> +	vhost_dev_cleanup(&v->vdev);
> +	kfree(v->vdev.vqs);
> +}
> +
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  {
>  	struct vhost_vdpa *v;
> @@ -809,7 +815,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	return 0;
>  
>  err_init_iotlb:
> -	vhost_dev_cleanup(&v->vdev);
> +	vhost_vdpa_cleanup(v);
>  err:
>  	atomic_dec(&v->opened);
>  	return r;
> @@ -840,8 +846,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>  	vhost_vdpa_free_domain(v);
>  	vhost_vdpa_config_put(v);
>  	vhost_vdpa_clean_irq(v);
> -	vhost_dev_cleanup(&v->vdev);
> -	kfree(v->vdev.vqs);
> +	vhost_vdpa_cleanup(v);
>  	mutex_unlock(&d->mutex);
>  
>  	atomic_dec(&v->opened);
> -- 
> 2.20.1

