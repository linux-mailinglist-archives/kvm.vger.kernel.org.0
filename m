Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D843EB491
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbhHMLaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:30:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239904AbhHMLaH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628854180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WCGS/OpxgjgfzVLf9aTn9X1TLzV4RkJvMuAGRqfb9s=;
        b=cWNW5jgjnLWoDQqr5ugnrdeukwItxKqwgWbp7nEqZsc53OKjAleAo3dvlUOjNWknXOdkVa
        VLChc9h58F6N++bgDQweeQD4PoyN2kCpTesS1UWuUqahKHzZvLi7dddXOaPCRje5sVgJwu
        R3oPyCilU8/atdQmtecp1DX0klfUHjM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-AvEEmp8AOCyOeblmPkoi-g-1; Fri, 13 Aug 2021 07:29:38 -0400
X-MC-Unique: AvEEmp8AOCyOeblmPkoi-g-1
Received: by mail-ed1-f70.google.com with SMTP id eg56-20020a05640228b8b02903be79801f9aso4679418edb.21
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 04:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WCGS/OpxgjgfzVLf9aTn9X1TLzV4RkJvMuAGRqfb9s=;
        b=kmSlappY+cmys1iIMhmALhqP1ZVkHpgckvkeosdXeCkShj7uFtBD2kiE0sdwi2567E
         JkP1V+0jpI+nQXPUeF1F85Aoe5ANCMDlRTeM6Z7q7v/vRJQb704CFX+dZigYk3YFKOS1
         FkGZlqlTBcgAAvNIg4SMogDRr1ZNO5eXjDWbeREv3yUUfPX0Y1rgMmUeCLSojZSDgUB/
         ycJEeBYCQcy+akeTrv4naQ61J/yZ5Za4dqy/BVksqDRETmSKSzCGBK8hAB6CQv0bARMQ
         VVVUvchS8ostt+5ESY6bWzhLRd+CeykvgpS5apRn6VmtnOdrxAsMp1UKl8UJFptO31MJ
         GkZQ==
X-Gm-Message-State: AOAM532jRDL0bkTlvSPHhryZ/Grc9RROHT1B+Ndvo4QZswSELYKtHYJx
        zR6LlmAB0ByjoGUItpJ02eKtztwzqbAzFbyY5c9pDZKUSt14KzDPMdwwhOXeFgUUgGMtey2u+iD
        Glj4VSXgdEhCDzfnltOkII7E/FwrjblrPhpJeUPB03fNInmeXEAr2cnkaQNQyhdB1
X-Received: by 2002:a17:906:4c8c:: with SMTP id q12mr1972496eju.254.1628854177147;
        Fri, 13 Aug 2021 04:29:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH8htYKmiDsXAd7BFSmDqCBD0EnftVcQJfDvMchpEvjLcpj1AZ9zL2cKh6oy7HSg9o7H4cOw==
X-Received: by 2002:a17:906:4c8c:: with SMTP id q12mr1972487eju.254.1628854176966;
        Fri, 13 Aug 2021 04:29:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bs13sm504561ejb.98.2021.08.13.04.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 04:29:36 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: Added LA57 support to is_canonical
To:     Lara Lazier <laramglazier@gmail.com>, kvm@vger.kernel.org
References: <20210813111833.42377-1-laramglazier@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <69b1ab87-239e-742f-3839-cb194ac6ec94@redhat.com>
Date:   Fri, 13 Aug 2021 13:29:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813111833.42377-1-laramglazier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 13:18, Lara Lazier wrote:
> In case LA57 is enabled, the function is_canonical would need to
> check if the address is correctly sign-extended from bit 57 (instead of 48)
> to bit 63.
> 
> Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> ---
>   lib/x86/processor.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index a08ea1f..3b43fc4 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -640,7 +640,10 @@ static inline void write_pkru(u32 pkru)
>   
>   static inline bool is_canonical(u64 addr)
>   {
> -	return (s64)(addr << 16) >> 16 == addr;
> +	int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
> +	int shift_amt = 64 - va_width;
> +
> +	return (s64)(addr << shift_amt) >> shift_amt == addr;
>   }
>   
>   static inline void clear_bit(int bit, u8 *addr)
> 

Queued, thanks.

Paolo

