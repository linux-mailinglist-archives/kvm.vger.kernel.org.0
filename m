Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9452C20F0
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 10:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgKXJM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 04:12:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728826AbgKXJM1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 04:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606209145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqaiCZDGtWlJBxJisOIJsVMv/Jkz4xVk/HMQaS8GFQc=;
        b=g25po3sYVO4btfYelJPCaD97/wtpP1187XpvUW13RpvtNEyo+3kAVxKOsQ1jOomChf0+FT
        efxNXnPcZ/iu8RCaM7UkrPygq9wkWXZio7AbpM/5iHjh2yQjXMDPGXyyD0+Tgrt9v/7rAw
        vw92W6hh//Lgft/DQo0n0m5q+rMF0zI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-yo4eqad-PcaScB4-qrsBRw-1; Tue, 24 Nov 2020 04:12:22 -0500
X-MC-Unique: yo4eqad-PcaScB4-qrsBRw-1
Received: by mail-wr1-f70.google.com with SMTP id n13so1928419wrs.10
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 01:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xqaiCZDGtWlJBxJisOIJsVMv/Jkz4xVk/HMQaS8GFQc=;
        b=YuYDUhmZxGl1LkhV7QGXSbo/v42jeZOyPQEZVsw1RPgvJl9eOa6OzfhdSCK/FYnZDK
         slqyJnnkKGVVB3Y/pj0v8mhhVDbX9VdLiTzb2tSXiEanfcgZnCNayqEpdntoodLwsKZq
         V5I3S8As4zCxbiI2EM3ucm6/lQq7iF8jErLYTD1OAn/4uVv6JPYUqXceAOIsmSH8W8PW
         ZqRXZLGqB/YKuEto5OMdI66OgGx6iRUQnQkPv71KmsPxO3cjwZaua887lI30G9AiYAQi
         +Zrk3MCq/Nga9RRPnhueI8tOM/bfisyL3iN2ltiFOyHm21DxijNfFH6/1ZlL9rR4+Xi8
         VjYQ==
X-Gm-Message-State: AOAM5304u4e8rKiI88JZ/VTA9lVEi9243Q/TchtD5HEUHJ9Z0WXQxwMg
        uDIHtWz+zbEx3mjX5tkOPmi/sUHaCxyK79C7N7HIROlizuN3yD+OEk0lvJ5d/YwwMWdSh48/lxF
        Je3jQ5qncODS+
X-Received: by 2002:a5d:654b:: with SMTP id z11mr3941071wrv.291.1606209140748;
        Tue, 24 Nov 2020 01:12:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwev9tMvVZ6+bs0vxEZD9bywtFrWO5UNLrCC803m+IufWsliHlD991Gn5a/8h4BKIOSfX5saQ==
X-Received: by 2002:a5d:654b:: with SMTP id z11mr3941051wrv.291.1606209140510;
        Tue, 24 Nov 2020 01:12:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z17sm4050245wmf.15.2020.11.24.01.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 01:12:19 -0800 (PST)
Subject: Re: [kvm-unit-tests][RFC PATCH] x86: Add a new test case for ret/iret
 with a nullified segment
To:     Bin Meng <bmeng.cn@gmail.com>, kvm@vger.kernel.org
Cc:     Bin Meng <bin.meng@windriver.com>
References: <1606206780-80123-1-git-send-email-bmeng.cn@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be7005bb-94f8-4a3f-8e51-de1e21499683@redhat.com>
Date:   Tue, 24 Nov 2020 10:12:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1606206780-80123-1-git-send-email-bmeng.cn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/20 09:33, Bin Meng wrote:
> From: Bin Meng <bin.meng@windriver.com>
> 
> This makes up the test case for the following QEMU patch:
> http://patchwork.ozlabs.org/project/qemu-devel/patch/1605261378-77971-1-git-send-email-bmeng.cn@gmail.com/
> 
> Note the test case only fails on an unpatched QEMU with "accel=tcg".
> 
> Signed-off-by: Bin Meng <bin.meng@windriver.com>
> ---
> Sending this as RFC since I am new to kvm-unit-tests
> 
>   x86/emulator.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index e46d97e..6100b6d 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -6,10 +6,14 @@
>   #include "processor.h"
>   #include "vmalloc.h"
>   #include "alloc_page.h"
> +#include "usermode.h"
>   
>   #define memset __builtin_memset
>   #define TESTDEV_IO_PORT 0xe0
>   
> +#define MAGIC_NUM 0xdeadbeefdeadbeefUL
> +#define GS_BASE 0x400000
> +
>   static int exceptions;
>   
>   /* Forced emulation prefix, used to invoke the emulator unconditionally.  */
> @@ -925,6 +929,39 @@ static void test_sreg(volatile uint16_t *mem)
>       write_ss(ss);
>   }
>   
> +static uint64_t usr_gs_mov(void)
> +{
> +    static uint64_t dummy = MAGIC_NUM;
> +    uint64_t dummy_ptr = (uint64_t)&dummy;
> +    uint64_t ret;
> +
> +    dummy_ptr -= GS_BASE;
> +    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
> +
> +    return ret;
> +}
> +
> +static void test_iret(void)
> +{
> +    uint64_t val;
> +    bool raised_vector;
> +
> +    /* Update GS base to 4MiB */
> +    wrmsr(MSR_GS_BASE, GS_BASE);
> +
> +    /*
> +     * Per the SDM, jumping to user mode via `iret`, which is returning to
> +     * outer privilege level, for segment registers (ES, FS, GS, and DS)
> +     * if the check fails, the segment selector becomes null.
> +     *
> +     * In our test case, GS becomes null.
> +     */
> +    val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
> +                      0, 0, 0, 0, &raised_vector);
> +
> +    report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
> +}
> +
>   /* Broken emulation causes triple fault, which skips the other tests. */
>   #if 0
>   static void test_lldt(volatile uint16_t *mem)
> @@ -1074,6 +1111,7 @@ int main(void)
>   	test_shld_shrd(mem);
>   	//test_lgdt_lidt(mem);
>   	test_sreg(mem);
> +	test_iret();
>   	//test_lldt(mem);
>   	test_ltr(mem);
>   	test_cmov(mem);
> 

Thanks, the patch is good.

Paolo

