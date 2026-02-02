Return-Path: <kvm+bounces-69906-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kODDJWEDgWnZDgMAu9opvQ
	(envelope-from <kvm+bounces-69906-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:04:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B7AD0E8A
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0785D3062967
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 20:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DDF30C35E;
	Mon,  2 Feb 2026 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ot8g1iR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA04429E0E8
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770062538; cv=pass; b=TneoEl/nt7RynW6pxABizoKV5vm1H1LmtNyyfHJeEfcBVPwGm6XYUPG+f4a7CQ1OwTSgKAjQB9i6Y5ZfhMgoko53ZqCgwE6PB0TgsRyuqa9Wd++A8YTSR6991AWKk7GO1Rq+pT1ERTUd9X6twA/zET8yWk5X5pyV+52gr9IBkIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770062538; c=relaxed/simple;
	bh=7lX9Ih7l4XfaMkeJ1oadylNWhfI+0UdT+W46nB4oAnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mL/eTxjmmGWIvuu+bzSWOOX02+1pLv9XDGzCe0eEfCTbb46IyJ/ygZ66NIJxYphCtdszfyWShnbrySsy9BTsAoopZe50+MqzAR4boK/K/7OB5qu6nOYtQ3nMOAxAYy/jfe6AgfCIXOq3+AcrNd6Z9cZnAgNWHgvzK8o6xGbWrk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ot8g1iR; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso2306a12.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 12:02:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770062535; cv=none;
        d=google.com; s=arc-20240605;
        b=PzPk5YCdBLiGA5tjeuHv1OMpu9txE6JIyvX7eZ0j7SUoqGpr/smEh68Ell6saMjAEs
         yN8v8SxCa5/cPG507EcxDG+EuwtGmf2fuZM68BF/eL8h6JyXqfID1mgAuiMJrBgDbwPT
         5r7F2LTYDgiRoQ3gXtZDd+4VkJKkTiTRd+/huGbuYQ/1ElLwuKf3g0fkQE7aNP5ONDAL
         dkcKnIOrdHmt7HgJg7sEtA9S9bNo59PigpOf6N95aixqPtX5Dtb94xAaRH+vHjIMfvIM
         ZpJwRzHucTAsebrbYhObxVTI1MN23vb11BAITsFQmCyL1nocmiCtDctE2oTqFXV0SiPc
         8QTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aWOK8SirIwQa+Rz7v++tb+WC55K8rKSbXo1UX280qkg=;
        fh=Cr9Q2XamF911ysM7KWOGYoVIA+10rwhM4fdHNAgKQ1M=;
        b=gNRo7b8XQ2xjNXDuSKIjbfS3N3FAnOdcrV8s4KwZ/2bku6+G5w2nn012OdTpPEHaB7
         gAl07jHfQqS5Qw4H6/GPUnYypv2Weh81g74kJ+G/80RejrR58B/eZttWurfcDQmY5Iim
         UbJJyixE5W7KtCFAJbyWNg7ugNCcZnYWnpTNgwwjd6DHY8nX0PPdcB5ad5ihKVlfWQVU
         wQkGJ6djer//KEjcVk8gYzFJ6LbAfzAfsNvBfz8N/h1rKivuftuxQAgb/rTP2Mzw05bQ
         ebs3i1wlOqZ0CHOBf9ahZ41i3Yg6da0do6kbspoHKNOtSezOdR8IVkh3XPzIzdxHxgGI
         DzBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770062535; x=1770667335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWOK8SirIwQa+Rz7v++tb+WC55K8rKSbXo1UX280qkg=;
        b=4ot8g1iRGH5cKSOAiazJvQf73YPn0PLuLWtqf1bhSsl2hM8XrllCrZf2VkP4BEUhpF
         slvczL29aXeY0VSlIjv6ORPgpk0g0lN2ORgLiOT5dECEwWv+Cn92wKdmzuUXv4zRoDkj
         LrH46eQyMgdAGZgbdxckC/d6OtyV8siTHglKCL4/l9sLDV5tgyCE5/oJeBmgAd/e7zLz
         j5LWglyTkOBK0nSXVFU8FbwiUm9kKWIyutQP2WnIED0kCD+k5chR0eJ+iK9Q9zpY3LT4
         XoS2ks0NopimVCA23EA++CaJUgQmHh2zYPeC9M+lgOjBVmPtoLCA5H1PnWBUAxj2VCqy
         yqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770062535; x=1770667335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aWOK8SirIwQa+Rz7v++tb+WC55K8rKSbXo1UX280qkg=;
        b=cwbg7OY6Dr+W10b7BLKPoHaDG9oy8pXp9808ZAEnn2gxWc8dGw7RY4M+jtNhJ5X1zs
         tVIh1SnLOhamI8pmhFuk9GsRcpxQUXLXG2Xsy6Wi9MGm33Kgb6TmqOYQS2RxMWogUNqj
         60J/frOyVoVgt1XO6azKrRyt2UMhv5f/sEApzb3cOJ0Kwq1OBYm51eqHHOz4qrqbxLGv
         8k7hz4+IymMo2ZziEv7AR+w2nTbUcklHjkXfs21PDbKkQC1CBQKLWzvL+CnZqhMkY0QG
         VzL0zAzGoAKb+yFQDvAXZOBNI58X4anpf9N+oWkmOdQ+sQTrs/nC9oqpRykNq2oH7mPY
         4VGA==
X-Forwarded-Encrypted: i=1; AJvYcCU/gfBmGgHq37BknkWHwNSOyiUwn5oja87plr74tpS5xp9vvEcZWFIjx3Q48LHbfMszz48=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGIBAn2K9+8QbUdQauEXCMDBzDeq8b4veUH9EvZC7du6RpvIrX
	Qg+7+74g1he/GjyyPrCak7ew9Sjqcxn1GABlwIawsTZQrsj3XaA7V7lZby+C88UEz0czROg/QS9
	2S+Zm5gkiqBL/t4Q0xT27cExCAyR+/uUg/FJxYSRZ
X-Gm-Gg: AZuq6aK338Ivbl3B6cxPf7Ao/e9ZI7sEzWKUHjMSg9TzzR8S8ViVlXovKBNzLZ3YxEm
	4zlQPfnKWb2CkSLGmwOa4BYQC/sZMAY2l4GX2zOGTg+v8yJhKcf9rVKGgU4yL8yqn5tX1nKtR5B
	Ui3bP2dQn4DRlN6PL7yAetsokPeYSrhlArFEpT7TqVLmh8OF0fs4b29rMeIEcoYyPwh93N1LZlX
	0RW/jDvNqXBzKi19VW64IK8N6u96BcpN9b/8jfPKG4tD8CWeiu/xxqdfEnDGq5SFttr9ek2nK2H
	hWGEXg==
X-Received: by 2002:a50:ec95:0:b0:650:5d5c:711c with SMTP id
 4fb4d7f45d1cf-65934e28d85mr5208a12.17.1770062535039; Mon, 02 Feb 2026
 12:02:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-2-jmattson@google.com>
 <5jwnuhsfer2eovcran7zfyjh7jjrc4zdjgimuipympjnznq7gr@fxdpszsihgup>
In-Reply-To: <5jwnuhsfer2eovcran7zfyjh7jjrc4zdjgimuipympjnznq7gr@fxdpszsihgup>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 2 Feb 2026 12:02:02 -0800
X-Gm-Features: AZwV_QiP4rEF0n2fXbRIdhissEKmJ5oaEqU37lHYtMEYfcEtHxcde_QEK8T-G4A
Message-ID: <CALMp9eTfph1ijT_cjjLM0RRbBJomc4_34rbG7K_BbJ-3X25b=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69906-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 04B7AD0E8A
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 5:21=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Jan 15, 2026 at 03:21:40PM -0800, Jim Mattson wrote:
> > When the vCPU is in guest mode with nested NPT enabled, guest accesses =
to
> > IA32_PAT are redirected to the gPAT register, which is stored in
> > vmcb02->save.g_pat.
> >
> > Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirec=
ted
> > to hPAT, which is stored in vcpu->arch.pat.
> >
> > This is architected behavior. It also makes it possible to restore a ne=
w
> > checkpoint on an old kernel with reasonable semantics. After the restor=
e,
> > gPAT will be lost, and L2 will run on L1's PAT. Note that the old kerne=
l
> > would have always run L2 on L1's PAT.
>
> This creates a difference in MSR_IA32_CR_PAT handling with nested SVM
> and nested VMX, right?

Correct.

> AFAICT, reading MSR_IA32_CR_PAT while an L2 VMX guest is running will
> read L2's PAT. With this change, the same scenario on SVM will read L1's
> PAT. We can claim that it was always L1's PAT though, because we've
> always been running L2 with L1's PAT.
>
> I am just raising this in case it's a problem to have different behavior
> for SVM and VMX. I understand that we need to do this to be able to
> save/restore L1's PAT with SVM in guest mode and maintain backward
> compatibility.
>
> IIUC VMX does not have the same issue because host and guest PAT are
> both in vmcs12 and are both saved/restored appropriately.

Correct.

> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 31 ++++++++++++++++++++++++-------
> >  1 file changed, 24 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 7041498a8091..3f8581adf0c1 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2846,6 +2846,13 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, st=
ruct msr_data *msr_info)
> >       case MSR_AMD64_DE_CFG:
> >               msr_info->data =3D svm->msr_decfg;
> >               break;
> > +     case MSR_IA32_CR_PAT:
> > +             if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
> > +                 nested_npt_enabled(svm))
> > +                     msr_info->data =3D svm->vmcb->save.g_pat; /* gPAT=
 */
