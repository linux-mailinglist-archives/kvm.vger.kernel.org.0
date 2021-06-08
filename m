Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D4639FCB5
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhFHQnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhFHQnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 12:43:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6FFC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 09:41:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h16so12262768pjv.2
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 09:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b/MZpiR66ewTSim1WwCgmLNKDwnWD3pufYpqwYfLPKU=;
        b=eppItGX1DgZiHMFm/WaH4b6ozdA44efGectWI1T2JKxSAAS0Osf16y7A2zCxg4TQBg
         K9YrCHhg6ZQuXCXLl+5ZWKAIJ4uWKQKGATy79/XnCMTwppi1cXc8Z/R9UUKJhLR4k4mm
         7V7ULWc/F2ufJoOGyi1vMLbpWgQZ985RF//a5Bi1Cd21z3jyKj9VjnjMmTblL0dXsQw5
         sWnQ8Sd+kvZCBiuDQPwB9heuWIc3dM4BH3XfdhVugKP8YyV0zxwOHvRT14pieUjJasps
         m05wg7SkpadjM8e5a4CDBQEFETfiSA8B855xkvVGqH0qzJ8D4X9wKcy4GkztAs3MPicV
         SY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/MZpiR66ewTSim1WwCgmLNKDwnWD3pufYpqwYfLPKU=;
        b=l206PDioOY0E11za2hICrN9Mvol3TodiQ1Bl1gcczwnTDysQ22r2VcAPUx2l6+dDpT
         j33rTCD16bWuTN+nF1wDfj0lx1wt2/V0Ff7fWRg2f5s+0l233YUxD/WjUuoHSzyhCze4
         OT0TiZajqV1RWvWzmFjiP7vcnfuIV1GTn1F0DZC/SzzLLvM3PLjzp8JjNnjUebWDWz7V
         yebfxlzAEBRSVfaaklZmQzQ/zcqdS6TSkxAsWjLtTK1riQmOqwt0wn5ozMESSF4eugfa
         yJQV/OBuIFK6MIqdjZNPtdLUPRnxwE8WmNbMClTecsUEc83E3FnU0ACNZML9tpY1L0MB
         vRyw==
X-Gm-Message-State: AOAM532ZY/yoQzbCxM+KNe50A62IYLk5n4Lq1ppSRxULizrTZqwWXHFu
        n6svyFvDB5yyQJCbSxyot17ivQ==
X-Google-Smtp-Source: ABdhPJyLX/erWPaMyVyNgXSpSeNvJjb8Ds8CeGzeCnkGsW/Qodl00uQSPBRqaRwMmuoqc4szSEv3FA==
X-Received: by 2002:a17:902:d88e:b029:10e:601e:d779 with SMTP id b14-20020a170902d88eb029010e601ed779mr853444plz.82.1623170500557;
        Tue, 08 Jun 2021 09:41:40 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id b20sm14218333pjh.11.2021.06.08.09.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 09:41:39 -0700 (PDT)
Date:   Tue, 8 Jun 2021 16:41:36 +0000
From:   David Matlack <dmatlack@google.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, drjones@redhat.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, peterx@redhat.com,
        venkateshs@chromium.org
Subject: Re: [PATCH v2] KVM: selftests: introduce P47V64 for s390x
Message-ID: <YL+dwGhYheOiliZG@google.com>
References: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
 <20210608123954.10991-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608123954.10991-1-borntraeger@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 02:39:54PM +0200, Christian Borntraeger wrote:
> s390x can have up to 47bits of physical guest and 64bits of virtual
> address  bits. Add a new address mode to avoid errors of testcases
> going beyond 47bits.

Thanks for the fix. My apologies for breaking s390.

The patch "KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()"
has already been added to stable so you may want to add the following:

Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Cc: stable@vger.kernel.org

> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
> v1->v2:
> - remove wrong comment
> - use 5 levels of page tables
>  tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..b602552b1ed0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -43,6 +43,7 @@ enum vm_guest_mode {
>  	VM_MODE_P40V48_4K,
>  	VM_MODE_P40V48_64K,
>  	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> +	VM_MODE_P47V64_4K,
>  	NUM_VM_MODES,
>  };
>  
> @@ -60,7 +61,7 @@ enum vm_guest_mode {
>  
>  #elif defined(__s390x__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
> +#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 16)
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 28e528c19d28..b126fab6c4e1 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -175,6 +175,7 @@ const char *vm_guest_mode_string(uint32_t i)
>  		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
>  		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
>  		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
> +		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
>  	};
>  	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
>  		       "Missing new mode strings?");
> @@ -192,6 +193,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  	{ 40, 48,  0x1000, 12 },
>  	{ 40, 48, 0x10000, 16 },
>  	{  0,  0,  0x1000, 12 },
> +	{ 47, 64,  0x1000, 12 },
>  };
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
> @@ -277,6 +279,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
>  #endif
>  		break;
> +	case VM_MODE_P47V64_4K:
> +		vm->pgtable_levels = 5;
> +		break;
>  	default:
>  		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
>  	}
> -- 
> 2.31.1
> 
