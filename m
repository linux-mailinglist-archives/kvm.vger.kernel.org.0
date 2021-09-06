Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D1540198D
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbhIFKO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241851AbhIFKOY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630923200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6w6LAFexoBEaduWz7q8eyw7xCDoy2E5zTIuRR/QZtqk=;
        b=Jz93mwJ+QVRQbG5Bd6BeuVzlmfBfB9vWMuLD7TqG6s79a5eaiejaPHdm1ynxAACYtpI8LW
        NasJnL3Ha3FdXTZQ5vHtYhXMKWCQhHp17KcKxWfvJwNPDSSOPe0Sk+w7P0y3ACMET25KLr
        yjZJboC4VR2UTMtlkssU+L0R466MpJA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-sHeT1cDIN1-GiQNXCdg4_A-1; Mon, 06 Sep 2021 06:13:19 -0400
X-MC-Unique: sHeT1cDIN1-GiQNXCdg4_A-1
Received: by mail-wm1-f71.google.com with SMTP id r126-20020a1c4484000000b002e8858850abso2164883wma.0
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6w6LAFexoBEaduWz7q8eyw7xCDoy2E5zTIuRR/QZtqk=;
        b=Pil3OHaiyUkmd1SA6bQ+BXJhrKtvqFo9MeDtdHTmVq7J0qpz59nqkauJUKI0mOFHKr
         SrFqAfqxsF2bKTlQnjFNngnscAbXMruVkI067d4p3Rc3NLpcdCfTASQZsYrx0Tdgo3m4
         KHcEpUwttXKrpymvUkdjUDJQVJL91u53yMRJVkeKbAZk+e+BydPr7eKPD7aHvlGyR85D
         BrXGFIhzLuBLYpmZ+sTODX93EdKZ3treeXFgFi0k8ge6SvQd6bi6sIqbKMoRlXIuNIvJ
         F+IVduShdzRNMRC7RWMHChxPnmyoC+L3OjTXU+ZccS3MEOxS/S55g7BZGboC1iMVeeuR
         buMg==
X-Gm-Message-State: AOAM5326yMhAxNTR+TtUn+3qIrvCKpQxD3IUObl0GG+yqwtkmlMy4Rs2
        Ng4KWtp2j/a1g3+c6N1cQNfNjg42+67RkvJjmQdJRFSYPStVz/oFpxMqSIqyBha5FEDtcixw2ma
        HA4S5r9cyK2l/
X-Received: by 2002:adf:f00f:: with SMTP id j15mr12767439wro.265.1630923198182;
        Mon, 06 Sep 2021 03:13:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWNKIJirwR0n4MrIYuHA/BoWJh22sJ26zsj+XcsKpsxVGIHDHCEpJzatFFAPC9c5KeqDfNLw==
X-Received: by 2002:adf:f00f:: with SMTP id j15mr12767420wro.265.1630923198005;
        Mon, 06 Sep 2021 03:13:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h11sm8796814wrx.9.2021.09.06.03.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:13:17 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Remove unused field mmio_cached in struct
 kvm_mmu_page
To:     Jia He <justin.he@arm.com>, Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210830145336.27183-1-justin.he@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4cbba0a-b346-628c-36f1-6f7c5d1c1ca1@redhat.com>
Date:   Mon, 6 Sep 2021 12:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210830145336.27183-1-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/21 16:53, Jia He wrote:
> After reverting and restoring the fast tlb invalidation patch series,
> the mmio_cached is not removed. Hence a unused field is left in
> kvm_mmu_page.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>   arch/x86/kvm/mmu/mmu_internal.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 35567293c1fd..3e6f21c1871a 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -37,7 +37,6 @@ struct kvm_mmu_page {
>   
>   	bool unsync;
>   	u8 mmu_valid_gen;
> -	bool mmio_cached;
>   	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
>   
>   	/*
> 

Queued, thanks.

Paolo

