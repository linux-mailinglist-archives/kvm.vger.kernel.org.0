Return-Path: <kvm+bounces-46094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97388AB1F5C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 23:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7AAD1C46334
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 21:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DA82609F8;
	Fri,  9 May 2025 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uYAhK1H/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE88226CF4;
	Fri,  9 May 2025 21:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746827383; cv=none; b=RForPRk/UVY42WK3FP9PZZejo/pEJ+u66fP5VKO2GErsEh2w/p+PCRwGke2iWyHC4e1AMY+lyvIf7tchDhh32a9YBuJPA2R0ERQGLllA+QfFTy9MzKr6FxmZjg3JDTHosJHkslvnCvhMZolTtS9Pv3cZzhBINvTi6oIfwk+qBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746827383; c=relaxed/simple;
	bh=SiJ264L76W+iNGxah+QR+bqOGeUBSZ7lji/MNG6Rk4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ze/NDB7OKPt5z6kGPUeBiwbQdyhpg20xi0k4z7N88p2o9lSMWxeojCjn72vGJKzOOxZphONEM7Mp6Qg30x/G2zlDtlF89sRlGOlzUvVFcDmFMY+i3bin8qhoPYp5erAh1k/6AXU7SIKdkekTFSG68dd0ZI57r/F3LaPP/JsFJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uYAhK1H/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02004C4CEE4;
	Fri,  9 May 2025 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746827381;
	bh=SiJ264L76W+iNGxah+QR+bqOGeUBSZ7lji/MNG6Rk4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uYAhK1H/3ajc/630iBxlSZwFpfs7YQjH28MoAy/PNXdDe5ceNI2Ycnxt1dn+GTZ7d
	 Q3lsLH2TxYfYHz+IrJ3qB14PQJo3sJspgtFfVNbI8W2CuG4oyBhBZo1LP2UragiUPj
	 05tToUJo/K4GRvFE3hrbtcl3cCcwJhJZC4jMwKYPF//w+q7XKUk9iIZy2B6/5BbqAG
	 M+Q4oMqDgbf7hrL7a1JZuLFLOXpo9VdqQytFBt5g+A+xD4/yEJFMVJhJlxUAT4iNI7
	 afH+/8ACTMWKfAKZI6z5+xaLPzbvrXLxWPccl6Lm0FzuU4aNnm+LbWIiQpfIhxEwsf
	 i5CWn2npgfs4Q==
Date: Fri, 9 May 2025 21:49:39 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, xin@zytor.com,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/6] x86/msr: minimize usage of native_*() msr access
 functions
Message-ID: <aB54c5ajYkGZ1sPi@liuwe-devbox-ubuntu-v2.tail21d00.ts.net>
References: <20250506092015.1849-1-jgross@suse.com>
 <20250506092015.1849-4-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506092015.1849-4-jgross@suse.com>

On Tue, May 06, 2025 at 11:20:12AM +0200, Juergen Gross wrote:
> In order to prepare for some MSR access function reorg work, switch
> most users of native_{read|write}_msr[_safe]() to the more generic
> rdmsr*()/wrmsr*() variants.
> 
> For now this will have some intermediate performance impact with
> paravirtualization configured when running on bare metal, but this
> is a prereq change for the planned direct inlining of the rdmsr/wrmsr
> instructions with this configuration.
> 
> The main reason for this switch is the planned move of the MSR trace
> function invocation from the native_*() functions to the generic
> rdmsr*()/wrmsr*() variants. Without this switch the users of the
> native_*() functions would lose the related tracing entries.
> 
> Note that the Xen related MSR access functions will not be switched,
> as these will be handled after the move of the trace hooks.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/hyperv/ivm.c      |  2 +-

Acked-by: Wei Liu <wei.liu@kernel.org>

> 
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 09a165a3c41e..fe177a6be581 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -319,7 +319,7 @@ int hv_snp_boot_ap(u32 cpu, unsigned long start_ip)
>  	asm volatile("movl %%ds, %%eax;" : "=a" (vmsa->ds.selector));
>  	hv_populate_vmcb_seg(vmsa->ds, vmsa->gdtr.base);
>  
> -	vmsa->efer = native_read_msr(MSR_EFER);
> +	rdmsrq(MSR_EFER, vmsa->efer);
>  

