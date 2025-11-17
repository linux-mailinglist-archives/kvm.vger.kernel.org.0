Return-Path: <kvm+bounces-63373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BC3C64238
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 13:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7C8FD4EE0EC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4437332D7DE;
	Mon, 17 Nov 2025 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPJVjdJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D2332D0DE;
	Mon, 17 Nov 2025 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383134; cv=none; b=aRtXXfFGWhUn6Rb56eE9mYBk1pktmYYDOpEkZdUJBGGutSQ8G5Xyk1TgIsjcl6FHe3MxHvEEHiSYVG4YHXQpZKzxlLhJjPV9oFOmE0k1iPjhJL/zO9PhNc2ZwwRHA/fXI7hZmbreZUGkAKpT58MeGzfkboNpLhUKFTmj4Z+Dpx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383134; c=relaxed/simple;
	bh=to5FSmCxcR8ncCUrVa9GhTYI/Go6IIIA2pm5lhCNvJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkyDn/UVOEvLkiLBCrbRu86QjvBXX3WKtzk2zg6yo3S7EU/95z5Z28Hku/iTeZcsOfN7Yi07eTkfVJQowAf4eij80y09nvdAZsX2v/WtUJT0YmHlGqX52lgx4kQZL+AxioKjy0DMtP7fGaZrd+8ZhR41cVlGA0L4VGAiNvaWt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPJVjdJ2; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763383132; x=1794919132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=to5FSmCxcR8ncCUrVa9GhTYI/Go6IIIA2pm5lhCNvJY=;
  b=EPJVjdJ2645uehp0CgJPa+uIsHWhAMMbzARWsVffGgSQ1Zv0hM2wXZZ7
   FHuYdNuVMYAfwziZuJhRigLmMAX7lK1B7FSAmwcuFHnSRN3yaJTnBp98y
   pj5mJ5dh/fcCzm0NbUwkbha7ejF0oFkNTwH/AUNqNoc6YrnxWraW3l/fg
   /0wiA1GIBvVwpooZTNuHkzjD3CSRdnC/nqiBcWnAS0494eAny0sFCvJzI
   cfFIc3bll0hu35fJVYJryMs7DEB792KBS6+monTaIQ50MwugS0ZWQbsy/
   V3M+BHUEtG3VXld1q+z3TWjTFMofkSfB7qfuS9NQyMEUXyB/34FCfT9zE
   w==;
X-CSE-ConnectionGUID: JgT8GysoTbCWl0zlJuCXOw==
X-CSE-MsgGUID: Lu3Rl9BDR8KBMDzwG+jE3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65313723"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="65313723"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 04:38:51 -0800
X-CSE-ConnectionGUID: oxWl3IshRmSTvmh87ONQNg==
X-CSE-MsgGUID: IQr/93GgT3Kbd056GBz7Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190238911"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO localhost) ([10.245.246.22])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 04:38:49 -0800
Date: Mon, 17 Nov 2025 14:38:46 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jon Kohler <jon@nutanix.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside
 of the fastpath
Message-ID: <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030224246.3456492-3-seanjc@google.com>

Hi,

On Thu, Oct 30, 2025 at 03:42:44PM -0700, Sean Christopherson wrote:
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -608,6 +608,17 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>  }
>  
> +static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> +		kvm_machine_check();
> +
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	return vmx_handle_exit_irqoff(vcpu);
> +}

I bisected kvm-x86/next down to this change for a TDX guest not booting
and host producing errors like:

watchdog: CPU118: Watchdog detected hard LOCKUP on cpu 118

Dropping the is_td_vcpu(vcpu) check above fixes the issue. Earlier the
call for vmx_handle_exit_irqoff() was unconditional.

Probably the (u16) cast above can be dropped too? It was never used for
TDX looking at the patch.

Regards,

Tony

