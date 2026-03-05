Return-Path: <kvm+bounces-72886-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Jz6KeDAqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72886-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:44:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBAE21669B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3EFC83099D10
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E86C3D34AA;
	Thu,  5 Mar 2026 17:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="U9hTis9y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8629B34A76E;
	Thu,  5 Mar 2026 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732555; cv=none; b=eG9nQmr9UeRXLczQvqabIK+b0tU6FJJNAsAQZ6IaW7100ZWiz8xR+fQPmVaO9Tljy+F7YIaqdUXZIxc4IrcNVehZgcG/fn4civy+fYF/dnsGJFF4Z87WTnywtBDNtFi9p7vaGemmKLoeV5Q3JJyY3a99AAoh91zTj8XFco/r7gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732555; c=relaxed/simple;
	bh=21WHh1VsCuYCMG20K/554Bw6H0yUrjgPIUyOm0VP6KM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lwxIjG3lCOYh8XcIp0Lh2ymXFN1chfiIZlgvY4yIvvzItj5ft3s3TjkTDqgoRLt8SQk2aZRIxzQzKpTU2YAgBNc1D/zeP0CcsuY6ocCkiqReCAncl5xGdL7+o3W3k6EyavZRVqfwfEHLXUi62h0QGf7iWkfoOOaj+Dtf6XMPd4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=U9hTis9y; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 625HQ60A3525601
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 5 Mar 2026 09:26:07 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 625HQ60A3525601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772731568;
	bh=5hn0jF1YKw9oU65oOl9+YoH/Q746A6JZMd0p082/8yY=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=U9hTis9yQetdUD4O8Tma/KbBrXx/4Y1qaKcvrvWkR6pb3jWhOKlMohMJWZev/fZKb
	 LBXzqGICgkf0B5THX7WJTvOTCfRW1NWQCrnIezGgI994IM7F1i5jOs4ejtjyTKrSsw
	 paSNYsLtQjoeETbL9H2ePWhxunMSsR9R+GW4gNBbAqSYeTW1j4qdNg3Wmyl0HJ8eNd
	 vZ+UsHTFmlQ4Z7kywhfH7lz42PmgUO9L4lMW7WryTDF+sPTuGiETySr9acKnOT/2Jm
	 G3UdPgThz1M0aj9lkx55zWNr7vHnKXH+TgfWFNgoXcRwIgUfowT0LCMmjnd9DeYufT
	 a6471Yi9uF4ig==
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
In-Reply-To: <aamfka09bDZV0iUO@google.com>
Date: Thu, 5 Mar 2026 09:25:56 -0800
Cc: Binbin Wu <binbin.wu@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1034AC94-928A-4588-909F-A943E867A53C@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
 <aahchI7oiFrjFAmb@google.com>
 <99463361-58F3-42F9-9BCC-4BF0BF73D247@zytor.com>
 <aamfka09bDZV0iUO@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 0DBAE21669B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72886-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,zytor.com:dkim,zytor.com:mid]
X-Rspamd-Action: no action


>>>>> + /* Per-CPU FRED MSRs */
>>>=20
>>> Meh, this is pretty self-explanatory code.
>>=20
>> I want to remind that this is =E2=80=9CPer-CPU=E2=80=9D.
>>=20
>> On the other side, FRED_CONFIG and FRED_STKLVLS are typically the =
same on
>> all CPUs, and they don=E2=80=99t need to be updated during vCPU =
migration.
>>=20
>> But anyway vCPU migration only cares per-CPU MSRs, so this is =
redundant.
>>=20
>> It often bothers me whether to explain the code a bit more or not, =
with a
>> short brief comment or a lengthy one.
>=20
> Oh, I'm all for comments,  But I generally dislike terse comments like =
the above,
> as they're only useful for readers that *already* know many of the =
gory details,
> and for everyone else, it's largely just noise.
>=20
> E.g. in this case, what the subtlety of what you were trying to convey =
with
> "Per-CPU" was completely lost on me.  It would have been a wee bit =
more helpful
> in earlier versions that used RDMSR, but even then it required the =
reader to make
> large leaps of intuition to understand the full context.
>=20
> And the terse comment is also "wrong" in the sense that it lies by =
omission,
> because this isn't *all* of the per-CPU MSRs.
>=20
> E.g.
>=20
> /*
>  * Update the FRED RSP MSRs values that are restored on VM-Exit, as
>  * Linux uses dedicated per-CPU stacks for things like #DBs and NMIs.
>  * Note, RSP0 is _only_ used to load RSP on user=3D>kernel =
transitions,
>  * i.e. doesn't need to be loaded on VM-Exit and so doesn't have a =
VMCS
>  * field.  Note #2, the SSP MSRs will likely be per-CPU as well, but
>  * Linux doesn't yet support supervisor shadow stacks.
>  */=20

