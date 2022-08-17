Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3DD59750C
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbiHQRZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240911AbiHQRZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:25:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254F0A062E
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:25:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pm17so13061529pjb.3
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 10:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hCq/PjmSnq52qccJMB90RFwBUsMpXeagX4qGypLdhpE=;
        b=N+IfMHTiYpzIYImT/JuopWNwNg0E5yvxwVTEC9c6MmClUGnC9KcfKMEifeWWKRuCs8
         Hfu7xQBaDGkdxYyA5V2MvL58ZSxm9uuiFx8OcdQYvG+L/XuBtg0QYic626WZ/EIkvi/Y
         zRTr/XkBZjfkcA2UvpwGOMR4cVVR123Yh57MrF7Rt21E51/NstgwgEyKGoqqK1pdPZZJ
         a/LzBTbn9NBFQZqAGFqNKbo2QQISCol3wXodUq2HfrZ08WNNpnHC7UgGZ1Q2zhmA0I4t
         yD00nK/Mi2lahqjKQNgGruxHPv9i+lTKYKbSyAG+ZlATGLDw4WBC0hjdu1bDSN0ogqcu
         xJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hCq/PjmSnq52qccJMB90RFwBUsMpXeagX4qGypLdhpE=;
        b=4pokZA68i0oAz3yoVlnKp7YgkifvCLDlhv22cToGhhvJLOv9yAepqNt/0lar26MrUw
         RuyBertjg+BR4n17dS3et8YLbsVRBgK7TmkBxULRv11lbwCtHhtHbg0Ru/Hk9vtEmdri
         droA/CuHXyl/0/q6j2unqBGuv3fnfvJ3cLksZTaDAJE8lNW5W552uD9FN+WyCmdiqSAS
         FsMKsvSVJdzfNNlU48Ugo3tS1+O9xmwGt2XUDEOiVd6ord3Bzol83iEuU9jmTkFB96Ia
         U0tdi6bKNY3Obufw/bwSyKHtMWh4VDCCRolVe2ukDVH8UcWnGsAKBTUS0YPRiL/FXVyG
         Z1gg==
X-Gm-Message-State: ACgBeo2ci+cwU6aBPOIiwOnnuP7sE/A6L2L1yJG93D/UxiI/P/SuSqdI
        VP9jTPm6Lt3v5Xn7mbhBIopP8Q==
X-Google-Smtp-Source: AA6agR5lJPZ9ZFvM9kMHy1/peLxDJomZHuK4R1AVa5To+hXepZOQ5IsT2+6KY2aa42EWY7qTsMkVfA==
X-Received: by 2002:a17:90a:68ce:b0:1f4:db83:1eea with SMTP id q14-20020a17090a68ce00b001f4db831eeamr4793245pjj.55.1660757126353;
        Wed, 17 Aug 2022 10:25:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902da8500b0016be834d54asm140624plx.306.2022.08.17.10.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:25:25 -0700 (PDT)
Date:   Wed, 17 Aug 2022 17:24:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
Message-ID: <Yv0kRhSjSqz0i0lG@google.com>
References: <20220817152956.4056410-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817152956.4056410-1-vipinsh@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022, Vipin Sharma wrote:
> Add command line options to run the vcpus and the main process on the
> specific cpus on a host machine. This is useful as it provides
> options to analyze performance based on the vcpus and dirty log worker
> locations, like on the different numa nodes or on the same numa nodes.

The two options should probably be separate patches, they are related but still
two very distinct changes.

> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 
> This is based on the discussion at
> https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com/

This can and should be captured in the changelog proper:

  Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com

> @@ -348,12 +353,74 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	perf_test_destroy_vm(vm);
>  }
>  
> +static int parse_num(const char *num_str)
> +{
> +	int num;
> +	char *end_ptr;
> +
> +	errno = 0;
> +	num = (int)strtol(num_str, &end_ptr, 10);
> +	TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> +		    "Invalid number string.\n");
> +	TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);

Is the paranoia truly necessary?  What happens if parse_cpu_list() simply uses
atoi() and is passed garbage?

