Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFDB6C8484
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCXSJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 14:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCXSIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 14:08:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD221CF74
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:08:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544539a729cso26068587b3.5
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679681311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o4Tqt4kqtzTJla7XRNL0c/kKlReBvCunwksIuXzFAk0=;
        b=EaXdlaCVrNVtrmhLHMPBiO72ywCX9Oi0Az5ZDrqB9s6e2hziyatvjcUu40goCfwUso
         uKNcS/5NTtJQwqIS6Jhpc5p/4JjAbTOaRI4EnkaRUx0gWOB3u1wb9esr2jLhpYmC3ZAz
         AYt13uRlYZ4BZAsLpjKe/FbqrHZT05hCJ2XDEsQ3iDZ+9Bi76xz+Afh9WnIUKsdQHw+L
         fdkWj4LMiLoZmNyxUBP4l7VGBsR5wUHwFacDuRAhrAlk4WJHqbzBWysn4hWWoepAi6wB
         MKzczIKkvqWLHo3ucp6GvFAJZpcYKkxOjSvkl+ySR+wdI5mt2FKVjP+4t927ovP5iQ0K
         HhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679681311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4Tqt4kqtzTJla7XRNL0c/kKlReBvCunwksIuXzFAk0=;
        b=hcJG8YbBMbmseywrVNtUswF75gP72hn6NWa23Ybq4t7atlNnXzGfer89vcFc9ZQir5
         r7mouFJtJBRCPFdQh5eLRr+EyyGmkElfCFw4RMzlH3rzBI1sDu61diGl2gJRCtXdCbL7
         AThnIPy18EiaT6aKU7NcWZzAnJya/UQfQ6lTnYrsSwtR78+b2kYyxwaDG34/bVrBpya9
         cN1Uq0EZgFQWvgPoWHN8HV6wZuvDWR+U2J6yDvPxVJiggccgCH/YUprBF31++FT8O4OG
         9qcUlAwKdXPalGR7ZXKGjhA1x0AqPvo2zl2yyUbhZBICsLoDoC/YFTZvQArcfRApTMtI
         M08A==
X-Gm-Message-State: AAQBX9c3LenNM7A5fZ9QtwWiI9bqWyuhCTAhNaNFz9iXiyOBdaB+p0+4
        OkpuHsIIgqnUfcaIj7j248i5QQCKik4=
X-Google-Smtp-Source: AKy350Y4fQGkTc8iwt18qHDi+1TcgK0rrkVtg+1sAZcQCSik5VBR6jz98AIDTxSjKrR7HNJhWyCXC90oStA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1148:b0:b76:5c0b:3573 with SMTP id
 p8-20020a056902114800b00b765c0b3573mr1473996ybu.5.1679681311157; Fri, 24 Mar
 2023 11:08:31 -0700 (PDT)
Date:   Fri, 24 Mar 2023 11:08:29 -0700
In-Reply-To: <20230110175057.715453-6-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-6-pgonda@google.com>
Message-ID: <ZB3nHdT1mZXHt+mP@google.com>
Subject: Re: [PATCH V6 5/7] KVM: selftests: add library for
 creating/interacting with SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023, Peter Gonda wrote:
> Add interfaces to allow tests to create SEV guests. The additional
> requirements for SEV guests PTs and other state is encapsulated by the
> new vm_sev_create_with_one_vcpu() function. This can future be
> generalized for more vCPUs but the first set of SEV selftests in this
> series only uses a single vCPU.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
>  tools/arch/x86/include/asm/kvm_host.h         |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/include/kvm_util_base.h     |  15 +-
>  .../selftests/kvm/include/x86_64/processor.h  |   1 +
>  .../selftests/kvm/include/x86_64/sev.h        |  27 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   8 +-
>  .../selftests/kvm/lib/x86_64/processor.c      |  45 +++-
>  tools/testing/selftests/kvm/lib/x86_64/sev.c  | 254 ++++++++++++++++++
>  8 files changed, 343 insertions(+), 11 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
>  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
> 
> diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
> index d8f48fe835fb..c95041e92fb5 100644
> --- a/tools/arch/x86/include/asm/kvm_host.h
> +++ b/tools/arch/x86/include/asm/kvm_host.h
> @@ -8,6 +8,7 @@
>  struct kvm_vm_arch {
>  	uint64_t c_bit;
>  	uint64_t s_bit;
> +	bool is_pt_protected;

Leftover crud from a previous version, no?  I.e. can't this just use vm->protected?

>  };
>  
>  #endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 1750f91dd936..b7cfb15712d1 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -39,6 +39,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
>  LIBKVM_x86_64 += lib/x86_64/svm.c
>  LIBKVM_x86_64 += lib/x86_64/ucall.c
>  LIBKVM_x86_64 += lib/x86_64/vmx.c
> +LIBKVM_x86_64 += lib/x86_64/sev.c
>  
>  LIBKVM_aarch64 += lib/aarch64/gic.c
>  LIBKVM_aarch64 += lib/aarch64/gic_v3.c
> @@ -199,7 +200,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>  	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> -	$(KHDR_INCLUDES)
> +	$(KHDR_INCLUDES) -static -gdwarf-4

