Return-Path: <kvm+bounces-61664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91119C2407F
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B32567680
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC6E32ED31;
	Fri, 31 Oct 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sq2sLfmj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2832C93D;
	Fri, 31 Oct 2025 09:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761901318; cv=none; b=WYZ5NxNpWMeaR34XOP7aoo2AjIuTLEcCO4/1gU+AOIPIbRi6+djy/uKmNJO+EDQ3i7YGxbAm+rfN/8LPptqvTep1rupcH9YCocdWYhH9IZN6sVUHhKycyyTolV160EAJfaosLBoPM3G/Uz+Eq3xSDmr+SvN4v03l2DuvPL+4lf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761901318; c=relaxed/simple;
	bh=WrRAkZWX2mY1Sn4BYh8lP0+Uv8J4x4xta8TyjbzO6EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfwJAPwu9PZn2cBT0Jbh8JQxfd287t6lp7ReUQPRigybjrxU5pKExRLAXBMVI1BE+OiUDIq2B2c1QtBAQlMQy1yOCI1cAzhnpLCC62wszfXfb+4F0afD2CDeuJe8MopWvpOGUjgkJ5epD2oJeNOrXDovAYXcU9eEvkw89pMe7zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sq2sLfmj; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761901317; x=1793437317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WrRAkZWX2mY1Sn4BYh8lP0+Uv8J4x4xta8TyjbzO6EM=;
  b=Sq2sLfmje2ZeDz5hZSVX9mEkwXjHmQr0YQElNkrBZKrzfOHbZPdYAXcK
   UlibsXE7whgpwzpISuXg+jr2ZgBW0vEmOv2VHY/hBnfkkCay3zwJsyqj6
   gJPXUKoXP8nKzH7/qRGgKnul+DaNHFRoYCv7yOhpoXItUnQu0Vxcapzg5
   c+xUXbDCu9AVR4jco/m89OVlCxykle7vHi4o/g0Yu1XitLBXXPrU9opfb
   v/IBLCXYYqM7QNlVlqGem5nG6Xp67DrNDV8PlBo8aJJ7w0CbFpuPDZUZm
   Iw6w8auzgJQtGd3On1hIhDUfsR+Nl5vimpEnm9qQBhCrCF3nRjmFNxe6J
   A==;
X-CSE-ConnectionGUID: tNRuY/7aTt6vJcUw0m1jpg==
X-CSE-MsgGUID: KeXux0DyQzSHV5wTuHddlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="66671060"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="66671060"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:00:58 -0700
X-CSE-ConnectionGUID: Dd9eBStPTB2R+zNgqb0uKQ==
X-CSE-MsgGUID: AT1MnrH1RWGItLZni9BlRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186120016"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.28]) ([10.124.240.28])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:00:50 -0700
Message-ID: <326290aa-def6-478c-9ef3-1649e027e5d5@linux.intel.com>
Date: Fri, 31 Oct 2025 17:00:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/28] KVM: TDX: Derive error argument names from the
 local variable names
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-20-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030200951.3402865-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 4:09 AM, Sean Christopherson wrote:
> When printing SEAMCALL errors, use the name of the variable holding an
> error parameter instead of the register from whence it came, so that flows
> which use descriptive variable names will similarly print descriptive
> error messages.
>
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5e6f2d8b6014..63d4609cc3bc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -41,14 +41,15 @@
>   #define TDX_BUG_ON(__err, __fn, __kvm)				\
>   	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
>   
> -#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
> +#define TDX_BUG_ON_1(__err, __fn, a1, __kvm)			\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx", a1)
>   
> -#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
> +#define TDX_BUG_ON_2(__err, __fn, a1, a2, __kvm)	\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 " 0x%llx", a1, a2)
>   
> -#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
> -	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
> +#define TDX_BUG_ON_3(__err, __fn, a1, a2, a3, __kvm)	\
> +	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 ", 0x%llx, " #a3 " 0x%llx", \
> +		     a1, a2, a3)
>   
>   
>   bool enable_tdx __ro_after_init;


