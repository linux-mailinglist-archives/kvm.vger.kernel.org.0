Return-Path: <kvm+bounces-73223-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJP/MRyyq2mSfgEAu9opvQ
	(envelope-from <kvm+bounces-73223-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 06:05:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEE422A2E9
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 06:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E22D1304527D
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 05:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A78735A925;
	Sat,  7 Mar 2026 05:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cgCLjTY7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C955369980
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772859923; cv=pass; b=ljgc2VblMH/8ziRRJ+FJoxCw6Aka9UW9zMdKR7ivio+wk2cN7lLDIaeUY0933E28NLvIqGhA+GaA8hsnmZO9KvLuJxj4B0WBJ+zAnDHDD/HpbWyUPpYdpxGlb0xSlKrpzP+CkatXQM64EDk8wGKiMFEJlV6GASxPjlSMXFJMqMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772859923; c=relaxed/simple;
	bh=m+5jDdjhfe9gygaw5cmNN+U9gLqfe9mm1ny9+3sGnkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JFeKesKP9zNNBtC8NxvSzV2e2LBpDbkN/vgQNIpyYZCAaL+eVEOxp5i72nlu3ERllK/bm/L1BtFg41NNtXYVyQFjiahgqwsLCQLJmLkmHVr6u1wD73dKn2BfFTHTsVsT0jfIhz6c9XMWIQnR0FcPhAZNEEVoxgdkh/flEs1aMEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cgCLjTY7; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so2544a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 21:05:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772859915; cv=none;
        d=google.com; s=arc-20240605;
        b=eoDQ5YAV6VC1V0EIy56LpdQrZXbMhUBRnzFX2ewpqeaLfVF5wd6OnpubsmD0qrUxof
         +lKnp/mj62gRBH9nuY9FbU2oVKzwnBzCVqNJQn3PjdQrsik9VqfM12Ld3A0bdoZv26os
         qkMVp3z1ylJFlg5v6FXS9Y9nM4Q96tjCDI5BnROBmxFp37HaLmLk+zzbibdypdLUDF3p
         HXkCezQpP0eO9XzfH8y3qNAgWHpcsCaYN1NFoJE6CaqeRVG/k+s0dNVtczNTWExUPIvI
         GlOoFDP9GQNf7GvG5eWJ2CHD3gRr7/yRuonQQPZxGdX0q7vSSU/p20W0n1u0/E548c0t
         HHzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FzZnqBz8H2Ikf67ooR80zhf5Zwa0E0u4JK0MciwOL38=;
        fh=+bfcKFq+/OQVtzrCBpcAyMlL2mqd/Z/pm2kLkprpBiA=;
        b=LcvvCYGnoTdKupeAdJXgKbS6ZbDy2WJLVSMrTljRkRrd/vz+DuNFecBF6AGLG5+xjT
         PjxOYmUM7d5e/HOEAlMHgfxUaAy+2u+8bkMsXkM8WnK2E7vy+yEnHwcZDHOSkiB/emwd
         8ctXWqZYKPul4q3G5jafPNC5472OxPxWNqB2U4ehakRKbs05T1Hbg0ew1NtMtqJQO9PD
         VGIKhCPbPmRl6NmYa3XygTtTHB6LgagRmiQF/ovNORz6aSMijM7/OOKHStLbF0r/H0el
         +EHgCaZ/i6q8vnRipmY3UrRkvQop7A92vWpW8XPdpJWDSyw879Eab5D/1/QfBAwcYvnb
         CYsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772859915; x=1773464715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzZnqBz8H2Ikf67ooR80zhf5Zwa0E0u4JK0MciwOL38=;
        b=cgCLjTY7S7CFy3wtO4JOfrx/i5ewtsik1AhkKEjlbo3yrf1jw2gTeKJP3KqEM2XmX6
         X5ZUl+sehe7bO/t1wfSQK+FKmsPSKkzSnLZi9sWVqRH7BzDFEY1ob3KLqzRnPfP7iLs4
         vSYbd4nd5dWnztX7yRT7NQ2f+lNNhpmF51yLtwrYYwTdbLnAX9Ap3PGA4668lj2ESnRL
         gX/G8C0unQLHHIH6y3OOiGn0pmbwKeVGdy7rOSpVTeseCmZ4RxRlB/baoRnJakN80vv4
         TKP/kwd8wwYLk7DlJSWKUc2XNuxWS5a7/BaoLTjVSIrZYYbWofju1H/O+Hz2ytPCmEBh
         psEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772859915; x=1773464715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzZnqBz8H2Ikf67ooR80zhf5Zwa0E0u4JK0MciwOL38=;
        b=MfXvSiLnHH8quzvzvrChIC4VFoQTD+lbAIhElNMGKN12SiKL5KVeFsTvaenzfsOgV1
         wj+O1br4ADeNochITZGVxdz5tkRII7xoiR2fjn48difGaXOUYxROvkk95VrAlZotFnmq
         wJqGRRdr45CVKkSK7i8jWUSGOUnjMcmwCmhq3hCPlwEckWIhQI2urubzdg3dY8HyYxTD
         nun0wPYL8A5CDrveMjV/qXCQCF1H1T64ZG6Gxue8xW9gdT+l2kXkvw01/2ZBwjbgdMYB
         ONw6JumC3Ef1aJh7x/G1JQx8dUztk0VFOEFJH175635TgssVrpw0Nf7fofmILmAZGXQc
         5fEA==
X-Forwarded-Encrypted: i=1; AJvYcCWuJvd/XLoUOdxpLQPNPQT5ysLei0ia2MXFaz6vjdw2vy73Syxv5yk6OlU9s6ksTY2pFOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3mpANZCqfsC61WYmyVWImLdcWKSHFtW5rjGjkgmT/MWQMemVm
	rm8rcZxCAD98o+dBVUIXSVPKUYp4HlTVVoVtcPMOpDsLoxsfeexvJ/rgleIy2cx/Sq4P26bU+a3
	khQhmpQ8GqjufcyCR94cfjjNcEulAa1DnzJSM+Hha
X-Gm-Gg: ATEYQzzjEeOui7tXjsb5ZYQ+Z86O/4RROlB737JPUHclL43CNcRia4qejPSKrqJGt5T
	4tMDJV/LaMAs73hIUl4yjiTH51h2SBQhmTABRqjDm37sAeGjEFbo3urwKKEhBWRkSHjlymYSaDr
	VYalvmL5jSLoX3KCVKSgUbyuPqTyc9DRvTbWJOZDJaKHbewPjSMyhgjVOK9F8aMNCzXyrx4+/9P
	L7Dxk1CFvI4fOmg3nQPave5a5RrPoj9Xf1a6XkYTfOLHLliUXofmATwzzskELqvY25knuZ4cDU0
	E3FAbBw=
X-Received: by 2002:aa7:d997:0:b0:64b:2faa:d4e8 with SMTP id
 4fb4d7f45d1cf-661f54be61cmr10231a12.1.1772859914257; Fri, 06 Mar 2026
 21:05:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com> <CALMp9eQNBZsJNdfCVwbJ4v1DgCNqRV3DVcEeCPFt=dd29+qy-A@mail.gmail.com>
 <20260306223225.l2beapz3nvmqefou@desk> <CALMp9eQoE13d1cqD3PNJtvdKUGZeVm1g-9TWh+M+MJj_sm9CzA@mail.gmail.com>
 <20260306232920.dja5n7cngrsyj6tk@desk> <CALMp9eSoNaifKyppbjJjNx1YEw9KFv0LGAJ6xD-ko0zJnNXEbw@mail.gmail.com>
 <20260307010051.u4ugg3nyvsu6hwbg@desk> <CALMp9eQGZcekQ3QtL=J7TqHJ9YfZ+SbrgY5P8fp14p4KNThYmw@mail.gmail.com>
 <20260307024132.wleqtpovzd6wtvm7@desk>
In-Reply-To: <20260307024132.wleqtpovzd6wtvm7@desk>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 21:05:01 -0800
X-Gm-Features: AaiRm53KBRRe1-ojBI7-Ba8xmHnOvDB52LWWCjTuNBfS3IU6Sl_b4qSl6f-zxIY
Message-ID: <CALMp9eTO0irFX9sZaVU84r1aW5E7Q2B3bE8uWfgViSug6Hx+og@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>, David Dunn <daviddunn@google.com>, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FEE422A2E9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73223-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.949];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 6:41=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Fri, Mar 06, 2026 at 05:10:23PM -0800, Jim Mattson wrote:
> > On Fri, Mar 6, 2026 at 5:01=E2=80=AFPM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > +Chao
> > >
> > > On Fri, Mar 06, 2026 at 04:35:49PM -0800, Jim Mattson wrote:
> > > > > > > > I think we need an explicit CPUID bit that a hypervisor can=
 set to
