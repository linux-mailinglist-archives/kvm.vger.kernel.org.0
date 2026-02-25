Return-Path: <kvm+bounces-71808-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGZEBm+mnmmrWgQAu9opvQ
	(envelope-from <kvm+bounces-71808-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:36:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 829A619388C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:36:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0749730517C7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 07:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F982E0B5C;
	Wed, 25 Feb 2026 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bWgpGrog"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BD91DF75C
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 07:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772004687; cv=pass; b=CMhbn3bY6BaOBOcPozNIdbO4Ox3ecdQ+XVjhk2MJHEeKbJwN6r/HnAeJG+JzZPsbf9ZTl9V31SYVe+4/zGkf5xTtBmlKPLIYnXsOFJqcf5ASK+Qvg6FNVJ4BqhUfwWFrbz+8TLnXnEuPLc0bbZID5ejwp/jZhbMjoznjsTOxQWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772004687; c=relaxed/simple;
	bh=iGYGT1zAvQhLDodw/8tlbySDHlXg49Ntp6LeHdpPLsE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jCwOt+7zPoj8OGXRYmndbbYKOQyC7qWOe7m9FkwajJ6IL18plld1sAewlESpe8IwIE5MEuhBbw+Cf0xCKB55FKtvy2fjpNshwOu6v2t9bcCxXNegn9zv4hh5G1R/TOG7D1LAkZtv2cIEJs0fjXoYoJ+jW9BUGz+inq2SVKZA+bY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bWgpGrog; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-94ac7f22d23so1731853241.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772004685; cv=none;
        d=google.com; s=arc-20240605;
        b=VArmTfcik1LiM5lYayTU8cJyNliT5FVPF+EZ646/kovAx+1XaaKF7BQvnOPCHbmfyN
         F6JvjocCoZSOI8dncmFj2YbSjryTm5dLnZ1HkNR6+syasrKEH+P7ileHgiV+t4As+4Gn
         YtQ2htyco9PL+PGvRQpoqFlES++cnMQ8tJ35KC4Sj8vkMnJq2zE8nCSS+KFKSM0N/5Yk
         MfO7b/dhSrYRuzkS3vLcxo84CXUi1TY07iLSfPrZiYZxl9jEJdaugha6uXVMo/yknFd4
         PRtlDfgiWtUxDDaDUE7YjIuQzkvI2bH4k3aAZqvhIt54C9TZAYFlCjz33798NJ7Gk2H6
         ik9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        fh=RTA+JSvck0pEOhNFlf6AbXAmMajdd2ePveLy3P6+iro=;
        b=Qt+80NAkFRtda/mKC6CaUcd9dzoW+CTiyCObYHygdiHFXnXPMTYj9y9QXsMlgK6Ol7
         UD27amWArie4wpMrfuIVaCs5a8LP/8/R6qyQrcChyzkYGyaK7+c+B8AFR1n6ngflFSfa
         C5RmkWpPje2Mjadw6tLG42kSGDzJT/Ffpp7Iq0/QdyXlyuHvMrZ5Xaiu6enSZq6zltnH
         Yd+wmXac7p8QyNTnQGDDzmQyDpiw5UXmgMSv8/OpGOJyqEORH0LFY92OgXHrS/fj+KS4
         EOA+T2kyxzGHsl7NAtZCatM0EMLlVfodRZ1I5qSFA/DrxUcQ4RPXjYGKaOMTQcTm6vNE
         uqKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004685; x=1772609485; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        b=bWgpGrog6nsW6EOEHynnZAPGvkBcMVg/s1vfSpuzTZLe7e6t4gBUDAZXvOPcNuoT4S
         pnzbstWM4T9iS1znGoiSjyIWvaDbKYN6o/o71Es5cgPT9w/4NB07oc6aITDq8PiOly4F
         xok/UzWtqKvu4yXXY5lZ21DFx1gn5ouSN5c+mmA0GjPF7rDP6w2UD0Xsq70es5uw7quI
         UQLR1wMKm2YWMNw/euHnkLXp0S93RtVNzISXX9HRBvcewdSLvPd+vkMQsjLDO4JrxF4L
         t2XvIzRh00K4MwpOdL4+M+23Z7HHsUKzVeggTvCwSIHQqe9424kPa8W5KMBq5qWfogcF
         7VbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004685; x=1772609485;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        b=gd0hcvC25gR6D5FqHerrzooyYiSm9fOyeyy6o7CJux2zF+fN1p+Eojowlq9FCSQG/1
         uOQ1CvMdTCgjWXoiiPf/sk0/Bd4Adv+azTO6RtSub4AlheevMf9gd3eIee8rfSvnQQht
         YngSL+t98ArpJ9a3Hj/MosouM3ZWW+pp4vD0I5a5/sSoQ3Md/6+EJkoG4UOy8UIC8FWa
         rWkqB+6RBsNHumsegMnQT2jTzsTbdN4ZN48OcMBvKD84qvpYovrPqmGf2RnLNGVcLjQ9
         F5xthU/PBByYDBS4f9V0XIqiX0YJroLDCJaUhmEcm1LUSi32xAdZaUyNL3Yr1W1pySJR
         53Yg==
X-Forwarded-Encrypted: i=1; AJvYcCW3ryCe7OaBy4csavYNlXKWc9LSs/9hJoecmstloY9k/+uh5X+POdw4jRjOZ7nSYit8k9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGTpBogGz6hb4SgJHYsiUQQcAcLB9GPpVTrzUaOlw7YVdMMMDx
	osgU6GqRPuh8nxljdTpvfjkKtrHBVu5xSm+LfQPPiN31UIgdb9CIafg1mWzTr4QbzWZkUqdtA4V
	ijGzL6OH1lgVEBNZKCM24pcW1S1gNMgLOVdYVOj5Z
X-Gm-Gg: ATEYQzwuAuZ4nVoHNGP24rTgExY4ABISE4szTEsdY3Kegp1KVv+Hp712Qm2pH8IgYiC
	9gtB9sF/OQagiCRAqBGvy1lCmvMie7BEED+AwUqvy0nvg2HGuz3CMZ7q21FI+wiemf25zIXpPg1
	ndKsu9/2uYwyfpOKU6OACOM0+8GOcYfFaHxOPXlGvUee5xu71vS8XFk74wsZWyKacAHVm4bBF73
	2FyJGy9ZnjSyhNGZzPsJ8KDhWdTd+UHSyDdohTt8QGCLPCSqiXJXNJ9pikAOt/6wRO0d954x8xU
	NNdbgJb9GqfvOe2LaAomkg1onPEHkFFUDT7iapFy2OgH/eJ4ZqkE+8OsPSCKADkTPpkGaQ==
X-Received: by 2002:a05:6102:3e84:b0:5dd:89af:459b with SMTP id
 ada2fe7eead31-5ff05d62336mr520728137.7.1772004684941; Tue, 24 Feb 2026
 23:31:24 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 23:31:24 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 23:31:23 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
 <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org> <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 23:31:23 -0800
X-Gm-Features: AaiRm51zoZaexsL8AgLT-NSu-LX5kDXX-7Kv8iZiX_RuOJxbA-22InSuIouRjL8
Message-ID: <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[29];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71808-lists,kvm=lfdr.de];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 829A619388C
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>
>>
>> [...snip...]
>>
>>>> Could we maybe have a
>>>> different callback (when the mapping is still guaranteed to be around)
>>>> from where we could update i_blocks on the freeing path?
>>>
>>> Do you mean that we should add a new callback to struct
>>> address_space_operations?
>>
>> If that avoids having to implement truncation completely ourselves, that might be one
>> option we could discuss, yes.
>>
>> Something like:
>>
>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>> index 7c753148af88..94f8bb81f017 100644
>> --- a/Documentation/filesystems/vfs.rst
>> +++ b/Documentation/filesystems/vfs.rst
>> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>>                 sector_t (*bmap)(struct address_space *, sector_t);
>>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>>                 bool (*release_folio)(struct folio *, gfp_t);
>> +               void (*remove_folio)(struct folio *folio);
>>                 void (*free_folio)(struct folio *);
>>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
>> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>>         its release_folio will need to ensure this.  Possibly it can
>>         clear the uptodate flag if it cannot free private data yet.
>>
>> +``remove_folio``
>> +       remove_folio is called just before the folio is removed from the
>> +       page cache in order to allow the cleanup of properties (e.g.,
>> +       accounting) that needs the address_space mapping.
>> +
>>  ``free_folio``
>>         free_folio is called once the folio is no longer visible in the
>>         page cache in order to allow the cleanup of any private data.
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 8b3dd145b25e..f7f6930977a1 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -422,6 +422,7 @@ struct address_space_operations {
>>         sector_t (*bmap)(struct address_space *, sector_t);
>>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>>         bool (*release_folio)(struct folio *, gfp_t);
>> +       void (*remove_folio)(struct folio *folio);
>>         void (*free_folio)(struct folio *folio);
>>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>         /*
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 6cd7974d4ada..5a810eaacab2 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>>  void filemap_remove_folio(struct folio *folio)
>>  {
>>         struct address_space *mapping = folio->mapping;
>> +       void (*remove_folio)(struct folio *);
>>
>>         BUG_ON(!folio_test_locked(folio));
>> +
>> +       remove_folio = mapping->a_ops->remove_folio;
>> +       if (unlikely(remove_folio))
>> +               remove_folio(folio);
>> +
>>         spin_lock(&mapping->host->i_lock);
>>         xa_lock_irq(&mapping->i_pages);
>>         __filemap_remove_folio(folio, NULL);
>>
>
> Thanks for this suggestion, I'll try this out and send another revision.
>
>>
>> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
>> might be more controversial.
>>

I'm not sure which lock you were referring to, I hope it's not the
inode's i_lock? Why is calling the callback under lock frowned upon?

I found .remove_folio also had to be called from
delete_from_page_cache_batch() for it to work. Then I saw that both of
those functions already use filemap_unaccount_folio(), and after all,
like you said, guest_memfd will be using this callback for accounting,
so in RFC v2 [1] I used .unaccount_folio instead, and it is called under
the inode's i_lock from filemap_unaccount_folio().

[1] https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com/T/

>> For accounting you need the above might be good enough, but I am not sure for how many
>> other use cases there might be.
>>
>> --
>> Cheers,
>>
>> David

