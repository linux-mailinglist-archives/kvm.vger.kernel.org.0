Return-Path: <kvm+bounces-71046-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEX0J/cHj2ltHQEAu9opvQ
	(envelope-from <kvm+bounces-71046-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 12:16:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB6D1359FD
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 12:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B2873111AED
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 11:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5E53542D0;
	Fri, 13 Feb 2026 11:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e9NXA0As"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4E30FF30
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980875; cv=pass; b=CgJx0L31hrF/OnkAO7Fstica6g/4WhJ3FC5QHdmRzuyEXAPh6aRgjc/nzswUvBh2GpcbodbE9YVe3DirHfCBPZM/9TzVHMah2/+Qe0fna5DNIKbMJtSexbP3bPKBfHsJjmiQS4NrQ40Dgpf8r5CyQRMqcHk2oGzsBwzCUrxJU3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980875; c=relaxed/simple;
	bh=S4Ba0KXNuJGSXiTRArril8r2Pr+NJQGRneQ2XA75mB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gc8S6EoeYejOgcscA1G8M1Ps+Xccvwao5DzQARNVUDmQ1ZksNg13dC1licdd9VqIH1UTZDgghkt1J/nbz4wY/FxWFrYi8wR8yG10rC3FhL+K/4NSPYMn1bTayRDGm0QOYMAtjVJcQkJKIO/uW9O0fY/ueF7GJ9d1rZW7PbgvLEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e9NXA0As; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5069a785ed2so343521cf.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 03:07:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770980873; cv=none;
        d=google.com; s=arc-20240605;
        b=ARnLaq3zN7KDm6U8HEnk0XQ6a8OgmpbjS2pnURxhAZLnHRrH9nloWO8VBffziJlANx
         wMVCCFNSwVr9yUYMPVcvjj0vk049/Ee7A2m0cB6bw7xCo8ohIZJA0C1WGa9Go3hM2hBY
         DsXPVflGm+By048Vvcpl4bEsDtbwxGDXhJaKO+wHWza115qn8QnJm0H5Xv2Jc2E1dMR3
         ltoJZUhBHFKiEuKzNt8RMc6Q8BpqDAyQLePnl8rpLwSbxMs6uCburB3krEhgXjDsIbWx
         pLCaNqOd02UevrbQTPnb40IEYn+RXwlqmrQqCgyib9hfDspkNwa/dzdGp56czUhJVZ7D
         00cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        fh=JD+uiVxoRJL1PBwMMYUJvzwyFWq1aVnUmr9P1w6wpCQ=;
        b=bEWmzSg347DJ2wZtI0qYpbpYDfAB9TNFl4+qjyB19Xye8guWd4wAOkcvyb0NZhOvLj
         qm6XCw22dkGKwp8H0sg09P+tGcekjFaF1GLGV6L0+51eIZ/VSUTkyIP1izwd8grxhP+3
         kRLhqXH4PEu1QaHq0GWG3Yk0Lu+lO5TrnEIAoy8TNIcZcOm9H8TUxNJ2wVQoUMLr0bAi
         2lPzTCn3hRCqEfobORYkbR1fgSU+HMBg1gW372Kfxa5xvYKP6syAlHZfXdZkPYWu0jhs
         U8ZVd9mhzLW1tCGyeAAMQfI5IDt0t6kH3K3N2vRsNyJME4pShj9ykaJnJvl6rabb6IUc
         Drtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770980873; x=1771585673; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        b=e9NXA0AsdNmqfk0ZPqV8h1TxMbtS1ZZC/0uN7M7tjvsETSqzDWE0psY2pE+QrfYh8b
         7sNqsRt9QSiOXoBmo9TGrQVNtFt/N6AtGv5WJeBR/ki3yEhpZFuY1fzTKHPRbGVTOYAy
         nXRRw9obe+1652aTANYgeyOEhfpRn3NBWIfWTO6QbeB35IT9Il8fZf3t+dcVIakQXS0z
         JFHKW5wvm9d3u+6reSNCKx1jgKbYzeRFNnVqXiFZ9FxnfUfxvV/VFqxY+wviS1AllEbl
         g2odT9xBgzNe/SkmwaR0M+W1Omn27QQbw8YAG4ANpGJA+n62i3EKTApG1ZdB329BPbYS
         aTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770980873; x=1771585673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhioMr+TlEkKghKMNX83e9mEkIV+C0EY/uR4/Y90u/g=;
        b=L9cf6ZdKC49AVvKTI306k/saeXKcwUTAXKQmtOfhIMtNP/3+D1sQ6ttiTzoF3IwK2C
         NK3Oone2Bjg4QPx7qivBACANxxnjRAHGTbUA0wF9NUrPhbOk57YBZjWjZTpL2gHAy2t9
         fj//j3V/nQw0rFCiNYj96p2f9AdxlZNqEl5tNcoFknEh8ChLGC+TIC50iuZmBxpDqjGS
         WvqWM29oJGqXJDBmMMLZul556c1XFK/SOyecyFgyLq3adljTTg6nikYVp746ramg+nqq
         WanwQlTjOaNyuNSGaPfFXbqcj4tIRtxKwRnHsAgacLClks9XjU7VPjEKbr8gloLLLXKL
         vPPg==
X-Gm-Message-State: AOJu0YxUE/y4EZXRGMbKyB1qw6AlGXSheaWqrGuES2QWt6oxsxJw8aya
	NUwpr4rMjc6Hq1u2hwOYip/oo0djaB9uU9LhN0V154rcWuNq4hEYgTTDJYREcMW/y8lai1WccnE
	dCDXJhDDYlAR1dXnBEweR8nchh+3rSv/OqhwW05es
X-Gm-Gg: AZuq6aLXVbRr4jc+SdNackMATPd1YKWRgH08bC1wvdlOCebhDRdvl+/1H5oREoKOGFk
	8WYaJbOpIC9UFPuSrvrH98k1f3GTZGGQY7V2R8R3CV0FaniHNsvWiBbbklmwnqZPM7JYwK320Gn
	S3UZ03mV1cG7qwigKkki61qp4Q10ylk5tdGiLEVQhmvYRxeLsGwb6XdBKc/ecqyWNGXJpq54hWl
	6V/CznmQNJDEY9V/tu31Ru80pqyNdDGiGWirhv98AnMPpmyQUVftbPOx3e+4q3YjGT8DPDneihM
	y6aE/tcS
X-Received: by 2002:ac8:5794:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-506a8434debmr6596891cf.5.1770980872383; Fri, 13 Feb 2026
 03:07:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com> <20260212090252.158689-3-tabba@google.com>
 <86ecmoc3dk.wl-maz@kernel.org>
In-Reply-To: <86ecmoc3dk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 13 Feb 2026 11:07:16 +0000
X-Gm-Features: AZwV_QgSdg6ZxR7oLi_wuOeoAvMjVYMSeO2-E9Trn8UZX41x8tt3ScmTFjatuKs
Message-ID: <CA+EHjTx1xjPCd0w56YDF42W=-HtKm9DYxUwGPd+2u-zmiSw9CQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] KVM: arm64: Fix ID register initialization for
 non-protected pKVM guests
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-71046-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: DAB6D1359FD
X-Rspamd-Action: no action

