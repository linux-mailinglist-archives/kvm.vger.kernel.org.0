Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831D627E33A
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 10:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgI3IDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 04:03:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgI3IDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 04:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601452995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=H4BYt/vK5k2En+rBp+T6Wcx0j3U2356tq8o6rj5g7sk=;
        b=U9uKzT2G/Oitq1KguT58OOjat4IByhl4L9mChzucQYxuegEsVhHNWU0sIrncjIYl/Mm5uv
        rG6ZcPbqc3yXpg5K2M4pYSH8Mu2+/LN1KQD1aPaOmzvWmm6zd6ChHSJwrxf7E8/uOiCDUj
        RA/3tE1LwwbtxsdI0tRn79RoEr1FLpw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-2cKBAX99P-6OOWSUn--LVg-1; Wed, 30 Sep 2020 04:03:13 -0400
X-MC-Unique: 2cKBAX99P-6OOWSUn--LVg-1
Received: by mail-wr1-f71.google.com with SMTP id a2so303269wrp.8
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 01:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H4BYt/vK5k2En+rBp+T6Wcx0j3U2356tq8o6rj5g7sk=;
        b=r71NBYgg9XQT4Cs2y/ezxH5QimmnCL0xRKddr2wX8OnMrOOVzyrGeQDrhuz55W1HFr
         RocezRJMf53p6VkDbeWuRYAyLkxTiTRJuaEJOmwtZBn8DBR74bxmarJ+Qa6lBLinTXHk
         lt+S2qxVgOHUWCl1iQ7dlTRXfPV+7uub7tmf3plNR/qy4eO4w1f8WXPnV/4nMHb7T6YR
         DXHzzVR1FMAqaaNVKPIS7AO1y37gdNDYiI3kgyOLijsBiTQT//ZLYFnA6YFZAuxKkTca
         CBiOm1o4JGZZYsFySNaR21R7k248SmlANXO1Oyk59oengiKyEwrEdIK+AvJfMhrvnFDg
         3vAQ==
X-Gm-Message-State: AOAM5334lHK1kE+QQrgCV2stgSzHRnAtrrPpPIb5bFHALIlCSK2fUNLD
        yY02n3pX6uJt1JGWq/1Mr5cz5hjmW3zg7luislsmRA3GljxPboix8EzmTi2DchBt/Ol7MUnyGMn
        ze26du33cwHaA
X-Received: by 2002:a1c:7302:: with SMTP id d2mr1636642wmb.133.1601452992066;
        Wed, 30 Sep 2020 01:03:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6FLyJ6AxdGq6XKIYw+0Prdew2OA8CUtL4E3vD8HvEyz00NKtWjkX0IlcXHTOvJQEOqWyQOA==
X-Received: by 2002:a1c:7302:: with SMTP id d2mr1636624wmb.133.1601452991837;
        Wed, 30 Sep 2020 01:03:11 -0700 (PDT)
Received: from [192.168.1.36] (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id k12sm1444147wrn.39.2020.09.30.01.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 01:03:11 -0700 (PDT)
Subject: Re: [PATCH v4 04/12] target/arm: Restrict ARMv4 cpus to TCG accel
To:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-5-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <971287b0-fd62-21bb-e80e-8b83c8a5c459@redhat.com>
Date:   Wed, 30 Sep 2020 10:03:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-5-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/30/20 12:43 AM, Philippe Mathieu-Daudé wrote:
> KVM requires a cpu based on (at least) the ARMv7 architecture.
> 
> Only enable the following ARMv4 CPUs when TCG is available:
> 
>   - StrongARM (SA1100/1110)
>   - OMAP1510 (TI925T)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/arm/Kconfig | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 7d040827af..b546b20654 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,3 +1,7 @@
> +config ARM_V4
> +    bool
> +    select TCG

This should be 'depends on TCG' because we can not
*select* TCG, either we enabled it or not.

The problem is the machines are already selected in
default-configs/arm-softmmu.mak, so we can not build
the current config without TCG.

> +
>  config ARM_VIRT
>      bool
>      imply PCI_DEVICES
> @@ -30,6 +34,7 @@ config ARM_VIRT
>  
>  config CHEETAH
>      bool
> +    select ARM_V4
>      select OMAP
>      select TSC210X
>  
> @@ -244,6 +249,7 @@ config COLLIE
>  
>  config SX1
>      bool
> +    select ARM_V4
>      select OMAP
>  
>  config VERSATILE
> 

