Return-Path: <kvm+bounces-71276-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIJULKEslmmNbwIAu9opvQ
	(envelope-from <kvm+bounces-71276-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:18:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5222C159D1A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1D49B3007BA3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA0632B984;
	Wed, 18 Feb 2026 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g61NIoxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DCD30F943
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 21:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771449499; cv=pass; b=Buczugg9MuvNIP/HKfVvDi79JU6Bl9UKftc+7D8R/1KYtgkWLe3AsruKQ94iXY9I78fIUfzXS/MOHqFSGgiEI+g0lpAYBaL08T/u3wXTvcgOwzL3DqWAguSwNdIOc676sZyTbM9qVTLB4ydaqgHqdefF+7Mvre+B9NgyFyTKSec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771449499; c=relaxed/simple;
	bh=5cLwRqYxV6p9+NMROAjhUeJBi41cRmDUq1ZyY3bDzD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pE11ES5QjBzJ1ANQCBh3hwQq4ZGr7a+/DlE31baq/NRWfOcUy1otLokduqOy6K95lxmAFpB2D8MOwW5rRZJYnS/M3hjGJUeQNCMpEt55+cGnQMnyjmYU8br9JhVCg2n4WbNo0DyvAkCrryegFehtjwtQCZ3GDsXWQxy5bAuTD/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g61NIoxg; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-94b07fddecbso195090241.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 13:18:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771449497; cv=none;
        d=google.com; s=arc-20240605;
        b=EtR5equfPQXs1yQe2Va1VVihoV5TRfI+6EWdCd0m3s/F/+ScDBEI1ln5ghdBal8ztg
         o1eG3wOVs5iNB68Yojz9EASBGsigQYzy7tBFJYhOriN8djY36vi2tBsQeNn7D2mEqTDg
         eXkFBXNqTZ2/5Ay496UV9ZOFdKOZ1UvvfMzNvc7bVEfbe92xw0hh7aXyqeP5ydbXsI0A
         +FOtlZww6dBeTbG7OHeAklUsx/lb9H8Q4xWOtJ8J2MjanXwQPE++bvvVqXGDSqSeLA2x
         +eX/ni5FLljsSe+4F3bT/k3p1JtLfn/J6/Yp8Sv88mVu4hrGMXHoiIMbFCR3PqIQLcsc
         BY3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        fh=7hYRJ5RhTdri8EkCcKhqgM/p+6sUJmLt+yNOUTadZak=;
        b=YY9c+gfaiCn4hvFRuvU6mTXheb0WS4sBMPVY8gJFop3aXNnV8MvZCsxyYoHIi0lCpP
         SOy6oH+QIymAAn3lc4eTefATGOo37KzZ6YcaH8FhbkMk3Ect6Ui90c3uLBQ5++zzJgFT
         frrfaEIVHj1W4sXiA4ky9/URiyXIz7j+UhDRoxhbiStyohbBu0xmSxMO0y/+HydFTBj+
         unRvzAfjk3E6eL4d+1pvNvEHjm2bMted/Mn8rtgWo3rcSApHsZMXPb5NsBbcvKXSrY//
         tHD5Rj1cS3jttK2UXJAqlUJQBAf8HNQ8gHCU0JBOgztwfFBTs+M+ZfnJJu3z94Ky+j8A
         O3sQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771449497; x=1772054297; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        b=g61NIoxg4/WrKx/jw46vLF4q4RrYV7MjodgUiBuB/LLku8en3YqDxR6jTKEaA3VcE4
         jQO6i83BOqhPgEFOu8bwJ0qVijl6YODJgxtYaxz2LvaEfudVk68yFS1RLfTHasiMoztA
         CcKkFYp5vOWBaUlOny9HlO7WapQgPEgIyhy50lRHIbnNwnOKxnbblISfMBGTyVKPyaB4
         K3aJX6BniE9SjXl8B5pgzzkoZMTrg7+xMyReksdGNgbjAXxiQ7IqGVEYlKl8TD+iW/+k
         YbRupAU0PPFvIM9KiarnzSPNw+Myf0U93xOPiRGpGIid73SlxaR6Wu7+ZCSv25TwxiJ7
         UhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771449497; x=1772054297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        b=FaR1D4soz0FtI/VFboA+kF0qxNRt7B3Wm6+f96+r9a2TfbuliuDjc5WM5yuy4JWxD8
         sjqvI2fc3HzNoEQBW6dE8GaGRomAFIYTsz9nlIzDNw0NztyEtZtRDbdBg80F0Fs/bjUS
         W7+h0Gxh6f7sMLv1oWqQXh95SXxbHUxrYngctTLl0Hz4LqI5sQ+16bxPpgWnYaKi/rDk
         +/2JMuedKlqc9iAXPbLvxhECgzE7BDRzEzhmddyepIUezahq6Q1iIe1ofixoPCC0fgFq
         v1hVyRVC9kjbXnzFfPq/xhDqONFDUV1AnwpieubTM5HFgXHn2zOqklWIK5L0RkUaTPEl
         4SVA==
X-Forwarded-Encrypted: i=1; AJvYcCVxniJjFUjYNLPhQLXM/0tsbdFZo3PdCYl25T+uwGZaNoi/kGcfIohS9kWlm6V2oS8WBOE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMzg4mAsP1BSh25EobTTRUSkwWchMjfzLunn6Wdp/5HYUTTsaC
	m/I19MUDpSUerpN9dZd8Zj5Pg7wHUo1QQMlD5WbYGZMiPNZxo/HFjjU5dlzrNg2zrvc8/+IkNBe
	AWDLZoCHVvtueBkde7wZpt1fv0NWpWFewYpVtWuC/
X-Gm-Gg: AZuq6aJhl+o+hqyDc4y0E6EUZvbUq21D6PAaQtiAIhH13AuSgaszW6Q+obgigVUyH88
	ZZd+tkv18IJcXjvReZ1mJeSVNl5jfFCeDghBbUI2USDWUQGArOWXLKNC9tZd6bTL/S469I7jKDk
	NLrGSCfK3H50yH8Cyos96ZefbIn8HLGkVpndxTFeljcVoHc7lJH+Ttqt1aO3RVrVgz5k57jLyk2
	P7ce0twJLHW5Z4t7gzsJzk2bS4jImjUAKEy6hQ7rrQ+aI6l65Q3oS+c4kTFNX8664SWtum/gVIc
	9RpunsI=
X-Received: by 2002:a05:6102:32cd:b0:5db:efcb:72 with SMTP id
 ada2fe7eead31-5fe2ad39b83mr6208741137.6.1771449497123; Wed, 18 Feb 2026
 13:18:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
 <aRZ9SQ_G2lsmXtur@google.com> <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
 <aZYpv6O15YMlGkzT@google.com>
In-Reply-To: <aZYpv6O15YMlGkzT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 18 Feb 2026 13:17:48 -0800
X-Gm-Features: AaiRm50oQAsne8PMukHk2_Ehws0mlHrvXf3-klwm2DNfi8keZfRuu7miCV2uiLE
Message-ID: <CALzav=cc9y2sp66QRwv=DCpb1j8fNjLWbsiqDVK9UE4e2kthzQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71276-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,linux.dev,arm.com,huawei.com,brainfault.org,atishpatra.org,sifive.com,dabbelt.com,eecs.berkeley.edu,ghiti.fr,linux.ibm.com,ventanamicro.com,intel.com,google.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5222C159D1A
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 1:06=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Dec 03, 2025, David Matlack wrote:
> > On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > My slowness is largely because I'm not sure how to land/approach this=
.  I'm 100%
> > > in favor of the renames, it's the timing and coordination I'm unsure =
of.
> > >
> > > In hindsight, it probably would have best to squeeze it into 6.18, so=
 at least
> > > the most recent LTS wouldn't generate conflicts all over the place.  =
The next
> > > best option would probably be to spin a new version, bribe Paolo to a=
pply it at
> > > the end of the next merge window, and tag the whole thing for stable@=
 (maybe
> > > limited to 6.18+?) to minimize downstream pain.
> >
> > With LPC coming up I won't have cycles to post a new version before
> > the 6.19 merge window closes.
> >
> > I'm tempted to say let's just wait for the next LTS release and merge
> > it in then. This is low priorit, so I'm fine with waiting.
>
> I ran this by Paolo in last week's PUCK, and he's in favor of the renames=
 (or at
> least, is a-ok with us doing it).  If you can prep a new version in the n=
ext week
> or so, we can get it applied for 7.1 shortly after the merge window close=
s.

Will do. I'll try to have it out by next week. Thanks!

