Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6E57D3E4
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 21:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGUTOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 15:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiGUTOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 15:14:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF348D5CE
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 12:13:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bh13so2511404pgb.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 12:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hpGVvp6V4ValnColSEYpsn7H5kyl9gR6Fj7m3GaWAHs=;
        b=e9QegT5BvitZywxr21cHJ+lsn6QYPuoG59t9W0COuw7IdcZueltTP1xyl9dgiKGmnq
         vHMHOvfX+swecJoxHQ8ReF4jt6eZqVa/aZB5Pw/YFvu2Z8JtgMCV9lNGRl68bsc1s8QO
         Bny7hrO03FyuHpq79/lEXQpjw5leIhJzFk1U+6KhA3UXFBDYg6xCTYnnrJPCU9hTmmJd
         Ca7Y1C7aICgdzuvX5p8+vfKzFRvfAroYgjnrXPIWg1pD7WBPgSf3gUPAmlg7zbdez+m4
         c1AzqMir2Q49N4f//CiTlAbgJlOoNPC4Pb2u7tyeTS2rxHqxnfItd9hSct7WW4nv1b+/
         6mQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hpGVvp6V4ValnColSEYpsn7H5kyl9gR6Fj7m3GaWAHs=;
        b=0ih/xOND5yo7sqb0qv+8bcafJEBLuemuA0tiJLM0TdO/aP41H01JhpMUO0koYaa76B
         kmKNISScaF5SDweDtyU60Iuv/5DayhK4C4PItGkMf4pwkbfpeZzjYaSnSYvGXakjCFtu
         KnRVnwGQkWEbItKQajr7e3S0dDLqH+rBfFLdOwMDICH6ObM/Sft0MiEaAO/Ji3h+dC0w
         Jr16PHDn15IkRIvD2WRdXnEg+OBPpWTPTUgOJW1LIXkvRgEatNx5Z5Ij+CFb3RtfLb23
         fsR9NyrXdBFvV142ghX6KtAq95r9NxKIZDCcrIN5rKjb+kvAqXAn09zmgHevAFyRAFTd
         AMGQ==
X-Gm-Message-State: AJIora8Vp6EIYIdv7WoHABTmZtc4qu7/7h1ToS1NvFmVVcHiCr1Oo+xI
        5BF9NhgOvlgFOPOLlB1c+DDpfg==
X-Google-Smtp-Source: AGRyM1tYtKm9K+5L1ARwzbxmuuU47Y1QPIKX+TBp/hDZswBqd1pFmZzMLQ/6LdmoogYxIPMxvdVC9w==
X-Received: by 2002:a05:6a00:1705:b0:525:4cac:fa65 with SMTP id h5-20020a056a00170500b005254cacfa65mr45038052pfc.40.1658430832057;
        Thu, 21 Jul 2022 12:13:52 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090341c400b0016d23e941f2sm2077550ple.258.2022.07.21.12.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 12:13:51 -0700 (PDT)
Date:   Thu, 21 Jul 2022 19:13:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 1/8] x86: nSVM: Move common
 functionality of the main() to helper run_svm_tests
Message-ID: <Ytmla6Qvo+7pnNnq@google.com>
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

Pass in the test array instead of using a global svm_tests that needs to be defined
in each file, which is gross and confusing.

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
