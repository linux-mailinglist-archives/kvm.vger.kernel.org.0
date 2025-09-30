Return-Path: <kvm+bounces-59222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A39FBAE6F8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 21:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A4FF1883C7B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A29128642E;
	Tue, 30 Sep 2025 19:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KmHeNLZj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45102AD0C;
	Tue, 30 Sep 2025 19:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759260083; cv=none; b=gEK+xSbTdupbZEOxGhF/DBo/o5NsBrYloR310xVbtEGJu+ep0DuyuN4+kgi9Rs43gyVCSJVIC5CA2wNXgtLmtfIEEtdiskSJ+xZ3EtFp+7tlxpG8zn43v2mEAJSSZ0mF/veWQ1iTm3WQuOQe52irDtFx21G0BcwZm9CH2x0gYrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759260083; c=relaxed/simple;
	bh=SvJ8S7Nw/fPta0kTc9ASSeJSDJulLZWtqNWEtdEqeps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ne3IRwIfilvqcMQAEwlo+CpRfsW9ooAt5w/1PRRiTEXm5t7TvPwCaR6kKafpEHmXwsLAhJK+oB3t5OuNaDini6Xwk2VagR0RV0rVlKqEHfGjW6X28wHtkBKNucieW0TsI9f1qMkLCgHqrjs3C/UU75aug7OBjbf1CnElzGGUOsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KmHeNLZj; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [IPV6:2601:646:8081:9484:3373:e8bd:aaa4:7c23] ([IPv6:2601:646:8081:9484:3373:e8bd:aaa4:7c23])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58UJJc0q376069
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 30 Sep 2025 12:19:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58UJJc0q376069
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1759259981;
	bh=5jKsWr8QEv1dE0BHGjK4jG5jy4dVCkN+HP+b8pZLYWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KmHeNLZj/n0P3Bx95LFzhVuxLXrHMsWLMMJ2Gm4H8FNamSlw/ykdibwr0KiTsB1Hx
	 kimmmjaE4PQNu82809DGZ+bXQB5PtFK+1BIkP2kit+wX/G9oZjCTGQQ4NBn3eyeroN
	 igAJ5wylIhFE9616RLBxQ4fa1M/81mz3016d0y5QrZzka0FJXVai2ABAi7s6qurIZU
	 UCt7L6g9U8v2bHT5kR3usV/nGI4JUG2MRe34f5yvbCfc1Wc8a+J7TpEqXyLIfbRGUg
	 AzbRtlbso5/anwJIMETPoxFJcMs4aRnGHHmG/oIvBJHSwcgPCKq+EsfPpQlRB7rZB1
	 WCrrEfyQwfYwQ==
Message-ID: <1412c7a5-8961-4949-b09e-7b9d080ce9bf@zytor.com>
Date: Tue, 30 Sep 2025 12:19:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] x86/msr: Inline rdmsr/wrmsr instructions
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        llvm@lists.linux.dev
Cc: xin@zytor.com, "Kirill A. Shutemov" <kas@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>,
        Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nathan Chancellor
 <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
References: <20250930070356.30695-1-jgross@suse.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20250930070356.30695-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-09-30 00:03, Juergen Gross wrote:
> When building a kernel with CONFIG_PARAVIRT_XXL the paravirt
> infrastructure will always use functions for reading or writing MSRs,
> even when running on bare metal.
> 
> Switch to inline RDMSR/WRMSR instructions in this case, reducing the
> paravirt overhead.
> 
> In order to make this less intrusive, some further reorganization of
> the MSR access helpers is done in the first 5 patches.
> 
> The next 5 patches are converting the non-paravirt case to use direct
> inlining of the MSR access instructions, including the WRMSRNS
> instruction and the immediate variants of RDMSR and WRMSR if possible.
> 
> Patch 11 removes the PV hooks for MSR accesses and implements the
> Xen PV cases via calls depending on X86_FEATURE_XENPV, which results
> in runtime patching those calls away for the non-XenPV case.
> 
> Patch 12 is a final little cleanup patch.
> 
> This series has been tested to work with Xen PV and on bare metal.
> 
> This series is inspired by Xin Li, who used a similar approach, but
> (in my opinion) with some flaws. Originally I thought it should be
> possible to use the paravirt infrastructure, but this turned out to be
> rather complicated, especially for the Xen PV case in the *_safe()
> variants of the MSR access functions.
> 

Looks good to me.

(I'm not at all surprised that paravirt_ops didn't do the job. Both I and Xin
had come to the same conclusion.)


Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>

