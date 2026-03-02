Return-Path: <kvm+bounces-72443-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJzyAS0fpmkDKwAAu9opvQ
	(envelope-from <kvm+bounces-72443-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:37:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D30C11E6B85
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2A61E30080B6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E96733D4FE;
	Mon,  2 Mar 2026 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXD10vZC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51212D592C
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772494615; cv=none; b=t5dxBbrIorD5KuoSggVbE8od/FlsV6h+GEIAWNEcXkHPqReDrRg/w/vCQKHAYPdtM/wH49mS4+Xlqq8l8lGKt/JZsAcRwK3PFBWbRjTIgOYl46vLtAiQX+fV2Y4+gxtm1DGnOFHmZMCAyD3UIvu5SlnZBWyQW3VnIa0eaInl9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772494615; c=relaxed/simple;
	bh=RIh46aKXqH8m9feKRZzfWkJHaJQBpvp9DXVobA4WVbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xsro8e1BiwEfVb25aoBibGz1na0UK2pgYxgiUwjcSW2KeOZ0Rn5wwwvRih2F4GXWFuAumBCWZwqv1zlgpjJOZqvKJJXDsF+YqoIDPntqkXuUDPw3FArgCG8bRu0ZEGq3/HUvi/yaQrychg5R13kUZfl/LZm0RELvHCQOyfMkqjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXD10vZC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD16C19423
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 23:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772494615;
	bh=RIh46aKXqH8m9feKRZzfWkJHaJQBpvp9DXVobA4WVbc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SXD10vZCs4GpFJAOBf7JAjdvk9SAIbWmSCFb4aWx959RJiU/Html9y+bctmcFqDNm
	 UUYSLSkVHHUmi1UWW0hbvBW1Sr+59mN54J/e2UHkqicjqAOsfij5qkRRDmpFo/JOs8
	 aoaIS32Af4BdvtD83T1Y9gDPNjnQE9rM1WhqyQ35xBDYS6zw9lC7qyhhO3MEUkDGep
	 4Q6ZsTaQQ531O1hmKHTs0s9hZHWbKVXjngaikD2jqE5livl4ARqjxfoZPFlC+MjWFa
	 U3lGwX8EiN7N65fV3ZzKme/XspvGIS9A9gnPgwIUDroRNCOapdwSsSILiY4qq18FFM
	 CGLyrlQCwRYXA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65a43a512b0so5723591a12.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 15:36:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU1EEug9rz87gyVkr0bRpOA0ksCT2Emwbfzga1/XbkeM8fSO26RzmX3/nEJYUZGE/zMyP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzamosqQhYsEJO2I9OwA6xuCRlkbPEWLeQoGYGWxjq85A/iEkRR
	QobkQjT5EfQVqkkbvcOwjMgq0JYKF0JBLMrIY5UKReRvqJpRb0R+Cfm/c/SG1nYOAx08sS7U+I3
	M08S8BKt+WTZDhGkT4mccZdwF4tIM34I=
X-Received: by 2002:a17:907:3c94:b0:b8e:d162:2404 with SMTP id
 a640c23a62f3a-b937639ba42mr903123566b.15.1772494614310; Mon, 02 Mar 2026
 15:36:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com> <aaHHg2-lcpvkejB8@google.com>
 <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com>
 <aaHf9Lxx8ap_3DRI@google.com> <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
 <aaYbx59lQf5beYSv@google.com>
In-Reply-To: <aaYbx59lQf5beYSv@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 15:36:42 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOKUv+FiTN8tKu0dP3x_FiH2xMJBSw5XaJ7=hRmZo+oJw@mail.gmail.com>
X-Gm-Features: AaiRm53x17xg_pWp-r18u63otxmgvoNpw2AFncGIC1DeAiBMKkos0EjuPTxkzTA
Message-ID: <CAO9r8zOKUv+FiTN8tKu0dP3x_FiH2xMJBSw5XaJ7=hRmZo+oJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D30C11E6B85
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72443-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 3:22=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > > > That being said, I hate nested_run_in_progress. It's too close to
> > > > nested_run_pending and I am pretty sure they will be mixed up.
> > >
> > > Agreed, though the fact that name is _too_ close means that, aside fr=
om the
> > > potential for disaster (minor detail), it's accurate.
> > >
> > > One thought is to hide nested_run_in_progress beyond a KConfig, so th=
at attempts
> > > to use it for anything but the sanity check(s) would fail the build. =
 I don't
> > > really want to create yet another KVM_PROVE_xxx though, but unlike KV=
M_PROVE_MMU,
> > > I think we want to this enabled in production.
> > >
> > > I'll chew on this a bit...
> >
> > Maybe (if we go this direction) name it very explicitly
> > warn_on_nested_exception if it's only intended to be used for the
> > sanity checks?
>
> It's not just about exceptions though.  That's the case that has caused a=
 rash
> of recent problems, but the rule isn't specific to exceptions, it's very =
broadly
> Thou Shalt Not Cancel VMRUN.
>
> I think that's where there's some disconnect.  We can't make the nested_r=
un_pending
> warnings go away by adding more sanity checks, and I am dead set against =
removing
> those warnings.
>
> Aha!  Idea.  What if we turn nested_run_pending into a u8, and use a magi=
c value
> of '2' to indicate that userspace gained control of the CPU since nested_=
run_pending
> was set, and then only WARN on nested_run_pending=3D=3D1?  That way we do=
n't have to
> come up with a new name, and there's zero chance of nested_run_pending an=
d something
> like nested_run_in_progress getting out of sync.

Yeah this should work, the only thing I would change is using macros
instead of 1 and 2 for readability.

