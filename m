Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD71E6043
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 14:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbgE1MJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 08:09:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388750AbgE1L4c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 May 2020 07:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590666990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yiz5dSOYdlV7/pPCeIEVuYRNWj51QSmz3pq/ju45gCA=;
        b=AmEKr4AOy6SBsHOIfvGUroLhAqyXc0piACz7y0G6LoJihaZky311F5hjm+wJ94kPrp6e9W
        fLC+iGarMMFCGLTEmls3zETQJNXed65sbC4/iTBKg+GYEzUYheNJaJFDf+4IyOyPYbeDvy
        PetcSFYSdixlFQVp9ydQj/A4A1ezy/I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-rdkIDvvoO3y551Wjy8nSZg-1; Thu, 28 May 2020 07:56:29 -0400
X-MC-Unique: rdkIDvvoO3y551Wjy8nSZg-1
Received: by mail-wr1-f70.google.com with SMTP id q24so7127741wra.14
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yiz5dSOYdlV7/pPCeIEVuYRNWj51QSmz3pq/ju45gCA=;
        b=EGpRlcSlXP5znstNp5XTCk6blz6mlroQwjVlhru+XdalHeDUBttKXhTytxhwfn+6N/
         LphVmpLnDV6/X6sE43yYGys39kT81s9Xycjlmvxgu/F+LmdzHNYF0jnAEguHblbhEDAr
         JhNaHqe94KOhW3/xGn5vgzxX2ypIGSyrCODcaMgA+FX+ifItFxOuNOwtaJEz9C/mnTgb
         puQ5PEWLuFwvNnCdWHjmUNLJ3HUn7QtT2uFb8xdgFO5gInBSVmH5DmM0QdWlxfFU15vQ
         en7y8AJpCKIyuFrC4OKpGHKdizCZyGJQmqUs7vHCr9MMDYXWOBLQPrXP7bzbbrEpscF0
         sM6g==
X-Gm-Message-State: AOAM532PVN/LG/iOHnueaXA7WXm+9wZEAN4j12GNbvpCJWbfrQvBOCzQ
        6Y+AHRkfeW6HfRPT2gLoFqZUlaJ27bmE7EkmOFDi0iQFGYQR7Jl2dusAqeoM7UI3bXll6znNBCB
        oHMgs17ntapyx
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr3231831wrt.341.1590666987859;
        Thu, 28 May 2020 04:56:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKuPIf7B5Cz3iHbqwMVjcFt8fJUNDvvngaOdIAtByLGJ+sgSj7uK/BuNlur4kQQFO7KPpNXA==
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr3231809wrt.341.1590666987632;
        Thu, 28 May 2020 04:56:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id f2sm6023682wrg.17.2020.05.28.04.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:56:27 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: Remove defunct KVM_DEBUG_FS Kconfig
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200528031121.28904-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <257b0ba7-84e2-89de-3708-1174f5d090be@redhat.com>
Date:   Thu, 28 May 2020 13:56:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528031121.28904-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/20 05:11, Sean Christopherson wrote:
> Remove KVM_DEBUG_FS, which can easily be misconstrued as controlling
> KVM-as-a-host.  The sole user of CONFIG_KVM_DEBUG_FS was removed by
> commit cfd8983f03c7b ("x86, locking/spinlocks: Remove ticket (spin)lock
> implementation").
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/Kconfig      | 8 --------
>  arch/x86/kernel/kvm.c | 1 -
>  2 files changed, 9 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1197b5596d5ad..0ccf4e76acfe8 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -818,14 +818,6 @@ config PVH
>  	  This option enables the PVH entry point for guest virtual machines
>  	  as specified in the x86/HVM direct boot ABI.
>  
> -config KVM_DEBUG_FS
> -	bool "Enable debug information for KVM Guests in debugfs"
> -	depends on KVM_GUEST && DEBUG_FS
> -	---help---
> -	  This option enables collection of various statistics for KVM guest.
> -	  Statistics are displayed in debugfs filesystem. Enabling this option
> -	  may incur significant overhead.
> -
>  config PARAVIRT_TIME_ACCOUNTING
>  	bool "Paravirtual steal time accounting"
>  	depends on PARAVIRT
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb728..89ba09228eaf5 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -21,7 +21,6 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/kprobes.h>
> -#include <linux/debugfs.h>
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
>  #include <asm/timer.h>
> 

Queued, thanks.

Paolo

