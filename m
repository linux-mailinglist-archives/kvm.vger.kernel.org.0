Return-Path: <kvm+bounces-71711-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uD1bJ6YvnmmkTwQAu9opvQ
	(envelope-from <kvm+bounces-71711-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 00:09:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0CE18E140
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 00:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 14F7930508EA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FA834B18F;
	Tue, 24 Feb 2026 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qjaI4wnc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3CE2FFDE2
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771974514; cv=pass; b=G4zXKv0o+EpIHAjZnF9UYcenAkHNmyqQPGzow6agxa7tf3QDQaaO2vYl2zDtFF19Vq8tbCOX4TL6m2JG9bC4a+2nM6Qs7Ee0g1HxJ3WFcXvmn+mGntJj40GIFM0t1OV3ym5QM9YavOrVyt8c20JEF1npMsFUhaLAB5bhF+jLJvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771974514; c=relaxed/simple;
	bh=28oWEEZoiQk0c8pFXW4FAksDMsn5TOYNsg+K52E7d0I=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hNzRUhYeEF4/vhRmIcB7iWTguRwWDudiEj9240Cnjo27yKCnO2xbc1GrPZjWOrHluwbysM9d3nkGXxeYjW0eExu/rm5NhBPnHEWKAuOxOvc7vD3UD9GdrbOozz7wJCgIQxXYzUNBEps8aoqPqkd6duxc1lLtpeC6KOB/QXG5LoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qjaI4wnc; arc=pass smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-948029fb1f2so1683735241.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 15:08:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771974512; cv=none;
        d=google.com; s=arc-20240605;
        b=gS4XQqLxdvbKpeDK2JG55IOIQUrhHweyPmrQT4cPBFJVNqV5Yg7IQXjB55Bi8hZirL
         RnviVDeOemkile9VlhjJze0pAxv8j2/jra5KuXFgQSNS5lTRoYBfRM9+/rJ16chPrWrF
         R0IrA8IW5WyF+s7w5kTqk0Qx3j1lTOelIdL9VbgGfImQwNusiXr+o2ovXCKkAGWuRiyj
         DJAvnFJlMAxgIHTubwTn/q5YnK6z05hmkZZRBoY87WjElkK6NDyyw8e7bj2xm2+Nu2lN
         e9oY/hh88sRTBcrw4tdYWeFd22l+GLQLtD3wHFuZByjBF3gh5J9Z0VZ+i34CgK5DW/B0
         lYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        fh=MldFT0evfvI0beKyOgBWgBEDqHSfJdh2f948ER5pcX4=;
        b=WRrMLcA/y62HvHN4Z9VfGpsiHHVuJKJyhTThF+310w1WIkEyXXKohTr680+uwJy1Zk
         IWhL6BDb59HcVDXYe4RTx6qbw5l1t8DCNUgV5S0tRArFNtbNWJruPk5myb+WTyhreUm2
         ujtsO5JgxN6G1NwZv9sLbSGRilMikMCf7Vy3xXY27Xuj6duiGmlXj89wGFEfGCBe4hXV
         4e37bRkkpz7tsXUpImeAiKP5iXolTzemey9G+z0s5rVCR88wcvNT2Dhln8T9/xAXQjiT
         liUoyC0FAo+m6eWmsKO8Go0V3Rm23j7c06o02VWgx7z/ib/oC/EA/15vWldTgChwuvOC
         pQCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771974512; x=1772579312; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        b=qjaI4wncSBISX6RMiyYjW6b7vhKOb7K3rRqhHpgcw3cBMa34/9D2b2LhVwiUzcW1NM
         LM+e+JbVTdBdYV7oed9NR0e/npN6N4IN20/kvexzf1JHzwICpOSVhckPKqMtuf8nRj/i
         umt4eOPj1p+CJFBwhmI2biJxADyS2yKAfVaMY5Ckdvqv4iJlcnSFDr/k7BkuWU7XvKnD
         6xjMcoGQj9BlCV/x0mN7J7wtQmwhDvaesWdeyhqEl2FlQVUrn2KCKkbNeZCq6Lf311Kc
         GsyMNFVKNifRzFGjtjZernenD9waEcL8F8qVWnsijoga03aHMcDjwbFWIHzgURP4uHv0
         DsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771974512; x=1772579312;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        b=ZN0OQQoR/HZFGy4tJ81t9qfaulnAPvd4MLL1XT1Q8sGRRzXJMmeJ2hz+OKaJ2PHAJ2
         i49egqMUudztw2N9TcMV8TzQaWhsk1Sp0g4BFu7KR5CENAiMPUTIg7lWbVp1DCZD6yyc
         IDL3gpi/AKTRzNJft7dvjDs+BHeg+k1GWjl2aM9WgSS0M6matKaDru4gUfrBiGr/OXUM
         BKsX29zw/ObPmkz+n7FNmXai5XMYCd5dbntbnpI0nZR+JhaXDrj6M4qR42vlzTLPI8p9
         h5LlELfY54OpVBxHOzD+/m6ZypXv99/do+YEW7eHd+dzzdmTnAOf5kdUerTBhVL2zSxt
         vNeA==
X-Forwarded-Encrypted: i=1; AJvYcCUXo1QK7GXngFpdyujLIZlWJrYOQCAkO6uOoBV1IxU+f2UV5ZcTlqGCy6X+RYdD3MyViiM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz6TJNHwr04zPO14Coifuh22ZvpRJe4mGC3JI2OUcq8F5+ndPr
	+7bzZFrN93HiHv/WYysbRKowXGeKeCus6+pKTiw+KwbxGRMwyAXBb7EJkXQ0zZEKDDFFJ1n1ueV
	TrsVJLlySC4RT3FqXWmfcZCuJyA2gGp3U3TXpQMtw
X-Gm-Gg: ATEYQzxilirPWvr+aaRJMefUhaL3+c3+vajRwhBq0/DFFbs0pqagKzR3WuAusymaVKJ
	Vhc0DUGHmIxVyjF3YdAZ6YIPXYr6NGuwStfg85Gt7icoMq4kZX9OewDL3u/6ae/6Aa/Omq7axHN
	GttYELtpjb1wDcdXKXdvEk/mOcFVeuzzQwuTtO4LTkYGg26y7YSwq2TZgwC/S96c8eCDi3Bz/hb
	Saarg/i8nzAKC5kv6K+zgLGtbQYJoALMF/5SUvdZu4crIC7jeAzeJRR4KNOBLpFT3GAcfdyYLEa
	r6VNa11ed2434V16813Ug34J4cFb7lHjH37WJTfbvw==
X-Received: by 2002:a05:6102:3591:b0:5f1:c4d3:5b37 with SMTP id
 ada2fe7eead31-5feb2f08b48mr5246678137.16.1771974511231; Tue, 24 Feb 2026
 15:08:31 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 15:08:30 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 15:08:30 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com> <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 15:08:30 -0800
X-Gm-Features: AaiRm50613GkBCc5TY4oG7cVnbM-cLi0tM-0c-2O0j598MHU_6zRLimq98-hNZ8
Message-ID: <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71711-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: BE0CE18E140
X-Rspamd-Action: no action

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>
> [...snip...]
>
>>> Could we maybe have a
>>> different callback (when the mapping is still guaranteed to be around)
>>> from where we could update i_blocks on the freeing path?
>>
>> Do you mean that we should add a new callback to struct
>> address_space_operations?
>
> If that avoids having to implement truncation completely ourselves, that might be one
> option we could discuss, yes.
>
> Something like:
>
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 7c753148af88..94f8bb81f017 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>                 sector_t (*bmap)(struct address_space *, sector_t);
>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>                 bool (*release_folio)(struct folio *, gfp_t);
> +               void (*remove_folio)(struct folio *folio);
>                 void (*free_folio)(struct folio *);
>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>         its release_folio will need to ensure this.  Possibly it can
>         clear the uptodate flag if it cannot free private data yet.
>
> +``remove_folio``
> +       remove_folio is called just before the folio is removed from the
> +       page cache in order to allow the cleanup of properties (e.g.,
> +       accounting) that needs the address_space mapping.
> +
>  ``free_folio``
>         free_folio is called once the folio is no longer visible in the
>         page cache in order to allow the cleanup of any private data.
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..f7f6930977a1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -422,6 +422,7 @@ struct address_space_operations {
>         sector_t (*bmap)(struct address_space *, sector_t);
>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>         bool (*release_folio)(struct folio *, gfp_t);
> +       void (*remove_folio)(struct folio *folio);
>         void (*free_folio)(struct folio *folio);
>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>         /*
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4ada..5a810eaacab2 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>  void filemap_remove_folio(struct folio *folio)
>  {
>         struct address_space *mapping = folio->mapping;
> +       void (*remove_folio)(struct folio *);
>
>         BUG_ON(!folio_test_locked(folio));
> +
> +       remove_folio = mapping->a_ops->remove_folio;
> +       if (unlikely(remove_folio))
> +               remove_folio(folio);
> +
>         spin_lock(&mapping->host->i_lock);
>         xa_lock_irq(&mapping->i_pages);
>         __filemap_remove_folio(folio, NULL);
>

Thanks for this suggestion, I'll try this out and send another revision.

>
> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
> might be more controversial.
>
> For accounting you need the above might be good enough, but I am not sure for how many
> other use cases there might be.
>
> --
> Cheers,
>
> David

