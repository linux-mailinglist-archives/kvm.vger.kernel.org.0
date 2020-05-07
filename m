Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4401C8734
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGKrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:47:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52608 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725914AbgEGKrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 06:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588848459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5GBZ1BPaYoUZGlKv+l0CXQxh4T9djzRMOd1T5tvSABs=;
        b=QbKXJKbB1MkI06PS2+PwYfsG7LATq18yKcePAHwHhGA34r6qPUbcaVzO7OAeCuDVjybSZH
        Gy55vXi3ArhKoAX5rLC7x/IgjnT2z1t9sdbgjnbm2wXkXkvOy/V23kJL9Tv5VaVh1MytD1
        rRb0/q/Cj02Oe4TW1hFatfjnlsFNhH4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-ho5-gsoTOvGpG3Mdy-8_8g-1; Thu, 07 May 2020 06:47:37 -0400
X-MC-Unique: ho5-gsoTOvGpG3Mdy-8_8g-1
Received: by mail-wm1-f71.google.com with SMTP id t62so3147879wma.0
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 03:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5GBZ1BPaYoUZGlKv+l0CXQxh4T9djzRMOd1T5tvSABs=;
        b=q8ivciUkM3WUuYX+3/6oh71yjp+VeeNcxUEFmnRYsThJZwTHEutcWNzB08kF8DHQJJ
         jh1bpePPbp5a/v3ohFaH0PDAS92zm3z7WFoaM1pO8ECBzeTLkLWA4BgHTtdkqvSHIQBu
         IIVpk54XSOwsKledtQlnlNyw5Qx0cpUkqL6/qNUBNd9ytHyq1H3/M4xUE9x/MNXIFU9U
         5WYCahnrMfPcSILp2NPRQxeUxUe3F4/wgXmbYHBQl4hVQ/b9CgF7VXg0XPoXmRLMCU1q
         L4XjFi+a/a1SzEBlIXADVBWwW/f6VZGR5IWw/Q0POHJuOASyBQAr7FR1/sEiKOYCCBhr
         3u7Q==
X-Gm-Message-State: AGi0Pubh3RtMci59E5VPn2yOdhIT4/6y6IquUkRCqGJECHVXPwu41Yz1
        cb0FWSb460AEIkNMu7IXFspXwwK0YfpAT+L/lUVaPGZph0PShq7J1IgA6DWHgdBD0n6QfrG8cb8
        jie83lHCyw9Ir
X-Received: by 2002:adf:e751:: with SMTP id c17mr15873038wrn.351.1588848456324;
        Thu, 07 May 2020 03:47:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypLG5sLX7vjTBpzQVJYqyJozq0EEasF4Ci+xsJ7MLTLakuqA8erklYkKxDwmmh/F0jhS05XJgw==
X-Received: by 2002:adf:e751:: with SMTP id c17mr15873017wrn.351.1588848456163;
        Thu, 07 May 2020 03:47:36 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id a9sm7225179wmm.38.2020.05.07.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:47:35 -0700 (PDT)
Date:   Thu, 7 May 2020 06:47:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 10/15] MAINTAINERS: Add myself as virtio-mem maintainer
Message-ID: <20200507064709-mutt-send-email-mst@kernel.org>
References: <20200507103119.11219-1-david@redhat.com>
 <20200507103119.11219-11-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507103119.11219-11-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 12:31:14PM +0200, David Hildenbrand wrote:
> Let's make sure patches/bug reports find the right person.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Make this patch 2 in the series, or even squash into patch 1.

> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4d43ea5468b5..ad2b34f4dd66 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18037,6 +18037,13 @@ S:	Maintained
>  F:	drivers/iommu/virtio-iommu.c
>  F:	include/uapi/linux/virtio_iommu.h
>  
> +VIRTIO MEM DRIVER
> +M:	David Hildenbrand <david@redhat.com>
> +L:	virtualization@lists.linux-foundation.org
> +S:	Maintained
> +F:	drivers/virtio/virtio_mem.c
> +F:	include/uapi/linux/virtio_mem.h
> +
>  VIRTUAL BOX GUEST DEVICE DRIVER
>  M:	Hans de Goede <hdegoede@redhat.com>
>  M:	Arnd Bergmann <arnd@arndb.de>
> -- 
> 2.25.3

