Return-Path: <kvm+bounces-73089-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGQIJSf6qmmcZAEAu9opvQ
	(envelope-from <kvm+bounces-73089-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:00:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C39224733
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9EE73025D1D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E391341AB6;
	Fri,  6 Mar 2026 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBmnr84U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC403E7148
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812346; cv=none; b=IJcMHL8rUTjpvR1TOdxDngc1m2vZeRlXcE42eIDtAC0FQ9eRiA5IaRysEmckIt/H11CA0Le3jWhPyWMZGrISag6Va/C89ZoSJzmhlcl8gWujRq/Ki0iOOmQUOtE2DiwLADAvHoQnF9/bERzJtYnzUW69KZiQla88p0x/DsI9FeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812346; c=relaxed/simple;
	bh=wX4Jbp9e36703xKLKZdMY1ynrULtCAJCp8wgNk//eT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S1lW8kdSpip+EvYdyIEcpmKi8HnObb7bvDQZqmyIzBUKgwLMKMTHNUEPZGwJq+dxxVKzeM12RQdigWlaCjpqFjJpQffh1kTjCdojpf7DFFP8VnrtsIu1aLFv2HiJthc09iI8g/8kBZxmwGgbSYUUlPvjqU0TjFE31x/dHjayKbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBmnr84U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D667CC2BC87
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812345;
	bh=wX4Jbp9e36703xKLKZdMY1ynrULtCAJCp8wgNk//eT4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dBmnr84UHD3s2+C8v/zyP1NMnVLdeLsp5vkub7TOxWDBYcYLUM7YaTGcIWNALvGzK
	 6CozVg4sWmXuDeVUC4XIjulAgb8344j5n69evSgCJr6N539HLvopqrlznLt8jvVGnc
	 lbnoedInNXaWCfuj7agJdtpUU8UZdXxhil34qKjL4ZYcXrVq8A0u9XKwa5o127zhQD
	 KkAJSjDlqL5TBbKKItjTtv8XJui1xkQDtYS+nO49kzQmqgNSWP5FfMEW9+xTw/kE9S
	 VH1s6fjdpfym4HwhM+AP42WFM0bK3D0fw+nmzUCZplTeOC2Yuu6ORH0i0B4tS2A+LX
	 jeLY7+tzQKfKg==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so789531a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 07:52:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWz3fqmATLS2WzXpJiVrMg8G5qW6gyC43tPane5VTOAkKu24QJyo1sLK1xJkiLevwPdALU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx093BJfK/k7aFx5sz08rPU1TrNObufahThlMZjb9ua5u6iFrqE
	TTnvDxbehrjeyotK2i/Jg/ptO4h3j/AiORRUblQmgPnxDaYNr/g/7EgULM/YRVSYmWq4WfkR5n1
	2M9/acnFHPWk5jZ2p3212vK66/v32G7s=
X-Received: by 2002:a17:907:728e:b0:b87:965:907a with SMTP id
 a640c23a62f3a-b942df7851fmr157705166b.32.1772812344691; Fri, 06 Mar 2026
 07:52:24 -0800 (PST)
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
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com> <aaowUfyt7tu8g5fr@google.com>
In-Reply-To: <aaowUfyt7tu8g5fr@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 07:52:13 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
X-Gm-Features: AaiRm52ESuNzXExyTm8Nv83X1g9niX6DbKPcJhhYn60jz-Cq16Nz84_3Gcr6Fo8
Message-ID: <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 42C39224733
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73089-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.955];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

> > > It also does the same thing for VMSAVE/VMLOAD, which seems to also not
> > > be architectural. This would be more annoying to handle correctly
> > > because we'll need to copy all 1's to the relevant fields in vmcb12 or
> > > vmcb01.
> >
> > Or just exit to userspace with
> > KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. I think on the
> > VMX side, this sort of thing goes through kvm_handle_memory_failure().
>
> Yep, I think this is the correct fixup:

Looks good, I was going to say ignore the series @
https://lore.kernel.org/kvm/20260305203005.1021335-1-yosry@kernel.org/,
because I will incorporate the fix in it after patch 1 (the cleanup),
and patch 2 will need to be redone such that the test checks for
KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. But then I
stumbled upon the VMSAVE/VMLOAD behavior and the #GP I was observing
with vls=1 (see cover letter).

So I dug a bit deeper. Turns out with vls=1, if the GPA is supported
but not mapped, VMLOAD will generate a #NPF, and because there is no
slot KVM will install an MMIO SPTE and emulate the instruction. The
emulator will end up calling check_svme_pa() -> emulate_gp(). I didn't
catch this initially because I was tracing kvm_queue_exception_e() and
didn't get any hits, but I can see the call to
inject_emulated_exception() with #GP so probably the compiler just
inlines it.

Anyway, we'll also need to update the emulator. Perhaps just return
X86EMUL_UNHANDLEABLE from check_svme_pa() instead of injecting #GP,
although I don't think this will always end up returning to userspace
with
KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. Looking at
handle_emulation_failure(), we'll only immediately exit to userspace
if KVM_CAP_EXIT_ON_EMULATION_FAILURE is set (because EMULTYPE_SKIP
won't be set). Otherwise we'll inject a #UD, and only exit to
userspace if the VMSAVE/VMLOAD came from L1.

Not sure if that's good enough or if we need to augment the emulator
somehow (e.g. new return value that always exits to userspace? Or
allow EMULTYPE_SKIP x86_emulate_insn() -> check_perm() to change the
emulation type to add EMULTYPE_SKIP?

