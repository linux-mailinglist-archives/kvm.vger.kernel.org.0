Return-Path: <kvm+bounces-43560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6180A91A33
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 13:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD5CE19E2923
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F4D237702;
	Thu, 17 Apr 2025 11:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZIADA/NB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C20C23645F;
	Thu, 17 Apr 2025 11:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744888345; cv=none; b=S9227j0ssDDFMosFj1z5u3/q2oW9pB/sY8vL4Xsl7GinHmaJt00rrWM4WFCifZjoLgC3A6Lr1uGERavvtv/7vnJigoPhTtozjifZiuSJT1ZhtwbRIZ+DI47ZPZ/m4QJh097o9iHc8zNSCewucGItmiE3EC73j8FSXmhCvCLWDz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744888345; c=relaxed/simple;
	bh=zKR49UWsXQlKIMA1VnL+BkqgO+3iF8iLPVDDfF2KoTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJv86Il9HqLtscLyVepF/2S8m/x0VJulXPSa8zvBWZuchr/O4G6UWUyWFznvNE8KjgnwSqRoajoPJpzF2/wy4MpHHYFytP+KKoPa/sfquDczEHSfMFI+RNlieWHMDIr/7cCW3iixL2DS6JcI2oLoGR6XHX/tZxPEdTqhAfK/izs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZIADA/NB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53HBB0dU3967739
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 17 Apr 2025 04:11:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53HBB0dU3967739
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744888264;
	bh=zKR49UWsXQlKIMA1VnL+BkqgO+3iF8iLPVDDfF2KoTE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZIADA/NBWFdjMUgJTKpv9M9Wy2YG9IZEPFByL8wYabsxbBoRuZfKRlm/KXHCD1Dct
	 p+vwf14YsIuc+VHp9bDfack/1J0ZEDi3/LMHCo05xDW9TD4JrJ0GM5fVVA/piqxPhD
	 UyV8JWSU0hR2PMwkuYuHLcqgii53bDcW9KmA0ITTnJZG4RxQYf1Gr8LMHk+DKpR9xo
	 v/L3GNQ4ChUSYncpwgOQsPYYlB/v/0qZd/JiW4t/kLzx/6ZLdqruZ97wB6zyl1mziC
	 tKwEE+12hM3fNBR36tO17t9Oq8pShTsP2t1ihwsRhIESP8RHTn9IcCLiPfhw0jeR7+
	 9wRv9KyfJmA3A==
Message-ID: <edbeb41d-3c38-4778-9a7c-255edc7cd5fb@zytor.com>
Date: Thu, 17 Apr 2025 04:10:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 13/15] x86/msr: Use the alternatives mechanism to
 read MSR
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: acme@kernel.org, adrian.hunter@intel.com, ajay.kaher@broadcom.com,
        alexander.shishkin@linux.intel.com, andrew.cooper3@citrix.com,
        bcm-kernel-feedback-list@broadcom.com, boris.ostrovsky@oracle.com,
        bp@alien8.de, bpf@vger.kernel.org, dave.hansen@linux.intel.com,
        decui@microsoft.com, haiyangz@microsoft.com, hpa@zytor.com,
        irogers@google.com, jgross@suse.com, jolsa@kernel.org,
        kan.liang@linux.intel.com, kvm@vger.kernel.org, kys@microsoft.com,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        llvm@lists.linux.dev, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, seanjc@google.com, tglx@linutronix.de,
        tony.luck@intel.com, virtualization@lists.linux.dev,
        vkuznets@redhat.com, wei.liu@kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
References: <0f4f2ed70829fffb2eb816e34e26be22681705a5.camel@gmail.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <0f4f2ed70829fffb2eb816e34e26be22681705a5.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/2025 10:13 AM, Francesco Lavra wrote:
> This works only if this function has been called directly (e.g. via
> `call asm_xen_write_msr`), but doesn't work with alternative call types
> (like indirect calls). Not sure why one might want to use an indirect
> call to invoke asm_xen_write_msr, but this creates a hidden coupling
> between caller and callee.
> I don't have a suggestion on how to get rid of this coupling, other
> than setting ipdelta in _ASM_EXTABLE_FUNC_REWIND() to 0 and adjusting
> the _ASM_EXTABLE_TYPE entries at the call sites to consider the
> instruction that follows the function call (instead of the call
> instruction) as the faulting instruction (which seems pretty ugly, at
> least because what follows the function call could be an instruction
> that might itself fault). But you may want to make this caveat explicit
> in the comment.

Good idea, will state that in the comment.