> > +             else
> > +                     msr_info->data =3D vcpu->arch.pat; /* hPAT */
> > +             break;
> >       default:
> >               return kvm_get_msr_common(vcpu, msr_info);
> >       }
> > @@ -2929,14 +2936,24 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, s=
truct msr_data *msr)
> >
> >               break;
> >       case MSR_IA32_CR_PAT:
> > -             ret =3D kvm_set_msr_common(vcpu, msr);
> > -             if (ret)
> > -                     break;
> > +             if (!kvm_pat_valid(data))
> > +                     return 1;
> >
> > -             svm->vmcb01.ptr->save.g_pat =3D data;
>
> This is a bug fix, L2 is now able to alter L1's PAT, right?

Yes, L1 and L2 share a PAT today. The whole series is fixing that mistake.

> > -             if (is_guest_mode(vcpu))
> > -                     nested_vmcb02_compute_g_pat(svm);
> > -             vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>
> This looks like another bug fix, it seems like we'll update vmcb01 but
> clear the clean bit in vmcb02 if we're in guest mode.

I will split this out into a separate patch, since this is tangential
to the rest of the series.

> Probably worth calling these out (and CC:stable, Fixes:.., etc)?
>
> We probably need a comment here explaining the gPAT vs hPAT case, I
> don't think it's super obvious why we only redirect L2's own accesses to
> its PAT but not userspace's.

