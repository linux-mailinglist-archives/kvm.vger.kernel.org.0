Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E14341858
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCSJb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229877AbhCSJbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616146263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYHOK4lMWpC+xS3RIkmJjIMrFZxUWa5W6Haf+gFHPEo=;
        b=ZbaBzumcn3ah7geulhQGpLnsre5yREMww26oPKfJeOU/h4ZamwJB9Knk5aOQDjlJ7EpBPH
        WU/2agKMv5TdakjkK/Jbp3oBAeXSMjfmkVyR3uVDdG6ovqhPJrZ8zfjxtpLvYGi/I1mx9C
        yse5KvNJ9JT/im51wgcSQbuZnaHwpm8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-V7eaut-wN0uLq6xBWEKmyQ-1; Fri, 19 Mar 2021 05:31:01 -0400
X-MC-Unique: V7eaut-wN0uLq6xBWEKmyQ-1
Received: by mail-ej1-f71.google.com with SMTP id au15so18088503ejc.8
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 02:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYHOK4lMWpC+xS3RIkmJjIMrFZxUWa5W6Haf+gFHPEo=;
        b=RIA1ewuq+EsNkUwWHldYcGyY7Gn/ZwEI3rGZpwLRPJeoH9SB+IMYpomDC76uUH47BV
         K9vSg9ZTqAMmlvQU/UCAcPnLB8hcpH9rxcDWg99EeKDtK4YOqvHkcv6nrLWj4KZzHFhB
         DbDJB3NUv3htaxpmXn0VHzX4pZHwLA/a5aTuZ+tJiJmS0Lvf4Ex8kkZpQbcwxBMFVHFc
         /5P+FCFvZCcrVOEWe927351UOKL0vks0/7oNqx8RpVj4QklY2+AKwYYTg3v7uIVUk7gD
         GYWN+JuzL8v49ykaQSZnHtNU438o6wMvJfuW5Vn7xbOGqIyGAL3eV6FouydBgLU27oll
         dsCg==
X-Gm-Message-State: AOAM531maF2RC3v35m0l60Ai4ngZ0eRFeVHcpB79bxPgJ7dLWC33phdQ
        sslfb+pih9u2Ffy9FqfXYUGT9Tp1jsGM723GNHCDeVb/hg5O1vmg7hf+IyKQ74HSsA9QEBqpz3/
        OcKy/PkownvfJ
X-Received: by 2002:aa7:ccd7:: with SMTP id y23mr8413392edt.190.1616146260104;
        Fri, 19 Mar 2021 02:31:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNNwR4QLQrbUFsrZg4XyjREPZfV4WMGAz+2dAqPL5WGkOm3iW6Wk0Ch8wxRb+d/pQvhZM56w==
X-Received: by 2002:aa7:ccd7:: with SMTP id y23mr8413372edt.190.1616146259918;
        Fri, 19 Mar 2021 02:30:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v8sm3688136edx.38.2021.03.19.02.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 02:30:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Remove unused variable rc
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1616143992-30228-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8dc7779-346f-b63a-59d0-bc70fceeb1cb@redhat.com>
Date:   Fri, 19 Mar 2021 10:30:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1616143992-30228-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/21 09:53, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./arch/x86/kvm/emulate.c:4985:5-7: Unneeded variable: "rc". Return
> "X86EMUL_CONTINUE" on line 5019.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   arch/x86/kvm/emulate.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f7970ba..8ae1e16 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4982,8 +4982,6 @@ static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
>   static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
>   		      unsigned size, bool sign_extension)
>   {
> -	int rc = X86EMUL_CONTINUE;
> -
>   	op->type = OP_IMM;
>   	op->bytes = size;
>   	op->addr.mem.ea = ctxt->_eip;
> @@ -5016,7 +5014,7 @@ static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
>   		}
>   	}
>   done:
> -	return rc;
> +	return X86EMUL_CONTINUE;
>   }
>   
>   static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
> 

Queued, thanks.

Paolo

