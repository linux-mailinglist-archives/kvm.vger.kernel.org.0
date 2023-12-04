Return-Path: <kvm+bounces-3282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C33802A1D
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 03:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E63F41F20F25
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 02:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E407517C8;
	Mon,  4 Dec 2023 02:05:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A6A6B3;
	Sun,  3 Dec 2023 18:05:13 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cxh+jWM21l3aE+AA--.23770S3;
	Mon, 04 Dec 2023 10:05:10 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxjNzTM21lP8hTAA--.53749S3;
	Mon, 04 Dec 2023 10:05:09 +0800 (CST)
Subject: Re: [PATCH v5 2/4] KVM: selftests: Add core KVM selftests support for
 LoongArch
To: Tianrui Zhao <zhaotianrui@loongson.cn>, Shuah Khan <shuah@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, Peter Xu <peterx@redhat.com>,
 Vipin Sharma <vipinsh@google.com>
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
 <20231130111804.2227570-3-zhaotianrui@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2a2ef678-95f9-b6ff-8e32-f1aee26276a5@loongson.cn>
Date: Mon, 4 Dec 2023 10:05:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231130111804.2227570-3-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxjNzTM21lP8hTAA--.53749S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cw18WrWUuFW5Kw1Dtry7Jwc_yoW8Jr4kKo
	W3CFsF9r4rG342yr97Kr10qay2qw109an8CFy5Cr4rXa1vyFy5Ar15Kw4Fyr1fWF4kJryD
	CasrWan7CF97Awn8l-sFpf9Il3svdjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUOb7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_
	JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUc9a9UUUUU



