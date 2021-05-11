Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F390537A5F8
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhEKLrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:47:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231341AbhEKLrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620733569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnehP62jTgxCuPr6k9MZbaNlRjHOqW8Ae/zjW9smOX8=;
        b=RNojMiuz8y8OYboeb/ETPKTecLsa5t03bYQZp3V45bq+Pj1jIpdbJq5PNfE0V0dNmPMMnZ
        z1a2cUuL/XP9f0kyfbuBhcmKk79M1hPdTyepSfFq7bfdi4CTWsBuvRr7YntxjTq1m6dIx7
        Lj42kAm6gXUa6G1zGlNxVKhoKjNVA6k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-5Kkja7z4Mu61aDtCs5NGFQ-1; Tue, 11 May 2021 07:46:07 -0400
X-MC-Unique: 5Kkja7z4Mu61aDtCs5NGFQ-1
Received: by mail-wr1-f71.google.com with SMTP id r12-20020adfc10c0000b029010d83323601so8607547wre.22
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 04:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KnehP62jTgxCuPr6k9MZbaNlRjHOqW8Ae/zjW9smOX8=;
        b=gBRkIzFKn2um/openx2ed6xdN9ekDIBM56rUBfU6Og5/4YitrUwQD883RjtkNVJfhU
         moNahCPARdfEpn7BI7eZtSDe/gPhSuM22SI3M4Xhf6ww/vSdXUOUSBTkJAFRRPWyeVLG
         BASSJVxXrkUCFuwO4Py5Nmn3/MhmuP1zo4JDE2p4m2Fc9sNjdcMmMsspZQy6udIOFcJ9
         ZedYnzSi2VEMLBNL9f3hNgIy0poMQcyOeD8mdIROX9lB2dOElD/NQvlgDqTqmurfahEr
         gbVNySo2dpcEB4nJGQm11no8oIGGsYAYRVhFr4zl/1Y3SJmXawS8R7c4+kz4/FbheH5s
         lRJw==
X-Gm-Message-State: AOAM531UVspMpHc1Sed7YmBirPU7dvtqxTfUgyHDya5S6pKLhMeSns1E
        CpKXWg/7E3rKYLup+hN4BN6mkwrTpqCGZ1cwD/+qmW6aVIGijqf86bFvx9CNBi1biDmnjgiXR2g
        U3JfLjX8x25zH
X-Received: by 2002:a05:600c:4103:: with SMTP id j3mr31747798wmi.128.1620733566434;
        Tue, 11 May 2021 04:46:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrNXEPgoZMyPICExn2J3OJsOKC9meT3BX3Y92xuG75W+OWnljWUaSEdzp9ps1I/zuqPH+AcQ==
X-Received: by 2002:a05:600c:4103:: with SMTP id j3mr31747781wmi.128.1620733566224;
        Tue, 11 May 2021 04:46:06 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id 3sm23617944wms.30.2021.05.11.04.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 04:46:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: cpumodel: FMT2 SCLP implies
 test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-5-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <5f9d81aa-1546-91af-0e06-5e879b854b13@redhat.com>
Date:   Tue, 11 May 2021 13:46:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510150015.11119-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.21 17:00, Janosch Frank wrote:
> The sie facilities require sief2 to also be enabled, so lets check if
> that's the case.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/cpumodel.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 619c3dc7..67bb6543 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -56,12 +56,24 @@ static void test_sclp_features_fmt4(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_sclp_features_fmt2(void)
> +{
> +	if (sclp_facilities.has_sief2)
> +		return;
> +
> +	report_prefix_push("!sief2 implies");
> +	test_sclp_missing_sief2_implications();
> +	report_prefix_pop();
> +}
> +
>   static void test_sclp_features(void)
>   {
>   	report_prefix_push("sclp");
>   
>   	if (uv_os_is_guest())
>   		test_sclp_features_fmt4();
> +	else
> +		test_sclp_features_fmt2();
>   
>   	report_prefix_pop();
>   }
> 

I'd fold that into the previous patch

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

