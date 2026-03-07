Return-Path: <kvm+bounces-73199-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEF2BbZ7q2kSdgEAu9opvQ
	(envelope-from <kvm+bounces-73199-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:13:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 822942294A2
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDBB1314AB10
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C13B28640C;
	Sat,  7 Mar 2026 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wrcHaSgV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC4C2877CF
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772845838; cv=pass; b=kQ76m4hH6voqT7ptBCwVMdmgFvox2WGA56yMJsnkKhfdm4PJt5ezSujyJ4a2qLWE8+3FJDsEBSsTb154wO0kbTU16C96jqlckej3zA8DSqQ3G/Lg7fc5kYalTRF6NgXgpfA/1NjX5Ep6b0GoiD3eXkiYFlyRfSno8VXwbBhNjto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772845838; c=relaxed/simple;
	bh=yIMcXKwgZDyFvs8IYiesrCfabRBnenrpEZ7PHSfPNE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DTOuU1aflQaIzYykuljLrDjCcjXW9izvlyJCp8fJEMm9rUC4AtvUng30wxN7AEHWk4axIecpa5HhoC2PoD31+v6TKsv8lGQzoJodLCWahu7j8YIdlAOI3r8LfT97xNQ7wtxYzHYgRK5XC8lP6hsXsV7TX/wWeClIvfhvgVhlcLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wrcHaSgV; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-660a4aa2aa9so4716a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 17:10:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772845836; cv=none;
        d=google.com; s=arc-20240605;
        b=iyEz9wP7pBBwuTzqLX/3uhYEKr0S6LL3KqTMZp72GC/kXOnFkgcES891ghaMcugPzQ
         2XYn9P3Pi/DIqDfKHy5Db1xUcqAx8Lhl1O5dZHvT6XwOzWMTuNsb2smQ2Ua0IditAPmt
         Jmk8NI5cjoRAOsE7nAjPrfx/FtGweL9GxWL4yRzQz8hT7SD0HbLR81KzarsSeCEP+YMZ
         mxUqDIYtoHpK2LM66ViS1KvfP5xhLvVuUC1QcceeNT+HpMGCP8XpByjGIMAlZKhct4Pl
         gIuvE8ZT9AxYnVa/+3T+X7+Kerbjd4Sjfcg9QXOFbqG99Ui2uray2zSzKql62d5G1fy0
         o83Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ppqlJiZMxYeI7bKV6A/WJ2q2ooZdl1nY70i+0bB/Mm8=;
        fh=smGuO6sj1wAbfV1qwBed4WbpOK4lqkUkiqp16IlxO7I=;
        b=a1UkEjDglzvD3k0TNjT0Wql4RcUpzqPXeb7KG+/VDyJ8xdmI5OzGvXlPPbJspA648d
         ZksbKei6ymprRwI7qwQ5sNqf7HnE9rqKsCwYE68GY3aFbSphoQV/3x7JNdkptUiO2dMw
         /BWXDZWzw7lAqOfXlKC04oMsvRPBcZYQgvP1RrnGotAUKZQpzI0aBF93MAEq0gOcXGtm
         JeYi5NGzB4wlG1xeFgNnUyd+luMNvWR2uDnaHVUz06bP86BwU3fTmPx/w9B4QA6Ugp20
         a/YEafWxfzbPmEarFPg1eI3KGC+Qu6Au2/PMO/dAGnPnsWAe+FpKzRL0BtbKxLO6bVdi
         Z1xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772845836; x=1773450636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppqlJiZMxYeI7bKV6A/WJ2q2ooZdl1nY70i+0bB/Mm8=;
        b=wrcHaSgVUUefRqXPXgYyBpic2lrEc/O/M0ynO7awLSeJVxhiR8FYTzXtpTpqP/I8fU
         b5U+n1vv5cUmsduNUpRMKJuu7ylfDaD1FFnNKtsVH1r47uyL/hXFLVzViEXxP9x14jsI
         awtBHYgRhiOEMwj3MlL9CnOtutY1hW86GnjzHQ2j68UmgA6BDKB4z3d6VuDWtEh9FxW4
         FPmV3pGX1fE5TnaVi3Pr0Q1YLAfAuVg2kZWNERnt58YdeeFEVFaGVYWk9IrlY05dIann
         H/T/1qclFoWGBVB+0vWrorbjaASPGX9pbWeyTN5eBX3Nqa7qLUK9hB+GfieJnFSTFWMf
         7h6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772845836; x=1773450636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ppqlJiZMxYeI7bKV6A/WJ2q2ooZdl1nY70i+0bB/Mm8=;
        b=kPIVYOWVoWOhw4PWICa1LRzjd5fk6b1QIfcdimCfsS6Zg5pak9uQZM7p489BfNGjP4
         YJIS8vAwityZaN+2tQUlTZXc/ClxntdCIy5NZ1KFSqFwkteAzDEz5QcXjqqn2VG7IZWi
         bk1FbzUFxDbZG/Ox0AQ14b9cegsr15hRkVs/Ww5XJq6bvw18rhaf8H0Goxgd4Ve7W3Bx
         nqKFy83bAdRMeGIG8V2L5q2MS/JJPKvXpjmNF5J7QuLKo/2svYcXMAMGCGO/riOiTtRe
         7u5HAHwliAJIkf8RRlILEamp64cRsYUi0n1/i32hB9bZnSqbTqm61/1wgtlHLDVvsVG4
         MNVg==
X-Forwarded-Encrypted: i=1; AJvYcCV0L8P22jtLp4S3GUMPaozzTXB3cinGWkVtRYiaMEqeMqmW8yQZN4Nj6VOA7Kk0SYGGYRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyRfXPIj6eGCDhnjJVYpqsDirx6OCsR0xINcRseiO0J7SJ3n/A
	EvIyoQXxGGmzKGxMh/KtI4uUwXWGByzfSI70rQtLR8PLNo73nqfXXf1dVy/aG/B0Qt0WwELYKg2
	HA4mEmKGFVGT/GUlKoSqJgpaEM407ajObJOcCyPPO
X-Gm-Gg: ATEYQzyDF/8ZOMwaBq+oM0oYxM2nsw9f7gw7noR5CTiXXSCgWXD3UZY7PwIkpAFcyhU
	m1vFksZPiziDeyunkEJ4wIEI9u3ChL1+/3WWdrZ3/Ei25sFGhjSyoIAf+Ky1Wg9JYbA7WfkQEKK
	NR+LzJvrX6/h/VJmYQPyAZrBgWP+tC4n8j96tKxjz9lLI74Ti8JcvyLwid5z4D4oZvJaEpQlGvV
	dfd57ibMd0Kfk0E6on0sQGLTTZcUBrAGfrmOEr7UOtwSFQtqcmrAK2bnDE31Jgrt01pIm/7Wbtk
	GZB5hQOeNeE8RQntaw==
X-Received: by 2002:a05:6402:514b:b0:65f:7099:bc8c with SMTP id
 4fb4d7f45d1cf-661e7d9e77bmr10935a12.8.1772845835277; Fri, 06 Mar 2026
 17:10:35 -0800 (PST)
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
 <20260307010051.u4ugg3nyvsu6hwbg@desk>
In-Reply-To: <20260307010051.u4ugg3nyvsu6hwbg@desk>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 17:10:23 -0800
X-Gm-Features: AaiRm53zKbqs8IocTQ06Vi4Ubf88QjJrl5zpTvGnHqPhGTo3L9Qw6xgqDLUF9xE
Message-ID: <CALMp9eQGZcekQ3QtL=J7TqHJ9YfZ+SbrgY5P8fp14p4KNThYmw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 822942294A2
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
	TAGGED_FROM(0.00)[bounces-73199-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.958];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 5:01=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> +Chao
>
> On Fri, Mar 06, 2026 at 04:35:49PM -0800, Jim Mattson wrote:
> > > > > > I think we need an explicit CPUID bit that a hypervisor can set=
 to
> > > > > > indicate that the underlying hardware might be SPR or later.
> > > > >
> > > > > Something similar was attempted via virtual-MSRs in the below ser=
ies:
> > > > >
> > > > > [RFC PATCH v3 09/10] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_=
S_SUPPORT
> > > > > https://lore.kernel.org/lkml/20240410143446.797262-10-chao.gao@in=
tel.com/
> > > > >
> > > > > Do you think a rework of this approach would help?
> > > >
> > > > No, I think that whole idea is ill-conceived.  As I said above, the
> > > > hypervisor should just set IA32_SPEC_CTRL.BHI_DIS_S on the guest's
> > > > behalf when BHI_CTRL is not advertised to the guest. I don't see an=
y
> > > > value in predicating this mitigation on guest usage of the short BH=
B
> > > > clearing sequence. Just do it.
> > >
> > > There are cases where this would be detrimental:
> > >
> > > 1. A guest disabling the mitigation in favor of performance.
> > > 2. A guest deploying the long SW sequence would suffer from two mitig=
ations
> > >    for the same vulnerability.
> >
> > The guest is already getting a performance boost from the newer
> > microarchitecture, so I think this argument is moot.
>
> For a Linux guest this is mostly true. IIRC, there is atleast one major
> non-Linux OS that suffers heavily from BHI_DIS_S.

Presumably, this guest OS wants to deploy the long sequence (if it may
run on SPR and later) and doesn't want BHI_DIS_S foisted on it. I
don't recall that negotiation being possible with
MSR_VIRTUAL_MITIGATION_CTRL.

