Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BAF37565A
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 17:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhEFPRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 11:17:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234888AbhEFPRa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 11:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620314191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SA1NrT39CfPyhzZPJSdm4GEH5F6jhjVZb3C8MTdowDw=;
        b=QYX4d3Tj7AniLkHj7wJbHBjtBKFfG9a8KBgCPHf6fqIKM9WiigxPHUKJtLWppRP0FFhM4G
        VFQcEJjBY89BXxw7DzRtOfMf0HxdBcdpr/Kr1HWiL6VlbtJFOH4wnlzE+/tzn7/sHHgvZ2
        2NSJin78k9oXQHN6MjxLgfHFlxex1oI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-gZB_kuU3OHGE8GiKqKlDlQ-1; Thu, 06 May 2021 11:16:30 -0400
X-MC-Unique: gZB_kuU3OHGE8GiKqKlDlQ-1
Received: by mail-wm1-f69.google.com with SMTP id r10-20020a05600c2c4ab029014b601975e1so2369647wmg.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 08:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SA1NrT39CfPyhzZPJSdm4GEH5F6jhjVZb3C8MTdowDw=;
        b=iYxKHuJr5MwWTv3W7n1n6TMDFMYuOovDNE8g0jLIMQQHCuHgcCAiPEROy3oqlIyNlc
         Gn5v3VNZ2XT5dQ7w1cidVlQJJIZFYKS1D8PflbvqI9AsrxJnWdpHxoqCB9TSBnnIB01V
         5aQNiHyYNtkha9QC8IqZNb7lwDdfpnVXRA7ixxeyAWUB2hTiLlR3Mc67tHGggUiJ8PS2
         QSeBzhAyrXyF0yZxlvBP4Dy/82DaJW5B0Z6+KPb7P5+sxwLSREchouho9m30N4bWh8HI
         VsSzunMPTLl++gMmRo2j4XgzAS0vsj5LwqBsK7hhtSoD5cPDS77RP6YBvoHZH31D0xWc
         8y1A==
X-Gm-Message-State: AOAM531lUohmLVNLBjvPBKIMNf9/gxefVlGf8fmreI/31CUL7cUVAxGz
        OUCkxKSMLSNsG0GkHyy4zvxuUeK8wXK5pTGez/gIKqIdtfLkk5WpC2LXmRUqQ243/ZhyEvlqCAD
        +7u4/FKv5UfTw
X-Received: by 2002:a5d:5989:: with SMTP id n9mr5896874wri.60.1620314188637;
        Thu, 06 May 2021 08:16:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMgCRVRkh4jO4sg3+6rUGG1geu3tGpV+QRlPYqSSAYP/uGyLm3QOyZI0kA+MTDJSfE5hV4ng==
X-Received: by 2002:a5d:5989:: with SMTP id n9mr5896838wri.60.1620314188401;
        Thu, 06 May 2021 08:16:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k16sm3862229wmi.44.2021.05.06.08.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 08:16:27 -0700 (PDT)
Subject: Re: [PATCH] tools/kvm_stat: Fix documentation typo
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com
References: <20210506140352.4178789-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9a115b64-6bb2-dae8-911a-56ae6e468178@redhat.com>
Date:   Thu, 6 May 2021 17:16:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506140352.4178789-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/21 16:03, Stefan Raspl wrote:
> Makes the dash in front of option '-z' disappear in the generated
> man-page.
> 
> Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
> index feaf46451e83..3a9f2037bd23 100644
> --- a/tools/kvm/kvm_stat/kvm_stat.txt
> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
> @@ -111,7 +111,7 @@ OPTIONS
>   --tracepoints::
>           retrieve statistics from tracepoints
>   
> -*z*::
> +-z::
>   --skip-zero-records::
>           omit records with all zeros in logging mode
>   
> 

Queued, thanks.

Paolo

