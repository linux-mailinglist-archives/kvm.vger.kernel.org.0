Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EB36728F7
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjARUD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjARUD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:03:29 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869E65F39E;
        Wed, 18 Jan 2023 12:03:15 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id m15so95144ilq.2;
        Wed, 18 Jan 2023 12:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiVxuG8jgXwLBeU9Xb643dPVZKHVidgY4lujjD3tUC4=;
        b=Z1pv4yAHpgYzV3CYJsuAz3slpan88WdCCWEsxGupIu7y5OTzewQQct/1ZPMAwM8C45
         +sntpeZ142VwK7hk4y21HaeZdJ8SHmAdLpxG1anHr0A1ZLEBbJNl1bgPbmhix1Eqguvd
         VnoNpBECprgsCxCI9n+NzenIqVC2w5gCRFUmOGDVppiQl9PVZBhP12gOF2RGg0RvBxe6
         /M2asQRdh/l8LF4U/EEfygHY2uRRLhi5GuuFxj1C0U8gHzdWUB/5q2D9CgrlJuFgIx+b
         3P5L+2YVrVZ5RL6ApK8NQEaProWSBoRRhqlQU5ByKGZrMU3v0CS5aBkMdPifm6GiPnTe
         Y2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiVxuG8jgXwLBeU9Xb643dPVZKHVidgY4lujjD3tUC4=;
        b=xWSIZB22PnAw6EbTRICyjHLw/MoCkgjLswiXsawLKDBEswWmoympMxfmdmC7JW1Lij
         GX7zQTAfzlJ7oGFDPimDyYbJ1To3477/Zy6pg7UrzSvNcCu91Cpt+gvh7l8eC7VWswP2
         iGEO9tJim++QwLoDtbC7KFQ7IBT5y8VsnCCOvyMT4kQxb5nv15e4gyVSl8f6fDfw9a75
         UcLYT/ZcRadwyLlOu5BG58LpPTxGvjJM9REq6KoQpEkdfgmmTEG515exCOWPIwlkp2vm
         D5vk9wuKD6mdomtj+Oowis0/7C3mQeZo9gLQj17l920/CrNQcGSg0W04Bax7a4lTtqd9
         9k0w==
X-Gm-Message-State: AFqh2kpUyDEYD/iCGr6XCd+RmBCFl2G2+7EUiCtMhc5YoX1nAJ8pdjjo
        xe0NSqxrYlsrUfnDtH7R7SL8V/pFLn4=
X-Google-Smtp-Source: AMrXdXvOCjTzRHFG4DHtmcU1JarHRcv/I9h/rHKbzZ8jvw9J3Y6A3sIyUPZaECz1dylkiE+lj90j7A==
X-Received: by 2002:a92:d6cd:0:b0:30e:cd95:c25b with SMTP id z13-20020a92d6cd000000b0030ecd95c25bmr1263778ilp.0.1674072194845;
        Wed, 18 Jan 2023 12:03:14 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h31-20020a056638339f00b00371caa7ef7csm5418976jav.2.2023.01.18.12.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:03:14 -0800 (PST)
Date:   Wed, 18 Jan 2023 22:03:07 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU
 cap KVM_CAP_X86_DISABLE_EXITS
Message-ID: <20230118220307.0000256c@gmail.com>
In-Reply-To: <20230113220114.2437-7-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
        <20230113220114.2437-7-kechenl@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 22:01:14 +0000
Kechen Lu <kechenl@nvidia.com> wrote:

I think I figure out why this test case doesn't work:

The 2nd case always hangs because:

1) Unlike the 1st case in which a halter and an IPI sender will be created,
there is only halter thread created in the 2nd case.
2) The halter enables KVM_X86_DISABLE_EXITS_HLT. Thus, HLT will not cause VMEXIT
3) The halter stuck in the halter_waiting_guest_code(). data->hlt_count is
always 1 and data->wake_count is always 0.
4) In the main thread, you have test_vm_disable_exits_cap() -> 
                         while (data->hlt_count < COUNT_HLT_EXITS);

