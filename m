Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6774460B1
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 09:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhKEIfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 04:35:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232736AbhKEIfN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 04:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUz7Uqfcr6vjpPuFN/6PJkrmCB4tUkJaU03BFN22CaE=;
        b=a+D0wh0Ng6LB4CLmXoXSYQWFgo9/cMszfFjdsrClV/71EAY4jVpllDc5jOm/Bh+wAC9SUg
        jC1lEQyMgkxL3y/XuN3njDnWmuA4Iz+wr7ZQkP8kXYBY7W9fcZvPLQE5/w6qFBtCWSNBFU
        oq+R36E8l6FOqk/6uVRRQalWFnh55i0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-WIjuYLZ8M7W2OJXpSvzp1w-1; Fri, 05 Nov 2021 04:32:30 -0400
X-MC-Unique: WIjuYLZ8M7W2OJXpSvzp1w-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so8145746edl.17
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 01:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HUz7Uqfcr6vjpPuFN/6PJkrmCB4tUkJaU03BFN22CaE=;
        b=dBqmIh7ZlX4+ccp9VOrJvWDIKghO8uICmA7FPnRPaUs0mH6D0G+DU9WsxHxPKrqoQp
         4BPTiNL76Q/5Nvx7lb7zo/N/HjnRZePde7Vv7h4tSPU/hMnqgB4qRLKDENvFwJaq/7gz
         gr+AzqhjabnBDdxesRGwJMPA4pMpikTFme6Tr0LYKfthFu9kcKRx9Hfx84Rr3RJ5k70+
         DBnADJYpkDHpsOf52mnLqcKTvdPn5/LxUxRZneC5bB+r3F4N/+9KnklvyM68C6rDvaTO
         xqWjgdS4Fd79p+F0SoNwl+rkWVbt21OosJLOzVNyPYoBAVLuY4lB6EdDlrYceSMGuKuk
         dSLg==
X-Gm-Message-State: AOAM532l2VZ9b++YQCbKKfTek8s4EcsTgV8l3/haN51ofAC73o13NVXH
        BUZ92Cztwc59vonxZn38bXzZIuwEqkViUjmibEbAWtjzKeny2IwRrpe6QOlQ2u8AXf9wTsckiVb
        pbdpwlGYw0SHJ
X-Received: by 2002:aa7:c395:: with SMTP id k21mr59826680edq.175.1636101149129;
        Fri, 05 Nov 2021 01:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG6LlOvWNxHc/km/eCAgFIUf26b78WCGDOP8wC0KUlo3tODOpjH30Ptj/aqd85VBUALJi06g==
X-Received: by 2002:aa7:c395:: with SMTP id k21mr59826670edq.175.1636101149017;
        Fri, 05 Nov 2021 01:32:29 -0700 (PDT)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id t15sm3588190ejx.75.2021.11.05.01.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:32:27 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:32:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa: Mark vdpa_config_ops.get_vq_notification as
 optional
Message-ID: <20211105083224.5tkhslrswshbynnu@steredhat>
References: <20211104195248.2088904-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104195248.2088904-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 04, 2021 at 08:52:48PM +0100, Eugenio Pérez wrote:
>Since vhost_vdpa_mmap checks for its existence before calling it.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> include/linux/vdpa.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>index c3011ccda430..0bdc7f785394 100644
>--- a/include/linux/vdpa.h
>+++ b/include/linux/vdpa.h
>@@ -155,7 +155,7 @@ struct vdpa_map_file {
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				@state: pointer to returned state (last_avail_idx)
>- * @get_vq_notification:	Get the notification area for a virtqueue
>+ * @get_vq_notification:	Get the notification area for a virtqueue (optional)
>  *				@vdev: vdpa device
>  *				@idx: virtqueue index
>  *				Returns the notifcation area
>-- 
>2.27.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

