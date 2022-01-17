Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6982490246
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiAQHB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:01:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235059AbiAQHBz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 02:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642402915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZInfsJu7ErgNvQcctk0yVymFu8hQlMDYYqOyuF8tNVM=;
        b=iTWDqHBz+TZjnRD8G2rpKjC18LOafvDVyN2gDO+j9SdtyBJtDuM2dj5ALdIGRT+K73+uOD
        Q18zGdIPzBn5KKFIKBOnbAe52cv+EmhjLmz3IFItjuNzmzF36wP/C6PlZGgx/Z+lpvepzw
        LlYoOXnSmnjp8B5Qg2kMgRr+EfT7wlg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-4q5iSFI-NdGkzXVGNLEzDw-1; Mon, 17 Jan 2022 02:01:43 -0500
X-MC-Unique: 4q5iSFI-NdGkzXVGNLEzDw-1
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a7bc20a000000b0034c3d77f277so2580011wmi.3
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 23:01:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZInfsJu7ErgNvQcctk0yVymFu8hQlMDYYqOyuF8tNVM=;
        b=0DUGzj+6AgGHJw2Z5OJvLZfBcgyv8OLLYUTZfd5dLPWJG7VQdt6TUUwumJKLkWkH1z
         NGCPz91q/7Sxbm5rQLWpYa/GscoQyMPFeaKQ5yuI2e1GJWshxGuWCnvS+ctgw2lkCgpK
         zPJnpBunYupe7igK8wsN5UCrXxVd9CVWaLg1NshjUYxPyo8QGT99BrqRR/WkFKjoG7kY
         MkxaGUZmz2D9w24lA6jWjvZKIbsUz50DedefCiPVxbUiXg5asN4Rgv5uYF5sldPKgeDY
         c7yPqLoypfPlNzt+TWeeIGpew4A7sBBt3wfs9o9GVu9CvzijKMEMC2uUCfbmHYCGEdEg
         RJIA==
X-Gm-Message-State: AOAM530K9UHJdxsvENYV0g7qaORonKPkVUAoerPY27wpfM9cNsHR2pS0
        RhNzypq0n2L+7z6/1WVaBl8kCrlWyKBSCYAG//HlpGEbt8Z7M5Ibfa0Q7KAB/FVsBzcQLluFk6b
        CfpmGCRIuMOSu
X-Received: by 2002:a05:6000:2c2:: with SMTP id o2mr9989373wry.660.1642402902407;
        Sun, 16 Jan 2022 23:01:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7sVxoy5PbUdoRvkQMmy3TI09E04uzw+Rzmzzc7mhJn+tLE06QBaym/a4ilbrhWaYgX0C1Rw==
X-Received: by 2002:a05:6000:2c2:: with SMTP id o2mr9989359wry.660.1642402902220;
        Sun, 16 Jan 2022 23:01:42 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id v8sm12897381wrt.116.2022.01.16.23.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 23:01:41 -0800 (PST)
Message-ID: <80006dc9-039c-d729-f84c-af964314442f@redhat.com>
Date:   Mon, 17 Jan 2022 08:01:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: css: Skip if we're not run by
 qemu
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114100245.8643-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 11.02, Janosch Frank wrote:
> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/css.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 881206ba..c24119b4 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -15,6 +15,7 @@
>   #include <interrupt.h>
>   #include <asm/arch_def.h>
>   #include <alloc_page.h>
> +#include <vm.h>
>   
>   #include <malloc_io.h>
>   #include <css.h>
> @@ -350,6 +351,12 @@ int main(int argc, char *argv[])
>   {
>   	int i;
>   
> +	/* There's no guarantee where our devices are without qemu */
> +	if (!vm_is_kvm() && !vm_is_tcg()) {
> +		report_skip("Not running under QEMU");
> +		goto done;
> +	}

You've added the check before the report_prefix_push() ...

>   	report_prefix_push("Channel Subsystem");
>   	enable_io_isc(0x80 >> IO_SCH_ISC);
>   	for (i = 0; tests[i].name; i++) {
> @@ -357,7 +364,8 @@ int main(int argc, char *argv[])
>   		tests[i].func();
>   		report_prefix_pop();
>   	}
> -	report_prefix_pop();
>   
> +done:
> +	report_prefix_pop();

... but in case of the goto you now do the pop without the push. I think you 
have to drop the second hunk.

  Thomas


>   	return report_summary();
>   }

