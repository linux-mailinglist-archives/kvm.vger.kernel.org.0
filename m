Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6296E1EB4DA
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 07:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgFBFCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 01:02:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725787AbgFBFCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 01:02:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591074130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=unNhbaKpoHgJDBrC7Eb3u/ZNlGD55wlBW/mLz0bPcnk=;
        b=RqF+hkdBCz2NBIx4YiYPNT2FHvdUGmCk6cjxHBla32SRN/FYe9jrEWUuX5lrSlhkbsIRd3
        Ng3d/Ri113jXlW9kVda4B8evkZXHIAC2BDMyaSp87GZW5uFnHwT4iDc2tZV2iJLt4FROra
        tYo+w3Bq9FyLYdBPpUaZS9h+3xkG3m8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-RZz89on3MUm0KrgtZCoHXQ-1; Tue, 02 Jun 2020 01:02:02 -0400
X-MC-Unique: RZz89on3MUm0KrgtZCoHXQ-1
Received: by mail-wr1-f71.google.com with SMTP id z10so890066wrs.2
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 22:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=unNhbaKpoHgJDBrC7Eb3u/ZNlGD55wlBW/mLz0bPcnk=;
        b=Zs3zau6MPq+lIVbP27xwhVf5MmoEu1jI+OI32Fo62ktnU/Di1vHc1bDyN7O4vl+hAm
         PYn5CUIl2bV2qf9FRdPCm7BRL1OVm7u5C5ysKy7vTi0ZWOyRB/LZIvGUDEVTE4d2Ti1J
         p05bgqCjyOeYITflK/uTVKoKfz5CGd7UzQIO0tHR06GR1EThFjjMvC90/D/QEScu5ZIc
         AdfCr7UM7SNPhxEEf38zU0K1li17Yrl/I28wuZ+4tONfgV0JJ7Vo4nUbHTUYTmSqi8fO
         PIqSLlFh9H6VBSXQXXIX6kZBUAWJedAylM7RmblgLkFKl6cVw7SL5HNh18nHsYlcElxn
         z99A==
X-Gm-Message-State: AOAM530jn/YeiMwWloGPASdFOdp57X1yt2FGFtWI0lditYRvdnNAEwWY
        /rW11cPUBlQSFukT0VoWDgCD0qiE9xOYBAzM+JwOFzK2bhmrCF8xBYTDWebfCg6saupLiXeW2iQ
        W1WNWeW9Cx3hk
X-Received: by 2002:adf:9b9e:: with SMTP id d30mr25308474wrc.345.1591074121762;
        Mon, 01 Jun 2020 22:02:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3nr1AXCn3Z5SMmVoLwH2lrM47voNMRhlWpVupnJ+5ZSE/pBwVxy8G2I2bBBJ+b49EcSyp0Q==
X-Received: by 2002:adf:9b9e:: with SMTP id d30mr25308453wrc.345.1591074121511;
        Mon, 01 Jun 2020 22:02:01 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id w3sm1759935wmg.44.2020.06.01.22.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 22:02:00 -0700 (PDT)
Date:   Tue, 2 Jun 2020 01:01:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 1/6] vhost: allow device that does not depend on vhost
 worker
Message-ID: <20200602005904-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529080303.15449-2-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 04:02:58PM +0800, Jason Wang wrote:
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d450e16c5c25..70105e045768 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -166,11 +166,16 @@ static int vhost_poll_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync,
>  			     void *key)
>  {
>  	struct vhost_poll *poll = container_of(wait, struct vhost_poll, wait);
> +	struct vhost_work *work = &poll->work;
>  
>  	if (!(key_to_poll(key) & poll->mask))
>  		return 0;
>  
> -	vhost_poll_queue(poll);
> +	if (!poll->dev->use_worker)
> +		work->fn(work);
> +	else
> +		vhost_poll_queue(poll);
> +
>  	return 0;
>  }
>

So a wakeup function wakes up eventfd directly.

What if user supplies e.g. the same eventfd as ioeventfd?

Won't this cause infinite loops?

-- 
MST

