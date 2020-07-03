Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4E62139A5
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGCL51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:57:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30695 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725984AbgGCL50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 07:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593777445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vguke/qtwFZxNa/JyDoWeyEUdyrOhuZE11Fv/Kd8Lxs=;
        b=OxTduzOrNNiAjAEPrcnVCGS9gb1FgEd2y9Snn7nnhLm3kCgOKnLfyQixHxu31iDstM/Jlq
        fiQE3WPkymkOKFVY3Xu2q6D7u3L+SEWF08oyP1xsznGFfhhZSX629VPse64rP7kYiZFOKW
        qY4X78ydm4UhIQcqW7RemOZ7FY8qNus=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-3L9PwWxYM2WnhTxLD_TDQQ-1; Fri, 03 Jul 2020 07:57:24 -0400
X-MC-Unique: 3L9PwWxYM2WnhTxLD_TDQQ-1
Received: by mail-wr1-f71.google.com with SMTP id a18so31367672wrm.14
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 04:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vguke/qtwFZxNa/JyDoWeyEUdyrOhuZE11Fv/Kd8Lxs=;
        b=G+04b0vr5nbznGQ11pNOi4frULqaPwcNdLDyRrCPTZ7cILiyo9btOscZZb83vPt4z1
         nKQF8anN7yoRvBMS/aCs42bBPz/BZyZUDF0y8WlY2rG7l6S2seoSGXVzT0+3Lm6cLhzv
         FVD1o4+TiIpH4sgOV1qO/8UwSkDbploYeFDOG0Jvi77eyZvbHZPtwtehEsapKNAmgJri
         r7cjAmGuN0xW94b8h8+J7oyMvip1uo3PJjOGxCWFrooRyYYv0VPMQSwOMRjWLBY7d2kM
         wQ8f432f5XwE39SPJwYvf+xVT4bbKNxhbmX261ASjJRIFb2EIwutKlZmBjFFPzratCrS
         rWjQ==
X-Gm-Message-State: AOAM530HYi+uJ7JCpeb/CxVemOe2wzaf1iPz/Ruy78e6FSb75/HVn5bo
        yAHdb0NecurjaqIEsKTJE/t6jo5PJ/6bH6xx0La/etwAT3JKSgvM1CKVLG4EdVQLc7Co9pbGzmI
        09fkTZA0G22j0
X-Received: by 2002:adf:9062:: with SMTP id h89mr33730545wrh.285.1593777442668;
        Fri, 03 Jul 2020 04:57:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb51LgLMXS4Pu5vBKIKaww2jRDnYSUGTOwYMr4mM+8Xra1hNP690hF3ro32wVISdhRKFuKXA==
X-Received: by 2002:adf:9062:: with SMTP id h89mr33730534wrh.285.1593777442500;
        Fri, 03 Jul 2020 04:57:22 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id 59sm14372843wrj.37.2020.07.03.04.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 04:57:21 -0700 (PDT)
Date:   Fri, 3 Jul 2020 07:57:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [PATCH v1] virtio-mem: fix cross-compilation due to
 VIRTIO_MEM_USABLE_EXTENT
Message-ID: <20200703075708-mutt-send-email-mst@kernel.org>
References: <20200626072248.78761-1-david@redhat.com>
 <20200703104027.30441-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703104027.30441-1-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 12:40:27PM +0200, David Hildenbrand wrote:
> The usable extend depends on the target, not on the destination. This
> fixes cross-compilation on other architectures than x86-64.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

I folded this into 890f95d1adc8e0cb9fe88f74d1b76aad6d2763d6.
Thanks!

> ---
>  hw/virtio/virtio-mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index bf9b414522..65850530e7 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -51,7 +51,7 @@
>   * necessary (as the section size can change). But it's more likely that the
>   * section size will rather get smaller and not bigger over time.
>   */
> -#if defined(__x86_64__)
> +#if defined(TARGET_X86_64) || defined(TARGET_I386)
>  #define VIRTIO_MEM_USABLE_EXTENT (2 * (128 * MiB))
>  #else
>  #error VIRTIO_MEM_USABLE_EXTENT not defined
> -- 
> 2.26.2

