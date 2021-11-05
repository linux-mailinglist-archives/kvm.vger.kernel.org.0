Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608D94460B2
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 09:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhKEIfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 04:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232644AbhKEIfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 04:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSxcNVRVB/DnKZ4+R+U2HEVeDSNW0idhy+8Cu/Pwcx0=;
        b=APMT/2up7s68m7Hru2j/xMF7qi+7x3C2nOT1Lu9cxn33Pw3qiRgBFOwBthC6O9q+tEdd1o
        g4i3lFlEBSZWLdL6WhGN4FWj/OGo0DKEVyZSAsO9QLamTQqskivBkyb361q38YQM72OhLF
        vD+UeQBCLxywKBVfrIvBn2bS3F6/TAQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-1q3JyeCBNKy4wcLTWbSytA-1; Fri, 05 Nov 2021 04:32:57 -0400
X-MC-Unique: 1q3JyeCBNKy4wcLTWbSytA-1
Received: by mail-ed1-f71.google.com with SMTP id w12-20020aa7da4c000000b003e28acbf765so8208678eds.6
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 01:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JSxcNVRVB/DnKZ4+R+U2HEVeDSNW0idhy+8Cu/Pwcx0=;
        b=EKLN6AMKCmfOxUMHPI3ugXrh+T/zNXbBqDLE/nYVfaBP3ipgKnBU8vzlx97Z5Q00Eu
         2WYicKLNDMDXeg6wAykdel4OdvRwLxRMbdRGQO40uxsGKS54Ge/oMpMKFaf7jBZTDQHD
         l5PVwXFY6ubZfOoKPoXMAchdqrd0ZfFFiHRqly6rAd9qO+RzFONyzBx5v4TJ9PwQ1VxF
         KHhaCAcepcwx6YtoEucdlRgjhFWREZjcE5bxK+A73R1epm9CHj2FR+ldU4not81l6rJZ
         ex5UxXWis+pCoPCCvDWLd4VgWoU/SWwFTyLwqNhX2C8/NaVCt2CGNyTwRU8WB5e+Q8rb
         MxIw==
X-Gm-Message-State: AOAM532pcgcVJZUOOmiyq4UQiRFs/CQcZd6JmVrpJRNdKh14NinPDv3Q
        V8bTrlQhn+RCv+u6f4QDh1fllprQARRztF7pAXq2lqbgnAvNvElA0lNM1UPgn6J3znkLzL4BfPs
        McZcpDnSiUfyI
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr44987881edy.38.1636101176829;
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1GoJj1G+zOd7oQ+Yq/sGjIs8oFTI+82pGo9B8tvnTk8Cb+1Fmockzi86p8mv8w/4VBcIpXg==
X-Received: by 2002:a05:6402:6c8:: with SMTP id n8mr44987864edy.38.1636101176724;
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id f22sm4127471edu.26.2021.11.05.01.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 01:32:56 -0700 (PDT)
Date:   Fri, 5 Nov 2021 09:32:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vdpa: Avoid duplicate call to vp_vdpa get_status
Message-ID: <20211105083253.y4mikalhbfwmcuhp@steredhat>
References: <20211104195833.2089796-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104195833.2089796-1-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 04, 2021 at 08:58:33PM +0100, Eugenio Pérez wrote:
>It has no sense to call get_status twice, since we already have a
>variable for that.
>
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vhost/vdpa.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 01c59ce7e250..10676ea0348b 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -167,13 +167,13 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
> 	status_old = ops->get_status(vdpa);
>
> 	/*
> 	 * Userspace shouldn't remove status bits unless reset the
> 	 * status to 0.
> 	 */
>-	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
>+	if (status != 0 && (status_old & ~status) != 0)
> 		return -EINVAL;
>
> 	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status & VIRTIO_CONFIG_S_DRIVER_OK))
> 		for (i = 0; i < nvqs; i++)
> 			vhost_vdpa_unsetup_vq_irq(v, i);
>
>-- 
>2.27.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

