Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D967737156D
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhECMxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:53:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233786AbhECMxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=00y6pk1lqtm3CQ8P5eKfBOeFzeVGfefBmB3Ru5wJeWQ=;
        b=FyC9S1gTcj/piFDf+MXSrbK2RiGOHZsayxhp74AuO3Iz0i9b1FnW5ylBe5mSE1ry2auK5d
        DYb4Mo2MYXNpeTmv6Q3uWCcKI/aCIVjaxW47XaxzWV338FgB6H1HiRNi0hlCmfxgYj9HhB
        TPR2NKdKhRoEABj3of56IN8OFcF/m0k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-57rQzjDGMzqWKRtx5uOU1Q-1; Mon, 03 May 2021 08:52:17 -0400
X-MC-Unique: 57rQzjDGMzqWKRtx5uOU1Q-1
Received: by mail-wr1-f71.google.com with SMTP id 93-20020adf80e60000b0290106fab45006so3861970wrl.20
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 05:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=00y6pk1lqtm3CQ8P5eKfBOeFzeVGfefBmB3Ru5wJeWQ=;
        b=JmiTRW27lHljSs+06JNuoIrDWei0Rw//lk2yZYrS7op6y79YfMcHGe95SgJrmrm4hO
         D4PhIFRF5+FgBVBmOlGC5keiEl+G2rrD1BhBJS9d8zWK+HofyJUM+erDNp1IdF02iPNX
         49A1m/YBkbgE4r0dgeAXwGp6tz9HHbFkyDLLZE2ZiwIw6DctL8CoT4i6gLTVzEeBITbi
         4YNTGO6OPszYci299vumBNtVY8oFl+gGpgHnq5brBxt1MW7v2GUyC+XLCGdYK9rPvYfm
         NUlJYD5OSy+E3UBcvwFEwU6lugtO2R/i9ZwFM6RSljH9/ABfNmW7knPCPRg0XmucTT/c
         QFlg==
X-Gm-Message-State: AOAM533XV5dwhNj+2KBl79JTXct602+F9yjYmt7awBcIQ1w4U8Yh4IaL
        Ecoy6T1pjDXBvl5db9JkGO+QcMxK6mGFOKtM+2QxAqwteNyOF/ExnF2wNKZEpsWKWwtHs25wp0a
        uPHyl47wIXHSf
X-Received: by 2002:a05:6000:12ca:: with SMTP id l10mr25043633wrx.145.1620046336596;
        Mon, 03 May 2021 05:52:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBpUyPshJ4bbxqVI40aIk/ceTeMiB4otIs9gTRTA1WEiCDKVv8vl0cAJ12rix0ePOiKck2lg==
X-Received: by 2002:a05:6000:12ca:: with SMTP id l10mr25043610wrx.145.1620046336368;
        Mon, 03 May 2021 05:52:16 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c649f.dip0.t-ipconnect.de. [91.12.100.159])
        by smtp.gmail.com with ESMTPSA id s1sm9772241wmj.8.2021.05.03.05.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 05:52:16 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix vector stfle checks
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, cohuck@redhat.com
References: <20210503124713.68975-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <973d0083-6831-2822-a16f-7cb924a395b5@redhat.com>
Date:   Mon, 3 May 2021 14:52:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503124713.68975-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.05.21 14:47, Janosch Frank wrote:
> 134 is for bcd
> 135 is for the vector enhancements
> 
> Not the other way around...
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> ---
>   s390x/vector.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/vector.c b/s390x/vector.c
> index d1b6a571..b052de55 100644
> --- a/s390x/vector.c
> +++ b/s390x/vector.c
> @@ -53,7 +53,7 @@ static void test_add(void)
>   /* z14 vector extension test */
>   static void test_ext1_nand(void)
>   {
> -	bool has_vext = test_facility(134);
> +	bool has_vext = test_facility(135);
>   	static struct prm {
>   		__uint128_t a,b,c;
>   	} prm __attribute__((aligned(16)));
> @@ -79,7 +79,7 @@ static void test_ext1_nand(void)
>   /* z14 bcd extension test */
>   static void test_bcd_add(void)
>   {
> -	bool has_bcd = test_facility(135);
> +	bool has_bcd = test_facility(134);
>   	static struct prm {
>   		__uint128_t a,b,c;
>   	} prm __attribute__((aligned(16)));
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

thanks!

-- 
Thanks,

David / dhildenb

