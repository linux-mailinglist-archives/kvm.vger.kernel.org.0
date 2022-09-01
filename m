Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13285A9E7E
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiIARwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIARws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:52:48 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD37B7BA
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:52:47 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q15so12794907pfn.11
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=M/Y999ZLyjma23uFBl4/yrH86NPjAdlcDvjZkg4aH3Q=;
        b=r61VuJVMFRy45MadOUYLO4P9d+M05mE15r+IN67L1s4IhNVhjjPgsHg6tRIqXjndQk
         BCYCs6wY2jHvYRrQ8+fYllwUHRMgrB2FsaV7wQBiNLm9O8ZnAkwrNHiZBmYb8suPLQIx
         m0n4OEEks52oLyc+hulN8su9Q1HTxzBXSnPWT0uuh42lyAXMFhJzojGk/fFNordJE10q
         JV+x/oDRYhHEvQuHW+p41m5ulGeoT+7RgG7JGtnXuhJdP4dzsx8yldUjB3tBrLZHNwIE
         yGMix4ggDluYuTMsH9wQzKjI5QeRXODUJDDwem2R5ep6ZL2KpyfGKhEwhSZFPLLdXsgu
         s5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=M/Y999ZLyjma23uFBl4/yrH86NPjAdlcDvjZkg4aH3Q=;
        b=1jyG5UbkHKA8hWCHP31lt/an2/bFbYjRjzAWCs1gORwVoQ8/aY7lBK6nrUcTE6pwGe
         mz+hSdQwTGJ1bVNe2nuAiy7uptGQdZAtenKMk8GTEphvxYTv2GK8hA35roHH4NuBFLlH
         NZcy4L4h6PtG2p/NUSGrLR0qvsQaLpb8bnXZ6VFu7bEvM2tYgnGQXJccpfZDJmeor/3p
         s9DNUjKwG9FG5mhOqQ1uwbfRC0kl2m5iCRMrLNbjjxwSrMLy+VBvALmD0IKPkfo0yjoh
         y93g9UvSj+Kloa7QTNOVQlYaHwl50O2tginAStWtZsyI2XjRgzatD8lUNsjaq5mUvEYr
         o9iw==
X-Gm-Message-State: ACgBeo3OroqMPUjeTO39L8K2+hm/MF0dUrE5Az6MXPI7bDgJLLIV24RS
        BIggFDT/dKBsbb8orMrIfSs8ug==
X-Google-Smtp-Source: AA6agR7u798HWcTmJF3P8C8dYEk7W9tJdFWRoHqrsEKHQsDm+O4Xt76cQCCjVe+VC4t0jdArCZMnvA==
X-Received: by 2002:a63:f658:0:b0:42a:f05c:30f3 with SMTP id u24-20020a63f658000000b0042af05c30f3mr27181206pgj.46.1662054766406;
        Thu, 01 Sep 2022 10:52:46 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id k88-20020a17090a3ee100b001fd86f8dc03sm3643095pjc.8.2022.09.01.10.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 10:52:45 -0700 (PDT)
Date:   Thu, 1 Sep 2022 10:52:42 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        oupton@google.com
Subject: Re: [PATCH v2 1/3] KVM: selftests: Create source of randomness for
 guest code.
Message-ID: <YxDxagzRx0opmBBy@google.com>
References: <YwlCGAD2S0aK7/vo@google.com>
 <gsntk06pwo62.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntk06pwo62.fsf@coltonlewis-kvm.c.googlers.com>
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

