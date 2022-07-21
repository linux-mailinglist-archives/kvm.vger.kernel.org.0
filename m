Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467D657D2F7
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiGUSEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUSEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:04:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACB08C582
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:04:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pc13so2288969pjb.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OgAJmm3Ep3wxfkpYOEOF9qseQqCbaLzwzuf8n7Ni2cs=;
        b=AK/Pd6lyH9yHIX8/NUcSoSfTOtHuGyf+OWPFuY5DS9DSBaqSy/C0mAp2D4VgZhq2R/
         rlBXVwa29pVgFypSS7/R4ATWc1h1ifXlst8WWedvjd3iqhRLz5JwxJfY0jfzRZ2vrLwv
         mHJww7kvjEILQ9nNENDZgMs5ubgh0dVtTU9TxyBMIvGrBWRgOC6b7MzFveISIVjBSKwL
         fBQ5MoxmzPkJEoQ8fHYu1F547N2Hc1aW5UZZ+G0UGAYI3Ot7qfgsaQT+dNYiVG59D6TX
         jWktjJiOzhZGNhE3nJiML5iE27oVsgSFS4ku2lgrSlax8wAD3AMHZ4SK0zA0IJvtPXKT
         SIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OgAJmm3Ep3wxfkpYOEOF9qseQqCbaLzwzuf8n7Ni2cs=;
        b=Ik5bhzrFYCRerwvX+Tn3bb84XzPr84PfLQWSAkHHTLCdmc5ypq+N9M3s/ujm3Cg/GG
         rInuJBg6OihnaiEGeTmauNjZ+LPn0uwndXFSZih5SZdqey25fRW5ENjxYQpBOj/PHYce
         H6ITAO91HKj8UsM39myFCnR07FBCDnpa9YcUa+H+0uqwA9jiVo1CQBlZFbGu26yCtoEo
         vcp7a37t3wbypT1fZhsbiikVyMLEP+tEBmtKuKm3jjtCwoNSlqClJ3egDQuHw0jRel5g
         qpDoR17Ska5ZcEyYxXVkVAwS5xtxp+1JQE2Sg/+UPORvKC4BQXcS58MzYCAY8MmzBVs/
         Y5ZQ==
X-Gm-Message-State: AJIora8lTEIOpS8+rAR/l16gw6RaWG/4JvV+Q7rS5P6bF0kPk/zs+vKH
        7Hse5WfiVUjNooMXuJ6OM+7GaQiTUrSr6A==
X-Google-Smtp-Source: AGRyM1tDWHIKIPtKPtUT1K/IJOLBSjoS46MKh129dDYvNzYv2SFNmGZyZjc1LVKrRi4QPZ4Js2TtiQ==
X-Received: by 2002:a17:902:f54e:b0:16c:5119:d4a8 with SMTP id h14-20020a170902f54e00b0016c5119d4a8mr43406849plf.22.1658426678106;
        Thu, 21 Jul 2022 11:04:38 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b0016c4fb6e0b2sm2077898plg.55.2022.07.21.11.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:04:37 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:04:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 1/8] x86: nSVM: Move common
 functionality of the main() to helper run_svm_tests
Message-ID: <YtmVMmp1aK+lEY6b@google.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
 <20220628113853.392569-2-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628113853.392569-2-manali.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022, Manali Shukla wrote:
> Move common functionalities of main() to run_svm_tests(), so that
> nNPT tests can be moved to their own file to make other test cases run
> without nNPT test cases fiddling with page table midway.
> 
> The quick and dirty approach would be to turn the current main()
> into a small helper, minus its call to __setup_vm() and call the
> helper function run_svm_tests() from main() function.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  x86/svm.c | 14 +++++++++-----
>  x86/svm.h |  1 +
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 93794fd..36ba05e 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -397,17 +397,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
>          }
>  }
>  
> -int main(int ac, char **av)
> +int run_svm_tests(int ac, char **av)
>  {
> -	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
> -	pteval_t opt_mask = 0;
>  	int i = 0;
>  
>  	ac--;
>  	av++;
>  
> -	__setup_vm(&opt_mask);
> -
>  	if (!this_cpu_has(X86_FEATURE_SVM)) {
>  		printf("SVM not available\n");
>  		return report_summary();
> @@ -444,3 +440,11 @@ int main(int ac, char **av)
>  
>  	return report_summary();
>  }
> +
> +int main(int ac, char **av)
> +{
> +    pteval_t opt_mask = 0;
> +
> +    __setup_vm(&opt_mask);
> +    return run_svm_tests(ac, av);

Indentation is wrong.  Yeah, the rest of the file has issues and this gets
cleaned up in future patches, but that's no excuse for introducing _new_ badness.

> +}
> diff --git a/x86/svm.h b/x86/svm.h
> index e93822b..123e64f 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -403,6 +403,7 @@ struct regs {
>  
>  typedef void (*test_guest_func)(struct svm_test *);
>  
> +int run_svm_tests(int ac, char **av);
>  u64 *npt_get_pte(u64 address);
>  u64 *npt_get_pde(u64 address);
>  u64 *npt_get_pdpe(void);
> -- 
> 2.30.2
> 
