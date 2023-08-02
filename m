Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF8776D675
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 20:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjHBSHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 14:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjHBSHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 14:07:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90437A3
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 11:07:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5843fed1e88so294787b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 11:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690999661; x=1691604461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aYBq5Q96CpGkfQxAbNmYKZm5+ExWaPEyMZGk2PekfWQ=;
        b=kMvB8NwzZ2f28utg/bipBg/XV00In0z3HmKG57aADZb87Dfjxd94GUHXl9mRml5Bew
         pCQkyWj5/7EK2/cuY962nxJnZjnNrW4WnZb98E1jZCCTGJkWbBKrTLm0eYnLGehu1pbf
         p13/kRJ/W1XK5AqpAaod4tXiTgI9cWWV+bh2OCYyE/DhukaPEwQltpxce9GMftu7gL81
         x2hn6z2yZpnKDo84U+sk7AGhtVFEHM0q+FppCyR1gbnN9i6LoLe43MjIbnBw4kCgMIru
         nfDY93evr9w1jWlS3VQ6gwSLHPgtE9uPRpfkANHF5fEF824fdvWP8t3ME9ZyPv43k7uy
         FMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690999661; x=1691604461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYBq5Q96CpGkfQxAbNmYKZm5+ExWaPEyMZGk2PekfWQ=;
        b=FKx4QTf+uDAPdKCILG6vjHmXCsusm/bYE+zIxxSPgUiAHP+yvdrZuXq85dn8JqJ84A
         C+OOtduVrW5Dbjjske5E9PU+fmvETmzylLyhDtOmNMa9P7m3R/1Gsg7NIcuZkDp2fUNU
         K6XpkuA+JIYvIxC3adxJfnDONiNCzePsL0bsLiRBL0ZnX5alhDGXOguy1HXWLCUG/PL5
         GZgaMYCjjScvUXWDqj/IMTt9K8fPXKXGveJMEci67kOcxQMJ+/rjgsha+Upyk0Wmk5Qw
         MfRqcI1kdnWgOd41Ht+dWJ6aug7F09ONn/Pmkunx4HUVPkz8jbNT97aadgYwI0b+g2ws
         zE8w==
X-Gm-Message-State: ABy/qLZwZ0hxnEb3GTyxi0kZ0wBrXHmhRKsV1hnNuM7nOYjQ9qPFvGm4
        Znpc5KLKO0N00KTxGaK3eskOCTnK2GY=
X-Google-Smtp-Source: APBJJlGzmmAki8FPLA/Kt+NIeDgBabhk3tAwqfYiA2SUVE/7ybvjUDLbrjET1osZSWgDiQS5Pi9ozpujd5s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441d:0:b0:586:4eae:b942 with SMTP id
 r29-20020a81441d000000b005864eaeb942mr88301ywa.4.1690999660863; Wed, 02 Aug
 2023 11:07:40 -0700 (PDT)
Date:   Wed, 2 Aug 2023 11:07:39 -0700
In-Reply-To: <20230801020206.1957986-3-zhaotianrui@loongson.cn>
Mime-Version: 1.0
References: <20230801020206.1957986-1-zhaotianrui@loongson.cn> <20230801020206.1957986-3-zhaotianrui@loongson.cn>
Message-ID: <ZMqba0j82Di+P+LI@google.com>
Subject: Re: [PATCH v1 2/4] selftests: kvm: Add processor tests for LoongArch KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Tianrui Zhao wrote:
> Add processor tests for LoongArch KVM, including vcpu initialize

Nit, AFAICT these aren't tests, this is simply the core KVM selftests support
for LoongArch.

> and tlb refill exception handler.
> 
> Based-on: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  .../selftests/kvm/lib/loongarch/exception.S   |  27 ++
>  .../selftests/kvm/lib/loongarch/processor.c   | 367 ++++++++++++++++++
>  2 files changed, 394 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
> 
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/exception.S b/tools/testing/selftests/kvm/lib/loongarch/exception.S
> new file mode 100644
> index 000000000000..19dc50993da4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/loongarch/exception.S
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "sysreg.h"
> +
> +/* address of refill exception should be 4K aligned */
> +.align  12

.align works on bytes, not on shifts.  I.e. this will make handle_tlb_refill
12-byte aligned, not 4096-byte aligned.

