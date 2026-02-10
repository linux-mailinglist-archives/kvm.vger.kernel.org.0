Return-Path: <kvm+bounces-70715-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oM7/J9T0imn2OwAAu9opvQ
	(envelope-from <kvm+bounces-70715-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:05:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6E5118816
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B2F230360BD
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B3633EB1B;
	Tue, 10 Feb 2026 09:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LNWQzT/b"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8652433DEE5;
	Tue, 10 Feb 2026 09:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770714310; cv=none; b=dGH/c0Cz3/kMuWdv/tSxaUh1S5KNeoLTUvLZ9oJ7GlqhPSY/z2M20HBSkbeI4I4u/5Vl5wBU5DOogeMg7Haj7bLnVo86j4iNIQw0n+A+INaOLb4MW32sWglX8yEfSOjyjnB4NPKN+fc0O1DKjcYdP+uIN8/pZrUIq4++KOpkJr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770714310; c=relaxed/simple;
	bh=xbYWcmni73BY3xay5kLe4nlx38JkcTFjRz06ZFMOT14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jwpe8W4AHWKp3lxyjRWHvevbvqIwZcBbNt5ufDxXhl1DmRsC8UNgeWPp2ng253ZUQzaSl9IlwQQfJO16+2vfCvz67SBng7AgGDNELBhTgjIbL3ZW+HGbQ5kJ8xoxhj1e2PAkZVzvMuyMo3eR5qyD2kHps2P2xNRJNRySH8+68Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LNWQzT/b; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=mUWfO/rMqN3fH/y6H16r00FxSopOlvlhSXNKMKGz9xI=;
	b=LNWQzT/bLg6h5XGMj8XkPJhyn+Qo7sjV2G5uWPMECeduu6srXg5NvN62TSL+aZ
	0NsNe29iRWg47xrXSWJ8tkkhvjJQaHCu5ewEp12BclQCi3AKXCFI8oLSgIODiAnh
	B4WiVvovsctz9dJOIgwayKGxUh3RgsD/vADggcCqCZAjo=
Received: from [10.0.2.15] (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDX8LGl9Ipp1DFEKw--.2572S2;
	Tue, 10 Feb 2026 17:04:38 +0800 (CST)
Message-ID: <f46b9ea8-beb7-4957-a1c4-694e0099f421@163.com>
Date: Tue, 10 Feb 2026 17:04:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 2/5] KVM: x86: selftests: Alter the instruction of
 hypercall on Hygon
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260209041305.64906-1-zhiquan_li@163.com>
 <20260209041305.64906-3-zhiquan_li@163.com> <aYoNN64cAp9f_0k8@google.com>
From: Zhiquan Li <zhiquan_li@163.com>
Content-Language: en-US
In-Reply-To: <aYoNN64cAp9f_0k8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDX8LGl9Ipp1DFEKw--.2572S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WFW7ZF13Cw17Wry7Jw1UZFb_yoW7Aw15pa
	4kAw1FkF1xtFnxta4xXr4vqFW8WrZ7Wa18t348XFy3AF1fJ34xJrs7Ka4jya9xuFWrXwnx
	A3WIgF4DCanrt3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UjFAJUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbCwgZjTGmK9KY2DQAA3h
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[163.com];
	TAGGED_FROM(0.00)[bounces-70715-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhiquan_li@163.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[163.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0D6E5118816
X-Rspamd-Action: no action


On 2/10/26 00:37, Sean Christopherson wrote:
> Rather than play a constant game of whack-a-mole and end up with a huge number of
> "host_cpu_is_amd || host_cpu_is_hygon" checks, I would prefer to add (in addition
> to host_cpu_is_hygon) a "host_cpu_is_amd_compatible" flag.
> 
> E.g. slotted in after patch 1, something like this:
> 

Many thanks, Sean!
Let me put these into patch 2, and patch 3 can be dropped.

Best Regards,
Zhiquan

> ---
>  tools/testing/selftests/kvm/include/x86/processor.h  | 1 +
>  tools/testing/selftests/kvm/lib/x86/processor.c      | 8 ++++++--
>  tools/testing/selftests/kvm/x86/fix_hypercall_test.c | 2 +-
>  tools/testing/selftests/kvm/x86/msrs_test.c          | 2 +-
>  tools/testing/selftests/kvm/x86/xapic_state_test.c   | 2 +-
>  5 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/
> testing/selftests/kvm/include/x86/processor.h
> index 1338de7111e7..40e3deb64812 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -22,6 +22,7 @@
>  extern bool host_cpu_is_intel;
>  extern bool host_cpu_is_amd;
>  extern bool host_cpu_is_hygon;
> +extern bool host_cpu_is_amd_compatible;
>  extern uint64_t guest_tsc_khz;
>  
>  #ifndef MAX_NR_CPUID_ENTRIES
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/
> selftests/kvm/lib/x86/processor.c
> index f6b1c5324931..7b7fd2ad148f 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -24,6 +24,7 @@ vm_vaddr_t exception_handlers;
>  bool host_cpu_is_amd;
>  bool host_cpu_is_intel;
>  bool host_cpu_is_hygon;
> +bool host_cpu_is_amd_compatible;
>  bool is_forced_emulation_enabled;
>  uint64_t guest_tsc_khz;
>  
> @@ -794,6 +795,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus)
>  	sync_global_to_guest(vm, host_cpu_is_intel);
>  	sync_global_to_guest(vm, host_cpu_is_amd);
>  	sync_global_to_guest(vm, host_cpu_is_hygon);
> + sync_global_to_guest(vm, host_cpu_is_amd_compatible);
>  	sync_global_to_guest(vm, is_forced_emulation_enabled);
>  	sync_global_to_guest(vm, pmu_errata_mask);
>  
> @@ -1350,7 +1352,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
>  		     "1: vmmcall\n\t"					\
>  		     "2:"						\
>  		     : "=a"(r)						\
> - : [use_vmmcall] "r" (host_cpu_is_amd), inputs); \
> + : [use_vmmcall] "r" (host_cpu_is_amd_compatible), \
> + inputs); \
>  									\
>  	r;								\
>  })
> @@ -1391,7 +1394,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
>  	max_gfn = (1ULL << (guest_maxphyaddr - vm->page_shift)) - 1;
>  
>  	/* Avoid reserved HyperTransport region on AMD processors.  */
> - if (!host_cpu_is_amd)
> + if (!host_cpu_is_amd_compatible)
>  		return max_gfn;
>  
>  	/* On parts with <40 physical address bits, the area is fully hidden */
> @@ -1427,6 +1430,7 @@ void kvm_selftest_arch_init(void)
>  	host_cpu_is_intel = this_cpu_is_intel();
>  	host_cpu_is_amd = this_cpu_is_amd();
>  	host_cpu_is_hygon = this_cpu_is_hygon();
> + host_cpu_is_amd_compatible = host_cpu_is_amd || host_cpu_is_hygon;
>  	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
>  
>  	kvm_init_pmu_errata();
> diff --git a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c b/tools/
> testing/selftests/kvm/x86/fix_hypercall_test.c
> index 762628f7d4ba..00b6e85735dd 100644
> --- a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
> +++ b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
> @@ -52,7 +52,7 @@ static void guest_main(void)
>  	if (host_cpu_is_intel) {
>  		native_hypercall_insn = vmx_vmcall;
>  		other_hypercall_insn  = svm_vmmcall;
> - } else if (host_cpu_is_amd) {
> + } else if (host_cpu_is_amd_compatible) {
>  		native_hypercall_insn = svm_vmmcall;
>  		other_hypercall_insn  = vmx_vmcall;
>  	} else {
> diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/
> selftests/kvm/x86/msrs_test.c
> index 40d918aedce6..4c97444fdefe 100644
> --- a/tools/testing/selftests/kvm/x86/msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86/msrs_test.c
> @@ -81,7 +81,7 @@ static u64 fixup_rdmsr_val(u32 msr, u64 want)
>  	 * is supposed to emulate that behavior based on guest vendor model
>  	 * (which is the same as the host vendor model for this test).
>  	 */
> - if (!host_cpu_is_amd)
> + if (!host_cpu_is_amd_compatible)
>  		return want;
>  
>  	switch (msr) {
> diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/
> selftests/kvm/x86/xapic_state_test.c
> index 3b4814c55722..0c5e12f5f14e 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
> @@ -248,7 +248,7 @@ int main(int argc, char *argv[])
>  	 * drops writes, AMD does not).  Account for the errata when checking
>  	 * that KVM reads back what was written.
>  	 */
> - x.has_xavic_errata = host_cpu_is_amd &&
> + x.has_xavic_errata = host_cpu_is_amd_compatible &&
>  			     get_kvm_amd_param_bool("avic");
>  
>  	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);
> 
> base-commit: 391774310e7309b5a1ee12fac9264e95b1d4a6ee
> --


