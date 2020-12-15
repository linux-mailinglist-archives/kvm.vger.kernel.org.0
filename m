Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEAC2DAFC7
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgLOPIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 10:08:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:52310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbgLOPIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 10:08:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1608044852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DTMgY9IAUintdaOgUwZJxqSz/rzlPjbhmR/iJKmOAsE=;
        b=kqYCIO4LOQIayrtMDj0KQ1k0dZfDtN8TGJgpIw2840lDjyfhS0Pe8gt2FhpQH9C+QaHMrh
        raFYAUlHX+w5hn7WGB6fRkIB7ywg1gbbujlMRbDHRwibmY9VGSOH8Kdg2Lwy0PuCvyyTst
        y6lkWHYnnTqrtysTc7EOIGguUpb0OpM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C1912AF58;
        Tue, 15 Dec 2020 15:07:31 +0000 (UTC)
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Juri Lelli <juri.lelli@redhat.com>, linux-hyperv@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        "VMware, Inc." <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org,
        Ben Segall <bsegall@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Wei Liu <wei.liu@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>,
        xen-devel@lists.xenproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <bp@alien8.de>, luto@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
 <20201215145408.GR3092@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <2eeef3e6-2f7c-82ed-f02b-acd49a47b527@suse.com>
Date:   Tue, 15 Dec 2020 16:07:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201215145408.GR3092@hirez.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bbE03T3vMvfPnuzIYd7blCFzPDKWu8tXK"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bbE03T3vMvfPnuzIYd7blCFzPDKWu8tXK
Content-Type: multipart/mixed; boundary="rOMghP2aNZKArDug7s6citEJGC1oClV5D";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, linux-hyperv@vger.kernel.org,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 "VMware, Inc." <pv-drivers@vmware.com>,
 virtualization@lists.linux-foundation.org, Ben Segall <bsegall@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Wei Liu <wei.liu@kernel.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stephen Hemminger <sthemmin@microsoft.com>, Joerg Roedel <joro@8bytes.org>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Mel Gorman
 <mgorman@suse.de>, xen-devel@lists.xenproject.org,
 Haiyang Zhang <haiyangz@microsoft.com>, Steven Rostedt
 <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>, luto@kernel.org,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Daniel Bristot de Oliveira <bristot@redhat.com>
Message-ID: <2eeef3e6-2f7c-82ed-f02b-acd49a47b527@suse.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
 <20201215145408.GR3092@hirez.programming.kicks-ass.net>
In-Reply-To: <20201215145408.GR3092@hirez.programming.kicks-ass.net>

--rOMghP2aNZKArDug7s6citEJGC1oClV5D
Content-Type: multipart/mixed;
 boundary="------------0BB9EF8F4478FA91BE4D7120"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------0BB9EF8F4478FA91BE4D7120
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 15.12.20 15:54, Peter Zijlstra wrote:
> On Tue, Dec 15, 2020 at 03:18:34PM +0100, Peter Zijlstra wrote:
>> Ah, I was waiting for Josh to have an opinion (and then sorta forgot
>> about the whole thing again). Let me refresh and provide at least a
>> Changelog.
>=20
> How's this then?

Thanks, will add it into my series.


Juergen

