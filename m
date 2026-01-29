Return-Path: <kvm+bounces-69502-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJaHOGbPemnU+gEAu9opvQ
	(envelope-from <kvm+bounces-69502-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:09:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD84AB566
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56B46301CFBB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2C33563F7;
	Thu, 29 Jan 2026 03:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvzAqBi3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292FB41C62;
	Thu, 29 Jan 2026 03:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769656153; cv=none; b=qfxJpyeMpyKtJVfNoTbbtZWcVoInAx84f3QmbkvR4zv0TY8bUz000q7RRMxDSMLXyyYrC0/2Zb4lpfFuVBtOJdhArN+L52sF0sieliwd5KEL79dlQKsydo8uhDHrSr0ZF2Kn9DNoNTx7cakcbIN39ThPXT6TSXsostlSFdjpx+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769656153; c=relaxed/simple;
	bh=JOqcPePSr0+UqaB7nUU5NNUWpGxmFZJ1c7VatnOxxxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGG+esdyNEALxa8M+atrdi6Gs5mIRpuAxI3kNyko5khNzKhQZPnZCTu5IyNb2VIhpWFvIdqJGs2ANEnjGNLw4DwYj0Us5ifGAsPOpwMnzhLymO5A7mD8N5awB/F+dDwsmr/2eA6aJw7eGQJOgLcf543G/A1Tdp4r8CdnDkUVScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvzAqBi3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769656151; x=1801192151;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JOqcPePSr0+UqaB7nUU5NNUWpGxmFZJ1c7VatnOxxxI=;
  b=mvzAqBi3ksfD57WX6wvx6a6E/ix3bo4brumltRCxoc8+rwwPnDIYXODU
   unexgpc+lckvPm21yKMtax6pQgfPDmmO85oJH5Apz5nyR4IbCUvyjPCSq
   9AA3kxqiZZG/CQdM0/zzidRm1EPyn3BK90RQNRf7f1H2YohVv7Iz54V9e
   YpRGO9FLjXNx2Mrfn6o6eyPrnQCwQgDpbgp3maisCieyKBYBNFZZLmpJq
   3FSJNPSB8pnpEBMIHOlcU6hK9mzFuTJrwpu/vji1lR1+GxxppJue+7gcT
   3MOpC5sJ3VsflLW9qbnbZ32Qwoy7SMVv6moI5EoPhJnP2IUrp89Ndsl0s
   Q==;
X-CSE-ConnectionGUID: Rc4L9YS6Tsqtp2C6Ic7VVA==
X-CSE-MsgGUID: YVBI56aBTxuFFMSGWmco2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="58463261"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="58463261"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 19:09:11 -0800
X-CSE-ConnectionGUID: zoy6pHvhRS2sqqmJHzuAdw==
X-CSE-MsgGUID: ZCJ3o19BQya+ybJL8bvBXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="212950777"
Received: from unknown (HELO [10.238.3.203]) ([10.238.3.203])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 19:09:06 -0800
Message-ID: <7f045418-6ce4-4f2f-a3ee-4ddc3cf2fda5@intel.com>
Date: Thu, 29 Jan 2026 11:09:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: x86: Harden against unexpected adjustments to
 kvm_cpu_caps
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260128014310.3255561-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69502-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 8FD84AB566
X-Rspamd-Action: no action

On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> Add a flag to track when KVM is actively configuring its CPU caps, and
> WARN if a cap is set or cleared if KVM isn't in its configuration stage.
> Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
> vendor setup code expects the CPU caps to be frozen at that point, e.g.
> will do additional configuration based on the caps.
> 
> Rename kvm_set_cpu_caps() to kvm_initialize_cpu_caps() to pair with the
> new "finalize", and to make it more obvious that KVM's CPU caps aren't
> fully configured within the function.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c   | 10 ++++++++--
>   arch/x86/kvm/cpuid.h   | 12 +++++++++++-
>   arch/x86/kvm/svm/svm.c |  4 +++-
>   arch/x86/kvm/vmx/vmx.c |  4 +++-
>   4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 575244af9c9f..7fe4e58a6ebf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -36,6 +36,9 @@
>   u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
>   
> +bool kvm_is_configuring_cpu_caps __read_mostly;

I prefer the name, kvm_cpu_caps_finalized. But not strongly, so

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

