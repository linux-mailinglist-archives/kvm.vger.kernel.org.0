Return-Path: <kvm+bounces-48800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA29AD30BD
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 10:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D6CF188FF9B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF7E280005;
	Tue, 10 Jun 2025 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VmWKb/7N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206771DD9D3;
	Tue, 10 Jun 2025 08:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749544956; cv=none; b=pb9dThWMy9F029j8McvBhTz4pzBNVdcHj6MaCUc/+2KCeK4kP+3ZYf0XifSwUiqxu18EKzMpBybYb19L7rrVrK3IhbRAMShZ3keOLgsamDL+4dia3p9yadEJkbAAbFC/Lsk+EnAZR83ebDpbIn5MSu0ZZB9Hc5BT8gNLbUB579g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749544956; c=relaxed/simple;
	bh=WUurtHlZl4cO07q4cNhak6zc66i0f6kHUn1JCxCVaSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uAvbomeYkPA62fE55HV1YLgMTznP4ZZee6vLhGRgth3lOuITWhdvu9+h2vec8/5D6pzBTSy6lVuZvAqbdHxu/tHE+U/3W6nOHaAFR0GEzF0jNkk2OolAmrGWDxnAUbzuCRl3LbQex9iwpu/tnx+JxQsoRm1ntuUoGJFjVWcy4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VmWKb/7N; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749544956; x=1781080956;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=WUurtHlZl4cO07q4cNhak6zc66i0f6kHUn1JCxCVaSA=;
  b=VmWKb/7N+H1JvQcWzLmgqxBrX2/qlHNuZWZzF9YGBBKJfGZojfEywPzA
   EJ128PCFq0gfW48+M69aM6O2XdRg80idRyqdFA4OTcD6I/P224g4aVKa5
   L6Jtd/9fbHjwDWdmVHrUd16AuoaV7q6w2IroU24JgzTWqv+2Xm9F4Dvgc
   sQj/b+tTC2xfRf0TOdoUoAmTBusTSjD4+ZWV3Aag/H3RxR4VX7RQ9aQPf
   CANSMlaa5fVIcA/and/oOFrcz8QdpGF2CNXCgjPjbewNM0PEwtpL9KKms
   RH+hxyVC0qEEGcFmwrV9cuvvENOcn2PnFZgVn/qjPbueDy9s09gV5celg
   A==;
X-CSE-ConnectionGUID: efIY7f4rQeypkgzS+Du5sQ==
X-CSE-MsgGUID: 0WD1/uxnRwm1/xfA8Ps1wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51353426"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="51353426"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 01:42:35 -0700
X-CSE-ConnectionGUID: znwp2azGRUyEOd9NKPjhNg==
X-CSE-MsgGUID: k8eUFTqiSnqHlGGcfOV1UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="146683403"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 01:42:33 -0700
Message-ID: <574f8adc-6aea-4460-9211-685091a30f5e@linux.intel.com>
Date: Tue, 10 Jun 2025 16:42:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of
 KVM_X86_DISABLE_EXITS_APERFMPERF
To: Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250530185239.2335185-1-jmattson@google.com>
 <20250530185239.2335185-4-jmattson@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250530185239.2335185-4-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/31/2025 2:52 AM, Jim Mattson wrote:
