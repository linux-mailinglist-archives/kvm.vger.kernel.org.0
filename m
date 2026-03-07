Return-Path: <kvm+bounces-73189-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNNKAXF0q2kvdQEAu9opvQ
	(envelope-from <kvm+bounces-73189-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:42:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8A222910D
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8EF03101619
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 00:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E4827991E;
	Sat,  7 Mar 2026 00:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fZKfZLqV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9661D88D7
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772843765; cv=pass; b=Uk7sxY6TW1fdz3Jr9BbQiZHlCghzzRyiHyAeEMhw4t4FfTfxxuav9vkZlnbD6pnGKbzZVvrXmoStt8xfsb7ZGzM2CielnhTUDM03aoIIpJnBusS4o+e2FltUV7Fp6RqGSI9Wi/Zg0P3ukgQfMIMHzP/ayysUNCAw+iwI/DG90FI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772843765; c=relaxed/simple;
	bh=M1HS4LsPzjMn9GjQUpGsmtnEQd7vluU+eud8ws35qTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d72YM6HtJdSUFn2D1IR/gmdmYTYxRriwcvyWdEX8CW/fuv0PtrEV0AitG6kQGHEoeMkVIQm8nL1TmIS6V6/EwmbG3tFY2h6ctQ9umrpJg8gmOrkitpYjnuzteu+Ej8xtjTJ469+yJ2TPVl7u8njYLBOw35vuJcFaEL6Z7aQ8ls0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fZKfZLqV; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so1907a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 16:36:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772843762; cv=none;
        d=google.com; s=arc-20240605;
        b=J5SgwbT5XABEDYtg+rVRkK08Z46Fq8WVVXs7ct2958FBMkHZUTqmKKbtpKduQAXyRe
         3BHdKnitcVF1O94dGhy0KWU+/ESAqcMPMZRuOjuDYIvPFoQrGfqkj/+aj8SCIp3ybuG7
         XTRaVCfxsJfP6e6u7SIXpv8p7bpBc48HSoYyJLYUlO38ZIkFW/JEapGDZxj+AkarG9sI
         Aokm2f+xAGfQNbtvGyr3TJEf0cR9xA0ZXgjXbpyJbaPHzjnDc1p3UoaDXBlzshCievqE
         qN6g+2jvfegWIcgOli/6sCcXGWEo093ucggd+02r+c1CY/2RcMSIlE+kaOVHmPsuLjtd
         dGmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SC9jprVyr/opTRE/m0ovzFxUOAfQ7oj837ZiLpsmnzA=;
        fh=oWzs+iL+1AJgmyf6lJOEswRh5jhxCBL9663+cuVWME4=;
        b=YqirJ/q6zSUhzSBRG0w8hrV6mtVOEktToSlM7Gk/pFXcyZ3scTWHe9QZZ/lfdRwLUG
         bYZe7IuM6E4L/wVDO8pX4P6/HAxyOdb3I8/Ka9HkIHpSOBQ/hQx4w53LOEv2uVQGNEw4
         NdKbW0mXmnIv/lyRfNtArL6Rk8u+7SKrSoS61npxHKQY14affJF9q1h0RuNPDiKXDrtj
         EPYcr/GJ/runf5C1I9pn72Sv6Y0+KxabdYdYDbz1Kv5hY5QpQ0ZpX+NL29HG9eJKo4dO
         NC+zHriqgEGbHz1ZSV/0dPvStongXp2x9jxzcNZDsXQCXxihFWdDxjlghZgPObpzA0lG
         Y6xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772843762; x=1773448562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SC9jprVyr/opTRE/m0ovzFxUOAfQ7oj837ZiLpsmnzA=;
        b=fZKfZLqVwjdRBhaNq3rbr9CJQfER9zpa2jw1R4Drjs56Unsxvcx1iFFYOvuPNtLWD3
         60vQOrd475PaHSEGiyloD+EPpUQM2ka3gekF6PAqz9qHErh2mavb6+3gj5mULvkihyMw
         ugdZtjl7cgZtP/TzgjGEk7SugSpZStz62DhdeUMggVdRQ+2wWXFtZX9s3fODcYCO3YxR
         5sUNJnYlDG8H4D2NZg95xBhdpFa5eX0rgqaBIweVvl+AJ/+w/FG7F6Af6stl5MOKL0OT
         f7SovJtkhuI9+3JBX/8wpnxPAgLFsxuBulRQuPNNUCf4mJFfNtlAcLsJhCjyt+347EP9
         CLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772843762; x=1773448562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SC9jprVyr/opTRE/m0ovzFxUOAfQ7oj837ZiLpsmnzA=;
        b=OJ7MeWXAbo+VfsmwpuO9heaTlnIT9MOO3/7kNZMVsMC1JqzMJQm/vBI+OqeDS9plBv
         UtbW1vHIHF38cIGJbFne+fiVmllk5ZUnKDqk1dHQMb4Me4Mb92YoNGXFrGlgx+2w32SA
         pjndZELMT4MetJTpK1hzXLtaWA6nEtwYavwCvK3KYy6o4k4XBNs/QFJsF23CtgKMJ7Di
         2xHc3ldZcO9yDH5f3nwHNDC024osG0raDb6gy7p/CcbBdoPQTMiyXFUXPthkSzH7Nauj
         sMo9n5jXvRRyL78/j/Ek9GoXaE7xZyVfdjnqUPsNU56wTIaeVnZZnItFrRhjqdzdp/mi
         nyAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB/NFMW1MSUjqpr1Xk3Cd4/ECRCPX3buocPwHsCeFHzoReKFfmI7LNWOOWhjssEedJLzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs06w7vXSxjtmfkmK8/bJTbkqgDcxOSduyznHAmzR1nrD/3PAy
	/jSa6BSQkTxbhsHqT8v7WcR1zW6yyOtsWleOJy3oaRjeE77L9GfV3GC/zISDQoj3ZP94X0fyS1/
	0yr1FjCGAaQsDExiTnPrRIUt3WpMLOR0qNa73q16u
X-Gm-Gg: ATEYQzx/UHnksurBhqyGuxBYAhi5sRg33etj97VKGG3h64TNbu8DboMgPT4/W+ZIDlY
	XvWz2Qj/fu0bwi7ffCP3R2+BSALfN237rU2yR6vTqmDuwP+hXXTb/+nloNK5PQ96DN2ItBHcF1g
	UH7REcYWyu1hnCrhXYBcZFrLe983iNsMUUhQUcJLKgwqDVMoKYXhXSDXHnpZhCnpEm3urkdBPvX
	Dk+dtlNX/58uguQfl5dpXTpJWQVjyKkatXjeBdOWMvTrBPRAPgajk9fFdylyLujnQLbSXdo5Gk1
	942j6VG+qaR8nAg/GA==
X-Received: by 2002:a05:6402:27d0:b0:661:18d5:ee36 with SMTP id
 4fb4d7f45d1cf-661e70e9cb0mr18697a12.4.1772843761478; Fri, 06 Mar 2026
 16:36:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com> <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
 <20260306223225.l2beapz3nvmqefou@desk> <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
 <20260306232920.dja5n7cngrsyj6tk@desk>
In-Reply-To: <20260306232920.dja5n7cngrsyj6tk@desk>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 16:35:49 -0800
X-Gm-Features: AaiRm52ZGXqSaVDu8xWmkiWnKyBM7hQ_7ZiuUhVsoYkxlAJB8WRPG5US2Sgpie0
Message-ID: <CALMp9eSoNaifKyppbjJjNx1YEw9KFv0LGAJ6xD-ko0zJnNXEbw@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5E8A222910D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73189-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.949];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 3:29=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Mar 06, 2026 at 02:57:13PM -0800, Jim Mattson wrote:
> > On Fri, Mar 6, 2026 at 2:32=E2=80=AFPM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > On Fri, Mar 06, 2026 at 01:00:15PM -0800, Jim Mattson wrote:
> > > > On Wed, Nov 19, 2025 at 10:19=E2=80=AFPM Pawan Gupta
> > > > <pawan.kumar.gupta@linux.intel.com> wrote:
> > > > >
> > > > > As a mitigation for BHI, clear_bhb_loop() executes branches that =
overwrites
> > > > > the Branch History Buffer (BHB). On Alder Lake and newer parts th=
is
> > > > > sequence is not sufficient because it doesn't clear enough entrie=
s. This
> > > > > was not an issue because these CPUs have a hardware control (BHI_=
DIS_S)
> > > > > that mitigates BHI in kernel.
> > > > >
> > > > > BHI variant of VMSCAPE requires isolating branch history between =
guests and
> > > > > userspace. Note that there is no equivalent hardware control for =
userspace.
> > > > > To effectively isolate branch history on newer CPUs, clear_bhb_lo=
op()
> > > > > should execute sufficient number of branches to clear a larger BH=
B.
> > > > >
> > > > > Dynamically set the loop count of clear_bhb_loop() such that it i=
s
> > > > > effective on newer CPUs too. Use the hardware control enumeration
> > > > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > > >
> > > > I didn't speak up earlier, because I have always considered the cha=
nge
> > > > in MAXPHYADDR from ICX to SPR a hard barrier for virtual machines
> > > > masquerading as a different platform. Sadly, I am now losing that
> > > > battle. :(
> > > >
> > > > If a heterogeneous migration pool includes hosts with and without
> > > > BHI_CTRL, then BHI_CTRL cannot be advertised to a guest, because it=
 is
> > > > not possible to emulate BHI_DIS_S on a host that doesn't have it.
> > > > Hence, one cannot derive the size of the BHB from the existence of
> > > > this feature bit.
> > >
> > > As far as VMSCAPE mitigation is concerned, mitigation is done by the =
host
> > > so enumeration of BHI_CTRL is not a problem. The issue that you are
> > > refering to exists with or without this patch.
> >
> > The hypervisor *should* set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> > behalf when BHI_CTRL is not advertised to the guest. However, this
> > doesn't actually happen today. KVM does not support the tertiary
> > processor-based VM-execution controls bit 7 (virtualize
> > IA32_SPEC_CTRL), and KVM cedes the IA32_SPEC_CTRL MSR to the guest on
> > the first non-zero write.
>
> The first half of the series adds the support for virtualizing
> IA32_SPEC_CTRL. Atleast that part is worth reconsidering.
>
> https://lore.kernel.org/lkml/20240410143446.797262-1-chao.gao@intel.com/

Yes, the support for virtualizing SPEC_CTRL should be submitted separately.

> > > I suppose your point is in the context of Native BHI mitigation for t=
he
> > > guests.
> >
> > Specific vulnerabilities aside, my point is that one cannot infer
> > anything about the underlying hardware from the presence or absence of
> > BHI_CTRL in a VM.
>
> Agree.
>
> > > > I think we need an explicit CPUID bit that a hypervisor can set to
> > > > indicate that the underlying hardware might be SPR or later.
> > >
> > > Something similar was attempted via virtual-MSRs in the below series:
> > >
> > > [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SU=
PPORT
> > > https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@intel.=
com/
> > >
> > > Do you think a rework of this approach would help?
> >
> > No, I think that whole idea is ill-conceived.  As I said above, the
> > hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> > behalf when BHI_CTRL is not advertised to the guest. I don't see any
> > value in predicating this mitigation on guest usage of the short BHB
> > clearing sequence. Just do it.
>
> There are cases where this would be detrimental:
>
> 1. A guest disabling the mitigation in favor of performance.
> 2. A guest deploying the long SW sequence would suffer from two mitigatio=
ns
>    for the same vulnerability.

The guest is already getting a performance boost from the newer
microarchitecture, so I think this argument is moot.

