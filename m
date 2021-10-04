Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4167742070F
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhJDINd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhJDINb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNt/fWJq9H4VOv4gmEOcSD6BHelYlOktyHMHOZ+aCSw=;
        b=Z7Cqpff5azl2v3RTOzoJudD00pu058wtt+f7m+baX4REsenB3ZFdHMNp2bEmVnCKUfjc02
        MyT0+ErpsFLYPIsmW/1feOLxsTrse2Rbjspn0LFI4GQU5Bs/KDD+ERNBZxFpJmeS9f7zZj
        XsiTSEBUZyOFBH3XZTgostIiSW6f6zw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-DLPiNjxvPMWsNWWXotaZ7w-1; Mon, 04 Oct 2021 04:11:42 -0400
X-MC-Unique: DLPiNjxvPMWsNWWXotaZ7w-1
Received: by mail-ed1-f71.google.com with SMTP id w6-20020a50d786000000b003dabc563406so11984219edi.17
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dNt/fWJq9H4VOv4gmEOcSD6BHelYlOktyHMHOZ+aCSw=;
        b=O7TTlvdWjjHwgR0cTEPpPiTJ+UQkqfmuhmrfuD1T28yvVpRl2sEqoF6kzbTQLmWTtd
         8CMowcWJivZ3Gq7PONmZw0xWPvQbAjsvZBXAP8CQT6IorB9k6XTedjHkrij2WNxvyEW0
         2xk8FuDg6fHxznlHfTSRwU+xEBCBYbPF0QNWltEudkSOD7frqtxoaCvf9QjpRbsmD1WA
         dXQNBwXuI9caW/961x3Wv/bR2iQICjrblwJBslS/6Uw7ekNjbRd7XU78MfAbZ5Z16uv9
         hQQBOD1TEJ5IGVrA51NU/vp3k4iEhX6jqF58Nn95fQ7QzRF2N4g8ebZZB7ALB3tW8UHW
         daDw==
X-Gm-Message-State: AOAM530GAeXi8c7jcLWhup7R0pt3zLW+lO4J+BAVx1jr856xKZXITSEC
        jorGnRlY2EovzUqCLDOAIH7zGlzOYPq7oBd/2ymCl5KeT0O8QwbuGFP2AtMesz0GWhzFD8BGAbE
        uG7Hzrpje6XQX
X-Received: by 2002:a50:d8c7:: with SMTP id y7mr16860260edj.133.1633335099156;
        Mon, 04 Oct 2021 01:11:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/7eg1QUsdLOkjXK2hQ27bG0xM0Tb85lV3dlMdIW9CUmmwec7UdrWUxdO1ECuIjw+ov/GVJQ==
X-Received: by 2002:a50:d8c7:: with SMTP id y7mr16860081edj.133.1633335096461;
        Mon, 04 Oct 2021 01:11:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bx11sm6325863ejb.107.2021.10.04.01.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:11:35 -0700 (PDT)
Message-ID: <866140d0-1374-7966-19f0-401ccbf49655@redhat.com>
Date:   Mon, 4 Oct 2021 10:11:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 07/22] target/i386/sev_i386.h: Remove unused headers
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-8-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-8-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Declarations don't require these headers, remove them.
> 
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev_i386.h | 4 ----
>   target/i386/sev-stub.c | 1 +
>   2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index ae6d8404787..f4223f1febf 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -14,11 +14,7 @@
>   #ifndef QEMU_SEV_I386_H
>   #define QEMU_SEV_I386_H
>   
> -#include "qom/object.h"
> -#include "qapi/error.h"
> -#include "sysemu/kvm.h"
>   #include "sysemu/sev.h"
> -#include "qemu/error-report.h"
>   #include "qapi/qapi-types-misc-target.h"
>   
>   #define SEV_POLICY_NODBG        0x1
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 0227cb51778..d91c2ece784 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -12,6 +12,7 @@
>    */
>   
>   #include "qemu/osdep.h"
> +#include "qapi/error.h"
>   #include "sev_i386.h"
>   
>   SevInfo *sev_get_info(void)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