> For a VCPU thread pinned to a single LPU, verify that interleaved host
> and guest reads of IA32_[AM]PERF return strictly increasing values when
> APERFMPERF exiting is disabled.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +++
>  .../selftests/kvm/x86/aperfmperf_test.c       | 132 ++++++++++++++++++
>  4 files changed, 152 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 3e786080473d..8d42a3bd0dd8 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -131,6 +131,7 @@ TEST_GEN_PROGS_x86 += x86/amx_test
>  TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
>  TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
>  TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
> +TEST_GEN_PROGS_x86 += x86/aperfmperf_test
>  TEST_GEN_PROGS_x86 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86 += coalesced_io_test
>  TEST_GEN_PROGS_x86 += dirty_log_perf_test
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 93013564428b..43a1bef10ec0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1158,4 +1158,6 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> +int pin_task_to_one_cpu(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5649cf2f40e8..b6c707ab92d7 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -10,6 +10,7 @@
>  #include "ucall_common.h"
>  
>  #include <assert.h>
> +#include <pthread.h>
>  #include <sched.h>
>  #include <sys/mman.h>
>  #include <sys/resource.h>
> @@ -2321,3 +2322,19 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
>  	pg = paddr >> vm->page_shift;
>  	return sparsebit_is_set(region->protected_phy_pages, pg);
>  }
> +
> +int pin_task_to_one_cpu(void)
> +{
> +	int cpu = sched_getcpu();
> +	cpu_set_t cpuset;
> +	int rc;
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(cpu, &cpuset);
> +
> +	rc = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> +	TEST_ASSERT(rc == 0, "%s: Can't set thread affinity", __func__);
> +
> +	return cpu;
> +}
> +
> diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
> new file mode 100644
> index 000000000000..64d976156693
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test for KVM_X86_DISABLE_EXITS_APERFMPERF
> + *
> + * Copyright (C) 2025, Google LLC.
> + *
> + * Test the ability to disable VM-exits for rdmsr of IA32_APERF and
> + * IA32_MPERF. When these VM-exits are disabled, reads of these MSRs
> + * return the host's values.
> + *
> + * Note: Requires read access to /dev/cpu/<lpu>/msr to read host MSRs.
> + */
> +
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +#include <asm/msr-index.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define NUM_ITERATIONS 100
> +
> +static int open_dev_msr(int cpu)
> +{
> +	char path[PATH_MAX];
> +
> +	snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
> +	return open_path_or_exit(path, O_RDONLY);
> +}
> +
> +static uint64_t read_dev_msr(int msr_fd, uint32_t msr)
> +{
> +	uint64_t data;
> +	ssize_t rc;
> +
> +	rc = pread(msr_fd, &data, sizeof(data), msr);
> +	TEST_ASSERT(rc == sizeof(data), "Read of MSR 0x%x failed", msr);
> +
> +	return data;
> +}
> +
> +static void guest_code(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < NUM_ITERATIONS; i++)
> +		GUEST_SYNC2(rdmsr(MSR_IA32_APERF), rdmsr(MSR_IA32_MPERF));
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	uint64_t host_aperf_before, host_mperf_before;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int msr_fd;
> +	int cpu;
> +	int i;
> +
> +	cpu = pin_task_to_one_cpu();
> +
> +	msr_fd = open_dev_msr(cpu);
> +
> +	/*
> +	 * This test requires a non-standard VM initialization, because
> +	 * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
> +	 * a VCPU has been created.
> +	 */
> +	vm = vm_create(1);
> +
> +	TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
> +		     KVM_X86_DISABLE_EXITS_APERFMPERF);
> +
> +	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> +		      KVM_X86_DISABLE_EXITS_APERFMPERF);
> +
> +	vcpu = vm_vcpu_add(vm, 0, guest_code);
> +
> +	host_aperf_before = read_dev_msr(msr_fd, MSR_IA32_APERF);
> +	host_mperf_before = read_dev_msr(msr_fd, MSR_IA32_MPERF);
> +
> +	for (i = 0; i < NUM_ITERATIONS; i++) {
> +		uint64_t host_aperf_after, host_mperf_after;
> +		uint64_t guest_aperf, guest_mperf;
> +		struct ucall uc;
> +
> +		vcpu_run(vcpu);
> +		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +		case UCALL_SYNC:
> +			guest_aperf = uc.args[0];
> +			guest_mperf = uc.args[1];
> +
> +			host_aperf_after = read_dev_msr(msr_fd, MSR_IA32_APERF);
> +			host_mperf_after = read_dev_msr(msr_fd, MSR_IA32_MPERF);
> +
> +			TEST_ASSERT(host_aperf_before < guest_aperf,
> +				    "APERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
> +				    host_aperf_before, guest_aperf);
> +			TEST_ASSERT(guest_aperf < host_aperf_after,
> +				    "APERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
> +				    guest_aperf, host_aperf_after);
> +			TEST_ASSERT(host_mperf_before < guest_mperf,
> +				    "MPERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
> +				    host_mperf_before, guest_mperf);
> +			TEST_ASSERT(guest_mperf < host_mperf_after,
> +				    "MPERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
> +				    guest_mperf, host_mperf_after);

Should we consider the possible overflow case of these 2 MSRs although it
could be extremely rare? Thanks.


> +
> +			host_aperf_before = host_aperf_after;
> +			host_mperf_before = host_mperf_after;
> +
> +			break;
> +		}
> +	}
> +
> +	kvm_vm_free(vm);
> +	close(msr_fd);
> +
> +	return 0;
> +}

