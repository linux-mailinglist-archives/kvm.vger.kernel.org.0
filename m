Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05C1C5CC1
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgEEP7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 11:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbgEEP7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 11:59:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4D1C061A0F
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 08:59:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z6so2944554wml.2
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PGN1A+sSuq/RZDk1hxq5pwV+/ZZ2rP8eCBzu/0i9JeE=;
        b=gkD+4b/HuVR1OV+wasxnOnWiiI7SPXpzXXV6NVB0/4aI4sxsX5dMVJHJSdOMD/GURm
         0qolj7BO2CfRRwNI14+BawRnPnhQFbnlUcP94ozWZKQZ1j+V70vzlvFOzNOzEr69a50h
         DB8zN1wrTSCem8xjw10+5voFbemDDzJBFhfQvssigfGPmr4ohNpwDBYQIdOM2SwI6T8a
         HLnlfx9P89ZU7KsSlT4it26YLSo+cIqmksGluTOY68GBTbihTzxie6CFZNiG0k3v9aPx
         K/LPKXjBg/4qPR7FGBucSgPN1l94dxQnIeL+ZTHRdPPaYpokD3D/8eXp7f61AvRYXn11
         zXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PGN1A+sSuq/RZDk1hxq5pwV+/ZZ2rP8eCBzu/0i9JeE=;
        b=sC/yH5jiDmjbkrG13mcbtsdHCI1VK+Wy7V0edkuGcCt0vfcGyRadBEKZFj/9HYzRM4
         tPsd1igbe2BRFHJhTpOV9UgNH9JAO8LxNUHvwkUa70ItRZSBvuVNDOU9st/RZ6wnFECH
         1YmK2hPiVyuO6BT+ZZmjvtm2evSc9dhncnBdTsEg9dj0vWATFG1fTM4pm8LHHdxkzEbC
         Vc9C501p3igOVcRTv6v/B8az61Jx80NdacudRYC+TDt7zLym1D19nG2LxlcF1uPOCOHn
         VSl2UxP4pQ+EScYtoHTKRNXoQz7niSvhiKCfz7X1uH0f8xDVG9/FZ7A3KGjm1OFMJ576
         Br6Q==
X-Gm-Message-State: AGi0PuZiQDEiT0Zz/Lo8tiFXS/z/xemZPL5uTsBWhmwWMgMohLkKLdRk
        TLoW0BelPkmcWYh1Cr6+MpjLMg==
X-Google-Smtp-Source: APiQypIRbnHubEaPb4xAueBVmUC4wFvaCgRRjttD5slQL+gt6ng+H5WZMUHVwb5dq420a0m0Cc4QGw==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4240013wmk.72.1588694361415;
        Tue, 05 May 2020 08:59:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id a12sm841990wro.68.2020.05.05.08.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:59:20 -0700 (PDT)
Date:   Tue, 5 May 2020 16:59:16 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in
 Stage-2 descriptors
Message-ID: <20200505155916.GB237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-6-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 01:00:29PM +0100, Marc Zyngier wrote:
> Advertise bits [58:55] as reserved for SW in the S2 descriptors.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 6bf5e650da788..7eab0d23cdb52 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -177,10 +177,12 @@
>  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
>  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
>  #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> +#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW */
>  
>  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
>  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>  #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> +#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW */
>  
>  #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
>  #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> -- 
> 2.26.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

This is consistent with "Attribute fields in stage 1 VMSAv8-64 Block and
Page descriptors"

Reviewed-by: Andrew Scull <ascull@google.com>