> +.global handle_tlb_refill
> +handle_tlb_refill:
> +	csrwr	t0, LOONGARCH_CSR_TLBRSAVE
> +	csrrd	t0, LOONGARCH_CSR_PGD
> +	lddir	t0, t0, 3
> +	lddir	t0, t0, 1
> +	ldpte	t0, 0
> +	ldpte	t0, 1
> +	tlbfill
> +	csrrd	t0, LOONGARCH_CSR_TLBRSAVE
> +	ertn
> +
> +/* address of general exception should be 4K aligned */
> +.align  12

Same thing here.

> +.global handle_exception
> +handle_exception:
> +1:
> +	nop
> +	b	1b
> +	nop
> +	ertn
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> new file mode 100644
> index 000000000000..2e50b6e2c556
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> @@ -0,0 +1,367 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM selftest LoongArch library code, including CPU-related functions.
> + *

Again, unnecessary IMO.  If you do keep the comment, the extra line with a bare
asterisk should be dropped.

> + */
> +
> +#include <assert.h>
> +#include <linux/bitfield.h>
> +#include <linux/compiler.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "sysreg.h"
> +
> +#define DEFAULT_LOONGARCH_GUEST_STACK_VADDR_MIN		0xac0000

Why diverge from the common?

	#define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000

AFAIK, the common value is also mostly arbitrary, but that just makes it even
more confusing as to why LoongArch needs to bump the min by 0x4000.

> +uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
> +{
> +	uint64_t *ptep;
> +
> +	if (!vm->pgd_created)
> +		goto unmapped_gva;
> +
> +	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
> +	if (!ptep)
> +		goto unmapped_gva;
> +
> +	switch (vm->pgtable_levels) {
> +	case 4:
> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
> +		if (!ptep)
> +			goto unmapped_gva;

This wants a "fallthrough" annotation.

> +	case 3:
> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
> +		if (!ptep)
> +			goto unmapped_gva;
> +	case 2:
> +		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
> +		if (!ptep)
> +			goto unmapped_gva;
> +		break;
> +	default:
> +		TEST_FAIL("Page table levels must be 2, 3, or 4");

Obviously it shouldn't come up, but print the actual pgtable_levels to make debug
a wee bit easier e.g.
		TEST_FAIL("Got %u page table levels, expected 2, 3, or 4",
			  vm->pgtable_levels);

Mostly out of curiosity, but also because it looks like this was heavily copy+pasted
from ARM: does LoongArch actually support 2-level page tables?
> +static void loongarch_set_csr(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
> +{
> +	uint64_t csrid;
> +
> +	csrid = KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | 8 * id;
> +	vcpu_set_reg(vcpu, csrid, val);
> +}
> +
> +static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long val;
> +	int width;
> +	struct kvm_vm *vm = vcpu->vm;
> +
> +	switch (vm->mode) {
> +	case VM_MODE_P48V48_16K:
> +	case VM_MODE_P40V48_16K:
> +	case VM_MODE_P36V48_16K:
> +	case VM_MODE_P36V47_16K:
> +		break;
> +
> +	default:
> +		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
> +	}
> +
> +	/* user mode and page enable mode */
> +	val = PLV_USER | CSR_CRMD_PG;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_CRMD, val);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PRMD, val);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_EUEN, 1);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_ECFG, 0);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TCFG, 0);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_ASID, 1);
> +
> +	width = vm->page_shift - 3;
> +	val = 0;
> +	switch (vm->pgtable_levels) {
> +	case 4:
> +		/* pud page shift and width */
> +		val = (vm->page_shift + width * 2) << 20 | (width << 25);
> +	case 3:
> +		/* pmd page shift and width */
> +		val |= (vm->page_shift + width) << 10 | (width << 15);
> +	case 2:
> +		/* pte page shift and width */
> +		val |= vm->page_shift | width << 5;
> +		break;
> +	default:
> +		TEST_FAIL("Page table levels must be 2, 3, or 4");
> +	}
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
> +
> +	/* pgd page shift and width */
> +	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
> +
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
> +
> +	extern void handle_tlb_refill(void);
> +	extern void handle_exception(void);

Eww.  I get that it's probably undesirable to expose these via processor.h, but
at least declare them outside of the function.

> +struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
> +				  void *guest_code)
> +{
> +	return loongarch_vcpu_add(vm, vcpu_id, guest_code);

Please drop the single-line passthrough, i.e. drop loongarch_vcpu_add().  I'm
guessing you copy+pasted much of this from ARM.  ARM's passthrough isn't a pure
passthrough, which is directly related to why the "passthrough" is ok: there are
other callers to aarch64_vcpu_add() that pass a non-NULL @source.
