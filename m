Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFD2445CFD
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 01:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhKEAV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 20:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbhKEAVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 20:21:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2EEC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 17:18:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j9so6883803pgh.1
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 17:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RSaitoaJn+z/9FpIMqOLo4JYVyo2xROQhTktuioeT0w=;
        b=f68p2wrD/Akw4htV9D9gzQx5pbBRUwSAG9CuqPujyzjfbqP1sijm8s9I/izHZuL3hI
         fU3ixfl/GygrOqmfamt6tLNxeFCmxtIBq33zb6Ord39nxHQXJfg5yh7QhIYdyvz1w+ug
         Jp2DIWjPs7HM5VMKOibonO6O9eGVI68Q4MPE1T/MjNToRa3HuqxOM0bt8qz+gIFr23r+
         Glw50ezNnzTA7/brcwwzLzEXYjiX6YO9w7Wr6XVLbD7N1XLZLQ1uOo5kqDrlFRsvkRfk
         u572xwUmoOq/A/zoFsXNHF2JuPkVtcQOGxSip+c8nVnrW2aJcz4k84tjBXbEDSVqnGaJ
         lZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSaitoaJn+z/9FpIMqOLo4JYVyo2xROQhTktuioeT0w=;
        b=Nn5+kQEyPyyrHTb5LYj6IDMWFNwbR13UDo0VUOu8Vxo5V7u7CSW0JW+iUZ2VZ3zA8q
         COWOza4Puta1ba3DrqXiz5Hs1ISXH0FPfimjIikqPxUPYsjsieXJP1zaZLkHLqEbRxnd
         UPi1f6E8FfQDOAFUMANqsrahmkyW5jQ2szbAonOWc1C6TtrYGvtKfvDuhTdYy5XCNy6P
         ShKcUrWPK8SYB0vIxgTd6lggc/rQtXVQBEvpOtPWPhYuef/wMrkl5WeUKrl0WjYnus/r
         1AG+6yJ7xSfnD3rXWWRyqhHTs7UabTuwEwWOvOi/kjTsfbWRMun8apDW2GgBSd7QBBWM
         mqwA==
X-Gm-Message-State: AOAM532SJo4ZikYI5OUWs6P4mmoDFRCWSY0nAdViFRZmN5egLoN4+X2I
        X4qCdqvnaDiv/3WJjIEo/VImwg==
X-Google-Smtp-Source: ABdhPJwabVLpLrByQtkrHFiW9glRVLAuGoNeu8rnY2t+il8ww7HQQPlVfqIsrnaGpjPWHn+uIharAw==
X-Received: by 2002:a05:6a00:b85:b0:481:fc6:f100 with SMTP id g5-20020a056a000b8500b004810fc6f100mr32441146pfj.69.1636071524157;
        Thu, 04 Nov 2021 17:18:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p14sm4873208pjb.9.2021.11.04.17.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 17:18:43 -0700 (PDT)
Date:   Fri, 5 Nov 2021 00:18:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] kvm: x86: Convert return type of *is_valid_rdpmc_ecx()
 to bool
Message-ID: <YYR4X7oDXVClT7dx@google.com>
References: <20211104223246.443738-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104223246.443738-1-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: x86:

On Thu, Nov 04, 2021, Jim Mattson wrote:
> These function names sound like predicates, and they have siblings,
> *is_valid_msr(), which _are_ predicates. Moreover, there are comments
> that essentially warn that these functions behave unexpectedly.
> 
> Flip the polarity of the return values, so that they become
> predicates, and convert the boolean result to a success/failure code
> at the outer call site.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c1c4e2b05a63..d7def720227d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7328,7 +7328,9 @@ static void emulator_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
>  static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
>  			      u32 pmc)
>  {
> -	return kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc);
> +	if (kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc))
> +		return 0;
> +	return -EINVAL;


Heh, after seeing my off-the-cuff suggestion in a patch, I'd probably prefer the
more usual "return 0 at the end".  Either way is a-ok though, and waaaay better
than kvm_pmu_is_valid_rdpmc_ecx() returning '0' on success :-)

	if (!kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc))
		return -EINVAL;

	return 0;

>  }
>  
>  static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
> -- 
> 2.34.0.rc0.344.g81b53c2807-goog
> 
