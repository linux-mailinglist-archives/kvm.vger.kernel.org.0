Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4872A5B6186
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiILTN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiILTNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:13:54 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BEF3207A
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:13:54 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id f14-20020a056e020b4e00b002eb541997edso6963517ilu.9
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=HdCSUcTS0fcNrJQo4WAUEZdF4ywDUMWE7Ec4U+SG3h8=;
        b=NUgpCJ0IeTVbL+FuOT5UEugnvnylSYcx6mB0+6T8kbt6U6hsdGSndN6/a0wBXcjJnx
         cAzFOoCIR8cXRWJ5+6lasXEnJrnyh2hFbZIa2ZYJ8xUo8XJ2fR1r/CsTUHtVvCvf6/rL
         0/cBcGlyt8Jd9sC5yp/88K1kNOl6iHm7cuCtvZmPx4iOBqLXB5saqzO9p26rx648E0SE
         /WezpluVaswVK8I+BF7usy/3xvUCcM+aE5nGNqSFlcUO5+RzocWL/BZpMAGOoZI3Yyh1
         4NR/ogS9yF2RKV0A7TIrTDsKa3aaEqu5YsvfwhYwYsFFawfLw24+9jwyh4m2qSHLG6Z9
         QnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HdCSUcTS0fcNrJQo4WAUEZdF4ywDUMWE7Ec4U+SG3h8=;
        b=pVX33/pU7zoINbAWWpwrWQ9MiWjWLY5DY1z87e+lJXQNRbQXEXMwReLyLxNIcQZeJu
         /jrzhs1USo27SkKjInmk4YyaKKrez26cuRxV27u9J2U1UUYUcwVaG7Zkqt22qsMR+4hR
         sC/oCgRedIASMGIguuaEdVHMDJ6mnRW3M3bbHSizRvOSGHu00HaCDLTDyrSsg28jZ0Gy
         xXfuP4DOCtnQY3ObysziE1EAY6SnifHbcWftg6/rSIUxdP7NwhFkhJkXl+wgQytVx6ZU
         fEZhKuHVTvH1CTs5Jn3o8tAVvCYQxIIOg4lPSdepP7/RTs73dZ6P/r/ZEYJHBoVzPlui
         mlTg==
X-Gm-Message-State: ACgBeo0JlVLnPQeOjSPRGQAYN3qpXbclLDd+acIS6DC1XhYHVFJRoqTM
        FfUvhBXKjxrwJfBQTMVu9hsC7pFVQrWmYoQrIQ==
X-Google-Smtp-Source: AA6agR4bt2mxsvD5LWBq68Hcbp8X5OGRcK2wtqR/gQ1xxt0mNeGhAmk71ZjzqSZkKb+KIr1qhhWu9nT9xsfjGC71Sg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1414:b0:2ea:c7b9:efda with
 SMTP id n20-20020a056e02141400b002eac7b9efdamr11405897ilo.202.1663010033460;
 Mon, 12 Sep 2022 12:13:53 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:13:52 +0000
In-Reply-To: <YxtzEJ9HMLPqMqN4@google.com> (message from David Matlack on Fri,
 9 Sep 2022 10:08:32 -0700)
Mime-Version: 1.0
Message-ID: <gsnth71cpfrj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 1/3] KVM: selftests: implement random number generation
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Fri, Sep 09, 2022 at 12:42:58PM +0000, Colton Lewis wrote:
>> Implement random number generation for guest code to randomize parts
>> of the test, making it less predictable and a more accurate reflection
>> of reality.

>> Create a -r argument to specify a random seed. If no argument is
>> provided, the seed defaults to the current Unix timestamp. The random
>> seed is set with perf_test_set_random_seed() and must be set before
>> guest_code runs to apply.

>> The random number generator chosen is the Park-Miller Linear
>> Congruential Generator, a fancy name for a basic and well-understood
>> random number generator entirely sufficient for this purpose. Each
>> vCPU calculates its own seed by adding its index to the seed provided.

> Great commit message!


Thanks


>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
>>   tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>>   tools/testing/selftests/kvm/include/test_util.h      |  2 ++
>>   tools/testing/selftests/kvm/lib/perf_test_util.c     | 11 ++++++++++-
>>   tools/testing/selftests/kvm/lib/test_util.c          |  9 +++++++++
>>   5 files changed, 33 insertions(+), 3 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c  
>> b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> index d60a34cdfaee..2f91acd94130 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> @@ -126,6 +126,7 @@ struct test_params {
>>   	bool partition_vcpu_memory_access;
>>   	enum vm_mem_backing_src_type backing_src;
>>   	int slots;
>> +	uint32_t random_seed;
>>   };

>>   static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool  
>> enable)
>> @@ -220,6 +221,8 @@ static void run_test(enum vm_guest_mode mode, void  
>> *arg)
>>   				 p->slots, p->backing_src,
>>   				 p->partition_vcpu_memory_access);

>> +	pr_info("Random seed: %u\n", p->random_seed);
>> +	perf_test_set_random_seed(vm, p->random_seed);
>>   	perf_test_set_wr_fract(vm, p->wr_fract);

>>   	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >>  
>> vm_get_page_shift(vm);
>> @@ -337,7 +340,7 @@ static void help(char *name)
>>   {
>>   	puts("");
>>   	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>> -	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
>> +	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed  
>> ] [-s mem type]"
>>   	       "[-x memslots]\n", name);
>>   	puts("");
>>   	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>> @@ -362,6 +365,7 @@ static void help(char *name)
>>   	printf(" -v: specify the number of vCPUs to run.\n");
>>   	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
>>   	       "     them into a separate region of memory for each vCPU.\n");
>> +	printf(" -r: specify the starting random seed.\n");
>>   	backing_src_help("-s");
>>   	printf(" -x: Split the memory region into this number of memslots.\n"
>>   	       "     (default: 1)\n");
>> @@ -378,6 +382,7 @@ int main(int argc, char *argv[])
>>   		.partition_vcpu_memory_access = true,
>>   		.backing_src = DEFAULT_VM_MEM_SRC,
>>   		.slots = 1,
>> +		.random_seed = time(NULL),

> It's a bad code smell that the random seed gets default initialized to
> time(NULL) twice (here and in perf_test_create_vm()).

> I also still think it would be better if the default random seed was
> consistent across runs. Most use-cases of dirty_log_perf_test is for A/B
> testing, so consistency is key. For example, running dirty_log_perf_test
> at every commit to find regressions, or running dirty_log_perf_test to
> study the performance effects of some change. In other words, I think
> most use-cases will want a consistent seed across runs, so the default
> behavior should match that. Otherwise I forsee myself (and automated
> tools) having to pass in -r to every test runs to get consistent,
> comparable, behavior.

> What do you think about killing 2 birds with one stone here and make the
> default random_seed 0. That requires no initialization and ensures
> consistent random behavior across runs.


If you say so. Consider it done.

> And then optionally... I would even recommend dropping the -r parameter
> until someone wants to run dirty_log_perf_test with different seeds.
> That would simplify the code even more. I have a feeling there won't be
> much interest in different seeds since, at the end of the day, it will
> always be the same rough distribution of accesses. More interesting than
> different seeds will be adding support for different types of access
> patterns.

I'm leaving it in. I think people will want to compare different seeds
sometimes and it wasn't complicated to put in.
