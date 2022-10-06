Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0C5F6E68
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 21:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiJFTuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiJFTuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 15:50:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EA25F986
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 12:50:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c7so2718758pgt.11
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 12:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dpir34eU+5LP/tNP3NKp61NmZ3W+CXLyocH49Fhg49A=;
        b=thOK5q1hFcVw5CAfmwDcWYs/2tKq8hhhJ0DPVM9nmt4V5ZjMW7zzZ/9peDO2hCCnrF
         va4C6NxLTn3UNoZ+pHUBSalsX3Lsrz084MaFLjK01lJNklxTIqCmGNxL/a40m7qmBeI5
         lGHugj5RBSrkpH44i+naEnh73VyE6J9q98bH5dQnXSWHFnP1TMKlc8zf8phuiHe24GhD
         VHQr09gu4vTtE79XBk98YPvMFntJF1mQdgRDDxZslg/P1yj95mL5CVzzg5054XdAmUOa
         PJ/zjReX9Up1EHLEEcfFxK25QqOCQWFbXjHSzbRo90Cfhv5sCTATGpgqv0pP/EFosuCF
         Ecgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpir34eU+5LP/tNP3NKp61NmZ3W+CXLyocH49Fhg49A=;
        b=nMzh361ignGS4SVipKLxhsXSrE0gghsMG4QsnTLtUn7EAw9JTAan9oH2Y1zPQzZlc6
         U85gNDtY83I+g7b5sTLjHzVZKuLMBQpVWz1ZsW6kdGJcr6zdJG+/Z26RtACVyVH79+G3
         0h+0yduvMcwTmLs9i2qkPdoRTSRBPnvchyNURNhfSzI/nRsHOmWn+fxpPBWGMeIFhFPp
         lHjiQuyWuk7TRsj4WZxgDoSzcb45KtJkFnRFzTnnU1nHAv/HrUn3uum5eMy4mrkIDZ75
         6LUh6wwGgqvTxdHjXnr6xT3bkHTY2Y1p7QZ2UjDG3QzWQ8QY6wDe2IoTmmUpsXOPNKfD
         ygRQ==
X-Gm-Message-State: ACrzQf0wwdIPI0PPhADAbYQzF9Gj1cASHyAbMpuGf1AiMRrQKUrRCT6J
        8xhW1rhSYuKz6YVFtld+PkNQsg==
X-Google-Smtp-Source: AMsMyM6XzxJrL/53BvOJnFCJqrsPOdcYV/8B5iYckuAl+zzs9v21CBMQx39TEnmR4CXn2FLTReDb3w==
X-Received: by 2002:a05:6a00:b4d:b0:561:b974:94b9 with SMTP id p13-20020a056a000b4d00b00561b97494b9mr1325486pfo.26.1665085816695;
        Thu, 06 Oct 2022 12:50:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f80-20020a623853000000b00562362dbbc1sm3635363pfa.157.2022.10.06.12.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:50:15 -0700 (PDT)
Date:   Thu, 6 Oct 2022 19:50:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on
 specific CPUs
Message-ID: <Yz8xdJEMjcfdrcWC@google.com>
References: <20221006171133.372359-1-vipinsh@google.com>
 <20221006171133.372359-5-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006171133.372359-5-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022, Vipin Sharma wrote:
> Add command line options, -c,  to run the vCPUs and optionally the main

Stale, there's only one option now.   Extra space too.  And an uber nit, just
"vCPUs" instead of "the vCPUs".  And if you introduce "pin" here (though that's
probably unnecessary since it's nearly ubiquitous terminology), it can be used
throughout to be more succinct, e.g.

Add a command line topion, -c, to pin vCPUs to physical CPUs (pCPUS), i.e.
to force vCPUs to run on specific pCPUs.

> process on the specific CPUs on a host machine. This is useful as it
> provides a way to analyze performance based on the vCPUs and dirty log
> worker locations, like on the different numa nodes or on the same numa

s/numa/NUMA

> nodes.

Please add a link to the discussion that led to implementing only 1:1 pinning,
along with a brief blurb to call out that this is deliberately "limited" in order
to keep things simple.

> Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>

Suggested-by: is generally intended to document that someone else came up with
the original idea.  Even for significant massages to APIs like this, there's no
need to add Suggested-by for me as I most definitely didn't come up with the
original idea of pinning vCPUs.  It's obviously not a big deal, but sometimes
knowing who originally suggested something does help provide context.

> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 23 +++++++-
>  .../selftests/kvm/include/perf_test_util.h    |  6 ++
>  .../selftests/kvm/lib/perf_test_util.c        | 58 ++++++++++++++++++-
>  3 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index ecda802b78ff..33f83e423f75 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -353,7 +353,7 @@ static void help(char *name)
>  	puts("");
>  	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
>  	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
> -	       "[-x memslots]\n", name);
> +	       "[-x memslots] [-c physical cpus to run test on]\n", name);
>  	puts("");
>  	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>  	       TEST_HOST_LOOP_N);
> @@ -383,6 +383,18 @@ static void help(char *name)
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> +	printf(" -c: Comma separated values of the physical CPUs, which will run\n"

Lead with what the option does, then dive into gory details.  In most cases, a user
is going to dump the help text to find something specific (I constantly forget params)
or to get a general idea of what's possible.  E.g. someone should have a clear
understanding of _what_ the command line option does after the first blurb, without
having to understand the details of the command.

> +	       "     the vCPUs, optionally, followed by the main application thread cpu.\n"
> +	       "     Number of values must be at least the number of vCPUs.\n"
> +	       "     The very next number is used to pin main application thread.\n\n"
> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24,50\n"
> +	       "     This means that the vcpu 0 will run on the physical cpu 22,\n"
> +	       "     vcpu 1 on the physical cpu 23, vcpu 2 on the physical cpu 24\n"
> +	       "     and the main thread will run on cpu 50.\n\n"

This can be much more brief by using common acronyms for pCPU, and simply stating
"pin" instead of "on the", e.g.

	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
	       "     values (target pCPU), one for each vCPU, plus an optional\n"
	       "     entry for the main application task (specified via entry\n"
	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24,50\n"
	       "     will create 3 vCPUs, and pin vCPU0=>pCPU22, vCPU1=>pCPU23\n"
	       "     vCPU2=>pCPU24, and pin the application task to pCPU50.\n"
	       "     To leave the application task unpinned, drop the final entry:"
	       "       ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"
	       "     (default: no pinning)\n");


> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24\n"
> +	       "     Same as the previous example except now main application\n"
> +	       "     thread can run on any physical cpu\n\n"
> +	       "     (default: No cpu mapping)\n");
>  	puts("");
>  	exit(0);
>  }

...

> +static void pin_me_to_pcpu

Maybe s/me/this_task ?

> (int pcpu)

Unless we're using -1 as "don't pin" or "invalid", this should be an unsigned value.

> +{
> +	cpu_set_t cpuset;
> +	int err;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(pcpu, &cpuset);

To save user pain:

	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
	TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
		    strerror(errno));

	TEST_ASSERT(CPU_ISSET(pcpu, &allowed_mask),
		    "Task '%d' not allowed to run on pCPU '%d'\n");

	CPU_ZERO(&allowed_mask);
	CPU_SET(cpu, &allowed_mask);

that way the user will get an explicit error message if they try to pin a vCPU/task
that has already been affined by something else.  And then, in theory,
sched_setaffinity() should never fail.

Or you could have two cpu_set_t objects and use CPU_AND(), but that seems
unnecessarily complex.

> +	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
> +	TEST_ASSERT(err == 0, "sched_setaffinity() errored out for pcpu: %d\n", pcpu);

!err is the preferred style, though I vote to use "r" instead of "err".  And print
the errno so that the user can debug.

	r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
	TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
		    errno, strerror(errno));

> +}
> +
>  static void *vcpu_thread_main(void *data)
>  {
>  	struct vcpu_thread *vcpu = data;
> +	int idx = vcpu->vcpu_idx;
> +	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[idx];
> +
> +	if (perf_test_args.pin_vcpus)
> +		pin_me_to_pcpu(vcpu_args->pcpu);
>  
>  	WRITE_ONCE(vcpu->running, true);
>  
> @@ -255,7 +274,7 @@ static void *vcpu_thread_main(void *data)
>  	while (!READ_ONCE(all_vcpu_threads_running))
>  		;
>  
> -	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
> +	vcpu_thread_fn(vcpu_args);
>  
>  	return NULL;
>  }
> @@ -292,3 +311,40 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
>  	for (i = 0; i < nr_vcpus; i++)
>  		pthread_join(vcpu_threads[i].thread, NULL);
>  }
> +
> +static int pcpu_num(const char *cpu_str)
> +{
> +	int pcpu = atoi_paranoid(cpu_str);

newline after declaration.  Though maybe just omit this helper entirely?  As a
somewhat belated thought, it's trivial to let "-1" mean "don't pin this vCPU".
No idea if there's a use case for that, but it's not any more work to support.

Even if <0 is invalid, what about just having pin_task_to_pcu() do all the
sanity checking?  That way it's more obvious that that helper isn't failing to
sanity check the incoming value.

> +	TEST_ASSERT(pcpu >= 0, "Invalid cpu number: %d\n", pcpu);
> +	return pcpu;
> +}
> +
> +void perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus)
> +{
> +	char delim[2] = ",";
> +	char *cpu, *cpu_list;
> +	int i = 0;
> +
> +	cpu_list = strdup(pcpus_string);
> +	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
> +
> +	cpu = strtok(cpu_list, delim);
> +
> +	// 1. Get all pcpus for vcpus

No C++ comments please.

> +	while (cpu && i < nr_vcpus) {
> +		perf_test_args.vcpu_args[i++].pcpu = pcpu_num(cpu);
> +		cpu = strtok(NULL, delim);
> +	}
> +
> +	TEST_ASSERT(i == nr_vcpus,
> +		    "Number of pcpus (%d) not sufficient for the number of vcpus (%d).",
> +		    i, nr_vcpus);

Rather than assert after the fact, use a for-loop:

	for (i = 0; i < nr_vcpus; i++ {
		TEST_ASSERT(cpu, "pCPU not provided for vCPU%d\n", i);
		perf_test_args.vcpu_args[i++].pcpu = atoi_paranoid(cpu);
		cpu = strtok(NULL, delim);
	}

so as to avoid having to consume the loop control variable before and after the
loop.  Or even

	for (i = 0, cpu = strtok(cpu_list, delim);
	     i < nr_vcpus;
	     i++, cpu = strtok(NULL, delim)) {
		TEST_ASSERT(cpu, "pCPU not provided for vCPU%d\n", i);
		perf_test_args.vcpu_args[i++].pcpu = atoi_paranoid(cpu);
	}

Though IMO the latter is gratuitous and hard to read.

> +
> +	perf_test_args.pin_vcpus = true;
> +
> +	// 2. Check if main worker is provided
> +	if (cpu)
> +		pin_me_to_pcpu(pcpu_num(cpu));

Verify the string is now empty?  I.e. that there isn't trailing garbage.

> +
> +	free(cpu_list);
> +}
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
