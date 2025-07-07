Return-Path: <kvm+bounces-51647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A847AFAA8D
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33BE73B7CCA
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 04:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D4C25A627;
	Mon,  7 Jul 2025 04:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="ZM3Fge1P"
X-Original-To: kvm@vger.kernel.org
Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6E256C6C
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 04:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751862068; cv=none; b=TaKio7Rgm5ucFrUqFxuCk6ZJuR6kQ3gqRfR2XR8bYMmbDoNe2sL7jFKKblcGC/WSbTaGLV7qErQ1W1qsgcK5q2411XR7nGvO5vU72fvlhYv4rtSH+BsG6cQwHH6+7PkxapQeJuP70tz3yRo2+/UQCGKTpBeVvxOpFex64reYaSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751862068; c=relaxed/simple;
	bh=EUC69sE9zenTn/2Sy/h9p+6RjbERduALnbcWccHJTLY=;
	h=Mime-Version:References:Cc:In-Reply-To:Message-Id:Content-Type:To:
	 Subject:From:Date; b=YoAA5EYEINg7T1Wlvqkhxek3Iv7opOywhYfGgTEwUpM9Wzsa7etChSEeC/438a6H0rULKfwX18+oVXz461VQ8paxbSc1nH3YL3qluzYD2E7vF6mVIkCQhnfhhMp1Q1SO4ytoE6pWtFN6g1GpJo2i/2fniYuGfEdKsZNTJYCA2Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=ZM3Fge1P; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1751862005;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CjKnAonOWWkQnCl5eH4m1YN83iARqUOCPFNnwkrDA/A=;
 b=ZM3Fge1Pi+aUQAekTHo9Mg/8VyKwb+ZygKql4rSVquIVpG/0J/vEHwmxO3AM1CPe8+pMUN
 zseBLWnt5f/coQHm4t2QCrCKxuCFcwkQYkqExyksfPzclqblZsBPutktedV1xvmGUeXHgS
 Huf0bVuLtzqzlKFuO7weT202tvw5SK3vTYScp1qVSS+MBWY0aNrpOdCmF4AU2GGbvQ/DYV
 EAijsLCOSELqqHG4HFw+et5saTgUUNqqJMBaJ4im+FRB4K76oDJsNCbvDX4RaQsjhPmdZS
 3Tu9SkARNMdbEIU+G1IAGLNXF2zrC/MoSSBrmQZBHlJKKP3gorBOx41R97M+pg==
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707035345.17494-1-apatel@ventanamicro.com> <20250707035345.17494-3-apatel@ventanamicro.com>
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>, 
	"Heinrich Schuchardt" <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250707035345.17494-3-apatel@ventanamicro.com>
Message-Id: <cbdbf6f6-4645-4e93-ba5f-0d2a1cbd2116@lanxincomputing.com>
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
X-Lms-Return-Path: <lba+2686b4af3+980cc1+vger.kernel.org+liujingqi@lanxincomputing.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
User-Agent: Mozilla Thunderbird
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Mon, 07 Jul 2025 12:20:02 +0800
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Date: Mon, 7 Jul 2025 12:20:00 +0800