>=20
> ---
> Subject: objtool: Alternatives vs ORC, the hard way
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon, 23 Nov 2020 14:43:17 +0100
>=20
> Alternatives pose an interesting problem for unwinders because from
> the unwinders PoV we're just executing instructions, it has no idea
> the text is modified, nor any way of retrieving what with.
>=20
> Therefore the stance has been that alternatives must not change stack
> state, as encoded by commit: 7117f16bf460 ("objtool: Fix ORC vs
> alternatives"). This obviously guarantees that whatever actual
> instructions end up in the text, the unwind information is correct.
>=20
> However, there is one additional source of text patching that isn't
> currently visible to objtool: paravirt immediate patching. And it
> turns out one of these violates the rule.
>=20
> As part of cleaning that up, the unfortunate reality is that objtool
> now has to deal with alternatives modifying unwind state and validate
> the combination is valid and generate ORC data to match.
>=20
> The problem is that a single instance of unwind information (ORC) must
> capture and correctly unwind all alternatives. Since the trivially
> correct mandate is out, implement the straight forward brute-force
> approach:
>=20
>   1) generate CFI information for each alternative
>=20
>   2) unwind every alternative with the merge-sort of the previously
>      generated CFI information -- O(n^2)
>=20
>   3) for any possible conflict: yell.
>=20
>   4) Generate ORC with merge-sort
>=20
> Specifically for 3 there are two possible classes of conflicts:
>=20
>   - the merge-sort itself could find conflicting CFI for the same
>     offset.
>=20
>   - the unwind can fail with the merged CFI.
>=20
> In specific, this allows us to deal with:
>=20
> 	Alt1			Alt2			Alt3
>=20
>   0x00	CALL *pv_ops.save_fl	CALL xen_save_fl	PUSHF
>   0x01							POP %RAX
>   0x02							NOP
>   ...
>   0x05				NOP
>   ...
>   0x07   <insn>
>=20
> The unwind information for offset-0x00 is identical for all 3
> alternatives. Similarly offset-0x05 and higher also are identical (and
> the same as 0x00). However offset-0x01 has deviating CFI, but that is
> only relevant for Alt3, neither of the other alternative instruction
> streams will ever hit that offset.
>=20
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>   tools/objtool/check.c   |  180 ++++++++++++++++++++++++++++++++++++++=
++++++----
>   tools/objtool/check.h   |    5 +
>   tools/objtool/orc_gen.c |  180 +++++++++++++++++++++++++++++++-------=
----------
>   3 files changed, 290 insertions(+), 75 deletions(-)
>=20
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -1096,6 +1096,32 @@ static int handle_group_alt(struct objto
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
> @@ -2237,18 +2263,12 @@ static int handle_insn_ops(struct instru
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
> @@ -2460,19 +2480,137 @@ static int validate_return(struct symbol
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
> @@ -2484,9 +2622,10 @@ static void fill_alternative_cfi(struct
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
> @@ -2541,8 +2680,10 @@ static int validate_branch(struct objtoo
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
> @@ -2697,6 +2838,17 @@ static int validate_branch(struct objtoo
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
> --- a/tools/objtool/check.h
> +++ b/tools/objtool/check.h
> @@ -41,6 +41,7 @@ struct instruction {
>   	struct instruction *first_jump_src;
>   	struct reloc *jump_table;
>   	struct list_head alts;
> +	struct instruction *alt_end;
>   	struct symbol *func;
>   	struct list_head stack_ops;
>   	struct cfi_state cfi;
> @@ -55,6 +56,10 @@ static inline bool is_static_jump(struct
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
> --- a/tools/objtool/orc_gen.c
> +++ b/tools/objtool/orc_gen.c
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
> +
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
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>=20


--------------0BB9EF8F4478FA91BE4D7120
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

--------------0BB9EF8F4478FA91BE4D7120--

--rOMghP2aNZKArDug7s6citEJGC1oClV5D--

--bbE03T3vMvfPnuzIYd7blCFzPDKWu8tXK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAl/Y0TEFAwAAAAAACgkQsN6d1ii/Ey90
5gf/fv6ShHPDsI6KjVGI01pyEfB7zDILbgYz5I1pW/QR1lKJCIIoFLrMMH8py872tlshMice+SiY
ZBPTyyXz+h8bX//x8DGdvI5Hs482fWql/k7zjojO/vDc8uPyqQduf0WTn0umbRR5SFmF8KnPxGMG
3/uIyRCQCl9SSAMVKjkv4nG4d8YXgScYr6/40lxeKuFh6nglSlIxwyviZVB2GTNs7UNa0KiYVSOo
+nN5BHDLpZvLbe4lAFh3+SHld1uZML9OmbNq6f7SJOp4zSCEfvqPBbEXJQ8TBa7JGYuKSD3IUQpS
+fogPib/MIc4ihSryEAzmJw/MXu0djiGjMDJquBIEw==
=UqFe
-----END PGP SIGNATURE-----

--bbE03T3vMvfPnuzIYd7blCFzPDKWu8tXK--
