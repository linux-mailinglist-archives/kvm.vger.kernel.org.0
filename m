Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4341735E0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgB1LM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 06:12:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726740AbgB1LM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 06:12:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582888377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eztyLr18rUsKgzAlNi2r4kFzwGuvDZCkN9O+G3210Q=;
        b=BwI4Uxa9/T+5AkB7ChbwNP70RIvJm5g4FcwZHfLuZQSjT1NqHW7OrVtP8kcSYwjGz8UT5G
        2oUSc/JofzmMf7JWX2uq/+V4+8Xtz0UckpsbnDWPtwRvhEGzPWamEVoWdRRUHlYXsXPani
        hwGkFY5yCbBSpanz4AhAorJtfRdG/mE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-4Rk6fg4aPHeL4m3zmNOH4A-1; Fri, 28 Feb 2020 06:12:55 -0500
X-MC-Unique: 4Rk6fg4aPHeL4m3zmNOH4A-1
Received: by mail-wm1-f70.google.com with SMTP id 7so440750wmo.7
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 03:12:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6eztyLr18rUsKgzAlNi2r4kFzwGuvDZCkN9O+G3210Q=;
        b=tvPutcPNaV6zpB/W4bGypJnZBqYYdBwB113tAGgLUsQsLaMlRBSGzYVxXMgHG646wU
         MJ/Qlan1S/t9+iqTzDibUPdrjkWZdpomq/veHQZK4ad2DGDFISFDnNkJvUvtUv8orA5t
         NCKz2yhr+zm3pQtJ4qYs5rRYdIxFu6I0e3juETMk6DEw9eTXLvJJuJjhBcHc0dtL4GlL
         h29qpHfi3s7C1+RGpBcWaKCd0S46jFQm7hrPTl8+9r2AQefROrkAytuibk/9B2s5z3q0
         kz1rnpE31OMmuZWtMolvaY7CwvhCZ3i4sJt0IBc7Xdnh26iicFYf5FLfaq0hlikVpInv
         HJVg==
X-Gm-Message-State: APjAAAXxkNe/5fuYt1ZitrSDuJfvCnIpnFqwXDxBlkZfj0xFGXJqFx/n
        e5EmOOJSaqrLVMLwT4FutGNLT1tP0VviSsILYsqeTnl8muEL9SyfjB57oMQkWD7qZ/7Bhia2+Mg
        H9+yMdxV4+0lK
X-Received: by 2002:a5d:4bd0:: with SMTP id l16mr4624928wrt.271.1582888373492;
        Fri, 28 Feb 2020 03:12:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHxXSLg6yOIutH+5xxvSxQZMCyiWdEsnAPUuRrTBMOvwPtJyjoz4HitpptcXPZJqsPZZU8Zg==
X-Received: by 2002:a5d:4bd0:: with SMTP id l16mr4624906wrt.271.1582888373213;
        Fri, 28 Feb 2020 03:12:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id n2sm12547831wro.96.2020.02.28.03.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 03:12:52 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 5/7] svm: convert neg shift to unsigned
 shift
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     oupton@google.com, drjones@redhat.com
References: <20200226074427.169684-1-morbo@google.com>
 <20200226094433.210968-1-morbo@google.com>
 <20200226094433.210968-10-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2429756-ccc5-6e01-fd12-34ecb5b8c05a@redhat.com>
Date:   Fri, 28 Feb 2020 12:12:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226094433.210968-10-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 10:44, Bill Wendling wrote:
> Shifting a negative signed value is undefined. Use a shift of an
> unsigned value instead.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

In practice only UBSAN complains; GCC even documents that it does not
treat it as undefined (which would be insane, especially if the
multiplication by 2 does not overflow as in this case):

     GCC does not use the latitude given in C99 only to treat certain
     aspects of signed '<<' as undefined, but this is subject to change.

But in the interest of purity we should instead compile with -fwrapv.

Paolo

> ---
>  x86/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index ae85194..17be4b0 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -1148,7 +1148,7 @@ static bool npt_rw_l1mmio_check(struct test *test)
>  }
>  
>  #define TSC_ADJUST_VALUE    (1ll << 32)
> -#define TSC_OFFSET_VALUE    (-1ll << 48)
> +#define TSC_OFFSET_VALUE    (~0ull << 48)
>  static bool ok;
>  
>  static void tsc_adjust_prepare(struct test *test)
> 

