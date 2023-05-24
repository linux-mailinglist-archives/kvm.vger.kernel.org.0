Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABFB70F384
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 11:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjEXJxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 05:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjEXJxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 05:53:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE9F93
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 02:53:12 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f427118644so8587535e9.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 02:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684921991; x=1687513991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FrOm8kjaf/kMK6BQFjHY0qv4Ix8HtAKqXfw+FTyX2aQ=;
        b=IKjtGz09U8TXKu2c8khn2oGWGxV1XKiDNHh+tnB7jByk95DYms1DdKaXgCIk0VAIcI
         jgUxOqJiTWzB41HOD+mcVdT+oywfZomR4l8e0ZIedsZc5yzyxUbAFSwo6mFfQpHsQQMT
         ulYK8k5D0NKjxj8ed62yu9gE1xIsXKCaGNwpGc/X1CwVeMzbxUNQWl3L74FKhNjIch8g
         6faoSjuX3p1esWsz9eUKDa42zrEu1mbvEq6UfBIzmSY6iGQQEY6yvsfQtHK8jgiMnnAU
         AeFh8jz+/wFgwKbSqNll8KwPxQuzfX2ptBOTyiFNvm6cfwOig3Is6ZfJvaG+D6hC89UV
         B6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684921991; x=1687513991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrOm8kjaf/kMK6BQFjHY0qv4Ix8HtAKqXfw+FTyX2aQ=;
        b=V2RxzSSElSrsUlB4LobQDEeBos8jm2ZvR+01s9gP2A77FI70Ze6xSMPCDmx94/3UVG
         zSR0zgFBmt6EYkq499sW220TK1WZ7VKspzA++bS4piS1twKnyWZqfIf6dg1u845R/Zt7
         kNEmeL5fV0nkSouotAe+a+Ioq6B5EfejEyw6b4t5O/EdRKpXOsb4RzVo+PM+Ox9Qay4/
         vgcv0mNk4pDZoG6S5LkP+JsZf+rDcDa9h+ZhO/KZ9OrnaVLUceoIZ7MJx81vjD2w2a3w
         NI8rJz76SF0StXA20DYW+VTszUm5uPTAYfoshdmRW0fKiLALFUKCTjM6rlanLi5bBViB
         Parg==
X-Gm-Message-State: AC+VfDzDgsL3vPqkkkIzpUgRzHZYWa2bXDdYyvMQtCUD6byic42IXWQK
        rlL25mlklfoYR9DDMqJoWYcqTg==
X-Google-Smtp-Source: ACHHUZ6EZt3VMwP4c//tmcQVg2w1/GF2fX1tcNr51SPg1SpGZLIb2d2+OSTysJItOTvDJofcjjT2uQ==
X-Received: by 2002:a7b:c411:0:b0:3f6:3bb:5129 with SMTP id k17-20020a7bc411000000b003f603bb5129mr7298406wmi.23.1684921990898;
        Wed, 24 May 2023 02:53:10 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t16-20020a1c7710000000b003f604793989sm1741284wmi.18.2023.05.24.02.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 02:53:08 -0700 (PDT)
Date:   Wed, 24 May 2023 12:53:04 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     ankita@nvidia.com
Cc:     jgg@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, maz@kernel.org, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 6/6] vfio/nvgpu: register device memory for poison
 handling
Message-ID: <32a8c23a-7db9-4b9f-a2e8-cc978a9b8202@kili.mountain>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-7-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405180134.16932-7-ankita@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 11:01:34AM -0700, ankita@nvidia.com wrote:
> @@ -188,7 +277,20 @@ nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
>  
>  	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
>  				       &(nvdev->mem_prop.mem_length));
> -	return ret;
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * A bitmap is maintained to teack the pages that are poisoned. Each
> +	 * page is represented by a bit. Allocation size in bytes is
> +	 * determined by shifting the device memory size by PAGE_SHIFT to
> +	 * determine the number of pages; and further shifted by 3 as each
> +	 * byte could track 8 pages.
> +	 */
> +	nvdev->mem_prop.pfn_bitmap
> +		= vzalloc(nvdev->mem_prop.mem_length >> (PAGE_SHIFT + 3));

This allocation needs a NULL check.

regards,
dan carpenter

> +
> +	return 0;
>  }