On Tue, Aug 30, 2022 at 07:01:57PM +0000, Colton Lewis wrote:
> David Matlack <dmatlack@google.com> writes:
> 
> > On Wed, Aug 17, 2022 at 09:41:44PM +0000, Colton Lewis wrote:
> > > Create for each vcpu an array of random numbers to be used as a source
> > > of randomness when executing guest code. Randomness should be useful
> > > for approaching more realistic conditions in dirty_log_perf_test.
> 
> > > Create a -r argument to specify a random seed. If no argument
> > > is provided, the seed defaults to the current Unix timestamp.
> 
> > > The random arrays are allocated and filled as part of VM creation. The
> > > additional memory used is one 32-bit number per guest VM page to
> > > ensure one number for each iteration of the inner loop of guest_code.
> 
> > nit: I find it helpful to put this in more practical terms as well. e.g.
> 
> >    The random arrays are allocated and filled as part of VM creation. The
> >    additional memory used is one 32-bit number per guest VM page (so
> >    1MiB of additional memory when using the default 1GiB per-vCPU region
> >    size) to ensure one number for each iteration of the inner loop of
> >    guest_code.
> 
> > Speaking of, this commit always allocates the random arrays, even if
> > they are not used. I think that's probably fine but it deserves to be
> > called out in the commit description with an explanation of why it is
> > the way it is.
> 
> 
> I'll add a concrete example and explain always allocating.
> 
> Technically, the random array will always be accessed even if it never
> changes the code path when write_percent = 0 or write_percent =
> 100. Always allocating avoids extra code that adds complexity for no
> benefit.
> 
> > > @@ -442,6 +446,9 @@ int main(int argc, char *argv[])
> > >   		case 'o':
> > >   			p.partition_vcpu_memory_access = false;
> > >   			break;
> > > +		case 'r':
> > > +			p.random_seed = atoi(optarg);
> 
> > Putting the random seed in test_params seems unnecessary. This flag
> > could just set perf_test_args.randome_seed directly. Doing this would
> > avoid the need for duplicating the time(NULL) initialization, and allow
> > you to drop perf_test_set_random_seed().
> 
> 
> I understand there is some redundancy in this approach and had
> originally done what you suggest. My reason for changing was based on
> the consideration that perf_test_util.c is library code that is used for
> other tests and could be used for more in the future, so it should
> always initialize everything in perf_test_args rather than rely on the
> test to do it. This is what is done for wr_fract (renamed write_percent
> later in this patch). perf_test_set_random_seed is there for interface
> consistency with the other perf_test_set* functions.
> 
> But per the point below, moving random generation to VM creation means
> we are dependent on the seed being set before then. So I do need a
> change here, but I'd rather keep the redundancy and
> perf_test_set_random_seed.
> 
> > > +void perf_test_fill_random_arrays(uint32_t nr_vcpus, uint32_t
> > > nr_randoms)
> > > +{
> > > +	struct perf_test_args *pta = &perf_test_args;
> > > +	uint32_t *host_row;
> 
> > "host_row" is a confusing variable name here since you are no longer
> > operating on a 2D array. Each vCPU has it's own array.
> 
> 
> Agreed.
> 
> > > @@ -120,8 +149,9 @@ struct kvm_vm *perf_test_create_vm(enum
> > > vm_guest_mode mode, int nr_vcpus,
> 
> > >   	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> 
> > > -	/* By default vCPUs will write to memory. */
> > > -	pta->wr_fract = 1;
> > > +	/* Set perf_test_args defaults. */
> > > +	pta->wr_fract = 100;
> > > +	pta->random_seed = time(NULL);
> 
> > Won't this override write the random_seed provided by the test?
> 
> 
> Yes. I had thought I accounted for that by setting random_seed later in
> run_test, but now realize that has no effect because I moved the
> generation of all the random numbers to happen before then.
> 
> 
> > >   	/*
> > >   	 * Snapshot the non-huge page size.  This is used by the guest code to
> > > @@ -211,6 +241,11 @@ struct kvm_vm *perf_test_create_vm(enum
> > > vm_guest_mode mode, int nr_vcpus,
> 
> > >   	ucall_init(vm, NULL);
> 
> > > +	srandom(perf_test_args.random_seed);
> > > +	pr_info("Random seed: %d\n", perf_test_args.random_seed);
> > > +	perf_test_alloc_random_arrays(nr_vcpus, vcpu_memory_bytes >>
> > > vm->page_shift);
> > > +	perf_test_fill_random_arrays(nr_vcpus, vcpu_memory_bytes >>
> > > vm->page_shift);
> 
> > I think this is broken if !partition_vcpu_memory_access. nr_randoms
> > (per-vCPU) should be `nr_vcpus * vcpu_memory_bytes >> vm->page_shift`.
> 
> 
> Agree it will break then and should not. But allocating that many more
> random numbers may eat too much memory. In a test with 64 vcpus, it would
> try to allocate 64x64 times as many random numbers. I'll try it but may
> need something different in that case.

You might want to reconsider the idea of using a random number generator
inside the guest. IRC the reasons against it were: quality of the random
numbers, and that some random generators use floating-point numbers. I
don't think the first one is a big issue. The second one might be an
issue if we want to generate non-uniform distributions (e.g., poisson);
but not a problem for now.

> 
> > Speaking of, this should probably just be done in
> > perf_test_setup_vcpus(). That way you can just use vcpu_args->pages for
> > nr_randoms, and you don't have to add another for-each-vcpu loop.
> 
> 
> Agreed.
> 
> > > +
> > >   	/* Export the shared variables to the guest. */
> > >   	sync_global_to_guest(vm, perf_test_args);
> 
> > > @@ -229,6 +264,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm,
> > > int wr_fract)
> > >   	sync_global_to_guest(vm, perf_test_args);
> > >   }
> 
> > > +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> > > +{
> > > +	perf_test_args.random_seed = random_seed;
> > > +	sync_global_to_guest(vm, perf_test_args);
> 
> > sync_global_to_guest() is unnecessary here since the guest does not need
> > to access perf_test_args.random_seed (and I can't imagine it ever will).
> 
> > That being said, I think you can drop this function (see earlier
> > comment).
> 
> 
> See earlier response about consistency.
