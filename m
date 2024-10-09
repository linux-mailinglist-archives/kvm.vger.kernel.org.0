Return-Path: <kvm+bounces-28180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0B199630E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03F01C21A19
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0086818FC9C;
	Wed,  9 Oct 2024 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X/XLpRiW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C092C188933
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463003; cv=none; b=hPAgNDrOzYuUjPd9r7AfzXVlhvuDdIKjQ0wJ7DI0PD1hHCtb6PawmmnnBV8QgIlRcZLQtbXpTsVVPcEC+betKghzZ7tqQMXQcafK0uhPY0OG9DDipILZN/T9PX6x7JAZrMNVXd7n6shk8SJByCXSPAMnzt4TqH+kZow5lGOmlZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463003; c=relaxed/simple;
	bh=puO2yolwMmXZ4+1/AaWo0WiUXGvYXZVPtqYsDlpyI2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWeZnlB7j5VupEY2aw1mD7sjYiYsiJCFFzdUFmJGLC4+IF0e1QK+g1tIyzEqFDe1gtvnviKJLituyIFyOBJ0Ay56USvCP//d4MTbkVmdZqL7fB8l3t8cMIP5r/g7+Altc19CFsc7U1fhZdVP9BXzZoq50TJVejecB5OZWPnhT58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X/XLpRiW; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728463001; x=1759999001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=puO2yolwMmXZ4+1/AaWo0WiUXGvYXZVPtqYsDlpyI2g=;
  b=X/XLpRiWlv8Bpnuaeq91JOabNxFW2IQzYxxLWa7f6/OgiB5PsGImpMaL
   /7Po++ndkZUWTFFCs8o6EJuC2ZfLnp6IBdvgKA43tib5AFKLbdqMvirn5
   nKBNUo2JLLQJUq+49NJf/mN/vpgeQfnghDPS4PkfHJOFzRALJRIT5Aiz7
   76GoAD6CaqYpXE8b/2Y0zY8cK1DA0ZvbR5XNQ5QXVTN8YChGPTqj/8kPj
   l1KZvoaqCJ5vO6Vl3DdVRvdBThTIPQiByUCNuPlaBU1pdjnZ+CUzaT3Qc
   KSD9Fv49lm/oPVsR9Dof4SLPy2C26KraIga/Q4QsXRt6yeEYOhfIWhTty
   g==;
X-CSE-ConnectionGUID: sh3JK4aOSu+qoRGCkF0Msw==
X-CSE-MsgGUID: U3c0ycLFS/uH7awJmLFv+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27639449"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27639449"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 01:36:36 -0700
X-CSE-ConnectionGUID: fWS+miooRGaMtvJG25pO9g==
X-CSE-MsgGUID: HRCGbfD0TnGkXyc1GgsmiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="75764406"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 09 Oct 2024 01:36:35 -0700
Date: Wed, 9 Oct 2024 16:52:47 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Gao Shiyuan <gaoshiyuan@baidu.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] x86: Add support save/load HWCR MSR
Message-ID: <ZwZEXyRvZeb4eO6q@intel.com>
References: <20240926040808.9158-1-gaoshiyuan@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926040808.9158-1-gaoshiyuan@baidu.com>

Hi Shiyuan,

On Thu, Sep 26, 2024 at 12:08:08PM +0800, Gao Shiyuan via wrote:
> Date: Thu, 26 Sep 2024 12:08:08 +0800
> From: Gao Shiyuan via <qemu-devel@nongnu.org>
> Subject: [PATCH v1 1/1] x86: Add support save/load HWCR MSR
> X-Mailer: git-send-email 2.39.3 (Apple Git-146)
> 
> KVM commit 191c8137a939 ("x86/kvm: Implement HWCR support")
> introduced support for emulating HWCR MSR.
> 
> Add support for QEMU to save/load this MSR for migration purposes.
> 
> Signed-off-by: Gao Shiyuan <gaoshiyuan@baidu.com>
> ---
>  target/i386/cpu.c     |  1 +
>  target/i386/cpu.h     |  5 +++++
>  target/i386/kvm/kvm.c | 12 ++++++++++++
>  target/i386/machine.c | 20 ++++++++++++++++++++
>  4 files changed, 38 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 85ef7452c0..339131a39a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7093,6 +7093,7 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
>      env->a20_mask = ~0x0;
>      env->smbase = 0x30000;
>      env->msr_smi_count = 0;
> +    env->hwcr = 0;

Why we need to clear it here? This needs to be explained in the commit
message.

>      env->idt.limit = 0xffff;
>      env->gdt.limit = 0xffff;
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 14edd57a37..a19b1ceda4 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -539,6 +539,8 @@ typedef enum X86Seg {
>  
>  #define MSR_AMD64_TSC_RATIO_DEFAULT     0x100000000ULL
>  
> +#define MSR_K7_HWCR                     0xc0010015
> +
>  #define MSR_VM_HSAVE_PA                 0xc0010117
>  
>  #define MSR_IA32_XFD                    0x000001c4
> @@ -1859,6 +1861,9 @@ typedef struct CPUArchState {
>      uint64_t msr_lbr_depth;
>      LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
>  
> +    /* Hardware Configuration MSR */

We can keep the same comment as msr_hwcr in KVM to emphasize this is an
AMD-specific MSR, i.e.,

/* AMD MSRC001_0015 Hardware Configuration */

> +    uint64_t hwcr;

Add the msr_ prefix to indicate that this value is only intended to
store the MSR. Currently, for similar members, some have the msr_ prefix
and some do not, but it is better to have it for clarity.

> +
>      /* exception/interrupt handling */
>      int error_code;
>      int exception_is_int;

-Zhao