Spurious stuff from your environment, which by the way can just use EXTRA_CFLAGS,
e.g. I build selftests with

  EXTRA_CFLAGS="$static -Werror -gdwarf-4"

where $static varies based on the host.

>  no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
>          $(CC) -Werror $(CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 5f3150ecfbbf..b5283bcc1d02 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -89,6 +89,13 @@ enum kvm_mem_region_type {
>  	NR_MEM_REGIONS,
>  };
>  
> +/* VM protection policy/configuration. */
> +struct protected_vm {
> +	bool enabled;
> +	bool has_protected_bit;
> +	int8_t protected_bit;
> +};

More leftover crud.

> +
>  struct kvm_vm {
>  	int mode;
>  	unsigned long type;
> @@ -711,6 +718,10 @@ static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
>  }
>  
> +uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
> +			      uint32_t nr_runnable_vcpus,
> +			      uint64_t extra_mem_pages);
> +

Making vm_nr_pages_required() globally visible is no longer needed (upstream
changed).

> +#endif /* SELFTEST_KVM_SEV_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 0d0a7ad7632d..99983a5c5558 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -151,6 +151,7 @@ const char *vm_guest_mode_string(uint32_t i)
>  		[VM_MODE_P40V48_16K]	= "PA-bits:40,  VA-bits:48, 16K pages",
>  		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
>  		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
> +		[VM_MODE_PXXV48_4K_SEV]	= "PA-bits:ANY, VA-bits:48,  4K pages",
>  		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
>  		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
>  		[VM_MODE_P36V48_4K]	= "PA-bits:36,  VA-bits:48,  4K pages",
> @@ -176,6 +177,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  	[VM_MODE_P40V48_16K]	= { 40, 48,  0x4000, 14 },
>  	[VM_MODE_P40V48_64K]	= { 40, 48, 0x10000, 16 },
>  	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
> +	[VM_MODE_PXXV48_4K_SEV]	= {  0,  0,  0x1000, 12 },

Aha! An excuse to use my "mode overloading" idea[*].  Similar to concerns I had with
the UPM restricted memory stuff, adding dedicated enums for modifier is going to
be a maintenance problem.  So rather than have VM_MODE_PXXV48_4K_SEV, I propose we
split @mode into a set of masks and then have a "primary mode" and a "vm type".

Note, Andrew requested using a struct, so this may need a fair bit of massaging.

[*] https://lore.kernel.org/all/YtrqVwSK42KbKckf@google.com

> +static void assert_supported_guest_mode(struct kvm_vm *vm)
> +{
> +	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K || vm->mode == VM_MODE_PXXV48_4K_SEV,
> +		    "Attempt to use unknown or unsupported guest mode, mode: 0x%x",
> +		    vm->mode);

These changes all go away if we use a modifier for the VM type.

