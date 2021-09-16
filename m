Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9381C40D4BC
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhIPImd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233681AbhIPIma (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 04:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631781670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t8cpB7LEQnEml3YwGjWnOEASbAxhpE1soFuJ3YTSDPI=;
        b=LvGpPI2LSEimKFAeddjUn8LGxqEJen2lBLtQjrafpTL6xiQFjArw2wnccAMsc/cw82Nlw8
        eBpbmKAEsS5/dJxnGXoG4guSBH7ct8LEe9UQMSS4Dv8TGe6MM3dxDh1/RRlrvLl/fCnyLg
        WNh/0APGcWSop00glfpJmHNlBZ5udnk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-vB0GhirxOCuPRR5l2EFIUQ-1; Thu, 16 Sep 2021 04:41:09 -0400
X-MC-Unique: vB0GhirxOCuPRR5l2EFIUQ-1
Received: by mail-ed1-f69.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so4660642edb.3
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8cpB7LEQnEml3YwGjWnOEASbAxhpE1soFuJ3YTSDPI=;
        b=C5CPaJVxkpC5FMNbInbXjpEDoV+Pv9b8MCPEg9p+6V6eSmUFG0YEatwy1R0u+SnO/l
         5ht/xRQmV0o8Ov/FS1wA6RRZn7Q5+f5CfIfTMMvJE+0pGP5rXIdIg1qNG7zh/v3BxPVE
         NtCwHK8+49D7w1zbqCscm/jvw9pNSH8Htljr2Q1r7rFQng5Ho9NEXpUEInNmmvkTHeDr
         KLpNJCzubo7iDfSoCw8iy2buNdegyAozuGWQhmtrTQFZL33yP1gNl+Y2yDAzeYOQzv9c
         5G9LxXvD2Rra9FHLRyToxkRjLdkamocnFX7PYesnZZKJ7OUDMlbTGQK8OfVpCH2uY0Y6
         wFZA==
X-Gm-Message-State: AOAM530qn4qjItR7Pz2g/rjzGfbP/E0FDwh2wB4HrHusxF+urQ8X1nVK
        fAo46mcK89ed670nsbpGjg9m1972QhTbiSmyAvDroaoMtKOxWBhtKou+zT4Q2h0JsRjcWuccSEv
        JiAd1IY/w2QrV
X-Received: by 2002:a17:906:6547:: with SMTP id u7mr4924313ejn.544.1631781667898;
        Thu, 16 Sep 2021 01:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7u3GSYekO1CItCUDPs4M34SKGJSXHQpM/mQxpZYQPgkDyUCZkS6qJH02kMi+VNgOeSfmTpw==
X-Received: by 2002:a17:906:6547:: with SMTP id u7mr4924299ejn.544.1631781667615;
        Thu, 16 Sep 2021 01:41:07 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id y8sm920008ejm.104.2021.09.16.01.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:41:07 -0700 (PDT)
Date:   Thu, 16 Sep 2021 10:41:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Refactor help message for -s
 backing_src
Message-ID: <20210916084105.cydzodlkhtdoq3cb@gator.home>
References: <20210915213034.1613552-1-dmatlack@google.com>
 <20210915213034.1613552-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915213034.1613552-3-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 09:30:33PM +0000, David Matlack wrote:
> All selftests that support the backing_src option were printing their
> own description of the flag and then calling backing_src_help() to dump
> the list of available backing sources. Consolidate the flag printing in
> backing_src_help() to align indentation, reduce duplicated strings, and
> improve consistency across tests.
> 
> Note: Passing "-s" to backing_src_help is unnecessary since every test
> uses the same flag. However I decided to keep it for code readability
> at the call sites.

I think I'd prefer not passing "-s", but I won't insist.

> 
> While here this opportunistically fixes the incorrectly interleaved
> printing -x help message and list of backing source types in
> dirty_log_perf_test.
> 
> Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/access_tracking_perf_test.c   |  6 ++----
>  .../testing/selftests/kvm/demand_paging_test.c  |  5 ++---
>  .../testing/selftests/kvm/dirty_log_perf_test.c |  8 +++-----
>  tools/testing/selftests/kvm/include/test_util.h |  5 ++++-
>  .../testing/selftests/kvm/kvm_page_table_test.c |  7 ++-----
>  tools/testing/selftests/kvm/lib/test_util.c     | 17 +++++++++++++----
>  6 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 71e277c7c3f3..5d95113c7b7c 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -371,9 +371,7 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> -	printf(" -s: specify the type of memory that should be used to\n"
> -	       "     back the guest data region.\n\n");
> -	backing_src_help();
> +	backing_src_help("-s");
>  	puts("");
>  	exit(0);
>  }
> @@ -381,7 +379,7 @@ static void help(char *name)
>  int main(int argc, char *argv[])
>  {
>  	struct test_params params = {
> -		.backing_src = VM_MEM_SRC_ANONYMOUS,
> +		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
>  		.vcpus = 1,
>  	};
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 735c081e774e..96cd3e0357f6 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -426,8 +426,7 @@ static void help(char *name)
>  	printf(" -b: specify the size of the memory region which should be\n"
>  	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>  	       "     Default: 1G\n");
> -	printf(" -s: The type of backing memory to use. Default: anonymous\n");
> -	backing_src_help();
> +	backing_src_help("-s");
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> @@ -439,7 +438,7 @@ int main(int argc, char *argv[])
>  {
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	struct test_params p = {
> -		.src_type = VM_MEM_SRC_ANONYMOUS,
> +		.src_type = DEFAULT_VM_MEM_SRC,
>  		.partition_vcpu_memory_access = true,
>  	};
>  	int opt;
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 3c30d0045d8d..5ad9f2bc7369 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -308,11 +308,9 @@ static void help(char *name)
>  	printf(" -v: specify the number of vCPUs to run.\n");
>  	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>  	       "     them into a separate region of memory for each vCPU.\n");
> -	printf(" -s: specify the type of memory that should be used to\n"
> -	       "     back the guest data region.\n\n");
> +	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
> -	       "     (default: 1)");
> -	backing_src_help();
> +	       "     (default: 1)\n");
>  	puts("");
>  	exit(0);
>  }
> @@ -324,7 +322,7 @@ int main(int argc, char *argv[])
>  		.iterations = TEST_HOST_LOOP_N,
>  		.wr_fract = 1,
>  		.partition_vcpu_memory_access = true,
> -		.backing_src = VM_MEM_SRC_ANONYMOUS,
> +		.backing_src = DEFAULT_VM_MEM_SRC,
>  		.slots = 1,
>  	};
>  	int opt;
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index d79be15dd3d2..2f09f2994733 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -68,6 +68,7 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
>  struct timespec timespec_elapsed(struct timespec start);
>  struct timespec timespec_div(struct timespec ts, int divisor);
>  
> +

