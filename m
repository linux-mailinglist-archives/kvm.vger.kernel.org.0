Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D209436C54
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 22:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhJUUrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 16:47:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhJUUrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 16:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634849133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/SUfFd7tmRLSxE+s820D6mW2/CdeETMvR8Nw8HQGk+c=;
        b=Yxkh/DM8rPaYiz8nG+rN2TKp6lYZbVrLkSsYyLtSKdiMf1YaNxXtSeYyqA8RwR/lGxVNYo
        Go8R7MyL7b5kLf0/K+6kGw70r5mBOMfYXiNcv2JCW7E42SyZl0251kFN7pPJuWWIuHtiut
        fj4u6BcFdY2x1FboRI9n9v/54OpnGgI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-zPnOlxUUM3Kj0qYvmQwsiw-1; Thu, 21 Oct 2021 16:45:32 -0400
X-MC-Unique: zPnOlxUUM3Kj0qYvmQwsiw-1
Received: by mail-ed1-f72.google.com with SMTP id l10-20020a056402230a00b003db6977b694so1544924eda.23
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 13:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/SUfFd7tmRLSxE+s820D6mW2/CdeETMvR8Nw8HQGk+c=;
        b=ZW/VcftQS+AZ4MpTnASa1y549ubQwKPCcf+PEArX67p91YiudPTeI2J930XgscV+CL
         qHaxVQ2GtLPPsYp2nmKxbr9SkHVsR9Mq67OrnjC32TYfs6smBqij1UR9vGWsJFJa01vD
         7Bg31lUDt3OgVHGkOFC+2YgMEKoJmefumAfMmlIlfUEnE1mvXqCdV3YMhCJPBKEIn9L3
         0K7mNm9sRC5YS6bCLBSf1q9YMULEBir7wHuz7I801DBGLQd6hEJ1jqk+TagAWO3kWdfy
         VuH6bvDSGdkkZGkqUCw6ImoLE9QcYduESzJ0fDBxZFTh6uzHL1Kjcua+yfg6Y750OpsT
         +4kg==
X-Gm-Message-State: AOAM531dX78s8AMUDEfXzDYK7j60eS4kpMrr5S0Y7XOC2XMrfWFc1uK4
        DEhOJVScK2/Kt4L4SvO/fTqMWGEs5bc4ehYhVewwE+rk6n1qLyKp+HFZ88/3fkj4KFHFJOcSf7K
        U5HN/rjnpApLh
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr10150025ejr.149.1634849130494;
        Thu, 21 Oct 2021 13:45:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhjTeDsNE4YwiZ1H0bKsd1MMTBAyg+vBlirDPGcGcy+e6HV6pN5leYTVkefemvCaH9hvoheg==
X-Received: by 2002:a17:906:5950:: with SMTP id g16mr10150006ejr.149.1634849130334;
        Thu, 21 Oct 2021 13:45:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w7sm3492053ede.8.2021.10.21.13.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 13:45:29 -0700 (PDT)
Message-ID: <fdc97a01-2d08-26f4-e71b-9a9533c7c3bc@redhat.com>
Date:   Thu, 21 Oct 2021 22:45:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] kvm: x86: Remove stale declaration of kvm_no_apic_vcpu
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20211021185449.3471763-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021185449.3471763-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 20:54, Jim Mattson wrote:
> This variable was renamed to kvm_has_noapic_vcpu in commit
> 6e4e3b4df4e3 ("KVM: Stop using deprecated jump label APIs").
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/x86.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 7d66d63dc55a..ea264c4502e4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -343,8 +343,6 @@ extern bool enable_vmware_backdoor;
>   
>   extern int pi_inject_timer;
>   
> -extern struct static_key kvm_no_apic_vcpu;
> -
>   extern bool report_ignored_msrs;
>   
>   static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
> 

Queued, thanks.

Paolo

