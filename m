Return-Path: <kvm+bounces-73264-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mO6wMeJ+rmlfFQIAu9opvQ
	(envelope-from <kvm+bounces-73264-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:03:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 291DB2353AD
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9AD273030748
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8663F36BCD5;
	Mon,  9 Mar 2026 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrUxksLl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940C36B04E
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 08:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773043325; cv=pass; b=fzqtgn3wYmPREgp6jYoTQiU9IVs6rk0/9Q2BbHZn6VNKXZh1xN8AwNHfjBcEYe68I3omejMCDwnH2n124pBQufcnENakYY+WOhj2Wtb8vA1vqOPmfsbsUglwfxLQq7QGlkesYi0TTjD+pQ1VmUr+gYzTrMq1U/jkH3R0Spl8I+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773043325; c=relaxed/simple;
	bh=YZGVdYoM57Ljoy9ZvHaawIawTucwlY62ulstM6rXlh4=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XLhLCIF4kYkTiWRla6RcaMj7y4EmCdKVLIA/bhchrNSccLnaLZf1IgrFv7PuaOpFewWTbeADLFqnqSgNinfiSfEaNwZ0dckukygcJ5ID84Ps6XNEvNYvD/z1+jj9N0y4BzbpHOiNLW6UJUDzZKkFDufcGloWvdwQZd0rxdBNo0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrUxksLl; arc=pass smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-94ddba39060so3086036241.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 01:02:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773043323; cv=none;
        d=google.com; s=arc-20240605;
        b=DQo1Sq3xO0QLcwGnC13OXyamFwfRCqZg3GUSrwb2A5MJSlV27n0n1j+jwjk0RvKPag
         ea/qZu/XWHmOEklmKbBarH4sjGJQD5bh8kj6s6xn3UNmCWn79vee5jM+Wsw8Sch66hyV
         SC4yGM4KTX+9YzryaTRKusHUn5UCLUsh77nU0S3JQW5p93meLhbB1MX2L4k20k9dvPkv
         9q6f6ApHLxkm53dzzf2Qng8TdBQJnW1fQXu/kK8Kw+Bk1YTkibtM6ojiRlDeax3x/RW2
         m/45Dt/EsBJgwoHf4TSC1XdHN7n5DbMIorLgAtxQUeAa8eB0/IFdkGU/bu8WISt6aevd
         5PUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        fh=2B8S++9xrebr/uBfkMVImzPT5NdiSjyAw67eYNK/r9A=;
        b=J2mpSYrjDOaJoQw+VdxhwmY1YYthfMtrUpCSphdiuL9EfSElmOGBz1BZauI9nVZd9v
         /VGqh9duHRgCb9RfURptx6EAsrQ4QotXGRKLvCom1wdme1owcYoLTSMkbdEnYxgJWIDa
         Iu0JH9qdNQ1wpXv3MYEgSgFgx1g8zAyqUZJLIkxO9D8H/XnT/dPZSytbVbWVwfzPbl0e
         dvIZV2b8Guz2qaYchdtqBt4gT7Z3FKSLEqw77oH57GDKbujwKPRqkNl43nGKTQ/L58er
         H2nZ7D73mWs4BgfNeJiaNQjUxY9nMy8/Mb6OpIp/QxGJq3rNcFRBuki+/h0XwphjGEYI
         OaQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773043323; x=1773648123; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        b=CrUxksLl5ZhEZYNX4dpMjta5jQtWUxaGY397oFvuTSjQP75JG2G1HWvyS6ZqkmPcLz
         XvcQiDeqw5wCuH6rdcu9qevxZJ4edrBqvyLN+jZCBZI7i0QjntVHe94mUXQR9RAv7Nwk
         ksMwRgzT/mrbQvpijMpv6nDY5M9sdyPrX/gKAvNW0TAwXzlaVPNg+nN74qwzVSEyJa8S
         xiQwjlrZcVqPUquT9tTUQ1SgvoYKq7IDxllJoWCewzOM+GDBxkc8iNh3rnjhhhPq6Cn5
         wirgUBRicT7dgfzd8N6KQnfVuHKtoRamt4sJI6b9occkPgO7COKShMIAgo3vpP0oPYpP
         YNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773043323; x=1773648123;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iKTwpN//vgpsNCCXbcsIw/eIDxxyup8fH8lZJsZvpA=;
        b=KNq0jK6C1N7YUFJgJtZEWitAZpreTczXDztbxrDyz3mj46YTxACPjP+L5uXkPDcFWV
         rUxWHTG6eZim8U68f3DO2imY66RBRnKSn3kZOeHptRA5BOGWVWzq9y/OzDQkdQZNa9Sa
         UEWcPxSk/s8y8Nw/jIrITyLMm/7gQwrhuJpwDZRRNXFMxwnR5y3yi1zQL8dLkI+7S8OM
         CKmlzLeaUuYFd0cUCekSOkgGICU2cjF4vDEsrz2a+DTmfWhA+wycsFLUTQk2cFm/Tdyx
         ZXBJReKXYx5oprMrysZIxa343KFf6YGQFxVRnA77S8aAY9j9CtVAUewOQkAMcorTnBn7
         vDhw==
X-Forwarded-Encrypted: i=1; AJvYcCUkb9PUQkqWORllvhJmrZprTOoa5sAZRFuIdEvn3kN4Santrff2upRY0D9n+vqueAuwGkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqv3x7tKbJYHnj4GtWPbPGUKPsHcsXhkh5TiVCMmpvDEElOhQt
	hYOHChP8wlJn9aI5qQ3ajaC45a5uy/xYwtA08DB/fDe+IXOHDFy1zKCB7PBkP6KL/u6r7uJVlU5
	vgwknIFvEdp1+etQrtzWBaO4EYHiqr8KRyRqrH5e+
X-Gm-Gg: ATEYQzwcVOFsjSlkqlYwTUleZ2yEGVEOKqph3luarbe7w6GwS4vZehI4g3gyw/jEldP
	LENgPTBSs9ZWyjLnj6D1wUMNvTVNyFPkj7GDjwW3btFx1LvH5amj/Y39TScRT610GyexSv12aSD
	NzhPUq49hIvPUqp7HcRjnf4ANiSdDR4EKQGygRLVi8PLYRGjYnHN+CAcc0QKUCA6ZF+u5WpAs7H
	NxbD//Sh7D6irPPo0ynpXspI3uOKXrTFn4uFlFRLHV9namkuVj2rcB6HY3FLUfGrXiWVbVKGq/D
	shuesr+q4VtMVMQ2oL4f2ktCo1PkZMoVZFx80hicR+zn2V56KsVaN0H89tySWmWQJSZT+w==
X-Received: by 2002:a05:6102:4194:b0:5ff:cee8:660c with SMTP id
 ada2fe7eead31-5ffe61bf0d2mr3868411137.31.1773043322886; Mon, 09 Mar 2026
 01:02:02 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 01:02:02 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 01:02:02 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aahNprLw0_Cdhzxp@google.com>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com> <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
 <aahNprLw0_Cdhzxp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 01:02:02 -0700
X-Gm-Features: AaiRm52tdsuammFV80Tf5JuKg-WPQwxrDNCct9c5X_bV6T_IkMHGIVZ0r4R166A
Message-ID: <CAEvNRgFwyqY0q-PTvMGjK82rxvbCfPxK8-RUPML3w_8mzAk8xA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
To: Sean Christopherson <seanjc@google.com>, Vlastimil Babka <vbabka@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 291DB2353AD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73264-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[35];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.951];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 02, 2026, Vlastimil Babka wrote:
>> On 2/25/26 08:20, Ackerley Tng wrote:
>> > __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
>>
>>                                                            FGP?
>>
>> > adds complexity for the reader. Since guest_memfd doesn't meaningfully use
>> > any of the other FGP flags, undo that complexity by directly calling
>> > filemap_alloc_folio().
>> >
>> > Directly calling filemap_alloc_folio() also allows the order of 0 to be
>> > explicitly specified, which is the only order guest_memfd supports. This is
>> > easier to understand,
>
> That's debatable.  IMO, one isn't clearly better than the other, especially since
> filemap_lock_folio() is itself a wrapper for __filemap_get_folio_mpol().  And there
> is a cost to open-coding, as it means we risk missing something if there's a change
> in __filemap_get_folio_mpol() that's beneficial to guest_memfd.
>
> As Vlastimil said, if this greatly simplifies accounting, then I'm ok with it.
> But the changelog needs to focus on that aspect, because I don't see this as a
> clear win versus using __filemap_get_folio_mpol().
>

