Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8C43BB7CB
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 09:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhGEH3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 03:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhGEH3E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 03:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625469987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l9vs1YPIv2blq9FC78Zp91jCknQ/u9T8kZKZmeKaZRA=;
        b=f6pNER3XwifOx80jTy0AW5kYV74j3FWMxz6H5TDsfdxA51ekw0Pj1IiRVyuTsPxSGKoxH8
        SiaPitmTui5UIAhb2e9fKG7IEeDaYzONzHgmcx4CgVzRFULgKGTm5n2XM4BxWgU1x0juzW
        r2pOUbtOYP/5lur7zpTogevEz0hSwYg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-0pxSSwsXN3-AnGheCgFE5g-1; Mon, 05 Jul 2021 03:26:26 -0400
X-MC-Unique: 0pxSSwsXN3-AnGheCgFE5g-1
Received: by mail-wr1-f71.google.com with SMTP id u13-20020a5d6dad0000b029012e76845945so3822812wrs.11
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 00:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l9vs1YPIv2blq9FC78Zp91jCknQ/u9T8kZKZmeKaZRA=;
        b=XXc8JXSx4zHpGGTTLykLiJa4OTyALd5c1eVB3PutjJEF7NHlEfqWI17+cT+F030GTO
         BOPHlv7qN2lPnsoH5h2/t+QGMcwUd6T5WJf2KXOWdbnBhhng3vfBjWENZsQVWj2mq6QB
         IzOEIIqMG29YCoj4MOLAqyRODNNBWNypZssYsrjr+tf4QYl/lAiQ3Xhco/U6WRcXTHnP
         vyo6ir8T6f3qzb0Iqn7YDGTe6CRsVgBhliQymKmN5nj1x683idzOFH64BgNhrwzMiqj6
         4xqfjMU90kMNE77Cwo3sIGaVTu0I59ysHqvmcqTZyB+wRAV7o6Y94Yy1AcgCJtYAKTHV
         tBeQ==
X-Gm-Message-State: AOAM530gHuj/eDz/AAu1aTs5mwB+sGfSeJRwFVoswlsCXmcZ3QpxwZek
        hn6j7cx1O17IWCVPt3xAYWcP9p4QEZ4+ZqQYLhMMLgWJ3oGvKZCM2vjW28ZdiPS0tXOtnZFwDPb
        0f6TKyDII8hQm
X-Received: by 2002:a05:6000:1b90:: with SMTP id r16mr6213101wru.316.1625469985642;
        Mon, 05 Jul 2021 00:26:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX5s9gwqr/+i2PIcE3RNqcoNcbUIAVBtfFh7ejuMNIPfYUynbufqlpSdfdzmg6iRoFqGsfdA==
X-Received: by 2002:a05:6000:1b90:: with SMTP id r16mr6213084wru.316.1625469985468;
        Mon, 05 Jul 2021 00:26:25 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id n7sm19896668wmq.37.2021.07.05.00.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 00:26:25 -0700 (PDT)
Date:   Mon, 5 Jul 2021 03:26:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com
Subject: Re: [PATCH 2/2] vdpa: vp_vdpa: don't use hard-coded maximum
 virtqueue size
Message-ID: <20210705032602-mutt-send-email-mst@kernel.org>
References: <20210705071910.31965-1-jasowang@redhat.com>
 <20210705071910.31965-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705071910.31965-2-jasowang@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 03:19:10PM +0800, Jason Wang wrote:
> This patch switch to read virtqueue size from the capability instead
> of depending on the hardcoded value. This allows the per virtqueue
> size could be advertised.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

So let's add an ioctl for this? It's really a bug we don't..

> ---
>  drivers/vdpa/virtio_pci/vp_vdpa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index 2926641fb586..198f7076e4d9 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -18,7 +18,6 @@
>  #include <linux/virtio_pci.h>
>  #include <linux/virtio_pci_modern.h>
>  
> -#define VP_VDPA_QUEUE_MAX 256
>  #define VP_VDPA_DRIVER_NAME "vp_vdpa"
>  #define VP_VDPA_NAME_SIZE 256
>  
> @@ -197,7 +196,10 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>  
>  static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 qid)
>  {
> -	return VP_VDPA_QUEUE_MAX;
> +	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
> +	struct virtio_pci_modern_device *mdev = &vp_vdpa->mdev;
> +
> +	return vp_modern_get_queue_size(mdev, qid);
>  }
>  
>  static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
> -- 
> 2.25.1

