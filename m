Return-Path: <kvm+bounces-73198-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CGINSd7q2kSdgEAu9opvQ
	(envelope-from <kvm+bounces-73198-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:11:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8521B229435
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9D33304F216
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1192877CF;
	Sat,  7 Mar 2026 01:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCb8OVwW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE319261B9B
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 01:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845791; cv=none; b=LttlEY1311SPQGXZIN9MzIgfGLPuCzcnY6dTBGEaSiusuGVTHc/1AXFgJo8OIJ1x+PLIW1NK+v8G50cIbPgFbqijlJyRRo8fid0lQyEtZD8ShjHUR1Rs2crk8o8vhqUnIE+Ids31WqjG5RoEBsYrJpuCtElDeDfDP+seo7DXMUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845791; c=relaxed/simple;
	bh=3TvYy04KOxe8wRJbdPBcJUmCZB7Dr4IJF8X7Rke1ugc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G+5v6jX7Hb6Asp1ea0gP6uVheEtN264f9PdkSPLKqa7gGqnHC75vm8q+i7rhvAOONETRzaaZeBK8Cg3CQpVB1vnRfXbvLEXCwy4NT0QLD9nNqnjzvPFFnQQR+VUzqSsBYRg8I9AKnt1DWUo545UKGIneaeRvIFrwbcQFrBw+edg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCb8OVwW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E92DC2BCAF
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772845791;
	bh=3TvYy04KOxe8wRJbdPBcJUmCZB7Dr4IJF8X7Rke1ugc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lCb8OVwWRzd1+XLQaM9id24uLxIDcwg9OYxOrxjr3VZ3gpol6M1SGKAN6Pqmmy0UX
	 oCY4ZV5zb0BwZk/Nw1jHRrVhUT9jrAGOjuot+oRZFC+mo2L53/xC5jCaesWWeT8fdz
	 iu4sydQCKZRiEQfh5+koPywzmYmqqFxsb/SMJAwiiRCs1bAw8+kqwtVMC4ApczQbd6
	 a3LC0hGdZWPBzZDIdBF/3S2gpYy63jmMVWvFoD+a7RXL0T5fDl5FphXuGySKhzSr7a
	 9GnRY/WKkE9DJbELF2eOI4u8T0NibuvJbXb6vf5PeE98VL9I550mO7l4EYgLYEYqwa
	 cjGA0fWlB0KRQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b93695f7cdcso1319724366b.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 17:09:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSA9UKAJVuf8qLRrAGP+9QcUwHvVdU8NVAenFdODToOmg6VJGfXo3BpfUwc3WfFB/HhAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzykIo+c83/zB7cxJL43AhKWC8G2jUgZcdD3jyZOhXVSw7b0Ylx
	XM97J5osAEohrgLdn3VvPdov0BEOGxNhUnTgM2PKH95Uu3K5169bTOMVcg36xYSGN3VmtrFIZ/4
	wj6WjLGE6hobcv79+fM8kcYZQbq+GkPg=
X-Received: by 2002:a17:907:844:b0:b94:2913:2d12 with SMTP id
 a640c23a62f3a-b942dce9a8cmr225153566b.17.1772845790249; Fri, 06 Mar 2026
 17:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-5-yosry@kernel.org>
In-Reply-To: <20260306210900.1933788-5-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 17:09:39 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMJw-MGFTiuYbtVfoyA9guYCcA5B4siMttbV5Oka2cs6g@mail.gmail.com>
X-Gm-Features: AaiRm53E1yWUQBvWmAffQN_WTd1m2KpZ6MF5yHaakEe-wgGQkr_7-43743PI4Vg
Message-ID: <CAO9r8zMJw-MGFTiuYbtVfoyA9guYCcA5B4siMttbV5Oka2cs6g@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: nSVM: Fail emulation of VMRUN/VMLOAD/VMSAVE
 if mapping vmcb12 fails
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8521B229435
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73198-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.959];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> KVM currently injects a #GP if mapping vmcb12 fails when emulating
> VMRUN/VMLOAD/VMSAVE. This is not architectural behavior, as #GP should
> only be injected if the physical address is not supported or not aligned
> (which hardware will do before the VMRUN intercept is checked).
>
> Instead, handle it as an emulation failure, similar to how nVMX handles
> failures to read/write guest memory in several emulation paths.
>
> When virtual VMLOAD/VMSAVE is enabled, if vmcb12's GPA is not mapped in
> the NPTs a VMEXIT(#NPF) will be generated, and KVM will install an MMIO
> SPTE and emulate the instruction if there is no corresponding memslot.
> x86_emulate_insn() will return EMULATION_FAILED as VMLOAD/VMSAVE are not
> handled as part of the twobyte_insn cases.
>
> Even though this will also result in an emulation failure, it will only
> result in a straight return to userspace if
> KVM_CAP_EXIT_ON_EMULATION_FAILURE is set. Otherwise, it would inject #UD
> and only exit to userspace if not in guest mode. So the behavior is
> slightly different if virtual VMLOAD/VMSAVE is enabled.
>
> Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---

Nice find from AI bot, we should probably update gp_interception() to
make sure we reinject a #GP if the address exceeds MAXPHYADDR.
Something like:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5362443f4bbce..1c52d6d59c480 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2320,7 +2320,8 @@ static int gp_interception(struct kvm_vcpu *vcpu)
                                EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
        } else {
                /* All SVM instructions expect page aligned RAX */
-               if (svm->vmcb->save.rax & ~PAGE_MASK)
+               if (svm->vmcb->save.rax & ~PAGE_MASK ||
+                   svm->vmcb->save.rax & rsvd_bits(cpuid_maxphyaddr(vcpu),=
 63))
                        goto reinject;

                return emulate_svm_instr(vcpu, opcode);

