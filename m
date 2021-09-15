Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB3540CF10
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhIOV5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhIOV5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:57:08 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BD9C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:55:49 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q3so5422445iot.3
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvVy8oPhdZ3l6KQ5Nlbub8biDmjev9BTDMM8zLauqZg=;
        b=rqQFq2P0zRSoKqDzDYIMu7sIV+XIClIcXp1bqSax0EPe46obp/hf2A+C90feErW0AY
         CwhdisYBABhn653XQQoq88xHk2qRO2wnWoEtf7yODTW7NV86HYekRl+IkLIFLT0rJ1Xn
         jT5bwzAQ5IGaibiUuoZV7EfZwgxrpOvkYp1UTpeqng9nrNB/Cd1+qahEQ8ICgrxLFafE
         mVUCBN2HmjavI4c4BAaQjAda+5n/CoIBaMUCaCd/PTul7mmmJ4+2Y62Ys/vUGWAGG+Av
         /UY5hKSVWr4BasVEdiL2lVlMaYPOPPwPLu60b6a+STTtIaAEekGQzPDM5eykQbWZoCeU
         LmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvVy8oPhdZ3l6KQ5Nlbub8biDmjev9BTDMM8zLauqZg=;
        b=rLENOpao1bWBhPRtubMXLOS76iGmxkaT7NlqV2rFlh3CIVdY2CZwW2lV38X9QhIS7q
         CuUBt4H2dcE0EGqIybGgZpIC3yqgepZBZLUwPlX04SkjUQRR/xf0l194qOjH5xDG5RpC
         A17Wv9ufcNMpveVcJeVVElMRjoSBimCsvGMlPQbuO9P4WEHaATiDDfCr/B6g1KiuVciP
         3O1z+6aLO/OC/4v5slZ4k0ofDh5or7fp/U0tRuSlgn1AQBjYFGcmWFn3uOW8P5hcW/aK
         uygBwyOLny7zohva5H3vXQO53pJUvUgf7nApdOkBe/BvKhtajiD+rQOd04oa5k+G6V+m
         XfZg==
X-Gm-Message-State: AOAM530ig+c8CSHXkB3gKsCO5HCTy9WX6lJ3BTg7z+WJ2/7v0w/R0PWK
        9INISfUcr5lCvUAwEx4AI92iqPi0e/jE3WhCnOYU5Q==
X-Google-Smtp-Source: ABdhPJwpqGoVHch3XAuqtMjUaY+fBqLyGsDZEs1rqM3VAddXm0ie8ngMnFUvZPGderk605gDHmGwMRqLzlf0LstU5tk=
X-Received: by 2002:a5e:8349:: with SMTP id y9mr1804751iom.34.1631742948774;
 Wed, 15 Sep 2021 14:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com> <20210915213034.1613552-3-dmatlack@google.com>
