Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F8B1F565F
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgFJOAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 10:00:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21325 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729653AbgFJOAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 10:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591797608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4ZJyuHZsqz6Dp/hV/6BFgchUFjowsw3OCjq+UXY+5M=;
        b=E79NLLxBKerATWN1x46GrAwb+CznmFo9jzX88o4fu24onpU2xcbS3ijOWBOVySyg22lHFP
        S7Eq2cECdUUhzedjukCfddO6gyUdkuC2dKBCkX+TqsKwZx9hkGnMBl8x7CTV3LzAKLpHE0
        ojG+iwJaeBt1ZgYWZD+d60OemFcIngA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-q1TUBPYjNeeg4TOlJ7XkGQ-1; Wed, 10 Jun 2020 10:00:06 -0400
X-MC-Unique: q1TUBPYjNeeg4TOlJ7XkGQ-1
Received: by mail-wr1-f71.google.com with SMTP id f4so1117147wrp.21
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 07:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W4ZJyuHZsqz6Dp/hV/6BFgchUFjowsw3OCjq+UXY+5M=;
        b=c2GK+Et3vC9bdq2LBjgj/CyjPhepMvWMzxe07/2tLesT8ymgwCXlpVsiAuMipJ5TPn
         7N2Z7MWQ7bzgozCD9pzA121zCg7QA24rvwma/hNcTsjQkKRJOX/hMsZA5/vT9YaE3zco
         dgn84yjFYiAkvxd70QEy83jsYtSGD7EoOYgfYLVi3qTuhC8kQ7OhQiSS1Jz4FtV6pp+v
         kaXHQxL4ci0qKF3dlaFAm0WkfBYSnF2fdUPJ/X07Xe6yNR/hobnh8OOl5uUqz/MZy/BH
         HAv3MxxWXzfxvbxgqJZ+Vc8B5CajNNw1FV0jdja67bPMbv7ZAeKqbH0THHFtJwm7czPs
         hMag==
X-Gm-Message-State: AOAM530ZiGhXqPkvJEgPDWdkSmX8ugsvtVREN0H7+pt3UrB8JjE4GKEQ
        RrMXxuQI+wZOvlbmH3humTKjVCLTPCCLoEA+BkCe/491tljKYcy9TlmrM6MBoq4A/0aNZ/qAJ8Y
        inu5uGeeosoir
X-Received: by 2002:adf:e588:: with SMTP id l8mr4149042wrm.255.1591797604006;
        Wed, 10 Jun 2020 07:00:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4noLc0O45gskMWYhwv5vg8oao1Tu5iY4ApUPR3SsY/4SwqHOBeyf+02xREn7ZL0gTTtiIIg==
X-Received: by 2002:adf:e588:: with SMTP id l8mr4149007wrm.255.1591797603762;
        Wed, 10 Jun 2020 07:00:03 -0700 (PDT)
Received: from eperezma.remote.csb (109.141.78.188.dynamic.jazztel.es. [188.78.141.109])
        by smtp.gmail.com with ESMTPSA id t129sm7723980wmf.41.2020.06.10.07.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 07:00:03 -0700 (PDT)
Message-ID: <313ad30e073974d71ac4c2fc3bc75db690ec8c72.camel@redhat.com>
Subject: Re: [PATCH RFC v7 02/14] fixup! vhost: option to fetch descriptors
 through an independent struct
From:   Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Date:   Wed, 10 Jun 2020 16:00:01 +0200
In-Reply-To: <20200610113515.1497099-3-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
         <20200610113515.1497099-3-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-6.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-06-10 at 07:35 -0400, Michael S. Tsirkin wrote:
> ---
>  drivers/vhost/vhost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 180b7b58c76b..11433d709651 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2614,7 +2614,7 @@ int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
>  err_fetch:
>  	vq->ndescs = 0;
>  
> -	return ret;
> +	return ret ? ret : vq->num;
>  }
>  EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
>  

I'm able to lock the vhost_get_vq_desc running virtio_test with no arguments against this patch. It does not happen if
it returns vq->num early, appended below.

Let me know if you prefer your conditional at the end of the function and I will investigate the cause.

Thanks!

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 28f324fd77df..4d198994e7be 100644
@@ -2350,7 +2345,9 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	int ret = fetch_descs(vq);
 	int i;
 
-	if (ret <= 0)
+	if (ret == 0)
+		return vq->num;
+	else if (ret < 0)
 		goto err;
 
 	/* Now convert to IOV */

