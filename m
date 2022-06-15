Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1274254D57D
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348243AbiFOXr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiFOXr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:47:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0F61E3EA
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:47:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a10so899pju.3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cD+e2nDASdNRyN/xmx8OX4wkHlHRc9188ES1iEv2Jmw=;
        b=EM1Unq4KE6Ml2VF+r8hIIxXg9AexXWAaF0e9661J4D6x50HEzaIONRFz57x3v2tKtm
         8QBHCNJXxPX6YLQbRPY/tkavroOx0nCNL6IQremDm0cRotahSoyh6VX9tPZWEb9/+aTT
         6R0SDOg+F7mOfTbIvsZ8aSLmcyEFPbED9t+PugTY5RWKsYqNbpwRDcLxNcihY+UThrYj
         7uuLodrdQFCqOB/+MZBIPWGG69K+DkXQbRp2BJLb0KMlbgeQvxUaySIoMffBt0haO70Y
         WDZxFrqJtj8eNPHNEM77yIdkWrsm3CDggDgpPu0Ch/TCWMKGkDPwNSdawdMlVrEf+Ior
         Cmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cD+e2nDASdNRyN/xmx8OX4wkHlHRc9188ES1iEv2Jmw=;
        b=5S9BUdKJWOeQja1aR2hJy+sWDNtNhlufdD3fCNrLI898SuRt4UYcbZZkUR8QmKl8kB
         vZaoahWJ3HOsZvblyxcXYqO1Txc72cuQ0SG7kjBvRCCTHu3woFEqF8e6yY9YhKYIvWDF
         Y0dAy70UqpI08TCnmqxKcTUgKSROi390F5egkjzdkeVE2+bvn+GQIwJX2bUFDoQPyMtb
         pR3Ff2v5+Hx3qzaUDw4k9PqmmEJQkFmj2QyhlYrIno3kZYuv/m7kF1RzLnHFCcc0e1Yv
         W5zx4r5eSVI1Eb0//7M2hdrLtYsdNK3EwUbWfV7L2mrnRzOtAFu1VGS3qDClOc2l2G4J
         LhYA==
X-Gm-Message-State: AJIora9dQzLdxg+t6SbKWUn3aknyRX/eYWKWg7WrijbGfFcLfoA1uT3b
        0R+v50kC1iPa0PsmsG24uhmMug==
X-Google-Smtp-Source: AGRyM1uLM4UYSJmVCFGm+7cCG4tpq5+SrE3U6adkra+XwdBD9Jj9Nv7UsJ5EJ5w2GLKrPLfKTVGOrw==
X-Received: by 2002:a17:903:3296:b0:164:13db:509 with SMTP id jh22-20020a170903329600b0016413db0509mr1735331plb.128.1655336876470;
        Wed, 15 Jun 2022 16:47:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id cf6-20020a17090aebc600b001e2da6766ecsm2395664pjb.31.2022.06.15.16.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:47:56 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:47:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 3/8] x86: nSVM: Allow nSVM tests run
 with PT_USER_MASK enabled
Message-ID: <YqpvqEzEVfNvncwe@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-4-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428070851.21985-4-manali.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022, Manali Shukla wrote:
> Commit 916635a813e975600335c6c47250881b7a328971
> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> clears PT_USER_MASK for all svm testcases. Any tests that requires
> usermode access will fail after this commit.
> 
> Above mentioned commit did changes in main() due to which other
> nSVM tests became "incompatible" with usermode
> 
> Solution to this problem would be to set PT_USER_MASK on all PTEs.
> So that KUT will build other tests with PT_USER_MASK set on
> all PTEs.

Similar to the previous changelog, state what the patch does.  After reading all
of that, someone who doesn't already know what's going on might not understand
the change.

  Now that nNPT testcases, which need to run without USER page tables,
  live in their own test, use the default setup_vm() to create the page
  tables with the USER bit set so that usermode testcases can be added
  in the future.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  x86/svm_tests.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index f0eeb1d..3b3b990 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -10,7 +10,6 @@
>  #include "isr.h"
>  #include "apic.h"
>  #include "delay.h"
> -#include "vmalloc.h"
>  
>  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
>  
> @@ -3297,9 +3296,7 @@ static void svm_intr_intercept_mix_smi(void)
>  
>  int main(int ac, char **av)
>  {
> -    pteval_t opt_mask = 0;
> -
> -    __setup_vm(&opt_mask);
> +    setup_vm();
>      return run_svm_tests(ac, av);
>  }
>  
> -- 
> 2.30.2
> 
