Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0290A38F4FD
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhEXVfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhEXVfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:35:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635BBC061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:34:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ot16so13693823pjb.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bK50K0ZuzWopvsRPDO/W9edrVLo3uYNgj7H36Mg20zU=;
        b=rLfM8Es5WWlEOUqQlzKFMrBsWdFS+YBM0GERCq4zR4U0U8d0oa3zPx8ltLXnFCF+M9
         1HgkeNANlCEAbjeUebYF853F9yCjUr7ldIbCtq3bTF2gJBUjUwnierbTlYzb1gKf7iZz
         W0XzH189RCcLJRRFG6fyC1zKpSnFrCK1gKbXmaO0LHgCNWXHDe+44nmbmHuswCiNfvVr
         6x7NQsEQfOygXQZuouwO2ECAPnnzCpF1yUNKvEfx/fxuLRRMy5ihCHZ58qTBaMC8D/co
         A5tBrYjvyVf0SJSj03RZ3qRgxSVcUthKaI6tfEXcJRiK9nhHTMfNVG1uezekObJZ+rjV
         O2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bK50K0ZuzWopvsRPDO/W9edrVLo3uYNgj7H36Mg20zU=;
        b=LTxzRwHWruBmXll0WmJzMGVTt4eGAYjmBYtfdvYvqOL61gu2Sy5xCpos9e3XZLTb9I
         ycG5De6WdH9Gvf5s+0bpeY89mFmtv0feItzOve3Yp+9WEjwCRgyyVmd9+aH22daa1KX5
         tiMguXhf2xTuKwvM/Q6JEzb6v5Kg6MdmI58Mdc/nQaPcTdDK8c+KvWr77IsmliVEP97r
         rMCr3Ho9P2LgzxiAxd5oqu0/cAG9GwPqNBOpRJCo3II/eLlpwkz87Jw3hHhCb6pwpTQ8
         uEUqEcT79eqWrC5OC+QOvV2AytgzmOo1GB6OOe88MERjZuDFq/sM+OGFJQFipBEtJrAE
         bGtQ==
X-Gm-Message-State: AOAM5334DnLoABn7NywSwvEkTnRFUv6jKbvt6Vbb4X+9Wiq9d2BMS4Ts
        mRYBOBJh+W48A0Hv4t0UL/JyHg==
X-Google-Smtp-Source: ABdhPJwR+sUklgjM5cKeSrUw8qvy5Zyr+dYz/5Xqsq3ODHfVzoA+/YiYBtJlsvLZXr8k4NBtHWMRzw==
X-Received: by 2002:a17:90a:6402:: with SMTP id g2mr26855568pjj.82.1621892051796;
        Mon, 24 May 2021 14:34:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h1sm11585614pfh.72.2021.05.24.14.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:34:11 -0700 (PDT)
Date:   Mon, 24 May 2021 21:34:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 1/7] kvm: x86: Expose XFD CPUID to guest
Message-ID: <YKwbz3zuPhR7u1dw@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-2-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-2-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I need a formletter for these...

GET_SUPPORTED_CPUID advertises support to userspace, it does not expose anything
to the guest.

On Sun, Feb 07, 2021, Jing Liu wrote:
> Intel's Extended Feature Disable (XFD) feature is an extension
> to the XSAVE feature that allows an operating system to enable
> a feature while preventing specific user threads from using
> the feature. A processor that supports XFD enumerates
> CPUID.(EAX=0DH,ECX=1):EAX[4] as 1.
> 
> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 83637a2ff605..04a73c395c71 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -437,7 +437,7 @@ void kvm_set_cpu_caps(void)
>  	);
>  
>  	kvm_cpu_cap_mask(CPUID_D_1_EAX,
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | F(XFD)

KVM must not advertise support until it actually has said support, i.e. this
patch needs to go at the end of the series.

Also, adding the kvm_cpu_cap flag in a separate patch isn't strictly required.
In most cases, I would go so far as to say that if there is additional enabling
to be done, advertising the feature should be done in the same patch that adds
the last bits of enabling.  Putting the CPUID stuff in its own patch doesn't
usually add values, e.g. if there's a bug in the actual support code bisecting
will point at the wrong patch if userspace conditions its vCPU model on
GET_SUPPORTED_CPUID.

>  	);
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> -- 
> 2.18.4
> 
