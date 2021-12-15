Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647D4475682
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbhLOKgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236385AbhLOKgv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 05:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639564610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ptKoSAfT5SsWIhv5lmYV8KPEM4zjV9bjMbcaoWPndEY=;
        b=R7gR8gjGzMN9Cyd5vApRyburHobYgRRfZbDp5dkzsOt4PzXmOeVEjfqsrtfqHkjmVPPDG0
        SWrkp8MkYYIoeQPqOkW/TOwEDkFC/+55KNooXZpB2CDT5q77nWxbV3YeminPQ74q1gtHWe
        xxRhhkUD0xU/fC8EO9IcYfBRTbqR0eQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-SxYKyMdLOeqt-DoriAn8Tg-1; Wed, 15 Dec 2021 05:36:49 -0500
X-MC-Unique: SxYKyMdLOeqt-DoriAn8Tg-1
Received: by mail-wr1-f72.google.com with SMTP id f3-20020a5d50c3000000b00183ce1379feso5776283wrt.5
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 02:36:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ptKoSAfT5SsWIhv5lmYV8KPEM4zjV9bjMbcaoWPndEY=;
        b=fVVYj6e0rBHhK++QZAD7Jm1yMpxDIIa9xKHgKUq/XHuvt9RILN8azizB6wMEoj4q6Q
         GHRjjFkftxmRq85jqQAMW6zOsvbEuWidqt0yfmqKhgFOD6HYZ4FYIKS7xKLOcpaMC9SB
         ZgfdwlUO+aOSd4g+QvFDKc9Qzt3W+vOpRC4VB0cY/IIS7rAcA+0i35hhRef/cMXyaDKc
         WsGevGY7lzAblKWq1/dq/Mb0nTsxVydwepvbD8wh3uO5WMs004E/9YYafwTJ2+EkQFp3
         XH5S82xAmGzrHx7q586y5jHNQBsyX5HZw7o6wndFPjmmR3qh9HGMQGNo9PXB+COAEgYb
         wNXQ==
X-Gm-Message-State: AOAM531EMncLmqfsrjcCE1AzfQd8BhUZf1rSAepH+Vr4m3v3uwnSdZKm
        47wrmZvHq8qb8dGVOe1w2h4h5PNwxs36o/B/awIu8kHHsfjrXuFylqng1io7Vc4ZL2ukVVLA3hQ
        MxaAKK+zvXyXA
X-Received: by 2002:adf:e545:: with SMTP id z5mr3752090wrm.444.1639564608414;
        Wed, 15 Dec 2021 02:36:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBnUf22YjzKJbcPC/wjehGcYrBCnzHHS+4oHxIIgmKjGoySZZ7bBKyLwVNBvgSyN8jPjVkHw==
X-Received: by 2002:adf:e545:: with SMTP id z5mr3752079wrm.444.1639564608279;
        Wed, 15 Dec 2021 02:36:48 -0800 (PST)
Received: from [192.168.1.36] (174.red-83-50-185.dynamicip.rima-tde.net. [83.50.185.174])
        by smtp.gmail.com with ESMTPSA id t8sm1902442wmq.32.2021.12.15.02.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:36:47 -0800 (PST)
Message-ID: <03770439-52cd-ba59-8ae2-643671d3b682@redhat.com>
Date:   Wed, 15 Dec 2021 11:36:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH-for-7.0] target/i386/kvm: Replace use of __u32 type
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-trivial@nongnu.org
References: <20211116193955.2793171-1-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <20211116193955.2793171-1-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Laurent,

This patch is reviewed, can it go via your trivial tree?

On 11/16/21 20:39, Philippe Mathieu-Daudé wrote:
> QEMU coding style mandates to not use Linux kernel internal
> types for scalars types. Replace __u32 by uint32_t.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/i386/kvm/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 5a698bde19a..13f8e30c2a5 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1406,7 +1406,7 @@ static int hyperv_fill_cpuids(CPUState *cs,
>      c->edx = cpu->hyperv_limits[2];
>  
>      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS)) {
> -        __u32 function;
> +        uint32_t function;
>  
>          /* Create zeroed 0x40000006..0x40000009 leaves */
>          for (function = HV_CPUID_IMPLEMENT_LIMITS + 1;
> 

