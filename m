Return-Path: <kvm+bounces-71932-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JSNOQX0n2kyfAQAu9opvQ
	(envelope-from <kvm+bounces-71932-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:19:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B35B1A1C20
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3A8B302512E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3626938F92F;
	Thu, 26 Feb 2026 07:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkVgGHqo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238D938F232
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 07:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772090341; cv=pass; b=paLhUVTUbQ7tWJeLppFo8IdbrSwrj+QAXUeMf+9sGMzfCfCBRRLFzFBPU5wMNg3X0sUlhatkUyzThj/mTIqCmilDsghW/AZtB0picqopOknlDPnSmdyrN2Uk4zA6s5axFuTq6IN2mKPqJtUoBgbK3veCHxGryGqIAq0aIJO30I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772090341; c=relaxed/simple;
	bh=5kZAYgXFbfkfi4UQTiPb13p2MazR2wn4poiXvnKgRZ4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WG+Lhc4N1T9W/mj23exI7fXMJroVNIPxYYq3OXbm9mgQnMrndwl+dfceU8y62ufv/FGeHVN1eGV7zmqAu49PiotU5tabYye7LrNhMXR5eB2joX2K7m2OoO65z2o4w/QPPIL+KmdaRKfUu3807vnHn1TDUS9e0yAa1h4GWgNf3p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UkVgGHqo; arc=pass smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ff10630b18so122140137.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 23:19:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772090339; cv=none;
        d=google.com; s=arc-20240605;
        b=G08UO+12kjz1k8oLZ/fl7lYR18q2O7/bnBshUmXPnVAxcnjNSlwEqTn/zokTgip7ls
         u+ELQ8X3MXN0owgC3pW61eOb4PiNwSOaMhNq0EYGdwwLGdNmlQiwxzVDURvcyNHZytDO
         XQnn9Jlvz7l79hjcKVa3c3YLjvRetTscCTvKJf/lBk1Nf+cSAzfGXOfUCpEoQuW6H7jL
         YXr0ACUoH4ebSnyrdMVtkOr1MayQrT9McV4k4uK2ih53HT2hAYw5n/m48KyzWl+XE0lG
         WLG2toVLUsLlBq8f7fue8yxO6hwWvrSRshiUbHow5JrOC8zKd+sv9aJ/BpLwZjKQi3wW
         7RuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        fh=X98mRtsDGzrEsEo68vaV5c45lRAouWvaZnl2RTIrlg0=;
        b=lNoAcD2sBN5dj723Z5voHeAhPMOpEoAGuW2V8FSfslp9U+VAZ65stinAUSrDqTvqm9
         UMfXcD2095TuQLWDIzfHepNedZjO7JfDZQWItPXkXjrV6kt0TAYehGo8UwfbOUf6Gb2I
         /ql+Qgusc+fx0iBz1Is0RPTHoBziojRLe12swWJkUckYztVFrBTDnJ8Vmu2aFfs70Xmm
         8A7qCPqmQBl6xsEIpDlSpPFwf2YJehdvjOs1/0Ql2HjP9xPOoQndHoye2YFWCtk7jpY2
         I6ibgK1ddepFjg/QrXfJSBwFx1T+2G35hRRHhoqY8DXL4IvBn1NCd1pTYdN4y37SVXp1
         WzsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772090339; x=1772695139; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        b=UkVgGHqohjH+9DegPTESkRCcW5GUEqXvHEODRmFWxtri5m9ThGxc4fKgZxf5Saqr8L
         YJrx321iwCj2lurexXPSzZLRMuMfSLaeQ5XJwZpvWgrEsjqL6YSH3oI9aYCxLuciOV2h
         Th3mtvnHTE3jibadRUa+/d1c3fLeqAjVIhgsNS7MDhAsuzKLu/kTjFW7wFk1pfE0UK89
         rLmkznK+fNm1ZoxRdE2UwXAQWBk0B+shMZuOtjUKqb9gSdMWSDPA94hpuqoEAeCbC5Ws
         /qtppmWA9nUOL4IdxWS/iQwOlrAUzPQIRiWQ0MavabJ8C/bh7UY+dLfjza95EZAGluFR
         tEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772090339; x=1772695139;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38TkFjWu/yMjVfuieCXSU8i+AJioChf0CvAqY9rgty4=;
        b=Umt/hH1Xq8boURdJiu+N8aNFGPf11piQmxJylNkWOU68AeLgHCRGc/KmrbPtffWA2A
         sVPx0kIk5OTW3ug2Gz4sLejPenXRHe0D20T1Kh/bwZE/VpgnYyjSjo3h2jto0w5ttSze
         RQkzpv6iCbrmBYuPF5XWpBBW6pkdgT8AwwwjJAcOVVPbNEm45VbLD2KwkZS1b0w7+/xQ
         Ahp+RAJJauTTYyUNmUeakLSOKTUglcmAjytMnnXD3GJPyIAeYlP74hNfW+fRHlWgujqJ
         tOS1e/xQlMgPlT+I081GHHMQTfwgxsQsaGzNenhINDNoRdeTdCBLYmZSpfZS4aVDvzxY
         Twpg==
X-Forwarded-Encrypted: i=1; AJvYcCX7cvUaqvtxs5IAUNMRP7jsFf95AtZ/PlxaYno8twtDuZTCiZIwO8W9EO9OVYhtEeP9CxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMVf0ut6HCUHGDsc8KXQLi0EbXbQtrO7pEDQUcp/n+GwOgoJla
	Q3HVzcWpganuCro5kMjK9k8TRQlD/kt3og/qYowmsmL0jbK+cNGcQiXopCnmyoLlPoAHk6O944d
	fkblcz+XWeAEoC7a+2Slub8nHGABqWV11jZE545Ya
X-Gm-Gg: ATEYQzzX5nFux2/frVztu27sreIqWPEZMquvMrqwifr7dzz/VBXyMPW3Tw2x3h1vVVd
	8esoIkKcOzvrwIsn+5+XQnoW4ULQtx0CoCMNrfeZhA9oiegkRIeHV9jbNY4Nhpy5ehXzd4UxH4q
	E7En189bTXl1xouBu672rwZjDtOReKOr4FH9/G5xvrzKoxsnDRBbA0yccaUcsTEGS6TCOVxAoIU
	bpkmYY2V+BXu1v6IznvRCGUwY9byXUxOAPlikJH2j4Q656WRFS9vKZpV+jJc+zOe2lUxHM+1hpO
	pTFg9IltY/GlgOUFGsCCpAQW1VfBogvHQ7SvVIY17x8oWp5wHvj1sL/ca8dOENWWnzs+KQ==
X-Received: by 2002:a05:6102:3581:b0:5ef:2cb8:e9db with SMTP id
 ada2fe7eead31-5ff13ef650bmr1386972137.18.1772090338420; Wed, 25 Feb 2026
 23:18:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 23:18:57 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 23:18:57 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <f6649b09-aa64-4c91-bf3a-ba706f023180@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
 <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org> <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
 <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com> <f6649b09-aa64-4c91-bf3a-ba706f023180@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 23:18:57 -0800
X-Gm-Features: AaiRm51uhp_e3rB2FjbroD20Md18UNjoNkKYVi3b2D7VPNikPNLP_eyGmYzYmA4
Message-ID: <CAEvNRgHaDDTW_CFT_91Rqzx=OErmiP1GvtuCYnAs_wNRWb-hZw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71932-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4B35B1A1C20
X-Rspamd-Action: no action

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/25/26 08:31, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>
>>>>
>>>> [...snip...]
>>>>
>>>>
>>>> If that avoids having to implement truncation completely ourselves, that might be one
>>>> option we could discuss, yes.
>>>>
>>>> Something like:
>>>>
>>>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>>>> index 7c753148af88..94f8bb81f017 100644
>>>> --- a/Documentation/filesystems/vfs.rst
>>>> +++ b/Documentation/filesystems/vfs.rst
>>>> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>>>>                 sector_t (*bmap)(struct address_space *, sector_t);
>>>>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>>>>                 bool (*release_folio)(struct folio *, gfp_t);
>>>> +               void (*remove_folio)(struct folio *folio);
>>>>                 void (*free_folio)(struct folio *);
>>>>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
>>>> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>>>>         its release_folio will need to ensure this.  Possibly it can
>>>>         clear the uptodate flag if it cannot free private data yet.
>>>>
>>>> +``remove_folio``
>>>> +       remove_folio is called just before the folio is removed from the
>>>> +       page cache in order to allow the cleanup of properties (e.g.,
>>>> +       accounting) that needs the address_space mapping.
>>>> +
>>>>  ``free_folio``
>>>>         free_folio is called once the folio is no longer visible in the
>>>>         page cache in order to allow the cleanup of any private data.
>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>> index 8b3dd145b25e..f7f6930977a1 100644
>>>> --- a/include/linux/fs.h
>>>> +++ b/include/linux/fs.h
>>>> @@ -422,6 +422,7 @@ struct address_space_operations {
>>>>         sector_t (*bmap)(struct address_space *, sector_t);
>>>>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>>>>         bool (*release_folio)(struct folio *, gfp_t);
>>>> +       void (*remove_folio)(struct folio *folio);
>>>>         void (*free_folio)(struct folio *folio);
>>>>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>>>         /*
>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>> index 6cd7974d4ada..5a810eaacab2 100644
>>>> --- a/mm/filemap.c
>>>> +++ b/mm/filemap.c
>>>> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>>>>  void filemap_remove_folio(struct folio *folio)
>>>>  {
>>>>         struct address_space *mapping = folio->mapping;
>>>> +       void (*remove_folio)(struct folio *);
>>>>
>>>>         BUG_ON(!folio_test_locked(folio));
>>>> +
>>>> +       remove_folio = mapping->a_ops->remove_folio;
>>>> +       if (unlikely(remove_folio))
>>>> +               remove_folio(folio);
>>>> +
>>>>         spin_lock(&mapping->host->i_lock);
>>>>         xa_lock_irq(&mapping->i_pages);
>>>>         __filemap_remove_folio(folio, NULL);
>>>>
>>>
>>> Thanks for this suggestion, I'll try this out and send another revision.
>>>
>>>>
>>>> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
>>>> might be more controversial.
>>>>
>>
>> I'm not sure which lock you were referring to, I hope it's not the
>> inode's i_lock? Why is calling the callback under lock frowned upon?
>
> I meant the two locks: mapping->host->i_lock and mapping->i_pages.
>
> I'd assume new callbacks that might result in holding these precious
> locks longer might be a problem for some people. Well, maybe, maybe not.
>

The extra time (for guest_memfd, and almost no extra time for other
filesystems) is on the truncation path, hopefully that isn't a hot path!

> I guess .free_folio() is called outside the lock because it's assumed to
> possibly do more expensive operations.
>

I thought .free_folio() was called outside of the lock because after the
folio is removed from the filemap, there should be no more inode/filemap
related contention, so any cleanup can definitely be done outside the
inode/filemap locks.

> --
> Cheers,
>
> David

