Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4C2F9C99
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbhARJ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 04:58:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388422AbhARJtG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610963247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3fuvZp+lrDwiaB7C6iDX8zQyy7iI1p6lhJanq5+GG8=;
        b=ANp00R6aCxuF8cTfuZbGqEnYgYcLze/DVu+vMAU0vc6XTBSAuBj2ApUxihKrzUQV0614Jc
        Effy28Z7hY14h93rwd2HlRkMwoOt/zU0p6NJchhebDlKNllUY2KICAMPNO5k2y4C49AOJg
        +3BvlCwcvsxkqw3/pee1lkTpndMHLGY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-XA0pfvU0POmMP6ofRrtBwQ-1; Mon, 18 Jan 2021 04:47:25 -0500
X-MC-Unique: XA0pfvU0POmMP6ofRrtBwQ-1
Received: by mail-wr1-f70.google.com with SMTP id z8so8048344wrh.5
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:47:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h3fuvZp+lrDwiaB7C6iDX8zQyy7iI1p6lhJanq5+GG8=;
        b=lihC72NsHbGtUr5GP/xRY/B9cJ1XqopqbipKgoSialAFxTSvfa5G7e4xqxpXA4tJgN
         oVm75rDw2XuNDRG9Rcembhcj5x8Qitso6yBVXwJT7q36gUozn+LEeYdA7xkFAajyoSww
         KR8cUNuXwITHHBUdywq7BLwRM8Cj5ihPoKJjNsWnBKdkG32ERkYg5r08JjdQ0++EkYYO
         +hFns1kbkdmJlWekSRie2CEuoTiQEMZCfll77SKB8x/ljvn0UDgBZFZSFHnhBdwZsPPB
         jTMY9EqMZUZGnhjOF47A+gtRTix5sWR1HY1PgmJkklOuc+NEsaeh01jakiaHWwPhdCxO
         9EKA==
X-Gm-Message-State: AOAM533JTThI4BWn0gbhH/qTTrJ5XJIWtxWuPUxBQ0fobMprBOvp0q60
        UWTFJe9CkLJZHhnhsXqFcpfHYNzs+6hJvzlwV8sANzfhr7JRGcS4HiG3rwbvmyCGNsZpK6/z48N
        lAl5INQwjrkvV
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4844307wmh.64.1610963244290;
        Mon, 18 Jan 2021 01:47:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8COcCkXe8PQWeE8FIzffZ9MNBL4S35PWLxiBL8vLCQnUOMhWx4vouHjd3jlolTgo5leIwvQ==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4844288wmh.64.1610963244180;
        Mon, 18 Jan 2021 01:47:24 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id g5sm29664539wro.60.2021.01.18.01.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:47:23 -0800 (PST)
Subject: Re: [PATCH v2 6/9] tests: Rename PAGE_SIZE definitions
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-7-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <abafe09d-369c-0f97-db89-b4a163843ad4@redhat.com>
Date:   Mon, 18 Jan 2021 10:47:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-7-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 7:38 AM, Jiaxun Yang wrote:
> As per POSIX specification of limits.h [1], OS libc may define
> PAGE_SIZE in limits.h.
> 
> Self defined PAGE_SIZE is frequently used in tests, to prevent
> collosion of definition, we give PAGE_SIZE definitons reasonable
> prefixs.
> 
> [1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  tests/migration/stress.c            | 10 ++---
>  tests/qtest/libqos/malloc-pc.c      |  4 +-
>  tests/qtest/libqos/malloc-spapr.c   |  4 +-
>  tests/qtest/m25p80-test.c           | 54 +++++++++++-----------
>  tests/tcg/multiarch/system/memory.c |  6 +--
>  tests/test-xbzrle.c                 | 70 ++++++++++++++---------------
>  6 files changed, 74 insertions(+), 74 deletions(-)
...

> diff --git a/tests/tcg/multiarch/system/memory.c b/tests/tcg/multiarch/system/memory.c
> index d124502d73..eb0ec6f8eb 100644
> --- a/tests/tcg/multiarch/system/memory.c
> +++ b/tests/tcg/multiarch/system/memory.c
> @@ -20,12 +20,12 @@
>  # error "Target does not specify CHECK_UNALIGNED"
>  #endif
>  
> -#define PAGE_SIZE 4096             /* nominal 4k "pages" */
> -#define TEST_SIZE (PAGE_SIZE * 4)  /* 4 pages */
> +#define MEM_PAGE_SIZE 4096             /* nominal 4k "pages" */
> +#define TEST_SIZE (MEM_PAGE_SIZE * 4)  /* 4 pages */

Clearer renaming TEST_PAGE_SIZE and TEST_MEM_SIZE.

If possible using TEST_PAGE_SIZE / TEST_MEM_SIZE:
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

>  
>  #define ARRAY_SIZE(x) ((sizeof(x) / sizeof((x)[0])))
>  
> -__attribute__((aligned(PAGE_SIZE)))
> +__attribute__((aligned(MEM_PAGE_SIZE)))
>  static uint8_t test_data[TEST_SIZE];

