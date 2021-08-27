Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618493F9ABD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhH0OSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 10:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhH0OSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 10:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630073862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvsE54zH/Q6lwEJkx0yPhkkdoX0CrsLr4U5mSYQur+k=;
        b=De/NpmzGpYAZLuD4UqXrZvgmtgvCEd0D1Ew5e4R3EeEXQSv73MwhJqNfCyAdqBuYoFP4BH
        bL95jkM/JMteG1NXdvHCSE5TvufAyBwn8m5hbQbLLiOvYRuZ8OJh4jQHHGv0PiyJ9NCVsn
        ktZv4ic6ZSmigoMP2D/BKYNA+X0AtT8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-Ve_KbAvAM5uJw0nQHuhK6g-1; Fri, 27 Aug 2021 10:17:40 -0400
X-MC-Unique: Ve_KbAvAM5uJw0nQHuhK6g-1
Received: by mail-wm1-f70.google.com with SMTP id h1-20020a05600c350100b002e751bf6733so1802400wmq.8
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 07:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GvsE54zH/Q6lwEJkx0yPhkkdoX0CrsLr4U5mSYQur+k=;
        b=PP9Xfh22CVjhPYmtARRlyzvC6E8tE04HD66GxvKvDP9KGd2Ftdp+yBfU5cVu+t8SZx
         feRb7iBURUPpdnRAgAgNfS47gOvUMUPt59y8EwtKt8qX5FCZFYZPLaBOGxXTKsfZkwbB
         I1Aqo8h+PrZhVLgLBa+dvhg6Vyen6CMjyNth5Y5fpSnC6na4bdcPXgUnZAiQ5QkgVdI+
         N09r4DHaR/AlV7Z5ohsBEEBERoVwG9lIYsFjhR6fYkyKoIRNdJRhTCtk3ep/Twa601DS
         aGv4+5thFYDePPP1vGR99CJSOUgllgCcHXeAmPQmIjtH95u4bXlAlykwjNpa/GaLlPwq
         dEhg==
X-Gm-Message-State: AOAM53099QQrVOumIKS8Ta4vxezzM4N2V75KjmIY8NVX1WlNvQ2M8kcu
        VKqeNjwx27suQK/nnHirk0kKSVGdtqq4WFuLqI/5ja7lNaLW+zdlmDxBWQMTlXGfGdROXC01lMN
        ucVCTevETlyiX
X-Received: by 2002:adf:c785:: with SMTP id l5mr10747564wrg.360.1630073859586;
        Fri, 27 Aug 2021 07:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhWQT/gKMwUWWXonhtMPa7OWc5O0g75JajRoLb0idXm1tUR4ztDcuyOh7elIiCthS8Cz+QHg==
X-Received: by 2002:adf:c785:: with SMTP id l5mr10747535wrg.360.1630073859391;
        Fri, 27 Aug 2021 07:17:39 -0700 (PDT)
Received: from thuth.remote.csb (dynamic-046-114-148-182.46.114.pool.telefonica.de. [46.114.148.182])
        by smtp.gmail.com with ESMTPSA id k16sm6598673wrx.87.2021.08.27.07.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 07:17:38 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2] Makefile: Don't trust PWD
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20210827105407.313916-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <60b4fab4-0337-ebd3-48f9-ba74faa6caec@redhat.com>
Date:   Fri, 27 Aug 2021 16:17:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210827105407.313916-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 12.54, Andrew Jones wrote:
> PWD comes from the environment and it's possible that it's already
> set to something which isn't the full path of the current working
> directory. Use the make variable $(CURDIR) instead.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28c9319..6792b93c4e16 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>   cscope:
>   	$(RM) ./cscope.*
>   	find -L $(cscope_dirs) -maxdepth 1 \
> -		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
> +		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>   	cscope -bk
>   
>   .PHONY: tags
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