On Fri, 13 Feb 2026 at 11:03, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 12 Feb 2026 09:02:51 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > In protected mode, the hypervisor maintains a separate instance of
> > the `kvm` structure for each VM. For non-protected VMs, this structure is
> > initialized from the host's `kvm` state.
> >
> > Currently, `pkvm_init_features_from_host()` copies the
> > `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` flag from the host without the
> > underlying `id_regs` data being initialized. This results in the
> > hypervisor seeing the flag as set while the ID registers remain zeroed.
> >
> > Consequently, `kvm_has_feat()` checks at EL2 fail (return 0) for
> > non-protected VMs. This breaks logic that relies on feature detection,
> > such as `ctxt_has_tcrx()` for TCR2_EL1 support. As a result, certain
> > system registers (e.g., TCR2_EL1, PIR_EL1, POR_EL1) are not
> > saved/restored during the world switch, which could lead to state
> > corruption.
> >
> > Fix this by explicitly copying the ID registers from the host `kvm` to
> > the hypervisor `kvm` for non-protected VMs during vCPU initialization,
> > since we trust the host with its non-protected guests' features. Also
> > ensure `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
> > `pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
> > initialize them and set the flag once done.
> >
> > Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 37 ++++++++++++++++++++++++++++++++--
> >  1 file changed, 35 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 12b2acfbcfd1..267854ed29c8 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -344,6 +344,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >
> >       /* No restrictions for non-protected VMs. */
> >       if (!kvm_vm_is_protected(kvm)) {
> > +             clear_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_arch_flags);
> > +
> >               hyp_vm->kvm.arch.flags = host_arch_flags;
>
> Can't you just have
>
>                 hyp_vm->kvm.arch.flags &= ~BIT_ULL(KVM_ARCH_FLAG_ID_REGS_INITIALIZED);
>
> since there are no atomicity requirements here?

I'll fix this.

> >
> >               bitmap_copy(kvm->arch.vcpu_features,
> > @@ -471,6 +473,36 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
> >       return ret;
> >  }
> >
> > +static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > +     const struct kvm *host_kvm = hyp_vm->host_kvm;
> > +     struct kvm *kvm = &hyp_vm->kvm;
> > +
> > +     if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_kvm->arch.flags))
> > +             return -EINVAL;
> > +
> > +     if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
> > +             return 0;
> > +
> > +     memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
> > +     set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
>
> This looks a bit odd. Can you have another vcpu doing this in
> parallel? You seem to be holding vm_table_lock at this stage, so
> that's probably OK,  but I'd have expected something like:

You're right, it cannot happen in parallel, but another vCPU could
have beaten this one to it.

>
>         if (test_and_set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
>                 return 0;
>
>         memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
>
> which makes the intent slightly clearer.

I agree. I'll fix this too.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

