Return-Path: <kvm+bounces-68344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E98D33C1F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5307B302409B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A812234AAE2;
	Fri, 16 Jan 2026 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="DWNXtTIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF0633CE82
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768583369; cv=none; b=hz06BcbpWUN8i5idUqDvDBY8Raw9xgf7jtJTdlWIJEaL3vxSsb7oxxwO5MFKc0Ftgv6kFnxDOBXJHXwAn417+YMSRkucX3a0X9vCjDCJMsWrFQvtRK1ZxPzO6wVeqSZt+BfTPjo1E9cyLN1Cvpmss8SBWL2nhTDL/D6sqlNSf5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768583369; c=relaxed/simple;
	bh=OgfGYzyoOo7LnR2rlb7Y0ATya0bhxed4yd8DBJmBSVk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=II1ldEC+lxeIqq9IZrHXoNBgjSXCJXBg6cLreSd1LzUTBIKUC8D7wjzjIavp0IJI5m8nBlD+oE0F1roOhumtEHK0oZt/AzqwUB6nGt0M1DZPdaqwzJVuFoCuXbuhcXEemCpWSNejTmADMnSFedLBe/6StlcDPA05003ssnctGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=DWNXtTIa; arc=none smtp.client-ip=79.135.106.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768583364; x=1768842564;
	bh=hgF1sC5w0nZhRl9CXrxpuRnpTJCUGr7J7j9UsMP7WBU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DWNXtTIayxOvHp4Sq0R+LiqaUQvG/qOVVK7VcxgSyVgrAIvJawhtepERoEqLfR7mK
	 hFINzuMEkx9KiZ22uOYnI6cu+dXAGwb5yoWuAOQrC0EDciUnSwoZTSOqHh+iuHiobm
	 j+ZkR17pkEgsfakpDgdxe6SeoxP89E2DzB3+gIu4mOgDj7OzXAK5N7HqZPob4J0uf5
	 YxsQu5qJ6uK6BSMUkEkX7/pPV3RFlIxcsgWPe3jl/qO59j4y5ThHPjsR6KLk9DV9z/
	 Ib9gLMeqFMpZphkBWOfm1ZGrCEA03kNTGt3qvaiJUTVPUnP3TcWnnXJvxWWkDGFzha
	 lDxDws0+bUIMg==
Date: Fri, 16 Jan 2026 17:09:17 +0000
To: Sean Christopherson <seanjc@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 09/14] x86/mm: LAM compatible non-canonical definition
Message-ID: <aWpv9MgPHMYR27I0@wieczorr-mobl1.localdomain>
In-Reply-To: <aWpuuiuqZhkGRj2B@google.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me> <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com> <19zLzHKb9uDih-eLthvMnb-TF7WvD5Dk7shNZvYqyzl7wAsyS6s_fXuZG7pMOR4XfouH8Tb1MT7LqHvV5RXQLw==@protonmail.internalid> <aWpRwJqjzBxOaRwi@google.com> <aWpb1AnRHW2yupZp@wieczorr-mobl1.localdomain> <aWpuuiuqZhkGRj2B@google.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 6407d752904376ac3bb2995fc8da4a870aabc55b
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2026-01-16 at 09:00:42 -0800, Sean Christopherson wrote:
>On Fri, Jan 16, 2026, Maciej Wieczor-Retman wrote:
>> On 2026-01-16 at 06:57:04 -0800, Sean Christopherson wrote:
>> >On Fri, Jan 16, 2026, Andrey Ryabinin wrote:
>> >> On 1/12/26 6:28 PM, Maciej Wieczor-Retman wrote:
>> >> > diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/pag=
e.h
>> >> > index bcf5cad3da36..b7940fa49e64 100644
>> >> > --- a/arch/x86/include/asm/page.h
>> >> > +++ b/arch/x86/include/asm/page.h
>> >> > @@ -82,9 +82,22 @@ static __always_inline void *pfn_to_kaddr(unsign=
ed long pfn)
>> >> >  =09return __va(pfn << PAGE_SHIFT);
>> >> >  }
>> >> >
>> >> > +#ifdef CONFIG_KASAN_SW_TAGS
>> >> > +#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_b=
its) - 1))
>> >>
>> >> why is the choice of CANONICAL_MASK() gated at compile time? Shouldn=
=E2=80=99t this be a
>> >> runtime decision based on whether LAM is enabled or not on the runnin=
g system?
>>
>> What would be appropriate for KVM? Instead of using #ifdefs checking
>> if(cpu_feature_enabled(X86_FEATURE_LAM))?
>
>None of the above.  Practically speaking, the kernel APIs simply can't aut=
omatically
>handle the checks, because they are dependent on guest virtual CPU state, =
_and_
>on the exact operation.  E.g. LAM doesn't apply to inputs to TLB invalidat=
ion
>instructions like INVVPID and INVPCID.
>
>By the time KVM invokes __is_canonical_address(), KVM has already done the=
 necessary
