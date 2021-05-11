Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8546037A5E3
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhEKLlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:41:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231409AbhEKLlH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620733201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yjB7dqXnO7Oz56DntzKqDo8+xChSMWY5z8HK6XFxLuk=;
        b=g90efToIPIDm0m3thXnBEhMe8weMkRl3ZE507fNMLAOBVbFRSJjIDHUapugZ4Fy2qzv3Zn
        JdANTFzanuWGc6bJNIYIhXGooUWbP+5OQ9kryylX2aR2fklTa3UeRnHmSLaqTRG5OaCjNb
        BYueZH4oen+koZ2hNW/pylaDeG5qgyk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-PsRSgFjxNSmBXqIlGGeutQ-1; Tue, 11 May 2021 07:39:59 -0400
X-MC-Unique: PsRSgFjxNSmBXqIlGGeutQ-1
Received: by mail-wm1-f72.google.com with SMTP id g199-20020a1c9dd00000b02901355dd71edaso933724wme.7
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 04:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yjB7dqXnO7Oz56DntzKqDo8+xChSMWY5z8HK6XFxLuk=;
        b=DAmjLDbLny9/F9XOEAPDOIQR33rEYU5oRO1wdIUJBm2kOZSXv9dX8IWLo8MQgjy6Vd
         T3mE5godG2QvSBajqkrBuihNhbjyzXz9GxZMBT1YCFJtEFHdq8p1kqZRA5GPJxi0P9Pl
         rrO+7CQDnSusf+//Ylwy5NVTl820R0/WV7Zf/RjAGQ/DX3U126WSWcXMMRnysXfBmCM8
         vFnzEJMwkAI5NX9tyBRRye0MzGPd2pEYNO2m1dD22ORQfhhsI+PcBfpnq3FVz+DK0zXa
         wYdlygFrs1ENptTIY8SNkoGdA60BguWLInu/03t6CXTKH7X0XPlB7UbJPAeGAElbncin
         1epw==
X-Gm-Message-State: AOAM532DZltweaY3Dhe6V2yJPpBQcJJlsA4r1LiahxCwihwtkyPPOp5W
        O9LR4BVQMtUUWnBmzxH+Xj0fLxKyk0y8Z9Zsyp7aKRlMXPlcauU2wuV/AMbXnlCgFIZhDa7xAok
        /vFR0RDLNrc6j
X-Received: by 2002:a1c:f70d:: with SMTP id v13mr3261110wmh.183.1620733198529;
        Tue, 11 May 2021 04:39:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjkDdjJJUARQXp0aF3NmnJVwjOXlQUh4rTsb2x3SNnrK7lnD3VQRixmRuDTGJg/ahiLWsenA==
X-Received: by 2002:a1c:f70d:: with SMTP id v13mr3261085wmh.183.1620733198327;
        Tue, 11 May 2021 04:39:58 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id v1sm8221951wru.73.2021.05.11.04.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 04:39:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: sclp: Only fetch read info byte
 134 if cpu entries are above it
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-2-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <450c17cf-4431-73dc-164d-725bb0626c9d@redhat.com>
Date:   Tue, 11 May 2021 13:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510150015.11119-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.21 17:00, Janosch Frank wrote:
> The cpu offset tells us where the cpu entries are in the sclp read
> info structure.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/sclp.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 7a9b2c52..f11c2035 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -138,7 +138,8 @@ void sclp_facilities_setup(void)
>   	assert(read_info);
>   
>   	cpu = sclp_get_cpu_entries();
> -	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
> +	if (read_info->offset_cpu > 134)
> +		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
>   	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>   		/*
>   		 * The logic for only reading the facilities from the
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

