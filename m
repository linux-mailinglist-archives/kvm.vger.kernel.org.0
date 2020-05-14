Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984181D28E6
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgENHhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:37:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbgENHhv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 03:37:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589441870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27iA5uONi7AeJrONNE08sbdyu9DE9geMuQqlKBob0m4=;
        b=NP3pPGg2OO3frDrQD0F0f8KWpoi73aeXSsxV/XaXCWkv+itxBExkVzFWswmRe6Jlkpts3/
        frL6G0WnP25bNtQz5iDToI81zlFIhVw9/lGwCFuSZuQeltgv2FG2EbjfTEHBq3m4/olz0X
        +YnRNWjvG+pNEx4aIVIrwhBPHDt01l8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-U8Tlk1GdPQaBZHgznYqZsg-1; Thu, 14 May 2020 03:37:49 -0400
X-MC-Unique: U8Tlk1GdPQaBZHgznYqZsg-1
Received: by mail-wr1-f72.google.com with SMTP id g10so1122993wrr.10
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 00:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=27iA5uONi7AeJrONNE08sbdyu9DE9geMuQqlKBob0m4=;
        b=Qp7OeusJ/baEyI3RRhNokz4GBRruEr7YBMVLSoeo7DQcNuNGhsKsOYfFibNCyR6Y3I
         GRQwsR8vkiznQxr9ALuWyYyDFmkr+zeGkFSYjSZkQDJjgxJudwsZRrI18GogvCn/lv42
         wBkf7Jt6KQCOwa4uO7aKg4bCq+ZCRRyV4q/UOCISFtbG7K5fZC/I4N/AFgAtlFrmUVY/
         k4MLN2x5rRNc3qlRfZlFwmjwn3g/ZTtnvTZDpGzwEKOUdnQRtc1QY/afeMq0rl5bkiK2
         yTZXmIvDYjTKCk1vCzdURHhsxsT85sTRPf0HJHiRTWcb7o9MeXvPZKnLQam5Svuf+bvI
         Akzw==
X-Gm-Message-State: AOAM532RngJyysjtoZNqvqdlIE8ObcgdEU/8M2idtiLUqSYgW2qce/0R
        iNFSN4aFzdEPOhq8UPxDMuZiXyuLzYr725CXZz1Dp1Xjjgc2RLh2F2diTwI0xM7BaH7S2khTuC7
        EdrPcq+sCtkfz
X-Received: by 2002:adf:fa44:: with SMTP id y4mr3899439wrr.135.1589441868045;
        Thu, 14 May 2020 00:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWl6pBz3r2KXCaR08FMVHP88Rbr1wfWs30mkbj8pugBnaiLkX93+Q2jYMOG2K5tzv1Li6xpA==
X-Received: by 2002:adf:fa44:: with SMTP id y4mr3899418wrr.135.1589441867803;
        Thu, 14 May 2020 00:37:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bdd8:ac77:1ff4:62c6? ([2001:b07:6468:f312:bdd8:ac77:1ff4:62c6])
        by smtp.gmail.com with ESMTPSA id a13sm2623883wrv.67.2020.05.14.00.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 00:37:47 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Always compile the kvm-unit-tests with
 -fno-common
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, dgilbert@redhat.com
References: <20200512095546.25602-1-thuth@redhat.com>
 <a87824f4-354a-3fb8-f91d-501e2fc5ece4@redhat.com>
 <d1fa1aae-f648-f734-e7e4-82deb8a60db6@redhat.com>
 <20200514073300.bxrxzowabqqx7thw@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a26231f-7b16-4805-ba06-0805d25b9513@redhat.com>
Date:   Thu, 14 May 2020 09:37:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200514073300.bxrxzowabqqx7thw@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/20 09:33, Andrew Jones wrote:
> diff --git a/lib/auxinfo.h b/lib/auxinfo.h
> index 08b96f8ece4c..a46a1e6f6a62 100644
> --- a/lib/auxinfo.h
> +++ b/lib/auxinfo.h
> @@ -13,7 +13,6 @@ struct auxinfo {
>         unsigned long flags;
>  };
>  
> -/* No extern!  Define a common symbol.  */
> -struct auxinfo auxinfo;
> +extern struct auxinfo auxinfo;
>  #endif
>  #endif
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index ab67ca0a9fda..2ea9c9f5bbcc 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -5,6 +5,7 @@ all: directories test_cases
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-edu.o
>  cflatobjs += lib/alloc.o
> +cflatobjs += lib/auxinfo.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/alloc_page.o
>  cflatobjs += lib/alloc_phys.o
> 
> 
> Thanks,
> drew
> 

Yes, this sounds good.

