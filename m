Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8AA6E7B8C
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 16:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjDSOKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 10:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSOKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 10:10:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D55B778
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:10:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cm18-20020a17090afa1200b0024713adf69dso602630pjb.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681913402; x=1684505402;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/kGJnr8z8wxFrqDDXTynz2Kx1rxlQ8BF/qZuK+TGWn4=;
        b=SxrBPA6qU+OGTC6UynMhENFjzSeh4jXXTTT/OUvF54hQ53R3i/vju73B3M2RWGVHde
         OsrjVYPR1G2ocHGGT6WOFAKGIT7n2gKDvDHgpMRciEE4Exja3aOgO3WDDmznUnbDm7HX
         e7lkm+VfP2pojMrkd872ZHcch/AMcA1z7JJUdVK7YFdmdxETdVn5Jkli8E3mfWne3OKt
         jSAcS2lT0Rx1VSAU4F/MwMap1sJNY7o7mcWiO8fvc4C7KTJaTE0y0CB65F6JLsgZiBVs
         w278/W0YsZow0vAJZ+rbHYVYYEpwvMS47RHRSStfQy6dU2Jse+eQ11YIMglYgydePNPo
         ozFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681913402; x=1684505402;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/kGJnr8z8wxFrqDDXTynz2Kx1rxlQ8BF/qZuK+TGWn4=;
        b=eoQymm8rBerh9uy8peFKXp4i2z6a5vaqm5q66vRgFoAfL4PyAWPNjEDTFjkjbjopZf
         tS8jNMsPLNPPCtmEU/sA8In8cq2KpjaQX9VE+SkWC+EDsw/7hVaQvKwHIRxNXjUXyKhC
         cs9u9qF09muh+JH//YeJsWEv/+29wfrPl9rKCJQM7iFcaqnyhivM9yPp8oSOLwtsiBXa
         jnxsJoV2WDSpFD4kxuaIKYLVNNaLKqvQC7LvuIVP+9BwfrUNfpkd/z1+dJdjsDBsW32z
         fAu2mr5WScjEq+n+gGFsAEc2kkPHLjV6rqIDox1Ylhq5/hmb8YPP1poXPsx0TRj6wNDq
         P4fg==
X-Gm-Message-State: AAQBX9f5s+I4cyMQRE/+HVu3dkQLAqY2xFQdlSctDbT6avmPF9kY7drt
        w+fGEJpnBQouITgV/BWe5Q4=
X-Google-Smtp-Source: AKy350bsWt7gg1Vbj2PnqQ28BkArGIcqSM9CzS04F8MJNW6pY4byRVmQbsrVKQ0SpUWMaYOw8CbxAA==
X-Received: by 2002:a05:6a20:8e03:b0:f0:98ff:97e2 with SMTP id y3-20020a056a208e0300b000f098ff97e2mr4382368pzj.24.1681913401469;
        Wed, 19 Apr 2023 07:10:01 -0700 (PDT)
Received: from [172.27.232.10] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id c25-20020aa78e19000000b0056d7cc80ea4sm11217057pfr.110.2023.04.19.07.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 07:10:00 -0700 (PDT)
Message-ID: <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
Date:   Wed, 19 Apr 2023 22:09:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in
 demand_paging_test