>LAM unmasking.  E.g. having KVM pass in a flag saying it doesn't need LAM =
masking
>would be rather silly.

Oh good, then I'll leave this function alone and try to work it out differe=
ntly.
Thanks!

>
>> >> > +#else
>> >> > +#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
>> >> > +#endif
>> >> > +
>> >> > +/*
>> >> > + * To make an address canonical either set or clear the bits defin=
ed by the
>> >> > + * CANONICAL_MASK(). Clear the bits for userspace addresses if the=
 top address
>> >> > + * bit is a zero. Set the bits for kernel addresses if the top add=
ress bit is a
>> >> > + * one.
>> >> > + */
>> >> >  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr=
_bits)
>> >>
>> >> +Cc KVM
>> >
>> >Thanks!
>> >
>> >> This is used extensively in KVM code. As far as I can tell, it may be=
 used to
>> >> determine whether a guest virtual address is canonical or not.
>> >
>> >Yep, KVM uses this both to check canonical addresses and to force a can=
onical
>> >address (Intel and AMD disagree on the MSR_IA32_SYSENTER_{EIP,ESP} sema=
ntics in
>> >64-bit mode) for guest addresses.  This change will break KVM badly if =
KASAN_SW_TAGS=3Dy.
>>
>> Oh, thanks! That's good to know.
>>
>> >
>> >> case, the result should depend on whether LAM is enabled for the gues=
t, not
>> >> the host (and certainly not a host's compile-time option).
>> >
>> >Ya, KVM could roll its own versions, but IMO these super low level help=
ers should
>> >do exactly what they say.  E.g. at a glance, I'm not sure pt_event_addr=
_filters_sync()
>> >should be subjected to KASAN_SW_TAGS either.  If that's true, then AFAI=
CT the
>> >_only_ code that wants the LAM-aware behavior is copy_from_kernel_nofau=
lt_allowed(),
>> >so maybe just handle it there?  Not sure that's a great long-term maint=
enance
>> >story either though.
>>
>> Yes, longterm it's probably best to just get it right in here.
>
>As above, I don't think that's feasible, because the context of both the c=
urrent
>(virtual) CPU and the usage matters.  In other words, making __canonical_a=
ddress()
>itself LAM-aware feels wrong.
>
>Actually, the kernel already has to deal with masking LAM bits for userspa=
ce
>addresses, and this series needs to unmask kernel address in other flows t=
hat
>effectively consume virtual addresses in software, so why not just do some=
thing
>similar for copy_from_kernel_nofault_allowed()?
>
>diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
>index 42115ac079cf..0b3c96f8902a 100644
>--- a/arch/x86/mm/maccess.c
>+++ b/arch/x86/mm/maccess.c
>@@ -33,7 +33,8 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe=
_src, size_t size)
>        if (!boot_cpu_data.x86_virt_bits)
>                return true;
>
>-       return __is_canonical_address(vaddr, boot_cpu_data.x86_virt_bits);
>+       return __is_canonical_address(__tag_reset(vaddr),
>+                                     boot_cpu_data.x86_virt_bits);
> }
> #else
> bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size=
)

Thanks! I'll try that :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


