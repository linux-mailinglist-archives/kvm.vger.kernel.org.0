Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC11EA770
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 17:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgFAP71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 11:59:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726124AbgFAP71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 11:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591027166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PY24dt2bmg7ywUdAP7lYu79bfrIgHdFha4W8dhSH/gU=;
        b=A2nTweALENqpKhudhI0UL8Jzvc4QKWTRYST6WrWBVCIFQpqgbDFVlDyWJaUngdRsZB7qrb
        nV5H30ZQQuf+furyg5qyQWK8ubRqFh99WUgi5Ri38kftbvnKUYRWJUUdeIHg0+NnJy+qks
        5eolmk6B9lskqBPHfIioAGHikqocQiQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-gsvecOK-MOmkg-tibU5lVw-1; Mon, 01 Jun 2020 11:59:24 -0400
X-MC-Unique: gsvecOK-MOmkg-tibU5lVw-1
Received: by mail-wr1-f69.google.com with SMTP id m14so163902wrj.12
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 08:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PY24dt2bmg7ywUdAP7lYu79bfrIgHdFha4W8dhSH/gU=;
        b=cFkRL5ghd0e1Qz1EfRFr45SJpkLoGkUteQAM137HU8r7wpuVLfAmwOn75kHU1Hq314
         E5jfBnBasjX5WUM0pBvu7+naVUvbepEaNQyWR/glgm++6za6kF2gWOeoYkrn1ADlQ6vu
         RBJkZBV2mzeelY8C5dnMeE+dEwJLZ42v6iBw/4ll21Dkhb4XfKuUdtDZ713bkmjH4BdT
         I0EsN4TCgThvrRvQskqFIwofotCb5D4sug4x6KU3GwmwK20e/OLOedxG9eTO/eIL/l66
         +41nXkif8uLZlmxGfvQrZr87zg/1juYT/47sZtJ6D+sGOe5ux0LKU5KN8vt2Zw/ZzcVz
         6FqA==
X-Gm-Message-State: AOAM532UZy2sUsSCQaiZPzTn0bHR3Pll5TZqSqLlSm5dypAnacrLHiKE
        1e9F1zmn23iGPUDdUktOczvSBWKEZZZulCgRqMZfHPJknpRQWHtSNsdl8ftkriNJJ86JxkgS+t5
        PrPOMDMsFv1eW
X-Received: by 2002:a7b:cb47:: with SMTP id v7mr68410wmj.34.1591027163503;
        Mon, 01 Jun 2020 08:59:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjILQES+F8X4Y9MVfqEONtezbQrBNEN0H1k4k8QVV03jttiz3P+mx9ontSfWUumKvP2umvag==
X-Received: by 2002:a7b:cb47:: with SMTP id v7mr68383wmj.34.1591027163257;
        Mon, 01 Jun 2020 08:59:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c3:280a:2d69:cc83? ([2001:b07:6468:f312:1c3:280a:2d69:cc83])
        by smtp.gmail.com with ESMTPSA id n204sm40799wma.5.2020.06.01.08.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 08:59:22 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: fix rdtsc() for vmx_tsc_adjust_test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20200601154726.261868-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5c07c703-7828-e86f-584a-92a443639e41@redhat.com>
Date:   Mon, 1 Jun 2020 17:59:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601154726.261868-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/20 17:47, Vitaly Kuznetsov wrote:
> vmx_tsc_adjust_test fails with:
> 
> IA32_TSC_ADJUST is -4294969448 (-1 * TSC_ADJUST_VALUE + -2152).
> IA32_TSC_ADJUST is -4294969448 (-1 * TSC_ADJUST_VALUE + -2152).
> IA32_TSC_ADJUST is 281470681738540 (65534 * TSC_ADJUST_VALUE + 4294962476).
> ==== Test Assertion Failure ====
>   x86_64/vmx_tsc_adjust_test.c:153: false
>   pid=19738 tid=19738 - Interrupted system call
>      1	0x0000000000401192: main at vmx_tsc_adjust_test.c:153
>      2	0x00007fe1ef8583d4: ?? ??:0
>      3	0x0000000000401201: _start at ??:?
>   Failed guest assert: (adjust <= max)
> 
> The problem is that is 'tsc_val' should be u64, not u32 or the reading
> gets truncated.
> 
> Fixes: 8d7fbf01f9afc ("KVM: selftests: VMX preemption timer migration test")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 7cb19eca6c72..82b7fe16a824 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -79,7 +79,7 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
>  static inline uint64_t rdtsc(void)
>  {
>  	uint32_t eax, edx;
> -	uint32_t tsc_val;
> +	uint64_t tsc_val;
>  	/*
>  	 * The lfence is to wait (on Intel CPUs) until all previous
>  	 * instructions have been executed. If software requires RDTSC to be
> 

Pushed, thanks.

Paolo

