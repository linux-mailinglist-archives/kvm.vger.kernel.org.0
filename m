Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AB375472
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhEFNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231265AbhEFNKi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620306579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kpgqQ0cIy127Bc1vNVkXau+Shvx8VY5BV4kLbZ9pBXM=;
        b=beqn+/GQ0eb10POetrhNq65Gn022xtiTssYX4W+ONAPa68p2u2jN3ijuCW1/xyX4qSoTtZ
        OMzF2a1CxTDc7h9jhPdqx3E65qWWBrgd/5oYs8+waF4v8H/ZmiQMLsJQcTqzqA6CpQ0rkw
        pONe25oHVMbTSCjmAO6oP+C+8rsn3VE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-9OA54tz1Pgi6U5I0n722rw-1; Thu, 06 May 2021 09:09:38 -0400
X-MC-Unique: 9OA54tz1Pgi6U5I0n722rw-1
Received: by mail-wm1-f70.google.com with SMTP id h128-20020a1cb7860000b0290148da43c895so987871wmf.4
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kpgqQ0cIy127Bc1vNVkXau+Shvx8VY5BV4kLbZ9pBXM=;
        b=ZMgCfExtb2vOjZSIWwp82pPc0rb/Y9GjXVmWa+USBAdv0PgKT1ZIphjwxgX6hqyhhR
         2o+fb6wEKsbzUHdwgJOao6HR1W1cI61IBm/WpZXCGOrapSnunA7rumMO3ana2VEv6+me
         h8vFnHf0It9sVLTOF4E4nDn1Pr+nVeqlKf6tD+vdEOjRr+89FfsP6/98tQc7wVG5Fwr0
         No8x+hjxj1iX5aaA0nvFnOJWMjrXI33ev7VkKjA9pl9dFydYnxYTBE7M8J2C5bRZCRZp
         Fc9HavFQFTOzeWhltFC94YdQfUF9JmfKAAUbcgrkj/dx6EcYI4ywzjXWmtPECTYeS0ZM
         ZlwQ==
X-Gm-Message-State: AOAM53119vUBXJGbsx1RZn4t8YIdJRvCK9zLZU65xAAIA2QZHD3MKf2H
        1K61shfuaKEwTBVsBWtW9CvGREsf5oSsx6kBHh6zKaU8KMHFQEHednoAQYdn7ttf4LqEaHJwyRW
        q0fW5tdooGLBXIhOIQBDAhX519LkZI+UVCPiQiEPWQG8ZeR1Hr23nGX9UNU1nxw==
X-Received: by 2002:a1c:a5cb:: with SMTP id o194mr3910870wme.91.1620306576623;
        Thu, 06 May 2021 06:09:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp5w8PqMyRSZxJNykUGJoYMgKsTUuWMKnjxrmA/6+xEfnfnshU6AgG2I3BTMsrsSE/eoOWPw==
X-Received: by 2002:a1c:a5cb:: with SMTP id o194mr3910842wme.91.1620306576410;
        Thu, 06 May 2021 06:09:36 -0700 (PDT)
Received: from [192.168.1.19] (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id s5sm3535667wmh.37.2021.05.06.06.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 06:09:35 -0700 (PDT)
Subject: Re: [PATCH 5/5] target/ppc/kvm: Replace alloca() by g_malloc()
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20210505170055.1415360-1-philmd@redhat.com>
 <20210505170055.1415360-6-philmd@redhat.com>
 <20210506104130.5f617359@bahia.lan>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <3405dbc2-caf3-0da6-25aa-fe54f8ac8e11@redhat.com>
Date:   Thu, 6 May 2021 15:09:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506104130.5f617359@bahia.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/21 10:41 AM, Greg Kurz wrote:
> On Wed,  5 May 2021 19:00:55 +0200
> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> 
>> The ALLOCA(3) man-page mentions its "use is discouraged".
>>
>> Replace it by a g_malloc() call.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  target/ppc/kvm.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
>> index 104a308abb5..ae62daddf7d 100644
>> --- a/target/ppc/kvm.c
>> +++ b/target/ppc/kvm.c
>> @@ -2698,11 +2698,11 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
>>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>>                             uint16_t n_valid, uint16_t n_invalid, Error **errp)
>>  {
>> -    struct kvm_get_htab_header *buf;
>> -    size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
>> +    size_t chunksize = sizeof(struct kvm_get_htab_header)
> 
> It is a bit unfortunate to introduce a new dependency on the struct type.
> 
> What about the following ?
> 
> -    struct kvm_get_htab_header *buf;
> +    g_autofree struct kvm_get_htab_header *buf = NULL;
>      size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
>      ssize_t rc;
>  
> -    buf = alloca(chunksize);
> +    buf = g_malloc(chunksize);

OK.

