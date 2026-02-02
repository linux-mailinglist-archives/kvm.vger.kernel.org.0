Return-Path: <kvm+bounces-69908-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANP2IekMgWkCDwMAu9opvQ
	(envelope-from <kvm+bounces-69908-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:45:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FC5D13CD
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 311B3300916F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 20:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7C830CD95;
	Mon,  2 Feb 2026 20:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rgGj6aOS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA03090DD
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770064873; cv=pass; b=kKlvC+95GBjBsk//cuJ3kLNslLUfqRkAjUeuR3bK3QpRbYEQwrDWX4MZ8QcrbNvj/wd0AgPJpKywaCBL76gzJT6Wf4YrCO1MgJVterV0PqWSci1BQUr/v2BWwMHDp/qcAu+KboFayZLK94SfRGJh/RVcukxMsTHByST1HZgU/0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770064873; c=relaxed/simple;
	bh=06KjNwAaG6bm5+TYQv5otpaksSAxLs/PjhIpum3xg4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHpF25+19jJregvWPty7V/PsDHhqiB6l8mmeAkvFWipvT+8HM0/y/Y+wvuUgtz6FPgu8satTBBH4obPya8nuB6H+Q+XZQXDkJwOfQxIScQ3BPwfYxq6Hj7faEkTlIloAn0+5GNYpuCnETeE6dMiU+JlPpdxMkt941Rgsz0K7yxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rgGj6aOS; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so130a12.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 12:41:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770064870; cv=none;
        d=google.com; s=arc-20240605;
        b=OvI10KT2ZtvhiqO1XWScwYABl4k4N/S3FJlIvTFHLHBCXPRfzf1n3L1bMyoyf7WSqE
         bpV+qytqhJcR7zajCB0fcaEy6y4ikRUWyYD5JSFnOniHFeZ76KWwjmZFuCZnZxCRdUMF
         5GuDqB3HlJvuL3wFitzFIov8EBtvOkLsCdG4x1s32/hrIsil7baPsYUlO7ijXyQ1ghdF
         5IgjR6x8ikUP0ozE239xqdL5Cn9IS+0SKYmHJsC+SiFW+TP4YWkgdV4EyYPBclIjcBNk
         svpcSoC1KuNO6W+bTkb+BDcJpHjYTCiCdjRi/cWEQAsT/Go2hUCDmDiqlk5L4MW0uo9o
         FbBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2IMh41X3lfsz0vhQymTprdXfmdt4B+CuibsxTGA9cUQ=;
        fh=loG6OcRef11LzBVLeDXGRRf7eRLhyQomsfv8tF9H9vg=;
        b=HhgH+vXGRPbFqn/n6XQKI63yxqnjUDiKe7HJrhO6aLCNxjjZd9jOy3Hn7BriyrHHjc
         hVooFaNmKamxD+vFDKFqWarHmiKA/8TTIF7oTm9yMmIQ5CmkkhS9DmpD+Ks1OH6RHxrc
         QAnrpe/qGbu2a5NVT3ctnHEoi/iev637WUw6tN5KJdPh37Uhkbe3QuUNp1P4rG2ZXC6L
         v6qJTy6luk6E9DvyMbFMPKYnSZTbnI5VegqybE3of/dK/BW1oA3kWV7PzD0ru5qsOrc/
         Y8zP+IcozZ8xTRx3FKiuJIvREMFwfiBaQ0Rr1r2XjlwF5D3mDvv7tQd/3BOdklnvvZPv
         NFvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770064870; x=1770669670; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2IMh41X3lfsz0vhQymTprdXfmdt4B+CuibsxTGA9cUQ=;
        b=rgGj6aOSvZkNqQHpSH0CvpauW+Er0eKOBGeiWsJZaKnFdNTATmIysIsesnxEfSvBaE
         +AqDrEkTUQrKYDHhZhZP4/KeEmaeIEIaZO+GrdoAd5OrDOkopJMCdN2jEI4+o32baLtl
         JTRyOCr9H7AQ/KrZLW41i6M8wtjPReXqJF4XwZ2bw4D2qZmff51GLiYmqky+rrDPTPGo
         ONw8RboNTqySKij5F/JOxIA5Ez5AAWyobm4fC19/JtXvdvNzDBMNjJIzVuOFZNhjfqNl
         LqJyad4ddfAAo3rChZxc48/J+wihO6j0zc5EEsDH8b9ZckqCCJBLYfnXx4oxTwabnHlE
         PW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770064870; x=1770669670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2IMh41X3lfsz0vhQymTprdXfmdt4B+CuibsxTGA9cUQ=;
        b=DaQSn6wJdgB4Ploro5j8YEk0GUv4CvJU7xG4CI893GRhBnoREKJwqcjNXeCIAk5lEV
         em436Q3XZ+s3+Oz8FPbPWNvekFAyK5yLqzjbV6Y+gPTKDi6/QSKfvaNaYFEV7iFZA6D1
         zOQ0KmAf5m8YOq8YqbWy02+iS6zact0tzQ0rir6xY4CLMQG3gHE3BQYadUEFkO+zECNP
         BGpP7TD3E9Ki2hCEfhzUPN3dainxWSqtNURm+w08VZ54DZtwCxHGfnbGLRjlGPgcM/RN
         ec3DSG+TzldRF/XqSNx0yTKSPVQvGq4nIbDX6PjtUoEfbUAldHcid78xY/NsddmYKr2g
         rlOw==
X-Forwarded-Encrypted: i=1; AJvYcCW3oYutUbOpZpr2uEOAUAHlqicKHvZRS2Mvse7+TfvaOupV6KMkwGrZr13fExp3Y2tuh0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDKzH38VKNX0BKs5AcyicGSlj/H3cwgsK8WBpcaOu0q+fYMUx8
	9w4PtoxyxjO8FkmpDtUiIfDqcIR/sWa5x1N7QbdXdx50ySkdeN3sP7GfftoMD5iTd6bpZbDfDOL
	Ql59HgeJN+LiSoXSevKwKp5cdNXpH4pGdtXgMfzqB
X-Gm-Gg: AZuq6aKNt6KuUUY5j/5iuqN6lIRSCSmSD3H2XdA7mPDn3N6TohhlBw/GnadUGqOlbpj
	0BZxBhjStcw+nVbekzVS+mK471YtSAdlOTqdHlHMJHmYX+YuBi3PyTSNWSUqochXGivXKz0EJ3Q
	aKciULWF4SweOlqL6vQMdqMQVPzKPnZYE0nmNKfMdu/yp4NYMXsKTptof//hSN33H3n8RkP40Zj
	13maCETqSzmm/FDMDiCrK9TEGu96t/+64FiB/Kfwo6dnWgzMn39pv8g19jktTaVdmck/ig3Lfw3
	rxumcg==
X-Received: by 2002:aa7:c3c5:0:b0:658:133d:8eb9 with SMTP id
 4fb4d7f45d1cf-65933dfca2cmr9220a12.2.1770064870080; Mon, 02 Feb 2026 12:41:10
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-4-jmattson@google.com>
 <mcxo54ct7bsu2d6xmalpsae6wq32ykjh6dd4kfgcgru474dqre@47flraln5zz5>
In-Reply-To: <mcxo54ct7bsu2d6xmalpsae6wq32ykjh6dd4kfgcgru474dqre@47flraln5zz5>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 2 Feb 2026 12:40:58 -0800
X-Gm-Features: AZwV_QjDlpKgTWVJhvtudgSKth7iSkip7p3g3HVeq5o303u-FKzAbkVZnMyhL64
Message-ID: <CALMp9eS+s=GM6Kr1Lfrx0S7bM174N0FQ6DepTTVMRnrDij0Ltg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] KVM: x86: nSVM: Add validity check for vmcb12 g_pat
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
	TAGGED_FROM(0.00)[bounces-69908-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E9FC5D13CD
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 5:41=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Jan 15, 2026 at 03:21:42PM -0800, Jim Mattson wrote:
> > Add a validity check for g_pat, so that when nested paging is enabled f=
or
> > vmcb12, an invalid g_pat causes an immediate VMEXIT with exit code
> > VMEXIT_INVALID, as specified in the APM, volume 2: "Nested Paging and
> > VMRUN/VMEXIT."
> >
> > Update the signature of __nested_vmcb_check_save() to include a pointer=
 to
> > a struct vmcb_ctrl_area_cached, since the g_pat validity check depend o=
n
> > the nested paging control bit.
> >
> > Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 07a57a43fc3b..e65291434be9 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -369,7 +369,8 @@ static bool __nested_vmcb_check_controls(struct kvm=
_vcpu *vcpu,
> >
> >  /* Common checks that apply to both L1 and L2 state.  */
> >  static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> > -                                  struct vmcb_save_area_cached *save)
> > +                                  struct vmcb_save_area_cached *save,
> > +                                  struct vmcb_ctrl_area_cached *contro=
l)
> >  {
> >       if (CC(!(save->efer & EFER_SVME)))
> >               return false;
> > @@ -400,6 +401,10 @@ static bool __nested_vmcb_check_save(struct kvm_vc=
pu *vcpu,
> >       if (CC(!kvm_valid_efer(vcpu, save->efer)))
> >               return false;
> >
> > +     if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
> > +            npt_enabled && !kvm_pat_valid(save->g_pat)))
>
> If this lands after "KVM: nSVM: Drop the non-architectural consistency
> check for NP_ENABLE" [1], the npt_enabled check can be dropped, as
> SVM_NESTED_CTL_NP_ENABLE will be cleared if the guest cannot use NPTs.
>
> [1]https://lore.kernel.org/kvm/20260115011312.3675857-16-yosry.ahmed@linu=
x.dev/