Content-Language: en-US
To:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-23-amoorthy@google.com>
From:   Hoo Robert <robert.hoo.linux@gmail.com>
In-Reply-To: <20230412213510.1220557-23-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/13/2023 5:35 AM, Anish Moorthy wrote:
> Demonstrate a (very basic) scheme for supporting memory fault exits.
> 
>>From the vCPU threads:
> 1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
>     with the purpose of establishing the absent mappings. Do so with
>     wake_waiters=false to avoid serializing on the userfaultfd wait queue
>     locks.
> 
> 2. When the UFFDIO_COPY/CONTINUE in (1) fails with EEXIST,
>     assume that the mapping was already established but is currently
>     absent [A] and attempt to populate it using MADV_POPULATE_WRITE.
> 
> Issue UFFDIO_COPY/CONTINUEs from the reader threads as well, but with
> wake_waiters=true to ensure that any threads sleeping on the uffd are
> eventually woken up.
> 
> A real VMM would track whether it had already COPY/CONTINUEd pages (eg,
> via a bitmap) to avoid calls destined to EEXIST. However, even the
> naive approach is enough to demonstrate the performance advantages of
> KVM_EXIT_MEMORY_FAULT.
> 
> [A] In reality it is much likelier that the vCPU thread simply lost a
>      race to establish the mapping for the page.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>   .../selftests/kvm/demand_paging_test.c        | 209 +++++++++++++-----
>   1 file changed, 155 insertions(+), 54 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e84dde345edbc..668bd63d944e7 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -15,6 +15,7 @@
>   #include <time.h>
>   #include <pthread.h>
>   #include <linux/userfaultfd.h>
> +#include <sys/mman.h>

+#include <linux/mman.h> for MADV_POPULATE_WRITE definition.

>   #include <sys/syscall.h>
>   
>   #include "kvm_util.h"
> @@ -31,6 +32,57 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
>   static size_t demand_paging_size;
>   static char *guest_data_prototype;
>   
> +static int num_uffds;
> +static size_t uffd_region_size;
> +static struct uffd_desc **uffd_descs;
> +/*
> + * Delay when demand paging is performed through userfaultfd or directly by
> + * vcpu_worker in the case of a KVM_EXIT_MEMORY_FAULT.
> + */
> +static useconds_t uffd_delay;
> +static int uffd_mode;
> +
> +
> +static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hva,
> +									bool is_vcpu);
> +
> +static void madv_write_or_err(uint64_t gpa)
> +{
> +	int r;
> +	void *hva = addr_gpa2hva(memstress_args.vm, gpa);
> +
> +	r = madvise(hva, demand_paging_size, MADV_POPULATE_WRITE);
> +	TEST_ASSERT(r == 0,
> +				"MADV_POPULATE_WRITE on hva 0x%lx (gpa 0x%lx) fail, errno %i\n",
> +				(uintptr_t) hva, gpa, errno);

There are quite a few strange line breaks/indentations across this
patch set, editor's issue?:-)

> +}
> +
> +static void ready_page(uint64_t gpa)
> +{
> +	int r, uffd;
> +
> +	/*
> +	 * This test only registers memslot 1 w/ userfaultfd. Any accesses outside
> +	 * the registered ranges should fault in the physical pages through
> +	 * MADV_POPULATE_WRITE.
> +	 */
> +	if ((gpa < memstress_args.gpa)
> +		|| (gpa >= memstress_args.gpa + memstress_args.size)) {
> +		madv_write_or_err(gpa);
> +	} else {
> +		if (uffd_delay)
> +			usleep(uffd_delay);
> +
> +		uffd = uffd_descs[(gpa - memstress_args.gpa) / uffd_region_size]->uffd;
> +
> +		r = handle_uffd_page_request(uffd_mode, uffd,
> +					(uint64_t) addr_gpa2hva(memstress_args.vm, gpa), true);
> +
> +		if (r == EEXIST)
> +			madv_write_or_err(gpa);
> +	}
> +}
> +
>   static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
>   {
>   	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
> @@ -42,25 +94,36 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
>   
>   	clock_gettime(CLOCK_MONOTONIC, &start);
>   
> -	/* Let the guest access its memory */
> -	ret = _vcpu_run(vcpu);
> -	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> -	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
> -		TEST_ASSERT(false,
> -			    "Invalid guest sync status: exit_reason=%s\n",
> -			    exit_reason_str(run->exit_reason));
> -	}
> +	while (true) {
> +		/* Let the guest access its memory */
> +		ret = _vcpu_run(vcpu);
> +		TEST_ASSERT(ret == 0
> +					|| (errno == EFAULT
> +						&& run->exit_reason == KVM_EXIT_MEMORY_FAULT),
> +					"vcpu_run failed: %d\n", ret);
> +		if (ret != 0 && get_ucall(vcpu, NULL) != UCALL_SYNC) {
> +
> +			if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
> +				ready_page(run->memory_fault.gpa);
> +				continue;
> +			}
> +
> +			TEST_ASSERT(false,

TEST_ASSERT(false, ...) == TEST_FAIL()

> +						"Invalid guest sync status: exit_reason=%s\n",
> +						exit_reason_str(run->exit_reason));
> +		}
>   
> -	ts_diff = timespec_elapsed(start);
> -	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
> -		       ts_diff.tv_sec, ts_diff.tv_nsec);
> +		ts_diff = timespec_elapsed(start);
> +		PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
> +					   ts_diff.tv_sec, ts_diff.tv_nsec);

