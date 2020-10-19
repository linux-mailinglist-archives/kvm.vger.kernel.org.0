Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E4292A31
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgJSPSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:18:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729849AbgJSPSE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBCguRNOfJllp0/NwaH8eTnMNWpZQS4LUPzl0zBKDS8=;
        b=TAJrUwTPoW6bH4ndvHFkm97pTVxO8pmu2twmojHdXamY1MFUbtnjCkODEMqe7oVIL0rAvl
        B2GuS/f4PlDV+6Lu+9YJKWAnRI7x6NI8Z8yQnBl2iCgPbEuof8i6NUlwsdh32/1k25dq/d
        DzHznZ9VykFOVoMUFgW0mXlXhW2oANs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-5mZo14OrOEyUoW5_XMTUwQ-1; Mon, 19 Oct 2020 11:18:01 -0400
X-MC-Unique: 5mZo14OrOEyUoW5_XMTUwQ-1
Received: by mail-wm1-f71.google.com with SMTP id r19so53328wmh.9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eBCguRNOfJllp0/NwaH8eTnMNWpZQS4LUPzl0zBKDS8=;
        b=oDg784m0qxH+cAMHScNnY+ccOaesjQbR/aMYrw1geqqZiTWbA8kZQxfNSx25ZahxQh
         sMJ/pImKTSuGGVDRhCySh1dAoKwH6bRvWqFiwx364pwxDVCqkQ0+K+mmXhNZNSPGVtZq
         BhC5/CmYDe+KXROW42JfsbIv1/cm04/vjz9aUBFQxQZ2BmgNcj0czYFEW0jEFxx4eOrZ
         Dg2qBQeVkwXcQCRcZDQ+IvTFUjTjxch/gdJ/preASmI5yhutq1tO15oNmTdHm/RCEULe
         +J7ZS827MA4Rpcl7Z0wyYwuyBtOIyTfzz/0qiU+KaF5JUmb3M3gY5qmPGEceWei49hwd
         Nd5Q==
X-Gm-Message-State: AOAM5328j1HT9Kceca3WvM9YtIJm6gxnxcfRaNEvA1krE5VcXENAQgPm
        vVeiiB34Vp1/uk8E+aENqvFzCZcc79QKi4j+kJWBxXp+QbYivYKNB67I1QZq4OABzHSgyqliTb4
        uJOs9GbPH3zmC
X-Received: by 2002:a5d:4fc5:: with SMTP id h5mr962wrw.145.1603120679956;
        Mon, 19 Oct 2020 08:17:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWFhrFkA1K5rxHXvfwUbrF2K0FMCTnE2rtnx+2maY1gGUIwZkJLmkLXmqp8oLhPjcNOmX5lA==
X-Received: by 2002:a5d:4fc5:: with SMTP id h5mr932wrw.145.1603120679721;
        Mon, 19 Oct 2020 08:17:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w5sm356911wmg.42.2020.10.19.08.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:17:58 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: Update the comment about asynchronous page fault
 in exc_page_fault()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20201002154313.1505327-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ee54faa-b204-ccec-da42-8029f834b80e@redhat.com>
Date:   Mon, 19 Oct 2020 17:17:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002154313.1505327-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 17:43, Vitaly Kuznetsov wrote:
> KVM was switched to interrupt-based mechanism for 'page ready' event
> delivery in Linux-5.8 (see commit 2635b5c4a0e4 ("KVM: x86: interrupt based
> APF 'page ready' event delivery")) and #PF (ab)use for 'page ready' event
> delivery was removed. Linux guest switched to this new mechanism
> exclusively in 5.9 (see commit b1d405751cd5 ("KVM: x86: Switch KVM guest to
> using interrupts for page ready APF delivery")) so it is not possible to
> get older KVM (APF mechanism won't be enabled). Update the comment in
> exc_page_fault() to reflect the new reality.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/mm/fault.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 6e3e8a124903..3cf77592ac54 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1446,11 +1446,14 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
>  	prefetchw(&current->mm->mmap_lock);
>  
>  	/*
> -	 * KVM has two types of events that are, logically, interrupts, but
> -	 * are unfortunately delivered using the #PF vector.  These events are
> -	 * "you just accessed valid memory, but the host doesn't have it right
> -	 * now, so I'll put you to sleep if you continue" and "that memory
> -	 * you tried to access earlier is available now."
> +	 * KVM uses #PF vector to deliver 'page not present' events to guests
> +	 * (asynchronous page fault mechanism). The event happens when a
> +	 * userspace task is trying to access some valid (from guest's point of
> +	 * view) memory which is not currently mapped by the host (e.g. the
> +	 * memory is swapped out). Note, the corresponding "page ready" event
> +	 * which is injected when the memory becomes available, is delived via
> +	 * an interrupt mechanism and not a #PF exception
> +	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
>  	 *
>  	 * We are relying on the interrupted context being sane (valid RSP,
>  	 * relevant locks not held, etc.), which is fine as long as the
> 

Queued, thanks.

Paolo

