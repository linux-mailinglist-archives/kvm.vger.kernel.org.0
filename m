Return-Path: <kvm+bounces-71549-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBSLGO7mnGmNMAQAu9opvQ
	(envelope-from <kvm+bounces-71549-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:46:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 85D1A17FF21
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A1B6306F27C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845EA37FF61;
	Mon, 23 Feb 2026 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4npmqqkZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E05F1E9B1A
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771890148; cv=pass; b=fCzKo7AHulGv0khkRU5nBBQ6I1B6lHUo0Jp+iRs/2aYN/wx2YqPqWSF5k2TIt61rO6saAnlXJYgnzwNZjQZrwMCySPGpYFA052m3y1B2F/9cG5L78+JZ4PYt3BtIG8dIWyxQMpOdTXSznE5JXaEaMGq7IXtn9MyMD5xoEmGy758=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771890148; c=relaxed/simple;
	bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CP+o6fxG/vDg1G7537i+oaKhc+6oewVTcpKAIKkJyUL4UWnWBCvjJYSJsfkbxG/cEFbDV+ITneFrmn6JtuEUU9lZYt8RxDo9it+KyLDvuqNSXO0i/aWwZKjMvIupc3adeztPq+J0/gl+ZYGzUoeFYJlXnko3v3hATaGlF09r8Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4npmqqkZ; arc=pass smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-94abd52b274so1278264241.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 15:42:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771890146; cv=none;
        d=google.com; s=arc-20240605;
        b=fC1nhITDNBBRFf/Tr3f9dm5YAPJNijMBUM6hvEeE4z9QQ22Imhsfh/DgyCmvopbf5O
         PBN4sUIOmW+pKBBOu3k6BxA5IxppDqe8SaCZV8ShVRQDWM2tYyRAWVk9BVSLHED7ZmDu
         ta9P7I3UIQ3Ddx/H1soWxcwBfO1cFTQktEQhX4U3P+ZsVuOiUJO78i0Q6T0cqr152YWC
         2hmdxmsIA8Fv/gVPS0Twzb6dE/Dc3NhxZpR/g3PvtiHWMehHDqbdPeZ0RJkZ7zPsnTOj
         QGhcQluq4v4aHK2fZ9UJtLN/Dynbr76CIdSoNDjUxfdoy15d9cvxRPY+oT+FNSylCv7U
         A9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        fh=jdYo2zUXyfEBZLx/yQCFA+4tPWELp8R8pis3a0cn2pw=;
        b=WEAaOXgdeIDhBqM63L8j9t9sNxbnoMnn0wY+R5st0h+9imk9r4/pnGx/hiXpRv3B5C
         iz9vYpwhUwBxO6FVVQIsaBjh06l2ifAhrDvl4w6d0snoWLHgVzgYxKYYh1ol8QQZv6d0
         6EdW4UTW+6jwiCXKWkl5EKVRTvtdvUTlXtdB1XoPI6oFee23XZmFaXZNzCrmsekhn3Vs
         C/Wl22cdPIB8v18Yc9BQraXxsiN/73Jh5C/0bY+sWgvYxQIenCDkcMGWHz5Cby4F236t
         bXksDED0f8Q9nvmmeD/+ilPGWPPMu0AOP9R4K7Fwz/DU4QjAwT26Ay22RdVMZB1dOB+V
         AlLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771890146; x=1772494946; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        b=4npmqqkZVD4RdxyIRdLVN3GJ7fxWuMZCnqv7lxvXKBLGnYLdgHySwMxoi65MgG7ZHj
         q/mQv62NpefnTqLd5SVDhmDhjWjQs0eTdLhx0WK/S+dpkS6YzqJjbeGoLxj8en304v9P
         WjJ2xHvxEejgELw1MUKyU+IGjKcCUEP8bHGCB+O1WkB+bIxrm1Jm0LJp4ZXaMTq/Yjyw
         Aq1yTR4H6M+iZsZEIPqRNGjLmWUAxBEk/m3nKtxVTxufNpwaweCPnVtKKJvHPHnx85x5
         hcfTk2fuxe/ilc3cu/6XP5AlNVlhu4IkSHLUt2xOYN2xfWvB0+yB1nQhxnQ3gd84iVka
         Nmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771890146; x=1772494946;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        b=dTLL3rU5MCM1hvqoesXgF5DD1QQDLTBNy8kJDgM8u/70k9amFT0yXuZvRy3RUPWybV
         XXHA79s6WWGNjnx60MhmE4hpJSfqh08JP6fT0iYRzHiWO/3BpR6pnI4lYbw6gwKhUfN9
         bCAN1pnHVje+gK3Ur4+y7nBm2sOag3/rnlBbTKCAJ0IxSCKfNswh/LTxVqheAffJy8m8
         sDobkouYqTR9heLrxioHvWu39fhFYAIEwLeHj03ubdckJE8PQlNrTHJQ+/3xBNVVHBi0
         bUiti2ta6D1Q6BVMAqgEq+W+C8Uc7JSZQpou0YxK8XDDYH9yBCEabYIt5mAuQfRRfe9D
         9mNA==
X-Forwarded-Encrypted: i=1; AJvYcCWaMM5ilyGs4dTySeEmKlciTZT6OFHADa5XcAB7Bk47qfguU3CiU6HaYk/vbRJk4zwJ7cQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YycNJpCfM77bIYCXKTPbMZlK9YzsPk/Jxq2Lt026rsQakHs6Am8
	Ko8/UqfU6zSJg0VFgMlk5+3KA2h/5i9u8WULph1xFBr1dFvfTtZQGJ+Cr2IPMdIKrOHLUTUoKrT
	HX64/wm9DUkfzf/lHuz9jexCeXFcBj4xaGNFnsFaE
X-Gm-Gg: ATEYQzxIqosDQeP9Q5WMZAVW+lGg+s8gnYXCq+Pn0WJGHzlYQCyxEdnm38E9VX0MuET
	gY1UqqUShOPkJMJ9CaYqjIyF2AHLjNJ65QlSpJ3eZ4gbq6ueCGuVKWbeKWXA8OTRqZAPt54QrHm
	iM0/K8sHetkiyKfrSUzXWEcf6gg4ZZDmspVFqvgHXnjtFNMwpxghJTy4ORBTXz0y6XReCSVqkO1
	lBbMm0X6oLepDxXxl9q408riCp6HHHonKnBZQQ1wDvH7adf6NbDfU86t89Evi/ombvDk0onQoHF
	AsO3sWT0xwvLFV4ADpQ9HI4NioZqbJSc/2Kd17NlKw==
X-Received: by 2002:a05:6102:3053:b0:5f5:32e2:5ea2 with SMTP id
 ada2fe7eead31-5feb30fc3a8mr3035084137.37.1771890145956; Mon, 23 Feb 2026
 15:42:25 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 15:42:25 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 15:42:25 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 23 Feb 2026 15:42:25 -0800
X-Gm-Features: AaiRm52aDnZI9CEbv5M2DeAz_Eaea7Sv4JJPWItwl1wMCqksqqJ4XC4LTodyGY8
Message-ID: <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-71549-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 85D1A17FF21
X-Rspamd-Action: no action

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/23/26 08:04, Ackerley Tng wrote:
>> Hi,
>>
>> Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
>> all. Hence, st_blocks in the struct populated by a userspace fstat()
>> call on a guest_memfd will always be 0. This patch series makes
>> guest_memfd track the amount of memory allocated on an inode, which
>> allows fstat() to accurately report that on requests from userspace.
>>
>> The inode's i_blocks and i_bytes fields are updated when the folio is
>> associated or disassociated from the guest_memfd inode, which are at
>> allocation and truncation times respectively.
>>
>> To update inode fields at truncation time, this series implements a
>> custom truncation function for guest_memfd. An alternative would be to
>> update truncate_inode_pages_range() to return the number of bytes
>> truncated or add/use some hook.
>>
>> Implementing a custom truncation function was chosen to provide
>> flexibility for handling truncations in future when guest_memfd
>> supports sources of pages other than the buddy allocator. This
>> approach of a custom truncation function also aligns with shmem, which
>> has a custom shmem_truncate_range().
>
> Just wondered how shmem does it: it's through
> dquot_alloc_block_nodirty() / dquot_free_block_nodirty().
>
> It's a shame we can't just use folio_free().

Yup, Hugh pointed out that struct address_space *mapping (and inode) may already
have been freed by the time .free_folio() is called [1].

[1] https://lore.kernel.org/all/7c2677e1-daf7-3b49-0a04-1efdf451379a@google.com/

> Could we maybe have a
> different callback (when the mapping is still guaranteed to be around)
> from where we could update i_blocks on the freeing path?

Do you mean that we should add a new callback to struct
address_space_operations?

.invalidate_folio semantically seems suitable. This is called from
truncate_cleanup_folio() and is conditioned on
folio_needs_release(). guest_memfd could make itself need release, but
IIUC that would cause a NULL pointer dereference in
filemap_release_folio() since try_to_free_buffers() -> drop_buffers()
will dereference folio->private.

From the name, .release_folio sounds eligible, but this is meant for
releasing data attached to a folio, not quite the same as updating inode
fields. This is also not called in the truncation path.

>
> --
> Cheers,
>
> David

