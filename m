Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD6352EC0
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhDBRwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhDBRwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 13:52:41 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF3C0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 10:52:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t140so3960096pgb.13
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DR+GfHFVSClxnOoVDPPDqNtZjE1/6beeDXokMn5t0R4=;
        b=eDMX9ATqRzsEblZ5sNUjBcY6sgZlbvpjiQr8TJk4r0Pvfv3mY01L9PxtED+KfC1MLM
         Xo8w7xEZA4Ov0Ix+/HGt3TG26Cvec+VQVez2VM1/oCPHTYJJLWUH//4h+Ishg6frjNe4
         cCrTwCbrHMCnZChDMlQ1wKcNVF4LbP0HE3kqEDvvcOkKBiSeSgVNaTmN2DwCBeGcu7Sv
         WnkOl7ts+pjVZlCTKEuEqhrZtyXe7D7qapvIf00SwsqGKielhzHJE+4iSnTSUTtu7j8j
         egrecgOTqT/kWMkM5PjsKpDFkredxIjoJ3TdKyIYlJ4bK5/fG2IGTlYDIbWXrs9HM5CZ
         zLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DR+GfHFVSClxnOoVDPPDqNtZjE1/6beeDXokMn5t0R4=;
        b=qW+W/rwIAsLTSVDNbShYepFK9FMI8UhUlu8PlxbtxYtpS9hqPLmp6x9ykwcjz7UUbq
         HewX++9q7/0nj8GJzyNGAaqb4C8UE6nC+JsAS7JiC8nOvjambc/V/xbc/k5Sz6v5Wu8j
         DXHtFf8sfsvcWraCmW6L/z1Wbrc+rxHEzEX4SGvDiGxXPPJjbNzSMXgD51u+aO/cqcA+
         mo8+Cy6/tlXckBGRa7gumkk2hL8Y2Xo/4Ls4O0udfajXR7uvAhUFHPbnr4k/gtFkgrvI
         IurJUC3WbH8M9+YT4ZRlDF+S1+VoaLMjRO8LRRoNQBQGULVflARPi7bPkhtUNUj8w0Zo
         Sm4g==
X-Gm-Message-State: AOAM530cX4BZ7maiaPIs+1v8s4wThJir57J1FlCCW30Jml18PjWY1GSw
        m+qU4Co2rCmFZ9RZYwRBLdN0PQ==
X-Google-Smtp-Source: ABdhPJygyQ1u+E9ey5N36tVyUJtT67Ic8DnQwOrdXzGKUreyjMgGQQWTYX4IjjPurepj2r1bKOjZgg==
X-Received: by 2002:a62:5e05:0:b029:20b:241e:4e18 with SMTP id s5-20020a625e050000b029020b241e4e18mr13179003pfb.1.1617385959703;
        Fri, 02 Apr 2021 10:52:39 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k10sm8756233pfk.205.2021.04.02.10.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 10:52:39 -0700 (PDT)
Date:   Fri, 2 Apr 2021 17:52:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/5 v6] KVM: SVM: Define actual size of IOPM and MSRPM
 tables
Message-ID: <YGdZ454tDZToq2pk@google.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
 <20210402004331.91658-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402004331.91658-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Krish Sadhukhan wrote:
> Define the actual size of the IOPM and MSRPM tables so that the actual size
> can be used when initializing them and when checking the consistency of the
> physical addresses. These #defines are placed in svm.h so that they can be
> shared.
>  static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..d0a4d7ce8445 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -28,6 +28,9 @@ static const u32 host_save_user_msrs[] = {
>  };
>  #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
>  
> +#define IOPM_ALLOC_SIZE PAGE_SIZE * 3
> +#define MSRPM_ALLOC_SIZE PAGE_SIZE * 2

Drop the "ALLOC", this is the architectural size, not the size that's allocated.

It'd also be nice to align the values.  My personal preference would be to have
the number of pages come first, i.e. "3 pages" versus "4096 3-byte chunks", but
that's definitely getting deep into nitpick territory. :-)

#define IOPM_ALLOC_SIZE  3 * PAGE_SIZE
#define MSRPM_ALLOC_SIZE 2 * PAGE_SIZE
> +
>  #define MAX_DIRECT_ACCESS_MSRS	18
>  #define MSRPM_OFFSETS	16
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> -- 
> 2.27.0
> 
