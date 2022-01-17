Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D8490FF1
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbiAQRwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:52:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233445AbiAQRwQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642441935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/xq6a824NvWlkbfgxqJlSfnHzBPgwMyo8yjUKXz4sg=;
        b=ZhKI8ZL6RYUdfU6teD5UKLfb7pqZrM6bFdnj+MqInrF+ppdjvArVWnu1mS6z0Sj4TTH9bK
        MGXy9LF6AYOajRoW54UwokoaOS1G6BDMtwJs/KUtZmWbRNO+N9WVbqA35JL7FLrF9X4uBk
        bvS9YD6qQeVmtxa2gA9mr4I9KQhyv08=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-Asl5fsPrNUCJj2hTDZePqQ-1; Mon, 17 Jan 2022 12:52:12 -0500
X-MC-Unique: Asl5fsPrNUCJj2hTDZePqQ-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so5082829wmb.7
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X/xq6a824NvWlkbfgxqJlSfnHzBPgwMyo8yjUKXz4sg=;
        b=19DldGFJlRomirwVsqRRauz6WRgxuvVrWgfM9xNlTqGdjYs9PgLhS7aYnhNBCKvvi0
         nt1cC3VX7s2LoVcYN0Xtlcx3aYQcOkigz0ki/GeMg4Fo45xuq98ASDzgJZXK8GIdV28g
         o5phMJbo6RXKemsvhK0TrXLW5HlSyLJfCCnZWsdrmbI/ANFAseWg6f8qa0kvN+UmDrvy
         ejQObnR8vaF3h1DGxSgvYtvERkWpjYIyvnPi/panOHGhG4uXFBF1KHgB9vQO/HsAP3mE
         T4A+7czQerxk+kF6xCHjNlS2XGLOVSKQVt5AGI6GUthOORUq3OrF4VHpg524CQc0gRmW
         /vcA==
X-Gm-Message-State: AOAM530viwc1pMFX5z02tpFRRCejVS3lH17NFejUecDN/ym7JjpQNMa+
        /4IyVoqI365h6d0V1TZobbNuYFVhYH5t8u3yDsCJUjRmPkpT1rgYES8uJRyQ4aJn9WEosW5uxqN
        DBDtyZk4+Ln3a
X-Received: by 2002:a1c:7209:: with SMTP id n9mr10003593wmc.83.1642441931216;
        Mon, 17 Jan 2022 09:52:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKisSU4G5w2S0Henxr1S3D9REmimsfL39nrIQwKsuRAaokQww5Gemo1Mb19ll9iKDhR0DWEw==
X-Received: by 2002:a1c:7209:: with SMTP id n9mr10003577wmc.83.1642441930957;
        Mon, 17 Jan 2022 09:52:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c11sm22371208wmq.48.2022.01.17.09.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:52:10 -0800 (PST)
Message-ID: <5acea70f-5e53-f1df-7355-8fa194b59380@redhat.com>
Date:   Mon, 17 Jan 2022 18:52:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH] ACPI: fix ACPI RSDP located before 0xF0000
 is not found
Content-Language: en-US
To:     "Barzen, Benjamin" <bbarzen@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Benjamin Barzen <b.barzen@barzen.io>
References: <6DFC2BF8-5CAC-410C-9A36-36E92FFC7817@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6DFC2BF8-5CAC-410C-9A36-36E92FFC7817@amazon.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/22 13:53, Barzen, Benjamin wrote:
>  From e107317d029b5298c88701b4bcc93bc64e28384b Mon Sep 17 00:00:00 2001
> From: bbarzen <bbarzen@amazon.com>
> Date: Wed, 29 Dec 2021 12:50:14 +0100
> Subject: [PATCH] ACPI: fix ACPI RSDP located before 0xF0000 is not found
> 
> The function find_acpi_table_addr locates the ACPI RSDP by searching the
> BIOS read only memory space. The official ACPI specification states that
> this space goes from 0xE0000 to 0xFFFFF. The function currently starts
> searching at 0xF0000. Any RSDP located before that address can
> subsequently not be found.
> 
> Change the start address of the search to 0xE0000.
> 
> Singed-off-by: Benjamin Barzen <bbarzen@amazon.de>
> ---
>   lib/x86/acpi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
> index 4373106..bd7f022 100644
> --- a/lib/x86/acpi.c
> +++ b/lib/x86/acpi.c
> @@ -19,7 +19,7 @@ void* find_acpi_table_addr(u32 sig)
>           return (void*)(ulong)fadt->firmware_ctrl;
>       }
> 
> -    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
> +    for(addr = 0xe0000; addr < 0x100000; addr += 16) {
>          rsdp = (void*)addr;
>          if (rsdp->signature == 0x2052545020445352LL)
>             break;

Queued, thanks.

Paolo

