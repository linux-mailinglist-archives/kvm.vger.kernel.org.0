Return-Path: <kvm+bounces-73150-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OOXCPQUq2lzZwEAu9opvQ
	(envelope-from <kvm+bounces-73150-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:55:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 892E32267E1
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61ACF305A95D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA53141C0A9;
	Fri,  6 Mar 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGWswoaj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1633C3AA1B4
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772819671; cv=none; b=f8euLIoXMo1laWhxodR1hCPO9ISqVLbUHmoghkVpiawpypb+5zofo98HmYmL8pWi3pf/9i/tgDhQizFYWthKg+x3MO3gFMkSTf77XAssCGgSyX5WKrxea1Dp3waIlAVY/YuJG4FKssXmOdfYQydKjq5x+ZUqG442TNxfpwGR0hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772819671; c=relaxed/simple;
	bh=CQVqnhsG1eX+PM6p8vp2A4o5bXKP7GX61nvxGyY+aMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j5vcMe2b9HBSRAFaKTp7Eh8zB5E0Qp+1LCybKkm+KFLsqm6ZrOVkUoWGCX/rVMNoM42BAU4P5eN7sejASQ67WMdQ+VaRNvpNQHspYStGBOKenbft2km+/QYTzBD00JgDlPaHP9QOz7mJywTkXIBfQ3Aq5bbgGD+xYrWYRilZmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGWswoaj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E99C4AF09
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772819670;
	bh=CQVqnhsG1eX+PM6p8vp2A4o5bXKP7GX61nvxGyY+aMk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QGWswoajZpVCcz/dTM+Q+PLTRUD8dVYOzndlArCZBGLXDCcpxmhghfzeN0RpdFE6F
	 7RDznaILlXYKzLQrgKGfzgCnwrIynu6FyjQ8f+IJxm0rC986WhmYqXzqzo0WvWZHwh
	 93/dUbiXqCl6g9fZ4p/c2v51gf9C6lmmwuBP3WXEP7YSvBxwwJq87Iqi6wsQxBmwNt
	 THLZVTSWq6vHcPp3u8EWvy+JDiWmD8/HTCtV/DwS/UkXGxoFIeoqK0Zl8c1AdhfRSi
	 fqQVxYoJuhG0MEs2a9UXWNoSMbwwV5Rje5nkIx5aGmCCptIZ5/kwbijcId4/BgKhRi
	 p9SAuH/3neLYw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b942b36de08so136643966b.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 09:54:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUxOii2K2UyXZapj3RK3CH9riD5PNnSBJhtjLAkRxaXVhUwAJbibZjQB/O5Gk9hd4xA+5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOiAntR1ChjlZtDtg1Lm8d9GXMj30nJIPD4xwPd2XZWaa6fNQA
	Rup+x96hxubCqV5nWFVaHYXNSbGxbLUxTPygDiKuWvF+DSDQp8ZJedgMZtSpls7A6kHe4mdSQe2
	Me/iiaIGwQFZWSbUKX6uNxNbS8rs1yKo=
X-Received: by 2002:a17:907:94c9:b0:b8f:d2a0:c283 with SMTP id
 a640c23a62f3a-b942cf16e99mr181750466b.1.1772819669440; Fri, 06 Mar 2026
 09:54:29 -0800 (PST)
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
 <aaowUfyt7tu8g5fr@google.com> <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
In-Reply-To: <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 09:54:18 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOV-4Nx7rZxHy8XsK3_X-enGm==Unj1NiiaaM2EuxK2WQ@mail.gmail.com>
X-Gm-Features: AaiRm51ovvWU7wOz02KJPYDdf-iUZNPdOYmHCJPOEKiiF_L23TVsu9HxYp31chE
Message-ID: <CAO9r8zOV-4Nx7rZxHy8XsK3_X-enGm==Unj1NiiaaM2EuxK2WQ@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 892E32267E1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73150-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.957];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 7:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > > > It also does the same thing for VMSAVE/VMLOAD, which seems to also =
not
> > > > be architectural. This would be more annoying to handle correctly
> > > > because we'll need to copy all 1's to the relevant fields in vmcb12=
 or