On 2023/11/30 下午7:18, Tianrui Zhao wrote:
> Add core KVM selftests support for LoongArch.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   .../selftests/kvm/lib/loongarch/exception.S   |  59 ++++
>   .../selftests/kvm/lib/loongarch/processor.c   | 333 ++++++++++++++++++
>   2 files changed, 392 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>   create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
> 
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/exception.S b/tools/testing/selftests/kvm/lib/loongarch/exception.S
> new file mode 100644
> index 00000000000..88bfa505c6f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/loongarch/exception.S
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "processor.h"
> +
> +/* address of refill exception should be 4K aligned */
> +.balign	4096
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
> +	/*
> +	 * save and restore all gprs except base register,
> +	 * and default value of base register is sp ($r3).
> +	 */
> +.macro save_gprs base
> +	.irp n,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
> +	st.d    $r\n, \base, 8 * \n
> +	.endr
> +.endm
> +
> +.macro restore_gprs base
> +	.irp n,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
> +	ld.d    $r\n, \base, 8 * \n
> +	.endr
> +.endm
> +
> +/* address of general exception should be 4K aligned */
> +.balign	4096
> +.global handle_exception
> +handle_exception:
> +	csrwr  sp, LOONGARCH_CSR_KS0
> +	csrrd  sp, LOONGARCH_CSR_KS1
> +	addi.d sp, sp, -EXREGS_SIZE
> +
> +	save_gprs sp
> +	/* save sp register to stack */
> +	csrrd  t0, LOONGARCH_CSR_KS0
> +	st.d   t0, sp, 3 * 8
> +
> +	csrrd  t0, LOONGARCH_CSR_ERA
> +	st.d   t0, sp, PC_OFFSET_EXREGS
> +	csrrd  t0, LOONGARCH_CSR_ESTAT
> +	st.d   t0, sp, ESTAT_OFFSET_EXREGS
> +	csrrd  t0, LOONGARCH_CSR_BADV
> +	st.d   t0, sp, BADV_OFFSET_EXREGS
> +
> +	or     a0, sp, zero
> +	bl route_exception
> +	restore_gprs sp
> +	csrrd  sp, LOONGARCH_CSR_KS0
> +	ertn
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> new file mode 100644
> index 00000000000..82d8c1ec711
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
> @@ -0,0 +1,333 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <assert.h>
> +#include <linux/compiler.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +static vm_paddr_t invalid_pgtable[4];
> +static uint64_t virt_pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
> +{
> +	unsigned int shift;
> +	uint64_t mask;
> +
> +	shift = level * (vm->page_shift - 3) + vm->page_shift;
> +	mask = (1UL << (vm->page_shift - 3)) - 1;
> +	return (gva >> shift) & mask;
> +}
> +
> +static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
> +{
> +	return entry &  ~((0x1UL << vm->page_shift) - 1);
> +}
> +
> +static uint64_t ptrs_per_pte(struct kvm_vm *vm)
> +{
> +	return 1 << (vm->page_shift - 3);
> +}
> +
> +static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t child)
> +{
> +	uint64_t *ptep;
> +	int i, ptrs_per_pte;
> +
> +	ptep = addr_gpa2hva(vm, table);
> +	ptrs_per_pte = 1 << (vm->page_shift - 3);
> +	for (i = 0; i < ptrs_per_pte; i++)
> +		*(ptep + i) = child;
> +}
> +
> +void virt_arch_pgd_alloc(struct kvm_vm *vm)
> +{
> +	int i;
> +	vm_paddr_t child, table;
> +
> +	if (vm->pgd_created)
> +		return;
> +	child = table = 0;
> +	for (i = 0; i < vm->pgtable_levels; i++) {
> +		invalid_pgtable[i] = child;
> +		table = vm_phy_page_alloc(vm, DEFAULT_LOONARCH64_PAGE_TABLE_MIN,
> +				vm->memslots[MEM_REGION_PT]);
> +		TEST_ASSERT(table, "Fail to allocate page tale at level %d\n", i);
> +		virt_set_pgtable(vm, table, child);
> +		child = table;
> +	}
> +	vm->pgd = table;
> +	vm->pgd_created = true;
> +}
> +
> +static int virt_pte_none(uint64_t *ptep, int level)
> +{
> +	return *ptep == invalid_pgtable[level];
> +}
> +
> +static uint64_t *virt_populate_pte(struct kvm_vm *vm, vm_vaddr_t gva, int alloc)
> +{
> +	uint64_t *ptep;
> +	vm_paddr_t child;
> +	int level;
> +
> +	if (!vm->pgd_created)
> +		goto unmapped_gva;
> +
> +	level = vm->pgtable_levels - 1;
> +	child = vm->pgd;
> +	while (level > 0) {
> +		ptep = addr_gpa2hva(vm, child) + virt_pte_index(vm, gva, level) * 8;
> +		if (virt_pte_none(ptep, level)) {
> +			if (alloc) {
> +				child = vm_alloc_page_table(vm);
> +				virt_set_pgtable(vm, child, invalid_pgtable[level - 1]);
> +				*ptep = child;
> +			} else
> +				goto unmapped_gva;
> +
> +		} else
> +			child = pte_addr(vm, *ptep);
> +		level--;
> +	}
> +
> +	ptep = addr_gpa2hva(vm, child) + virt_pte_index(vm, gva, level) * 8;
> +	return ptep;
> +
> +unmapped_gva:
> +	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
> +	exit(EXIT_FAILURE);
> +}
> +
> +vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +{
> +	uint64_t *ptep;
> +
> +	ptep = virt_populate_pte(vm, gva, 0);
> +	TEST_ASSERT(*ptep != 0, "Virtual address vaddr: 0x%lx not mapped\n", gva);
> +
> +	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
> +}
> +
> +void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
> +{
> +	uint32_t prot_bits;
> +	uint64_t *ptep;
> +
> +	TEST_ASSERT((vaddr % vm->page_size) == 0,
> +			"Virtual address not on page boundary,\n"
> +			"vaddr: 0x%lx vm->page_size: 0x%x", vaddr, vm->page_size);
> +	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
> +			(vaddr >> vm->page_shift)),
> +			"Invalid virtual address, vaddr: 0x%lx", vaddr);
> +	TEST_ASSERT((paddr % vm->page_size) == 0,
> +			"Physical address not on page boundary,\n"
> +			"paddr: 0x%lx vm->page_size: 0x%x", paddr, vm->page_size);
> +	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
> +			"Physical address beyond maximum supported,\n"
> +			"paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> +			paddr, vm->max_gfn, vm->page_size);
> +
> +	ptep = virt_populate_pte(vm, vaddr, 1);
> +	prot_bits = _PAGE_PRESENT | __READABLE | __WRITEABLE | _CACHE_CC;
> +	prot_bits |= _PAGE_USER;
> +	*ptep = paddr | prot_bits;
> +}
> +
> +static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
> +{
> +	static const char * const type[] = { "pte", "pmd", "pud", "pgd"};
> +	uint64_t pte, *ptep;
> +
> +	if (level < 0)
> +		return;
> +
> +	for (pte = page; pte < page + ptrs_per_pte(vm) * 8; pte += 8) {
> +		ptep = addr_gpa2hva(vm, pte);
> +		if (virt_pte_none(ptep, level))
> +			continue;
> +		fprintf(stream, "%*s%s: %lx: %lx at %p\n",
> +				indent, "", type[level], pte, *ptep, ptep);
> +		pte_dump(stream, vm, indent + 1, pte_addr(vm, *ptep), level--);
> +	}
> +}
> +
> +void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
> +{
> +	int level;
> +
> +	if (!vm->pgd_created)
> +		return;
> +
> +	level = vm->pgtable_levels - 1;
> +	pte_dump(stream, vm, indent, vm->pgd, level);
> +}
> +
> +void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
> +{
> +}
> +
> +void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	if (get_ucall(vcpu, &uc) != UCALL_UNHANDLED)
> +		return;
> +
> +	TEST_FAIL("Unexpected exception (pc:0x%lx, estat:0x%lx, badv:0x%lx)",
> +			uc.args[0], uc.args[1], uc.args[2]);
> +}
> +
> +void route_exception(struct ex_regs *regs)
> +{
> +	unsigned long pc, estat, badv;
> +
> +	pc = regs->pc;
> +	estat = regs->estat;
> +	badv  = regs->badv;
> +	ucall(UCALL_UNHANDLED, 3, pc, estat, badv);
> +	while (1)
> +		;
> +}
> +
> +void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
> +{
> +	va_list ap;
> +	struct kvm_regs regs;
> +	int i;
> +
> +	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
> +		    "num: %u\n", num);
> +
> +	vcpu_regs_get(vcpu, &regs);
> +	va_start(ap, num);
> +	for (i = 0; i < num; i++)
> +		regs.gpr[i + 4] = va_arg(ap, uint64_t);
> +	va_end(ap);
> +	vcpu_regs_set(vcpu, &regs);
> +}
> +
> +static void loongarch_get_csr(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
> +{
> +	uint64_t csrid;
> +
> +	csrid = KVM_REG_LOONGARCH_CSR | KVM_REG_SIZE_U64 | 8 * id;
> +	vcpu_get_reg(vcpu, csrid, addr);
> +}
> +
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
> +		/* fall throuth */
> +	case 3:
> +		/* pmd page shift and width */
> +		val |= (vm->page_shift + width) << 10 | (width << 15);
> +		/* pte page shift and width */
> +		val |= vm->page_shift | width << 5;
> +		break;
> +	default:
> +		TEST_FAIL("Got %u page table levels, expected 3 or 4", vm->pgtable_levels);
> +	}
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
> +
> +	/* pgd page shift and width */
> +	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
> +
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
> +
> +	/*
> +	 * refill exception runs on real mode, entry address should
> +	 * be physical address
> +	 */
> +	val = addr_gva2gpa(vm, (unsigned long)handle_tlb_refill);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBRENTRY, val);
> +
> +	/*
> +	 * general exception runs on page-enabled mode, entry address should
> +	 * be virtual address
> +	 */
> +	val = (unsigned long)handle_exception;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_EENTRY, val);
> +
> +	loongarch_get_csr(vcpu, LOONGARCH_CSR_TLBIDX, &val);
> +	val &= ~CSR_TLBIDX_SIZEM;
> +	val |= PS_DEFAULT_SIZE << CSR_TLBIDX_SIZE;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBIDX, val);
> +
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_STLBPGSIZE, PS_DEFAULT_SIZE);
> +
> +	/* LOONGARCH_CSR_KS1 is used for exception stack */
> +	val = __vm_vaddr_alloc(vm, vm->page_size,
> +			DEFAULT_LOONARCH64_STACK_MIN, MEM_REGION_DATA);
> +	TEST_ASSERT(val != 0,  "No memory for exception stack");
> +	val = val + vm->page_size;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_KS1, val);
> +
> +	loongarch_get_csr(vcpu, LOONGARCH_CSR_TLBREHI, &val);
> +	val &= ~CSR_TLBREHI_PS;
> +	val |= PS_DEFAULT_SIZE << CSR_TLBREHI_PS_SHIFT;
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TLBREHI, val);
> +
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_CPUID, vcpu->id);
> +	loongarch_set_csr(vcpu, LOONGARCH_CSR_TMID,  vcpu->id);
> +}
> +
> +struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
> +				  void *guest_code)
> +{
> +	size_t stack_size;
> +	uint64_t stack_vaddr;
> +	struct kvm_regs regs;
> +	struct kvm_vcpu *vcpu;
> +
> +	vcpu = __vm_vcpu_add(vm, vcpu_id);
> +	stack_size = vm->page_size;
> +	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
> +			DEFAULT_LOONARCH64_STACK_MIN, MEM_REGION_DATA);
> +	TEST_ASSERT(stack_vaddr != 0,  "No memory for vm stack");
> +
> +	loongarch_vcpu_setup(vcpu);
> +	/* Setup guest general purpose registers */
> +	vcpu_regs_get(vcpu, &regs);
> +	regs.gpr[3] = stack_vaddr + stack_size;
> +	regs.pc = (uint64_t)guest_code;
> +	vcpu_regs_set(vcpu, &regs);
> +
> +	return vcpu;
> +}
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


