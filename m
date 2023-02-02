Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16BC688149
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 16:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjBBPJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 10:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjBBPJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 10:09:17 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0A6945E4;
        Thu,  2 Feb 2023 07:08:43 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id u7so857175ilg.4;
        Thu, 02 Feb 2023 07:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r10iloJfhw6nFVH1YorP9IFzQtnwI610yCRf3peuVJw=;
        b=Q717smR+L9VTpLBs/UbSO3utP6NbFXm5iR6bcYOtTF/THwk9WPz82hFqAy3kTNYXY1
         ZiqvVYrtGNG+jKv/bs5qwrMWx9VG2shJ2AR7wSVB+TON6TguhPC5FH9hiX78nH3San7F
         eAOCDTwGh0fI/p6cKil8x1PC6369xtOzkVdv7xOduGmfCuDSDRFx1CahpDcSoOl2qTb4
         6z+es6ef2YD+PGwqKub5Nfku5GD6ae83MVRtD3q9JC6GIJdSYc91oNOMY4h5k5XtIGZd
         vToRpqKOpvTBq6B3DOUl+y8F17DfutIghco2YpK0A2Gib91vQaYvQFSeq7BJSCl79cEx
         hUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r10iloJfhw6nFVH1YorP9IFzQtnwI610yCRf3peuVJw=;
        b=s3h9504PHdzGT+7M63VzYxP1fa72JtqWqwU1PDOz/8ErRjFZMv/j9KJj1Q/ELk07+U
         TdENcW4aEm7yte0xbGCymBEbM66bfCQBq8+mZn8WLjy7ai2bbS6lm1FjH6uv5hTV729E
         eJXAKo9M3sWGJAK+rNM8kEj8QJjc/cxEyJxTPGEaMHFWDxXca1EOhPWjWL0GwMT6Dn9l
         f/hvD91imClVBS7foDfTEtVTU3GBbRtPQz44bE1fSQFRMcjOtrASoWkgf+Ed+XBrn8mq
         JCIsDC0Mdgxoteof5tl4/os6OwAKvheBnQz4WRwcQmj8tvFI66ypAvRRDt8Z8eDdUqvz
         +Rhw==
X-Gm-Message-State: AO0yUKVF7AToLMY1M/kQA67TExFUGe32EL6uC/dso5KSL3IzcP014/Oy
        gnTSOc5lOpxg7wSUsa6hGks=
X-Google-Smtp-Source: AK7set8GzQ6FsHNt+9XsIeJNHVXwrMZ4X8n/VVOgWWnPsge/4KtcFUw7lQocp/iq74j840b33Q2qug==
X-Received: by 2002:a05:6e02:110f:b0:30e:f89b:6652 with SMTP id u15-20020a056e02110f00b0030ef89b6652mr3128569ilk.0.1675350521278;
        Thu, 02 Feb 2023 07:08:41 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id c10-20020a056638028a00b0037cb59b5c28sm3802880jaq.52.2023.02.02.07.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 07:08:40 -0800 (PST)
Date:   Thu, 2 Feb 2023 17:08:36 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 6/6] KVM: selftests: Add tests for VM and vCPU
 cap KVM_CAP_X86_DISABLE_EXITS
Message-ID: <20230202170836.000078f1@gmail.com>
In-Reply-To: <20230121020738.2973-7-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
        <20230121020738.2973-7-kechenl@nvidia.com>
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

On Sat, 21 Jan 2023 02:07:38 +0000
Kechen Lu <kechenl@nvidia.com> wrote:

It works on my box now. LGTM. I was curious if there is any other userspace
application using this? It would be interesting to see their strategies.

> Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
> in VM and vCPU scope both working as expected.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
> Suggested-by: Zhi Wang <zhi.wang.linux@gmail.com>
> Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/disable_exits_test.c | 363 ++++++++++++++++++
>  2 files changed, 364 insertions(+)
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
> index 000000000000..74a2152b35dd
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> @@ -0,0 +1,363 @@
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
> +/* Arbitrary chosen IPI vector value from sender to halter vCPU */
> +#define IPI_VECTOR	 0xa5
> +/* Number of HLTs halter vCPU thread executes */
> +#define LOOP_DURATION	 3
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
> +
> +	while (rdtsc() - tsc_start < 4000000000) {
> +		if ((data->wake_count != old_wake_count) &&
> +			(data->hlt_count != old_hlt_count))
> +			break;
> +	}
> +	GUEST_ASSERT((data->wake_count != old_wake_count) &&
> +			(data->hlt_count != old_hlt_count));
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
> +		vcpu->id, r);
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
> +static void vm_run_with_threads(struct kvm_vcpu *halter_vcpu,
> +		struct kvm_vcpu *sender_vcpu)
> +{
> +	int r;
> +	pthread_t threads[2];
> +
> +	/* Start halter vCPU thread and wait for it to execute first HLT. */
> +	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
> +	TEST_ASSERT(r == 0,
> +		"pthread_create halter failed errno=%d", errno);
> +	fprintf(stderr, "Halter vCPU thread started\n");
> +
> +	sleep(1);
> +
> +	/*
> +	 * After guest halter vCPU executed first HLT, start the sender
> +	 * vCPU thread to wakeup halter vCPU
> +	 */
> +	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
> +	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
> +
> +	sleep(LOOP_DURATION);
> +
> +	cancel_join_vcpu_thread(threads[0], halter_vcpu);
> +	cancel_join_vcpu_thread(threads[1], sender_vcpu);
> +}
> +
> +/*
> + * Test case 1:
> + * Normal VM running with one vCPU keeps executing HLTs,
> + * another vCPU sending IPIs to wake it up, should expect
> + * all HLTs exiting to host
> + * and Test case 2:
> + * VM scoped exits disabling, HLT instructions
> + * stay inside guest without exits
> + */
> +static void test_vm_disable_exits_cap(bool cap_enabled)
> +{
> +	uint64_t kvm_halt_exits;
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *halter_vcpu;
> +	struct kvm_vcpu *sender_vcpu;
> +	struct guest_stats *data;
> +	vm_vaddr_t guest_stats_page_vaddr;
> +
> +	/* Create VM */
> +	vm = vm_create(2);
> +
> +	/*
> +	 * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS cap
> +	 * with flag KVM_X86_DISABLE_EXITS_HLT
> +	 */
> +	if (cap_enabled)
> +		vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> +			KVM_X86_DISABLE_EXITS_HLT);
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
> +	vm_run_with_threads(halter_vcpu, sender_vcpu);
> +	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
> +	if (cap_enabled)
> +		TEST_ASSERT(kvm_halt_exits == 0,
> +		"Halter vCPU had unexpected halt exits occurring after disabling VM-scoped halt exits cap\n");
> +	else
> +		TEST_ASSERT(kvm_halt_exits == data->hlt_count,
> +		"Halter vCPU had unmatched %lu halt exits - %lu HLTs executed, when not disabling VM halt exits\n",
> +		kvm_halt_exits, data->hlt_count);
> +	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> +		kvm_halt_exits);
> +	fprintf(stderr, "Guest records %lu HLTs executed, waked %lu times\n",
> +		data->hlt_count, data->wake_count);
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
> +	vm_vcpu_add(vm, 0, halter_guest_code);
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
> +		"Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after vCPUs created is not allowed, but it succeeds here\n");
> +}
> +
> +/*
> + * Test case 4:
> + * vCPU scoped halt exits disabling and enabling tests,
> + * verify overides are working after vCPU created
> + */
> +static void test_vcpu_toggling_disable_exits_cap(void)
> +{
> +	uint64_t kvm_halt_exits;
> +	uint64_t kvm_halt_exits_in_guest;
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *halter_vcpu;
> +	struct kvm_vcpu *sender_vcpu;
> +	struct guest_stats *data;
> +	vm_vaddr_t guest_stats_page_vaddr;
> +
> +	/* Create VM */
> +	vm = vm_create(2);
> +
> +	/* Add vCPU with loops halting */
> +	halter_vcpu = vm_vcpu_add(vm, 0, halter_guest_code);
> +	/* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
> +	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> +		KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE);
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
> +	/*
> +	 * For the first phase of the running, halt exits
> +	 * are disabled, halter vCPU executes HLT instruction
> +	 * but never exits to host
> +	 */
> +	vm_run_with_threads(halter_vcpu, sender_vcpu);
> +	kvm_halt_exits_in_guest = data->hlt_count;
> +	fprintf(stderr, "Guest records %lu HLTs with halt exits disabled\n",
> +		data->hlt_count);
> +	/*
> +	 * Override and clean KVM_CAP_X86_DISABLE_EXITS flags
> +	 * for halter vCPU. Expect to see halt exits occurs then.
> +	 */
> +	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
> +		KVM_X86_DISABLE_EXITS_OVERRIDE);
> +	/*
> +	 * Second phase of the test, after guest halter vCPU
> +	 * reenabled halt exits, start the sender
> +	 * vCPU thread to wakeup halter vCPU
> +	 */
> +	vm_run_with_threads(halter_vcpu, sender_vcpu);
> +	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
> +	TEST_ASSERT(kvm_halt_exits == data->hlt_count - kvm_halt_exits_in_guest,
> +		"Halter vCPU had unexpected %lu (should be %lu) halt exits\n",
> +		kvm_halt_exits, data->hlt_count - kvm_halt_exits_in_guest);
> +	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
> +		kvm_halt_exits);
> +	fprintf(stderr, "Guest records %lu HLTs executed, waked %lu times\n",
> +		data->hlt_count, data->wake_count);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	fprintf(stderr, "VM-scoped tests start\n");
> +	test_vm_disable_exits_cap(false);
> +	test_vm_disable_exits_cap(true);
> +	test_vm_disable_exits_cap_with_vcpu_created();
> +	fprintf(stderr, "vCPU-scoped test starts\n");
> +	test_vcpu_toggling_disable_exits_cap();
> +	return 0;
> +}

