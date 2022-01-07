Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5EA487C13
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbiAGSU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:20:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbiAGSU0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641579594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LEKuHF9yTKUqICMQYUfO1cRr5YsPmHwV4qHCm3WYUtw=;
        b=X0NgqqgGRGUoYiL2t70FNtw7sH49JgiXs5rWYqJrj/ZNs5V8AO7iLzdEk60QmMQ25Kr4Ym
        de3VdgowwR2SbCEIGJSsVDTLLT11xMMT604VHDoJwdh+6nPdxyzITlwdYfcN2QKjsC3YY+
        SUBcFZ4LVl9T+hp8wAEP1hl4JgpKLKQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-TC4aR571M1Sw6C5xvNorrQ-1; Fri, 07 Jan 2022 13:16:43 -0500
X-MC-Unique: TC4aR571M1Sw6C5xvNorrQ-1
Received: by mail-ed1-f71.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so5318312edc.18
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 10:16:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LEKuHF9yTKUqICMQYUfO1cRr5YsPmHwV4qHCm3WYUtw=;
        b=VFIFPKgCPk3P8I/1p+9uwGilnuZe7CpAzocTUuS22diT5H8zyKAW/j8h+Bi6tvqm1h
         f0S/AWXg+I7MJw6B/PknA4I/n9waBFlDszNGqAVa55z6SqBXRDZh4ZVOmJV6WK+zJz03
         NGm+JM/MdNFtOwCbI7DdVZgT/iM72xwd7pjzU8Q7mcHYvOJ92vYnyjaXiEudf56CbD1o
         ANVAwrXVTTBDjrN6ClDlD2SowndsV+OTfvgUYB1mteC8T4USfUxZMWmhk6suahl11n9j
         yDwMCX1UZWRCmO5r7cDKkfi6qms+X58b7XOUUpKbUyr4RjvDjNE5J4xgl+CvZ9OynXUd
         cVZg==
X-Gm-Message-State: AOAM5335C1ZT+aDsDjYApVvSjHnlLkHTSFdHFuErL1eavc/NrT757fdW
        yYS/GXVcdyM0Mb4xo9P45GtLat0GhAg06QcLvLaNrJMqs7ADzK2tRm5xxRgChfqxuOmkt7mp5qK
        W1nMPYM4KqvwO
X-Received: by 2002:aa7:c655:: with SMTP id z21mr57196535edr.352.1641579400798;
        Fri, 07 Jan 2022 10:16:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycjjFb848dQt7J7Fb88K8gCdlrmMdmMLqCzHYOT3oz8rOhUkyQhnSXl1sG+Syoxx5T2OhQ4g==
X-Received: by 2002:aa7:c655:: with SMTP id z21mr57196514edr.352.1641579400594;
        Fri, 07 Jan 2022 10:16:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id di16sm1598153ejc.82.2022.01.07.10.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 10:16:40 -0800 (PST)
Message-ID: <8886415d-f02d-7451-fa8d-4df340182dbc@redhat.com>
Date:   Fri, 7 Jan 2022 19:16:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: move the can_unsync and prefetch checks outside
 of the loop
Content-Language: en-US
To:     Vihas Mak <makvihas@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220107082554.32897-1-makvihas@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220107082554.32897-1-makvihas@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 09:25, Vihas Mak wrote:
> mmu_try_to_unsync_pages() performs !can_unsync check before attempting
> to unsync any shadow pages.
> This check is peformed inside the loop right now.
> It's redundant to perform it every iteration if can_unsync is true, as
> can_unsync parameter isn't getting updated inside the loop.
> Move the check outside of the loop.
> 
> Same is the case with prefetch.

The meaning changes if the loop does not execute at all.  Is this safe?

Paolo

> Signed-off-by: Vihas Mak<makvihas@gmail.com>
> Cc: Sean Christopherson<seanjc@google.com>
> Cc: Vitaly Kuznetsov<vkuznets@redhat.com>
> Cc: Wanpeng Li<wanpengli@tencent.com>
> Cc: Jim Mattson<jmattson@google.com>
> Cc: Joerg Roedel<joro@8bytes.org>
> ---
>   arch/x86/kvm/mmu/mmu.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1d275e9d7..53f4b8b07 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2586,6 +2586,11 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>   	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
>   		return -EPERM;
>   
> +	if (!can_unsync)
> +		return -EPERM;
> +
> +	if (prefetch)
> +		return -EEXIST;
>   	/*
>   	 * The page is not write-tracked, mark existing shadow pages unsync
>   	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
> @@ -2593,15 +2598,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>   	 * allowing shadow pages to become unsync (writable by the guest).
>   	 */
>   	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> -		if (!can_unsync)
> -			return -EPERM;
> -
>   		if (sp->unsync)
>   			continue;
>   
> -		if (prefetch)
> -			return -EEXIST;
> -

