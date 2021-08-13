Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216603EBC23
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 20:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhHMSgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 14:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhHMSgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 14:36:52 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF32C061756;
        Fri, 13 Aug 2021 11:36:25 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r5so17205260oiw.7;
        Fri, 13 Aug 2021 11:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OX42h8St+RmVz9wXOQXgL9a26RAmj4rjnHNOaTkFFW0=;
        b=CqWnZh0Dt8NqhJAg+956rXykSGhBoXP+6EBZsQuHuMwpkrNE5+ld5M+vY9MkYsEGyf
         eojTsnsV2KJyyhKuwvhNbq4JOynVVMHvXW3cpPLVMeez8F5hYKyZ1E/uQ3rBjLtM50+z
         hpTxDxufndmzXloZoKzKxSc9XP09Z4q72EpUUR8+mvKQitwPBCYIiMa8xQji4JoAtdqA
         WQLp9E0kkPKjMqZKYpjw/dSAzOCSuvo+db9hXe7J5umXTw+OStuJQUZVwWI+Kh27RboB
         GVb1FLUok4NeP96WNz9KChhVy4Btizeet1zq097swY2OmJz2O4JfBO/edwqNvxnOP9+E
         UrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OX42h8St+RmVz9wXOQXgL9a26RAmj4rjnHNOaTkFFW0=;
        b=hFmiLJ0YPViFwfXyhTJq4nX6KJluX7TqkAgQGc/P0REil/Sf5kE7p0l08ptlC3ecN7
         7EIrS/CJXnZpAwJLkFWBoOVZ+rv5i4hRUAbCbEMiMuRMpoBJbeF3U6GY/PVKnAd8SiWV
         YCTqkluyDu+NcFJuHLwQwxJ9H6xtZGvo1weQdXcyONy0wTftZeoS1pZpLHB8URlBByqH
         7qU8pNiPfTXuCe7i5NYLSjSz9m1FXs2UkynjtTszVTUd9hdj5FPVq6FXrSnn9Fx9CGj3
         HMNsEW3iB6d7vEZKTHB7OOkx+uy3InXjpjdYitAbkRtyGaAP3OagkNohYOc1TyQSByIj
         dTZA==
X-Gm-Message-State: AOAM533NbAMPTQ9zJLOMMwZgzDqbuhLjadETco38+R0C0WZkKgdt3jPN
        AziXW2xX/G6UB0sXsTPXDn8=
X-Google-Smtp-Source: ABdhPJwfRnF3NmHT6g6Bq8r2FDE9A6tX0UM2T9jki2ZxIiTbxg84WKtcrGU8s1dQ/oyJNs20tMYZTA==
X-Received: by 2002:a05:6808:14c2:: with SMTP id f2mr3197024oiw.100.1628879785026;
        Fri, 13 Aug 2021 11:36:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t21sm452164otl.67.2021.08.13.11.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 11:36:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 13 Aug 2021 11:36:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hikaru Nishida <hikalium@chromium.org>
Cc:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, suleiman@google.com,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steve Wahl <steve.wahl@hpe.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [v2 PATCH 2/4] x86/kvm: Add definitions for virtual suspend time
 injection
Message-ID: <20210813183622.GA2201105@roeck-us.net>
References: <20210806100710.2425336-1-hikalium@chromium.org>
 <20210806190607.v2.2.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806190607.v2.2.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021 at 07:07:08PM +0900, Hikaru Nishida wrote:
> Add definitions of MSR, KVM_FEATURE bit, IRQ and a structure called
> kvm_suspend_time that are used by later patchs to support the
> virtual suspend time injection mechanism.
> 
> Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
> ---
> 

This patch series assumes that kvm is supported on all architectures and builds.
Where it isn't, it results in widespread compile errors such as ...

> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 8a364aa9881a..233ceb6cce1f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -22,6 +22,7 @@
>  #include <linux/pvclock_gtod.h>
>  #include <linux/compiler.h>
>  #include <linux/audit.h>
> +#include <linux/kvm_host.h>
>  
   In file included from kernel/time/timekeeping.c:25:
   In file included from include/linux/kvm_host.h:32:
>> include/uapi/linux/kvm.h:14:10: fatal error: 'asm/kvm.h' file not found
   #include <asm/kvm.h>
            ^~~~~~~~~~~

Guenter