> > > > > > > > indicate that the underlying hardware might be SPR or later=
.
> > > > > > >
> > > > > > > Something similar was attempted via virtual-MSRs in the below=
 series:
> > > > > > >
> > > > > > > [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_=
SEQ_S_SUPPORT
> > > > > > > https://lore.kernel.org/lkml/20240410143446.797262-10-chao.ga=
o@intel.com/
> > > > > > >
> > > > > > > Do you think a rework of this approach would help?
> > > > > >
> > > > > > No, I think that whole idea is ill-conceived.  As I said above,=
 the
> > > > > > hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the gues=
t's
> > > > > > behalf when BHI_CTRL is not advertised to the guest. I don't se=
e any
> > > > > > value in predicating this mitigation on guest usage of the shor=
t BHB
> > > > > > clearing sequence. Just do it.
> > > > >
> > > > > There are cases where this would be detrimental:
> > > > >
> > > > > 1. A guest disabling the mitigation in favor of performance.
> > > > > 2. A guest deploying the long SW sequence would suffer from two m=
itigations
> > > > >    for the same vulnerability.
> > > >
> > > > The guest is already getting a performance boost from the newer
> > > > microarchitecture, so I think this argument is moot.
> > >
> > > For a Linux guest this is mostly true. IIRC, there is atleast one maj=
or
> > > non-Linux OS that suffers heavily from BHI_DIS_S.
> >
> > Presumably, this guest OS wants to deploy the long sequence (if it may
> > run on SPR and later) and doesn't want BHI_DIS_S foisted on it. I
> > don't recall that negotiation being possible with
> > MSR_VIRTUAL_MITIGATION_CTRL.
>
> Patch 4/10 of that series is about BHI_DIS_S negotiation. A guest had to
> set MITI_CTRL_BHB_CLEAR_SEQ_S_USED to indicate that it isn't aware of the
> BHI_DIS_S control and is using the short sequence (ya, there is nothing
> about the long sequence). When KVM sees this bit set, it deploys BHI_DIS_=
S
> for that guest.
>
> x86/bugs: Use Virtual MSRs to request BHI_DIS_S
> https://lore.kernel.org/lkml/20240410143446.797262-5-chao.gao@intel.com/

Ah. I see now. I missed this part of the specification: "Guest OSes
that are using long or TSX sequences can optionally clear
BHB_CLEAR_SEQ_S_USED bit in order to communicate this to the VMM."

Maybe this would be less confusing if BHB_CLEAR_SEQ_S_USED were named
more clearly. Perhaps something like "SET_BHI_DIS_S_FOR_ME"?

Is it reasonable to assume that without the presence of BHI_CTRL, the
non-Linux OS we've been discussing will (ironically) only use the long
sequence if the hypervisor advertises BHB_CLEAR_SEQ_S_SUPPORT? That
is, without BHB_CLEAR_SEQ_S_SUPPORT, does it assume the short sequence
is adequate?