> +}
> +
>  void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  {
> -	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
> -		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> +	assert_supported_guest_mode(vm);
>  
>  	/* If needed, create page map l4 table. */
>  	if (!vm->pgd_created) {
> @@ -186,8 +193,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
>  	uint64_t *pml4e, *pdpe, *pde;
>  	uint64_t *pte;
>  
> -	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
> -		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> +	assert_supported_guest_mode(vm);
>  
>  	TEST_ASSERT((vaddr % pg_size) == 0,
>  		    "Virtual address not aligned,\n"
> @@ -273,11 +279,14 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
>  {
>  	uint64_t *pml4e, *pdpe, *pde;
>  
> +	TEST_ASSERT(
> +		!vm->arch.is_pt_protected,
> +		"Protected guests have their page tables protected so gva2gpa conversions are not possible.");

Eww, Google3 C++ "readability".

	TEST_ASSERT(!vm->protected,
		    "Walking page tables of protected guests is impossible");

> @@ -566,6 +576,10 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  void kvm_arch_vm_post_create(struct kvm_vm *vm)
>  {
>  	vm_create_irqchip(vm);
> +
> +	if (vm->mode == VM_MODE_PXXV48_4K_SEV) {

Unnecesary braces.

> +		sev_vm_init(vm);
> +	}
>  }
>  
>  struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
> @@ -1050,6 +1064,25 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
>  	}
>  }
>  
> +static void configure_sev_pte_masks(struct kvm_vm *vm)
> +{
> +	uint32_t eax, ebx, ecx, edx, enc_bit;
> +
> +	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> +	enc_bit = ebx & CPUID_EBX_CBIT_MASK;

Add X86_PROPERTY_SEV_C_BIT (or something along those lines).

> +
> +	vm->arch.c_bit = 1ULL << enc_bit;
> +	vm->protected = true;
> +	vm->gpa_protected_mask = vm->arch.c_bit;
> +}
> +
> +void kvm_init_vm_address_properties(struct kvm_vm *vm)
> +{
> +	if (vm->mode == VM_MODE_PXXV48_4K_SEV) {

Unnecessary braces as written, but having a helper is just silly.

> +		configure_sev_pte_masks(vm);

	if (vm->type == VM_TYPE_SEV) {
		vm->protected = true;
		vm->arch.c_bit = this_cpu_property(X86_PROPERTY_SEV_C_BIT);
		vm->gpa_tag_mask = vm->arch.c_bit;
	}

> +	}
> +}

...

> +static void sev_ioctl(int cmd, void *data)
> +{
> +	int ret;
> +	struct sev_issue_cmd arg;
> +
> +	arg.cmd = cmd;
> +	arg.data = (unsigned long)data;
> +	ret = ioctl(open_sev_dev_path_or_exit(), SEV_ISSUE_CMD, &arg);
> +	TEST_ASSERT(ret == 0, "SEV ioctl %d failed, error: %d, fw_error: %d",
> +		    cmd, ret, arg.error);

This leaks the fd, and it should use kvm_ioctl().  Yean, it's not technically a
KVM ioctl(), but there's no need to reinvent the wheel.

> +}
> +
> +static void kvm_sev_ioctl(struct kvm_vm *vm, int cmd, void *data)
> +{
> +	struct kvm_sev_cmd arg = {0};
> +	int ret;
> +
> +	arg.id = cmd;
> +	arg.sev_fd = open_sev_dev_path_or_exit();
> +	arg.data = (__u64)data;

Use a struct initializer:

	struct kvm_sev_cmd sev_cmd = {
		.id = cmd,
		.sev_fd = vm->sev_fd,
		.data = (unsigned long)data,
	};
> +
> +	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
> +	TEST_ASSERT(
> +		ret == 0,
> +		"SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
> +		cmd, ret, errno, strerror(errno), arg.error);

Google3 horrors aside, just use vm_ioctl().

	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &sev_cmd);

> +}
> +
> +static void sev_register_user_region(struct kvm_vm *vm, struct userspace_mem_region *region)
> +{
> +	struct kvm_enc_region range = {0};
> +	int ret;
> +
> +	range.addr = (__u64)region->region.userspace_addr;
> +	;
> +	range.size = region->region.memory_size;
> +
> +	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> +	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n",
> +		    errno);

See above.

> +}
> +
> +static void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa, uint64_t size)
> +{
> +	struct kvm_sev_launch_update_data ksev_update_data = {0};

These are _local_ variables, there's no need to namespace them, i.e. delete kvev_.

> +
> +	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
> +
> +	ksev_update_data.uaddr = (__u64)addr_gpa2hva(vm, gpa);
> +	ksev_update_data.len = size;

Struct initializer.

> +
> +	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
> +}
> +
> +
> +/*
> + * Iterate over set ranges within sparsebit @s. In each iteration,
> + * @range_begin and @range_end will take the beginning and end of the set
> + * range, which are of type sparsebit_idx_t.
> + *
> + * For example, if the range [3, 7] (inclusive) is set, within the
> + * iteration,@range_begin will take the value 3 and @range_end will take
> + * the value 7.
> + *
> + * Ensure that there is at least one bit set before using this macro with
> + * sparsebit_any_set(), because sparsebit_first_set() will abort if none
> + * are set.
> + */
> +#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
> +	for (range_begin = sparsebit_first_set(s),                      \
> +	     range_end =                                        \
> +	     sparsebit_next_clear(s, range_begin) - 1;          \
> +	     range_begin && range_end;                                  \
> +	     range_begin = sparsebit_next_set(s, range_end),            \
> +	     range_end =                                        \
> +	     sparsebit_next_clear(s, range_begin) - 1)

