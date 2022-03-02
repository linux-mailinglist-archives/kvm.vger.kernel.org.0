Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A2D4C9E8F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 08:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239916AbiCBHq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 02:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbiCBHqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 02:46:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D227B0E88;
        Tue,  1 Mar 2022 23:46:08 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso4075074pjj.2;
        Tue, 01 Mar 2022 23:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=otpwk78u6yviw/MoUg3r3NHs9lgfJsOxOMAplftcHjc=;
        b=LAlLJIHiID33W7Uc3QmQGx4pAqnRj5khVAs4NO8o9tivxdlMOtdIwW0x41BnCVBBRx
         7Wh4XbUvUUBrouONOyHebRByANqhEurghmW8zIRBxGH+6/nmXm0/QDPrgM4DPYuOYMvr
         dl5pw1imQe2CpRJ95iQe8KkBW14O1qSjNd7BDMB6QnKN5o0WaADI3s4GETWeCXC0fYIV
         votMQ+FnLumxRm4ac6Y63miiFtstGfwFYezyd0ozWVDWmytzAGPzwm96fji0QCpYg+EC
         hBWoE/kqB7mfJQJ8mnvBxKIvQWX0Kcnqg++5e3Dj/SHvzSrC3QxlrGqf+W6xKZoWD7EN
         OhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=otpwk78u6yviw/MoUg3r3NHs9lgfJsOxOMAplftcHjc=;
        b=3/Wxfx3jFnDkFQpsQ38SZI8IuM2Va4WVMv8TmcxB8pVLw0m4CfXuGulSGpoSF1Df0l
         NP4p1CuIuY64NY3Divc59q2b4a0XndpPVvSch9SRrqPCtLryxdlnzmJMkXhWsehj+dJx
         eE4AeFWeVrzWRplz/RWi56Ik3a+xhrmyZGlScK8GfLO8McFlXx8qJYRAQugZZGYDpXto
         qumoQjHD8b7f4LL1+pMUR5/SUkh2DZ7qhr5deJMMAniseokDL3bft/QHscCAmUYWq4BU
         6HbRneIoqlLLARESoR4+e5fffzT3Li1re+HuyuzhDUOKLymR9+tIr/nvlFEiAHEUnv5d
         t9Eg==
X-Gm-Message-State: AOAM533WEADBWw6/oBd+7n226TyRSuO5j7anqbuOuZI2Gntx2qdGuXDH
        g/wMdxTtPLw6XlEpoKJDNyQ=
X-Google-Smtp-Source: ABdhPJzYof9x9kIeWw3MGZlRgNzsBGZfuwM0dLo0FGIjggfpQlGehyQdTi6D2b7lsgaKpirIiogrRA==
X-Received: by 2002:a17:902:e34b:b0:14f:af20:4b3c with SMTP id p11-20020a170902e34b00b0014faf204b3cmr30005852plc.56.1646207167836;
        Tue, 01 Mar 2022 23:46:07 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a056a000b8a00b004de9129eb80sm20233905pfj.85.2022.03.01.23.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 23:46:07 -0800 (PST)
Message-ID: <4d9bd945-3af7-2e71-29df-8046eb0601ca@gmail.com>
Date:   Wed, 2 Mar 2022 15:45:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 19/19] KVM: sefltests: Add x86-64 test to verify MMU
 reacts to CPUID updates
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20210622200529.3650424-1-seanjc@google.com>
 <20210622200529.3650424-20-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20210622200529.3650424-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/6/2021 4:05 am, Sean Christopherson wrote:
> Add an x86-only test to verify that x86's MMU reacts to CPUID updates
> that impact the MMU.  KVM has had multiple bugs where it fails to
> reconfigure the MMU after the guest's vCPU model changes.
> 
> Sadly, this test is effectively limited to shadow paging because the

The x86_64/mmu_role_test fails when "N=/sys/module/kvm_intel/parameters/ept" :

KVM_SET_CPUID2 failed, rc: -1 errno: 22 (due to "63f5a1909f9e")

Does this regression meet your expectations even after "feb627e8d6f6" ?

> hardware page walk handler doesn't support software disabling of GBPAGES
> support, and KVM doesn't manually walk the GVA->GPA on faults for
> performance reasons (doing so would large defeat the benefits of TDP).
> 
> Don't require !TDP for the tests as there is still value in running the
> tests with TDP, even though the tests will fail (barring KVM hacks).

In this case, we could assert that the test will fail, rather than throwing the 
failure,
which is unfriendly to many CI systems. What do you think ?

