Return-Path: <kvm+bounces-33544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3AC39EDE00
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA67018860DA
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 03:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E561531C4;
	Thu, 12 Dec 2024 03:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b70e8/AF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EF138DDB
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 03:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733975053; cv=none; b=qQHieCAlxbsMe5DmH9mtJCwDl8wPHKStBf1+b5lMPUvStCZISrvNNSo0H9KqFH+6ilPQsjwi0BEKRORz2FQx/2wvXjyR13u+1NEbdEy3qxjfkRqiasaa18+KzHtHYj7OVFdSItX89X8qKUlr3kar6/khxlsBerH5HSlwdso2UUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733975053; c=relaxed/simple;
	bh=+wucua3PkIdimHEQpSJ5QJWaEULv43kIlkiXzrAGwhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YKgh8/Nndqbec3aiHbSUPTHUH++MFTdAFBF+IzPc1uz9ccR5Ac7cHf6v8Q4dPdAzdnuekHEvZFz1OitOZIO6oyb8qgNpu28sAGcwhDk4mlb05tdacB2r9iPFYJiBm/r9cnCWeKccGWqejrZHcdlpg1Z2236OwinEnh24Vnua3uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b70e8/AF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733975051; x=1765511051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+wucua3PkIdimHEQpSJ5QJWaEULv43kIlkiXzrAGwhU=;
  b=b70e8/AFGXCqSe4ZBIMmOAlIXx2pYn7AL8O/uk+iFhriwGKiYOpvYu7S
   4bEhQLZviWwp1WwjmqIcm3o68RjpM6p2jvYf89imDEk+U0bBUZzlGI+p9
   Qkd7Mj/w2w56EXKCXl50fzWIrU7JYzg3gl4oxtsIqwpCKSJUwbtO7YcqX
   /0XSgbjj+0OpG2v4VSfMNZOvE0b8IA/FnOcIR53X6LJ5idEz3aYFrZLL9
   tNFYx0tEotd+9sAxxJKpqgQzl1nMFVZne+onAGBPqdwhKOvluDsablcOE
   OYUSTd+XHlOOfGkuM/0LyIdJHjGCVF0FdKGKnWCVcgF6yvqFKPvbQUFrW
   g==;
X-CSE-ConnectionGUID: FlOQMAB5Qy69ZjLsZyKTjQ==
X-CSE-MsgGUID: 0aB7zYbtQmmzEtm2pOG+Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="33707635"
X-IronPort-AV: E=Sophos;i="6.12,227,1728975600"; 
   d="scan'208";a="33707635"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 19:44:10 -0800
X-CSE-ConnectionGUID: iS/EYUjbQdaGI1JbhbAplw==
X-CSE-MsgGUID: JCZugvyySKm22cOSJglwLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101033599"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 19:44:08 -0800
Message-ID: <2144c2c0-4a5d-4efd-b5e2-f2b4096c08b5@intel.com>
Date: Thu, 12 Dec 2024 11:44:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
 qemu-devel@nongnu.org
Cc: seanjc@google.com, michael.roth@amd.com, rick.p.edgecombe@intel.com,
 isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241212032628.475976-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/2024 11:26 AM, Binbin Wu wrote:
> Userspace should set the ret field of hypercall after handling
> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
> 
> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
> otherwise, TDX guest boot could fail.
> A matching QEMU tree including this patch is here:
> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
> 
> Previously, the issue was not triggered because no one would modify the ret
> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
> https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
> value could be modified.
> ---
>   target/i386/kvm/kvm.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8e17942c3b..4bcccb48d1 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>   
>   static int kvm_handle_hypercall(struct kvm_run *run)
>   {
> +    int ret = -EINVAL;
> +
>       if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> -        return kvm_handle_hc_map_gpa_range(run);
> +        ret = kvm_handle_hc_map_gpa_range(run);
> +
> +    run->hypercall.ret = ret;

Updating run->hypercall.ret is useful only when QEMU needs to re-enter 
the guest. For the case of ret < 0, QEMU will stop the vcpu.

I think we might need re-think on the handling of KVM_EXIT_HYPERCALL. 
E.g., in what error case should QEMU stop the vcpu, and in what case can 
QEMU return the error back to the guest via run->hypercall.ret.

> -    return -EINVAL;
> +    return ret;
>   }
>   
>   #define VMX_INVALID_GUEST_STATE 0x80000021
> 
> base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7