As data->hlt_count will never increase in the vcpu_thread, the main thread
always stuck in the while loop.

Can you explain more about your thoughts of designing this test case?

> Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
> in VM and vCPU scope both works as expected.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
> Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/disable_exits_test.c | 457 ++++++++++++++++++
>  2 files changed, 458 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 1750f91dd936..eeeba35e2536 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -114,6 +114,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
>  TEST_GEN_PROGS_x86_64 += x86_64/amx_test
>  TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
>  TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
> +TEST_GEN_PROGS_x86_64 += x86_64/disable_exits_test
>  TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86_64 += demand_paging_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> new file mode 100644
> index 000000000000..dceba3bcef5f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> @@ -0,0 +1,457 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test per-VM and per-vCPU disable exits cap
> + * 1) Per-VM scope 
> + * 2) Per-vCPU scope
> + *
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <pthread.h>
> +#include <inttypes.h>
> +#include <string.h>
> +#include <time.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "svm_util.h"
> +#include "vmx.h"
> +#include "processor.h"
> +#include "asm/kvm.h"
> +#include "linux/kvm.h"
> +
> +/* Arbitary chosen IPI vector value from sender to halter vCPU */
> +#define IPI_VECTOR	 0xa5
> +/* Number of HLTs halter vCPU thread executes */
> +#define COUNT_HLT_EXITS	 10
> +
> +struct guest_stats {
> +	uint32_t halter_apic_id;
> +	volatile uint64_t hlt_count;
> +	volatile uint64_t wake_count;
> +};
> +
> +static u64 read_vcpu_stats_halt_exits(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct kvm_stats_header header;
> +	u64 *stats_data;
> +	u64 ret = 0;
> +	struct kvm_stats_desc *stats_desc;
> +	struct kvm_stats_desc *pdesc;
> +	int stats_fd = vcpu_get_stats_fd(vcpu);
> +
> +	read_stats_header(stats_fd, &header);
> +	if (header.num_desc == 0) {
> +		fprintf(stderr,
> +			"Cannot read halt exits since no KVM stats defined\n");
> +		return ret;
> +	}
> +
> +	stats_desc = read_stats_descriptors(stats_fd, &header);
> +	for (i = 0; i < header.num_desc; ++i) {
> +		pdesc = get_stats_descriptor(stats_desc, i, &header);
> +		if (!strncmp(pdesc->name, "halt_exits", 10)) {
> +			stats_data = malloc(pdesc->size * sizeof(*stats_data));
> +			read_stat_data(stats_fd, &header, pdesc, stats_data,
> +				pdesc->size);
> +			ret = *stats_data;
> +			free(stats_data);
> +			break;
> +		}
> +	}
> +	free(stats_desc);
> +	return ret;
> +}
> +
> +/* HLT multiple times in one vCPU */
> +static void halter_guest_code(struct guest_stats *data)
> +{
> +	xapic_enable();
> +	data->halter_apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> +
> +	for (;;) {
> +		data->hlt_count++;
> +		asm volatile("sti; hlt; cli");
> +		data->wake_count++;
> +	}
> +}
> +
> +static void halter_waiting_guest_code(struct guest_stats *data)
> +{
> +	uint64_t tsc_start = rdtsc();
> +
> +	xapic_enable();
> +	data->halter_apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
> +
> +	for (;;) {
> +		data->hlt_count++;
> +		asm volatile("sti; hlt; cli");
> +		data->wake_count++;
> +		/* Wait for ~0.5sec for each HLT execution */
> +		tsc_start = rdtsc();
> +		while (rdtsc() - tsc_start < 2000000000);
> +	}
> +}
> +
> +/* Runs on halter vCPU when IPI arrives */
> +static void guest_ipi_handler(struct ex_regs *regs)
> +{
> +	xapic_write_reg(APIC_EOI, 11);
> +}
> +
> +/* Sender vCPU waits for ~1sec to assume HLT executed */
> +static void sender_wait_loop(struct guest_stats *data, uint64_t old_hlt_count,
> +		uint64_t old_wake_count)
> +{
> +	uint64_t tsc_start = rdtsc();
> +	while (rdtsc() - tsc_start < 4000000000);
> +	GUEST_ASSERT((data->wake_count != old_wake_count) &&
> +		       	(data->hlt_count != old_hlt_count));
> +}
> +
> +/* Sender vCPU loops sending IPI to halter vCPU every ~1sec */
> +static void sender_guest_code(struct guest_stats *data)
> +{
> +	uint32_t icr_val;
> +	uint32_t icr2_val;
> +	uint64_t old_hlt_count = 0;
> +	uint64_t old_wake_count = 0;
> +
> +	xapic_enable();
> +	/* Init interrupt command register for sending IPIs */
> +	icr_val = (APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR);
> +	icr2_val = SET_APIC_DEST_FIELD(data->halter_apic_id);
> +
> +	for (;;) {
> +		/*
> +		 * Send IPI to halted vCPU
> +		 * First IPI sends here as already waited before sender vCPU
> +		 * thread creation
> +		 */
> +		xapic_write_reg(APIC_ICR2, icr2_val);
> +		xapic_write_reg(APIC_ICR, icr_val);
> +		sender_wait_loop(data, old_hlt_count, old_wake_count);
> +		GUEST_ASSERT((data->wake_count != old_wake_count) &&
> +			(data->hlt_count != old_hlt_count));
> +		old_wake_count = data->wake_count;
> +		old_hlt_count = data->hlt_count;
> +	}
> +}
> +
> +static void *vcpu_thread(void *arg)
> +{
> +	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)arg;
> +	int old;
> +	int r;
> +
> +	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	TEST_ASSERT(r == 0,
> +		"pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
> +	       	vcpu->id, r);
> +	fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
> +	vcpu_run(vcpu);
> +	return NULL;
> +}
> +
> +static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
> +{
> +	void *retval;
> +	int r;
> +
> +	r = pthread_cancel(thread);
> +	TEST_ASSERT(r == 0,
> +		"pthread_cancel on vcpu_id=%d failed with errno=%d",
> +		vcpu->id, r);
> +
> +	r = pthread_join(thread, &retval);
> +	TEST_ASSERT(r == 0,
> +		"pthread_join on vcpu_id=%d failed with errno=%d",
> +		vcpu->id, r);
> +}
> +
> +/*
> + * Test case 1:
> + * Normal VM running with one vCPU keeps executing HLTs,
> + * another vCPU sending IPIs to wake it up, should expect
> + * all HLTs exiting to host
> + */
> +static void test_vm_without_disable_exits_cap(void)
> +{
> +	int r;
> +	int wait_secs;
> +	const int first_halter_wait = 10;
> +	uint64_t kvm_halt_exits;
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *halter_vcpu;
> +	struct kvm_vcpu *sender_vcpu;
> +	struct guest_stats *data;
> +	vm_vaddr_t guest_stats_page_vaddr;
> +	pthread_t threads[2];
> +
> +	/* Create VM */
> +	vm = vm_create(2);
> +
> +	/* Add vCPU with loops halting */
> +	halter_vcpu = vm_vcpu_add(vm, 0, halter_guest_code);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(halter_vcpu);
> +	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	/* Add vCPU with IPIs waking up halter vCPU */
> +	sender_vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
> +
> +	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
> +	data = addr_gva2hva(vm, guest_stats_page_vaddr);
> +	memset(data, 0, sizeof(*data));
> +
> +	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> +	vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> +
> +	/* Start halter vCPU thread and wait for it to execute first HLT. */
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
> +	TEST_ASSERT(r == 0,
> +		"pthread_create halter failed errno=%d", errno);
> +	fprintf(stderr, "Halter vCPU thread started\n");
> +
> +	wait_secs = 0;
> +	while ((wait_secs < first_halter_wait) && !data->hlt_count) {
> +		sleep(1);
> +		wait_secs++;
> +	}
> +	TEST_ASSERT(data->hlt_count,
> +		"Halter vCPU did not execute first HLT within %d seconds",
> +	       	first_halter_wait);
> +	fprintf(stderr,
> +		"Halter vCPU thread reported its first HLT executed "
> +	       	"after %d seconds.\n",
> +		wait_secs);
> +
> +	/* 
> +	 * After guest halter vCPU executed first HLT, start the sender
> +	 * vCPU thread to wakeup halter vCPU
> +	 */
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
> +	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
> +
> +	while (data->hlt_count < COUNT_HLT_EXITS);
> +
> +	cancel_join_vcpu_thread(threads[0], halter_vcpu);
> +	cancel_join_vcpu_thread(threads[1], sender_vcpu);
> +
> +	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
> +	TEST_ASSERT(kvm_halt_exits == data->hlt_count,
> +		"Halter vCPU had unmatched %lu halt exits - %lu HLTs "
> +		"executed, when not disabling VM halt exits\n",
> +	       	kvm_halt_exits, data->hlt_count);
> +	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> +		kvm_halt_exits);
> +	fprintf(stderr, "Guest records %lu HLTs executed, "
> +		"waked %lu times\n",
> +		data->hlt_count, data->wake_count);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +/*
> + * Test case 2:
> + * VM scoped exits disabling, HLT instructions
> + * stay inside guest without exits
> + */
> +static void test_vm_disable_exits_cap(void)
> +{
> +	int r;
> +	uint64_t kvm_halt_exits;
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *halter_vcpu;
> +	struct guest_stats *data;
> +	vm_vaddr_t guest_stats_page_vaddr;
> +	pthread_t halter_thread;
> +
> +	/* Create VM */
> +	vm = vm_create(1);
> +
> +	/*
> +	 * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS cap
> +	 * with flag KVM_X86_DISABLE_EXITS_HLT
> +	 */
> +	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> +		KVM_X86_DISABLE_EXITS_HLT);
> +
> +	/* Add vCPU with loops halting */
> +	halter_vcpu = vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(halter_vcpu);
> +	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
> +	data = addr_gva2hva(vm, guest_stats_page_vaddr);
> +	memset(data, 0, sizeof(*data));
> +	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> +
> +	/* Start halter vCPU thread and execute HLTs immediately */
> +	r = pthread_create(&halter_thread, NULL, vcpu_thread, halter_vcpu);
> +	TEST_ASSERT(r == 0,
> +		"pthread_create halter failed errno=%d", errno);
> +	fprintf(stderr, "Halter vCPU thread started\n");
> +
> +	while (data->hlt_count < COUNT_HLT_EXITS);
> +
> +	cancel_join_vcpu_thread(halter_thread, halter_vcpu);
> +
> +	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
> +	TEST_ASSERT(kvm_halt_exits == 0,
> +		"Halter vCPU had unexpected halt exits occuring after "
> +		"disabling VM-scoped halt exits cap\n");
> +	fprintf(stderr, "Halter vCPU had %lu HLT exits\n",
> +		kvm_halt_exits);
> +	fprintf(stderr, "Guest records %lu HLTs executed\n",
> +		data->hlt_count);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +/*
> + * Test case 3:
> + * VM overrides exits disable flags after vCPU created,
> + * which is not allowed
> + */
> +static void test_vm_disable_exits_cap_with_vcpu_created(void)
> +{
> +	int r;
> +	struct kvm_vm *vm;
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_X86_DISABLE_EXITS,
> +		.args[0] = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE,
> +	};
> +
> +	/* Create VM */
> +	vm = vm_create(1);
> +	/* Add vCPU with loops halting */
> +	vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> +
> +	/*
> +	 * After creating vCPU, the current VM-scoped ABI should 
> +	 * discard the cap enable of KVM_CAP_X86_DISABLE_EXITS
> +	 * and return non-zero. Since vm_enabled_cap() not able
> +	 * to assert the return value, so use the __vm_ioctl()
> +	 */
> +	r = __vm_ioctl(vm, KVM_ENABLE_CAP, &cap);
> +
> +	TEST_ASSERT(r != 0,
> +		"Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after "
> +		"vCPUs created is not allowed, but it succeeds here\n");
> +}
> +
> +/*
> + * Test case 4:
> + * vCPU scoped halt exits disabling and enabling tests,
> + * verify overides are working after vCPU created
> + */
> +static void test_vcpu_toggling_disable_exits_cap(void)
> +{
> +	int r;
> +	uint64_t kvm_halt_exits;
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *halter_vcpu;
> +	struct kvm_vcpu *sender_vcpu;
> +	struct guest_stats *data;
> +	vm_vaddr_t guest_stats_page_vaddr;
> +	pthread_t threads[2];
> +
> +	/* Create VM */
> +	vm = vm_create(2);
> +
> +	/* Add vCPU with loops halting */
> +	halter_vcpu = vm_vcpu_add(vm, 0, halter_waiting_guest_code);
> +	/* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
> +	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> +		KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(halter_vcpu);
> +	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
> +
> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	/* Add vCPU with IPIs waking up halter vCPU */
> +	sender_vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
> +
> +	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
> +	data = addr_gva2hva(vm, guest_stats_page_vaddr);
> +	memset(data, 0, sizeof(*data));
> +
> +	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
> +	vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
> +
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
> +	TEST_ASSERT(r == 0,
> +		"pthread_create halter failed errno=%d", errno);
> +	fprintf(stderr, "Halter vCPU thread started with halt exits"
> +		"disabled\n");
> +
> +	/* 
> +	 * For the first phase of the running, halt exits
> +	 * are disabled, halter vCPU executes HLT instruction
> +	 * but never exits to host
> +	 */
> +	while (data->hlt_count < (COUNT_HLT_EXITS / 2));
> +
> +	cancel_join_vcpu_thread(threads[0], halter_vcpu);
> +	/* 
> +	 * Override and clean KVM_CAP_X86_DISABLE_EXITS flags 
> +	 * for halter vCPU. Expect to see halt exits occurs then.
> +	 */
> +	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> +		KVM_X86_DISABLE_EXITS_OVERRIDE);
> +
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
> +	TEST_ASSERT(r == 0,
> +		"pthread_create halter failed errno=%d", errno);
> +	fprintf(stderr, "Halter vCPU thread restarted and cleared "
> +		"halt exits flag\n");
> +
> +	sleep(1);
> +	/* 
> +	 * Second phase of the test, after guest halter vCPU
> +	 * reenabled halt exits, start the sender
> +	 * vCPU thread to wakeup halter vCPU
> +	 */
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
> +	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
> +
> +	while (data->hlt_count < COUNT_HLT_EXITS);
> +
> +	cancel_join_vcpu_thread(threads[0], halter_vcpu);
> +	cancel_join_vcpu_thread(threads[1], sender_vcpu);
> +
> +	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
> +	TEST_ASSERT(kvm_halt_exits == (COUNT_HLT_EXITS / 2),
> +		"Halter vCPU had unexpected %lu halt exits, "
> +		"there should be %d halt exits while "
> +		"not disabling VM halt exits\n",
> +	       	kvm_halt_exits, COUNT_HLT_EXITS / 2);
> +	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> +		kvm_halt_exits);
> +	fprintf(stderr, "Guest records %lu HLTs executed, "
> +		"waked %lu times\n",
> +		data->hlt_count, data->wake_count);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	fprintf(stderr, "VM-scoped tests start\n");
> +	test_vm_without_disable_exits_cap();
> +	test_vm_disable_exits_cap();
> +	test_vm_disable_exits_cap_with_vcpu_created();
> +	fprintf(stderr, "vCPU-scoped test starts\n");
> +	test_vcpu_toggling_disable_exits_cap();
> +	return 0;
> +}

