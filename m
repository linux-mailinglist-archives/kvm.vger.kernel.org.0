Return-Path: <kvm+bounces-73179-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QA/wED9cq2mmcQEAu9opvQ
	(envelope-from <kvm+bounces-73179-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:59:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D63D228731
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2619309D18E
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D150C36164E;
	Fri,  6 Mar 2026 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uq/ZbNnE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1F435F17D
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837849; cv=pass; b=aEOCXZMcsN5z0im3RruU+y42V0hLXE7OqYxzaGLHk9Gu7FGdliC+QPZcH3RY5D4vWKweuQ+Riu/vgIq+Y8c+2B+lIqeBQ/gi+/b2K3uodDp7rYsNwkaASE9fztBYHui4pmrym80nc8PDTta0VZ1jFTyoOH0oU4yvpnS8ipIdAOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837849; c=relaxed/simple;
	bh=FzKxRoFe+O3x866jR4IL7oWd8DCSmKCIbdeUtgY9HDo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N12rQ1IF8I9KCrhTPY6Hssepg9t/bQvDWArB9TuCysaBOxt4oyFJ81ovKSA6E+tHNXyHDIB5vQdw9iF5Lnf9S5mMLvFbDOC3HlrCCy8DPz2oJ2wbS844o9DTRy0Rphn5V0HIN+ZEPvsXY1PvsNks/P9fPEbWwRaSsoApAeoRiDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uq/ZbNnE; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-660a4aa2aa9so4086a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:57:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772837846; cv=none;
        d=google.com; s=arc-20240605;
        b=k2+6GoY9jq2Hbd1TCTzKHcXJg1qy16pFitkav3BWRVaXs3FA5tcjCNfMaaMzynnd1L
         sd5eKI/+VyzRR2JoVm78oLlK04cbaH/BNa5FQ8vBl4sDAajW3OF6cHV8QS+n1bcG7IRV
         0HHDNeUFQIHU1NE6bWrwzNnY7kipaDgsZ8DMogzycN6kILdDqYtGUynpUQqMlr3tVN3Y
         4YVc6g/uulsmI9DRNNuhNl8ARen20CH34sxiqhNSqPivyKrJfd5fFSTkfnIlM7AG61vw
         EPbsFxJB8M619kN2hHPnEHeMiypc32us1+daZ39kYBf3/wfonhCz2Qf8kiiRwQaaNvv5
         fMGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7JLHQqr7nUq5BIg5QljzF5p4yIg29yC4wfnbT9pWH/A=;
        fh=iDKA+wPs92BilgOuVHBKv84nyUc+mxz4bjNiBc77ats=;
        b=ka80/2gnguDF3gGXIL03uAUL9g50moCi8hzLWgtm5CB2ezK5igHa0+A5duV07poULe
         03LVNyuX3qElF1LE17ydDrxSdAuQqYLfo1CFigSKJypKpbkaycZWsnq2hegmI/Wlhfnd
         Sv77WKD+rT4e/gf6GWCb61zGX8JoBvUV6t5hAziETq4lkJ495QrFvRN+xbuoS3Adigh9
         X0OuyoPWchpR5O0fQUACXWQFYsQKm5dNMP4WNB1LwDUamwSsW+mQ7P9HCATbEm1RodBQ
         WvvW3swTYpQpEUazs9avSRwcZHCCPxuppofDGohuyvkMtzyLslUVYmrvNY5o4SzvrJcL
         ilYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772837846; x=1773442646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JLHQqr7nUq5BIg5QljzF5p4yIg29yC4wfnbT9pWH/A=;
        b=Uq/ZbNnEsBgGBzLLzkdDMkXYbyKzeBgKbSsb8kYUNPte7ml0NJsfimj7bauR1buysB
         NpkQ7eo5BavAXwDPX+P46xu7lWHvEi5KrHz4mMFKJMGTKvnhUxMdlO/x0v23+QxeBdm1
         Jq+s8r66zDihTzbuxzHS3NjnfUyXPvtg4cVV5TcasGjb1iwuZyEL5mAuobgCMHDqrSn0
         DKxF4j6g1J5rPhjVqQ9PvEapTEc3bPGYNXtrKbeL8/nUBU4/+fB5NHg2g18iqiNa1Wkc
         bHGuuitq1BdMmNH4x/b1kOq/8M1pf5QZ87fGb19XfOWIS86iwLZ3iwc8HvWJ5dxrbRB6
         6NMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772837846; x=1773442646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7JLHQqr7nUq5BIg5QljzF5p4yIg29yC4wfnbT9pWH/A=;
        b=JdgWyQhqZh65dHbskgN4NEkc71BXRVJS7y2xDniMUMLqUIl1P8Fij+8uf7OEcktOcB
         Zwu+dyJZJidqzlcqaqmSlJ9o7VxcNZNN1oTeznOnB4Rc5hwe/SAFPldyGxNNXPkHyjtB
         UWYUGPX70i6W6igeE3aMFTmT0Sfmaf6Xlaw++HjVinCOmF3NlZfiQw7lDJFO5qCNQT1a
         lanDalwuxrLFvEL4zsCVpfvxPW66ZIISiBJ/dwzwLuYgaavcEb61mxNiZiO1JK5Fnp5R
         W50SL3EF4QdNM5UzcfpllTLHOID254WHclAa88ADa1mbNzBPa7xH2v4mIfBRhhpB8Kks
         zGAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjMOPv1TqH9R+5NKDBZyQ1yInL+wjNfLDDAcA7rh9kENOJIcsJLo1RVzF75N06dySPTUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvURFlAQqZ5Vlt6qAC1gg4nXKSueCVYISepNYN9anBMqNFT5ki
	QrNVH0P55NXV/wsaApvpTbATSGUt6wZInYnsNIt26e2wDs/qj7KxHQa+F71ahFF8+oNy2v2WfFt
	gCwljbBJzmiOmlO2qxW2AYRBRkdUhZHKrClZ6Kz/i
X-Gm-Gg: ATEYQzz3xKEuiu+xfIigVEp7F8kv9imk7xVzOmr7g2U/HxzWXC2gavXjkHuwQ5DTB4p
	4Dh79cNNaAtptAla4Bdm3f+42ddglXUqBVJdG6cul3Ic3UyG1AeAYoYliOvkLXpvVx/n+3v9RcH
	xCAjQniWQz9SvDcMrfnSykYuW87i9Q32ybDSOSHNtlK4TI/nAQq/IxsuLPrDualJObnPE6vY7pr
	j56dZmgoY42q0iSsQxTWns7LK24uuxR0q4pwCLlqbr5o5WVFXSPJN2dMWV2bU3zR5aT9XliJhXS
	XBBWwL0ZlUSd4npqsQ==
X-Received: by 2002:aa7:c745:0:b0:660:a516:7805 with SMTP id
 4fb4d7f45d1cf-661e8178a1amr11826a12.16.1772837845693; Fri, 06 Mar 2026
 14:57:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com> <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
 <20260306223225.l2beapz3nvmqefou@desk>
In-Reply-To: <20260306223225.l2beapz3nvmqefou@desk>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 14:57:13 -0800
X-Gm-Features: AaiRm53R7eaC9FlHo41DPd7GAkS73u3GcL9WnwydQ1loIzStZyE04rOI32i-SdQ
Message-ID: <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D63D228731
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73179-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.953];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 2:32=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Mar 06, 2026 at 01:00:15PM -0800, Jim Mattson wrote:
> > On Wed, Nov 19, 2025 at 10:19=E2=80=AFPM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > As a mitigation for BHI, clear_bhb_loop() executes branches that over=
writes
> > > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > > sequence is not sufficient because it doesn't clear enough entries. T=
his
> > > was not an issue because these CPUs have a hardware control (BHI_DIS_=
S)
> > > that mitigates BHI in kernel.
> > >
> > > BHI variant of VMSCAPE requires isolating branch history between gues=
ts and
> > > userspace. Note that there is no equivalent hardware control for user=
space.
> > > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > > should execute sufficient number of branches to clear a larger BHB.
> > >
> > > Dynamically set the loop count of clear_bhb_loop() such that it is
> > > effective on newer CPUs too. Use the hardware control enumeration
> > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> >
> > I didn't speak up earlier, because I have always considered the change
> > in MAXPHYADDR from ICX to SPR a hard barrier for virtual machines
> > masquerading as a different platform. Sadly, I am now losing that
> > battle. :(
> >
> > If a heterogeneous migration pool includes hosts with and without
> > BHI_CTRL, then BHI_CTRL cannot be advertised to a guest, because it is
> > not possible to emulate BHI_DIS_S on a host that doesn't have it.
> > Hence, one cannot derive the size of the BHB from the existence of
> > this feature bit.
>
> As far as VMSCAPE mitigation is concerned, mitigation is done by the host
> so enumeration of BHI_CTRL is not a problem. The issue that you are
> refering to exists with or without this patch.

The hypervisor *should* set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
behalf when BHI_CTRL is not advertised to the guest. However, this
doesn't actually happen today. KVM does not support the tertiary
processor-based VM-execution controls bit 7 (virtualize
IA32_SPEC_CTRL), and KVM cedes the IA32_SPEC_CTRL MSR to the guest on
the first non-zero write.

> I suppose your point is in the context of Native BHI mitigation for the
> guests.

Specific vulnerabilities aside, my point is that one cannot infer
anything about the underlying hardware from the presence or absence of
BHI_CTRL in a VM.

> > I think we need an explicit CPUID bit that a hypervisor can set to
> > indicate that the underlying hardware might be SPR or later.
>
> Something similar was attempted via virtual-MSRs in the below series:
>
> [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPOR=
T
> https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@intel.com/
>
> Do you think a rework of this approach would help?

No, I think that whole idea is ill-conceived.  As I said above, the
hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
behalf when BHI_CTRL is not advertised to the guest. I don't see any
value in predicating this mitigation on guest usage of the short BHB
clearing sequence. Just do it.