New extra blank line. Added on purpose?

>  enum vm_mem_backing_src_type {
>  	VM_MEM_SRC_ANONYMOUS,
>  	VM_MEM_SRC_ANONYMOUS_THP,
> @@ -90,6 +91,8 @@ enum vm_mem_backing_src_type {
>  	NUM_SRC_TYPES,
>  };
>  
> +#define DEFAULT_VM_MEM_SRC VM_MEM_SRC_ANONYMOUS
> +
>  struct vm_mem_backing_src_alias {
>  	const char *name;
>  	uint32_t flag;
> @@ -100,7 +103,7 @@ size_t get_trans_hugepagesz(void);
>  size_t get_def_hugetlb_pagesz(void);
>  const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
>  size_t get_backing_src_pagesz(uint32_t i);
> -void backing_src_help(void);
> +void backing_src_help(const char *flag);
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index 0d04a7db7f24..36407cb0ec85 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -456,10 +456,7 @@ static void help(char *name)
>  	       "     (default: 1G)\n");
>  	printf(" -v: specify the number of vCPUs to run\n"
>  	       "     (default: 1)\n");
> -	printf(" -s: specify the type of memory that should be used to\n"
> -	       "     back the guest data region.\n"
> -	       "     (default: anonymous)\n\n");
> -	backing_src_help();
> +	backing_src_help("-s");
>  	puts("");
>  }
>  
> @@ -468,7 +465,7 @@ int main(int argc, char *argv[])
>  	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>  	struct test_params p = {
>  		.test_mem_size = DEFAULT_TEST_MEM_SIZE,
> -		.src_type = VM_MEM_SRC_ANONYMOUS,
> +		.src_type = DEFAULT_VM_MEM_SRC,
>  	};
>  	int opt;
>  
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index af1031fed97f..ea23a86132ed 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -279,13 +279,22 @@ size_t get_backing_src_pagesz(uint32_t i)
>  	}
>  }
>  
> -void backing_src_help(void)
> +void print_available_backing_src_types(const char *prefix)

This can probably be static.

>  {
>  	int i;
>  
> -	printf("Available backing src types:\n");
> +	printf("%sAvailable backing src types:\n", prefix);
> +
>  	for (i = 0; i < NUM_SRC_TYPES; i++)
> -		printf("\t%s\n", vm_mem_backing_src_alias(i)->name);
> +		printf("%s    %s\n", prefix, vm_mem_backing_src_alias(i)->name);
> +}
> +
> +void backing_src_help(const char *flag)
> +{
> +	printf(" %s: specify the type of memory that should be used to\n"
> +	       "     back the guest data region. (default: %s)\n",
> +	       flag, vm_mem_backing_src_alias(DEFAULT_VM_MEM_SRC)->name);
> +	print_available_backing_src_types("     ");
>  }
>  
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
> @@ -296,7 +305,7 @@ enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
>  		if (!strcmp(type_name, vm_mem_backing_src_alias(i)->name))
>  			return i;
>  
> -	backing_src_help();
> +	print_available_backing_src_types("");
>  	TEST_FAIL("Unknown backing src type: %s", type_name);
>  	return -1;
>  }
> -- 
> 2.33.0.309.g3052b89438-goog
>


Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

