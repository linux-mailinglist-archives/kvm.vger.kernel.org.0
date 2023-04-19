Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FE6E7B45
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbjDSNvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjDSNvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:51:22 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E04B469A
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:51:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a67bcde3a7so35722775ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912280; x=1684504280;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=on3F8pM3p3B9OClirjfPRYd2TCLDzgp9dJKToJBsoLE=;
        b=dC0uL4Ug8165ZqCya+YsdJvUDjZauqRrZmyIPt7IiTUA/do6GbK4Q4PBwwD6bnNTu2
         HjNWDUyOx/2y+/oHqwMiDjZCOLMpDvPXGZk9RYHvnEUn23GpVxV3LS6d+pZRS7ydwEYl
         n2vUCFUxLfdqmvU/RBFZ5oheDGmk/v2fiRLI22MZCU2h68Dj82vCsk6DGj3cLie2JYMJ
         zop8FdIDWDo58mDf5D/NJomanHIqQfwh1gTDQGooXhM81EzKWjcvrPQGOyjf6eIpT2pj
         DztWnVgBpYPYBvCIf3lphHjD4n9wI4L5b+NBlIS8MaK79zQB+Xzv1fZP+QSskQeJmGRv
         Q0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912280; x=1684504280;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=on3F8pM3p3B9OClirjfPRYd2TCLDzgp9dJKToJBsoLE=;
        b=dnKGgxuQLGc3/8OolhfMATpWAOFF8yG0XzYXneLWacS2CYNuT3ji6RwRE9IRtEK539
         cmTFUFfth5PbuziIECyD0vW20t0ULBJRfKve5/m4Ip0tNG3wnWC1oQpaInupTD+VaJa7
         kyGSeVQGEgp/hvFWdZ9gNiF457QGQHrmHITqxSAIZ7M6YWZ4yMJw7k1bva52aJOroiFL
         jJUwMadKNq85tHdzV2jCo+U5lQ8SenC5v2pQ9FJH91+DC5tJqf8uetqRkRzlfYsBobER
         24uc/YSTHJfqqkA53sIghBM1qJmWybZ5wlWFja8/EbeSp2+YliMCbH2XcYV6LeVsS40z
         o4WA==
X-Gm-Message-State: AAQBX9dzK3/A1SKu+DTq8b1oAZJIKYaTcsoJY+Va1JWDQ6YSn16jBDXK
        cqZRT7KzHAgDBrRRWFbb4hk=
X-Google-Smtp-Source: AKy350aednu5oBp7h8YO3r+lKDMkIRtI+RAxeonBIF+ewZH3h1mRowihayQ3GZqOTl5W+jZZZHUuQA==
X-Received: by 2002:a17:902:db01:b0:1a6:d46b:dfb5 with SMTP id m1-20020a170902db0100b001a6d46bdfb5mr6253884plx.26.1681912279619;
        Wed, 19 Apr 2023 06:51:19 -0700 (PDT)
Received: from [172.27.232.10] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902904800b001a239325f1csm11398221plz.100.2023.04.19.06.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:51:19 -0700 (PDT)
Message-ID: <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com>
Date:   Wed, 19 Apr 2023 21:51:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
Content-Language: en-US
To:     Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
        maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-2-amoorthy@google.com>
From:   Hoo Robert <robert.hoo.linux@gmail.com>
In-Reply-To: <20230412213510.1220557-2-amoorthy@google.com>
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

On 4/13/2023 5:34 AM, Anish Moorthy wrote:
> At the moment, demand_paging_test does not support profiling/testing
> multiple vCPU threads concurrently faulting on a single uffd because
> 
>      (a) "-u" (run test in userfaultfd mode) creates a uffd for each vCPU's
>          region, so that each uffd services a single vCPU thread.
>      (b) "-u -o" (userfaultfd mode + overlapped vCPU memory accesses)
>          simply doesn't work: the test tries to register the same memory
>          to multiple uffds, causing an error.
> 
> Add support for many vcpus per uffd by
>      (1) Keeping "-u" behavior unchanged.
>      (2) Making "-u -a" create a single uffd for all of guest memory.
>      (3) Making "-u -o" implicitly pass "-a", solving the problem in (b).
> In cases (2) and (3) all vCPU threads fault on a single uffd.
> 
> With multiple potentially multiple vCPU per UFFD, it makes sense to
        ^^^^^^^^
