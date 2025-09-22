Return-Path: <kvm+bounces-58369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4450DB8F8CC
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6842A07A7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478582FFDF7;
	Mon, 22 Sep 2025 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jclQok3a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FBF2FE560;
	Mon, 22 Sep 2025 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758529783; cv=none; b=lfNHZd4BRqz0ZMHw6ewRr4dhC6qFB3kFoQ7jqAcUlIMSlM+V5xT//vJA5296QoXGkDWsUbp+km6NKp//Kg1JLDB3AUALy/sK1WmegXwn8bkUvJA9YiMZchzEIZbixP1L2jweL0i1IxQOm6kEepjhjA1Ibm9ntc4rpPQ2e4c4uDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758529783; c=relaxed/simple;
	bh=5r3HNYK1LoTYVBKggoCHH4XfI4B9WoLDAPbnJlBl6Io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofrvSB6baZCw7miJhzTsWtv2ayr0KhlmFpdVz6hsSEJr2lnnraWMx4L9/g5rzkfCsCx2F++Cw//ns5KARLY0T8qM1JQwcYqmPIfEBMSh8uEjFEBOLJHuBzlK0RAu1wom2TKHEVyfmA3ZfspvUXcIyw9+g55Z+MiJ/Pa6WzgTvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jclQok3a; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758529782; x=1790065782;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5r3HNYK1LoTYVBKggoCHH4XfI4B9WoLDAPbnJlBl6Io=;
  b=jclQok3aVbHGb4ixY1/IVAHXMGOYVnfWDfdPXpcste7Ren41/qXMjOBb
   6bn0ugRc9BsNmhgJNc6N8XwNFEJbDK1cO8bM7Y2KV/INw/8dM0e5XaHuH
   k9fV6IrjgepBI4hW+dpptC67dq98g8auw2QCiXLAraEwxR1dYfykjbZPy
   8853UbOsy155T9GuPZsmQ6agVfxZjc2GA+tnniThBsaLfjIJC4nYVFEng
   JEWGhkdqVXiN8usApfolQJ0X73kcGIv+D/J/q1otmJOUo5F74tbxp8Npi
   A1z2csrgKDy2mE9y2yRH7RnSQdarXzxPic8t//IQ1Atdt/ecj/GoSe2gP
   g==;
X-CSE-ConnectionGUID: u5YvFeIqRreujwNBLBJ2fA==
X-CSE-MsgGUID: ppGkLR75T/qzRf3/gS+naQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71463414"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71463414"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:29:41 -0700
X-CSE-ConnectionGUID: 8outSjVsTFeDiRPMSraaCw==
X-CSE-MsgGUID: G6l9sVMLTRqrhCs8jQsLQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="207380777"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:29:38 -0700
Message-ID: <3eb74bd9-5b0d-4673-9feb-124844431939@linux.intel.com>
Date: Mon, 22 Sep 2025 16:29:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 42/51] KVM: x86: Define Control Protection Exception
 (#CP) vector
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-43-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-43-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Add a CP_VECTOR definition for CET's Control Protection Exception (#CP),
> along with human friendly formatting for trace_kvm_inj_exception().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/uapi/asm/kvm.h | 1 +
>   arch/x86/kvm/trace.h            | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 467116186e71..73e0e88a0a54 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -35,6 +35,7 @@
>   #define MC_VECTOR 18
>   #define XM_VECTOR 19
>   #define VE_VECTOR 20
> +#define CP_VECTOR 21
>   
>   /* Select x86 specific features in <linux/kvm.h> */
>   #define __KVM_HAVE_PIT
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 06da19b370c5..322913dda626 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -462,7 +462,7 @@ TRACE_EVENT(kvm_inj_virq,
>   #define kvm_trace_sym_exc						\
>   	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
>   	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF), EXS(MF),	\
> -	EXS(AC), EXS(MC), EXS(XM), EXS(VE)
> +	EXS(AC), EXS(MC), EXS(XM), EXS(VE), EXS(CP)
>   
>   /*
>    * Tracepoint for kvm interrupt injection:


