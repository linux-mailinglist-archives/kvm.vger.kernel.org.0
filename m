Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84E32F9C95
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbhARJuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 04:50:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389219AbhARJqJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610963084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CAONhQbmSqOCe8hn+4JsxsZxXyg8mQaj+oFgmJ4RXBE=;
        b=GS7ALV2Ozo8ZWr0DkrlJ6o9fyHqEF35LeisIFGqtNpmEwTspMsDBzLkCUeSs+VxqnqEzEi
        gqIaXN9nJt37/bW8xejvcU6YsI5aLEuL65txEDY5mRzmJmHU8tmxO3FCGYX3+0NO9P81XF
        cS/f2OHfT7iQvwR6Tc41vR66wnM1M4Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-LfdbVe5UP8eTJxAupq-gTw-1; Mon, 18 Jan 2021 04:44:42 -0500
X-MC-Unique: LfdbVe5UP8eTJxAupq-gTw-1
Received: by mail-wm1-f72.google.com with SMTP id z12so4225993wmf.9
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:44:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CAONhQbmSqOCe8hn+4JsxsZxXyg8mQaj+oFgmJ4RXBE=;
        b=Mw/4RI10syiNQFH2HsqkEz1AWxnciFcFD4gzjaQGYhMsiUkKNLliK1GridLVWNAHDp
         HKmAmObdgOwx+qWffQ5nP4Dw7wGMRA0rXq3fkBFytJI1/o1WIDiZbCIxIPT1X0qMN5Z4
         CG7WgCwatRXbRwfX1Eh20IanNWVcayDIqmHJ1qoTwR0mZusig0XDOQgNxY0fseT6/1Y5
         89xyvaSTVpajlQDjK4EcpgNklkG8SxfYofDBx8N515GwEtC3RuuTeBvky3AmSezkXq1O
         ZzdeT8eO0REcKZ+VtSwVHX054DhShWXa+uYBbkredHrLI1G8R5X8Q2yJwOSulNbMOcei
         bVxw==
X-Gm-Message-State: AOAM531e4jdO1GeOCA55CoH2GGM+sw7X4habLXhE2DZeZFYh/1e6W2T/
        N/47laRhJs2M/hrZVIWeY6kp/I7cZQchpFTc1yQScw5iS5xD1WZLfhbA8YQ+HEU/BaxaOJjm262
        xRkOyyPmDOQ3A
X-Received: by 2002:a05:600c:3548:: with SMTP id i8mr8770117wmq.104.1610963081184;
        Mon, 18 Jan 2021 01:44:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7qSMLoq4mU9xFHzzMGoFXyEQqEz2C7ZbPkHAG5obBC4EeRcnldzTEyMRJoN3CmG9ZQpq8Sw==
X-Received: by 2002:a05:600c:3548:: with SMTP id i8mr8770104wmq.104.1610963081058;
        Mon, 18 Jan 2021 01:44:41 -0800 (PST)
Received: from [192.168.1.36] (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id j13sm24136418wmi.36.2021.01.18.01.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:44:40 -0800 (PST)
Subject: Re: [PATCH v2 5/9] elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
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
 <20210118063808.12471-6-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <7c6c2afa-d432-da7d-5c6f-d26bcfce4087@redhat.com>
Date:   Mon, 18 Jan 2021 10:44:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-6-jiaxun.yang@flygoat.com>
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
> To prevent collosion of definition, we rename PAGE_SIZE here.
> 
> [1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  contrib/elf2dmp/addrspace.h |  6 +++---
>  contrib/elf2dmp/addrspace.c |  4 ++--
>  contrib/elf2dmp/main.c      | 18 +++++++++---------
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/contrib/elf2dmp/addrspace.h b/contrib/elf2dmp/addrspace.h
> index d87f6a18c6..00b44c1218 100644
> --- a/contrib/elf2dmp/addrspace.h
> +++ b/contrib/elf2dmp/addrspace.h
> @@ -10,9 +10,9 @@
>  
>  #include "qemu_elf.h"
>  
> -#define PAGE_BITS 12
> -#define PAGE_SIZE (1ULL << PAGE_BITS)
> -#define PFN_MASK (~(PAGE_SIZE - 1))
> +#define ELF2DMP_PAGE_BITS 12
> +#define ELF2DMP_PAGE_SIZE (1ULL << ELF2DMP_PAGE_BITS)
> +#define ELF2DMP_PFN_MASK (~(ELF2DMP_PAGE_SIZE - 1))

Here you renamed all definitions, better.

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