> +
> +	return num;
> +}
> +
> +static int parse_cpu_list(const char *arg)
> +{
> +	char delim[2] = ",";
> +	char *cpu, *cpu_list;
> +	int i = 0, cpu_num;
> +
> +	cpu_list = strdup(arg);
> +	TEST_ASSERT(cpu_list, "Low memory\n");

Heh, probably a little less than "low".  Just be literal and let the user figure
out why the allocation failed instead.

        TEST_ASSERT(cpu_list, "strdup() allocation failed\n");

> +
> +	cpu = strtok(cpu_list, delim);
> +	while (cpu) {
> +		cpu_num = parse_num(cpu);
> +		TEST_ASSERT(cpu_num >= 0, "Invalid cpu number: %d\n", cpu_num);
> +		vcpu_to_lcpu_map[i++] = cpu_num;
> +		cpu = strtok(NULL, delim);
> +	}
> +
> +	free(cpu_list);

The tokenization and parsing is nearly identical between parse_cpu_list() and
assign_dirty_log_perf_test_cpu().  The code can be made into a common helper by
passing in the destination, e.g.

static int parse_cpu_list(const char *arg, cpu_set_t *cpuset, int *vcpu_map)
{
	const char delim[] = ",";
	char *cpustr, *cpu_list;
	int i = 0, cpu;

	TEST_ASSERT(!!cpuset ^ !!vcpu_map);

	cpu_list = strdup(arg);
	TEST_ASSERT(cpu_list, "Low memory\n");

	cpustr = strtok(cpu_list, delim);
	while (cpustr) {
		cpu = atoi(cpustr);
		TEST_ASSERT(cpu >= 0, "Invalid cpu number: %d\n", cpu);
		if (vcpu_map)
			vcpu_to_lcpu_map[i++] = cpu_num;
		else
			CPU_SET(cpu_num, cpuset);
		cpu = strtok(NULL, delim);
	}

	free(cpu_list);

	return i;
}

> @@ -383,6 +450,26 @@ static void help(char *name)
>  	backing_src_help("-s");
>  	printf(" -x: Split the memory region into this number of memslots.\n"
>  	       "     (default: 1)\n");
> +	printf(" -c: Comma separated values of the logical CPUs which will run\n"
> +	       "     the vCPUs. Number of values should be equal to the number\n"
> +	       "     of vCPUs.\n\n"
> +	       "     Example: ./dirty_log_perf_test -v 3 -c 22,43,1\n"
> +	       "     This means that the vcpu 0 will run on the logical cpu 22,\n"
> +	       "     vcpu 1 on the logical cpu 43 and vcpu 2 on the logical cpu 1.\n"
> +	       "     (default: No cpu mapping)\n\n");
> +	printf(" -d: Comma separated values of the logical CPUs on which\n"
> +	       "     dirty_log_perf_test will run. Without -c option, all of\n"
> +	       "     the vcpus and main process will run on the cpus provided here.\n"
> +	       "     This option also accepts a single cpu. (default: No cpu mapping)\n\n"
> +	       "     Example 1: ./dirty_log_perf_test -v 3 -c 22,43,1 -d 101\n"
> +	       "     Main application thread will run on logical cpu 101 and\n"
> +	       "     vcpus will run on the logical cpus 22, 43 and 1\n\n"
> +	       "     Example 2: ./dirty_log_perf_test -v 3 -d 101\n"
> +	       "     Main application thread and vcpus will run on the logical\n"
> +	       "     cpu 101\n\n"
> +	       "     Example 3: ./dirty_log_perf_test -v 3 -d 101,23,53\n"
> +	       "     Main application thread and vcpus will run on logical cpus\n"
> +	       "     101, 23 and 53.\n");
>  	puts("");
>  	exit(0);
>  }

> @@ -455,6 +550,13 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  

I wonder if we should make -c and -d mutually exclusive.  Tweak -c to include the
application thread, i.e. TEST_ASSERT(nr_lcpus == nr_vcpus+1) and require 1:1 pinning
for all tasks.  E.g. allowing "-c ..., -d 0,1,22" seems unnecessary.

> +	if (nr_lcpus != -1) {
> +		TEST_ASSERT(nr_lcpus == nr_vcpus,
> +			    "Number of vCPUs (%d) are not equal to number of logical cpus provided (%d).",
> +			    nr_vcpus, nr_lcpus);
> +		p.vcpu_to_lcpu = vcpu_to_lcpu_map;
> +	}
> +
>  	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
>  
>  	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
