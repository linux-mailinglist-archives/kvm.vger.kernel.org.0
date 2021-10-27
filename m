Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1A43D209
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 22:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhJ0UEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 16:04:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234231AbhJ0UEk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 16:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635364934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eKmmGD1nx7i4kqTzjfQkUa6PYfuzA04HlQL71OLcyPY=;
        b=cu3DpdfU58zU7yyZDuY2nsVvtDaCkUgu5cyc9JUw/UCxV7eG5Dy5IbNzOh1gRD7gTdJt1X
        8ZhhmS494+xx7r8hbevxttlezowfAL/FFUyETsmVm13bJSpctxgpTAnzGsRvtKmamWiQUx
        byk0psTWAt3zVdE0Xor5HftQeuYiOUM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-gCNTqlXxPpW9HNDaunKtTA-1; Wed, 27 Oct 2021 16:02:12 -0400
X-MC-Unique: gCNTqlXxPpW9HNDaunKtTA-1
Received: by mail-ed1-f72.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso3355862edb.19
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 13:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eKmmGD1nx7i4kqTzjfQkUa6PYfuzA04HlQL71OLcyPY=;
        b=pwEMI4BNgBDaSNRiCq/ANi2Q4/d5yXDzFErTlRzJMmyDZDi9MCUf+Km9mZHfFNQvcT
         Fg8rjcuCASWt7JSE5cDX+FrSNUbXvflLBPW3iWt0G8EEmdh1X7Q5noMlcehN5FGVcloK
         hBOd/gBVxWm7tiGnx3XnedgyTfMIqFPeqmZhCG62+wTyjcTd81IBSDaIWil6Rhc4U0V3
         fixWsdl4wjRwGgPFXIGgeqhaOla9WVQ6KbmPRMZjq8orf0/Pl4Q5sdBhs9L20+VWXSgx
         wPFPpaPRqyenEgvaUveK3pcJpWS0QOsKPNBd08FK3xys2+Owa/kcEWxYWqgK9yjrNa6u
         LxWA==
X-Gm-Message-State: AOAM532citSSs7ek5xPnQvp+rRkroUPcC8TnWFRtxYNObt5AaM6rdP6D
        fj0es3m1iBP74y+xAEIp/+d9PJCJRNIcGAAVt5u9z3WY9WTmEMdn9FiYnuZcZliNr/FftSUdHld
        E1HXfHoeMf+IT
X-Received: by 2002:a50:d4c9:: with SMTP id e9mr47956066edj.12.1635364931184;
        Wed, 27 Oct 2021 13:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrbQM+YpSGU4dsYU7jyrTt7pf6zqbcGk70m2QTsfqcvWmFs6yg5FyLDWycPtgyIove9NTZ6w==
X-Received: by 2002:a50:d4c9:: with SMTP id e9mr47956020edj.12.1635364930922;
        Wed, 27 Oct 2021 13:02:10 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id ne2sm420373ejc.44.2021.10.27.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:02:10 -0700 (PDT)
Date:   Wed, 27 Oct 2021 16:02:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
Message-ID: <20211027160010-mutt-send-email-mst@kernel.org>
References: <20211021084406.2660-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021084406.2660-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 04:44:06PM +0800, Cai Huoqing wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Pls check how this interacts with Mike Christie's patches.
Pls fix up the typo in the commit log.

> ---
>  drivers/vhost/vhost.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..e67bd5603b5f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -595,15 +595,15 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	dev->kcov_handle = kcov_common_handle();
>  	if (dev->use_worker) {
> -		worker = kthread_create(vhost_worker, dev,
> -					"vhost-%d", current->pid);
> +		/* avoid contributing to loadavg */

doesn't this comment have any value anymore?

> +		worker = kthread_run(vhost_worker, dev,
> +				     "vhost-%d", current->pid);
>  		if (IS_ERR(worker)) {
>  			err = PTR_ERR(worker);
>  			goto err_worker;
>  		}
>  
>  		dev->worker = worker;
> -		wake_up_process(worker); /* avoid contributing to loadavg */
>  
>  		err = vhost_attach_cgroups(dev);
>  		if (err)
> -- 
> 2.25.1