Point taken.

> > +             if (!msr->host_initiated && is_guest_mode(vcpu) &&
> > +                 nested_npt_enabled(svm)) {
> > +                     svm->vmcb->save.g_pat =3D data; /* gPAT */
> > +                     vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> > +             } else {
> > +                     vcpu->arch.pat =3D data; /* hPAT */
>
> Should we call kvm_set_msr_common() here instead of setting
> vcpu->arch.pat? The kvm_pat_valid() call would be redundant but that
> should be fine. My main concern is if kvm_set_msr_common() gains more
> logic for MSR_IA32_CR_PAT that isn't reflected here. Probably unlikely
> tho..

There are already three open-coded assignments to vcpu->arch.pat on
the VMX side. Perhaps this should be avoided, but it's tangential to
this series.

> > +                     if (npt_enabled) {
> > +                             svm->vmcb01.ptr->save.g_pat =3D data;
> > +                             vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_NPT=
);
> > +                             if (is_guest_mode(vcpu)) {
>
> IIUC (with the fix you mentioned) this is because L1 and L2 share the
> PAT if nested NPT is disabled, and if we're already in guest mode then
> we also need to update vmcb02 (as it was already created based on vmcb01
> with the old PAT). Probably worth a comment.

Noted.

> > +                                     svm->vmcb->save.g_pat =3D data;
> > +                                     vmcb_mark_dirty(svm->vmcb, VMCB_N=
PT);
> > +                             }
> > +                     }
> > +             }
> >               break;
> >       case MSR_IA32_SPEC_CTRL:
> >               if (!msr->host_initiated &&
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

