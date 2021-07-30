Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787F93DBAFC
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbhG3Oqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239185AbhG3Oql (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 10:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627656396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nD2LfDK5V0KudzsHM8L+/67w/lp/ADAceaawIhpxJt8=;
        b=K/H3cXCRScwQJ+czvz6HKxHDTW0WhX4RH/dhgox2lTec5/DUb75CfVKHTq4o7zMP8AI0F7
        V444HZu6CFj+P8X/caW5IxcoqyGB73v/wnRgoASxhRr/QeYaNtT4m5wR+pr1sSsnA5+4xb
        4Lc2We0S/PUckxL7g5No+bTi6tSHOwU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-gi9oJ3lfNe2lRIIWxLezVA-1; Fri, 30 Jul 2021 10:46:35 -0400
X-MC-Unique: gi9oJ3lfNe2lRIIWxLezVA-1
Received: by mail-wr1-f69.google.com with SMTP id o8-20020a5d4a880000b029013a10564614so3294708wrq.15
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 07:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nD2LfDK5V0KudzsHM8L+/67w/lp/ADAceaawIhpxJt8=;
        b=ZMtQR/3XWUYWZW6RR+pdknvDEZMSxGzUI0NsFp8o/r+Iaj9WPGzrEYgdXjvxVji5NW
         D3UcHrkC/J/J2m6+/saFPXSlFnOaV2zeiAprbnu0E8PLnZ+nrHyKt4B4zf4sQqrrbPAR
         UZHXaI+MiLNYk15mw+J9KxUrExH/mkbzbyiRW00uqKPVaxKxCvGHVZZ3rAdwjjukuezj
         MtiMCX3sCEdkMrmpgN1qJkzRuzgxXubYC17FQD6YUDeB2jyy26Yu218cdM9tc1IHoVTR
         reZ8bk+/J/ceF72sSG7VrpG/TZfpdfs34ECQTTGY67AqmABYug0Yqlo/wW7geQtQ5f++
         +6Iw==
X-Gm-Message-State: AOAM533AIlsS93a4u3u2aWP67W7staSzTSu2YzMru5JcHFLnm+fE+MPC
        qjbT6gd8XDxY+giOALErewBuFGkRl4G70IaSvRzKv0ewtpvASilmuUcEGXl3xOvgaWsNqFjS4+N
        tLeU9jvFMPezX
X-Received: by 2002:adf:f110:: with SMTP id r16mr3440009wro.358.1627656393994;
        Fri, 30 Jul 2021 07:46:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoe56kStW4UdUBwmtRKFzNS0WDSMqier5up9gpHBjzBCacrkuBdo+oN2BtQ90dqB3KLYTX/w==
X-Received: by 2002:adf:f110:: with SMTP id r16mr3439991wro.358.1627656393850;
        Fri, 30 Jul 2021 07:46:33 -0700 (PDT)
Received: from thuth.remote.csb (p5791d280.dip0.t-ipconnect.de. [87.145.210.128])
        by smtp.gmail.com with ESMTPSA id j5sm1909395wrs.22.2021.07.30.07.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 07:46:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: lib: Introduce HPAGE_*
 constants
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-1-frankja@linux.ibm.com>
 <20210729134803.183358-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <820e39e3-3ea4-42e5-c89e-f271bb25b886@redhat.com>
Date:   Fri, 30 Jul 2021 16:46:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729134803.183358-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/2021 15.48, Janosch Frank wrote:
> They come in handy when working with 1MB blocks/addresses.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/page.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
> index f130f936..2f4afd06 100644
> --- a/lib/s390x/asm/page.h
> +++ b/lib/s390x/asm/page.h
> @@ -35,4 +35,8 @@ typedef struct { pteval_t pte; } pte_t;
>   #define __pmd(x)	((pmd_t) { (x) } )
>   #define __pte(x)	((pte_t) { (x) } )
>   
> +#define HPAGE_SHIFT		20
> +#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
> +#define HPAGE_MASK		(~(HPAGE_SIZE-1))
> +
>   #endif
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

