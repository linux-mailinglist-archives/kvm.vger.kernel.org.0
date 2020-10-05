Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E1283257
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 10:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgJEImn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 04:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgJEImn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 04:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601887361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=31ayAEZBmqR7Ux6sh3+il7MrW6ACpreoIzwTXfmAPrc=;
        b=AsI3HdeOYoRXM82/0LnqCIJq0Dz9s3t18P5rwc2z+fORw5tvdJzWa6dWw9/0CHRRXD9saV
        rI3/lGDg3ddOqZYqN4wXUXHybnbkQLTSYkfnoFiog3obnb3GX2jIR3K7CpuFZLmz4uocZh
        +bZlwY+WyRwWA3/d88GQHvLkHGVQ4KA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-4yrGRKOAPc6apvoBeqP3qw-1; Mon, 05 Oct 2020 04:42:40 -0400
X-MC-Unique: 4yrGRKOAPc6apvoBeqP3qw-1
Received: by mail-wr1-f71.google.com with SMTP id 33so3706595wrk.12
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 01:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=31ayAEZBmqR7Ux6sh3+il7MrW6ACpreoIzwTXfmAPrc=;
        b=YKAgD/OzKGKsa1aSH/n4HIXfLFzzne8rVwnZOoI6sTCXI/qkQH+ewiz8LAoy3gTtDp
         ulVG0Zuy2g6rVbfROHzZx5pKIA9PQlOjovvE5YLV58kzw+8A/SJrK6gDpoPDUvJ5jyz3
         JUsMeNqOFDjLhpR9U7W0iBjSdhJB9OrqzAcJyZADLOEOW4aExvrHwHY++fC2CdkojfCf
         b9iOOk014kBvahVGoM4gtmvUB7P7IeibhKNN3qgZyOmTLfBh/9MMZUbozGLHvneJb4QA
         22bxsjqZRDIKXsgvLmIyzlRCYJo/ynfB2THPhsUNzj42Naq4ZO5KWuJyrVgXKoNO0ipm
         VfOA==
X-Gm-Message-State: AOAM5326HClH42v29pFoNx2ydnzXKBFdyjzR4t6kQ5+5/M0+OWcaGHFS
        pUNLKg1FYUgRbgGajYsS89uzioIuyRVqkwmZMzNcELWjM9IfDlBMRfQI6dI36/IwYpWyAlb5A7n
        aTZhX7fUetsAD
X-Received: by 2002:a1c:6804:: with SMTP id d4mr6505405wmc.27.1601887358464;
        Mon, 05 Oct 2020 01:42:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbgs9J3lD+xwtoqnW6h73f9rYZuUE1ffjGguH49HzGGs5wF02yJTIb/XLRHExUr1M2Hk1bmw==
X-Received: by 2002:a1c:6804:: with SMTP id d4mr6505374wmc.27.1601887358171;
        Mon, 05 Oct 2020 01:42:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t13sm1588514wmj.15.2020.10.05.01.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:42:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Update the comment about asynchronous page fault in exc_page_fault()
In-Reply-To: <20201002154313.1505327-1-vkuznets@redhat.com>
References: <20201002154313.1505327-1-vkuznets@redhat.com>
Date:   Mon, 05 Oct 2020 10:42:36 +0200
Message-ID: <87o8lh83nn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> KVM was switched to interrupt-based mechanism for 'page ready' event
> delivery in Linux-5.8 (see commit 2635b5c4a0e4 ("KVM: x86: interrupt based
> APF 'page ready' event delivery")) and #PF (ab)use for 'page ready' event
> delivery was removed. Linux guest switched to this new mechanism
> exclusively in 5.9 (see commit b1d405751cd5 ("KVM: x86: Switch KVM guest to
> using interrupts for page ready APF delivery")) so it is not possible to
> get older KVM (APF mechanism won't be enabled). Update the comment in
   
Sigh, this should have been

"to get #PF for a 'page ready' event even when the guest is running on
top of an older KVM"

or something like that but the part after "#" was eaten by git :-(

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

-- 
Vitaly