You=E2=80=99re right, terse comment could be bad.


>=20
>>>>> + if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>>>>> +#ifdef CONFIG_X86_64
>>>>=20
>>>> Nit:
>>>>=20
>>>> Is this needed?
>>>>=20
>>>> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, =
this
>>>> path is not reachable.
>>>> There should be no compilation issue without #ifdef CONFIG_X86_64 / =
#endif.
>>>>=20
>>>> There are several similar patterns in this patch, using  #ifdef =
CONFIG_X86_64 /=20
>>>> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and =
init_vmcs()
>>>> doesn't check the config, but here does.
>>>>=20
>>>>> + vmcs_write64(HOST_IA32_FRED_RSP1, =
__this_cpu_ist_top_va(ESTACK_DB));
>>>>> + vmcs_write64(HOST_IA32_FRED_RSP2, =
__this_cpu_ist_top_va(ESTACK_NMI));
>>>>> + vmcs_write64(HOST_IA32_FRED_RSP3, =
__this_cpu_ist_top_va(ESTACK_DF));
>>>=20
>>> IMO, this is flawed for other reasons.  KVM shouldn't be relying on =
kernel
>>> implementation details with respect to what FRED stack handles what =
event.
>>>=20
>>> The simplest approach would be to read the actual MSR.  _If_ using a =
per-CPU read
>>> provides meaningful performance benefits over RDMSR (or RDMSR w/ =
immediate?  I
>>> don't see an API for that...), then have the kernel provide a =
dedicated accessor.
>>=20
>> I think you asked for it:
>>=20
>> https://lore.kernel.org/kvm/ZmoWB_XtA0wR2K4Q@google.com/
>=20
> Gah, so I did.  FWIW, comments like that aren't intended to be "you =
must do it
> this way", i.e. it's ok to push back (if there's justification to do =
so), but I
> can totally see how it came across that way.
>=20
>> I assume fetching through per-CPU cache is fast, but I might have =
misunderstood
>> your suggestion.
>=20
> Oh, per-CPU cache is likely faster than RDMSR (though it would be nice =
to verify).
> The part I specifically don't like is referencing DB, NMI, and DF =
stacks.
>=20
>>> Then the accessor can be a non-inlined functions, and this code can =
be e.g.:
>>>=20
>>> if (IS_ENABLED(CONFIG_X86_64) && kvm_cpu_cap_has(X86_FEATURE_FRED)) =
{
>>> vmcs_write64(HOST_IA32_FRED_RSP1, fred_rsp(MSR_IA32_FRED_RSP1));
>>> vmcs_write64(HOST_IA32_FRED_RSP2, fred_rsp(MSR_IA32_FRED_RSP2));
>>> vmcs_write64(HOST_IA32_FRED_RSP3, fred_rsp(MSR_IA32_FRED_RSP2));
>                                                                ^
>                                                                |
>                                                                3 =
(guess who failed at copy+paste)
>>> }
>>>=20
>>> where fred_rsp() is _declared_ unconditionally, but implemented only =
for 64-bit.
>>> That way the compiler will be happy, and the actual usage will be =
dropped before
>>> linking via dead-code elimination.
>>=20
>> If KVM can=E2=80=99t rely on kernel side implementation details, =
fred_rsp() has to read
>> directly from the corresponding MSRs, right?
>=20
> No.  If the kernel provides an API specifically for getting RSP =
values, then KVM
> isn't rely on implementation details, KVM is relying on an (exported?) =
API, and
> it's the _kernel's_ responsibility to ensure that API is updated as =
needed.
>=20
> Yeah, yeah, KVM is also part of the kernel, but it's a _lot_ easier to =
forget to
> update code when the implementation details change when some of the =
usage is "far"
> away.

Okay, I think it=E2=80=99s clearer to me what bothers you.

A self-explanatory API is the right thing, and should be a standard =
practice.

>=20
>>> Actually, we can probably do one better?
>>>=20
>>> if (cpu_feature_enabled(X86_FEATURE_FRED) && =
kvm_cpu_cap_has(X86_FEATURE_FRED)) {
>>=20
>> I think KVM now forces X86_FEATURE_FRED=3Dy, no?
>=20
> 32-bit doesn't :-D
>=20
> But even for 64-bit, X86_FEATURE_FRED should be cleared when FRED =
isn't supported
> by hardware, in which case cpu_feature_enabled() still patches out the =
text.

Right, it can be patched out thus has =E2=80=9Czero=E2=80=9D impact on =
existing hardwares.

(Just that the FRED IRQ handling code is not as it=E2=80=99s used by =
KVM.)



