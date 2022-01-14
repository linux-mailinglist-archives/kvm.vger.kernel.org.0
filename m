Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B37848E8AC
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbiANKz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 05:55:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235571AbiANKz7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 05:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642157758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7t2L0tGPvBmzptQJNYlx/mVxaNkmH98DPVD0FMy+4Y=;
        b=BMeOaMaOXtUTSOjAzoSKFV4bYK7gMq/nwBhzWz5h/pGPQcOYbvG//M22/04Pd6ypl9jogk
        pjo1jRa9G9i4da3JDIzq25htYJ3uAGrTKDJS8BCyXwru97QH2Cps1ygK6qiI5zDdYqknMM
        /o+yGadtpeNTyI7xnsVWrvDUrPsmANQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-Jn14JCnWMQ6T6rc5U4gw8w-1; Fri, 14 Jan 2022 05:55:57 -0500
X-MC-Unique: Jn14JCnWMQ6T6rc5U4gw8w-1
Received: by mail-ed1-f72.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso8064456edb.7
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 02:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i7t2L0tGPvBmzptQJNYlx/mVxaNkmH98DPVD0FMy+4Y=;
        b=t5LNfuGKnJmhEg0ZzRJhh+Rs5M2moA4JsVKzy/4QHokqIRlEl0fowWjbAMBkFwuu2X
         mxJuBRdMyN1lOFXCMhpXqFk26xGXFnWky5R9afcgIYSUN1DfvAp6nJ4yXzEvIVHKXArc
         bYbfGDFc8BZKskDeO+4FTB58arrRS17/g6otPCR+l8BdLrgwTUSZwsCgmQcxHdHJiCSf
         hGfryxfLAyOCJTGdka8Z+azaeoXm8tnhWEDBhARRo3kg1ge2eOoaC5QhHZ3pI6/jBsmd
         r42NvY+Ibjehp/NW29VVrFGEAadLpsMgGWJPTIe3PRTE+iXS/lrcN+YCSyK9akEcu54R
         6hRg==
X-Gm-Message-State: AOAM533G4LmppwmI2usorDQQVtD2AKhTlzQNqfIS/5LvWYKwrXNlnXav
        P1asDtlv4AP3tPYgPMwazb04cQftNCKjcrvtCa+FtyaxZYv3P/ynAdusWCdBlGqHXy2WLQsaEW7
        z1+btomBzEzFB
X-Received: by 2002:a17:906:6a17:: with SMTP id qw23mr6719795ejc.117.1642157754333;
        Fri, 14 Jan 2022 02:55:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2NrQFgZtZ206dke6TC2VKRWWmb4O/1kn1Bh2tvLacuUltKQGsMqOC4U7RU0nLfICQYxKfkA==
X-Received: by 2002:a17:906:6a17:: with SMTP id qw23mr6719779ejc.117.1642157754085;
        Fri, 14 Jan 2022 02:55:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j9sm1694138ejg.64.2022.01.14.02.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 02:55:53 -0800 (PST)
Message-ID: <ee11b876-3042-f7c4-791e-2740130b93d4@redhat.com>
Date:   Fri, 14 Jan 2022 11:55:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re:
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org, peterz@infradead.org
References: <1642157664-18105-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1642157664-18105-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 11:54, Li RongQing wrote:
> After support paravirtualized TLB shootdowns, steal_time.preempted
> includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> 
> and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1:
> clear the rest of rax, suggested by Sean and peter
> remove Fixes tag, since no issue in practice
> 
>   arch/x86/kernel/kvm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b061d17..45c9ce8d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1025,8 +1025,8 @@ asm(
>   ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>   "__raw_callee_save___kvm_vcpu_is_preempted:"
>   "movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> -"setne	%al;"
> +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> +"and	$" __stringify(KVM_VCPU_PREEMPTED) ", %rax;"

This assumes that KVM_VCPU_PREEMPTED is 1.  It could also be %eax 
(slightly cheaper).  Overall, I prefer to leave the code as is using setne.

Paolo

>   "ret;"
>   ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
>   ".popsection");

