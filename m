Return-Path: <kvm+bounces-73263-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOxPIfZ9rmlfFQIAu9opvQ
	(envelope-from <kvm+bounces-73263-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 08:59:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E3D235272
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 08:59:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDE3C3055100
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 07:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3885B36BCC0;
	Mon,  9 Mar 2026 07:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQQ8sP7O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE5936A022
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773043061; cv=pass; b=i+eNjyTpXRBShtN535fRtOsy+0wvNZ9hQQOaDcquAH2P5wkKQOpW7quxIaSilbicxCiWnlMVXQMueiO0xlf5L3f0OdIFnZBfZPixpqnkgFErHVeI5rflThXoVsIoXIGlgEzgPTLh+meW/61uy8f9fHUeoMKlCAkwVXepVg80KFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773043061; c=relaxed/simple;
	bh=Bc5YCzZwaugc6qlY/fyP8r1uGR0PYI0Vhk0jy+TRtSM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=txayP9gFIU7oqMcFH9fTwyYP1/KNJh8pPao0qWvYcLmO9mjfn8m+FZ2jorUi8VYiJ/v6QdL/44WEr9QoDp802rW1A8gg7Fl/zC8qwPv85aXIsb9dk3lj3JI0VF/tpwPS74Zj5u/mYEjPMxliBLkLshEHxAXkCF1KtKDzZvTQFrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQQ8sP7O; arc=pass smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5673804da95so4597335e0c.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 00:57:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773043059; cv=none;
        d=google.com; s=arc-20240605;
        b=COdTueSOqWZcu9vhD+fNewVomLpLPW4kGsIsajMBKlA5MHzipX8dlePaSyAH2VdSx0
         tujnlrSd5cpVe3acm6KzzzlhvYKl00H1rPSSGTOISEP8RgS8nX5C7q6QJHnbKdNICUjJ
         /EK0XFsg91bYJYw99oRa89sBnELnvzTWYBD8VVZZPg2NTqW3ZdbvPEy/eKYQuJoik2wr
         W/HenICh2KdSml9QrpoYCTPCU1v0Lhwhe9vLay2pobwliVSJxGLrsXBDg5bWZjAUr+t4
         M2YsPmVn1z+GLAKw+QJO8YrVUuPL+/oSVVBjPRpDJHu72DTM809jNNkX/3hAy3ZJ8BJH
         gHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        fh=ih5qgrR8LPmmsvVaJtSrKhTMSG7aZs8tiXrqUh+pinw=;
        b=eP8Nyexx4HdICHyjSxfhXlIEOS0BaZdWYJ22exde7kpKn0jBnCAt5+J8EJSWcje+fQ
         WJtzOqAVgHYYWbmEauXBtQqd93PtO0kSFhfx9YV/cToX8G4DZJUmFYcmFRPzmUOQdWy7
         T+LwDCEEQRVV2Y7CxGWPXomcIxaiuCCqmf3ap6hjFMTGsjcTRlcYaoTGKpGo7tLj9kUQ
         NwMfg/ve4YUKyVrC/M5qUhg/0XxmxVD9efa/lK9uygcFotSfusMFpIWBi78Ov0tN4VMG
         ngOJc4oHaZpovn1+o+bTfWYxewcp0s5y7p0g+b4sLIuoWdnEXkjMnU4l3did71MCWfG5
         wGIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773043059; x=1773647859; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        b=wQQ8sP7OObRVcKgeGGv/EzwD3xLC5blExAfs9xMlsv9wXPz4gTY8BOntw4SjgTmNDN
         cRZQEL20ABBq7ZxLfp9oZTpp23v1pxAp5y732TxQdk8skhbNcTSzbNOB4VxkQOe+vEYT
         3QbGCZyRVGPxET4P2rhcv0Macc6trG4PottoMRTws7a2Us9OQGVoromoHQk5zZoeu5Fd
         1fiUjb4SDwZ+3wETlO2DfqSVB7fHEoT81J8viPUXHb4+2I6ZAcCuXh9+VtRsnrEhEaLR
         C2JzEkxC/jWSujXPW+/1iwtYKxKzbwiHRi8nf1xTmCbUR1n21O2CRV0XJqxff7GQpKT9
         HNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773043059; x=1773647859;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        b=CbO0c1UOps9YIpUcIObz4GJgtSJ6pDOdGDdy8L4EI8BsnFF81DkBceeapYcNbJUywq
         SAYUG0i0cft06I5kNa/Smvcuuxh7sQ/w8zIkGzUQ14/NL/zSnFO/RimK1OBTgZ5LRmCx
         hJDreRoVBtcwC2GRUvIeESVaOUFHiky3eN5H9lqKQ1yVPMgCYRfFTrKCakP0X1rgrNVO
         fZKOS8HNUuiqJ6v+yQvbx4KVIWsQUfvRXgWiYfGzd+TapcxeZzyIY/Bf/dCybuHtX6jk
         ZbIJCRz29y0RCx41j1mzpb1SXAm8LxVnRPxRKHxbaajkwZGY6djs1Cv+4UB8KuHRAQBG
         gdaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUThoIcKex24DkrPBD040lIpShPg4xlRhm5KTGUt350NCJc1eIcYWdoDmM69CHdh8a0uL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj42vvZEtspg/epa+FdfAK42Pw82vRZOqY1DQ+Hdm1CX6s0vB3
	cqkZ63LGm0Ugn9ZdERPsPrqizQWp1DstGI6fj4EKnFSzppYbYtu8PiXeBcQQ/PdtykJYBDai+mc
	yDEwpS0xTFTN5tdyz6/JbFzop0hikxJKWpfV5mMY9
X-Gm-Gg: ATEYQzyPZcTKCOuHS9uXR9qROADY23aeB0Q3tk0AJ1L8quWQsCiqXUjVWv9vPg4n6AK
	VxamKAehpEsun5G3y2CoBJ6Zk0dN1tJDAazKrBNLr5ULtxR6nqrlfRJru6+W31x6D9wZciu2sf4
	R3aPaxDlUyiPeBxhp74cpG/OSSrF7g17Jpb929mDYL9cD+ZWD1y5DO7i0jvWFczDoNsd0f66SEY
	3VUnJkRnzx1hq6wP3/Oy7PywzM2LbbY06ESKylDgArbqFVGAjVfp4nnIaMSPuwybIMpEqdyA6JI
	JAcpWgKCUaYqCcrGz+VqAC6T6KAFIXLol+keWGv5/CFV3Lg2Mo73PY4SXP18TWc+oUTwHA==
X-Received: by 2002:a05:6102:d8c:b0:5ff:d192:ff2c with SMTP id
 ada2fe7eead31-5ffe6213645mr3556252137.34.1773043058690; Mon, 09 Mar 2026
 00:57:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 00:57:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 00:57:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com> <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 00:57:38 -0700
X-Gm-Features: AaiRm539ncfsVFw5AP9VoOkialmaGifm5bQJ7k_NAlY4DMAWUCQTSVmir1fUcmo
Message-ID: <CAEvNRgEH5X79zwFr8t4EayDccED8i5__-oFyBZ4nb_RkX8826A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/6] fs: Add .unaccount_folio callback
To: Jan Kara <jack@suse.cz>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, seanjc@google.com, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 30E3D235272
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73263-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.947];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email]
X-Rspamd-Action: no action

Jan Kara <jack@suse.cz> writes:

> On Wed 25-02-26 07:20:38, Ackerley Tng wrote:
>> Add .unaccount_folio callback to allow filesystems to do accounting-related
>> updates to the inode or struct address_space mapping, when the folio is
>> about to be removed from the filemap/page_cache.
>>
>> .free_folio cannot be used since .free_folio cannot assume that struct
>> address_space mapping still exists.
>
> I agree .free_folio isn't the right place.
>
>> From the name, .invalidate_folio and .release_folio seem suitable, but
>> those are meant only to handle freeing of a folio's private
>> data. .release_folio is also not called in the truncation path.
>
> But this I don't quite understand. .invalidate_folio is called when
> the file is truncated (or when the whole inode is being evicted from
> memory). Filesystem can do whatever it wishes there, not just free folio
> private data. Are you pointing at folio_needs_release() check? But you can
> mark your mappings with mapping_release_always() - it's there exactly for
> such usecases... Am I missing something?
>

Looking at it again, mapping_release_always() gates both
.release_folio() in filemap_release_folio() and .invalidate_folio() in
truncate_cleanup_folio() and truncate_inode_partial_folio().

Let me try that out in the next revision. Thanks for pointing this out!

> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