I think this vcpu exec time calc should be outside while() {} block.

> +		break;
> +	}
>   }
>   
> -static int handle_uffd_page_request(int uffd_mode, int uffd,
> -		struct uffd_msg *msg)
> +static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hva,
> +									bool is_vcpu)
>   {
>   	pid_t tid = syscall(__NR_gettid);
> -	uint64_t addr = msg->arg.pagefault.address;
>   	struct timespec start;
>   	struct timespec ts_diff;
>   	int r;
> @@ -71,56 +134,78 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
>   		struct uffdio_copy copy;
>   
>   		copy.src = (uint64_t)guest_data_prototype;
> -		copy.dst = addr;
> +		copy.dst = hva;
>   		copy.len = demand_paging_size;
> -		copy.mode = 0;
> +		copy.mode = UFFDIO_COPY_MODE_DONTWAKE;
>   
> -		r = ioctl(uffd, UFFDIO_COPY, &copy);
>   		/*
> -		 * With multiple vCPU threads fault on a single page and there are
> -		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
> -		 * will fail with EEXIST: handle that case without signaling an
> -		 * error.
> +		 * With multiple vCPU threads and at least one of multiple reader threads
> +		 * or vCPU memory faults, multiple vCPUs accessing an absent page will
> +		 * almost certainly cause some thread doing the UFFDIO_COPY here to get
> +		 * EEXIST: make sure to allow that case.
>   		 */
> -		if (r == -1 && errno != EEXIST) {
> -			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
> -					addr, tid, errno);
> -			return r;
> -		}
> +		r = ioctl(uffd, UFFDIO_COPY, &copy);
> +		TEST_ASSERT(r == 0 || errno == EEXIST,
> +			"Thread 0x%x failed UFFDIO_COPY on hva 0x%lx, errno = %d",
> +			gettid(), hva, errno);

can this gettid() be substituted by tid above? or #include header file
for its prototype, otherwise build warning/error.

>   	} else if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
> +		/* The comments in the UFFDIO_COPY branch also apply here. */
>   		struct uffdio_continue cont = {0};
>   
> -		cont.range.start = addr;
> +		cont.range.start = hva;
>   		cont.range.len = demand_paging_size;
> +		cont.mode = UFFDIO_CONTINUE_MODE_DONTWAKE;
>   
>   		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
> -		/* See the note about EEXISTs in the UFFDIO_COPY branch. */
> -		if (r == -1 && errno != EEXIST) {
> -			pr_info("Failed UFFDIO_CONTINUE in 0x%lx, thread %d, errno = %d\n",
> -					addr, tid, errno);
> -			return r;
> -		}
> +		TEST_ASSERT(r == 0 || errno == EEXIST,
> +			"Thread 0x%x failed UFFDIO_CONTINUE on hva 0x%lx, errno = %d",
> +			gettid(), hva, errno);

Ditto

