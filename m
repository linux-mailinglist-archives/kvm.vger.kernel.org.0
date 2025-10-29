Return-Path: <kvm+bounces-61380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5AAC187EF
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 07:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E3D7234AEE8
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 06:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7036030596F;
	Wed, 29 Oct 2025 06:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LE5DIOnD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286AA28312D;
	Wed, 29 Oct 2025 06:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761719889; cv=none; b=Fbn55vaEkTa0t+yJdHEs3OZ7KASdaIuX6EPDDB+kw6AhB1SI1BI4/S6ajFOMWavSUHFz+V+Y6CsS3+cXV07uwDBUURu3YrEQg8zzPmc6l4/FVT9j4Unx3GWMU8rkZT5S3qoRpCVmHOv8ylP4DJkdkXevsTuzTv248+syOyXB8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761719889; c=relaxed/simple;
	bh=GQBcTt3q3jYhlQdBtZfxngxuplRCCGIsPQTXwR3o7QE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nW6ppnOOYIA+Hko7XNF0xw/sS9eIw9rFQjgEXICDw4aPC5Ypzh8QbUxY2LAsxaz1H2aeRscNDwUPJX61+8LuLpGNyXcezubyex/JVnZsjprLrQJIWzpdFSB+a70IyPNGm3WrxAnz4K8nKaNZtdrk2ev8xaf3lNHKOe7zyZGllvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LE5DIOnD; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761719887; x=1793255887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GQBcTt3q3jYhlQdBtZfxngxuplRCCGIsPQTXwR3o7QE=;
  b=LE5DIOnDHPPMwBZ6V+EXCZXh4DxsQVD4bMaNQ61jgeMPH98N1S0gBbzF
   yJNFIspJPqDQQblEh7R7ooyk+DItra1O2NatQvbYOuc1ZVvecq8W2rGox
   QPM8itT532kpJnK5slcYc91kz4kO6HYzjbX5yJLzld1KTuylIg006fov1
   AvC5Zh2JSUfd1kx8XFkCjEuYMLFRJRr2dC1l287cB1BghdS5mM5zgCX/g
   QoN5TL8XnAQDRU47jkjPmuWHGym4rOdJFngCXNYMzOV+8WQIavzUszRkO
   KUTgnF2vC6d86m76o3/Z1phRsnn1k0+a83HfUmYjkRwViUw09zHaih2Bi
   g==;
X-CSE-ConnectionGUID: GBMk75dfQl6MuVSpLjXg7w==
X-CSE-MsgGUID: ChZdgfbOS6KuF84/bpjMhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63867275"
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="63867275"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 23:38:05 -0700
X-CSE-ConnectionGUID: 8nQPxS3sQHujSGq7kBId9A==
X-CSE-MsgGUID: W9e750ZQTU6M5dFb3BxcwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="190701774"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 23:37:57 -0700
Message-ID: <71006f78-7afa-4821-8bd1-9cd5b8d62a33@linux.intel.com>
Date: Wed, 29 Oct 2025 14:37:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Take MMU lock around tdh_vp_init()
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, ackerleytng@google.com, anup@brainfault.org,
 aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, chenhuacai@kernel.org,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, ira.weiny@intel.com,
 kai.huang@intel.com, kas@kernel.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, maddy@linux.ibm.com, maobibo@loongson.cn,
 maz@kernel.org, michael.roth@amd.com, oliver.upton@linux.dev,
 palmer@dabbelt.com, pbonzini@redhat.com, pjw@kernel.org,
 vannapurve@google.com, x86@kernel.org, yan.y.zhao@intel.com,
 zhaotianrui@loongson.cn
References: <aP-1qlTkmFUgTld-@google.com>
 <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251028002824.1470939-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/28/2025 8:28 AM, Rick Edgecombe wrote:
> Take MMU lock around tdh_vp_init() in KVM_TDX_INIT_VCPU to prevent
> meeting contention during retries in some no-fail MMU paths.
>
> The TDX module takes various try-locks internally, which can cause
> SEAMCALLs to return an error code when contention is met. Dealing with
> an error in some of the MMU paths that make SEAMCALLs is not straight
> forward, so KVM takes steps to ensure that these will meet no contention
> during a single BUSY error retry. The whole scheme relies on KVM to take
> appropriate steps to avoid making any SEAMCALLs that could contend while
> the retry is happening.
>
> Unfortunately, there is a case where contention could be met if userspace
> does something unusual. Specifically, hole punching a gmem fd while
> initializing the TD vCPU. The impact would be triggering a KVM_BUG_ON().
>
> The resource being contended is called the "TDR resource" in TDX docs
> parlance. The tdh_vp_init() can take this resource as exclusive if the
> 'version' passed is 1, which happens to be version the kernel passes. The
> various MMU operations (tdh_mem_range_block(), tdh_mem_track() and
> tdh_mem_page_remove()) take it as shared.
>
> There isn't a KVM lock that maps conceptually and in a lock order friendly
> way to the TDR lock. So to minimize infrastructure, just take MMU lock
> around tdh_vp_init(). This makes the operations we care about mutually
> exclusive. Since the other operations are under a write mmu_lock, the code
> could just take the lock for read, however this is weirdly inverted from
> the actual underlying resource being contended. Since this is covering an
> edge case that shouldn't be hit in normal usage, be a little less weird
> and take the mmu_lock for write around the call.
>
> Fixes: 02ab57707bdb ("KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table")
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> Hi,
>
> It was indeed awkward, as Sean must have sniffed. But seems ok enough to
> close the issue.
>
> Yan, can you give it a look?
>
> Posted here, but applies on top of this series.
>
> Thanks,
>
> Rick
> ---
>   arch/x86/kvm/vmx/tdx.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index daec88d4b88d..8bf5d2624152 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2938,9 +2938,18 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   		}
>   	}
>   
> -	err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
> -	if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
> -		return -EIO;
> +	/*
> +	 * tdh_vp_init() can take a exclusive lock of the TDR resource inside
                                   ^
                                   an

> +	 * the TDX module. This resource is also taken as shared in several
> +	 * no-fail MMU paths, which could return TDX_OPERAND_BUSY on contention.
> +	 * A read lock here would be enough to exclude the contention, but take
> +	 * a write lock to avoid the weird inversion.
Can we also add the description that the lock is trying to prevent an edge case
as in the change log if not too wordy?

> +	 */
> +	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
> +		err = tdh_vp_init(&tdx->vp, vcpu_rcx, vcpu->vcpu_id);
> +		if (TDX_BUG_ON(err, TDH_VP_INIT, vcpu->kvm))
> +			return -EIO;
> +	}
>   
>   	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>   