redundant "multiple"?

> allow configuring the number reader threads per UFFD as well: add the
> "-r" flag to do so.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>   .../selftests/kvm/aarch64/page_fault_test.c   |  4 +-
>   .../selftests/kvm/demand_paging_test.c        | 62 +++++++++----
>   .../selftests/kvm/include/userfaultfd_util.h  | 18 +++-
>   .../selftests/kvm/lib/userfaultfd_util.c      | 86 +++++++++++++------
>   4 files changed, 124 insertions(+), 46 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index df10f1ffa20d9..3b6d228a9340d 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -376,14 +376,14 @@ static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
>   		*pt_uffd = uffd_setup_demand_paging(uffd_mode, 0,
>   						    pt_args.hva,
>   						    pt_args.paging_size,
> -						    test->uffd_pt_handler);
> +						    1, test->uffd_pt_handler);
>   
>   	*data_uffd = NULL;
>   	if (test->uffd_data_handler)
>   		*data_uffd = uffd_setup_demand_paging(uffd_mode, 0,
>   						      data_args.hva,
>   						      data_args.paging_size,
> -						      test->uffd_data_handler);
> +						      1, test->uffd_data_handler);
>   }
>   
>   static void free_uffd(struct test_desc *test, struct uffd_desc *pt_uffd,
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index b0e1fc4de9e29..6c2253f4a64ef 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -77,9 +77,15 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
>   		copy.mode = 0;
>   
>   		r = ioctl(uffd, UFFDIO_COPY, &copy);
> -		if (r == -1) {
> -			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d with errno: %d\n",
> -				addr, tid, errno);
> +		/*
> +		 * With multiple vCPU threads fault on a single page and there are
> +		 * multiple readers for the UFFD, at least one of the UFFDIO_COPYs
> +		 * will fail with EEXIST: handle that case without signaling an
> +		 * error.
> +		 */

But this code path is also gone through in other cases, isn't it? In
those cases, is it still safe to ignore EEXIST?

> +		if (r == -1 && errno != EEXIST) {
> +			pr_info("Failed UFFDIO_COPY in 0x%lx from thread %d, errno = %d\n",
> +					addr, tid, errno);

unintended indent changes I think.

>   			return r;
>   		}
>   	} else if (uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
> @@ -89,9 +95,10 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
>   		cont.range.len = demand_paging_size;
>   
>   		r = ioctl(uffd, UFFDIO_CONTINUE, &cont);
> -		if (r == -1) {
> -			pr_info("Failed UFFDIO_CONTINUE in 0x%lx from thread %d with errno: %d\n",
> -				addr, tid, errno);
> +		/* See the note about EEXISTs in the UFFDIO_COPY branch. */

Personally I would suggest copy the comments here. what if some day above
code/comment was changed/deleted?

> +		if (r == -1 && errno != EEXIST) {
> +			pr_info("Failed UFFDIO_CONTINUE in 0x%lx, thread %d, errno = %d\n",
> +					addr, tid, errno);

Ditto

>   			return r;
>   		}
>   	} else {
> @@ -110,7 +117,9 @@ static int handle_uffd_page_request(int uffd_mode, int uffd,
>   
>   struct test_params {
>   	int uffd_mode;
> +	bool single_uffd;
>   	useconds_t uffd_delay;
> +	int readers_per_uffd;
>   	enum vm_mem_backing_src_type src_type;
>   	bool partition_vcpu_memory_access;
>   };
> @@ -133,7 +142,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	struct timespec start;
>   	struct timespec ts_diff;
>   	struct kvm_vm *vm;
> -	int i;
> +	int i, num_uffds = 0;
> +	uint64_t uffd_region_size;
>   
>   	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
>   				 p->src_type, p->partition_vcpu_memory_access);
> @@ -146,10 +156,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   	memset(guest_data_prototype, 0xAB, demand_paging_size);
>   
>   	if (p->uffd_mode) {
> -		uffd_descs = malloc(nr_vcpus * sizeof(struct uffd_desc *));
> +		num_uffds = p->single_uffd ? 1 : nr_vcpus;
> +		uffd_region_size = nr_vcpus * guest_percpu_mem_size / num_uffds;
> +
> +		uffd_descs = malloc(num_uffds * sizeof(struct uffd_desc *));
>   		TEST_ASSERT(uffd_descs, "Memory allocation failed");
>   
> -		for (i = 0; i < nr_vcpus; i++) {
> +		for (i = 0; i < num_uffds; i++) {
>   			struct memstress_vcpu_args *vcpu_args;
>   			void *vcpu_hva;
>   			void *vcpu_alias;
> @@ -160,8 +173,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
>   			vcpu_alias = addr_gpa2alias(vm, vcpu_args->gpa);
>   
> -			prefault_mem(vcpu_alias,
> -				vcpu_args->pages * memstress_args.guest_page_size);
> +			prefault_mem(vcpu_alias, uffd_region_size);
>   
>   			/*
>   			 * Set up user fault fd to handle demand paging
> @@ -169,7 +181,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   			 */
>   			uffd_descs[i] = uffd_setup_demand_paging(
>   				p->uffd_mode, p->uffd_delay, vcpu_hva,
> -				vcpu_args->pages * memstress_args.guest_page_size,
> +				uffd_region_size,
> +				p->readers_per_uffd,
>   				&handle_uffd_page_request);
>   		}
>   	}
> @@ -186,7 +199,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   
>   	if (p->uffd_mode) {
>   		/* Tell the user fault fd handler threads to quit */
> -		for (i = 0; i < nr_vcpus; i++)
> +		for (i = 0; i < num_uffds; i++)
>   			uffd_stop_demand_paging(uffd_descs[i]);
>   	}
>   
> @@ -206,14 +219,19 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   static void help(char *name)
>   {
>   	puts("");
> -	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
> -	       "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
> +	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
> +		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
> +		   "          [-s type] [-v vcpus] [-o]\n", name);

Ditto

>   	guest_modes_help();
>   	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
>   	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> +	printf(" -a: Use a single userfaultfd for all of guest memory, instead of\n"
> +		   "     creating one for each region paged by a unique vCPU\n"
> +		   "     Set implicitly with -o, and no effect without -u.\n");

Ditto

>   	printf(" -d: add a delay in usec to the User Fault\n"
>   	       "     FD handler to simulate demand paging\n"
>   	       "     overheads. Ignored without -u.\n");
> +	printf(" -r: Set the number of reader threads per uffd.\n");
>   	printf(" -b: specify the size of the memory region which should be\n"
>   	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>   	       "     Default: 1G\n");
> @@ -231,12 +249,14 @@ int main(int argc, char *argv[])
>   	struct test_params p = {
>   		.src_type = DEFAULT_VM_MEM_SRC,
>   		.partition_vcpu_memory_access = true,
> +		.readers_per_uffd = 1,
> +		.single_uffd = false,
>   	};
>   	int opt;
>   
>   	guest_modes_append_default();
>   
> -	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
> +	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
>   		switch (opt) {
>   		case 'm':
>   			guest_modes_cmdline(optarg);
> @@ -248,6 +268,9 @@ int main(int argc, char *argv[])
>   				p.uffd_mode = UFFDIO_REGISTER_MODE_MINOR;
>   			TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISSING' or 'MINOR'.");
>   			break;
> +		case 'a':
> +			p.single_uffd = true;
> +			break;
>   		case 'd':
>   			p.uffd_delay = strtoul(optarg, NULL, 0);
>   			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
> @@ -265,6 +288,13 @@ int main(int argc, char *argv[])
>   			break;
>   		case 'o':
>   			p.partition_vcpu_memory_access = false;
> +			p.single_uffd = true;
> +			break;
> +		case 'r':
> +			p.readers_per_uffd = atoi(optarg);
> +			TEST_ASSERT(p.readers_per_uffd >= 1,
> +						"Invalid number of readers per uffd %d: must be >=1",
> +						p.readers_per_uffd);
>   			break;
>   		case 'h':
>   		default:
> diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> index 877449c345928..92cc1f9ec0686 100644
> --- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
> +++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> @@ -17,18 +17,30 @@
>   
>   typedef int (*uffd_handler_t)(int uffd_mode, int uffd, struct uffd_msg *msg);
>   
> +struct uffd_reader_args {
> +	int uffd_mode;
> +	int uffd;
> +	useconds_t delay;
> +	uffd_handler_t handler;
> +	/* Holds the read end of the pipe for killing the reader. */
> +	int pipe;
> +};
> +
>   struct uffd_desc {
>   	int uffd_mode;
>   	int uffd;
> -	int pipefds[2];
>   	useconds_t delay;
>   	uffd_handler_t handler;
> -	pthread_t thread;
> +	uint64_t num_readers;
> +	/* Holds the write ends of the pipes for killing the readers. */
> +	int *pipefds;
> +	pthread_t *readers;
> +	struct uffd_reader_args *reader_args;
>   };
>   
>   struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>   					   void *hva, uint64_t len,
> -					   uffd_handler_t handler);
> +					   uint64_t num_readers, uffd_handler_t handler);
>   
>   void uffd_stop_demand_paging(struct uffd_desc *uffd);
>   
> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> index 92cef20902f1f..2723ee1e3e1b2 100644
> --- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -27,10 +27,8 @@
>   
>   static void *uffd_handler_thread_fn(void *arg)
>   {
> -	struct uffd_desc *uffd_desc = (struct uffd_desc *)arg;
> -	int uffd = uffd_desc->uffd;
> -	int pipefd = uffd_desc->pipefds[0];
> -	useconds_t delay = uffd_desc->delay;
> +	struct uffd_reader_args *reader_args = (struct uffd_reader_args *)arg;
> +	int uffd = reader_args->uffd;
>   	int64_t pages = 0;
>   	struct timespec start;
>   	struct timespec ts_diff;
> @@ -44,7 +42,7 @@ static void *uffd_handler_thread_fn(void *arg)
>   
>   		pollfd[0].fd = uffd;
>   		pollfd[0].events = POLLIN;
> -		pollfd[1].fd = pipefd;
> +		pollfd[1].fd = reader_args->pipe;
>   		pollfd[1].events = POLLIN;
>   
>   		r = poll(pollfd, 2, -1);
> @@ -92,9 +90,9 @@ static void *uffd_handler_thread_fn(void *arg)
>   		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
>   			continue;
>   
> -		if (delay)
> -			usleep(delay);
> -		r = uffd_desc->handler(uffd_desc->uffd_mode, uffd, &msg);
> +		if (reader_args->delay)
> +			usleep(reader_args->delay);
> +		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
>   		if (r < 0)
>   			return NULL;
>   		pages++;
> @@ -110,7 +108,7 @@ static void *uffd_handler_thread_fn(void *arg)
>   
>   struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>   					   void *hva, uint64_t len,
> -					   uffd_handler_t handler)
> +					   uint64_t num_readers, uffd_handler_t handler)
>   {
>   	struct uffd_desc *uffd_desc;
>   	bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
> @@ -118,14 +116,26 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>   	struct uffdio_api uffdio_api;
>   	struct uffdio_register uffdio_register;
>   	uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
> -	int ret;
> +	int ret, i;
>   
>   	PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
>   		       is_minor ? "MINOR" : "MISSING",
>   		       is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
>   
>   	uffd_desc = malloc(sizeof(struct uffd_desc));
> -	TEST_ASSERT(uffd_desc, "malloc failed");
> +	TEST_ASSERT(uffd_desc, "Failed to malloc uffd descriptor");
> +
> +	uffd_desc->pipefds = malloc(sizeof(int) * num_readers);
> +	TEST_ASSERT(uffd_desc->pipefds, "Failed to malloc pipes");
> +
> +	uffd_desc->readers = malloc(sizeof(pthread_t) * num_readers);
> +	TEST_ASSERT(uffd_desc->readers, "Failed to malloc reader threads");
> +
> +	uffd_desc->reader_args = malloc(
> +		sizeof(struct uffd_reader_args) * num_readers);
> +	TEST_ASSERT(uffd_desc->reader_args, "Failed to malloc reader_args");
> +
> +	uffd_desc->num_readers = num_readers;
>   
>   	/* In order to get minor faults, prefault via the alias. */
>   	if (is_minor)
> @@ -148,18 +158,32 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>   	TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
>   		    expected_ioctls, "missing userfaultfd ioctls");
>   
> -	ret = pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
> -	TEST_ASSERT(!ret, "Failed to set up pipefd");
> -
>   	uffd_desc->uffd_mode = uffd_mode;
>   	uffd_desc->uffd = uffd;
>   	uffd_desc->delay = delay;
>   	uffd_desc->handler = handler;

Now that these info are encapsulated into reader args below, looks
unnecessary to have them in uffd_desc here.

> -	pthread_create(&uffd_desc->thread, NULL, uffd_handler_thread_fn,
> -		       uffd_desc);
>   
> -	PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
> -		       hva, hva + len);
> +	for (i = 0; i < uffd_desc->num_readers; ++i) {
> +		int pipes[2];
> +
> +		ret = pipe2((int *) &pipes, O_CLOEXEC | O_NONBLOCK);
> +		TEST_ASSERT(!ret, "Failed to set up pipefd %i for uffd_desc %p",
> +					i, uffd_desc);
> +
> +		uffd_desc->pipefds[i] = pipes[1];
> +
> +		uffd_desc->reader_args[i].uffd_mode = uffd_mode;
> +		uffd_desc->reader_args[i].uffd = uffd;
> +		uffd_desc->reader_args[i].delay = delay;
> +		uffd_desc->reader_args[i].handler = handler;
> +		uffd_desc->reader_args[i].pipe = pipes[0];
> +
> +		pthread_create(&uffd_desc->readers[i], NULL, uffd_handler_thread_fn,
> +					   &uffd_desc->reader_args[i]);
> +
> +		PER_VCPU_DEBUG("Created uffd thread %i for HVA range [%p, %p)\n",
> +					   i, hva, hva + len);
> +	}
>   
>   	return uffd_desc;
>   }
> @@ -167,19 +191,31 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
>   void uffd_stop_demand_paging(struct uffd_desc *uffd)
>   {
>   	char c = 0;
> -	int ret;
> +	int i, ret;
>   
> -	ret = write(uffd->pipefds[1], &c, 1);
> -	TEST_ASSERT(ret == 1, "Unable to write to pipefd");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = write(uffd->pipefds[i], &c, 1);
> +		TEST_ASSERT(
> +			ret == 1, "Unable to write to pipefd %i for uffd_desc %p", i, uffd);
> +	}
>   
> -	ret = pthread_join(uffd->thread, NULL);
> -	TEST_ASSERT(ret == 0, "Pthread_join failed.");
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		ret = pthread_join(uffd->readers[i], NULL);
> +		TEST_ASSERT(
> +			ret == 0,
> +			"Pthread_join failed on reader thread %i for uffd_desc %p", i, uffd);
> +	}
>   
>   	close(uffd->uffd);
>   
> -	close(uffd->pipefds[1]);
> -	close(uffd->pipefds[0]);
> +	for (i = 0; i < uffd->num_readers; ++i) {
> +		close(uffd->pipefds[i]);
> +		close(uffd->reader_args[i].pipe);
> +	}
>   
> +	free(uffd->pipefds);
> +	free(uffd->readers);
> +	free(uffd->reader_args);
>   	free(uffd);
>   }
>   