>   	} else {
>   		TEST_FAIL("Invalid uffd mode %d", uffd_mode);
>   	}
>   
> +	/*
> +	 * If the above UFFDIO_COPY/CONTINUE fails with EEXIST, it will do so without
> +	 * waking threads waiting on the UFFD: make sure that happens here.
> +	 */
> +	if (!is_vcpu) {
> +		struct uffdio_range range = {
> +			.start = hva,
> +			.len = demand_paging_size
> +		};
> +		r = ioctl(uffd, UFFDIO_WAKE, &range);
> +		TEST_ASSERT(
> +			r == 0,
> +			"Thread 0x%x failed UFFDIO_WAKE on hva 0x%lx, errno = %d",
> +			gettid(), hva, errno);

Ditto

> +	}
> +
>   	ts_diff = timespec_elapsed(start);
>   
>   	PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
>   		       timespec_to_ns(ts_diff));
>   	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
> -		       demand_paging_size, addr, tid);
> +		       demand_paging_size, hva, tid);
>   
>   	return 0;
>   }
>   
> +static int handle_uffd_page_request_from_uffd(int uffd_mode, int uffd,
> +				struct uffd_msg *msg)
> +{
> +	TEST_ASSERT(msg->event == UFFD_EVENT_PAGEFAULT,
> +		"Received uffd message with event %d != UFFD_EVENT_PAGEFAULT",
> +		msg->event);
> +	return handle_uffd_page_request(uffd_mode, uffd,
> +					msg->arg.pagefault.address, false);
> +}
> +
>   struct test_params {
> -	int uffd_mode;
>   	bool single_uffd;
> -	useconds_t uffd_delay;
>   	int readers_per_uffd;
>   	enum vm_mem_backing_src_type src_type;
>   	bool partition_vcpu_memory_access;
> +	bool memfault_exits;
>   };
>   
>   static void prefault_mem(void *alias, uint64_t len)
> @@ -137,15 +222,26 @@ static void prefault_mem(void *alias, uint64_t len)
>   static void run_test(enum vm_guest_mode mode, void *arg)
>   {
>   	struct test_params *p = arg;
> -	struct uffd_desc **uffd_descs = NULL;
>   	struct timespec start;
>   	struct timespec ts_diff;
>   	struct kvm_vm *vm;
> -	int i, num_uffds = 0;
> -	uint64_t uffd_region_size;
> +	int i;
> +	uint32_t slot_flags = 0;
> +	bool uffd_memfault_exits = uffd_mode && p->memfault_exits;
> +
> +	if (uffd_memfault_exits) {
> +		TEST_ASSERT(kvm_has_cap(KVM_CAP_ABSENT_MAPPING_FAULT) > 0,
> +					"KVM does not have KVM_CAP_ABSENT_MAPPING_FAULT");
> +		slot_flags = KVM_MEM_ABSENT_MAPPING_FAULT;
> +	}
>   
>   	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
> -				1, 0, p->src_type, p->partition_vcpu_memory_access);
> +				1, slot_flags, p->src_type, p->partition_vcpu_memory_access);
> +
> +	if (uffd_memfault_exits) {
> +		vm_enable_cap(vm,
> +					  KVM_CAP_MEMORY_FAULT_INFO, KVM_MEMORY_FAULT_INFO_ENABLE);
> +	}
>   
>   	demand_paging_size = get_backing_src_pagesz(p->src_type);
>   
> @@ -154,12 +250,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		    "Failed to allocate buffer for guest data pattern");
>   	memset(guest_data_prototype, 0xAB, demand_paging_size);
>   
> -	if (p->uffd_mode) {
> +	if (uffd_mode) {
>   		num_uffds = p->single_uffd ? 1 : nr_vcpus;
>   		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
>   
>   		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
> -		TEST_ASSERT(uffd_descs, "Memory allocation failed");
> +		TEST_ASSERT(uffd_descs, "Failed to allocate memory of uffd descriptors");
>   
>   		for (i = 0; i < num_uffds; i++) {
>   			struct memstress_vcpu_args *vcpu_args;
> @@ -179,10 +275,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   			 * requests.
>   			 */
>   			uffd_descs[i] = uffd_setup_demand_paging(
> -				p->uffd_mode, p->uffd_delay, vcpu_hva,
> +				uffd_mode, uffd_delay, vcpu_hva,
>   				uffd_region_size,
>   				p->readers_per_uffd,
> -				&handle_uffd_page_request);
> +				&handle_uffd_page_request_from_uffd);
>   		}
>   	}
>   
> @@ -196,7 +292,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	ts_diff = timespec_elapsed(start);
>   	pr_info("All vCPU threads joined\n");
>   
> -	if (p->uffd_mode) {
> +	if (uffd_mode) {
>   		/* Tell the user fault fd handler threads to quit */
>   		for (i = 0; i < num_uffds; i++)
>   			uffd_stop_demand_paging(uffd_descs[i]);
> @@ -211,7 +307,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	memstress_destroy_vm(vm);
>   
>   	free(guest_data_prototype);
> -	if (p->uffd_mode)
> +	if (uffd_mode)
>   		free(uffd_descs);
>   }
>   
> @@ -220,7 +316,7 @@ static void help(char *name)
>   	puts("");
>   	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
>   		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
> -		   "          [-s type] [-v vcpus] [-o]\n", name);
> +		   "          [-w] [-s type] [-v vcpus] [-o]\n", name);
>   	guest_modes_help();
>   	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
>   	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> @@ -231,6 +327,7 @@ static void help(char *name)
>   	       "     FD handler to simulate demand paging\n"
>   	       "     overheads. Ignored without -u.\n");
>   	printf(" -r: Set the number of reader threads per uffd.\n");
> +	printf(" -w: Enable kvm cap for memory fault exits.\n");
>   	printf(" -b: specify the size of the memory region which should be\n"
>   	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>   	       "     Default: 1G\n");
> @@ -250,29 +347,30 @@ int main(int argc, char *argv[])
>   		.partition_vcpu_memory_access = true,
>   		.readers_per_uffd = 1,
>   		.single_uffd = false,
> +		.memfault_exits = false,
>   	};
>   	int opt;
>   
>   	guest_modes_append_default();
>   
> -	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
> +	while ((opt = getopt(argc, argv, "ahowm:u:d:b:s:v:r:")) != -1) {
>   		switch (opt) {
>   		case 'm':
>   			guest_modes_cmdline(optarg);
>   			break;
>   		case 'u':
>   			if (!strcmp("MISSING", optarg))
> -				p.uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
> +				uffd_mode = UFFDIO_REGISTER_MODE_MISSING;
>   			else if (!strcmp("MINOR", optarg))
> -				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
> -			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
> +				uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
> +			TEST_ASSERT(uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
>   			break;
>   		case 'a':
>   			p.single_uffd = true;
>   			break;
>   		case 'd':
> -			p.uffd_delay = strtoul(optarg, NULL, 0);
> -			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
> +			uffd_delay = strtoul(optarg, NULL, 0);
> +			TEST_ASSERT(uffd_delay >= 0, "A negative UFFD delay is not supported.");
>   			break;
>   		case 'b':
>   			guest_percpu_mem_size = parse_size(optarg);
> @@ -295,6 +393,9 @@ int main(int argc, char *argv[])
>   						"Invalid number of readers per uffd %d: must be >=1",
>   						p.readers_per_uffd);
>   			break;
> +		case 'w':
> +			p.memfault_exits = true;
> +			break;
>   		case 'h':
>   		default:
>   			help(argv[0]);
> @@ -302,7 +403,7 @@ int main(int argc, char *argv[])
>   		}
>   	}
>   
> -	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
> +	if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
>   	    !backing_src_is_shared(p.src_type)) {
>   		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
>   	}

