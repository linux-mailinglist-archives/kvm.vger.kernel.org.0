Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E1148D646
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 12:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiAMLDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 06:03:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231831AbiAMLDz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 06:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642071834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MpZ4Du/iM3hkKHHuN33A6bZXhYi9Fwj36mcGGjKskBw=;
        b=XxNeE0LJM+w3K774fdgW43OfUSgoTUjxMEWwmh+D7Z+/UnLwgmrP2wmJCEUYSY4bqAAczi
        tY7WX4YUu8yJoy6diyOALgIsbCz/c8ASwLuBjncTULrxtAzxueLePzZqOZVD3dq9xKxVqe
        XMfMdtnUz6Jx2Lu3MyaGXpI6K7V6GkE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-fMbRlD3NOFelcU312XOFiA-1; Thu, 13 Jan 2022 06:03:53 -0500
X-MC-Unique: fMbRlD3NOFelcU312XOFiA-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003f9d22c4d48so4991401edd.21
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 03:03:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MpZ4Du/iM3hkKHHuN33A6bZXhYi9Fwj36mcGGjKskBw=;
        b=T/VpVDufjqOXK+uCM942wFLsYou3I/EI/BRNC6NZCS3T11jFNjABJEWVRlpfrPoiB7
         EFWbHnVshrnSvqlvu3+atykUh/XB90QUww/ajWp2cErI4EXMCj4zQ9oXEVAHx+K+Fx6Q
         fpb26AGh039puxW567Nu4oLRSbf7ZPK81sJfofcOyeEdrgxZN/QX+EQ9Ko5ya4KrFYNY
         XdokoCDqTJ1FT/1Ovps4pyI8Cy0w7VXRkGAFrTZbFeTo/HqWkHN182rxBYztRauK5PLX
         0dqbcQZP6Hy6shZ5y9pw+s+vs06GlF7KRkiwpWwur4HUVF0D/d226p/ztDefmVg+uEhs
         ZZRA==
X-Gm-Message-State: AOAM533Lkl+M8zb4zAGIAclVJ+VrH19dngPoc7IF75ukjERFIOSGPNqM
        4hhj7IntXcXrVsTRNuX/0GVunztVifNM9umHlACUNwJGCdoN1DUYXV4h1WiIp71Nx/mun4YI4Kj
        8h6LliMJxIrCp
X-Received: by 2002:a17:907:72c3:: with SMTP id du3mr3034509ejc.114.1642071831851;
        Thu, 13 Jan 2022 03:03:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5nCl7RoTG6c5m83v9OIRnTyFQ7PANN2z1weIZQ3bscYBH59y9e3ohr1LZGiWRx0W1za5VfQ==
X-Received: by 2002:a17:907:72c3:: with SMTP id du3mr3034494ejc.114.1642071831644;
        Thu, 13 Jan 2022 03:03:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id qb2sm760403ejc.219.2022.01.13.03.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 03:03:50 -0800 (PST)
Message-ID: <57e8ee6e-e332-990c-2f4f-1767374b637b@redhat.com>
Date:   Thu, 13 Jan 2022 12:03:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: fix kvm_vcpu_is_preempted
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org
References: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1641986380-10199-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/22 12:19, Li RongQing wrote:
> After support paravirtualized TLB shootdowns, steal_time.preempted
> includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> 
> and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED

The combination of PREEMPTED=0,FLUSH_TLB=1 is invalid and can only 
happens if the guest malfunctions (which it doesn't, it uses cmpxchg to 
set KVM_VCPU_PREEMPTED); the host only does an xchg with 0 as the new 
value.  Since this is guest code, this patch does not change an actual 
error in the code, does it?

Paolo

> Fixes: 858a43aae2367 ("KVM: X86: use paravirtualized TLB Shootdown")
> Signed-off-by: Li RongQing<lirongqing@baidu.com>
> ---
>   arch/x86/kernel/kvm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 59abbda..a9202d9 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1025,8 +1025,8 @@ asm(
>   ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>   "__raw_callee_save___kvm_vcpu_is_preempted:"
>   "movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> -"setne	%al;"
> +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> +"andb	$" __stringify(KVM_VCPU_PREEMPTED) ", %al;"
>   "ret;"
>   ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
>   ".popsection");

