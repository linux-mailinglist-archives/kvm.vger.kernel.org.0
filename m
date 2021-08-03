Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1743B3DE75D
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 09:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhHCHl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 03:41:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234248AbhHCHl4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 03:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627976505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEW12L7lEJwVitr0islGtcOwaqb3auoW/6llqcQs9Bo=;
        b=CqTbzxYbFeG33LhPH8dYRIjrt76BjkZXb1MHHxs07j59O+nF4TZSaVrtneunZG9oqrXcmb
        tY+zfqSSsTxSFGoV2myD1rSHwMklnOmb6iMIACfiGa1OQ5k8DYK3NGEgDpIeZ5VizHZ7HB
        F0s3RZ5661vbON9Z2yk4nQAZmufxohM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-YBlaQsxhOZO7XZ7toqEBKQ-1; Tue, 03 Aug 2021 03:41:44 -0400
X-MC-Unique: YBlaQsxhOZO7XZ7toqEBKQ-1
Received: by mail-pj1-f71.google.com with SMTP id o23-20020a17090a4217b02901774c248202so2141531pjg.9
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 00:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sEW12L7lEJwVitr0islGtcOwaqb3auoW/6llqcQs9Bo=;
        b=S/xb7ON0rGLvL7e9Dzhr9x7qrwcVCXXDU/muw0Yg71W6Pe1hokQLczcGIV5QG0p49z
         gUklz+0j2JKLH8GMhCJnESv58+k/jED/pa7dlv2ddWBHTuzffH2sC+l+oHCgwy6YyYVC
         aNmnr9AqW8TCSaJ5qOCsizFfZhsO3lsGqHe7EyH42f6DbIqJbouQzfi+qj0AZE93RaT2
         nmzDKn5WP6J2oBHcb8AkMbC2PZjd8SziweGTOK1AA6oC6bvGiOBtf0z8gwhDH0ura5mi
         i4bSyYoAdB27kCyIMgzc2hFyPF9sR7tgapnz3Ui4BEWAG71z68QpIvewTKZFEci5NBva
         Mk0w==
X-Gm-Message-State: AOAM531rOANdWQEleeC7XJaBBZFMrEIll4C5fgCfHAa9q7TT/NOmpbsF
        qAiTMuBG+1xgJmjl5kT3OhqcIDbjLdxo73+TVMg7yqdqD47i7njEvIHMrO/4kKnvcGN4DhQC55s
        p1AH1EMQYgUuR
X-Received: by 2002:a65:6658:: with SMTP id z24mr924181pgv.266.1627976503787;
        Tue, 03 Aug 2021 00:41:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTQ9FIMwD850kYRySFMOvwSa2Mh3zZSaM4w5MdRtHBvqDzhjK3JTqHR+x1mQoJbyhltJ0O8Q==
X-Received: by 2002:a65:6658:: with SMTP id z24mr924161pgv.266.1627976503586;
        Tue, 03 Aug 2021 00:41:43 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r15sm13016701pjl.29.2021.08.03.00.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:41:42 -0700 (PDT)
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com>
Date:   Tue, 3 Aug 2021 15:41:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:34, Xie Yongji Ð´µÀ:
> Export alloc_iova_fast() and free_iova_fast() so that
> some modules can use it to improve iova allocation efficiency.


It's better to explain why alloc_iova() is not sufficient here.

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/iommu/iova.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b6cf5f16123b..3941ed6bb99b 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   
>   	return new_iova->pfn_lo;
>   }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>   
>   /**
>    * free_iova_fast - free iova pfn range into rcache
> @@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
>   
>   	free_iova(iovad, pfn);
>   }
> +EXPORT_SYMBOL_GPL(free_iova_fast);
>   
>   #define fq_ring_for_each(i, fq) \
>   	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)

