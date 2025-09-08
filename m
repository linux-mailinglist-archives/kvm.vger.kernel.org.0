Return-Path: <kvm+bounces-56978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB45BB4900F
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 800587AE2A5
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FDA2FC896;
	Mon,  8 Sep 2025 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbqKNgQb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B242FF153;
	Mon,  8 Sep 2025 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339192; cv=none; b=kGPbVIcBP3dR1wfy3kAjyxz6JecE+woPBsGb+MOBqa3QqOtX981KUJMt+tb8dP75Z5F/Uhx+or8aKOHyKz6ciuHwe0Bv2AiHnHBU+nL1XMEt2af6hAoUw2gy4bNoPlGBoJWuhty0XPCPaq4bX3kn5aWqLenDC0BcDyBa6he/2ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339192; c=relaxed/simple;
	bh=vp3Ll0DD8f6GHuC6ep/boDdVQoM4zx28t3tUYlvipAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axYMlWNGtiB+cjepI2Y6WwnR0quy5C3autfJqNAm4P4ubBcBPLLvnDwJCFP4JuMNRWLIx/SQJABDqUpMejKx/8K/ObJdOlTaq1Ag+tHn4R361nPbCi2PW2E5EjpGB25mvvD+Bd3a4tp7WZr2H/7Qoy5qN4exGJOSWsGLAcGC2cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbqKNgQb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6321CC4CEF1;
	Mon,  8 Sep 2025 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757339192;
	bh=vp3Ll0DD8f6GHuC6ep/boDdVQoM4zx28t3tUYlvipAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VbqKNgQb30mJAz3xeH4qBnsukYcMxuJ/Cw/0QQxLu9Y9gHT/3s7tMlP3CCD5phpZX
	 0vQZkJBcOEw+i9PAwKGz8klrX5fYrng6qoOlREsnkcIdDxNZ731A13w8YT2CU7wXC+
	 Fyb/ftYaA5HesuKL6u3V+ncYjY7V9K+upmv7Fy59/kkeHsBfiWVAxENLhItPm5+4Na
	 /SRj83XI+ILHDwTow7fdXkHYLVNZeW3hclbtkMTlBFl1QZ9ShpfS8lqi9csCTSJ9Y6
	 pqXqSOcL2muT8niikgnTtfwk3P7loDEf+2m4XUqgNiwhIJ83XnXgSCsIJWTdDYgFkb
	 CV6Ln400inaPQ==
Date: Mon, 8 Sep 2025 19:09:41 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 04/12] x86/cpufeatures: Add CPUID feature bit for
 Extended LVT
Message-ID: <kgavy7x2hweqc5fbg65fwxv7twmaiyt3l5brluqhxt57rjfvmq@aixr2qd436a2>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052212.209171-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250901052212.209171-1-manali.shukla@amd.com>

On Mon, Sep 01, 2025 at 10:52:12AM +0530, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> Local interrupts can be extended to include more LVT registers in
> order to allow additional interrupt sources, like Instruction Based
> Sampling (IBS).
> 
> The Extended APIC feature register indicates the number of extended
> Local Vector Table(LVT) registers in the local APIC.  Currently, there
> are 4 extended LVT registers available which are located at APIC
> offsets (400h-530h).
> 
> The EXTLVT feature bit changes the behavior associated with reading
> and writing an extended LVT register when AVIC is enabled. When the
> EXTLVT and AVIC are enabled, a write to an extended LVT register
> changes from a fault style #VMEXIT to a trap style #VMEXIT and a read
> of an extended LVT register no longer triggers a #VMEXIT [2].
> 
> Presence of the EXTLVT feature is indicated via CPUID function
> 0x8000000A_EDX[27].
> 
> More details about the EXTLVT feature can be found at [1].
> 
> [1]: AMD Programmer's Manual Volume 2,
> Section 16.4.5 Extended Interrupts.
> https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> [2]: AMD Programmer's Manual Volume 2,
> Table 15-22. Guest vAPIC Register Access Behavior.
> https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 286d509f9363..0dd44cbf7196 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -378,6 +378,7 @@
>  #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
> +#define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */

Per APM Vol 3, Appendix E.4.9 "Function 8000_000Ah", bit 27 is:
ExtLvtAvicAccessChgExtended: Interrupt Local Vector Table Register AVIC 
Access changes. See “Virtual APIC Register Accesses.”

And, APM Vol 2, 15.29.3.1 "Virtual APIC Register Accesses" says:
Extended Interrupt [3:0] Local Vector Table Registers:
	CPUID Fn8000_000A_EDX[27]=1:
		Read: Allowed
		Write: #VMEXIT (trap)
	CPUID Fn8000_000A_EDX[27]=0:
		Read: #VMEXIT (fault)
		Write: #VMEXIT(fault)

So, as far as I can tell, this feature is only used to determine how 
AVIC hardware handles accesses to the extended LVT entries. Does this 
matter for vIBS? In the absence of this feature, we should take a fault 
and KVM should be able to handle that.


- Naveen


