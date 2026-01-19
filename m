Return-Path: <kvm+bounces-68468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F968D39E25
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C5A93032AB3
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5079E25A62E;
	Mon, 19 Jan 2026 05:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTG0ZvNO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B351B424F;
	Mon, 19 Jan 2026 05:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802163; cv=none; b=PjHLMBOulJX1eZUgFMWuRMdFrdlVnooxqrAybjawaAYQoATjDR230tGN0s20+uk+F6GLY0PQL5w042XNHI1XgCbbOa+NIPgymuYKBWup0XbqdHUQi+Aq9j4WPQdKmDUQCdH6bXxJ7Km/k1FRb6XPQNRmAbbfn45kS509dNs0brg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802163; c=relaxed/simple;
	bh=q89dLAPqhbmZ5LGxQZAnAGCJEDTl3eLYuXVT/VALPTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dvb1Tg2fATeXgucrt1OpMyzKjlDEXZIaPLTqCNIqOokgVrVIbT56IXxn1wg3UDcxixcUdGDiWYImgEUROZvbtGQan4WORjj1+SRZhcN4Qn/fciBAJ/54JxGl0GPf2UPzOMozUFxdzXqyfhwUtI+D8uO6kiEgR5ggbDsXbLF92YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTG0ZvNO; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768802161; x=1800338161;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q89dLAPqhbmZ5LGxQZAnAGCJEDTl3eLYuXVT/VALPTk=;
  b=QTG0ZvNONbq9kzQo707W1s30C4JBMalsehZevnBpCs7db0sNe4MPcayM
   qkhXZUaLzmyzuFfwcUK4tks0fr/Gq/XPkWXl8fHetKjcos6tDNDFWA3fE
   2LK12hDZy+pDMK9Vse1fA5A8fSNRExk3Q9yQlZZxReY1QWq2rhLotW9W0
   u1F/qRN5LZ8BsK4t+cg+bQhfU33ltr2uSapejph2xaLOQOehP7R3SGsZN
   wv9I9YhR/TbLNPryht+jlNEtI20CRhS63htKxotXaRskcBpCbl5BCOtYQ
   kkhST9MEROEtS9NQM5dMNk6H8zJtHT0QtQS90nwUeBBDKVfD+Q+qDlKoh
   w==;
X-CSE-ConnectionGUID: RdnthPLnQO6KrjLn/r8Waw==
X-CSE-MsgGUID: Hg+ZKgy9RFCOpngy6JtDlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="92679688"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="92679688"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:56:01 -0800
X-CSE-ConnectionGUID: Ou77wQqqTWyo4pIuYtWDmw==
X-CSE-MsgGUID: 7uRQ/pE2SHmoJX+iPlR8Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="205680161"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:55:58 -0800
Message-ID: <2dd73d71-ae88-4b17-8229-2cebecca7782@intel.com>
Date: Mon, 19 Jan 2026 13:55:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit to
 guests
To: "Chang S. Bae" <chang.seok.bae@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com,
 Peter Fang <peter.fang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-15-chang.seok.bae@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260112235408.168200-15-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+ Rick and Binbin

On 1/13/2026 7:54 AM, Chang S. Bae wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 189a03483d03..67b3312ab737 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -214,7 +214,8 @@ static DEFINE_PER_CPU(struct kvm_user_return_msrs, user_return_msrs);
>   #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
>   				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> -				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
> +				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE \
> +				| XFEATURE_MASK_APX)
>   

Not any intention of this patch, but this change eventually allows the 
userspace to expose APX to TDX guests.

Without any mentioning of TDX APX tests and validation like the one for 
CET[1], I think it's unsafe to allow it for TDX guests. E.g., the worst 
case would be KVM might need extra handling to keep host's 
states/functionalities correct once TD guest is able to manage APX.

I'm thinking maybe we need introduce a supported mask, 
KVM_SUPPORTED_TD_XFAM, like KVM_SUPPORTED_TD_ATTRS. So that any new XFAM 
related feature for TD needs the explicit enabling in KVM, and people 
work on the new XSAVE related feature enabling for normal VMs don't need 
to worry about the potential TDX impact.

[1] 
https://lore.kernel.org/all/ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com/

