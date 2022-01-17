Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3021490254
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbiAQHEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237272AbiAQHEm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 02:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642403082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bm7nLw8ZrvKQ9DWZRbpqyczV3AlIZvgrU0JQB1GxQ10=;
        b=hdZDJdfzxajpdayvs/OGvpbVwcd5jhvzPCK3/oEE19BpKv9oaN/DtkJyR8ta4MyAEFucCE
        7fl1se8Yvdp9Y4Al+aGne0ZjUN+oAWtY+YI6ghhPdQ02E4AUYL4KN9XFB/L1NuY6a3Lgfp
        5ez1XbUaYNwN+mQctSt0S5xL8/v7fRY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-qUt3A_P6OpKDrEpXuAcyRA-1; Mon, 17 Jan 2022 02:04:40 -0500
X-MC-Unique: qUt3A_P6OpKDrEpXuAcyRA-1
Received: by mail-wm1-f69.google.com with SMTP id n14-20020a7bcbce000000b003488820f0d9so10389719wmi.8
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 23:04:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bm7nLw8ZrvKQ9DWZRbpqyczV3AlIZvgrU0JQB1GxQ10=;
        b=CADXmw5v4ASnpzsRpLGGv58SYJtGqyrtpS8a4IK6ml64vKALMrhrU1g9yClxz/QByu
         CXsUsCu7Kbk4ua4zwG9FAaPXtjHug9E6xbRn9QUSNxehQrO8xD80JvcR6p3J6ZAJFMbC
         7a+96xobw8RqtP4S5xsDkzNTPnjdffvhv8EFXKd5Pi61XTtKOSoEmgyMxc3hJ3gCmYzk
         7ia6Nh3JOPcv2e8Yd1+wbo61PVI31HA404lzmEK1lQKc80PyCSbIGGZ6+hGb4NKI3mto
         DdzUlNQY6XopRVpauvuq6q3k2LwignIW2kSCWv4s4iiIiP3IVXWzRskqd1x63VbbLYs9
         //Og==
X-Gm-Message-State: AOAM532tMLDzimRzBASm0SBGG9tgr+5dEgkDBG0VOISlJPMBnKk5T3Vw
        UO3jaQFfwUegv0rs9UDNi81lG3qwXjCewg9f+msKWeJz4FAiJo7atmxGAgAIZ/mfGdWL5H3VsNw
        Mciv4f5isuMQN
X-Received: by 2002:a5d:5282:: with SMTP id c2mr18923081wrv.580.1642403079486;
        Sun, 16 Jan 2022 23:04:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy702MD8wNWsvrPRm5BZtjdblB6KzKbZ34prL2NciM5sVLUJaMKlOsivrMifphyF8lPeMEa/A==
X-Received: by 2002:a5d:5282:: with SMTP id c2mr18923068wrv.580.1642403079327;
        Sun, 16 Jan 2022 23:04:39 -0800 (PST)
Received: from [192.168.8.100] (tmo-098-68.customers.d1-online.com. [80.187.98.68])
        by smtp.gmail.com with ESMTPSA id x6sm12679289wrt.58.2022.01.16.23.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 23:04:38 -0800 (PST)
Message-ID: <999498b3-6b1d-69ae-c80f-2a10102d95bd@redhat.com>
Date:   Mon, 17 Jan 2022 08:04:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: diag308: Only test subcode 2
 under QEMU
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220114100245.8643-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2022 11.02, Janosch Frank wrote:
> Other hypervisors might implement it and therefore not send a
> specification exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/diag308.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/diag308.c b/s390x/diag308.c
> index c9d6c499..414dbdf4 100644
> --- a/s390x/diag308.c
> +++ b/s390x/diag308.c
> @@ -8,6 +8,7 @@
>   #include <libcflat.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/interrupt.h>
> +#include <vm.h>
>   
>   /* The diagnose calls should be blocked in problem state */
>   static void test_priv(void)
> @@ -75,7 +76,7 @@ static void test_subcode6(void)
>   /* Unsupported subcodes should generate a specification exception */
>   static void test_unsupported_subcode(void)
>   {
> -	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
> +	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
>   	int idx;
>   
>   	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
> @@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
>   		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>   		report_prefix_pop();
>   	}
> +
> +	/*
> +	 * Subcode 2 is not available under QEMU but might be on other
> +	 * hypervisors.
> +	 */
> +	if (vm_is_tcg() || vm_is_kvm()) {
> +		report_prefix_pushf("0x%04x", 2);

Maybe replace the format string with "0002" and drop the "2" parameter?

> +		expect_pgm_int();
> +		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +		report_prefix_pop();
> +	}
>   }
>   
>   static struct {

Reviewed-by: Thomas Huth <thuth@redhat.com>