I don't see it today, but I will probably forget to keep checking. :)

> > +             return false;
> > +
> >       return true;
> >  }
> >
> > @@ -407,8 +412,9 @@ static bool nested_vmcb_check_save(struct kvm_vcpu =
*vcpu)
> >  {
> >       struct vcpu_svm *svm =3D to_svm(vcpu);
> >       struct vmcb_save_area_cached *save =3D &svm->nested.save;
> > +     struct vmcb_ctrl_area_cached *ctl =3D &svm->nested.ctl;
> >
> > -     return __nested_vmcb_check_save(vcpu, save);
> > +     return __nested_vmcb_check_save(vcpu, save, ctl);
> >  }
> >
> >  static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> > @@ -1892,7 +1898,7 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
> >       if (!(save->cr0 & X86_CR0_PG) ||
> >           !(save->cr0 & X86_CR0_PE) ||
> >           (save->rflags & X86_EFLAGS_VM) ||
> > -         !__nested_vmcb_check_save(vcpu, &save_cached))
> > +         !__nested_vmcb_check_save(vcpu, &save_cached, &ctl_cached))
>
> save_cached here is from vmcb01, but ctl_cached is from vmcb12, right?
> So we're conditioning the PAT validity check on L1's gPAT on NPT being
> enabled for L2 IIUC.
>
> Perhaps we should pass 'bool guest_npt' instead of the cached control
> area?  Then we can just pass npt_enabled here IIUC.

I'm going to cache it on its own to avoid confusion.

> >               goto out_free;
> >
> >
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