> > > > vmcb01.
> > >
> > > Or just exit to userspace with
> > > KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. I think on the
> > > VMX side, this sort of thing goes through kvm_handle_memory_failure()=
.
> >
> > Yep, I think this is the correct fixup:
>
> Looks good, I was going to say ignore the series @
> https://lore.kernel.org/kvm/20260305203005.1021335-1-yosry@kernel.org/,
> because I will incorporate the fix in it after patch 1 (the cleanup),
> and patch 2 will need to be redone such that the test checks for
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. But then I
> stumbled upon the VMSAVE/VMLOAD behavior and the #GP I was observing
> with vls=3D1 (see cover letter).
>
> So I dug a bit deeper. Turns out with vls=3D1, if the GPA is supported
> but not mapped, VMLOAD will generate a #NPF, and because there is no
> slot KVM will install an MMIO SPTE and emulate the instruction. The
> emulator will end up calling check_svme_pa() -> emulate_gp(). I didn't
> catch this initially because I was tracing kvm_queue_exception_e() and
> didn't get any hits, but I can see the call to
> inject_emulated_exception() with #GP so probably the compiler just
> inlines it.
>
> Anyway, we'll also need to update the emulator. Perhaps just return
> X86EMUL_UNHANDLEABLE from check_svme_pa() instead of injecting #GP,

Actually, not quite. check_svme_pa() should keep injecting #GP, but
based on checking rax against kvm_host.maxphyaddr instead of the
hardcoded 0xffff000000000000ULL value. The address my test is using is
0xffffffffff000, which is a legal address on Turin (52 bit phyaddr),
but check_svme_pa() thinks it isn't and injects #GP. I think if that
is fixed, check_svme_pa() will succeed, and then emulation will fail
anyway because it's not implemented. So that seems like a separate
bug.

But then if the address is below maxphyaddr and the EFER.SVME check
succeeds, I think we should return X86EMUL_UNHANDLEABLE? I cannot
immediately tell if this will organically happen in x86_emulate_insn()
after check_svme_pa() returns.

The rest of what I said stands.

> although I don't think this will always end up returning to userspace
> with
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. Looking at
> handle_emulation_failure(), we'll only immediately exit to userspace
> if KVM_CAP_EXIT_ON_EMULATION_FAILURE is set (because EMULTYPE_SKIP
> won't be set). Otherwise we'll inject a #UD, and only exit to
> userspace if the VMSAVE/VMLOAD came from L1.
>
> Not sure if that's good enough or if we need to augment the emulator
> somehow (e.g. new return value that always exits to userspace? Or
> allow EMULTYPE_SKIP x86_emulate_insn() -> check_perm() to change the
> emulation type to add EMULTYPE_SKIP?

On Fri, Mar 6, 2026 at 7:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > > > It also does the same thing for VMSAVE/VMLOAD, which seems to also =
not
> > > > be architectural. This would be more annoying to handle correctly
> > > > because we'll need to copy all 1's to the relevant fields in vmcb12=
 or
> > > > vmcb01.
> > >
> > > Or just exit to userspace with
> > > KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. I think on the
> > > VMX side, this sort of thing goes through kvm_handle_memory_failure()=
.
> >
> > Yep, I think this is the correct fixup:
>
> Looks good, I was going to say ignore the series @
> https://lore.kernel.org/kvm/20260305203005.1021335-1-yosry@kernel.org/,
> because I will incorporate the fix in it after patch 1 (the cleanup),
> and patch 2 will need to be redone such that the test checks for
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. But then I
> stumbled upon the VMSAVE/VMLOAD behavior and the #GP I was observing
> with vls=3D1 (see cover letter).
>
> So I dug a bit deeper. Turns out with vls=3D1, if the GPA is supported
> but not mapped, VMLOAD will generate a #NPF, and because there is no
> slot KVM will install an MMIO SPTE and emulate the instruction. The
> emulator will end up calling check_svme_pa() -> emulate_gp(). I didn't
> catch this initially because I was tracing kvm_queue_exception_e() and
> didn't get any hits, but I can see the call to
> inject_emulated_exception() with #GP so probably the compiler just
> inlines it.
>
> Anyway, we'll also need to update the emulator. Perhaps just return
> X86EMUL_UNHANDLEABLE from check_svme_pa() instead of injecting #GP,
> although I don't think this will always end up returning to userspace
> with
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. Looking at
> handle_emulation_failure(), we'll only immediately exit to userspace
> if KVM_CAP_EXIT_ON_EMULATION_FAILURE is set (because EMULTYPE_SKIP
> won't be set). Otherwise we'll inject a #UD, and only exit to
> userspace if the VMSAVE/VMLOAD came from L1.
>
> Not sure if that's good enough or if we need to augment the emulator
> somehow (e.g. new return value that always exits to userspace? Or
> allow EMULTYPE_SKIP x86_emulate_insn() -> check_perm() to change the
> emulation type to add EMULTYPE_SKIP?

