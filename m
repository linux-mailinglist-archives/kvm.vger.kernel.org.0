Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F854373B3F
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhEEMcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 08:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229559AbhEEMci (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 08:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620217902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrUSa+B2KPFx7VOF93FTNLWSclj6DcfgFqJOwWQfjtA=;
        b=FMMH9aitXjjTHqKCQ5FWlMiAL2bgC7Io83wb8B01Gcq2zwtB83d3qCO815X/HBeG5ajkek
        Z+5Dkh48EzH0iy73keB9Y64qkCYAYrdtojtLbnzmm7P5FCNn0obxUxqxCkCrjBv7nx2MKO
        XNJCBc2ny33YXnR3GVUvC6UdlFZl5cg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-kjEGjP75NWa3zEnbriVQGA-1; Wed, 05 May 2021 08:31:40 -0400
X-MC-Unique: kjEGjP75NWa3zEnbriVQGA-1
Received: by mail-wr1-f70.google.com with SMTP id 91-20020adf94640000b029010b019075afso629758wrq.17
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 05:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GrUSa+B2KPFx7VOF93FTNLWSclj6DcfgFqJOwWQfjtA=;
        b=UKXugVHNnLnuF+kH6aG754OLXwrt+bC8X2yIJQapdxUI46P935Ip+gQa5fVqsooSSj
         JYIFIMlScwkxeV0pwr67VbOXepVSbC5fVv4n9EZpDYsxxLkHqLfAGEKhuAIpY5x8LxNN
         AXdi3wcSmN4U9h/vtqCkuo47xttv19iGbGSXMjfC/vrP5sOxOfUj4EU6o9z1YlBlqT3s
         F4W5VXD0vBvQeJoabyYOZ2L0EenTXnuz2cfGtyKSFVrzaUVWV6q6h0oeNw4kI9Cy6hAc
         PL8T2zfm6X12QpdAjdujbmdKshQ7CudDNX0r6isFu+jc1ZNXnOrt8T33xQwG5JfsuM7J
         cwBQ==
X-Gm-Message-State: AOAM5313DGeXmXXzwWtST+qHq5n5l4gCz9b2KrLjyqCIN8I5DSc3WF8x
        jvgcOuu7meooGvfuo6EIz6/PALQfWoRuK0UZN/beorJuiYnA9jRO2HwrTBxK9irfjp79WYGp3Oh
        RsEsyWjqTnwtH
X-Received: by 2002:a5d:5242:: with SMTP id k2mr38400772wrc.269.1620217899326;
        Wed, 05 May 2021 05:31:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyb+4uiulVYZWXaGDHPDtKOdkLy2FZyI/8E/o64BtLS6RHys+Dj8jMpLW+B4BKN0ArrciGgA==
X-Received: by 2002:a5d:5242:: with SMTP id k2mr38400755wrc.269.1620217899094;
        Wed, 05 May 2021 05:31:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i20sm4939656wmq.29.2021.05.05.05.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 05:31:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Makefile: do not use "libgcc" for clang
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20210309045250.3333311-1-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b886420-91bf-0607-a51d-36fb090c8507@redhat.com>
Date:   Wed, 5 May 2021 14:31:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210309045250.3333311-1-morbo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/21 05:52, Bill Wendling wrote:
> The -nostdlib flag disables the driver from adding libclang_rt.*.a
> during linking. Adding a specific library to the command line then
> causes the linker to report unresolved symbols, because the libraries
> that resolve those symbols aren't automatically added. Turns out clang
> doesn't need to specify that library.

This breaks 32-bit build with clang due to __udivdi3/__umoddi3.  Let me 
post an alternative.

Paolo

> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   Makefile            | 6 ++++++
>   arm/Makefile.common | 2 ++
>   x86/Makefile.common | 2 ++
>   3 files changed, 10 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index e0828fe..61a1276 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -22,10 +22,16 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>   cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>   
> +# cc-name
> +# Expands to either gcc or clang
> +cc-name = $(shell $(CC) -v 2>&1 | grep -q "clang version" && echo clang || echo gcc)
> +
>   #make sure env CFLAGS variable is not used
>   CFLAGS =
>   
> +ifneq ($(cc-name),clang)
>   libgcc := $(shell $(CC) --print-libgcc-file-name)
> +endif
>   
>   libcflat := lib/libcflat.a
>   cflatobjs := \
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a123e85..94922aa 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -58,7 +58,9 @@ OBJDIRS += lib/arm
>   libeabi = lib/arm/libeabi.a
>   eabiobjs = lib/arm/eabi_compat.o
>   
> +ifneq ($(cc-name),clang)
>   libgcc := $(shell $(CC) $(machine) --print-libgcc-file-name)
> +endif
>   
>   FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
>   %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 55f7f28..a96b236 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -37,7 +37,9 @@ COMMON_CFLAGS += -O1
>   # stack.o relies on frame pointers.
>   KEEP_FRAME_POINTER := y
>   
> +ifneq ($(cc-name),clang)
>   libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
> +endif
>   
>   # We want to keep intermediate file: %.elf and %.o
>   .PRECIOUS: %.elf %.o
> 

