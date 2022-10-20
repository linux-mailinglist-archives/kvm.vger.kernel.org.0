Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0CB60681B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJTSV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 14:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJTSV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 14:21:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711AF106E2C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:21:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c24so76378pls.9
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5XGjBdCf/8LFBdQcCN59KvxyIpL1ByzupgSnjZz9bg=;
        b=LvvbtoIxbssp4Dw2B1Mwk3i0tGgAnMay6dCF1Lb/LZIP11zKi1J1eExyxslJa7cn6h
         39UGosxy0JQ85sDpX63Toz/Kc0piVqlOckARuuSBy5raAZzR/nWLj+UhkEhDPRW9F2AR
         VQHaisJgfttwTTbPEnK4VaT6/w6Cv84FkRo+HLg8ivl/n063vIFaiXroT9lS+Z21S5BR
         E1oN27lHtgI2xKYpoyu/QkjUyTiJUnc2Z0r3zoN+tz3TJiYqB291Tj+7a8bbJ2gEx/mj
         VJwTNRxmKe628AuE5PpnryO9FdLtBLnKSmJR3ayoUU1CJ+ib1UBeB4VhJ9XQCK4RbHNc
         sUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5XGjBdCf/8LFBdQcCN59KvxyIpL1ByzupgSnjZz9bg=;
        b=by4RzD+4sQbqO3W+f1/OoZTTDLqpU57KYeWyPaOMZxhu23ErOYdeZqEvh2YZbQ7uKo
         hwRi0QJ0eX09ec5AZDYjVO02hayo2cOnshDf290th5CUo4dxlEPy5MM+hgYotyBull1K
         zzGdaHdLjW6Lx9IHf4Wk4kiPGUJTOKyCS+Xt6VajVWPljNtJ1IP8r1ea1DxCILTZEIai
         6iB+YLutmbAP1MiBIxyDj7raPrHqxkaYBe5NLnTh0yQK1mz4mrF1Bf9R/pqKfSiFlyya
         82wNzC6jiUiunfqyZbOAbQfBUuPO/r5xR4cy5xsfTndUqDDl4kC7rQvnf725Uiau0q81
         YAWQ==
X-Gm-Message-State: ACrzQf2RHQsNgMSGDZ+22P3vBc2N3UXIQcDzaZKEflrzfemPFzBI0YD0
        65N/p9IP3q3vdTRrRTOeea4QvgnQe7dGxA==
X-Google-Smtp-Source: AMsMyM4HVD0/uSnWyZqydXcfN/V23kb42o21O3xCIB2kkAbI8fnFVn5B57jXMxjtsklgoDDID3+j5g==
X-Received: by 2002:a17:902:ccd1:b0:186:5ee4:cf49 with SMTP id z17-20020a170902ccd100b001865ee4cf49mr6526959ple.26.1666290116845;
        Thu, 20 Oct 2022 11:21:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m3-20020a62a203000000b0053e38ac0ff4sm13588725pff.115.2022.10.20.11.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:21:56 -0700 (PDT)
Date:   Thu, 20 Oct 2022 18:21:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 11/16] svm: add svm_suported
Message-ID: <Y1GRwf071rJDqVbh@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-12-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-12-mlevitsk@redhat.com>
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

s/suported/supported

On Thu, Oct 20, 2022, Maxim Levitsky wrote:

Please provide a changelog.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.h | 5 +++++
>  x86/svm.c         | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> index 04910281..2d13b066 100644
> --- a/lib/x86/svm_lib.h
> +++ b/lib/x86/svm_lib.h
> @@ -4,6 +4,11 @@
>  #include <x86/svm.h>
>  #include "processor.h"
>  
> +static inline bool svm_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_SVM);

Why add a wrapper?  The only reason NPT and a few others have wrappers is to
play nice with svm_test's "bool (*supported)(void)" hook.

I would rather go the opposite direction and get rid of the wrappers, which IMO
only make it harder to understand what is being checked.

E.g. add a required_feature to the tests and use that for all X86_FEATURE_*
checks instead of adding wrappers.  And unless there's a supported helper I'm not
seeing, the .supported hook can go away entirely by adding a dedicated "smp_required"
flag.

We'd probaby want helper macros for SMP vs. non-SMP, e.g.

#define SVM_V1_TEST(name, feature, ...)
	{ #name, feature, false, ... }
#define SVM_SMP_V1_TEST(name, feature, ...)
	{ #name, feature, true, ... }

diff --git a/x86/svm.c b/x86/svm.c
index 7aa3ebd2..2a412c27 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -170,6 +170,7 @@ test_wanted(const char *name, char *filters[], int filter_count)
 
 int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 {
+       bool smp_supported = cpu_count() > 1;
        int i = 0;
 
        ac--;
@@ -187,7 +188,10 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
        for (; svm_tests[i].name != NULL; i++) {
                if (!test_wanted(svm_tests[i].name, av, ac))
                        continue;
-               if (svm_tests[i].supported && !svm_tests[i].supported())
+               if (svm_tests[i].required_feature &&
+                   !this_cpu_has(svm_tests[i].required_feature))
+                       continue;
+               if (svm_tests[i].smp_required && !smp_supported)
                        continue;
                if (svm_tests[i].v2 == NULL) {
                        if (svm_tests[i].on_vcpu) {
diff --git a/x86/svm.h b/x86/svm.h
index 0c40a086..632287ca 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -9,7 +9,8 @@
 
 struct svm_test {
        const char *name;
-       bool (*supported)(void);
+       u64 required_feature;
+       bool smp_required;
        void (*prepare)(struct svm_test *test);
        void (*prepare_gif_clear)(struct svm_test *test);
        void (*guest_func)(struct svm_test *test);
