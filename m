Return-Path: <kvm+bounces-65492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BFCCACD85
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 11:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8EA53300E804
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 10:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8E732937B;
	Mon,  8 Dec 2025 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KdXhuuuH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7B1328B76;
	Mon,  8 Dec 2025 09:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186375; cv=none; b=fYUSswgscX/sDfGOYSzkSr5YBqdzhQIjJ1vmirreeMIX7yT5ee0srYlv4+KzTGuPdXpBi9t6XjVper/G0zgBxUFO5cuDJ/xBzh5F+Ed99FvBQyHl72NfJk/Dupm69ELHCyokSj7rqf+LRzF/V3wVLd0qp1XrkZJj/2XRukIrzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186375; c=relaxed/simple;
	bh=pukd5DIniWoie9kGMG9/80bzu02vevF6aHW9X0aaot4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJ5ipECbq/NLRGJO05+yx5S87AbszYEpc26CFf83caFE7Nmgx/nqWziE82lvFHUFWyJn+TDQl03WUwS9dvda5pb5fZpd6yOED2whfwu6/hLSHO2qeNQcP6qcjlvr2nSiA0mYMWA9uR6jMrhjDMshsxLyXsXDyhAryrCvxxqujXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KdXhuuuH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186373; x=1796722373;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pukd5DIniWoie9kGMG9/80bzu02vevF6aHW9X0aaot4=;
  b=KdXhuuuH2X2O8czSNlfvg+iMkrfMizeA1G1QeVWqCvJW+XNvT3L+/YDg
   3L6n5TlDWlJyIa/ShhDpkdMSPacyrWj6BsKIQPAsdygCZDfZywnbudEXJ
   xnk+vFB/gi5HMG3I1h9DDt1eybdUHzbUFxECh0ZqyVam79fXHlhStBQrn
   H0BPw3FppsC76lNnBpJBFmz0UFaI/EKs7Ll+93bFOXkz0b6VryUcq0QhT
   49sJ4e8g/idH1V5iPSYXMVD8a4tAuh3XiDGKOsGGTYtUFJbsJ1n3DjKdy
   GQx1HmAW6mzn8W2nrCpnXxl4r1AThKKWy+EB2PxjNZYLOlWPu9l40XQAv
   w==;
X-CSE-ConnectionGUID: lporIYXqTmus/cIYs99MVg==
X-CSE-MsgGUID: wj5kP2DMRD2yRmp8hWOhKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67161250"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67161250"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:52 -0800
X-CSE-ConnectionGUID: zIoGPMZ2RX+cbRJrhnH6Bg==
X-CSE-MsgGUID: GKzYOiuHTO6nUrMMOo/4dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="233262642"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:45 -0800
Message-ID: <4b82ce2f-ff87-4d6b-9cee-565f56bb75ca@linux.intel.com>
Date: Mon, 8 Dec 2025 17:32:41 +0800
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
>  		return;
> -	}
> +
>  	if (i < 0) {
>  		i = m->guest.nr++;
>  		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



