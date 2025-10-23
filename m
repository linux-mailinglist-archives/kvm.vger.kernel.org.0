Return-Path: <kvm+bounces-60868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB8FBFED42
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 03:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBCC13A26A2
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 01:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86211ACEAF;
	Thu, 23 Oct 2025 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MpdTQTdo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0C17A305;
	Thu, 23 Oct 2025 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761182506; cv=none; b=hc7z3x1MdhfrS+XnvZE4TUNGbIwYWISxZKQ8T+DfKTxZYn2sfaxf0h9Bhk6Rn6mkz6CXNt6FEblmrCgiaGgkSmPxGEpRD+SkG0vCi7bPcdlyUOt9qD+TRtI6etamr4qMvySnJDnvXVOoAC602ftB+SNzBFaZEjpta2QhEVZjsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761182506; c=relaxed/simple;
	bh=Cs26bGL6gNj5ycTNgxztit3bcAxl7FrFqDQSQ5lmzXg=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=Kp8q+vpkRMeBVsloyz/g+U11CANZ3OkCXEGb2j5fzIyvSZf8w9nKtF8UAQnMFzw/MUSpXh7dQy+QCiCtqhsOBWhpr31jRQfz4VLXImb/PSgDLAgaZA2gfIyUm1L8ChD8C9rGpGMMaiiSyz1AUt0PaKR+BO/Ne6WNpBnYd0Axkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MpdTQTdo; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59N1KrWM2539646
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 22 Oct 2025 18:20:54 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59N1KrWM2539646
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1761182455;
	bh=ZLUQ1JiNvlWhkPedHh+yb6CE80AdTaykCyDusRDhtkQ=;
	h=From:Subject:Date:References:Cc:In-Reply-To:To:From;
	b=MpdTQTdoe9MfSH9nzvYLcxz2vAPOoqDD2H4PKD4R46mf2YdM7mx6xYN4sOFT4fv74
	 e+zNPD3GDVGzv1dm3RzmqHmPl00ojskaYqAdjSlHJWvxNL1NF+h2k+om2lkbgA75F+
	 PP846aVH3U2MOoWSVPxOG7O30+eXw0mS6LW6n3p4NSQEdUxQnQ8Pf+6IjLghToPe8f
	 DlcSqLB4lgDwZ/zhbTLQhxYlC3yyCdpYokpuuGsRnQ/QAIBLqP69NqO+n34uuS94B4
	 RvCOsP1gp4jGv8L49W90L+qR7DID+b6nHefKqlP2d7JYPL6IoTQLoPiQb1sbgDYs2B
	 LCf38gVLXtxWQ==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Xin Li <xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for KVM
Date: Wed, 22 Oct 2025 18:20:43 -0700
Message-Id: <6596E9D7-E0B9-4AEA-BC39-2A637B401DC1@zytor.com>
References: <20251014010950.1568389-6-xin@zytor.com>
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org
In-Reply-To: <20251014010950.1568389-6-xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
X-Mailer: iPhone Mail (23A355)


> =EF=BB=BFConvert the __this_cpu_ist_{top,bottom}_va() macros into proper f=
unctions,
> and export __this_cpu_ist_top_va() to allow KVM to retrieve the top of the=

> per-CPU exception stack.
>=20
> FRED introduced new fields in the host-state area of the VMCS for stack
> levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
> per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
> fields each time a vCPU is loaded onto a CPU.
>=20
> To simplify access to the exception stacks in struct cea_exception_stacks,=

> a union is used to create an array alias, enabling array-style indexing of=

> the stack entries.
>=20
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>

Dave, can you please help to review patch 4 & 5?

Thanks!
Xin

