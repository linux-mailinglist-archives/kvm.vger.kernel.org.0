Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8662DAC3B
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 12:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgLOLng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 06:43:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:51012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgLOLng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 06:43:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1608032567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8JgTs45MuhZxp31unKb1wCSq9R0yfQ1p132Smb6fNbE=;
        b=eJxV41g0cLnyuFzF7+jvLZgSq72DDtjDi69jcCuJm38/OdETrwGMcJmFBHJXr7D/bpNwDc
        XnlFiyx38G3FK0y/VWeDFQjNYzetAYxoLQfYVHbu+aVmvayMvPLUXHVc2GG7X6zsMhGIU+
        N5elEp2XyFiRMzWokHOth1GTVb1gs9c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88697AE47;
        Tue, 15 Dec 2020 11:42:47 +0000 (UTC)
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
Date:   Tue, 15 Dec 2020 12:42:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123134317.GE3092@hirez.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H2kwefz8uIE15eQoOkpjLVA8XJ0Q8kIsD"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H2kwefz8uIE15eQoOkpjLVA8XJ0Q8kIsD
Content-Type: multipart/mixed; boundary="eJf0I1odMv2scnFFsZ16khArxsjn0GCwk";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, Deep Shah <sdeep@vmware.com>,
 "VMware, Inc." <pv-drivers@vmware.com>, "K. Y. Srinivasan"
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Stephen Hemminger <sthemmin@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
In-Reply-To: <20201123134317.GE3092@hirez.programming.kicks-ass.net>

--eJf0I1odMv2scnFFsZ16khArxsjn0GCwk
Content-Type: multipart/mixed;
 boundary="------------F4E81710D117794268EEB261"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------F4E81710D117794268EEB261
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter,

On 23.11.20 14:43, Peter Zijlstra wrote:
> On Fri, Nov 20, 2020 at 01:53:42PM +0100, Peter Zijlstra wrote:
>> On Fri, Nov 20, 2020 at 12:46:18PM +0100, Juergen Gross wrote:
>>>   30 files changed, 325 insertions(+), 598 deletions(-)
>>
>> Much awesome ! I'll try and get that objtool thing sorted.
>=20
> This seems to work for me. It isn't 100% accurate, because it doesn't
> know about the direct call instruction, but I can either fudge that or
> switching to static_call() will cure that.
>=20
> It's not exactly pretty, but it should be straight forward.

Are you planning to send this out as an "official" patch, or should I
include it in my series (in this case I'd need a variant with a proper
commit message)?

I'd like to have this settled soon, as I'm going to send V2 of my
series hopefully this week.


Juergen

