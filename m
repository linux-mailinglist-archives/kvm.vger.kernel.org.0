Return-Path: <kvm+bounces-69300-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iCZAG6JneWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69300-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:34:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 157E19BED5
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7869F301953D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7857238178;
	Wed, 28 Jan 2026 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0/voP2e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47F1991CB;
	Wed, 28 Jan 2026 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564054; cv=none; b=GdFSHtwszp1J83legret+qe9kIDTxyjAW1P5Nd5YuIEhon0Mr/fRHoxDLFxjkGxtgwfbRX4sqVgjGTeIF01U+AYcuZjloROjx4AVvmFgIwBL4EzvMMJi1y/cUsKVoCT0GNBYQAAzYvGeOazCH5kZuc7G8b+qbnI/phZdqZ1WQLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564054; c=relaxed/simple;
	bh=aAYPh5TPK/vfiT78Squ9pWrx3KTzRn+qCmkivAFewNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l/8mk0SMA5QyXeRscQ7Y6uAg+BmZ2P+Iguvo5z/2OvtxQ8LS9HlycEqaItUxqt+hjDO/xUfdAAJt4JioyG/3A80eth1TEcJmHiW4o58ivbEYKUWfOAT0WC5XnL5UaeY5ksH3CRLoU3prZhO7Uty2pxiEF4tUGL37QcfvIqB+pbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0/voP2e; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769564052; x=1801100052;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aAYPh5TPK/vfiT78Squ9pWrx3KTzRn+qCmkivAFewNA=;
  b=J0/voP2egxwUOGHaczsVUmXdZKHtErw2hqHaRnsbuxzJvJlhxB6yjZ1M
   QdfN01DJXghdKnUDohklLQTaZkXq7L0KlggrBuS/nYAE7JVBbcd2XEqsl
   9N9+jenTjwCdZpyu0wANfr0V0WuUO434HohUBHjBClJxToMul8Of5ou53
   i5AUuYE0f5Z7oRASQnZA7C0f4BQMGf7Xeth4+32hwfNedtIHLJlvn1OXF
   Qb/xbs3ZmX8VzWMRF1pjINaygWEorcBKqxHT6O7fBtPK0SZnTaRYD0ASr
   NJ6iVd9e/DSOU2nmv9h3LAPrebOM+QQR7jTiFUuzPWtK6AJVbVt9X4N70
   Q==;
X-CSE-ConnectionGUID: 5Md6iNHFTfiU5ekz5LqOIw==
X-CSE-MsgGUID: vxOSyIWhStiBtozcwt8Now==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70826648"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="70826648"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 17:34:10 -0800
X-CSE-ConnectionGUID: EkU0K+txS1q0+J8xpptafw==
X-CSE-MsgGUID: 71fFB8RpRjWU3AbpcnA3og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="208024708"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 17:34:05 -0800
Message-ID: <35fa8047-7506-4a78-b493-732160c3d25c@linux.intel.com>
Date: Wed, 28 Jan 2026 09:34:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] x86/virt/tdx: Use %# prefix for hex values in
 SEAMCALL error messages
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-3-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
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
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.intel.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69300-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 157E19BED5
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
> "%#" format specifier automatically adds the "0x" prefix and has one less
> character than "0x%".
> 
> For conciseness, replace "0x%" with "%#" when printing hexadecimal values
> in SEAMCALL error messages.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> "0x%" is also used to print TDMR ranges. I didn't convert them to reduce
> code churn, but if they should be converted for consistency, I'm happy
> to do that.

Generally, is there any preference for coding in Linux kernel about
"0x%" VS. "%#"? Or developers just make their own choices?


> 
> v2: new
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index dbc7cb08ca53..2218bb42af40 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -63,16 +63,16 @@ typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
>  
>  static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
>  {
> -	pr_err("SEAMCALL (%llu) failed: 0x%016llx\n", fn, err);
> +	pr_err("SEAMCALL (%llu) failed: %#016llx\n", fn, err);
>  }
>  
>  static inline void seamcall_err_ret(u64 fn, u64 err,
>  				    struct tdx_module_args *args)
>  {
>  	seamcall_err(fn, err, args);
> -	pr_err("RCX 0x%016llx RDX 0x%016llx R08 0x%016llx\n",
> +	pr_err("RCX %#016llx RDX %#016llx R08 %#016llx\n",
>  			args->rcx, args->rdx, args->r8);
> -	pr_err("R09 0x%016llx R10 0x%016llx R11 0x%016llx\n",
> +	pr_err("R09 %#016llx R10 %#016llx R11 %#016llx\n",
>  			args->r9, args->r10, args->r11);
>  }
>  


