Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0025E4981DD
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiAXORb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:17:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbiAXORa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643033849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sb56qyYsNZGbbFAZwLjwwcp+5s8NFhQzWjzjIg5vjA4=;
        b=OzjzsuwELT+dyeLcKYMiCPZVj0gbZNFwTBpd2kJE6JABDXPi+Clh3JvLzwF6axVvKsVvzc
        UVC38q3h2fKdXXx34AmQVR0Pf2wQPqBOYI2OUpfDyyLqxkfS2iZ3SZKfeKw58+fuzKsBWa
        WGk64hHOZTNqpDvj2juQwZyeYBp6a1M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-d_KFbp5ENLCly9rAGie2Eg-1; Mon, 24 Jan 2022 09:17:28 -0500
X-MC-Unique: d_KFbp5ENLCly9rAGie2Eg-1
Received: by mail-ed1-f72.google.com with SMTP id p17-20020aa7c891000000b004052d1936a5so8840791eds.7
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 06:17:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sb56qyYsNZGbbFAZwLjwwcp+5s8NFhQzWjzjIg5vjA4=;
        b=n/aFiTZRA8bnWRatkLqHqjV7IIJ/pcgjB9MhaoLRrcasykgFuBLT7NRbZfpiwKIGq/
         wqab+nPYKc15NDF2uet+Ddpm8MPVvUPhxvU9x8qkNreFwxfz2nKXgzZOdnQMVjl7QuJN
         StG0Ezgr92pV/Bzp5TrnXpcSBbnpw7LTNFNU9UEV4JeBdiqEIapABpKYASk0epZzmEh+
         ts6IdBZ+XN7g8ewQdGokkXU/7WeKGMGA4elOhx02PA8bXXNFhZe0NqtGpx9CIsPsiznO
         GtEtZMN6WgqxPlNyKcWs+szBK0cz+H9pROJWC+Vi86NLt+uVmxD5QiyXk4j8uhutAEal
         8Qjg==
X-Gm-Message-State: AOAM532pr72ML+8nICDohrNWiWFnr7si0uHQyBf7dYtpJQIQHpzHV19s
        6A7GISaydQQaz1xDamdTcZJMdwscrPUIp2U/JsLm3NHKTVpzWY5ll+cIdXNvIxsd/JKx7fjvRny
        ZPkQIBNpCqWb2
X-Received: by 2002:a17:906:148d:: with SMTP id x13mr1793469ejc.225.1643033847548;
        Mon, 24 Jan 2022 06:17:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuD02SM6AWTMGOGzB2kA7CFVpr0F2NdpLdqDJNjMFjxX9mCD5tWgG9yMv0RJr36+rXVE07bw==
X-Received: by 2002:a17:906:148d:: with SMTP id x13mr1793452ejc.225.1643033847338;
        Mon, 24 Jan 2022 06:17:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c5sm6688223edk.43.2022.01.24.06.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 06:17:26 -0800 (PST)
Message-ID: <d313a422-17f0-9141-8c24-1447c4f43e9b@redhat.com>
Date:   Mon, 24 Jan 2022 15:17:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH] x86: Align incw instruction to avoid split
 lock
Content-Language: en-US
To:     Junming Liu <junming.liu@intel.com>, seanjc@google.com,
        kvm@vger.kernel.org
References: <20220124111444.12548-1-junming.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124111444.12548-1-junming.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 12:14, Junming Liu wrote:
> A split lock is any atomic operation whose operand crosses two cache
> lines. Since the operand spans two cache lines and the operation must
> be atomic, the system locks the bus while the CPU accesses the two cache
> lines. The bus lock operation is heavy weight and can cause
> severe performance degradation.
> 
> Here's the log when run x86 test cases:
> [ 3572.765921] x86/split lock detection: #AC: qemu-system-x86/24383
> took a split_lock trap at address: 0x400306
> 
> Root caused 'cpu_online_count' spans two cache lines,
> "lock incw cpu_online_count" instruction causes split lock.
> 'cpu_online_count' is the type of word(two bytes) and
> therefore it needs to be aligned to 2 bytes to avoid split lock.
> 
> Signed-off-by: Junming Liu <junming.liu@intel.com>
> ---
>   x86/cstart.S   | 1 +
>   x86/cstart64.S | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 2c0eec7..6db6a38 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -143,6 +143,7 @@ ap_init:
>   online_cpus:
>   	.fill (max_cpus + 7) / 8, 1, 0
>   
> +.align 2
>   cpu_online_count:	.word 1
>   
>   .code16
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index ff79ae7..7272452 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -256,4 +256,5 @@ ap_init:
>   	jne 1b
>   	ret
>   
> +.align 2
>   cpu_online_count:	.word 1

Queued, thanks.

Paolo

