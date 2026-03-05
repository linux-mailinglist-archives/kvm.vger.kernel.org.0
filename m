Return-Path: <kvm+bounces-72829-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGvUDUmoqWmbBwEAu9opvQ
	(envelope-from <kvm+bounces-72829-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:59:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA98215045
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A36C30C7EFD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4CF3A7F70;
	Thu,  5 Mar 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Czm0Phi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1653CB2EA
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726175; cv=pass; b=U4dXO+qhsNGm9JH9x6W551KIQpSjPgMh+bZDGeRgpbigeXP3agMb+HbXHyM72MI66D+CuOiDl0lUXrQS1Op7mlclim/4I4KuMtLoHTzqspkM+jcasOznTkldiImXGCvkriAFx5bPIYdSPT3xeflpS53WKexgIiQFwZUPQcl845M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726175; c=relaxed/simple;
	bh=8/He003bwLnsz3pqmNbbjqwfmJwHV9I05RtqhCGve7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7wNwXm3jueXzBhYM+2SWpuRro/hdHgEqzBoZ4jHxs4JXjuU97BK4MlLUbv06fA9tHLY1s8U1A3JXPtwQR/NiBASAcRXGCNh2AeKJc2zd67bCR1dJC5eIc6YKmtr/UWqICyUoqgknY36ZljwwGYS9RtRnO/e1e4S+A1d7WMJj+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Czm0Phi; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5069a785ed2so502841cf.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 07:56:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772726171; cv=none;
        d=google.com; s=arc-20240605;
        b=FpxAjsV5qp7GtDdRmviZlp2BGv5lhsx88LXBApmw8UREin9+CSxY00qxdK1JJBroXi
         a6yyQYPZ0dJzxMSTZOWFOjAKIzJHQHOJ0/SBWgUzN663WgS9WqOdTUkvVck3UAbP9Op1
         EFnnWDSYgRqKUdjBRg+V5p4aq/I0SOTAEbYiREQek7Htmu4awewO0bicZOXPx6BabkRa
         P7qK+RDQzpqENxDqHRl8MwbdYp35TuYhYZyxQe6DQOlgKoKoz/hVsldD9ygUwQ1ED2Uu
         ZyRyRyq+pjnwFLvJb8YBqjSnOVXeCdNeXdOE7XNthmVHxnDlSB9HehMEwfAHGUVVVimj
         13BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        fh=hRRXCTveeYFA3B1dYydMzthjs4zemQL/IO2RU08KSmo=;
        b=OUXn6KTyzMaovcEi+YUFnaRDRat3cs92tTWYupuTsndoQ6FZY1V6KqVxl2v1Qrb4kh
         VWzYvAIb7NnDpjHLBX2RGPWtbkxjtwJo4s7PEEMu3peVgmVXKV4dOk+EMtiWbhFcu1RB
         W+J0m4haaEdLwQjWdmdJHN+jyNl119jTDOiMqIngSqVsRybii7rTbBjHuv55aM8ZA/GM
         FWl227Gj+aZ9+75tGi+3cK6tTUhLOAgjDvkrbZlNzJ3RsrZS6Vt8ryjYlFWNEOQ1P13S
         boHOhg7zmOfJkP2j42JF1ps3wuVyEonCfAQY9J4xMOeacJtUcGBSWHXHq8JDgh8Su6jg
         4M5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772726171; x=1773330971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        b=0Czm0Phi/rqNNg51/pA1GTCajBphnBv5oPmkvxVAQIkQ7332K7OE+lhgTXXhK9GUvH
         niVGyUtXr2dg6TgsXIwBgV/npwCuDd+9vU14PIVRqX2DBwjYhKhFl8eSrmG10xpAqP58
         /eObO6v4khVkZN6s9dbL97OJhjK9nk0RDLsGdpeGJdU19PdmVWkIKKotGM0Bb9E5dOB5
         vbldsYeqP4QCvK7/tx8rmVeL0hO5Kij3SyOc8euLTBKx2qsXqk1pBHc94HJ4+Vq9nCeY
         1PAWpywrbpLV+HOLWJ7bCk0opINQmxpePnYSSOY3i/QN0z/mzZssI6x19vcE0u+IhAvG
         KqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772726171; x=1773330971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        b=o6EZS9wBQ+WcygYaytFwTfV2jfD2mfTeEAeeOrWymWwUoQMUAQnwrApQeRnDZzLicA
         RiuB/9lfgObyv11MKhUOZ/dbrBxVeU0yao9VXp6vz3mCdAVeFZcZIwuRVyjAHwuDaVzg
         MwOavICTjpEbIuehnNZxzAYi+Er9CCVM+b16+YK2nSN0iGtNgfPZseXu5PhbTMyL4dKc
         TEzMvZlqmORnGo/vJRiw2zh5tjkvVisSe8TfCZXPDA5af6l2UNmv8IdKhu45HfysavWf
         GLbKxpYKVy2QjDGj7hMTgAZCm+EEMdk7dGoK3NxoKnOhweOh8/1dlxI05d1hh0G/uvsP
         xXNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVftC6fgSKssyILWmDnq+ol8u5r1M1ZQ0KiWrEwMxucLYZlb3lJ/FfuPe+QBk3RzpDiobc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyorLJwQVe8GAKv+Sgl9Iy+Cclfq4ECMk4iHRiik4OzhZOGdnxm
	J0nwmdwvm24jWtAzAZaP2L239EFLr3QlCEaJPPALuegg9vY0DqtR630afpJERNCDyXkaI6wX+nd
	2FGQuh3TMti0PcUY8iR61nI8NyLyFIYcaYsmId8vn
X-Gm-Gg: ATEYQzxYViC5G36aZQpBkYkgXhin9Z+0NfHVjLTjFC1rzRoFwnP4PUnhcXjNDH1cc1p
	C4GuJD2vmEQ6lHa5j31uF1BR2OADBMeL0VlzDkfvh5kNYUZb52NMuhWNS119NQf1gXiPsMUooiB
	hB216TE3RBtXmUvFqQ7+8X1vB/0HmhqFZ1RTfOz7ml4OLtzypkgMzAIzmWYsr9TSqVoFwOxZfqp
	kSowALOphlLro0hk2wGkaC4iT2I7TlL6mvbKrk/x1qE57liWykDIgWXn8uGdrcWvpePVqqb6H8F
	7mYeRjZ8QK3l5xgv5jwd58fbJKm/otjKyd/mvg==
X-Received: by 2002:a05:622a:508:b0:506:a1b1:422d with SMTP id
 d75a77b69052e-508e5e2b30dmr8659941cf.14.1772726170353; Thu, 05 Mar 2026
 07:56:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local> <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org> <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org> <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
 <aaiBX5Mm36Kg0wq1@casper.infradead.org>
In-Reply-To: <aaiBX5Mm36Kg0wq1@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 5 Mar 2026 07:55:59 -0800
X-Gm-Features: AaiRm53SpNsDBZ1BZJy_J-KSVGaLXeUaHRvKuxEZ4rqtXprCC3pHIR_HRRDvcVY
Message-ID: <CAJuCfpF1=DP4Whe9YkuMcqkE7CXnDWMDbvBAg9pAsut0YSeKEA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8BA98215045
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72829-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	FREEMAIL_CC(0.00)[kernel.org,oracle.com,linux-foundation.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 11:00=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Mar 04, 2026 at 04:53:27PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> > > We could literally return any error code -- it never makes it to
> > > userspace.  I forget where it is, but if you follow the syscall
> > > return to user path, a dying task never makes it to running a single
> > > instruction.
> >
> > Thanks for that Matthew, that makes life easier then.
> >
> > We can probably replace some of the more horrid if (err =3D=3D -EINTR) =
stuff with
> > fatal_signal_pending(current) to be clearer as a result.
>
> Umm.  Be careful?  fatal_signal_pending() may become true at a later
> point, so you may have acquired the lock _and_ fatal_signal_pending()
> can be true.  I'd need to audit a patch to be sure that it's a
> reasonable replacement.

Good point. I'll evaluate each case for this potential.
Thanks!

