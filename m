Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C1E37A5EF
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhEKLqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:46:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231276AbhEKLqQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620733508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0otTSj3OsAISXi/QZvZvvC7OfoKZIM9PUw7jqrFrVd8=;
        b=FMcOup1ah/qj8qSmCET0A1Nb5KFS16NoOSgFIxK2RZ1ummMxVwIn155GFmn+EL60XLzjpi
        8LBePzjzD6oN2GA2dDk2qebyN6vciwdVao2VXh/GFkN9ECm+hnLbvwCqUz8kmHnGrSSBUU
        oylMXZCSbH3DQZVte/efKrhK5SvLCwY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-n2Z9om77OQC8jxMQdFejVA-1; Tue, 11 May 2021 07:45:06 -0400
X-MC-Unique: n2Z9om77OQC8jxMQdFejVA-1
Received: by mail-wm1-f71.google.com with SMTP id s66-20020a1ca9450000b0290149fce15f03so506702wme.9
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 04:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0otTSj3OsAISXi/QZvZvvC7OfoKZIM9PUw7jqrFrVd8=;
        b=F5/goG6wsmsHvfglzdjHnuWhYG3LwKnKNcJxBM/mQnH1CDCMXm4tTUKC8ck07wJ/4N
         KgqEN+GUELJoBoBcKEf3/RLmdA+Xp7zxJn0MaSwlnl7IkEkQ/bS26OT0zbEvn+/nvFVc
         8OpYDsbtysVCovV+sjwbvHmQwyZ0FbNaTkdeDKIaGKPSS5NMAMmSJL74rSYt8c+8CXBZ
         UkMFn78oz6w/6nxLajvkRH8+hZKkaTZf4nUNC2ibcCtfYJAi1ZhV7a77YnKMYaZI4f6W
         5Ohz2E+vDPEjpIwf7GXCADoPIxqTIyJeKnYNlIPXh8XRkhViLpTzTh22H1OzVshoeauM
         wM2g==
X-Gm-Message-State: AOAM533JMJzD6+OtQTpGNyd1LHgf0VXV9xYnheLekfB2HhbWz3T3z2ho
        2Spb/UTXV/uwz03pn4FDsszFNM1T20gxc0IVwFvWCBs5zCm9h1c5SywtOs9vCAyzNIe5/8wTNf/
        KqsVwoFGLNOjk
X-Received: by 2002:a7b:c7d0:: with SMTP id z16mr31843669wmk.22.1620733505081;
        Tue, 11 May 2021 04:45:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeoG0qMkWvIW/Vmsi2YQP64+0h62W/3xn4fsB9Rj2MA+kkAHHPP/2nY55iSlh5Wwgi0nCLYw==
X-Received: by 2002:a7b:c7d0:: with SMTP id z16mr31843653wmk.22.1620733504892;
        Tue, 11 May 2021 04:45:04 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id f11sm3243694wmq.41.2021.05.11.04.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 04:45:04 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: cpumodel: FMT4 SCLP test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-4-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <10c758a5-9347-37ad-dc37-f4cde5af066c@redhat.com>
Date:   Tue, 11 May 2021 13:45:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510150015.11119-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.21 17:00, Janosch Frank wrote:
> SCLP is also part of the cpumodel, so we need to make sure that the
> features indicated via read info / read cpu info are correct.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/cpumodel.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 4dd8b96f..619c3dc7 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -2,14 +2,69 @@
>   /*
>    * Test the known dependencies for facilities
>    *
> - * Copyright 2019 IBM Corp.
> + * Copyright 2019, 2021 IBM Corp.
>    *
>    * Authors:
>    *    Christian Borntraeger <borntraeger@de.ibm.com>
> + *    Janosch Frank <frankja@linux.ibm.com>
>    */
>   
>   #include <asm/facility.h>
>   #include <vm.h>
> +#include <sclp.h>
> +#include <uv.h>
> +#include <asm/uv.h>
> +
> +static void test_sclp_missing_sief2_implications(void)
> +{
> +	/* Virtualization related facilities */
> +	report(!sclp_facilities.has_64bscao, "!64bscao");
> +	report(!sclp_facilities.has_pfmfi, "!pfmfi");
> +	report(!sclp_facilities.has_gsls, "!gsls");
> +	report(!sclp_facilities.has_cmma, "!cmma");
> +	report(!sclp_facilities.has_esca, "!esca");
> +	report(!sclp_facilities.has_kss, "!kss");
> +	report(!sclp_facilities.has_ibs, "!ibs");
> +
> +	/* Virtualization related facilities reported via CPU entries */
> +	report(!sclp_facilities.has_sigpif, "!sigpif");
> +	report(!sclp_facilities.has_sief2, "!sief2");
> +	report(!sclp_facilities.has_skeyi, "!skeyi");
> +	report(!sclp_facilities.has_siif, "!siif");
> +	report(!sclp_facilities.has_cei, "!cei");
> +	report(!sclp_facilities.has_ib, "!ib");
> +}
> +
> +static void test_sclp_features_fmt4(void)
> +{
> +	/*
> +	 * STFLE facilities are handled by the Ultravisor but SCLP
> +	 * facilities are advertised by the hypervisor.
> +	 */
> +	report_prefix_push("PV guest implies");
> +
> +	/* General facilities */
> +	report(!sclp_facilities.has_diag318, "!diag318");
> +
> +	/*
> +	 * Virtualization related facilities, all of which are
> +	 * unavailable because there's no virtualization support in a
> +	 * protected guest.
> +	 */
> +	test_sclp_missing_sief2_implications();
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_sclp_features(void)
> +{
> +	report_prefix_push("sclp");
> +
> +	if (uv_os_is_guest())
> +		test_sclp_features_fmt4();
> +
> +	report_prefix_pop();
> +}
>   
>   static struct {
>   	int facility;
> @@ -60,6 +115,8 @@ int main(void)
>   	}
>   	report_prefix_pop();
>   
> +	test_sclp_features();
> +
>   	report_prefix_pop();
>   	return report_summary();
>   }
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

