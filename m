Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A622416B18
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 06:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244075AbhIXE6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 00:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhIXE6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 00:58:35 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304E4C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 21:57:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j15so4233973plh.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 21:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FhfKAFl2Cp1pTCS3Bb7r2rs05iyLq60w24OU87R4Csg=;
        b=bbEeGZPt3coXPplXqb8SuClleUlX0a7cl3dbYTNip5d6pqAoYm1oYNWZbUOaPBcwYb
         yZEmyVeuAfmB5G9IETW9PA4ZW6h0nZ/r994LOMy8xNt3YAZKlpNYfIJ5ajqz9QeluFD+
         8Uaj++sxQj+LGgkPrdeUzCFqgWHG7/D4pPkbbqi87kCEYdsHObsmjj4RRXj19w7EYHHK
         s03nXugTkRvv+D8uUg03I0R3V2dOi8kQmw6tJWPQg8H0WtYM6aeeD18fVagBC7Mt9575
         OQYDNpYUdSbsAjcGpWSB0e6FadlHw4S/6XXCHCjd1dvsBC+LJT0ymfB/n8dWOrlP1N6g
         rCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FhfKAFl2Cp1pTCS3Bb7r2rs05iyLq60w24OU87R4Csg=;
        b=i+apV82j4oo4xSS5UiPSUVNbpobX1sPl+eXBceBv927qN6rq8sKMIjg9Yt6ovPxEd3
         +OycUbnioWNQeExQ6XZNr8pdu0TBC9bkON5Sh+nEfD4HFWxQTUb1KfOOhaMRVSj93ZvS
         uI/RolQCDFSDHGq35jmW0jkYxJD5BEjUpxZ1zOr/XBN3g46yNEl3LI4cItTQBEDFkdvj
         Z6tSVK/TU8DIDreGVQol0oNlp/k905fbDTPemKDhrTYhGw6occykfloIJlFgQs5Yyqnk
         n1gf90gQRyZMv5UpYFjROHjZyT3YgAT739PVEv5p92qzJR/DIobIYMCaKxcjg2y8MdL7
         DNNw==
X-Gm-Message-State: AOAM532RCRbXDfm039EsVK9Iofp3kDxzpghkQ7xpT5hw+xg2EgbNKmuv
        SP00J6JOYkBCziiQq7nbXv2PpgA54aHWGA==
X-Google-Smtp-Source: ABdhPJwliW/McnlmoE86OiLuWS+q9W9E1nRDSDE0qTX/YPeWCAFO/1nGnMNEEKep9JVlczSPs+dqhw==
X-Received: by 2002:a17:903:1d1:b0:13c:897c:c04b with SMTP id e17-20020a17090301d100b0013c897cc04bmr7112736plh.76.1632459422468;
        Thu, 23 Sep 2021 21:57:02 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id c16sm7076206pfo.163.2021.09.23.21.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 21:57:01 -0700 (PDT)
Date:   Thu, 23 Sep 2021 21:56:58 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] selftests: KVM: Explicitly use movq to read xmm registers
Message-ID: <YU1amie6LL/5JY8w@google.com>
References: <20210924005147.1122357-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924005147.1122357-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 12:51:47AM +0000, Oliver Upton wrote:
> Compiling the KVM selftests with clang emits the following warning:
> 
> >> include/x86_64/processor.h:297:25: error: variable 'xmm0' is uninitialized when used here [-Werror,-Wuninitialized]
> >>                return (unsigned long)xmm0;
> 
> where xmm0 is accessed via an uninitialized register variable.
> 
> Indeed, this is a misuse of register variables, which really should only
> be used for specifying register constraints on variables passed to
> inline assembly. Rather than attempting to read xmm registers via
> register variables, just explicitly perform the movq from the desired
> xmm register.
> 
> Fixes: 783e9e51266e ("kvm: selftests: add API testing infrastructure")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 34 +++++++++----------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 242ae8e09a65..eba8bd08293e 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -312,37 +312,37 @@ static inline void set_xmm(int n, unsigned long val)
>  	}
>  }
>  
> -typedef unsigned long v1di __attribute__ ((vector_size (8)));
> +#define GET_XMM(__xmm)							\
> +({									\
> +	unsigned long __val;						\
> +	asm volatile("movq %%"#__xmm", %0" : "=r"(__val) : : #__xmm);	\
> +	__val;								\
> +})
> +
>  static inline unsigned long get_xmm(int n)
>  {
>  	assert(n >= 0 && n <= 7);
>  
> -	register v1di xmm0 __asm__("%xmm0");
> -	register v1di xmm1 __asm__("%xmm1");
> -	register v1di xmm2 __asm__("%xmm2");
> -	register v1di xmm3 __asm__("%xmm3");
> -	register v1di xmm4 __asm__("%xmm4");
> -	register v1di xmm5 __asm__("%xmm5");
> -	register v1di xmm6 __asm__("%xmm6");
> -	register v1di xmm7 __asm__("%xmm7");
>  	switch (n) {
>  	case 0:
> -		return (unsigned long)xmm0;
> +		return GET_XMM(xmm0);
>  	case 1:
> -		return (unsigned long)xmm1;
> +		return GET_XMM(xmm1);
>  	case 2:
> -		return (unsigned long)xmm2;
> +		return GET_XMM(xmm2);
>  	case 3:
> -		return (unsigned long)xmm3;
> +		return GET_XMM(xmm3);
>  	case 4:
> -		return (unsigned long)xmm4;
> +		return GET_XMM(xmm4);
>  	case 5:
> -		return (unsigned long)xmm5;
> +		return GET_XMM(xmm5);
>  	case 6:
> -		return (unsigned long)xmm6;
> +		return GET_XMM(xmm6);
>  	case 7:
> -		return (unsigned long)xmm7;
> +		return GET_XMM(xmm7);
>  	}
> +
> +	/* never reached */
>  	return 0;
>  }
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>
