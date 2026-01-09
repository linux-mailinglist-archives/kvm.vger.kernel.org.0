Return-Path: <kvm+bounces-67492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9F6D069C7
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 01:30:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C63E630341FC
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 00:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055231DF987;
	Fri,  9 Jan 2026 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtWgBhSf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD71B4F1F;
	Fri,  9 Jan 2026 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767918602; cv=none; b=iTHAbTqDvwmjJs9cNgzRqdaGV/tM/aOiKz5NkhePaV+y7wzpPgnTYtwy85dJnsQ/QQrajI8Md8DHivs+BMQoM4MmHwcuWZVVYCetDEy2Y7SFa+r/ovdThcYGHW/X73Mf36lRfd+3OcGuAsO53zLVN823qweLhm1yQ9FCMrMd7Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767918602; c=relaxed/simple;
	bh=mX5XbuFq3oY1fgctrRQBbLXQxLXqk+y8wzPmf6LEIxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GM51FW9Z/G4j9AizNEXNhO3VrZ/Dx2OSXSeKYJoc7eKfbXA0d/j+1CZiJa7mjNAqagp4Ee+mXbCDhe1Q64wZ8S3X2PNhDFxHlSZz7hKa8zX6zjj5CgWx0D2DhisOVsQ+orKW3V9569JukYSbKDSpVC625hkvm4fXpkSyy+YS1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtWgBhSf; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767918601; x=1799454601;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mX5XbuFq3oY1fgctrRQBbLXQxLXqk+y8wzPmf6LEIxk=;
  b=CtWgBhSft7qKOIpKv4EWtzblbtp+5ef4vZOqBo6fPRpLTQ8QPlzcFGFx
   GbCHJIpaGrR/EzCq3ypJ1u4kcgZmwm7r2wisNnrBjfIULb/32JGUxfuq8
   6MG17ViCUoMkzTcOieTh5uuOy86k/AlhyAK4jdDr9hFi9g9ZG+QLJZ7j5
   uwtVdcc0DY0gFH6tucsLiHxs3QkI7VgtAA4iQRch8bwz8AAOE7ovj+9lu
   gZXOqqXHDapC+L8L40hWlYSWLx4ESHczBEiaeDiAWJ+MgMOZfI3izI5Q+
   CmKGAsb6hJLCmGQ7ZaoEEr+PcLXgJ9u9Ha0E+VJk3orIiXEbEgvr3mCxS
   g==;
X-CSE-ConnectionGUID: JJia++8rR8qXCtlv/LMKIg==
X-CSE-MsgGUID: hZT6qR2MSMmIMk15X/lU0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="86720691"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="86720691"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 16:30:00 -0800
X-CSE-ConnectionGUID: +aM55RQfSiK4CVJ+HHZuLw==
X-CSE-MsgGUID: FprPpiFKRD+vf2GC5TB/5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203255856"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 16:29:52 -0800
Message-ID: <a34caf32-a0e0-4bd1-a670-14ecb3756ae6@linux.intel.com>
Date: Fri, 9 Jan 2026 08:29:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 39/44] KVM: VMX: Bug the VM if either MSR auto-load
 list is full
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-40-seanjc@google.com>
 <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
 <aWANuxukqWmo36N0@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aWANuxukqWmo36N0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/9/2026 4:04 AM, Sean Christopherson wrote:
> On Mon, Dec 08, 2025, Dapeng Mi wrote:
>> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 38491962b2c1..2c50ebf4ff1b 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -1098,6 +1098,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>>>  {
>>>  	int i, j = 0;
>>>  	struct msr_autoload *m = &vmx->msr_autoload;
>>> +	struct kvm *kvm = vmx->vcpu.kvm;
>>>  
>>>  	switch (msr) {
>>>  	case MSR_EFER:
>>> @@ -1134,12 +1135,10 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>>>  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
>>>  	j = vmx_find_loadstore_msr_slot(&m->host, msr);
>>>  
>>> -	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
>>> -	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
>>> -		printk_once(KERN_WARNING "Not enough msr switch entries. "
>>> -				"Can't add msr %x\n", msr);
>>> +	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
>>> +	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
>> nit: Remove one extra space before "m->host.nr".
> Oh, that's intentional, so that the rest of the line is aligned with the "guest"
> line above.

Good to know. Thanks.