FGF_GET_ORDER() indeed caps the order at 0. I was overly focused on the
earlier line where it did mapping_min_folio_order(), where I thought
other code could possibly influence the eventual order.

I'll revert to __filemap_get_folio_mpol() in the next version and see
how that goes. Thanks!

> And if we go through with this, we should probably revert 16a542e22339 ("mm/filemap:
> Extend __filemap_get_folio() to support NUMA memory policies"), because guest_memfd
> is/was the only user.
>
>> > +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>> > +{
>> > +	/* TODO: Support huge pages. */
>> > +	struct mempolicy *policy;
>> > +	struct folio *folio;
>> > +	gfp_t gfp;
>> > +	int ret;
>> > +
>> > +	/*
>> > +	 * Fast-path: See if folio is already present in mapping to avoid
>> > +	 * policy_lookup.
>> > +	 */
>> > +	folio = filemap_lock_folio(inode->i_mapping, index);
>> > +	if (!IS_ERR(folio))
>> > +		return folio;
>> > +
>> > +	gfp = mapping_gfp_mask(inode->i_mapping);
>> > +
>> > +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
>
> This is a potential performance regression.  Previously, KVM would do a policy
> lookup once per retry loop.  Now KVM will do the lookup
>
> I doubt it will matter in practice, because on EEXIST filemap_lock_folio() should
> be all but guaranteed to find the existing folio.  But it's also something that
> should be easy enough to avoid, and it's also another argument for using
> __filemap_get_folio_mpol() instead of open coding our own version.

