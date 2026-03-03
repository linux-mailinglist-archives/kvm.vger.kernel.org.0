Return-Path: <kvm+bounces-72613-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAFbCVhZp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72613-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:57:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDDD1F7D2E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:57:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 114C930A87E5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F61372688;
	Tue,  3 Mar 2026 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fk3/BNja"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3793368AA
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574993; cv=pass; b=GXxBgcj+R+U+lGZKCbyAOW70ii8Law01eEvXVjb0j5s5hRm69qcfZ/OLay8s0J2XX0Du1TgopT06QWZHMl4HDqD8f7mOlDTr/QkgNXS1tsOJZlWI44RfUxkeJOOpguuFAUlyiqRWeZiFli9K4cztbARNibZIyMGUtKohaIMwOPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574993; c=relaxed/simple;
	bh=rboHVk+33J7HAdeUHlDmisJX+T3/+AQR79cDfX0htt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uiG4Bp8UZFImcoUQ2+g8qQRe2H97Lf7LgobEWcSPogdp35q993eYgkgwmOMH+zEAPNQLOlKURigFZwiQkMJjYOOB4y6F3PtshSUaMHbcXM6oUd9p2tbmbPDk/9TYlYCfrCFOI64qanetXvSKOt3VfATdPE6A/uKjiFDE0mQhx4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fk3/BNja; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899ee491af3so31772206d6.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:56:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772574991; cv=none;
        d=google.com; s=arc-20240605;
        b=Fi3Zu19hvvAIh8sGyjJ5obYBsjttCNpt0efF4gL/n/+aDvUbblxEy7sJPe1WVKV+nw
         e8cfr22PwO/04+7qgS4C4wEZwqilQv8h0XQbhA/Ca6VAVTLn1CNZbHrX3ZxmfhsfvwGW
         T2VbgU0pHpAMYg+LPUwzulsTjerm5jOg1Ndn8pRoIE2hIAleSb48yYP02iTaPdKOXjLy
         VNJp+9MQ+0K3aK/eme2aVuM/5SfXv8SykKQVxnAbIi/We6LeFPhQZGfmnjjyxCun7Wc6
         YkzXk87XncoLIrdbYRpgpG5qPyybsECGb8grU2zWzDbMb2je4xKC0SAiy/qURgIR1rgB
         52tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yL9ZfF2PiZMMlOEHToQfBb/KFNEINU/ZtZru9/pb3Ao=;
        fh=bkWIprXAypf3Jpu4X/tsnswe1ABvX80rZ2rEtA4QYus=;
        b=Pvj8mGbYgzO/xu/bwufr4Jb6a0EZwq1YYm2pHxXpw+9V8cdRtbVHyt64XoYp3bimXl
         QDpt7hT0M8X8qh4jMoHv+oQ3WeKKG2ADAm1wl8NZ9eqkUqkUjMfCQZycxFRBG6tiWAp4
         3VK7CEh4IAqJdhFCzYU6x+0Bw+IyOleBwgCSvJLat6Iw33aQTyWqzBf7SpiXF2WKcUg6
         hww4UYuxil7ZuiedhyR1//jPuyS1A9JRxqTkcbMj5cP30QBywLrd/VJcSK2NAIjHta/r
         M617Jt8S+0Y5of3lRpQtT4fM5hFRnEyjaNf8GolLbwVunZkyZrNODGuihUJ0/1WwgDnw
         zfjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772574991; x=1773179791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yL9ZfF2PiZMMlOEHToQfBb/KFNEINU/ZtZru9/pb3Ao=;
        b=fk3/BNja0B2y831k7k00ehFnHbcL15qWtsi7+8rznWTud48W6zpp6jXi0ZvaxANpxG
         x3Z6JrUpIZgxthJ+0vFZHtNd4FijZsvcukqedBfIuUbh7yeOWeMAwkSQfp+Y0xEDIrFe
         BN12Qx8XqaJtmhSTvQx92Tc8mTYJ+1tCplxEkn3drzSq9DqBxxM9CEA52k1Wt89RLPGR
         0D9jbzN1QNLlpaXdFuMHcFot+wl8rIcz8A2z39GOusqYCAtqzo3pio9UScEqbfzD7cCo
         sIJHU8OR/08o3UMIuc4GYdBRDbYJkAdSyXS63eeqlfyfeuBhbckA29h+RN8HUmOMRPCD
         dF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772574991; x=1773179791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yL9ZfF2PiZMMlOEHToQfBb/KFNEINU/ZtZru9/pb3Ao=;
        b=dMcj07DUxFmm72lCF9KQJKZn3s3B6lFjK0Tl3F9+83TC2u2RAPSWXgKy32LW3zO6HI
         4VGYvMslbmTU4MugfxBxgAhn55xrD0m+/3KSpUAP3yMzDY6VTjDlvlvVQJQyOe31xKzd
         WVpwVqqW5T44RkrpFsVlPweBHSiWU/9tDv+Y46gFuMVVd0zLp9zW2VUmqcr8DHsY1/L2
         wK2iGQu3iVJWJCB3xBWKThvSaWtdWfNJ7QH0NN5PJm5qUHioZF9VdrtAFKd0YZA75kw+
         oslSqPOrdOsenWTg48KlUJ+eRDsSxgZoKEpNcMcA6wnxTlZclGTGUc0NwYwl4PqIJyu4
         wWmw==
