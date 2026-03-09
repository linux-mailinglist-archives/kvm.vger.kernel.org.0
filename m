Return-Path: <kvm+bounces-73327-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wD2wKfjrrmkWKQIAu9opvQ
	(envelope-from <kvm+bounces-73327-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:49:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1C223C076
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 003F03025115
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17463DBD71;
	Mon,  9 Mar 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xI5mH1Ok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF15623AB88
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071114; cv=pass; b=WqGZZD+PtWBqSUlVSYBgCq5QD6/81JRHRYhnn6DbIN8ijjxz3+o0BY2eEZlfcnPe2uLp1ZS+ZTWhgtokY9sEX1kbbnfhWj6DJxsg7v9GoJ4N4Qu/cZkQiPyd7ZSavv06NNB2lvXfjuRhI2TfICvdhyFiaUYOE3YsxJ8BYIBCe5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071114; c=relaxed/simple;
	bh=FQ+rfw6YSM+Ur2t0O+8S8EZHYkkVvAytEeux3uABvPk=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CLyPk1sfIT6EmOcFT/gP/lEhHaVzt0Zo+csFr41twxtjfJl84rC0CDTYVABKAJJRTqxCBQpwAEtOk4G15Ue43mrmhVyabrkhxQ6vmpfreqPEE4O6kC8eEA22CIcwv8SkdvOs+RVP7gAm93sRal7pqEEVn5YCjLla9OMXJXmVrm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xI5mH1Ok; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-5ffca37e8cdso2502223137.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773071112; cv=none;
        d=google.com; s=arc-20240605;
        b=crpPFus59383R5hz8S0iMr2g76RYeY+Dk33DlGfM2zy7LmY5CGAT3wPF0SidLh7GIf
         8SVesiBMDJE5Z/vVMGZIzOFkrP8a4zz+hqLQQX1Xw4kIgEmNSLbqq8Mwb2/x184/sjnE
         vnxheUZzqKBBpyOJptkGDW5drWepJzgmwCyL9A3lZJfXx0d+CU2FGSwYwec+xDkMIW5H
         UPX9u0u/GJ97yDm3zzqwpkxz2wm6NW3kV+B9fb7pgCbAdoMTpeuhQZgh0CENQQUvEH7I
         f4pgJ+ejBvRfKUTVoHCxqZYuynVlEwSGJQzjY9rt1L9Sod/m2V6CPrC6WXZ1o7+2rOge
         aOKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        fh=P6WteVIMEz5nZCiuubsrMVYQ82HtTp/00uXrYehBy8E=;
        b=FRirAm4spScEcCsoRV8bmRhksDaC9Nh8mMvKVPXPnOueXzvqcupBjDFhi+5S7kKSdh
         jtfA05vt2y9eRVZXiRrw70kw3WYE84FeSuciioU/pd1zviMzIHUFm+PCS01MgbUOnDB7
         d2h7PXTj6oQMMoQsl5dhSurxVsuFEuR9sH/HpsEzc6f6MhA4/GAoHNGOeV4bqFr026Ai
         1fIR/X8jT1WTo3CbwKHZrwPqdz5gwdDLM7qoI867KyHEFQZB0ic8r4eOid5Ho2pB1OOq
         I6dmcn+WqrAlVi5cU+GeXb0OcA4xJAgMvWoGtk3eg+f2jHZu6zIVyWOxmKnayx7PixXm
         pf+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773071112; x=1773675912; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        b=xI5mH1OkbEx5rEciwSIW1r8sSiLBgdGlSOlZdRK6ui/M4nAvFHW8cqdINYfAXsV8uG
         nI8bSnfXg0WmJyzGTT4KYmmik5uOhjiWXFNNN14RCQ6kfG8md8JpD12d9PnsFp8CBb1s
         M8dPVYwMPiKqykvvLzCaRCNuF6x88XCJz0UtP/nxZjLTELP5LxX3WZ9mmh4rvorqeHDC
         FyXPy7Jpc0aPA/cTi1HrTrP/p+3xCtoe/TNwAtZwTewTH8loPRekj2HfeUsE0o5Y8BdT
         E9EMgjx38u6ekuFmEvOkfZ9NWw8lFW9GeB+xS0zv/EBLsB1y0gkdSa1SZtV4LgVKrjRb
         EGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071112; x=1773675912;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKp7UfWwsR+Qtr2/5qSzMlZ35ZQUtFxqOaPiGk/f9/o=;
        b=NYiymgyZXV3KbPV4HEnOjhQfha7V1TJ6ocqXuuVawR8700jekc4CBJR3PO+FSTraDE
         t1+SspABrtblI995dzhuB5WwqiyuxOLgWTCErOB+mgZV8YavAlpbHTO+5Wt73h+XM43w
         O550V2sC8m5xqvio+tMEpUPsU+TZUyRcXoCv7Wbwq+fZA4IrX+rrCkZOMmeHmRDc+cRL
         xYwinQuVJwpEdm4/ZJqbHGSbVdPx0kcYTzY1tRYR3BO43Gi3pON2hiN+Q5J7jkTreyek
         28NUxS9aHh8XU3l5YtUdq4y74KtYDvUp/S+TptN4va2lubYIICn8e/6Byy8TyYZgfLfE
         nfiQ==
X-Gm-Message-State: AOJu0YyQGyu+PecyrZLeX3KfmyYYkOl2OWSLA3o4gIqWoUy8a8v783cW
	XtDmebjrZ9jUby31z+tJ+M3hemyEVhOW5B0HTfDWHp2JjbrLpRPAV+9Wc8T4VHHMXrULlbXjenT
	YSpn+f+XEPcAgw9khE/bksLuuJ1/XG6rWiMoWSvdc
X-Gm-Gg: ATEYQzzkX6R7rc1NOmU+VcFIuqiNx8ZsPeNc8xIQxT0Wi3IR1mcdJIFu1FvEQ9RGo8C
	PQPKTLQkaGO19/+C5MFGxfzupLFK65cefxVB9C1upiZaqou0MwjE4B+G96atWJ5t3JiyPooIz+x
	xpsgIXVDFBZ49Vr2NNcd2wtlD9XAyrpYR+D+BQgLYjgFN80hrTjw+OC4wAVSxGxVeGC8rPUjyqF
	6u2boozNqjzdHbBWGimxwKWQfQ1OIFDkQcN3yPzZ1GUnDb7xk9d3sOzqzOwTx8DDP9v9VRhXHF6
	fwEcyjNsQd9sy4uBt2FqogrwOQRjj8k1zoLeU88Esg==
X-Received: by 2002:a05:6102:ccf:b0:600:131f:b68a with SMTP id
 ada2fe7eead31-600131fe1bemr2252059137.23.1773071109964; Mon, 09 Mar 2026
 08:45:09 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 08:45:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 08:45:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <577c4725-7eda-4693-a55a-413572541161@kernel.org>
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com> <577c4725-7eda-4693-a55a-413572541161@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 08:45:09 -0700
X-Gm-Features: AaiRm50NI2W_b1s4wqVK3z2E19_F4wrYli0WrzITukeFFAKkCo-7bYk8Lb2_YMI
Message-ID: <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8B1C223C076
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73327-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.951];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 3/9/26 10:53, Ackerley Tng wrote:
>> The guest memfd currently does not update the inode's i_blocks and i_bytes
>> count when memory is allocated or freed. Hence, st_blocks returned from
>> fstat() is always 0.
>>
>> Introduce byte accounting for guest memfd inodes.  When a new folio is
>> added to the filemap, add the folio's size.  Use the .invalidate_folio()
>> callback to subtract the folio's size from inode fields when folios are
>> truncated and removed from the filemap.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 462c5c5cb602a..77219551056a7 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>>  					 mapping_gfp_mask(inode->i_mapping), policy);
>>  	mpol_cond_put(policy);
>>
>> +	if (!IS_ERR(folio))
>> +		inode_add_bytes(inode, folio_size(folio));
>> +
>
> Can't we have two concurrent calls to __filemap_get_folio_mpol(), and we
> don't really know whether our call allocated the folio or simply found
> one (the other caller allocated) in the pagecache?
>

Ah that is true. Two threads can get past filemap_lock_folio(), then get
to __filemap_get_folio_mpol(), and then thread 1 will return from
__filemap_get_folio_mpol() with an allocated folio while thread 2
returns with the folio allocated by thread 1. Both threads would end up
incrementing the number of bytes in the inode.

Sean, Vlastimil, is this a good argument for open coding, like in RFC v2
[1]? So that guest_memfd can do inode_add_bytes() specifically when the
folio is added to the filemap.

An alternative I can think of is to add a callback that is called from
within __filemap_add_folio(). Would that be preferred?

[1] https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com/

> --
> Cheers,
>
> David

