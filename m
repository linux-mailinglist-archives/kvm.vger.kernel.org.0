Return-Path: <kvm+bounces-56979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A73B4900E
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B143ACC18
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4A130BF54;
	Mon,  8 Sep 2025 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8lRMQMZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ABA306B35;
	Mon,  8 Sep 2025 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339196; cv=none; b=m186y7nxLlOJ17K3LBy7h9zfRXJzObvpoU3ZrHO2h5LLu08Yu7tcZiKxzvUS+w9Z77tDbtnLoBShac7X/b67HTL8Fu0ui3ZNwJal20Vl00+9zheLgI/+vw/UEowY1Oaun1u3jREOSa95TCnlFuc7lywK2LtyZMuIDwDVgZkOkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339196; c=relaxed/simple;
	bh=CTe4rGRu7tQeVsXNFvoCD5+pC/mdlOMNsYbe3nACYh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SdWz5aIogjzwDSbHGfHB4CMa9Y1elwA9TIYi/cX1WVfNPcX+iBgQFziiaaNN8Sci9Add91BcoG1LcR9h7C0Om2PrJmwiLisUbA2NcwigdrkO7sVGwKN6X/5Ell7HguePpjqplTIZuqxzUh+8oHiZGxYJSkk25S5mCFJn1Ny6XSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8lRMQMZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED23CC4CEF7;
	Mon,  8 Sep 2025 13:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757339195;
	bh=CTe4rGRu7tQeVsXNFvoCD5+pC/mdlOMNsYbe3nACYh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j8lRMQMZKzJAMXGs2/yg5yLBIF9HGu4r5h1bpyMi/dedTvIpmB+GJXqR7cfrxwLX+
	 SxEo1u0zexPUAF1FLCt/3h4a4TyQVeGg4BQZ0SsciXD+3LlSvAUiPFnrPbWjJPA4r6
	 iCRHb82NqfQy/LQJDb1vybEXprBtJLnMUOZNKKh6kA2oNXV/6MLaXz60awMBLlnyXN
	 tfUJTJbuvPnKWDOMbrvGe6hX1RnupFViXIpnTQg+L0OLaS5NXA659feS7HhAcRclQi
	 eOt2ZDFkrj/+EjPxAVvO564l9/gf6NNMBD1XpgDEXzSqOqPNGl2SiYzVW9r4/dXbPL
	 FGqBaGlfiTM9w==
Date: Mon, 8 Sep 2025 19:11:55 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 05/12] KVM: x86: Add emulation support for Extented
 LVT registers
Message-ID: <xnwr5tch7yeme3feo6m4irp46ju5lu6gr4kurn6oxlgoutvabt@3k3xh2pbdbje>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052238.209184-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901052238.209184-1-manali.shukla@amd.com>

On Mon, Sep 01, 2025 at 10:52:38AM +0530, Manali Shukla wrote:
> From: Santosh Shukla <santosh.shukla@amd.com>
> 
> The local interrupts are extended to include more LVT registers in
> order to allow additional interrupt sources, like Instruction Based
> Sampling (IBS) and many more.
> 
> Currently there are four additional LVT registers defined and they are
> located at APIC offsets 400h-530h.
> 
> AMD IBS driver is designed to use EXTLVT (Extended interrupt local
> vector table) by default for driver initialization.
> 
> Extended LVT registers are required to be emulated to initialize the
> guest IBS driver successfully.
> 
> Please refer to Section 16.4.5 in AMD Programmer's Manual Volume 2 at
> https://bugzilla.kernel.org/attachment.cgi?id=306250 for more details
> on Extended LVT.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Co-developed-by: Manali Shukla <manali.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/apicdef.h | 17 ++++++++++++++
>  arch/x86/kvm/cpuid.c           |  6 +++++
>  arch/x86/kvm/lapic.c           | 42 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/lapic.h           |  1 +
>  arch/x86/kvm/svm/avic.c        |  4 ++++
>  arch/x86/kvm/svm/svm.c         |  6 +++++
>  6 files changed, 76 insertions(+)
> 

<snip>

> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a34c5c3b164e..1b46de10e328 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -669,6 +669,10 @@ static bool is_avic_unaccelerated_access_trap(u32 offset)
>  	case APIC_LVTERR:
>  	case APIC_TMICT:
>  	case APIC_TDCR:
> +	case APIC_EILVTn(0):
> +	case APIC_EILVTn(1):
> +	case APIC_EILVTn(2):
> +	case APIC_EILVTn(3):

This should actually be conditional on X86_FEATURE_EXTLVT.

I also forgot to add for the previous patch: the feature name needs to 
be changed to reflect the true nature of the feature bit.


- Naveen


