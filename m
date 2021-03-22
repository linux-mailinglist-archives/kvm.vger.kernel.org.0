Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC861345090
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 21:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhCVUQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 16:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhCVUQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 16:16:49 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE4AC061574;
        Mon, 22 Mar 2021 13:16:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kt15so13902054ejb.12;
        Mon, 22 Mar 2021 13:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9MgTlf1yAFXA1SMLrg9uUz/Zx0G39O4yukxveacwuqA=;
        b=Hq65TokTTybC8WE57EfUDp9sTV9M9Uj3qvRaRzNi56m04h1hFo9nTnoLkJEMMfoV9Y
         5efIFo+Xg8z+/7Cy1EnJQ5kKNCD3mcS0837WtZLhVeL1Ywv6D2fLWYo6tObqONtEbkGe
         z4VY3XAL/fxZA4adZG8L2HbkQLKc1EQ/f2jAh85bj1+oHOPQFUth9rEm1z5oSsFI68ks
         unegnSmcVgmWnXYbIDvM1vUGELf09x8qDEbGg1PUbXV4B1SrOAQ2vvqZ5s9TsIFvYtIU
         0f5Z/BBoigW593g05pxWgCw56jGKV8VIN+PeAdSJYmMFeDAi8gJ47ZFMAzvz/hGyQvIR
         OxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9MgTlf1yAFXA1SMLrg9uUz/Zx0G39O4yukxveacwuqA=;
        b=lpy+5+O5FlTShE5mLfFOkZQjxZ/0fr2iBjWXy7EpVN7IRoVa+RHvlXQF7zVi9AoCIr
         Fx0qQFFyeizvFtFP7B8FfQt1sqfv+9not4gTRBM5Z7WV4VXHv9txGbtcl8J73pi8XcmE
         tqT+ram+wM6EefXG9+gD9mdAR/S2r62trc5kRJ5cG3u8DLP9iMBpyS9d9PiQbW9Jyekz
         2969bUVs31cFcvpkVIBcIRTPf5ztbqYU1jiFZnqq2xUmRIhKKVqvmkCOIncta79i3EnO
         AVsJ0A3zM61xBFDuiVPXX+SLXoPWMNL7JUcLabPeQMmZZ9e2b89qPDGhEWw61eL+Q3Bz
         wlWQ==
X-Gm-Message-State: AOAM5330YnFes3qbd43QR5aeQfpMa0kpS/pEQZw9wKNpAMVUsfwlCJY0
        jNEyYOUEsPTgZG+BL8ya+Tc=
X-Google-Smtp-Source: ABdhPJzr+jqpvKPNXdzFVykPB4evgT36hacay7YqEiM9TqMNmG4Ay2EymQyc6TGf8SZzaBg3WUKMlQ==
X-Received: by 2002:a17:907:20e4:: with SMTP id rh4mr1473531ejb.369.1616444207247;
        Mon, 22 Mar 2021 13:16:47 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id n26sm11857852eds.22.2021.03.22.13.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:16:46 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Mon, 22 Mar 2021 21:16:44 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH V2] KVM: x86: A typo fix
Message-ID: <20210322201644.GA1955593@gmail.com>
References: <20210322060409.2605006-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322060409.2605006-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/resued/reused/
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  Changes from V1:
>  As Ingo found the correct word for replacement, so incorporating.
> 
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..e37c2ebc02e5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1488,7 +1488,7 @@ extern u64 kvm_mce_cap_supported;
>  /*
>   * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
>   *			userspace I/O) to indicate that the emulation context
> - *			should be resued as is, i.e. skip initialization of
> + *			should be reused as is, i.e. skip initialization of
>   *			emulation context, instruction fetch and decode.
>   *
>   * EMULTYPE_TRAP_UD - Set when emulating an intercepted #UD from hardware.

I already fixed this typo - and another 185 typos, in this 
comprehensive cleanup of arch/x86/ typos in tip:x86/cleanups:

  d9f6e12fb0b7: ("x86: Fix various typos in comments")
  163b099146b8: ("x86: Fix various typos in comments, take #2")

Please check future typo fixes against tip:master.

Thanks,

	Ingo
