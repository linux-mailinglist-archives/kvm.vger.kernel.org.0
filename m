Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECA19980F
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgCaODc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 10:03:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730755AbgCaODc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 10:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585663411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q1HhUZIT2eXWaur2lhwyirTrp2FNrCuPmxOJW0kwlcg=;
        b=h97VAV76J4Ycxw8/+INJEEDRbcJ/k6qDhOxu/x0Rp+QThfbSW3YpQMwBEgiE5Mi4+nIwpe
        GKrWAbrN+knP6a8nhRtsjxZto5Zbln8uQybLPShGIjhyMClI5USZauVNoVraMtPZABC9Pl
        sUY0lcPcO8kQ14cP43DTuKPLpJbVD8c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-kwNVHPhlNAuPgZyTlpcGfw-1; Tue, 31 Mar 2020 10:03:29 -0400
X-MC-Unique: kwNVHPhlNAuPgZyTlpcGfw-1
Received: by mail-wm1-f71.google.com with SMTP id 2so1114266wmf.1
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 07:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q1HhUZIT2eXWaur2lhwyirTrp2FNrCuPmxOJW0kwlcg=;
        b=G/Cz5V94ve2mZ4s5TClC7/udI99S2NDnX3r93g+27M2U+nbP9+fGrO8ldUfyxuwPmO
         7rrz+cUT+ileNqx8rt/gNQOFsPwtrBjTneNgy/VoGwszQHVFMtpmW976rXVHJrOuPtsW
         OjKiBBs8py6irdLTbUWS8wjGpuaR+QkoGD/pCBB1TdiaelHX5C3ZNwdZLk+5zGXN9Yn6
         hmHWdt1IC5mn4Ie3UATehgw8lop+b2R55x+0MlhUeb7gVxAOUUogdV5ivcxK5I95wMbf
         UVqd02P6uHps9e7LMLVpvbsIlXUuxamp1LdhOGKmemM0PiJD2g+Ao/Rl0LB8+YUdlONT
         LQVQ==
X-Gm-Message-State: ANhLgQ1azh6rslG87K9KEe1fLjMXFO7fnNjukcR/gYMkSbPqKfiL3yfJ
        e5g0EyH+F0Shit2EhNWfZiBdtDSWwdV2ZZ06dxuEchnDMS2MApxc03DH2rwCR3fOqNXBu+DT9f1
        3xD/dnSZm6oqP
X-Received: by 2002:a1c:2203:: with SMTP id i3mr3685831wmi.25.1585663408047;
        Tue, 31 Mar 2020 07:03:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vulRkkpxXMxZEng5aERNo4jJ/g5cD0Vhw5jYc5ZRlaSa1jWBjmSh3+3XcGa4A4n7qFMJ8cR0g==
X-Received: by 2002:a1c:2203:: with SMTP id i3mr3685803wmi.25.1585663407800;
        Tue, 31 Mar 2020 07:03:27 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id r17sm26682436wrx.46.2020.03.31.07.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 07:03:20 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:03:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jason Wang <jasowang@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: vdpa: remove unnecessary null check
Message-ID: <20200331100122-mutt-send-email-mst@kernel.org>
References: <20200330235040.GA9997@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330235040.GA9997@embeddedor>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 06:50:40PM -0500, Gustavo A. R. Silva wrote:
> container_of is never null, so this null check is
> unnecessary.
> 
> Addresses-Coverity-ID: 1492006 ("Logically dead code")
> Fixes: 20453a45fb06 ("vhost: introduce vDPA-based backend")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Yes weird. Was the point to test i_cdev? Tiwei?

> ---
>  drivers/vhost/vdpa.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 421f02a8530a..3d2cb811757a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -678,8 +678,6 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	int nvqs, i, r, opened;
>  
>  	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
> -	if (!v)
> -		return -ENODEV;
>  
>  	opened = atomic_cmpxchg(&v->opened, 0, 1);
>  	if (opened)
> -- 
> 2.26.0

