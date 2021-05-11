Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23A837AD3B
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhEKRmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhEKRmd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620754886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nl1zPJY8hVLVCv7ebg49anwE3iyxunve5gouX/dXQhM=;
        b=X1h6d3tg/bodM8EyItcUjahrQnrk/WJE1n+2Aj4AtSsI5zOIyeGZRDOKwKrEEQBAD4l0cT
        rfgGF4J42XJ3dUM+p4Vbkby1xeE1I6mysmqPvZdcZxFi8dTFZORXca4EY31gBwQ66p+POg
        540r7dLoVREg+B1bg/jWTf/Vmw6RKi4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-azkuughnODSl8CfSWmazlQ-1; Tue, 11 May 2021 13:41:23 -0400
X-MC-Unique: azkuughnODSl8CfSWmazlQ-1
Received: by mail-ed1-f71.google.com with SMTP id d8-20020a0564020008b0290387d38e3ce0so11350811edu.1
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nl1zPJY8hVLVCv7ebg49anwE3iyxunve5gouX/dXQhM=;
        b=tc6BgF/y1dnHhShMM92rr6Y66sFHSpVfdkMs0eu/vHoHOLX23qCV79EYRS3sVSZYgH
         ZdmOt1K+9PJQU2RQaPkjpdDkKTs9FqPoCqaWz+i9rtg92Jwhhmk7CL2gmuEtRtlSbNSh
         q+BEPvsYZc3uk8hUWkWkv06wL0TULOB+q6kci9UbUy3PD7FwWKTWoAK2nt+vHIoiLtOi
         YVHqsF/XkbOXdH+86FeGPmcOysTxup5g+E/hkujpmZDgIRslnlkQJyfGjh4UXqHdYxqu
         fy2IXIVrHV1cC9YppWqA9ErU6cNIsGfjM8hT4dA91QGQQ1gpPcdz5onU484haidQwt2T
         thHg==
X-Gm-Message-State: AOAM531geFEBCAgKOMBrTJ5KITddYIdOk68RprFvAVRVCdvrYQ8U4iCj
        +jVw0QYUFwceA5K+QOekq2kK36PlVyz76Qpt31uEGUgqAZWCqpGTuvCWwUbvjq/kEs1LVcm9AT3
        SWdlEEd6FSFEx
X-Received: by 2002:a17:906:33d8:: with SMTP id w24mr32367959eja.28.1620754882600;
        Tue, 11 May 2021 10:41:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0LBBwBsEgNINK0RaplwIyoZX/ZACJ5Ix5sGIo4CtkV7Z+pIqTURIBWUmLAz0Z/hgsY1rAKA==
X-Received: by 2002:a17:906:33d8:: with SMTP id w24mr32367945eja.28.1620754882395;
        Tue, 11 May 2021 10:41:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p25sm791740eja.35.2021.05.11.10.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 10:41:21 -0700 (PDT)
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
 <604b1638-452f-e8e3-b674-014d634e2767@redhat.com>
 <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
Message-ID: <b737d530-35e5-33af-0ea9-de6f507516aa@redhat.com>
Date:   Tue, 11 May 2021 19:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 19:03, Alexandru Elisei wrote:
> I think it's because I'm using the*arm-none-eabi*  toolchain for compilation
> instead of arm-linux-gnu, that's the toolchain for cross compiling arm code that
> is present in the official Arch Linux repositories. Is that unsupported? I don't
> remember any mention of it not being supported, but it's entirely possible that I
> just forgot.

No, it's just that there was no difference until now.  If you can add it 
to CI we can make sure it doesn't break.

> With rem initialized to 0 I get this:
> 
> rm-none-eabi-ld -nostdlib -Ttext=40010000 -o arm/selftest.elf -T
> /home/alex/data/repos/kvm-unit-tests/arm/flat.lds \
>      arm/selftest.o arm/cstart.o lib/libcflat.a lib/libfdt/libfdt.a
> lib/arm/libeabi.a arm/selftest.aux.o
> arm-none-eabi-ld: lib/libcflat.a(printf.o): in function `print_int':
> /home/alex/data/repos/kvm-unit-tests/lib/printf.c:72: undefined reference to
> `__aeabi_ldivmod'
> arm-none-eabi-ld: /home/alex/data/repos/kvm-unit-tests/lib/printf.c:73: undefined
> reference to `__aeabi_ldivmod'
> arm-none-eabi-ld: lib/libcflat.a(printf.o): in function `print_unsigned':
> /home/alex/data/repos/kvm-unit-tests/lib/printf.c:102: undefined reference to
> `__aeabi_uldivmod'
> arm-none-eabi-ld: lib/libcflat.a(alloc_page.o): in function `_page_alloc_init_area':
> /home/alex/data/repos/kvm-unit-tests/lib/alloc_page.c:482: undefined reference to
> `__aeabi_uldivmod'
> make: *** [/home/alex/data/repos/kvm-unit-tests/arm/Makefile.common:65:
> arm/selftest.elf] Error 1

So for this we need to include the uldivmod and ldivmod functions 
similar to those in 
https://android.googlesource.com/toolchain/compiler-rt/+/release_32/lib/arm.

The uninitialized warning is because of the division by zero case.  I've 
sent a couple patches to fix everything, please review!

Paolo