X-Forwarded-Encrypted: i=1; AJvYcCVrtNpL4NIgGM2lMbg6u229UWRKl1vO0dqW71nA7RIsJg8Me6JFrXHeLTKujRz2IBKFScw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqcNKnQmBI2zT5jHN0a9JRwOnSxkU0wqS7hcBX1wvK1YEFe92R
	GPFj216JVIop5WzqzHRWGGNBej/leYZQ2XX9JSeFPgMmRU623SyYSb4IsKuzqrJUWV7OT4lIxp7
	TLelOmN5h5MZVm63lq4AfsbIMTBASoZnWJCJNaFxY
X-Gm-Gg: ATEYQzxPpL1ieRT6/KjHzKgt7WJze5hxajhR8kR2iHdA2ksktJbg9yWStJo6pg/jtoX
	wLmPVKdBoTaFZJr+33Zur7ESJBqz5h2N10cjdMy8gq46b+wUXWtYHpRyrIHJMAHp4O+fO3Dt1Ix
	0MhorPVrB8000qkaXDLqND0TEYvY7KO+rfF3jYwyBIOgxDUk0GjGlKFK0KnHis+nPmh4Fw53IVA
	8TA9jOZw/gNIgWqNjX0HT1aISDNyLm6cG/LeXNJwUYbwIduSh4b5R4SfsaZf0sBEv2f+wtYiwx9
	zOKB+o7Cd0Ynkt+xXXgmoUM5bMDM2wLvLE1tzaDaLw==
X-Received: by 2002:a05:6214:d0a:b0:899:fea9:ccff with SMTP id
 6a1803df08f44-899fea9d39amr120422866d6.55.1772574990865; Tue, 03 Mar 2026
 13:56:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com> <aaYanA9WBSZWjQ8Y@google.com> <aaYssiNf7YrprstZ@google.com>
In-Reply-To: <aaYssiNf7YrprstZ@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Tue, 3 Mar 2026 16:56:19 -0500
X-Gm-Features: AaiRm52FCq8g6_s46Y70AXrEXpz_sxOYyYWda8061I3CPpDn_ZAqDxlH0KeTjLE
Message-ID: <CAE6NW_YTqbMZgq1nEiO6XsuQPZsKd9_0DseFDStocrh-sB1TBw@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ACDDD1F7D2E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72613-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > > On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > > Also taking a step back, I am not really sure what's the right thin=
g
> > > > to do for Intel-compatible guests here. It also seems like even if =
we
> > > > set the intercept, svm_set_gif() will clear the STGI intercept, eve=
n
> > > > on Intel-compatible guests.
> > > >
> > > > Maybe we should leave that can of worms alone, go back to removing
> > > > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > > > svm_recalc_instruction_intercepts() set/clear these intercepts base=
d
> > > > on EFER.SVME alone, irrespective of Intel-compatibility?
> > >
> > > Ya, guest_cpuid_is_intel_compatible() should only be applied to VMLOA=
D/VMSAVE.
> > > KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject #U=
D.  I.e. KVM
> > > is handling (the absoutely absurd) case that FMS reports an Intel CPU=
, but the
> > > guest enables and uses SVM.
> > >
> > >     /*
> > >      * Intercept VMLOAD if the vCPU model is Intel in order to emulat=
e that
> > >      * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that ex=
posing
> > >      * SVM on Intel is bonkers and extremely unlikely to work).
> > >      */
> > >     if (guest_cpuid_is_intel_compatible(vcpu))
> > >             guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> > >
> > > Sorry for not catching this in previous versions.
> >
> > Because I got all kinds of confused trying to recall what was different=
 between
> > v3 and v4, I went ahead and spliced them together.
> >
> > Does the below look right?  If so, I'll formally post just patches 1 an=
d 3 as v5.
> > I'll take 2 and 4 directly from here; I want to switch the ordering any=
ways so
> > that the vgif movement immediately precedes the Recalc "instructions" p=
atch.
>
> Actually, I partially take that back.  I'm going to send a separate v5 fo=
r patch
> 4, as there are additional cleanups that can be done related to Hyper-V s=
tubs.
>

Gotcha, if you're sending just patch 4 as v5, then should I send
patches 1 and 3 (with fixes) as a new series?

> P.S. This is a good example of why bundling unrelated patches into series=
 is
> discouraged.
>

Noted :)

