Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030CD12294D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 11:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfLQK6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 05:58:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727152AbfLQK6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 05:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576580309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gnDnyB2jtO59Y8NkYIvH0FNcLlZM59GdQIgIToL5nhQ=;
        b=IDP9RvcA8txYqo4DN24GgGk5wjs2hO3uJ3eBqoDaCg2vpGa1jGdkOyyx+edSWo1wH2fxn5
        v9gZU7+DAqwCX8wOn5cO0PR6y4vu1C0WjSKV3A6GDcaOksjsssFhEmDqW3XnHkIwwmoBAf
        7FdgufyLLAAPF6ou2rHR0StpLoQr4hM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-Cif9SJ0kNVaETmQD8Yl4Mg-1; Tue, 17 Dec 2019 05:58:28 -0500
X-MC-Unique: Cif9SJ0kNVaETmQD8Yl4Mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5763107ACC7;
        Tue, 17 Dec 2019 10:58:25 +0000 (UTC)
Received: from [10.36.118.8] (unknown [10.36.118.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185FF620A7;
        Tue, 17 Dec 2019 10:58:13 +0000 (UTC)
Subject: Re: [PATCH v15 3/7] mm: Add function __putback_isolated_page
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <20191205162230.19548.70198.stgit@localhost.localdomain>
 <cb49bbc7-b0c0-65cc-1d9d-a3aaef075650@redhat.com>
 <9eb9173278370dd604c4cefd30ed10be36600854.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8a4b0337-0bad-2978-32e8-6f90c7365f00@redhat.com>
Date:   Tue, 17 Dec 2019 11:58:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9eb9173278370dd604c4cefd30ed10be36600854.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.12.19 17:22, Alexander Duyck wrote:
> On Mon, 2019-12-16 at 12:36 +0100, David Hildenbrand wrote:
>> [...]
>>> +/**
>>> + * __putback_isolated_page - Return a now-isolated page back where w=
e got it
>>> + * @page: Page that was isolated
>>> + * @order: Order of the isolated page
>>> + *
>>> + * This function is meant to return a page pulled from the free list=
s via
>>> + * __isolate_free_page back to the free lists they were pulled from.
>>> + */
>>> +void __putback_isolated_page(struct page *page, unsigned int order)
>>> +{
>>> +	struct zone *zone =3D page_zone(page);
>>> +	unsigned long pfn;
>>> +	unsigned int mt;
>>> +
>>> +	/* zone lock should be held when this function is called */
>>> +	lockdep_assert_held(&zone->lock);
>>> +
>>> +	pfn =3D page_to_pfn(page);
>>> +	mt =3D get_pfnblock_migratetype(page, pfn);
>>
>> IMHO get_pageblock_migratetype() would be nicer - I guess the compiler
>> will optimize out the double page_to_pfn().
>=20
> The thing is I need the page_to_pfn call already in order to pass the
> value to __free_one_page. With that being the case why not juse use
> get_pfnblock_migratetype?

I was reading
	set_pageblock_migratetype(page, migratetype);
And wondered why we don't use straight forward
	get_pageblock_migratetype()
but instead something that looks like a micro-optimization

>=20
> Also there are some scenarios where __page_to_pfn is not that simple a
> call with us having to get the node ID so we can find the pgdat structu=
re
> to perform the calculation. I'm not sure the compiler would be ble to
> figure out that the result is the same for both calls, so it is better =
to
> make it explicit.

Only in case of CONFIG_SPARSEMEM we have to go via the section - but I
doubt this is really worth optimizing here.

But yeah, I'm fine with this change, only "IMHO
get_pageblock_migratetype() would be nicer" :)

>=20
>>> +
>>> +	/* Return isolated page to tail of freelist. */
>>> +	__free_one_page(page, pfn, zone, order, mt);
>>> +}
>>> +
>>>  /*
>>>   * Update NUMA hit/miss statistics
>>>   *
>>> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
>>> index 04ee1663cdbe..d93d2be0070f 100644
>>> --- a/mm/page_isolation.c
>>> +++ b/mm/page_isolation.c
>>> @@ -134,13 +134,11 @@ static void unset_migratetype_isolate(struct pa=
ge *page, unsigned migratetype)
>>>  		__mod_zone_freepage_state(zone, nr_pages, migratetype);
>>>  	}
>>>  	set_pageblock_migratetype(page, migratetype);
>>> +	if (isolated_page)
>>> +		__putback_isolated_page(page, order);
>>>  	zone->nr_isolate_pageblock--;
>>>  out:
>>>  	spin_unlock_irqrestore(&zone->lock, flags);
>>> -	if (isolated_page) {
>>> -		post_alloc_hook(page, order, __GFP_MOVABLE);
>>> -		__free_pages(page, order);
>>> -	}
>>
>> So If I get it right:
>>
>> post_alloc_hook() does quite some stuff like
>> - arch_alloc_page(page, order);
>> - kernel_map_pages(page, 1 << order, 1)
>> - kasan_alloc_pages()
>> - kernel_poison_pages(1)
>> - set_page_owner()
>>
>> Which free_pages_prepare() will undo, like
>> - reset_page_owner()
>> - kernel_poison_pages(0)
>> - arch_free_page()
>> - kernel_map_pages()
>> - kasan_free_nondeferred_pages()
>>
>> Both would be skipped now - which sounds like the right thing to do IM=
HO
>> (and smells like quite a performance improvement). I haven't verified =
if
>> actually everything we skip in free_pages_prepare() is safe (I think i=
t
>> is, it seems to be mostly relevant for actually used/allocated pages).
>=20
> That was kind of my thought on this. Basically the logic I was followin=
g
> was that the code path will call move_freepages_block that bypasses all=
 of
> the above mentioned calls if the pages it is moving will not be merged.=
 If
> it is safe in that case my assumption is that it should be safe to just
> call __putback_isolated_page in such a case as it also bypasses the blo=
ck
> above, but it supports merging the page with other pages that are alrea=
dy
> on the freelist.

Makes sense to me

Acked-by: David Hildenbrand <david@redhat.com>


--=20
Thanks,

David / dhildenb