In-Reply-To: <20210915213034.1613552-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 15 Sep 2021 14:55:37 -0700
Message-ID: <CANgfPd_xUrgX42Pg4DSpvg4QmMb3qtUMrKf-16R0JzQxOGNCGQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Refactor help message for -s backing_src
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
>
> All selftests that support the backing_src option were printing their
> own description of the flag and then calling backing_src_help() to dump
> the list of available backing sources. Consolidate the flag printing in
> backing_src_help() to align indentation, reduce duplicated strings, and
> improve consistency across tests.
>
> Note: Passing "-s" to backing_src_help is unnecessary since every test
> uses the same flag. However I decided to keep it for code readability
> at the call sites.
>
> While here this opportunistically fixes the incorrectly interleaved
> printing -x help message and list of backing source types in
> dirty_log_perf_test.
>
> Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

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
>         printf(" -v: specify the number of vCPUs to run.\n");
>         printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>                "     them into a separate region of memory for each vCPU.\n");
> -       printf(" -s: specify the type of memory that should be used to\n"
> -              "     back the guest data region.\n\n");
> -       backing_src_help();
> +       backing_src_help("-s");
>         puts("");
>         exit(0);
>  }
> @@ -381,7 +379,7 @@ static void help(char *name)
>  int main(int argc, char *argv[])
>  {
>         struct test_params params = {
> -               .backing_src = VM_MEM_SRC_ANONYMOUS,
> +               .backing_src = DEFAULT_VM_MEM_SRC,
>                 .vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
>                 .vcpus = 1,
>         };
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 735c081e774e..96cd3e0357f6 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -426,8 +426,7 @@ static void help(char *name)
>         printf(" -b: specify the size of the memory region which should be\n"
>                "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>                "     Default: 1G\n");
> -       printf(" -s: The type of backing memory to use. Default: anonymous\n");
> -       backing_src_help();
> +       backing_src_help("-s");
>         printf(" -v: specify the number of vCPUs to run.\n");
>         printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>                "     them into a separate region of memory for each vCPU.\n");
> @@ -439,7 +438,7 @@ int main(int argc, char *argv[])
>  {
>         int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>         struct test_params p = {
> -               .src_type = VM_MEM_SRC_ANONYMOUS,
> +               .src_type = DEFAULT_VM_MEM_SRC,
>                 .partition_vcpu_memory_access = true,
>         };
>         int opt;
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 3c30d0045d8d..5ad9f2bc7369 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -308,11 +308,9 @@ static void help(char *name)
>         printf(" -v: specify the number of vCPUs to run.\n");
>         printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>                "     them into a separate region of memory for each vCPU.\n");
> -       printf(" -s: specify the type of memory that should be used to\n"
> -              "     back the guest data region.\n\n");
> +       backing_src_help("-s");
>         printf(" -x: Split the memory region into this number of memslots.\n"
> -              "     (default: 1)");
> -       backing_src_help();
> +              "     (default: 1)\n");
>         puts("");
>         exit(0);
>  }
> @@ -324,7 +322,7 @@ int main(int argc, char *argv[])
>                 .iterations = TEST_HOST_LOOP_N,
>                 .wr_fract = 1,
>                 .partition_vcpu_memory_access = true,
> -               .backing_src = VM_MEM_SRC_ANONYMOUS,
> +               .backing_src = DEFAULT_VM_MEM_SRC,
>                 .slots = 1,
>         };
>         int opt;
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index d79be15dd3d2..2f09f2994733 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -68,6 +68,7 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
>  struct timespec timespec_elapsed(struct timespec start);
>  struct timespec timespec_div(struct timespec ts, int divisor);
>
> +
>  enum vm_mem_backing_src_type {
>         VM_MEM_SRC_ANONYMOUS,
>         VM_MEM_SRC_ANONYMOUS_THP,
> @@ -90,6 +91,8 @@ enum vm_mem_backing_src_type {
>         NUM_SRC_TYPES,
>  };
>
> +#define DEFAULT_VM_MEM_SRC VM_MEM_SRC_ANONYMOUS
> +
>  struct vm_mem_backing_src_alias {
>         const char *name;
>         uint32_t flag;
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
>                "     (default: 1G)\n");
>         printf(" -v: specify the number of vCPUs to run\n"
>                "     (default: 1)\n");
> -       printf(" -s: specify the type of memory that should be used to\n"
> -              "     back the guest data region.\n"
> -              "     (default: anonymous)\n\n");
> -       backing_src_help();
> +       backing_src_help("-s");
>         puts("");
>  }
>
> @@ -468,7 +465,7 @@ int main(int argc, char *argv[])
>         int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>         struct test_params p = {
>                 .test_mem_size = DEFAULT_TEST_MEM_SIZE,
> -               .src_type = VM_MEM_SRC_ANONYMOUS,
> +               .src_type = DEFAULT_VM_MEM_SRC,
>         };
>         int opt;
>
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index af1031fed97f..ea23a86132ed 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -279,13 +279,22 @@ size_t get_backing_src_pagesz(uint32_t i)
>         }
>  }
>
> -void backing_src_help(void)
> +void print_available_backing_src_types(const char *prefix)
>  {
>         int i;
>
> -       printf("Available backing src types:\n");
> +       printf("%sAvailable backing src types:\n", prefix);
> +
>         for (i = 0; i < NUM_SRC_TYPES; i++)
> -               printf("\t%s\n", vm_mem_backing_src_alias(i)->name);
> +               printf("%s    %s\n", prefix, vm_mem_backing_src_alias(i)->name);
> +}
> +
> +void backing_src_help(const char *flag)
> +{
> +       printf(" %s: specify the type of memory that should be used to\n"
> +              "     back the guest data region. (default: %s)\n",
> +              flag, vm_mem_backing_src_alias(DEFAULT_VM_MEM_SRC)->name);
> +       print_available_backing_src_types("     ");
>  }
>
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
> @@ -296,7 +305,7 @@ enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name)
>                 if (!strcmp(type_name, vm_mem_backing_src_alias(i)->name))
>                         return i;
>
> -       backing_src_help();
> +       print_available_backing_src_types("");
>         TEST_FAIL("Unknown backing src type: %s", type_name);
>         return -1;
>  }
> --
> 2.33.0.309.g3052b89438-goog
>