On 7/7/2025 11:53 AM, Anup Patel wrote:
> Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
> and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
> pointers before accessing HGEI[E|P] CSR which is slow and prone to race
> conditions because there is a separate per-hart lock for the VCPU pointer
> array and a separate per-VCPU rwlock for IMSIC VS-file (including HGEI
> line) used by the VCPU. Due to these race conditions, it is observed
> on QEMU RISC-V host that Guest VCPUs sleep in WFI and never wakeup even
> with interrupt pending in the IMSIC VS-file because VCPUs were waiting
> for HGEI wakeup on the wrong host CPU.
>
> The IMSIC virtualization already keeps track of the HGEI line and the
> associated IMSIC VS-file used by each VCPU so move the HGEI[E|P] CSR
> access to IMSIC virtualization so that costly HGEI line lookup can be
> avoided and likelihood of race-conditions when updating HGEI[E|P] CSR
> is also reduced.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Tested-by: Atish Patra <atishp@rivosinc.com>
> Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> Fixes: 3385339296d1 ("RISC-V: KVM: Use IMSIC guest files when available")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_aia.h |  4 ++-
>   arch/riscv/kvm/aia.c             | 51 +++++---------------------------
>   arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
>   arch/riscv/kvm/vcpu.c            |  2 --
>   4 files changed, 55 insertions(+), 47 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
> index 0a0f12496f00..b04ecdd1a860 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -87,6 +87,9 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>   
>   extern struct kvm_device_ops kvm_riscv_aia_device_ops;
>   
> +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu);
> +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu);
>   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu);
>   int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
>   
> @@ -161,7 +164,6 @@ void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
>   int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
>   			     void __iomem **hgei_va, phys_addr_t *hgei_pa);
>   void kvm_riscv_aia_free_hgei(int cpu, int hgei);
> -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
>   
>   void kvm_riscv_aia_enable(void);
>   void kvm_riscv_aia_disable(void);
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 19afd1f23537..dad318185660 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -30,28 +30,6 @@ unsigned int kvm_riscv_aia_nr_hgei;
>   unsigned int kvm_riscv_aia_max_ids;
>   DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>   
> -static int aia_find_hgei(struct kvm_vcpu *owner)
> -{
> -	int i, hgei;
> -	unsigned long flags;
> -	struct aia_hgei_control *hgctrl = get_cpu_ptr(&aia_hgei);
> -
> -	raw_spin_lock_irqsave(&hgctrl->lock, flags);
> -
> -	hgei = -1;
> -	for (i = 1; i <= kvm_riscv_aia_nr_hgei; i++) {
> -		if (hgctrl->owners[i] == owner) {
> -			hgei = i;
> -			break;
> -		}
> -	}
> -
> -	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
> -
> -	put_cpu_ptr(&aia_hgei);
> -	return hgei;
> -}
> -
>   static inline unsigned long aia_hvictl_value(bool ext_irq_pending)
>   {
>   	unsigned long hvictl;
> @@ -95,7 +73,6 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
>   
>   bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>   {
> -	int hgei;
>   	unsigned long seip;
>   
>   	if (!kvm_riscv_aia_available())
> @@ -114,11 +91,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
>   	if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
>   		return false;
>   
> -	hgei = aia_find_hgei(vcpu);
> -	if (hgei > 0)
> -		return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
> -
> -	return false;
> +	return kvm_riscv_vcpu_aia_imsic_has_interrupt(vcpu);
>   }
>   
>   void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
> @@ -164,6 +137,9 @@ void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
>   		csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
>   #endif
>   	}
> +
> +	if (kvm_riscv_aia_initialized(vcpu->kvm))
> +		kvm_riscv_vcpu_aia_imsic_load(vcpu, cpu);
>   }
>   
>   void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
> @@ -174,6 +150,9 @@ void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
>   	if (!kvm_riscv_aia_available())
>   		return;
>   
> +	if (kvm_riscv_aia_initialized(vcpu->kvm))
> +		kvm_riscv_vcpu_aia_imsic_put(vcpu);
> +
>   	if (kvm_riscv_nacl_available()) {
>   		nsh = nacl_shmem();
>   		csr->vsiselect = nacl_csr_read(nsh, CSR_VSISELECT);
> @@ -472,22 +451,6 @@ void kvm_riscv_aia_free_hgei(int cpu, int hgei)
>   	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
>   }
>   
> -void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
> -{
> -	int hgei;
> -
> -	if (!kvm_riscv_aia_available())
> -		return;
> -
> -	hgei = aia_find_hgei(owner);
> -	if (hgei > 0) {
> -		if (enable)
> -			csr_set(CSR_HGEIE, BIT(hgei));
> -		else
> -			csr_clear(CSR_HGEIE, BIT(hgei));
> -	}
> -}
> -
>   static irqreturn_t hgei_interrupt(int irq, void *dev_id)
>   {
>   	int i;
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index ea1a36836d9c..fda0346f0ea1 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -677,6 +677,48 @@ static void imsic_swfile_update(struct kvm_vcpu *vcpu,
>   	imsic_swfile_extirq_update(vcpu);
>   }
>   
> +bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu)
> +{
> +	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
> +	unsigned long flags;
> +	bool ret = false;
> +
> +	/*
> +	 * The IMSIC SW-file directly injects interrupt via hvip so
> +	 * only check for interrupt when IMSIC VS-file is being used.
> +	 */
> +
> +	read_lock_irqsave(&imsic->vsfile_lock, flags);
> +	if (imsic->vsfile_cpu > -1)
> +		ret = !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei));
> +	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +
> +	return ret;
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * No need to explicitly clear HGEIE CSR bits because the
> +	 * hgei interrupt handler (aka hgei_interrupt()) will always
> +	 * clear it for us.
> +	 */
> +}
> +
> +void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu)
> +{
> +	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
> +	unsigned long flags;
> +
> +	if (!kvm_vcpu_is_blocking(vcpu))
> +		return;
> +
> +	read_lock_irqsave(&imsic->vsfile_lock, flags);
> +	if (imsic->vsfile_cpu > -1)
> +		csr_set(CSR_HGEIE, BIT(imsic->vsfile_hgei));
> +	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
> +}
> +
>   void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long flags;
> @@ -781,6 +823,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
>   	 * producers to the new IMSIC VS-file.
>   	 */
>   
> +	/* Ensure HGEIE CSR bit is zero before using the new IMSIC VS-file */
> +	csr_clear(CSR_HGEIE, BIT(new_vsfile_hgei));
> +
>   	/* Zero-out new IMSIC VS-file */
>   	imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
>   
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index fe028b4274df..b26bf35a0a19 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -211,12 +211,10 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>   
>   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>   {
> -	kvm_riscv_aia_wakeon_hgei(vcpu, true);
>   }
>   
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   {
> -	kvm_riscv_aia_wakeon_hgei(vcpu, false);
>   }
>   

Nitpick:
Should the above two empty functions be removed ?

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>

Thanks,
Nutty

>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)

