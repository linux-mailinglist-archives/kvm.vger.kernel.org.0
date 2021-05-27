Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6999E392D6E
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhE0MDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234562AbhE0MDD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 08:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622116888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rshtr6KYefJiK6sc+86geasmnYg3Ge2yt4jk7Bd54GM=;
        b=XoCGhUKa8r1p3fx30I/r/ratfHI34rKwhQ78T3rj7Ivt9iJ5Ay7IHFikmw6LKgsZIyKTdm
        NdFLWtgfuVE0x1kSkEkzNo8ViaAMeWVAMn0RGaonA/irOMR1vgsMCn5+uEt4jHi3uRRL7l
        lltU3gXwbtiQlDzFOjqaUBYNzFJR/n4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-q4_FFIjENiubgdD3PfX85A-1; Thu, 27 May 2021 08:01:27 -0400
X-MC-Unique: q4_FFIjENiubgdD3PfX85A-1
Received: by mail-ej1-f72.google.com with SMTP id rs12-20020a170907036cb02903e0c5dcb92dso1544034ejb.15
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 05:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rshtr6KYefJiK6sc+86geasmnYg3Ge2yt4jk7Bd54GM=;
        b=X4Fvx5d4b+MsuJCzeSrBpiD7N+IHC8kivhv77f6DXfO4uwf9lTrlgdI7NtDFI4UFNP
         8EvWrOBoNb/ATMIzmbD8Se1EUQo/dqhhPVrNg/8xD5BjV9nzSazNnzWIkqlX8cfhrVtk
         fVV/cuj0zn+Fv0nZu7wk+kt2ZSxhWVGIglgTA4AjPxmh7yW6bbdu5Ay7I3Y1LgYA+uI2
         hBs69ovLAFGt9TvZovGlHo5XKmq7q6ZUMoz/Y8AfQJVkjcyw0v1QM6UuJFkDAK4xrnLs
         M1qNTpqw/k17ERTtE9cXLRTr08ozE3T5Z9e0HQCYrKtNSUIXzDPgRwNh8KEj51X5PvqU
         rkEw==
X-Gm-Message-State: AOAM5309XFH5TCUU+jb2pWFJE7q3tjil89wXM5/bLdPBw47Jbg+HnadT
        d3dhVEmxcwBH18ebzqfGnMtW48LxJSFC1i7dCuChHZKk6s5JHX9mtTQeft41wnMiVG7vLdhNhTn
        u6ZMrlKUNu2Is
X-Received: by 2002:a17:906:4812:: with SMTP id w18mr3402663ejq.4.1622116886290;
        Thu, 27 May 2021 05:01:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8zPMDWqAht84GtBKT51luHWyc6knch/ws7by24yBeWStSQysPxs6+g3y+ksCmKD/2Q7IuCw==
X-Received: by 2002:a17:906:4812:: with SMTP id w18mr3402645ejq.4.1622116886092;
        Thu, 27 May 2021 05:01:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jt11sm888558ejb.83.2021.05.27.05.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 05:01:25 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210526163227.3113557-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3f91bae8-942c-a311-29f6-4556682217b4@redhat.com>
Date:   Thu, 27 May 2021 14:01:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526163227.3113557-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 18:32, David Matlack wrote:
> This comment was left over from a previous version of the patch that
> introduced wrprot_gfn_range, when skip_4k was passed in instead of
> min_level.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 95eeb5ac6a8a..237317b1eddd 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1192,9 +1192,9 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   }
>   
>   /*
> - * Remove write access from all the SPTEs mapping GFNs [start, end). If
> - * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
> - * Returns true if an SPTE has been changed and the TLBs need to be flushed.
> + * Remove write access from all SPTEs at or above min_level that map GFNs
> + * [start, end). Returns true if an SPTE has been changed and the TLBs need to
> + * be flushed.
>    */
>   static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   			     gfn_t start, gfn_t end, int min_level)
> 

Queued, thanks.

Paolo

