Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D530C1F1B8C
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgFHPAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbgFHPAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 11:00:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13C8C08C5C2
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 08:00:41 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d128so16841245wmc.1
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hjZu9HUiJ4ghbYbVLHHdJJBsYU84vEwMo6AWGQbzbMg=;
        b=H4q0p6dexKRAu9bVDnRSuBCRoRqXk6tNmInurnFg/yZIgEWNJZaxUzJp9X/7yxQx+E
         Kq2z1a4o455v0Lxpi92VdXUmx0hyUT0ay2fwkkHVS1FvMcpSIx7mbZvGiPS7WuQUjzAw
         +cq2dDek+N/qnt2G0nz9jyyORRXYAg2c+A2CWUB9l9QseFwiLsjbg2wasklnP4DkeOMi
         VOrKoLsghKd23Fp3h4gjM7oPG8kR6M86DVX4S1hH0lU785YYfm1JWSQXLe+LiIiogHW4
         nvA3eES0u3Nvu4q1p8fvq7vAiy3KGMlaVeuQ9lD+gmWKWTx46tvQi7eMxrKOD7Hmz7oz
         wKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hjZu9HUiJ4ghbYbVLHHdJJBsYU84vEwMo6AWGQbzbMg=;
        b=gwVHRKwhCQhie019dtnukIwRVJJK8xR7EkUoKVdAn6RVEqOBR6sqXU5+lYZlrEf8NG
         yWIUS30kV/H0pEAxqRu8SdbBah1unAMGfvVxIbD8vCRosN4WZ+ruG3ZFnuXNzACkzJkw
         U5Lb17ehStMsIAYm/sArB7C9rUdI3IbZ+O+0IA9/GTYuAXoIKS4WhOVYbMcj9cru9b+c
         5OyaL+0Y9UOP8ACh6fMpvmJjoNamK6B80zGFxx+g25DdNFEvCcBHtH1BABTaPjp+uOil
         +QJ7ASa70g9HsnMGjMctbgSokMgvveKedDUiDEuKpjreJJGN5TluWMuhNWMj7cP4ZeWL
         WafQ==
X-Gm-Message-State: AOAM530aawMoZNJAXZHO7rpW/P+L8dgmgODDWZtvRU3bKoaQmWXBak0u
        cTdW0cD7H/kkhejODmDb3wQnDOyRLT8=
X-Google-Smtp-Source: ABdhPJwc83jEVUrsYqdet2/G/6Soma/d1TvTQMjyae5cRkkAfGcbkJMyoOVSLQRjigs4Bo6/5LNImQ==
X-Received: by 2002:a1c:29c4:: with SMTP id p187mr16901343wmp.73.1591628440198;
        Mon, 08 Jun 2020 08:00:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id n1sm10397wrp.10.2020.06.08.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 08:00:39 -0700 (PDT)
Date:   Mon, 8 Jun 2020 16:00:35 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Stop sparse from moaning at
 __hyp_this_cpu_ptr
Message-ID: <20200608150035.GB96714@google.com>
References: <20200608085731.1405854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608085731.1405854-1-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 09:57:31AM +0100, Marc Zyngier wrote:
> Sparse complains that __hyp_this_cpu_ptr() returns something
> that is flagged noderef and not in the correct address space
> (both being the result of the __percpu annotation).
> 
> Pretend that __hyp_this_cpu_ptr() knows what it is doing by
> forcefully casting the pointer with __kernel __force.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 0c9b5fc4ba0a..82691406d493 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -81,12 +81,17 @@ extern u32 __kvm_get_mdcr_el2(void);
>  
>  extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
>  
> -/* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
> +/*
> + * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
> + * provided that sym is really a *symbol* and not a pointer obtained from

Look at `this_cpu_ptr` one thing that stood out was `__verify_pcpu_ptr`
that is documented to be suitable for used in custom per CPU macros. I
didn't get how it worked (a type check?) but maybe it would work here
to validate the argment was indeed a per CPU symbol?

> + * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
> + * sparse quiet.
> + */
>  #define __hyp_this_cpu_ptr(sym)						\
>  	({								\
>  		void *__ptr = hyp_symbol_addr(sym);			\
>  		__ptr += read_sysreg(tpidr_el2);			\
> -		(typeof(&sym))__ptr;					\
> +		(typeof(sym) __kernel __force *)__ptr;			\
>  	 })
>  
>  #define __hyp_this_cpu_read(sym)					\