> E.g. KVM should not completely explode if MAXPHYADDR results in KVM using
> 4-level vs. 5-level paging for the guest.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/processor.h  |   3 +
>   .../selftests/kvm/x86_64/mmu_role_test.c      | 147 ++++++++++++++++++
>   4 files changed, 152 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index e0e14150744e..6ead3403eca6 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -15,6 +15,7 @@
>   /x86_64/hyperv_cpuid
>   /x86_64/hyperv_features
>   /x86_64/mmio_warning_test
> +/x86_64/mmu_role_test
>   /x86_64/platform_info_test
>   /x86_64/set_boot_cpu_id
>   /x86_64/set_sregs_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 61e2accd080d..8dc007bac0fe 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -47,6 +47,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>   TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
>   TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>   TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> +TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
>   TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>   TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
>   TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index f21126941f19..914b0d16929c 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -55,6 +55,9 @@
>   #define CPUID_PKU		(1ul << 3)
>   #define CPUID_LA57		(1ul << 16)
>   
> +/* CPUID.0x8000_0001.EDX */
> +#define CPUID_GBPAGES		(1ul << 26)
> +
>   #define UNEXPECTED_VECTOR_PORT 0xfff0u
>   
>   /* General Registers in 64-Bit Mode */
> diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> new file mode 100644
> index 000000000000..523371cf8e8f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
> @@ -0,0 +1,147 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID			1
> +
> +#define MMIO_GPA	0x100000000ull
> +
> +static void guest_code(void)
> +{
> +	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
> +	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
> +
> +	GUEST_ASSERT(0);
> +}
> +
> +static void guest_pf_handler(struct ex_regs *regs)
> +{
> +	/* PFEC == RSVD | PRESENT (read, kernel). */
> +	GUEST_ASSERT(regs->error_code == 0x9);
> +	GUEST_DONE();
> +}
> +
> +static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
> +{
> +	u32 good_cpuid_val = *cpuid_reg;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	uint64_t cmd;
> +	int r;
> +
> +	/* Create VM */
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	/* Map 1gb page without a backing memlot. */
> +	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
> +
> +	r = _vcpu_run(vm, VCPU_ID);
> +
> +	/* Guest access to the 1gb page should trigger MMIO. */
> +	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
> +		    "Unexpected exit reason: %u (%s), expected MMIO exit (1gb page w/o memslot)\n",
> +		    run->exit_reason, exit_reason_str(run->exit_reason));
> +
> +	TEST_ASSERT(run->mmio.len == 8, "Unexpected exit mmio size = %u", run->mmio.len);
> +
> +	TEST_ASSERT(run->mmio.phys_addr == MMIO_GPA,
> +		    "Unexpected exit mmio address = 0x%llx", run->mmio.phys_addr);
> +
> +	/*
> +	 * Effect the CPUID change for the guest and re-enter the guest.  Its
> +	 * access should now #PF due to the PAGE_SIZE bit being reserved or
> +	 * the resulting GPA being invalid.  Note, kvm_get_supported_cpuid()
> +	 * returns the struct that contains the entry being modified.  Eww.
> +	 */
> +	*cpuid_reg = evil_cpuid_val;
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	/*
> +	 * Add a dummy memslot to coerce KVM into bumping the MMIO generation.
> +	 * KVM does not "officially" support mucking with CPUID after KVM_RUN,
> +	 * and will incorrectly reuse MMIO SPTEs.  Don't delete the memslot!
> +	 * KVM x86 zaps all shadow pages on memslot deletion.
> +	 */
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +				    MMIO_GPA << 1, 10, 1, 0);
> +
> +	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vm, VCPU_ID);
> +	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
> +
> +	r = _vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
> +
> +	cmd = get_ucall(vm, VCPU_ID, NULL);
> +	TEST_ASSERT(cmd == UCALL_DONE,
> +		    "Unexpected guest exit, exit_reason=%s, ucall.cmd = %lu\n",
> +		    exit_reason_str(run->exit_reason), cmd);
> +
> +	/*
> +	 * Restore the happy CPUID value for the next test.  Yes, changes are
> +	 * indeed persistent across VM destruction.
> +	 */
> +	*cpuid_reg = good_cpuid_val;
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	int opt;
> +
> +	/*
> +	 * All tests are opt-in because TDP doesn't play nice with reserved #PF
> +	 * in the GVA->GPA translation.  The hardware page walker doesn't let
> +	 * software change GBPAGES or MAXPHYADDR, and KVM doesn't manually walk
> +	 * the GVA on fault for performance reasons.
> +	 */
> +	bool do_gbpages = false;
> +	bool do_maxphyaddr = false;
> +
> +	setbuf(stdout, NULL);
> +
> +	while ((opt = getopt(argc, argv, "gm")) != -1) {
> +		switch (opt) {
> +		case 'g':
> +			do_gbpages = true;
> +			break;
> +		case 'm':
> +			do_maxphyaddr = true;
> +			break;
> +		case 'h':
> +		default:
> +			printf("usage: %s [-g (GBPAGES)] [-m (MAXPHYADDR)]\n", argv[0]);
> +			break;
> +		}
> +	}
> +
> +	if (!do_gbpages && !do_maxphyaddr) {
> +		print_skip("No sub-tests selected");
> +		return 0;
> +	}
> +
> +	entry = kvm_get_supported_cpuid_entry(0x80000001);
> +	if (!(entry->edx & CPUID_GBPAGES)) {
> +		print_skip("1gb hugepages not supported");
> +		return 0;
> +	}
> +
> +	if (do_gbpages) {
> +		pr_info("Test MMIO after toggling CPUID.GBPAGES\n\n");
> +		mmu_role_test(&entry->edx, entry->edx & ~CPUID_GBPAGES);
> +	}
> +
> +	if (do_maxphyaddr) {
> +		pr_info("Test MMIO after changing CPUID.MAXPHYADDR\n\n");
> +		entry = kvm_get_supported_cpuid_entry(0x80000008);
> +		mmu_role_test(&entry->eax, (entry->eax & ~0xff) | 0x20);
> +	}
> +
> +	return 0;
> +}
