Return-Path: <kvm+bounces-61901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C89FAC2D869
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3032B3B0651
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2708921CFFA;
	Mon,  3 Nov 2025 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AflPVl88"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66B472618;
	Mon,  3 Nov 2025 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191976; cv=none; b=LsS+Af2MvI29scFc7pI2buX6UQ9HSs56wbYFERmH44i1rk+0zm6jqKNTASYiFpKk4HWpZK0+uvvknt4i12IFVmuDeVr2tjpC4WeSS6bhJ4vRztoe7AQ63rf/3LNtrhxshQ88Xc0pIv8+Qua0GHmx/Jo5jLElT4/qI/qVQ8toDcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191976; c=relaxed/simple;
	bh=+iaaWRw8B4NvnWOTSfgkouB60zccA7A8ZPnoe7ymArs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1Ji96YAz2lvf8ip0crslTL7q1mUGd6eP2Z6WQsfNYUe5xfG6ZAy7WYYjHO17yFBkOPj7sN2jSxePKrH+JecVfrFLo98ny0DVPsCKg1iKC63PpCiRpdiaF4ni5RcvTeo2haU90xgx1He8Y5o0ddIK0WM6vlK/zFXfkxnE0mGoio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AflPVl88; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762191974; x=1793727974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+iaaWRw8B4NvnWOTSfgkouB60zccA7A8ZPnoe7ymArs=;
  b=AflPVl88c6JjHYYfLX59Qd7YGL+jvJ3jKfQD38QgrCMAFHQMEpFJ5WeE
   FKzBUhfUPR2QZZoKuh4MOsYKJ3oJefX/gMfS7n1JJ//CAxmQNMaDgQP7i
   s4gBtOxTTWcJH2zXhkhi2RD5xZrQ2VaPcFiEyshCPuhjITIP10JE+te0O
   Pu7QmBYRuTlHx1gvmYC4c1oIaWFswhh1U56B6L4rGNwZei/GpO2UFD0CK
   2GFKnovjZ9ZRALCcW3lS50eL+HyiyYLiqNGYFWQ29yuh6kWtDR7OMIYDS
   0GgTqt6jWANvrlNxXwaTbR79CLaXhbkMG3IkkuR7SFABUJmOC9//uoP/C
   g==;
X-CSE-ConnectionGUID: vqa74VqLRki2TsF1NmZtUQ==
X-CSE-MsgGUID: l6YLO66hQEug39syBvE+yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="86900573"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="86900573"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:46:14 -0800
X-CSE-ConnectionGUID: 9+1oGi0QRhu7GEJpo3hShg==
X-CSE-MsgGUID: IcB7kOkoTJClOOC1GbIaxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="191273506"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 09:46:14 -0800
Date: Mon, 3 Nov 2025 09:46:08 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251103174608.lfghes3daaxvejxj@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-5-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> Rework the handling of the MMIO Stale Data mitigation to clear CPU buffers
> immediately prior to VM-Enter, i.e. in the same location that KVM emits a
> VERW for unconditional (at runtime) clearing.  Co-locating the code and
> using a single ALTERNATIVES_2 makes it more obvious how VMX mitigates the
> various vulnerabilities.
> 
> Deliberately order the alternatives as:
> 
>  0. Do nothing
>  1. Clear if vCPU can access MMIO
>  2. Clear always
> 
> since the last alternative wins in ALTERNATIVES_2(), i.e. so that KVM will
> honor the strictest mitigation (always clear CPU buffers) if multiple
> mitigations are selected.  E.g. even if the kernel chooses to mitigate
> MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_MMIO, some other mitigation
> may enable X86_FEATURE_CLEAR_CPU_BUF_VM, and that other thing needs to win.
> 
> Note, decoupling the MMIO mitigation from the L1TF mitigation also fixes
> a mostly-benign flaw where KVM wouldn't do any clearing/flushing if the
> L1TF mitigation is configured to conditionally flush the L1D, and the MMIO
> mitigation but not any other "clear CPU buffers" mitigation is enabled.
> For that specific scenario, KVM would skip clearing CPU buffers for the
> MMIO mitigation even though the kernel requested a clear on every VM-Enter.
> 
> Note #2, the flaw goes back to the introduction of the MDS mitigation.  The
> MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
> Move VERW closer to VMentry for MDS mitigation"), but previous kernels
> that flush CPU buffers in vmx_vcpu_enter_exit() are affected (though it's
> unlikely the flaw is meaningfully exploitable even older kernels).
> 
> Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

