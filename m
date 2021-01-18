Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550B12FA740
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393287AbhARRQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:16:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405658AbhARRQN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:16:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610990085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgqhkHksJdOBG2s3Yb/szIvKem7F9Jl4dLhQIn4mA+0=;
        b=Jb8L9uJIuWMh5jFrgU7SQcH9nIixK9lx/+ek0LDvYH3uO+x5lIdwezzpe8UZ9IJ0Iux3uC
        fnIflOBZ5JOd1KcdoB5XzxZB0OuC8eQHtPJeSJS1JWdwmyDMaDrCsRL7ZJIYFdmdNmoRfN
        QqnIKNotisMuHVl1vbvo8TbdDJEwX1A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-HjnLnRsoPSuhhrkwQKCmDA-1; Mon, 18 Jan 2021 12:14:43 -0500
X-MC-Unique: HjnLnRsoPSuhhrkwQKCmDA-1
Received: by mail-ed1-f69.google.com with SMTP id dh21so8093983edb.6
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:14:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xgqhkHksJdOBG2s3Yb/szIvKem7F9Jl4dLhQIn4mA+0=;
        b=POhmBW/MJrb0wLluwkqEAy2sn+pGZQPWAdNlT/i6S59FX5EZfcD9RBhttdVjrUOPvq
         uZlINnMKnmkHqgxLBhtsOAxzQhZcZEZ4Mj7lqE1iZV/WFVAoS0/FqcC1FTQwtqjh3591
         1nwtQML+TjGBGTrDrvtG2drD/0QBg6zhl4LZpoFfK/J9Wmbj3B1yMbrNqY4yiGgXc6+g
         UCf63Z+x3r2obyPoCH51oYhs0cUrrXEp6mZblgHUNYnZnAyMtq9hvksRmVjNDK5D4CfW
         iBedm/jK8I/15se1TqNBJNXLy6XchSqbRm9wBaxqqyG4Z0u8vjA94JcGLSOjiD7qyG6b
         z2vA==
X-Gm-Message-State: AOAM530QZdrVNUozg0DLov7EzgiPiM3IhxEvqRIsaUvxlst0jJ/6/xto
        elN+YG7vVD0kxdQJtLvcG7eoUTvnrXdPZNx8yvEXrQEn3Cjc+wyW2GVgzwxfIH7TaOivWSlIPU7
        S2OPlL0U0LLMH
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr427141ejq.517.1610990082420;
        Mon, 18 Jan 2021 09:14:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTXjDD0sMvbvIBc8P9VPVRTezDvykn9Rt36PhQDWbQljGIqfAPVP8SQhkmE7C9B3s6E5Lq/g==
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr427130ejq.517.1610990082209;
        Mon, 18 Jan 2021 09:14:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm11071788edz.95.2021.01.18.09.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:14:41 -0800 (PST)
Subject: Re: [PATCH] Add a reproducer for the AMD nested virtualization errata
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wei Huang <wei.huang2@amd.com>, Bandan Das <bsd@redhat.com>
References: <20210114122159.1147290-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3ddd14b-5595-ab16-d130-2bced3f6536c@redhat.com>
Date:   Mon, 18 Jan 2021 18:14:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114122159.1147290-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/21 13:21, Maxim Levitsky wrote:
> While this test doesn't test every case of this errata, it should
> reproduce it on all systems where the errata is known to exist.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   x86/svm_tests.c   | 68 +++++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg |  2 +-
>   2 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index dc86efd..0c75400 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -2315,6 +2315,73 @@ static void svm_guest_state_test(void)
>   	test_dr();
>   }
>   
> +
> +static bool volatile svm_errata_reproduced = false;
> +static unsigned long volatile physical = 0;
> +
> +
> +/*
> + *
> + * Test the following errata:
> + * If the VMRUN/VMSAVE/VMLOAD are attempted by the nested guest,
> + * the CPU would first check the EAX against host reserved memory
> + * regions (so far only SMM_ADDR/SMM_MASK are known to cause it),
> + * and only then signal #VMexit
> + *
> + * Try to reproduce this by trying vmsave on each possible 4K aligned memory
> + * address in the low 4G where the SMM area has to reside.
> + */
> +
> +static void gp_isr(struct ex_regs *r)
> +{
> +    svm_errata_reproduced = true;
> +    /* skip over the vmsave instruction*/
> +    r->rip += 3;
> +}
> +
> +static void svm_vmrun_errata_test(void)
> +{
> +    unsigned long *last_page = NULL;
> +
> +    handle_exception(GP_VECTOR, gp_isr);
> +
> +    while (!svm_errata_reproduced) {
> +
> +        unsigned long *page = alloc_pages(1);
> +
> +        if (!page) {
> +            report(true, "All guest memory tested, no bug found");;
> +            break;
> +        }
> +
> +        physical = virt_to_phys(page);
> +
> +        asm volatile (
> +            "mov %[_physical], %%rax\n\t"
> +            "vmsave\n\t"
> +
> +            : [_physical] "=m" (physical)
> +            : /* no inputs*/
> +            : "rax" /*clobbers*/
> +        );
> +
> +        if (svm_errata_reproduced) {
> +            report(false, "Got #GP exception - svm errata reproduced at 0x%lx",
> +                   physical);
> +            break;
> +        }
> +
> +        *page = (unsigned long)last_page;
> +        last_page = page;
> +    }
> +
> +    while (last_page) {
> +        unsigned long *page = last_page;
> +        last_page = (unsigned long *)*last_page;
> +        free_pages_by_order(page, 1);
> +    }
> +}
> +
>   struct svm_test svm_tests[] = {
>       { "null", default_supported, default_prepare,
>         default_prepare_gif_clear, null_test,
> @@ -2427,5 +2494,6 @@ struct svm_test svm_tests[] = {
>         init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
>       TEST(svm_cr4_osxsave_test),
>       TEST(svm_guest_state_test),
> +    TEST(svm_vmrun_errata_test),
>       { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>   };
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index b48c98b..f4ea370 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -213,7 +213,7 @@ arch = x86_64
>   [svm]
>   file = svm.flat
>   smp = 2
> -extra_params = -cpu host,+svm
> +extra_params = -cpu host,+svm -m 4g
>   arch = x86_64
>   
>   [taskswitch]
> 

Queued, thanks.

Paolo

