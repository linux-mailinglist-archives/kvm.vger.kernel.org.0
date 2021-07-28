Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833113D8BE1
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhG1KdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:33:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235315AbhG1KdP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627468393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBnjip7bmZlo5iIFfE9USXwqXSxtKiL/lSH0+0EZMvE=;
        b=TGYPqAzsAE4/NcRsgdiq9Z1xC5AmLmWEcPWs7ypDslhvTQfjzvqrHNHKzrBxDwa7vpkILp
        GSjBstbxGWKm6PVmpHsD1yjmb0Y7eH5/aOmxJhVY6Yf7Al9sD/eVj+/WDEhR/V+pMopxPs
        bnZY+2rWm5rgXhKgOKAeKpcXP/9Fotw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-9EJq_-r5OJ-Zs1gWHcTdcg-1; Wed, 28 Jul 2021 06:33:12 -0400
X-MC-Unique: 9EJq_-r5OJ-Zs1gWHcTdcg-1
Received: by mail-wr1-f72.google.com with SMTP id r14-20020a5d4e4e0000b029015409d80a01so504984wrt.12
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 03:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IBnjip7bmZlo5iIFfE9USXwqXSxtKiL/lSH0+0EZMvE=;
        b=kpjc82/QQ4lak0zlOsnJi8+3YUq7QgFtu6ZUDiwIkyIhZyvriBUv7D5nRRTpPlp3/b
         ZtP0u6LVuJbsLkWkERdL3p8+Xx3+7YplBeKzVfrAJVvMThHbpzAOGOIpFP9K+61rprhP
         WFOEN5p3/S/Z9xRtm9ZJ8p1V+IlJUK6GvgD+CPE5JuyZDrRgsxLldSbDXtPXXHHnF6MS
         sofdbuCdyJ3sG1DezpEDc+BTXNzyQpMGRAHTeYSYQbpclsh7rLy1ohLdhyTuWcSvG5ig
         79pqY3a0sVU3e3TcLxqJAw/xA3rU4iaN12M0deyWjhVy73e2nPMjzajxS1J9fzS86emC
         pDqQ==
X-Gm-Message-State: AOAM533eU/1JhXq6EgvISdjtLTjrqlLibQwn7hYgm0zXhm0562nENOvV
        G54IQwCpgpOl5cuowqXTnEwyelzlceCfp6+sjXFUeQkPf9aCQr3CxtkQAQVn3lXxQB9p6i2nPrj
        ppXsCt35V1R4f
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr19621475wrx.379.1627468391080;
        Wed, 28 Jul 2021 03:33:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg+mRSLuRF0fKoIVNkZUaXxgdmcVCNiAJAjD+MCyNtOlp9tZSli5/Dg0H/oK/AX3nCaTBDpA==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr19621459wrx.379.1627468390926;
        Wed, 28 Jul 2021 03:33:10 -0700 (PDT)
Received: from thuth.remote.csb (p5791d475.dip0.t-ipconnect.de. [87.145.212.117])
        by smtp.gmail.com with ESMTPSA id s3sm6128233wru.29.2021.07.28.03.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 03:33:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210728101328.51646-1-frankja@linux.ibm.com>
 <20210728101328.51646-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7e33e33f-63ef-c4d9-50d9-c1df150af1e6@redhat.com>
Date:   Wed, 28 Jul 2021 12:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728101328.51646-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/2021 12.13, Janosch Frank wrote:
> Seems like I missed adding them.
> 
> The s390x/sieve.c one is a bit of a head scratcher since it came with
> the first commit but I assume it's lpgl2-only since that's what the
> COPYRIGHT file said then.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/uv.c   |  9 +++++++++
>   s390x/mvpg-sie.c |  9 +++++++++
>   s390x/sie.c      | 10 ++++++++++
>   x86/sieve.c      |  5 +++++
>   4 files changed, 33 insertions(+)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 0d8c141c..fd9de944 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Ultravisor related functionality
> + *
> + * Copyright 2020 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>   #include <libcflat.h>
>   #include <bitops.h>
>   #include <alloc.h>
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 9bcd15a2..5e70f591 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests mvpg SIE partial execution intercepts.
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>   #include <libcflat.h>
>   #include <asm/asm-offsets.h>
>   #include <asm-generic/barrier.h>
> diff --git a/s390x/sie.c b/s390x/sie.c
> index cfc746f3..134d3c4f 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -1,3 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests SIE diagnose intercepts.
> + * Mainly used as a template for SIE tests.
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>   #include <libcflat.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/arch_def.h>
> diff --git a/x86/sieve.c b/x86/sieve.c
> index 8150f2d9..b89d5f80 100644
> --- a/x86/sieve.c
> +++ b/x86/sieve.c
> @@ -1,3 +1,8 @@
> +/* SPDX-License-Identifier: LGPL-2.0-only */
> +/*
> + * Implementation of the sieve of Eratosthenes
> + * Calculation and memory intensive workload for general stress testing.
> + */
>   #include "alloc.h"
>   #include "libcflat.h"
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