This belongs in tools/testing/selftests/kvm/include/sparsebit.h.

> +
> +/*
> + * sparsebit_next_clear() can return 0 if [x, 2**64-1] are all set, and the
> + * -1 would then cause an underflow back to 2**64 - 1. This is expected and
> + * correct.
> + *
> + * If the last range in the sparsebit is [x, y] and we try to iterate,
> + * sparsebit_next_set() will return 0, and sparsebit_next_clear() will try
> + * and find the first range, but that's correct because the condition
> + * expression would cause us to quit the loop.
> + */
> +static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
> +{
> +	const struct sparsebit *protected_phy_pages =
> +		region->protected_phy_pages;

Don't wrap, 3 chars in the case is fine.  You didn't wrap two lines below, which
runs over by 2 chars, so spontaneous combustion is unlikely.

> +	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
> +	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
> +
> +	sparsebit_idx_t i;
> +	sparsebit_idx_t j;
> +
> +	if (!sparsebit_any_set(protected_phy_pages))
> +		return;
> +
> +	sev_register_user_region(vm, region);
> +
> +	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
> +		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
> +		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
> +		const uint64_t gpa = gpa_base + offset;
> +
> +		sev_launch_update_data(vm, gpa, size_to_load);
> +	}
> +}
> +
> +static void sev_encrypt(struct kvm_vm *vm)

Open code this in its one caller. 

> +{
> +	int ctr;
> +	struct userspace_mem_region *region;
> +
> +	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {


> +		encrypt_region(vm, region);
> +	}
> +
> +	vm->arch.is_pt_protected = true;

Ah, that's why is_pt_protected exists.  Yeah, no.  I despise that SEV doesn't
actually protect guest memory until a magic command is issued.  Unless there is a
really, _really_ good reason not to treat the VM as fully protected from time zero,
let's ignore that detail in selftests.

> +}
> +
> +bool is_kvm_sev_supported(void)
> +{
> +	struct sev_user_data_status sev_status;
> +
> +	sev_ioctl(SEV_PLATFORM_STATUS, &sev_status);
> +
> +	if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
> +	      (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
> +	       sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {


This needs a comment explaining what on earth the major+minor stuff is, and why
we care.

> +		pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
> +			sev_status.api_major, sev_status.api_minor,
> +			sev_status.build, SEV_FW_REQ_VER_MAJOR,
> +			SEV_FW_REQ_VER_MINOR);

The pr_info() seems kinda pointless.  If someone is running these and the firmware
is too old, I assume they're going to have to do a lot of dirty work to get the
firmware updated.  And this is much easier on the eyes:

	struct sev_user_data_status sev_status;

	sev_ioctl(SEV_PLATFORM_STATUS, &sev_status);

	return sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
	       (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
	        sev_status.api_minor >= SEV_FW_REQ_VER_MINOR);

If the pr_info() really does add value, then do something like:

	supported = sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
		    (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
		     sev_status.api_minor >= SEV_FW_REQ_VER_MINOR);
	if (!supported)
		pr_info();

	return supported;
> +static void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
> +{
> +	struct kvm_sev_launch_start ksev_launch_start = {0};
> +	struct kvm_sev_guest_status ksev_status;

See above.

> +
> +	ksev_launch_start.policy = policy;
> +	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &ksev_launch_start);
> +	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
> +	TEST_ASSERT(ksev_status.policy == policy, "Incorrect guest policy.");
> +	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
> +		    "Unexpected guest state: %d", ksev_status.state);

Print the expected vs. actual.

> +
> +	ucall_init(vm, 0);
> +
> +	sev_encrypt(vm);
> +}
> +
> +static void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
> +{
> +	struct kvm_sev_launch_measure ksev_launch_measure;
> +	struct kvm_sev_guest_status ksev_guest_status;
> +
> +	ksev_launch_measure.len = 256;
> +	ksev_launch_measure.uaddr = (__u64)measurement;
> +	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);

See above.

> +
> +	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
> +	TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
> +		    "Unexpected guest state: %d", ksev_guest_status.state);

Expected vs. actual
