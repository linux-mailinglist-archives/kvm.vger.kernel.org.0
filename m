Return-Path: <kvm+bounces-52426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B90E9B050F9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 766F03BBE1D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD2D2D3ED9;
	Tue, 15 Jul 2025 05:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vuoaoi1I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74032D3A9F;
	Tue, 15 Jul 2025 05:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752557378; cv=none; b=XXJuZ9s8+98pUAE6ps6TkWqxmRi+4hI/ZavJWOH99T98U3Ahucwq0WIKW5CgEwav1mefCrKJ8+soEQ+AgSBI1l9s0vo4ZmBkWxeN3tmgL66E4mrj0wYCM9KRehUr2GVpOMwHiXx7rL05drtS2JUXh1dm/n3CcT3qAHTZZ35LlDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752557378; c=relaxed/simple;
	bh=relhaGmwuN3BM9WXC//DxFV+zOmPYgOkglV3qif+r1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhQ2+kCgvMN4FAfPvvnrW+5gLhZ0GRUbwfE1/nZmZGVhwxCarVKbakg8f2MavQxecmD3Oz9safwNigiwP8tHQcMHvMkBd3Rp4oiyQK5yxEjdoUvRI//yB65yOlFJj5kNlDFbyHl6G8eXH1YxQqiaXfbMmWwG9rE6mMWl5+CydvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vuoaoi1I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9E9C4CEE3;
	Tue, 15 Jul 2025 05:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752557376;
	bh=relhaGmwuN3BM9WXC//DxFV+zOmPYgOkglV3qif+r1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vuoaoi1IKqbr/CiXvNO7D35hDal9LUsv9lK/AFh8D09r6ycphXg7KX3UjHlxzxSaL
	 8g7/D/S0bPHYUizhGwEIdGHDxoY7Gthchev/QUgpNeOI1QB8iSnlAY/n4NJdM8N0Yh
	 xIdGOXckWFb/2R6ttiZ4QIzxCNnU4V4eSXGIZLVYNKonuCYi6+d/1bz3uTUL9fInKo
	 x++NgLwVhP3aAhYhOWgbESDWR/SWnpWnZe0VXj+XCFMX7ej9L0OdpF9PPDLr8VdRSh
	 eeShBwgjFF08y7KBLqyNW6KDRqIkZIA2MsdvOcowCs6W0gsWC7Y/CEL/2MAiXoXz5Z
	 Vr94bOPzPnyuA==
Date: Tue, 15 Jul 2025 05:29:31 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH v7 1/3] KVM: x86: Advance guest TSC after deep suspend.
Message-ID: <aHXnO6KapsNLjocd@google.com>
References: <20250714033649.4024311-1-suleiman@google.com>
 <20250714033649.4024311-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714033649.4024311-2-suleiman@google.com>

On Mon, Jul 14, 2025 at 12:36:47PM +0900, Suleiman Souhlal wrote:
> Try to advance guest TSC to current time after suspend when the host
> TSCs went backwards.
> 
> This makes the behavior consistent between suspends where host TSC
> resets and suspends where it doesn't, such as suspend-to-idle, where
> in the former case if the host TSC resets, the guests' would
> previously be "frozen" due to KVM's backwards TSC prevention, while
> in the latter case they would advance.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Tested again with comparing `date` before and after suspend-to-RAM:
  echo deep >/sys/power/mem_sleep
  echo $(date '+%s' -d '+3 minutes') >/sys/class/rtc/rtc0/wakealarm
  echo mem >/sys/power/state

Without the patch, the guest's `date` is slower (~3 mins) than the host's
after resuming.

Tested-by: Tzung-Bi Shih <tzungbi@kernel.org>

> @@ -5035,7 +5035,36 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	/* Apply any externally detected TSC adjustments (due to suspend) */
>  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
> +#ifdef CONFIG_X86_64
> +		unsigned long flags;
> +		struct kvm *kvm;
> +		bool advance;
> +		u64 kernel_ns, l1_tsc, offset, tsc_now;
> +
> +		kvm = vcpu->kvm;
> +		advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
> +		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +		/*
> +		 * Advance the guest's TSC to current time instead of only
> +		 * preventing it from going backwards, while making sure
> +		 * all the vCPUs use the same offset.
> +		 */
> +		if (kvm->arch.host_was_suspended && advance) {
> +			l1_tsc = nsec_to_cycles(vcpu,
> +						kvm->arch.kvmclock_offset + kernel_ns);
> +			offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);
> +			kvm->arch.cur_tsc_offset = offset;
> +			kvm_vcpu_write_tsc_offset(vcpu, offset);
> +		} else if (advance) {
> +			kvm_vcpu_write_tsc_offset(vcpu, kvm->arch.cur_tsc_offset);
> +		} else {
> +			adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
> +		}
> +		kvm->arch.host_was_suspended = false;
> +		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
> +#else
>  		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
> +#endif /* CONFIG_X86_64 */

Wondering if it needs to acquire the `tsc_write_lock`, given that:
- The original code adjust_tsc_offset_host() doesn't acquire.  Note:
  adjust_tsc_offset_host() eventually calls kvm_vcpu_write_tsc_offset() too.
- Documentation/virt/kvm/locking.rst [1].

[1] https://elixir.bootlin.com/linux/v6.15/source/Documentation/virt/kvm/locking.rst#L264

