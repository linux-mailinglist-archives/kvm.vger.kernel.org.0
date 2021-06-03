Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C033996C8
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 02:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCAL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 20:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCAL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 20:11:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3511BC06174A
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 17:09:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v12so1956234plo.10
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 17:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KgoxK5UQJ3kZ7ylqlhDO43tmp7163zUwhiNj0BfHXdQ=;
        b=NJtl5G//rP3VlOMT5/AFEAUnfv9Uyi1UWa0sdnuShpWWPYj7hThl3A0Vz8JsBQgUt7
         QsiHtcOCnjGSnwEO2LVKiD+xn95hln6GrpXiRTAZF5ThayB8rXu3IjJuIxnl9YoZR9Rz
         CvqH1ankaiVA1uYaIhJngocIc2UqqnPEBB8ehYLWItUYsv28e10FulqRAgQpuKdLfYyy
         d289zk5TmCWI7yoKek710LcDjWAgc6DBFGLAH4PrXsYRzip4oWSUogAQFP+oyN5meI0y
         NH2yho3fpT1wWHjgFAWE7abyoP8y6kCKYvXP2fbINSP8Dpd5OhLLuUKHYlcJcMQksWdJ
         s04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KgoxK5UQJ3kZ7ylqlhDO43tmp7163zUwhiNj0BfHXdQ=;
        b=AtHTRsI0Kc4CbwfX/YQcHIMkPXwTOIOTif+nilBGK8/dtkUJ37H9ELYnBdWo2YMOq/
         XSkb6hPlgz4VVkJlE/uycdAlkSseTnj61qVIr42dWJfNc5VKJfyNdCUtIvc9Uk0MZHEA
         bCPFmhD2W/Nm3a8EOXrPoIYBLlOEODOPnxsvOANPBf8q+NlnnFLU28dBdpgD4Ju1pLyZ
         VwmKQ/FUFuGQ10M+WzpIqvvZ1q8kxOXhvQouQ35bcInIKw+eXtwtqXD9kdu1rnlTm+dQ
         ckzp9p8/9VD2s0zivRkMf8rOZ0u+RA+DvFkLXdyZc62wnFdBTfKSTzlw5B/L4CGf0z19
         oaqQ==
X-Gm-Message-State: AOAM533Q4oqvcWfCy8KFpBFXtSbguihqGaHCVFiQBz6DRGmlBkl4u4TH
        fHrvYW/jdRWzFqEodQuI/fnhGPPnt7OzcA==
X-Google-Smtp-Source: ABdhPJzu2DlDCfQt2uy8zgwfsH5CDfV0mQIzsgP6mz5Kms+RtoW4iQr6dNVMBRs/dS7v3qmcWK1ZQw==
X-Received: by 2002:a17:90a:8c97:: with SMTP id b23mr33180951pjo.74.1622678970569;
        Wed, 02 Jun 2021 17:09:30 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id z185sm755360pgb.4.2021.06.02.17.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 17:09:30 -0700 (PDT)
Date:   Wed, 2 Jun 2021 17:09:26 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: selftests: get-reg-list: Remove
 get-reg-list-sve
Message-ID: <YLgdtgfrdr9ctQFW@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-5-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-5-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 12:33:43PM +0200, Andrew Jones wrote:
> Now that we can easily run the test for multiple vcpu configs, let's
> merge get-reg-list and get-reg-list-sve into just get-reg-list. We
> also add a final change to make it more possible to run multiple
> tests, which is to fork the test, rather than directly run it. That
> allows a test to fail, but subsequent tests can still run.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 -
>  tools/testing/selftests/kvm/Makefile          |  1 -
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |  3 --
>  .../selftests/kvm/aarch64/get-reg-list.c      | 31 +++++++++++++------
>  4 files changed, 21 insertions(+), 15 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 524c857a049c..dd36575b732a 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/get-reg-list
> -/aarch64/get-reg-list-sve
>  /aarch64/vgic_init
>  /s390x/memop
>  /s390x/resets
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index daaee1888b12..5c8f3725a7f0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -79,7 +79,6 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> -TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> deleted file mode 100644
> index efba76682b4b..000000000000
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#define REG_LIST_SVE
> -#include "get-reg-list.c"
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 03e041d97a18..b46b8a1fdc0c 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -27,16 +27,13 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
>  #include "kvm_util.h"
>  #include "test_util.h"
>  #include "processor.h"
>  
> -#ifdef REG_LIST_SVE
> -#define reg_list_sve() (true)
> -#else
> -#define reg_list_sve() (false)
> -#endif
> -
>  static struct kvm_reg_list *reg_list;
>  static __u64 *blessed_reg, blessed_n;
>  
> @@ -588,7 +585,8 @@ static struct vcpu_config *parse_config(const char *config)
>  int main(int ac, char **av)
>  {
>  	struct vcpu_config *c, *sel = NULL;
> -	int i;
> +	int i, ret = 0;
> +	pid_t pid;
>  
>  	for (i = 1; i < ac; ++i) {
>  		if (strcmp(av[i], "--core-reg-fixup") == 0)
> @@ -617,10 +615,22 @@ int main(int ac, char **av)
>  		c = vcpu_configs[i];
>  		if (sel && c != sel)
>  			continue;
> -		run_test(c);
> +
> +		pid = fork();
> +
> +		if (!pid) {
> +			run_test(c);
> +			exit(0);
> +		} else {
> +			int wstatus;
> +			pid_t wpid = wait(&wstatus);
> +			TEST_ASSERT(wpid == pid && WIFEXITED(wstatus), "wait: Unexpected return");
> +			if (WEXITSTATUS(wstatus) && WEXITSTATUS(wstatus) != KSFT_SKIP)
> +				ret = KSFT_FAIL;
> +		}
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> @@ -1026,6 +1036,7 @@ static struct vcpu_config sve_config = {
>  };
>  
>  static struct vcpu_config *vcpu_configs[] = {
> -	reg_list_sve() ? &sve_config : &vregs_config,
> +	&vregs_config,
> +	&sve_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
