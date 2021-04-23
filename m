Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64D369B48
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbhDWU3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 16:29:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232573AbhDWU27 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 16:28:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619209701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QfiDtCynhiYl7sLFfmuAReEItnr+/jDE3k1aIjHx0Kg=;
        b=bR3yU5Z9m/Fx9WXh6N/a2sdX7Qry+yvB49+pH/xGZ3Dy2FsDNff6N6c9g2LeegKexfSC1c
        XB4wg0sQXe6oKj+4ZFwslIW8c+DN6vTM2+1NVyY7HsJt72ekmrDbwJqlyvkSHxq3sG9HP6
        VDAAIxl+dt/aU5XGWFS778xCCJGsKtc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-rU2HqT_aP3WecK31tXbHog-1; Fri, 23 Apr 2021 16:28:19 -0400
X-MC-Unique: rU2HqT_aP3WecK31tXbHog-1
Received: by mail-ej1-f72.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso8862026ejv.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 13:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QfiDtCynhiYl7sLFfmuAReEItnr+/jDE3k1aIjHx0Kg=;
        b=M+eNlmVfhf99F36VVWjBBRGCVJvhksxHqaH5hYMrpdzrHP+ba/XISus4iGBSZRf3PF
         9WyemvECOeWBoSYlu3Vhp3bl2CrqkSi0N0E9JmEOULe2cBPFSqFIAJdfFqSB5Aq3o7yc
         9zrr3iws1fxiU9Fhh9iVkIAc0f7w6hccsl8+JUYR+EQAIRLZnOJEvw47cY+uSdiGzj7u
         ZyEPrlkxnBObGDKaJSfrcrykHF8kwzafwzasmzimafN/8ZlI1b1dJeEs+D8E/aV64dRK
         +lsltS+zRxAGLrxOCbwWffjBSsy3HVfTVUIyZeygrhXDjtRv9UnSnuZ0fRoHUC1Vkg3P
         ueJg==
X-Gm-Message-State: AOAM532+sVTQ5QxavgOEEZi1EQ0U02x4PGIFURZUr7k7cUk01nMg22rR
        wRQz+vC6mxr2WdY6u3Tue2NVp02GcTToBfhArSccXQQU/BoAIoyxnpwyOswuqOY1M5/pue9RgXQ
        U6yNPiZPNnoYU
X-Received: by 2002:a17:907:9607:: with SMTP id gb7mr5870701ejc.380.1619209698708;
        Fri, 23 Apr 2021 13:28:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfrbFBGT1MEbJHG6L0yjyl+q1DlTQm8NpqoE5d2Bcyzx+sjlqc8nfo+myUowMaXqpyvRQssA==
X-Received: by 2002:a17:907:9607:: with SMTP id gb7mr5870697ejc.380.1619209698580;
        Fri, 23 Apr 2021 13:28:18 -0700 (PDT)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id m10sm4794033ejc.32.2021.04.23.13.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 13:28:18 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:28:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Martin =?iso-8859-1?Q?=C5gren?= <martin.agren@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH] uio/uio_pci_generic: fix return value changed in
 refactoring
Message-ID: <20210423162757-mutt-send-email-mst@kernel.org>
References: <20210422192240.1136373-1-martin.agren@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210422192240.1136373-1-martin.agren@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 09:22:40PM +0200, Martin Ågren wrote:
> Commit ef84928cff58 ("uio/uio_pci_generic: use device-managed function
> equivalents") was able to simplify various error paths thanks to no
> longer having to clean up on the way out. Some error paths were dropped,
> others were simplified. In one of those simplifications, the return
> value was accidentally changed from -ENODEV to -ENOMEM. Restore the old
> return value.
> 
> Fixes: ef84928cff58 ("uio/uio_pci_generic: use device-managed function equivalents")
> Signed-off-by: Martin Ågren <martin.agren@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  This is my first contribution to the Linux kernel. Hints, suggestions,
>  corrections and any other feedback welcome.
> 
>  drivers/uio/uio_pci_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index c7d681fef198..3bb0b0075467 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -81,9 +81,9 @@ static int probe(struct pci_dev *pdev,
>  		return err;
>  	}
>  
>  	if (pdev->irq && !pci_intx_mask_supported(pdev))
> -		return -ENOMEM;
> +		return -ENODEV;
>  
>  	gdev = devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
>  	if (!gdev)
>  		return -ENOMEM;
> -- 
> 2.31.1.527.g47e6f16901

