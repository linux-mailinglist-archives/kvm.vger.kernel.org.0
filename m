Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959DD6F48F3
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 19:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbjEBRMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 13:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjEBRMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 13:12:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB816E5B
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 10:12:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51f10bda596so1824124a12.1
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 10:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683047556; x=1685639556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LQpsXa7PF6SfkNDRVYWe/pXw7LrZqwM+ndclXY8TsRA=;
        b=C43MRsCeJjlHRny0ujP2/WrWk7SuBq+T0iec7sTyuUJCtuy2gOVBMk6xF+njks3r8b
         iaHC8zvlhYdXVfFEIlS64AfFZlAUKc6V/+XV73g1rO1YWbs/QjNlnR8c8rbd9OZwbsav
         ucmm0mYAIA7SDeYN87XmItw5hU1/H8cwITnbs9dhYLmJvTRVsHacVPu4GfjyC0sriUS3
         Zmg0KEofgoQYlmUEer4zXwgoOD8bgHAGREE+tAkj2GsCjbCFvNxxyWSj1kYhtCl/kBhW
         mrH8bwK5YOTLcXEfFBmIjwOCnYPUI9AtmywcgEtYj7PQ79gI0bzLCRNxRbMZosi3SgXQ
         rO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047556; x=1685639556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQpsXa7PF6SfkNDRVYWe/pXw7LrZqwM+ndclXY8TsRA=;
        b=VNT5xN/oiBAJnTiv3QBrHk2vylJAvqnkKZM9pnSD+TwpdTOhf9lKs4drudAfGIm6Qx
         1mv3PY3kHR2H7TazuS+A2U8JNxb8pKRRgfZp/mTR6ZSgCwzOBCHSfLnT/Il2cn4uL4iU
         z+RBI/B0VaPmDDoKzzJjWRLzAD434VZZqtbBFsfVFV2scswBKt53E9WJqkR0/L7tKhR3
         z8jcjjAT/OrVynnuEUdzNEi/F62dUtYWeL9Oocu3ivxaT9BYbp9xmidNFaFDiwNwH08t
         LGzxM+eDi8guv0eWxmB1DTOoagkqCWFQPIQT/0trvWSIz2RU6cG3TMa0+JWCVTtiR5vP
         Kkiw==
X-Gm-Message-State: AC+VfDyrwRQuiY1kPeOe9j57F8P0LJX5Udz04NDLWfhMaiwVYxzTVkXI
        B9BmBbpFxCnEqAt4oTWYg+f4SAZBYlw=
X-Google-Smtp-Source: ACHHUZ6OGEbCDRyibiyEFmgXDoP74gBZmGkJmylBe5G97Pc5W9DviG/PDug9EqNO9adU8DJr2OhNI5d1W8M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8741:0:b0:513:e029:d172 with SMTP id
 i62-20020a638741000000b00513e029d172mr4555521pge.12.1683047556207; Tue, 02
 May 2023 10:12:36 -0700 (PDT)
Date:   Tue, 2 May 2023 10:12:34 -0700
In-Reply-To: <20230502112502.14859-1-yanjiewtw@gmail.com>
Mime-Version: 1.0
References: <20230502112502.14859-1-yanjiewtw@gmail.com>
Message-ID: <ZFFEgptZg1P367F7@google.com>
Subject: Re: [PATCH] docs: clarify KVM related kernel parameters' descriptions
From:   Sean Christopherson <seanjc@google.com>
To:     Yan-Jie Wang <yanjiewtw@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Avi Kivity <avi@redhat.com>,
        Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, trivial@kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 02, 2023, Yan-Jie Wang wrote:
> The descriptions of certain KVM related kernel parameters can be
> ambiguous and confusing. They state 'Disable ...,' which implies that
> setting them to 1 would disable the associated features or options,
> when in fact the opposite is true.
> 
> This commit addresses this issue by revising the descriptions of these
> parameters to make their intended behavior clear.

Less wrong perhaps, but IMO the actual behavior is still not captured, and from
a certain perspective the existing "Disable" verbiage better reflects how/when
most users would actually want to explicitly set a param.

Rather than commit one way or the other, what about reworking the descriptions
using this as a template?  E.g. state that the param controls something, state
the default and use that to communicate that 1==enabled, and then, when appropriate,
clarify that KVM disables (or in some cases ignores) params if hardware doesn't
support the related feature(s).

	kvm-intel.ept=	[KVM,Intel] Control KVM's use of Extended Page Tables,
			a.k.a. Two-Dimensional Page Tables.  Default is 1
			(enabled).  Disabled by KVM if hardware lacks support
			for EPT.

> 
> Signed-off-by: Yan-Jie Wang <yanjiewtw@gmail.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 9e5bab29685f..cc5abb3d54b9 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2552,10 +2552,10 @@
>  			on the ratio, such that a page is zapped after 1 hour on average.
>  
>  	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.

Eh, I don't see any reason to have this one say "allow" instead of "enable/disable".

> -			Default is 1 (enabled)
> +			Default is 1 (allow)
>  
> -	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
> -			for all guests.
> +	kvm-amd.npt=	[KVM,AMD] Enable nested paging (virtualized MMU)
> +			for all guests on capable AMD chips.
>  			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
>  
>  	kvm-arm.mode=
> @@ -2602,12 +2602,12 @@
>  			Format: <integer>
>  			Default: 5
>  
> -	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
> +	kvm-intel.ept=	[KVM,Intel] Enable extended page tables
>  			(virtualized MMU) support on capable Intel chips.
>  			Default is 1 (enabled)
>  
>  	kvm-intel.emulate_invalid_guest_state=
> -			[KVM,Intel] Disable emulation of invalid guest state.
> +			[KVM,Intel] Enable emulation of invalid guest state.
>  			Ignored if kvm-intel.enable_unrestricted_guest=1, as
>  			guest state is never invalid for unrestricted guests.
>  			This param doesn't apply to nested guests (L2), as KVM
> @@ -2615,7 +2615,7 @@
>  			Default is 1 (enabled)
>  
>  	kvm-intel.flexpriority=
> -			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
> +			[KVM,Intel] Enable FlexPriority feature (TPR shadow).
>  			Default is 1 (enabled)
>  
>  	kvm-intel.nested=
> @@ -2623,7 +2623,7 @@
>  			Default is 0 (disabled)

Heh, kvm-intel.nested has been enabled by default for quite some time.  Can you
fix that up too?

>  
>  	kvm-intel.unrestricted_guest=
> -			[KVM,Intel] Disable unrestricted guest feature
> +			[KVM,Intel] Enable unrestricted guest feature
>  			(virtualized real and unpaged mode) on capable
>  			Intel chips. Default is 1 (enabled)
>  
> @@ -2639,7 +2639,7 @@
>  
>  			Default is cond (do L1 cache flush in specific instances)
>  
> -	kvm-intel.vpid=	[KVM,Intel] Disable Virtual Processor Identification
> +	kvm-intel.vpid=	[KVM,Intel] Enable Virtual Processor Identification
>  			feature (tagged TLBs) on capable Intel chips.
>  			Default is 1 (enabled)
>  
> 
> base-commit: 865fdb08197e657c59e74a35fa32362b12397f58
> -- 
> 2.34.1
> 
