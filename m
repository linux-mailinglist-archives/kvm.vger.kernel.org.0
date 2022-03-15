Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CB74DA627
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 00:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352540AbiCOXR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 19:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbiCOXRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 19:17:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85AE46644
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 16:16:09 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b16so577246ioz.3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWQCIDU5jEufwl7Eenakcb0vQxFa1/UoqORJLjuuNhE=;
        b=QPne9aKrq0jSJxwKAvN2RfdcxxPofCtmfVt75fA8YVrNJPDiYxQXuHO4+3AfxM2Vwe
         Aucldu1FnNvysmOxcFjg7PvgDeuRU3+UgHKeLlu8bX2elW3Jo/2EnIdEtAZyKA7/rULi
         Lwqe9KvnjIqsZq28oCcivnx/lr9CAGyJS+bwxPlWEdTH1o3iA0HbdkiEUlxvg97t+qQj
         mXL6h7WNhIkr2vR8PybLX/e2W74SwkklhEipaLRGwNZ2jP4UOnH04rYpv68jqAKRG90W
         4/pxYM7C55nfMmVmWZRxsmA2Ib5aRJmjHdkWtPuX20QeFWJlutQkHrBBH2rzQTWsR8Nr
         vCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OWQCIDU5jEufwl7Eenakcb0vQxFa1/UoqORJLjuuNhE=;
        b=0bPqUL6p3GZmW6fmnzu4lD8Bmkp391eq/05fvfhsjh3bYvbkT9A87+TwMqgw2E42+v
         uCj8otzwoe1tbsIdz1UbUp4j2GaMqER+rqSd49H4oALt0ihrIzTxUXibn7dKmR2c06lO
         2BJ75YjxW+R8y97jyaJsdRcCssiRRTo7CqywY2CHtQNrsqua+Ug5zKK2fIeGkkjlSlsy
         ytcyt7E2rIWPBqKZJZFdCw8LcPlVqubL4GcWunnQD36QYJzkqm7C1c/g7NWAJen47fk9
         lqIEtLFX+d5I0EB8fh2OkqGw6eug+ox6dylUqkOgcpwPRyZiYd+BzNIthZKUS3w93Jb1
         LtVg==
X-Gm-Message-State: AOAM531wjOZc269couGOnewYNTMQxWAk49VuYOlwRnWj4sbFeYjHQJTe
        XszajrCPAqCi5IwX93HwsCSiQg==
X-Google-Smtp-Source: ABdhPJz9YtpbRtn+pOoVIMY+c8V/BrQ1H9IrGkr7iACumNBQrKchs6uMxcvVd/awNz9d3c+1qeU+fQ==
X-Received: by 2002:a05:6638:388e:b0:317:7979:f5bf with SMTP id b14-20020a056638388e00b003177979f5bfmr23978652jav.53.1647386169148;
        Tue, 15 Mar 2022 16:16:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id s185-20020a6b2cc2000000b00648d69f367asm157422ios.16.2022.03.15.16.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 16:16:08 -0700 (PDT)
Date:   Tue, 15 Mar 2022 23:16:05 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/4] irqchip/gic-v3: Exposes bit values for
 GICR_CTLR.{IR, CES}
Message-ID: <YjEeNThfYFtTffWz@google.com>
References: <20220314164044.772709-1-maz@kernel.org>
 <20220314164044.772709-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314164044.772709-2-maz@kernel.org>
X-Spam-Status: No, score=-16.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Mar 14, 2022 at 04:40:41PM +0000, Marc Zyngier wrote:
> As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
> the include file with the architectural values.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 12d91f0dedf9..aeb8ced53880 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -127,6 +127,8 @@
>  #define GICR_PIDR2			GICD_PIDR2
>  
>  #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +#define GICR_CTLR_IR			(1UL << 1)
> +#define GICR_CTLR_CES			(1UL << 2)

I think these are backwards (IR is bit 2)

https://developer.arm.com/documentation/ddi0595/2021-12/External-Registers/GICR-CTLR--Redistributor-Control-Register?lang=en

--
Thanks,
Oliver

>  #define GICR_CTLR_RWP			(1UL << 3)
>  
>  #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
> -- 
> 2.34.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
