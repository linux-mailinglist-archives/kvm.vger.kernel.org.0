Return-Path: <kvm+bounces-65493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C14B9CACAE1
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 134C6306454F
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABE032B99B;
	Mon,  8 Dec 2025 09:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R7lz10Q+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BDE32ABFD;
	Mon,  8 Dec 2025 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186479; cv=none; b=N1iRIjKkzslFKxLxjKfG1XNUui16G9ucLg49f9hhZAmobmhQDWX48AaYuZzFcUmttpIkpztgf0OIkAit5BwcWedt4Uro7B73bJjQ8SM+wjWSELXk1mSs8AfvgTlLD2lQE0Su7nRX8Po6875WL7FxSHSK9Y6Uf0lrzZLtBQ7pP+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186479; c=relaxed/simple;
	bh=nSxjb3iSvlhZrRlAmKEmJNxO+kFHROtO7j/bMcBHd/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tfVzW4bgCkVwVDQGwL9vceJj1/8C0jbzqrktpKKdZ97UCNoGA3/franYO823ruuZz8/sQpAAxF2qHPHsRUQkzDfDPhGfhpUn3/EXC3NFKQu2eVUb2JZe0QHDyAeI466OHYLyPxByjF5Hx5NTW2zLHdrr2dx7pH+LGDKUr+Dgt44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R7lz10Q+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186478; x=1796722478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nSxjb3iSvlhZrRlAmKEmJNxO+kFHROtO7j/bMcBHd/4=;
  b=R7lz10Q++QcRVjVH87R4YTbCHfkZB7IwmHerzxrLLhmN9rgtC2K7oXkI
   LubgVKvoFigNJv1qXvFFaFecYY7KfCytMLdYcgUlIHgIaaQpGTlZlTYmO
   4bZZU9cOJyDuBnE2crCW6uOuy5AJ8NrxdT+E2udv6RrNzgWUBcOXDfCn9
   ug8Jf0T3fZqkaUybgOsyL2oXwBP3CwY6DnJZQujrR930S5c87C5d2nveH
   p0k02dc6anqKZ1LGT43NeKiWrhEqvGqNDvghqQgOsrys56iXCJ2c0EuNq
   73DYD8A/4SlCWBSkvtqWJujsUnj/zwrrKuegSvJPuHlAP6U2AyJpBLunS
   Q==;
X-CSE-ConnectionGUID: ivHioeq3S2S642p7NS0K0g==
X-CSE-MsgGUID: W/0Bz5joT969CG0McuNgjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67288121"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67288121"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:34:38 -0800
X-CSE-ConnectionGUID: jJDDhXNuTkyNrjKmaswHjw==
X-CSE-MsgGUID: 4F6FhXpxRu6nERmNjwerUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="196157352"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:34:30 -0800
Message-ID: <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
Date: Mon, 8 Dec 2025 17:34:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 39/44] KVM: VMX: Bug the VM if either MSR auto-load
 list is full
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-40-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-40-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> WARN and bug the VM if either MSR auto-load list is full when adding an
> MSR to the lists, as the set of MSRs that KVM loads via the lists is
> finite and entirely KVM controlled, i.e. overflowing the lists shouldn't
> be possible in a fully released version of KVM.  Terminate the VM as the
> core KVM infrastructure has no insight as to _why_ an MSR is being added
> to the list, and failure to load an MSR on VM-Enter and/or VM-Exit could
> be fatal to the host.  E.g. running the host with a guest-controlled PEBS
> MSR could generate unexpected writes to the DS buffer and crash the host.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 38491962b2c1..2c50ebf4ff1b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1098,6 +1098,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  {
>  	int i, j = 0;
>  	struct msr_autoload *m = &vmx->msr_autoload;
> +	struct kvm *kvm = vmx->vcpu.kvm;
>  
>  	switch (msr) {
>  	case MSR_EFER:
> @@ -1134,12 +1135,10 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
>  	j = vmx_find_loadstore_msr_slot(&m->host, msr);
>  
> -	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
> -	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> -		printk_once(KERN_WARNING "Not enough msr switch entries. "
> -				"Can't add msr %x\n", msr);
> +	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
> +	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))

nit: Remove one extra space before "m->host.nr".


>  		return;
> -	}
> +
>  	if (i < 0) {
>  		i = m->guest.nr++;
>  		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);

