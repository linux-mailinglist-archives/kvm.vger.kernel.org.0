Return-Path: <kvm+bounces-48268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2143ACC12E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 757653A38A8
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6530326980D;
	Tue,  3 Jun 2025 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="pPDiTR0O"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A45E267F72;
	Tue,  3 Jun 2025 07:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748935508; cv=none; b=trZpUrBrCiSF723YCwoZpIMxLDmrb2f5uNUOo/AgkfGmRf83Wl3g6D5Wj0zhdd1RDAaEq0LbxzZylTt5JNHbrVBdgXTF7+mInQ7VE3zwklWbY5vi1bURiRrJKSnLdU9VcD7IeTHoQ67XcnHhIjB/OGDLE7eO/U2RTNByQucgnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748935508; c=relaxed/simple;
	bh=HSiydVzdKvNmaGbj4tGBgwBcK3tx9/JKEl44nSVv8DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lo23EiUta9S1Ta6E+7BDGvm6vhbdQwe0i+nUo2x51154gjywfSJ31W2AnwMUsOUkOlDLMfI8vKjh86JLpkwv7Z/dPhG3gNwDwNTutNXQ5xIAI1eQj4Kw/em4/Vgt3T8+8/SNTY405ooYQWc2P9O/fYMX3sHubMSlWUnVyrkc7bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=pPDiTR0O; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5537NsUt3751369
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 3 Jun 2025 00:23:55 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5537NsUt3751369
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1748935440;
	bh=aaqVJeEtJPDgcnRU0w0FJUnq7IQKBsxpIdRbtKHZrJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pPDiTR0O8ZfuH4ZBXXem53qDgsBrgtwbyPKhPw8loprHjEIJ+poRsNC8BHju1vAUM
	 uaSv6Hz92cC8H9Jo4UBrnkFn68dRBJQfMv1NeE6oNasLmT5zFRaC3Zz033C0GxKjMo
	 JaEOVOv/vayvWeyuLP3g9xOtfkhf9wKQE9kj/eLPEjzlYXpJmLpIfIn+6H57P2PXdg
	 W0ieqUTUcJaDxZKy59K45MYNVtLTrknk+iNkDxpxHSen0x3ETQp/tQHtwwFYbzwi3/
	 C9oI03FnOhqMaLS9B+3BeQPHtMwjdLswD7ttRGPGTuZ15JQeEXm6Lx2dIHIeFuU7+I
	 iv5aNX9wAn1UQ==
Message-ID: <5276d1ff-be9c-4391-ae64-4f7451f6ced8@zytor.com>
Date: Tue, 3 Jun 2025 00:23:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] x86/nmi: Extend the registration interface to
 include the NMI-source vector
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-4-sohil.mehta@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250513203803.2636561-4-sohil.mehta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/2025 1:37 PM, Sohil Mehta wrote:
> To prepare for NMI-source reporting, add a source vector argument to the
> NMI handler registration interface. Later, this will be used to
> register NMI handlers with a unique source vector that can be used to
> identify the originator of the NMI.
> 
> For now, just extend the interface and pass zero as the source vector
> for all handlers. No functional change intended.
> 
> Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>

Just two nits below, other than that:

Reviewed-by: Xin Li (Intel) <xin@zytor.com>
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index 79d88d12c8fb..f0a577bf7bba 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -54,6 +54,7 @@ struct nmiaction {
>   	u64			max_duration;
>   	unsigned long		flags;
>   	const char		*name;
> +	u8			source_vector;
>   };
>   
>   /**
> @@ -62,6 +63,7 @@ struct nmiaction {
>    * @fn:   The NMI handler
>    * @fg:   Flags associated with the NMI handler
>    * @n:    Name of the NMI handler
> + * @src:  NMI-source based vector for the NMI handler

"NMI-source based" sounds weird to me.

>    * @init: Optional __init* attributes for struct nmiaction
>    *
>    * Adds the provided handler to the list of handlers for the specified
> @@ -75,13 +77,14 @@ struct nmiaction {
>    *
>    * Return: 0 on success, or an error code on failure.
>    */
> -#define register_nmi_handler(t, fn, fg, n, init...)	\
> +#define register_nmi_handler(t, fn, fg, n, src, init...)	\
>   ({							\
>   	static struct nmiaction init fn##_na = {	\
>   		.list = LIST_HEAD_INIT(fn##_na.list),	\
>   		.handler = (fn),			\
>   		.name = (n),				\
>   		.flags = (fg),				\
> +		.source_vector = (src),			\
>   	};						\
>   	__register_nmi_handler((t), &fn##_na);		\
>   })
Please keep the line-ending backslashes (\) aligned.

I guess you want to keep the change minimal.

