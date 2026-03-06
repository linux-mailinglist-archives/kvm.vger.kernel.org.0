Return-Path: <kvm+bounces-73149-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yK8/NMIQq2kRZwEAu9opvQ
	(envelope-from <kvm+bounces-73149-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:37:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 393422264F9
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B9D131B49B3
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113A736C9E8;
	Fri,  6 Mar 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJu332WI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207A344DA4
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 17:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817927; cv=none; b=aZx7NlcQ+vw7mqy6UmOC00Evzx4B+/M/QauJYXDpDgSXGMqR+Ex9Mic3a4Ks7WA7Y3uNRP4MAolXk+KvPCvkKBnPFg1QFLGzhn43yFysyPcyCKvdjWbbwA8wvNOQyxnNixYKH7fNR0PRMFrHvVjaBu6QSJD6TdsPG9fAArUDdCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817927; c=relaxed/simple;
	bh=LULkRiIKOZJCvpEe0JHTfEpBuIQyQFeKljvtmWTwXj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbUkkWqHTKc1JvGQVxsh1ylSGHgc/5qKEjsoqgesCKsGYuWLQvpOKoEI9H1JHmtOdI7pBf1+7uk9TCsLweiS65l+VwlMiDRiKimiquXfaw02GuMu5bE9e8DzKtu41l9tOoXtQA1PNhsAS/rVdtoTBhk/l006e+7VnRww2aorxyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJu332WI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC70C19425
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817927;
	bh=LULkRiIKOZJCvpEe0JHTfEpBuIQyQFeKljvtmWTwXj8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gJu332WIjumaaoVH2dgvKk/ci/y9U7dRGevlfgUkw0p1np90G496FVceiPhfgJfns
	 f3ccDzKZ6ERI0DrZqOkGMFBo5JgDonrJJ0lqghaRQJxDIKq4MiwI3ltvOhQZ/RRgXl
	 5+uhpeppgfGp9VkOvtiaDM0iyfkc0ky8ZBrhUJyP+UE09pLMj6i6TzP76ETZr+fWx6
	 e0Ls2/cnMJZ9zzZ04aLEJwejAHgwaohd8QwYPbJIkrSsum6bCdMir/L9tqtHuwEkJY
	 KB+z0mWSAPDW84Va8giymme1NAObX6xg9/v6RA4e64hwvuaVaKPvj1uqe66O/CbKN7
	 jj36yi62JEbxA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b94146682d8so299550966b.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 09:25:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVOcyhjJINMF4at97Afh/Y9WUBxoBqWW6Bnz6zN+ijSPt4/x5pWbM3Zngn3bpFtxI9KfLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNJSZ4XoxFaANP9ZfohFGYJq0qV+cM/TruxwdwrgwjhavUmvio
	JuW+Op7C0UFPR05v/ouUb+QKJcFIMbhG0F1s2W8LfmAM7Qfe4iIkPK1RJMF0UyZZlEpUcMGYpod
	4ajIpW+anTuTY14Qdeh+nxOTFCjKjtKk=
X-Received: by 2002:a17:907:a0c8:b0:b87:3168:2cb9 with SMTP id
 a640c23a62f3a-b942df7e8d8mr195816666b.32.1772817925844; Fri, 06 Mar 2026
 09:25:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
 <aaowUfyt7tu8g5fr@google.com> <CAO9r8zP0qkjkEMYMc=sW+k+f+HGQMzh0H_Y0u3BeqqcraGYWcA@mail.gmail.com>
 <aasCR-YNNkoT4axo@google.com>
In-Reply-To: <aasCR-YNNkoT4axo@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 09:25:14 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP0HBd5rt4shoWo5ULd6_=fznPWSHTFuW-NH-h9WSep1g@mail.gmail.com>
X-Gm-Features: AaiRm51E6bkxUomqHkwz7UxcOUoZ4AZngQJrZYpIxIwqH2wvjKEs3om7ek-wHyM
Message-ID: <CAO9r8zP0HBd5rt4shoWo5ULd6_=fznPWSHTFuW-NH-h9WSep1g@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 393422264F9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73149-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.954];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 8:35=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Mar 06, 2026, Yosry Ahmed wrote:
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index b191c6cab57d..78a542c6ddf1 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1105,10 +1105,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > >
> > >         vmcb12_gpa =3D svm->vmcb->save.rax;
> > >         err =3D nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
> > > -       if (err =3D=3D -EFAULT) {
> > > -               kvm_inject_gp(vcpu, 0);
> > > -               return 1;
> > > -       }
> > > +       if (err =3D=3D -EFAULT)
> > > +               return kvm_handle_memory_failure(vcpu, X86EMUL_UNHAND=
LEABLE, NULL);
> >
> > Why not call kvm_prepare_emulation_failure_exit() directly?
>
> Mostly because my mental coin-flip came up heads.  But it's also one less=
 line
> of code, woot woot!
>
> > Is the premise that kvm_handle_memory_failure() might evolve to do more
> > things for emulation failures that are specifically caused by memory
> > failures, other than potentially injecting an exception?
>
> Yeah, more or less.  I doubt kvm_handle_memory_failure() will ever actual=
ly evolve
> into anything more sophisticated, but at the very least, using
> kvm_handle_memory_failure() documents _why_ KVM can't handle emulation.

Yeah I agree with this too.

>
> On second thought, I think using X86EMUL_IO_NEEDED would be more appropri=
ate.
> The memremap() is only reachable if allow_unsafe_mappings is enabled, and=
 so for
> a "default" configuration, failure can only occur on:
>
>         if (is_error_noslot_pfn(map->pfn))
>                 return -EINVAL;
>
> Which doesn't _guarantee_ that emulated I/O is required, but we're defini=
tely
> beyond splitting hairs at that point.

