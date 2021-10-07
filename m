Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC49424FA0
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhJGJDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:03:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231661AbhJGJDL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633597277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ypgwnUahS9XIzZmtGzPfOEo5zBah1g3vGbYlrZE5wc=;
        b=bk3+YCGxdGFf0i2axuhWUoa5VnthoikL1j3VqyD1fVtGg6M08XhLVo4B3QWhMDuCCrWbov
        OTvlxotoiiSwDWp2hEi3VdvCt09Ej0uKAHQHhzNqiA59JxDRH6BY24/OsTcBhMOjHeWVJo
        Sl7o7BLwZ6AlnVXkkT12BVIexa8f8Mo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-YdpwvbmIPha9-qwnAItKEg-1; Thu, 07 Oct 2021 05:01:16 -0400
X-MC-Unique: YdpwvbmIPha9-qwnAItKEg-1
Received: by mail-wr1-f69.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso4127290wra.13
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 02:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ypgwnUahS9XIzZmtGzPfOEo5zBah1g3vGbYlrZE5wc=;
        b=xa0x5VBpq88Z11e+lxM2Ybvgq4Cvi2DJ/Q/d4J9EF1Z2EOxooprhEZAA+0K/DnDkKp
         G2fazx1YTabgvNg5RwTqHVAWuRQPBHj9A44DwtcV6zxz9nyLXsscHAxikAp5+CBo2k2U
         QhYRbfUL5ErGSQOjlTMIg75vQLCMLnllUQOtTP11qOToU76R9UBL2G6HlgIf+QAoc32z
         2AjpL/9eRCeomzdm9yhDpiEd+bbaadU9fvkUePqvGgCmTnFjmxO1kfva1QIM286dGshw
         PaQsYAZDq0ow4Z5Ke0cKii6NAHKZE7pSz9gfAQk2VeYCoq1m67WJZ3zPCgLyItoud07D
         WOhg==
X-Gm-Message-State: AOAM53061Kg7ivkXx7FfBtWcw/0h2LP0tN1fnyJ/Dc3eEX3H6ErLqC8R
        aOSl1b6W4lSV/gICWH1rcvwwm5AdwYqOTRudebIbC6xRDxz59e93w/Otg7TGlsK+BrlX1pQBFWX
        4PBagxESPJSHN
X-Received: by 2002:adf:f48d:: with SMTP id l13mr3758190wro.94.1633597275763;
        Thu, 07 Oct 2021 02:01:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgaecN01seRmQ+dQqy5rj6yiI6HVyvpAX4sDykCKyi3fXq3FZ2gjnh1zfS29aqYRUAj65W+g==
X-Received: by 2002:adf:f48d:: with SMTP id l13mr3758170wro.94.1633597275598;
        Thu, 07 Oct 2021 02:01:15 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id z6sm12166174wmp.1.2021.10.07.02.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 02:01:15 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 4/9] lib: s390x: uv: Add UVC_ERR_DEBUG
 switch
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <078d665b-18c7-5efc-ea0e-54edef5f7282@redhat.com>
Date:   Thu, 7 Oct 2021 11:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211007085027.13050-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/2021 10.50, Janosch Frank wrote:
> Every time something goes wrong in a way we don't expect, we need to
> add debug prints to some UVC to get the unexpected return code.
> 
> Let's just put the printing behind a macro so we can enable it if
> needed via a simple switch.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/uv.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 2f099553..16db086d 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -12,6 +12,11 @@
>   #ifndef _ASMS390X_UV_H_
>   #define _ASMS390X_UV_H_
>   
> +/* Enables printing of command code and return codes for failed UVCs */
> +#ifndef UVC_ERR_DEBUG
> +#define UVC_ERR_DEBUG	0
> +#endif
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> @@ -194,6 +199,13 @@ static inline int uv_call_once(unsigned long r1, unsigned long r2)
>   		: [cc] "=d" (cc)
>   		: [r1] "a" (r1), [r2] "a" (r2)
>   		: "memory", "cc");
> +
> +	if (UVC_ERR_DEBUG && cc)
> +		printf("UV call error: call %x rc %x rrc %x\n",
> +		       ((struct uv_cb_header *)r2)->cmd,
> +		       ((struct uv_cb_header *)r2)->rc,
> +		       ((struct uv_cb_header *)r2)->rrc);
> +
>   	return cc;
>   }
>   
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

