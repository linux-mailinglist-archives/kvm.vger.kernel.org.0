Return-Path: <kvm+bounces-68452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E72E8D39C23
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 159313006A83
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 01:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DF521A434;
	Mon, 19 Jan 2026 01:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PP71gsNx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0F71E531
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 01:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768787266; cv=none; b=ORy9a0Bv/YvRmKWirflFOeCz/8NlEf1OgDqMcIJEOoYQrzQlhMIMEji+j6599gU2eaPu2rHpeRkrNnO9eNBIkOitTw0s/dANJa+uXYkcluoD5dJe1ztBMbp8yH6iR0ENwXpeS5GCkEVWYCQNuoItSGBLS6LykmYc7gSLV5WDLcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768787266; c=relaxed/simple;
	bh=5sXjbnnMJ6gQVd2D/+RSqklYdAvGFuLASzaMCw7XAjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oDkoJW4LcLbUAuToEvncDnb6UFaBpCoLjQY8W94d5SYiCCOkjh0EbrevpyaO/COZGGu0cOX2LKgUjquH19oX7SphBh97/hiZCwsetD1xBi5TIVusoFl4QcKHMG0CTUw0sWtmzDLvPLx07SoobKlwjtQMk8oY859dDjDyjjLli+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PP71gsNx; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768787265; x=1800323265;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5sXjbnnMJ6gQVd2D/+RSqklYdAvGFuLASzaMCw7XAjs=;
  b=PP71gsNxAbmGqMF6Wka0oETcyWfNR2aa80cL4+bf73mWcZuabSvO/pYm
   HRz130WyltpLzDquJNTkjlnd4IRL8kTOdF0M2JnEk78lDJIhoG2S4mnqF
   nPsxmygUZs23/OWjJxKwyfxh/frSTFNYIgKt4d5df1uscLPit0CLr4uEa
   HNeYoXNLiRjodC815qR3a/9N6LRzymBjZWJgcIQliAZyucYQ/6Dx8IJqD
   wbwyZVPbUv89KbsRqAzLjaR5O81vFaCQR94boldtlFkOczEMFKOtl8s/x
   3jiIfT1TsDyXjAYtH59NiOJEFz08cAR8Eh6cYtt+1ytcfSknavdrsTLqi
   g==;
X-CSE-ConnectionGUID: 7UbLyGaGSnqW90FHBKm9Wg==
X-CSE-MsgGUID: 5eLGyjUZTfubnUCDhgEY9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80719575"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="80719575"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:47:44 -0800
X-CSE-ConnectionGUID: W3OTvNw+R5OYEIx5fhQh7Q==
X-CSE-MsgGUID: bZCKTQSMSWKLe2i1c/5Nww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205798066"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:47:41 -0800
Message-ID: <d3be3cd0-5dce-4410-b2f8-e137562a678c@linux.intel.com>
Date: Mon, 19 Jan 2026 09:47:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] target/i386: Disable unsupported BTS for guest
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-2-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260117011053.80723-2-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/17/2026 9:10 AM, Zide Chen wrote:
> BTS (Branch Trace Store), enumerated by IA32_MISC_ENABLE.BTS_UNAVAILABLE
> (bit 11), is deprecated and has been superseded by LBR and Intel PT.
>
> KVM yields control of the above mentioned bit to userspace since KVM
> commit 9fc222967a39 ("KVM: x86: Give host userspace full control of
> MSR_IA32_MISC_ENABLES").
>
> However, QEMU does not set this bit, which allows guests to write the
> BTS and BTINT bits in IA32_DEBUGCTL.  Since KVM doesn't support BTS,
> this may lead to unexpected MSR access errors.
>
> Setting this bit does not introduce migration compatibility issues, so
> the VMState version_id is not bumped.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
>  target/i386/cpu.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2bbc977d9088..f2b79a8bf1dc 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -474,7 +474,10 @@ typedef enum X86Seg {
>  
>  #define MSR_IA32_MISC_ENABLE            0x1a0
>  /* Indicates good rep/movs microcode on some processors: */
> -#define MSR_IA32_MISC_ENABLE_DEFAULT    1
> +#define MSR_IA32_MISC_ENABLE_FASTSTRING    1

To keep the same code style and make users clearly know the macro is a
bitmask, better define MSR_IA32_MISC_ENABLE_FASTSTRING like below.

#define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)


> +#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
> +#define MSR_IA32_MISC_ENABLE_DEFAULT       (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
> +                                            MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)

Better move the macro "MSR_IA32_MISC_ENABLE_DEFAULT" after
"MSR_IA32_MISC_ENABLE_MWAIT".


>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>  
>  #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))