> ---
>=20
> Change in v7:
> * Remove Suggested-bys (Dave Hansen).
> * Move rename code in a separate patch (Dave Hansen).
> * Access cea_exception_stacks using array indexing (Dave Hansen).
> * Use BUILD_BUG_ON(ESTACK_DF !=3D 0) to ensure the starting index is 0
>  (Dave Hansen).
>=20
> Change in v5:
> * Export accessor instead of data (Christoph Hellwig).
> * Add TB from Xuelian Guo.
>=20
> Change in v4:
> * Rewrite the change log and add comments to the export (Dave Hansen).
> ---
> arch/x86/include/asm/cpu_entry_area.h | 51 +++++++++++++--------------
> arch/x86/mm/cpu_entry_area.c          | 25 +++++++++++++
> 2 files changed, 50 insertions(+), 26 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/=
cpu_entry_area.h
> index d0f884c28178..58cd71144e5e 100644
> --- a/arch/x86/include/asm/cpu_entry_area.h
> +++ b/arch/x86/include/asm/cpu_entry_area.h
> @@ -16,6 +16,19 @@
> #define VC_EXCEPTION_STKSZ    0
> #endif
>=20
> +/*
> + * The exception stack ordering in [cea_]exception_stacks
> + */
> +enum exception_stack_ordering {
> +    ESTACK_DF,
> +    ESTACK_NMI,
> +    ESTACK_DB,
> +    ESTACK_MCE,
> +    ESTACK_VC,
> +    ESTACK_VC2,
> +    N_EXCEPTION_STACKS
> +};
> +
> /* Macro to enforce the same ordering and stack sizes */
> #define ESTACKS_MEMBERS(guardsize, optional_stack_size)        \
>    char    ESTACK_DF_stack_guard[guardsize];        \
> @@ -39,37 +52,29 @@ struct exception_stacks {
>=20
> /* The effective cpu entry area mapping with guard pages. */
> struct cea_exception_stacks {
> -    ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
> -};
> -
> -/*
> - * The exception stack ordering in [cea_]exception_stacks
> - */
> -enum exception_stack_ordering {
> -    ESTACK_DF,
> -    ESTACK_NMI,
> -    ESTACK_DB,
> -    ESTACK_MCE,
> -    ESTACK_VC,
> -    ESTACK_VC2,
> -    N_EXCEPTION_STACKS
> +    union{
> +        struct {
> +            ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
> +        };
> +        struct {
> +            char stack_guard[PAGE_SIZE];
> +            char stack[EXCEPTION_STKSZ];
> +        } event_stacks[N_EXCEPTION_STACKS];
> +    };
> };
>=20
> #define CEA_ESTACK_SIZE(st)                    \
>    sizeof(((struct cea_exception_stacks *)0)->st## _stack)
>=20
> -#define CEA_ESTACK_BOT(ceastp, st)                \
> -    ((unsigned long)&(ceastp)->st## _stack)
> -
> -#define CEA_ESTACK_TOP(ceastp, st)                \
> -    (CEA_ESTACK_BOT(ceastp, st) + CEA_ESTACK_SIZE(st))
> -
> #define CEA_ESTACK_OFFS(st)                    \
>    offsetof(struct cea_exception_stacks, st## _stack)
>=20
> #define CEA_ESTACK_PAGES                    \
>    (sizeof(struct cea_exception_stacks) / PAGE_SIZE)
>=20
> +extern unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering s=
tack);
> +extern unsigned long __this_cpu_ist_bottom_va(enum exception_stack_orderi=
ng stack);
> +
> #endif
>=20
> #ifdef CONFIG_X86_32
> @@ -144,10 +149,4 @@ static __always_inline struct entry_stack *cpu_entry_=
stack(int cpu)
>    return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
> }
>=20
> -#define __this_cpu_ist_top_va(name)                    \
> -    CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
> -
> -#define __this_cpu_ist_bottom_va(name)                    \
> -    CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
> -
> #endif
> diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
> index 9fa371af8abc..595c2e03ddd5 100644
> --- a/arch/x86/mm/cpu_entry_area.c
> +++ b/arch/x86/mm/cpu_entry_area.c
> @@ -18,6 +18,31 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_p=
age, entry_stack_storage)
> static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stac=
ks);
> DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
>=20
> +/*
> + * FRED introduced new fields in the host-state area of the VMCS for
> + * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
> + * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
> + * populate these each time a vCPU is loaded onto a CPU.
> + *
> + * Called from entry code, so must be noinstr.
> + */
> +noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_order=
ing stack)
> +{
> +    struct cea_exception_stacks *s;
> +
> +    BUILD_BUG_ON(ESTACK_DF !=3D 0);
> +
> +    s =3D __this_cpu_read(cea_exception_stacks);
> +
> +    return (unsigned long)&s->event_stacks[stack].stack;
> +}
> +
> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering=
 stack)
> +{
> +    return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
> +}
> +EXPORT_SYMBOL(__this_cpu_ist_top_va);
> +
> static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
>=20
> static __always_inline unsigned int cea_offset(unsigned int cpu)
> --
> 2.51.0
>=20
>=20


