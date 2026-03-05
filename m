Return-Path: <kvm+bounces-72789-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iE7tBPQbqWn82AAAu9opvQ
	(envelope-from <kvm+bounces-72789-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 07:00:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7043F20B1AA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 07:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8461303E2F6
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 06:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53FB29827E;
	Thu,  5 Mar 2026 06:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SomfLdAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A4013D891;
	Thu,  5 Mar 2026 06:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772690402; cv=none; b=WPzp00VT+8U3UkLBrEkCJSqTcwl7pkgTR4/XzmfEW2nz6Q81pKQlC/iN/uW6LSj4vYPpXs0EUtbg2OlMyI39Cc6KgNJ6ZO5wvz0/RnjCImxrcWE18OlzU+x2vEzeda9RB0x7ydkiQVx6BUzzOhawAUuWWM/Z4K2pysS/6EdkyeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772690402; c=relaxed/simple;
	bh=kRl0dFzmzJVFvVrDPwTGJzGoVWZ8CXbDkZD9sYp1f38=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Qy7JOSrihaUx4DphJDW9pmNxj30tFcDR1J0jaVxlhu0+90JR567W4/1FRcOPAVSR32/y224HvGHwH5Vb0m1UBl0BNhwCrM3oiCzD0bm6nutEOgkitu/zkw1NvrX9rd7BxV+BO3/jmuEU3MC/FkET7uXuc5QZz0NprztjljDyYLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SomfLdAg; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6255RIQs2343052
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 4 Mar 2026 21:27:18 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6255RIQs2343052
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772688440;
	bh=KA5gN2wC89NrKPDnrGFrieYaC050Cg169d1qgwroiwc=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=SomfLdAgQhI/vJVfqLfsic/psO4zSViGxGwX9XiWanqa1wF/QLw68781ii0LsTcRE
	 qJkiUOdZ5AupVw9Ig1/cDsJc+9rcGobpAWzRxGUJvqFGjZ+fY8OaHZXojGH0gc0BBX
	 9JJJOTJyqfecYZCYSQFM/nTj6X2EChZbkdNHkoH6SJLWln4ZKboSw2llOUxCsbHrMa
	 oFWCi4YhORn9rosomWuuuupfhGXLuH2ldhT0KofMv9wJxmVjAhvLVyUqeTNUWr858U
	 rsTZnIwg+H6oRBcdmTl6VNCJIa8nqzPsEzqw3s/0uLM7fro59ejCfbBSqllwOjypFu
	 BA1f4u8zay5zg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
From: Xin Li <xin@zytor.com>
In-Reply-To: <aahchI7oiFrjFAmb@google.com>
Date: Wed, 4 Mar 2026 21:27:07 -0800
Cc: Binbin Wu <binbin.wu@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <99463361-58F3-42F9-9BCC-4BF0BF73D247@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
 <aahchI7oiFrjFAmb@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 7043F20B1AA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72789-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:dkim,zytor.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action



> On Mar 4, 2026, at 8:23=E2=80=AFAM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
> On Wed, Jan 21, 2026, Binbin Wu wrote:
>> On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index fcfa99160018..c8b5359123bf 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -1459,6 +1459,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu =
*vcpu, int cpu)
>>>    (unsigned long)(cpu_entry_stack(cpu) + 1));
>>> }
>>>=20
>>> + /* Per-CPU FRED MSRs */
>=20
> Meh, this is pretty self-explanatory code.

I want to remind that this is =E2=80=9CPer-CPU=E2=80=9D.

On the other side, FRED_CONFIG and FRED_STKLVLS are typically the same =
on
all CPUs, and they don=E2=80=99t need to be updated during vCPU =
migration.

But anyway vCPU migration only cares per-CPU MSRs, so this is redundant.

It often bothers me whether to explain the code a bit more or not, with =
a
short brief comment or a lengthy one.

>=20
>>> + if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>>> +#ifdef CONFIG_X86_64
>>=20
>> Nit:
>>=20
>> Is this needed?
>>=20
>> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, =
this
>> path is not reachable.
>> There should be no compilation issue without #ifdef CONFIG_X86_64 / =
#endif.
>>=20
>> There are several similar patterns in this patch, using  #ifdef =
CONFIG_X86_64 /=20
>> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and =
init_vmcs()
>> doesn't check the config, but here does.
>>=20
>>> + vmcs_write64(HOST_IA32_FRED_RSP1, =
__this_cpu_ist_top_va(ESTACK_DB));
>>> + vmcs_write64(HOST_IA32_FRED_RSP2, =
__this_cpu_ist_top_va(ESTACK_NMI));
>>> + vmcs_write64(HOST_IA32_FRED_RSP3, =
__this_cpu_ist_top_va(ESTACK_DF));
>=20
> IMO, this is flawed for other reasons.  KVM shouldn't be relying on =
kernel
> implementation details with respect to what FRED stack handles what =
event.
>=20
> The simplest approach would be to read the actual MSR.  _If_ using a =
per-CPU read
> provides meaningful performance benefits over RDMSR (or RDMSR w/ =
immediate?  I
> don't see an API for that...), then have the kernel provide a =
dedicated accessor.

I think you asked for it:

https://lore.kernel.org/kvm/ZmoWB_XtA0wR2K4Q@google.com/

I assume fetching through per-CPU cache is fast, but I might have =
misunderstood
your suggestion.


>=20
> Then the accessor can be a non-inlined functions, and this code can be =
e.g.:
>=20
> if (IS_ENABLED(CONFIG_X86_64) && kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> vmcs_write64(HOST_IA32_FRED_RSP1, fred_rsp(MSR_IA32_FRED_RSP1));
> vmcs_write64(HOST_IA32_FRED_RSP2, fred_rsp(MSR_IA32_FRED_RSP2));
> vmcs_write64(HOST_IA32_FRED_RSP3, fred_rsp(MSR_IA32_FRED_RSP2));
> }
>=20
> where fred_rsp() is _declared_ unconditionally, but implemented only =
for 64-bit.
> That way the compiler will be happy, and the actual usage will be =
dropped before
> linking via dead-code elimination.

If KVM can=E2=80=99t rely on kernel side implementation details, =
fred_rsp() has to read
directly from the corresponding MSRs, right?


>=20
> Actually, we can probably do one better?
>=20
> if (cpu_feature_enabled(X86_FEATURE_FRED) && =
kvm_cpu_cap_has(X86_FEATURE_FRED)) {

I think KVM now forces X86_FEATURE_FRED=3Dy, no?



