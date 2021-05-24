Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3793838F4DC
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhEXVaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhEXVaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:30:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DBCC061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:28:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e15so8661789plh.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VXDvybtYbaA/WSLW3M8pJycbeN9ie3uJZCSoeU17yO4=;
        b=Hx86I9k1r8WTQK+7RJJk0K+XsWt7hzlR5DPrVnvIKljyxdcdE5s7KywgdkPD2TjNHP
         NsaIsTjhihIqOZzfzNWFCGN+ObVkGd+YFp+EmTYyeZdyg8f/bBCFXVJeFex2AI+1nAUB
         G6+jBqV7W559zXsGtv6drRKhO0Z4slsOVR269zhhiD/db3lNXcvNTwrYsRIs6CjwwGG+
         ZsJlkWnQwhSc5NthytXMjqeFSJC+eequ0ymGUt/5uvLExHHY500YBhMLSN23izR8XfT2
         NqenXszlsX+IqCB7dXPFZYO2Gdc6lQgbfsNCOTmfxizw2pVBuEOlLWgA+U4OJhNO5s8w
         /9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VXDvybtYbaA/WSLW3M8pJycbeN9ie3uJZCSoeU17yO4=;
        b=GAAX11EjtVCXhuJdWx6+2ypRjmvjhgraqjM28UZMBG9b4FA0qpoPeX+9g+rzd4OW4s
         b+bWO5W//tw0c/pSXmSG77VvRIJk56ek+o6HVzJ8jCoJ8GmuKucdVlazlo19m/rRXJez
         WrdldQEesGEziliA/j9M8MFP08dr9ZbUSLuy5dJSCmVZ616f7eBQ0hFOLZkyBJP1V6dF
         9ZTXJ5swhnXaSVOBhJqd2sDn1i65RWT9EF/0sCx49zeo52iD4j3dAmZ2C+hwAtiYsXfc
         YSufDsyqpOv8ZvZFIqHbmd00O8rMTK2CMMl9H8pAOt3hw90jKCxzOl+dbrUHjazy6RcG
         GP1w==
X-Gm-Message-State: AOAM531ciI3kJxnk2kinrOhW8P3yAzEdFvUYRDXInvQOOxwUU2HXtK5W
        aqF2OCZLb7Cg74TBjzj3H5uvFw==
X-Google-Smtp-Source: ABdhPJyzR3mTIylx9ARwP1rkzsp2Ez0vWPebx/QquQiBs8xEkHeD9LTpdqUHhqeZ+DXQqp/+HPJkCQ==
X-Received: by 2002:a17:902:b585:b029:f6:5cd5:f128 with SMTP id a5-20020a170902b585b02900f65cd5f128mr22731955pls.43.1621891716493;
        Mon, 24 May 2021 14:28:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y1sm12007937pfn.13.2021.05.24.14.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:28:35 -0700 (PDT)
Date:   Mon, 24 May 2021 21:28:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 5/7] kvm: x86: Revise CPUID.D.1.EBX for alignment rule
Message-ID: <YKwagHvhqiY1rrAI@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-6-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-6-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021, Jing Liu wrote:
> CPUID.0xD.1.EBX[1] is set if, when the compacted format of an XSAVE
> area is used, this extended state component located on the next
> 64-byte boundary following the preceding state component (otherwise,
> it is located immediately following the preceding state component).
> 
> AMX tileconfig and tiledata are the first to use 64B alignment.
> Revise the runtime cpuid modification for this rule.
> 
> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 04a73c395c71..ee1fac0a865e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -35,12 +35,17 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  {
>  	int feature_bit = 0;
>  	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> +	bool is_aligned = false;
>  
>  	xstate_bv &= XFEATURE_MASK_EXTEND;
>  	while (xstate_bv) {
>  		if (xstate_bv & 0x1) {
>  		        u32 eax, ebx, ecx, edx, offset;
>  		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
> +			/* ECX[2]: 64B alignment in compacted form */
> +			is_aligned = !!(ecx & 2);
> +			if (is_aligned && compacted)

I'd forego the local is_aligned, and also check "compacted" first so that the
uncompacted variant isn't required to evaluated ecx.

And the real reason I am responding... can you post this as a standalone patch?
I stumbled across the "aligned" flag when reading through the SDM for a completely
unrelated reason, and also discovered that the flag has been documented since
2016.  While AMX may be the first to "officially" utilize the alignment flag,
the flag itself is architectural and not strictly limited to AMX.

> +				ret = ALIGN(ret, 64);
>  			offset = compacted ? ret : ebx;
>  			ret = max(ret, offset + eax);
>  		}
> -- 
> 2.18.4
> 
