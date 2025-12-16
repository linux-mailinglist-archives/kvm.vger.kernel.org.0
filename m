Return-Path: <kvm+bounces-66071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75704CC38E4
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E686307E59D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 14:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2299341AC7;
	Tue, 16 Dec 2025 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pq95Jg9P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60EE17C77;
	Tue, 16 Dec 2025 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765894929; cv=none; b=tEUQ32OnGTi6hPOXqErDfeSM5iL72GrpjOLfN8aJKjXtO+a79yiw7B7c5HJRhB0zBLyifwFYF0a0kiJZU2b/4q7QfjhbfXn4J1AWVI/hTRg/XtA0xn+gMv6JRnnXc+eUGo4CEE8GzLpXixw/dPiwlVho0K9SbHPdWVu2SmbV1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765894929; c=relaxed/simple;
	bh=8EmBYCZMZY7bqtalvK4soFukbvVP0Vq2Cmz6pn0pkD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p05AIjg+zMAQvghP/XsskOMa2yYsfaX7IWQfZKYoy5W+9dpgnYiqy5d4eZT4lz7SPznk7QBE40eTtOk6/c5znfe2OtN5WJoYGzIiSKAPrLDAcfiQttr0ngEJHD20boiLbbjdwjGtIK9glp3nzWoK6CJInbCKN9t+PoAZ9XczH8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pq95Jg9P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE973C16AAE;
	Tue, 16 Dec 2025 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765894929;
	bh=8EmBYCZMZY7bqtalvK4soFukbvVP0Vq2Cmz6pn0pkD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pq95Jg9PQpPHKoUzBuN6OxdVEbQxh1Y/XYydfsYCtj0qB1QCSpDHBUOOJKetPv2U7
	 V+EfXGgP32ZhyTJEhOT7hyW6d2dgXbeWY3zpkaUcYiUWDBduQw9HobohTWwCdPfZ/3
	 53kSaerQYX1+x82BeZsn7M3fXN+pzhsed3Wb+/sRmw0BKzURabc2dmSh7D26oRfxp8
	 Vn/jLd6puEz6akT3jkNHU83BDmrRCPmoj96SRwO5+/Hgc7e4KuUPe+mDpXhfzzzAfP
	 Zlj1eWQjU3zD5lrX7rMF1KErGsr1DQvIDjNT/krr/fKA5doQ9B3mgP9ImSK/QU52bP
	 a7uYwqeBxWIIw==
Date: Tue, 16 Dec 2025 19:51:33 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de, peterz@infradead.org, mingo@redhat.com, mizhang@google.com, 
	thomas.lendacky@amd.com, ravi.bangoria@amd.com, Sandipan.Das@amd.com
Subject: Re: [PATCH v2 03/12] KVM: Add KVM_GET_EXT_LAPIC and
 KVM_SET_EXT_LAPIC for extapic
Message-ID: <jf2zfqo6jrrcdkdatztiijmf7tgkho7bks4q4oaegiqpeflrkj@7blq6f5ck2hf>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052146.209158-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250901052146.209158-1-manali.shukla@amd.com>

On Mon, Sep 01, 2025 at 10:51:46AM +0530, Manali Shukla wrote:
> Modern AMD processors expose four additional extended LVT registers in
> the extended APIC register space, which can be used for additional
> interrupt sources such as instruction-based sampling and others.
> 
> To support this, introduce two new vCPU-based IOCTLs:
> KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC. These IOCTLs works similarly
> to KVM_GET_LAPIC and KVM_SET_LAPIC, but operate on APIC page with
> extended APIC register space located at APIC offsets 400h-530h.
> 
> These IOCTLs are intended for use when extended APIC support is
> enabled in the guest. They allow saving and restoring the full APIC
> page, including the extended registers.
> 
> To support this, the `struct kvm_ext_lapic_state` has been made
> extensible rather than hardcoding its size, improving forward
> compatibility.
> 
> Documentation for the new IOCTLs has also been added.
> 
> For more details on the extended APIC space, refer to AMD Programmer’s
> Manual Volume 2, Section 16.4.5: Extended Interrupts.
> https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  Documentation/virt/kvm/api.rst  | 23 ++++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h |  5 +++++
>  arch/x86/kvm/lapic.c            | 12 ++++++-----
>  arch/x86/kvm/lapic.h            |  6 ++++--
>  arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++---------
>  include/uapi/linux/kvm.h        | 10 +++++++++
>  6 files changed, 76 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6aa40ee05a4a..0653718a4f04 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2048,6 +2048,18 @@ error.
>  Reads the Local APIC registers and copies them into the input argument.  The
>  data format and layout are the same as documented in the architecture manual.
>  
> +::
> +
> +  #define KVM_APIC_EXT_REG_SIZE 0x540
> +  struct kvm_ext_lapic_state {
> +	__DECLARE_FLEX_ARRAY(__u8, regs);
> +  };
> +
> +Applications should use KVM_GET_EXT_LAPIC ioctl if extended APIC is
> +enabled. KVM_GET_EXT_LAPIC reads Local APIC registers with extended
> +APIC register space located at offsets 400h-530h and copies them into input
> +argument.

I suppose the reason for using a flex array was for addressing review 
comments on the previous version -- to make the new APIs extensible so 
that they can accommodate any future changes to the extended APIC 
register space.

I wonder if it would be better to introduce a KVM extension, say 
KVM_CAP_EXT_LAPIC (along the lines of KVM_CAP_PMU_CAPABILITY).

KVM_CHECK_EXTENSION(KVM_CAP_EXT_LAPIC) can then return a bitmask 
indicating supported features. Today, this will be a single bit 
indicating support for the base extended APIC register space (say, 
KVM_EXT_LAPIC_CAP_ENABLE).  This would map to current extended APIC 
register space (up to 0x540 offset). Additional bits can be introduced 
to represent future extensions/changes as necessary.

Userspace will then have to explicitly enable this using 
KVM_ENABLE_CAP() before issuing KVM_GET_EXT_LAPIC/KVM_SET_EXT_LAPIC.


- Naveen


