Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C244397407
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhFANYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 09:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233758AbhFANYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 09:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622553791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3IodH3/5b4duTPUMi2lNwYDriGX2oiejhw+9uyi1y0=;
        b=IJJv3mruEdmwfYQc2QriEe9sM+d7CN1SCIdwXLJT6xmmI1pnVIOP6XRVMAu+k7LLsQbqlq
        sOCvXxBnx7aSZt7n1wWFAKTvVeyVDc9PkMoy843ecYdSSc7G1FE318PbQ1dxbLoFCkcLlK
        Ghw9Ekk7rBUUBVbm4ZDnPawnHH9hz74=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-THVEDk4qMFO2UADUk9pJBA-1; Tue, 01 Jun 2021 09:23:09 -0400
X-MC-Unique: THVEDk4qMFO2UADUk9pJBA-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so7814836edd.2
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 06:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=J3IodH3/5b4duTPUMi2lNwYDriGX2oiejhw+9uyi1y0=;
        b=AwAK6YhoU9vN8Jn6buo7PPCX+APsu6EmJ+xhbD1IuvDiyQrCPEqsMf091aNtVvLika
         1bbeLKQKQzJj6R91srLBoLD78JAU3Ya6g/J6FY1Cx4nGjnfrUmNCFfG7rMejdF3jxSlE
         wpeJPlmzvWrc/qFvGaA/4g+hOUqLhQvTDHSjrpzz2CQExh8YegsZywZcNCBTYoqQiDUv
         9lcgO6xIoQpt7GtV86XfR5nmBDfyh9hKJYJB4G+l5oXA1873PPNeQ5EoePz3CqFx2Z+2
         TE5bDtDe2pm02SWamk65ifUH18zolIrPlEq/88BtnyXHytBNWkCYZHPm1t6BbxTtXIv3
         d/vg==
X-Gm-Message-State: AOAM5328mVKpE6TXdoBB3MdYFioPy75JvbHdtPQF907+NQaTUZVDig/u
        BR/PaDwH4NogKz4vjZCaRsYvuMjZGI6LRyJDEGpimI6ISmkH9zWzIriUNXinihrQeaD4Vg70zns
        KbDmAaqpaxZvT
X-Received: by 2002:a17:906:dffc:: with SMTP id lc28mr15927672ejc.96.1622553787895;
        Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5RCkzLnBYYcXilaqIyjeB0+R4VhL9QfSWNvwncl7kByJOJVcRNOUzLrUOFq0trQAooTIEjg==
X-Received: by 2002:a17:906:dffc:: with SMTP id lc28mr15927655ejc.96.1622553787709;
        Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id w14sm8639958edj.6.2021.06.01.06.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
Date:   Tue, 1 Jun 2021 15:23:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests
 for TCG
Message-ID: <20210601132305.3r5x456icpaa454h@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-4-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210525172628.2088-4-alex.bennee@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 06:26:27PM +0100, Alex Bennée wrote:
> With the support for TCG emulated GIC we can also test these now.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> ---
>  arm/unittests.cfg | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index f776b66..1a39428 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -194,7 +194,6 @@ arch = arm64
>  [its-migration]
>  file = gic.flat
>  smp = $MAX_SMP
> -accel = kvm
>  extra_params = -machine gic-version=3 -append 'its-migration'
>  groups = its migration
>  arch = arm64
> @@ -202,7 +201,6 @@ arch = arm64
>  [its-pending-migration]
>  file = gic.flat
>  smp = $MAX_SMP
> -accel = kvm
>  extra_params = -machine gic-version=3 -append 'its-pending-migration'
>  groups = its migration
>  arch = arm64
> -- 
> 2.20.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm


Reviewed-by: Andrew Jones <drjones@redhat.com>

