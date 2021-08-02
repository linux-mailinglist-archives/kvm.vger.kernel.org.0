Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570E93DE074
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 22:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhHBULG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 16:11:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230095AbhHBULG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 16:11:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627935055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LA8evM7BHjBr4jABvi1M9utaaAjmimAJTMztodEqWno=;
        b=Sdbwc2nyDANJY1mFTAktqUhIeYe1Hs7Q9uW6bdmTOawW+OsHzwxayFV7TqtNuUqjreizyr
        j5JSnYuDyIG8hmLLiH6bWL9w4EvJjicSw4UpSNJxrIfxK+EzjzDXCRTBlca2ypY62nWf5h
        CsDI2jPkmvvVZ2z/by52UsefAJR7tZU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-B6rrxzh7N62iXZKafz-BMw-1; Mon, 02 Aug 2021 16:10:54 -0400
X-MC-Unique: B6rrxzh7N62iXZKafz-BMw-1
Received: by mail-ej1-f72.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so4021958eje.3
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 13:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LA8evM7BHjBr4jABvi1M9utaaAjmimAJTMztodEqWno=;
        b=WYtCMZi3xtNQAXMkYxSMljNTKqBdE1W9xmUYMg6xJrk2T4Z6iQr9XQKWCNRShqR+lF
         Q5khSsqmf64pOjte+RgyCsJqCqD0dziJRjLKPzhq1LKltxqQuf78+QgS9QZVWoHUlI35
         jsIQ96EQCG5/d9W2Z2razwOgqqWb89K3AO3fugnDMVm/nyOQ8vY+oL5ucSDF/4IxLHOo
         0tvpnvENf66auR1J/LM6Kf5S2UXRG59AEa9/umxzKE4Inr39g4yV0MTNji8jdyel8KXv
         85Pq1b3FwaNzlHkthCNhlzd7S1FV7M2+c0Et0EenHLCgPvHm5hspoLnhF0GVtRh/TdCh
         0blA==
X-Gm-Message-State: AOAM532w+iJplJewxUOgKp9AfnURfwCrLK+/4YZWAXUVcs1GtcQXgaRa
        CGhm2wNgrXhO8OpuedCyGwdjDaranD7Kj7Oo8ltpkAVZVre51Clq/uhW2lgukIhUJfPWOU9Fr4F
        tgrW2BfFH42vw
X-Received: by 2002:a17:906:4b18:: with SMTP id y24mr16671486eju.42.1627935053630;
        Mon, 02 Aug 2021 13:10:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQDGepqRHg1s0zF2qekNjn1VPDNh8LoMDbONxjezTZrGQTTG2YxoZ166f6S0JBTqWT6JZH/A==
X-Received: by 2002:a17:906:4b18:: with SMTP id y24mr16671470eju.42.1627935053501;
        Mon, 02 Aug 2021 13:10:53 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id g8sm6748637edw.89.2021.08.02.13.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:10:52 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:10:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     fuguancheng <fuguancheng@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, arseny.krasnov@kaspersky.com,
        andraprs@amazon.com, colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] VSOCK DRIVER: Add multi-cid support for guest
Message-ID: <20210802160815-mutt-send-email-mst@kernel.org>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
 <20210802120720.547894-2-fuguancheng@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802120720.547894-2-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 08:07:17PM +0800, fuguancheng wrote:
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c998860d7bbc..a3ea99f6fc7f 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -17,6 +17,13 @@
>  
>  #define VHOST_FILE_UNBIND -1
>  
> +/* structs used for hypervisors to send cid info. */
> +
> +struct multi_cid_message {
> +	u32 number_cid;
> +	u64 *cid;
> +};
> +
>  /* ioctls */
>  
>  #define VHOST_VIRTIO 0xAF


In this case, a kernel pointer in a UAPI struct is suspicious.
So is padding after number_cid.

-- 
MST