>=20
> Index: linux-2.6/tools/objtool/check.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/tools/objtool/check.c
> +++ linux-2.6/tools/objtool/check.c
> @@ -1090,6 +1090,32 @@ static int handle_group_alt(struct objto
>   		return -1;
>   	}
>  =20
> +	/*
> +	 * Add the filler NOP, required for alternative CFI.
> +	 */
> +	if (special_alt->group && special_alt->new_len < special_alt->orig_le=
n) {
> +		struct instruction *nop =3D malloc(sizeof(*nop));
> +		if (!nop) {
> +			WARN("malloc failed");
> +			return -1;
> +		}
> +		memset(nop, 0, sizeof(*nop));
> +		INIT_LIST_HEAD(&nop->alts);
> +		INIT_LIST_HEAD(&nop->stack_ops);
> +		init_cfi_state(&nop->cfi);
> +
> +		nop->sec =3D last_new_insn->sec;
> +		nop->ignore =3D last_new_insn->ignore;
> +		nop->func =3D last_new_insn->func;
> +		nop->alt_group =3D alt_group;
> +		nop->offset =3D last_new_insn->offset + last_new_insn->len;
> +		nop->type =3D INSN_NOP;
> +		nop->len =3D special_alt->orig_len - special_alt->new_len;
> +
> +		list_add(&nop->list, &last_new_insn->list);
> +		last_new_insn =3D nop;
> +	}
> +
>   	if (fake_jump)
>   		list_add(&fake_jump->list, &last_new_insn->list);
>  =20
> @@ -2190,18 +2216,12 @@ static int handle_insn_ops(struct instru
>   	struct stack_op *op;
>  =20
>   	list_for_each_entry(op, &insn->stack_ops, list) {
> -		struct cfi_state old_cfi =3D state->cfi;
>   		int res;
>  =20
>   		res =3D update_cfi_state(insn, &state->cfi, op);
>   		if (res)
>   			return res;
>  =20
> -		if (insn->alt_group && memcmp(&state->cfi, &old_cfi, sizeof(struct c=
fi_state))) {
> -			WARN_FUNC("alternative modifies stack", insn->sec, insn->offset);
> -			return -1;
> -		}
> -
>   		if (op->dest.type =3D=3D OP_DEST_PUSHF) {
>   			if (!state->uaccess_stack) {
>   				state->uaccess_stack =3D 1;
> @@ -2399,19 +2419,137 @@ static int validate_return(struct symbol
>    * unreported (because they're NOPs), such holes would result in CFI_=
UNDEFINED
>    * states which then results in ORC entries, which we just said we di=
dn't want.
>    *
> - * Avoid them by copying the CFI entry of the first instruction into t=
he whole
> - * alternative.
> + * Avoid them by copying the CFI entry of the first instruction into t=
he hole.
>    */
> -static void fill_alternative_cfi(struct objtool_file *file, struct ins=
truction *insn)
> +static void __fill_alt_cfi(struct objtool_file *file, struct instructi=
on *insn)
>   {
>   	struct instruction *first_insn =3D insn;
>   	int alt_group =3D insn->alt_group;
>  =20
> -	sec_for_each_insn_continue(file, insn) {
> +	sec_for_each_insn_from(file, insn) {
>   		if (insn->alt_group !=3D alt_group)
>   			break;
> -		insn->cfi =3D first_insn->cfi;
> +
> +		if (!insn->visited)
> +			insn->cfi =3D first_insn->cfi;
> +	}
> +}
> +
> +static void fill_alt_cfi(struct objtool_file *file, struct instruction=
 *alt_insn)
> +{
> +	struct alternative *alt;
> +
> +	__fill_alt_cfi(file, alt_insn);
> +
> +	list_for_each_entry(alt, &alt_insn->alts, list)
> +		__fill_alt_cfi(file, alt->insn);
> +}
> +
> +static struct instruction *
> +__find_unwind(struct objtool_file *file,
> +	      struct instruction *insn, unsigned long offset)
> +{
> +	int alt_group =3D insn->alt_group;
> +	struct instruction *next;
> +	unsigned long off =3D 0;
> +
> +	while ((off + insn->len) <=3D offset) {
> +		next =3D next_insn_same_sec(file, insn);
> +		if (next && next->alt_group !=3D alt_group)
> +			next =3D NULL;
> +
> +		if (!next)
> +			break;
> +
> +		off +=3D insn->len;
> +		insn =3D next;
>   	}
> +
> +	return insn;
> +}
> +
> +struct instruction *
> +find_alt_unwind(struct objtool_file *file,
> +		struct instruction *alt_insn, unsigned long offset)
> +{
> +	struct instruction *fit;
> +	struct alternative *alt;
> +	unsigned long fit_off;
> +
> +	fit =3D __find_unwind(file, alt_insn, offset);
> +	fit_off =3D (fit->offset - alt_insn->offset);
> +
> +	list_for_each_entry(alt, &alt_insn->alts, list) {
> +		struct instruction *x;
> +		unsigned long x_off;
> +
> +		x =3D __find_unwind(file, alt->insn, offset);
> +		x_off =3D (x->offset - alt->insn->offset);
> +
> +		if (fit_off < x_off) {
> +			fit =3D x;
> +			fit_off =3D x_off;
> +
> +		} else if (fit_off =3D=3D x_off &&
> +			   memcmp(&fit->cfi, &x->cfi, sizeof(struct cfi_state))) {
> +
> +			char *_str1 =3D offstr(fit->sec, fit->offset);
> +			char *_str2 =3D offstr(x->sec, x->offset);
> +			WARN("%s: equal-offset incompatible alternative: %s\n", _str1, _str=
2);
> +			free(_str1);
> +			free(_str2);
> +			return fit;
> +		}
> +	}
> +
> +	return fit;
> +}
> +
> +static int __validate_unwind(struct objtool_file *file,
> +			     struct instruction *alt_insn,
> +			     struct instruction *insn)
> +{
> +	int alt_group =3D insn->alt_group;
> +	struct instruction *unwind;
> +	unsigned long offset =3D 0;
> +
> +	sec_for_each_insn_from(file, insn) {
> +		if (insn->alt_group !=3D alt_group)
> +			break;
> +
> +		unwind =3D find_alt_unwind(file, alt_insn, offset);
> +
> +		if (memcmp(&insn->cfi, &unwind->cfi, sizeof(struct cfi_state))) {
> +
> +			char *_str1 =3D offstr(insn->sec, insn->offset);
> +			char *_str2 =3D offstr(unwind->sec, unwind->offset);
> +			WARN("%s: unwind incompatible alternative: %s (%ld)\n",
> +			     _str1, _str2, offset);
> +			free(_str1);
> +			free(_str2);
> +			return 1;
> +		}
> +
> +		offset +=3D insn->len;
> +	}
> +
> +	return 0;
> +}
> +
> +static int validate_alt_unwind(struct objtool_file *file,
> +			       struct instruction *alt_insn)
> +{
> +	struct alternative *alt;
> +
> +	if (__validate_unwind(file, alt_insn, alt_insn))
> +		return 1;
> +
> +	list_for_each_entry(alt, &alt_insn->alts, list) {
> +		if (__validate_unwind(file, alt_insn, alt->insn))
> +			return 1;
> +	}
> +
> +	return 0;
>   }
>  =20
>   /*
> @@ -2423,9 +2561,10 @@ static void fill_alternative_cfi(struct
>   static int validate_branch(struct objtool_file *file, struct symbol *=
func,
>   			   struct instruction *insn, struct insn_state state)
>   {
> +	struct instruction *next_insn, *alt_insn =3D NULL;
>   	struct alternative *alt;
> -	struct instruction *next_insn;
>   	struct section *sec;
> +	int alt_group =3D 0;
>   	u8 visited;
>   	int ret;
>  =20
> @@ -2480,8 +2619,10 @@ static int validate_branch(struct objtoo
>   				}
>   			}
>  =20
> -			if (insn->alt_group)
> -				fill_alternative_cfi(file, insn);
> +			if (insn->alt_group) {
> +				alt_insn =3D insn;
> +				alt_group =3D insn->alt_group;
> +			}
>  =20
>   			if (skip_orig)
>   				return 0;
> @@ -2613,6 +2754,17 @@ static int validate_branch(struct objtoo
>   		}
>  =20
>   		insn =3D next_insn;
> +
> +		if (alt_insn && insn->alt_group !=3D alt_group) {
> +			alt_insn->alt_end =3D insn;
> +
> +			fill_alt_cfi(file, alt_insn);
> +
> +			if (validate_alt_unwind(file, alt_insn))
> +				return 1;
> +
> +			alt_insn =3D NULL;
> +		}
>   	}
>  =20
>   	return 0;
> Index: linux-2.6/tools/objtool/check.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/tools/objtool/check.h
> +++ linux-2.6/tools/objtool/check.h
> @@ -40,6 +40,7 @@ struct instruction {
>   	struct instruction *first_jump_src;
>   	struct reloc *jump_table;
>   	struct list_head alts;
> +	struct instruction *alt_end;
>   	struct symbol *func;
>   	struct list_head stack_ops;
>   	struct cfi_state cfi;
> @@ -54,6 +55,10 @@ static inline bool is_static_jump(struct
>   	       insn->type =3D=3D INSN_JUMP_UNCONDITIONAL;
>   }
>  =20
> +struct instruction *
> +find_alt_unwind(struct objtool_file *file,
> +		struct instruction *alt_insn, unsigned long offset);
> +
>   struct instruction *find_insn(struct objtool_file *file,
>   			      struct section *sec, unsigned long offset);
>  =20
> Index: linux-2.6/tools/objtool/orc_gen.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/tools/objtool/orc_gen.c
> +++ linux-2.6/tools/objtool/orc_gen.c
> @@ -12,75 +12,86 @@
>   #include "check.h"
>   #include "warn.h"
>  =20
> -int create_orc(struct objtool_file *file)
> +static int create_orc_insn(struct objtool_file *file, struct instructi=
on *insn)
>   {
> -	struct instruction *insn;
> +	struct orc_entry *orc =3D &insn->orc;
> +	struct cfi_reg *cfa =3D &insn->cfi.cfa;
> +	struct cfi_reg *bp =3D &insn->cfi.regs[CFI_BP];
> +
> +	orc->end =3D insn->cfi.end;
> +
> +	if (cfa->base =3D=3D CFI_UNDEFINED) {
> +		orc->sp_reg =3D ORC_REG_UNDEFINED;
> +		return 0;
> +	}
>  =20
> -	for_each_insn(file, insn) {
> -		struct orc_entry *orc =3D &insn->orc;
> -		struct cfi_reg *cfa =3D &insn->cfi.cfa;
> -		struct cfi_reg *bp =3D &insn->cfi.regs[CFI_BP];
> +	switch (cfa->base) {
> +	case CFI_SP:
> +		orc->sp_reg =3D ORC_REG_SP;
> +		break;
> +	case CFI_SP_INDIRECT:
> +		orc->sp_reg =3D ORC_REG_SP_INDIRECT;
> +		break;
> +	case CFI_BP:
> +		orc->sp_reg =3D ORC_REG_BP;
> +		break;
> +	case CFI_BP_INDIRECT:
> +		orc->sp_reg =3D ORC_REG_BP_INDIRECT;
> +		break;
> +	case CFI_R10:
> +		orc->sp_reg =3D ORC_REG_R10;
> +		break;
> +	case CFI_R13:
> +		orc->sp_reg =3D ORC_REG_R13;
> +		break;
> +	case CFI_DI:
> +		orc->sp_reg =3D ORC_REG_DI;
> +		break;
> +	case CFI_DX:
> +		orc->sp_reg =3D ORC_REG_DX;
> +		break;
> +	default:
> +		WARN_FUNC("unknown CFA base reg %d",
> +			  insn->sec, insn->offset, cfa->base);
> +		return -1;
> +	}
>  =20
> -		if (!insn->sec->text)
> -			continue;
> +	switch(bp->base) {
> +	case CFI_UNDEFINED:
> +		orc->bp_reg =3D ORC_REG_UNDEFINED;
> +		break;
> +	case CFI_CFA:
> +		orc->bp_reg =3D ORC_REG_PREV_SP;
> +		break;
> +	case CFI_BP:
> +		orc->bp_reg =3D ORC_REG_BP;
> +		break;
> +	default:
> +		WARN_FUNC("unknown BP base reg %d",
> +			  insn->sec, insn->offset, bp->base);
> +		return -1;
> +	}
>  =20
> -		orc->end =3D insn->cfi.end;
> +	orc->sp_offset =3D cfa->offset;
> +	orc->bp_offset =3D bp->offset;
> +	orc->type =3D insn->cfi.type;
>  =20
> -		if (cfa->base =3D=3D CFI_UNDEFINED) {
> -			orc->sp_reg =3D ORC_REG_UNDEFINED;
> -			continue;
> -		}
> +	return 0;
> +}
>  =20
> -		switch (cfa->base) {
> -		case CFI_SP:
> -			orc->sp_reg =3D ORC_REG_SP;
> -			break;
> -		case CFI_SP_INDIRECT:
> -			orc->sp_reg =3D ORC_REG_SP_INDIRECT;
> -			break;
> -		case CFI_BP:
> -			orc->sp_reg =3D ORC_REG_BP;
> -			break;
> -		case CFI_BP_INDIRECT:
> -			orc->sp_reg =3D ORC_REG_BP_INDIRECT;
> -			break;
> -		case CFI_R10:
> -			orc->sp_reg =3D ORC_REG_R10;
> -			break;
> -		case CFI_R13:
> -			orc->sp_reg =3D ORC_REG_R13;
> -			break;
> -		case CFI_DI:
> -			orc->sp_reg =3D ORC_REG_DI;
> -			break;
> -		case CFI_DX:
> -			orc->sp_reg =3D ORC_REG_DX;
> -			break;
> -		default:
> -			WARN_FUNC("unknown CFA base reg %d",
> -				  insn->sec, insn->offset, cfa->base);
> -			return -1;
> -		}
> +int create_orc(struct objtool_file *file)
> +{
> +	struct instruction *insn;
>  =20
> -		switch(bp->base) {
> -		case CFI_UNDEFINED:
> -			orc->bp_reg =3D ORC_REG_UNDEFINED;
> -			break;
> -		case CFI_CFA:
> -			orc->bp_reg =3D ORC_REG_PREV_SP;
> -			break;
> -		case CFI_BP:
> -			orc->bp_reg =3D ORC_REG_BP;
> -			break;
> -		default:
> -			WARN_FUNC("unknown BP base reg %d",
> -				  insn->sec, insn->offset, bp->base);
> -			return -1;
> -		}
> +	for_each_insn(file, insn) {
> +		int ret;
> +=09
> +		if (!insn->sec->text)
> +			continue;
>  =20
> -		orc->sp_offset =3D cfa->offset;
> -		orc->bp_offset =3D bp->offset;
> -		orc->type =3D insn->cfi.type;
> +		ret =3D create_orc_insn(file, insn);
> +		if (ret)
> +			return ret;
>   	}
>  =20
>   	return 0;
> @@ -166,6 +177,28 @@ int create_orc_sections(struct objtool_f
>  =20
>   		prev_insn =3D NULL;
>   		sec_for_each_insn(file, sec, insn) {
> +
> +			if (insn->alt_end) {
> +				unsigned int offset, alt_len;
> +				struct instruction *unwind;
> +
> +				alt_len =3D insn->alt_end->offset - insn->offset;
> +				for (offset =3D 0; offset < alt_len; offset++) {
> +					unwind =3D find_alt_unwind(file, insn, offset);
> +					/* XXX: skipped earlier ! */
> +					create_orc_insn(file, unwind);
> +					if (!prev_insn ||
> +					    memcmp(&unwind->orc, &prev_insn->orc,
> +						   sizeof(struct orc_entry))) {
> +						idx++;
> +//						WARN_FUNC("ORC @ %d/%d", sec, insn->offset+offset, offset, alt=
_len);
> +					}
> +					prev_insn =3D unwind;
> +				}
> +
> +				insn =3D insn->alt_end;
> +			}
> +
>   			if (!prev_insn ||
>   			    memcmp(&insn->orc, &prev_insn->orc,
>   				   sizeof(struct orc_entry))) {
> @@ -203,6 +236,31 @@ int create_orc_sections(struct objtool_f
>  =20
>   		prev_insn =3D NULL;
>   		sec_for_each_insn(file, sec, insn) {
> +
> +			if (insn->alt_end) {
> +				unsigned int offset, alt_len;
> +				struct instruction *unwind;
> +
> +				alt_len =3D insn->alt_end->offset - insn->offset;
> +				for (offset =3D 0; offset < alt_len; offset++) {
> +					unwind =3D find_alt_unwind(file, insn, offset);
> +					if (!prev_insn ||
> +					    memcmp(&unwind->orc, &prev_insn->orc,
> +						   sizeof(struct orc_entry))) {
> +
> +						if (create_orc_entry(file->elf, u_sec, ip_relocsec, idx,
> +								     insn->sec, insn->offset + offset,
> +								     &unwind->orc))
> +							return -1;
> +
> +						idx++;
> +					}
> +					prev_insn =3D unwind;
> +				}
> +
> +				insn =3D insn->alt_end;
> +			}
> +
>   			if (!prev_insn || memcmp(&insn->orc, &prev_insn->orc,
>   						 sizeof(struct orc_entry))) {
>  =20
>=20


--------------F4E81710D117794268EEB261
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------F4E81710D117794268EEB261--

--eJf0I1odMv2scnFFsZ16khArxsjn0GCwk--

--H2kwefz8uIE15eQoOkpjLVA8XJ0Q8kIsD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAl/YoTUFAwAAAAAACgkQsN6d1ii/Ey8c
4Af9EPguE36mExOqZBOb5ZgFrhbSqrWQDZmE1KbHgbM1ziiQCfiXQD6+EBEmtuQ0oUDN8hJc/CIg
f0IHhweVykhon4Z9R3Fv9q6z3ZryFRzygP14ZNye2GW6cspH0bp8c2v9vG+0dQKxAUee3cS2hJVn
XHeibQug+fGgdI2D90U6xryasC5CgTFYEttF/tEJNMGbVsZyTzQHHbWtPf93baVeEBfjd2cPe54R
Asv8rjRxGivpEtCA8+mK7Up57mLT6oLLX9CBzpzvfoMz7iQI8tj9gP5WO8NLcqGLF0K4PxREJEzC
UD6+h6ew8YijxTQPm3EL8bqbOZQT5pL+DHnrUoVMcQ==
=Kt/D
-----END PGP SIGNATURE-----

--H2kwefz8uIE15eQoOkpjLVA8XJ0Q8kIsD--
