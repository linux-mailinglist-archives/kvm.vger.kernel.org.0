Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC016EE55
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 19:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbgBYSti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 13:49:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51952 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727983AbgBYSth (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 13:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582656575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=0U2YIjcaH0sfDbbfCVMq4B9fMc4mFyqws5g8Fj7EgeU=;
        b=fZV0fd6W2yfWNapbPXgaS2PC1dR/ohv1yVuh3JJrLkn8PimHMJuScszAQVvHElc1SN7ue6
        aKHjEM4eiytEp/DIIXo8c6w0KKeA7L5+Um9HUWLw8s6TaBXq/eoEYWZGXjI0GnTckID3Wa
        41SRqVr6xn0bs4P28j2ZRDyGjnAfMAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-mEPfYc_cPrak1wILQNMV6A-1; Tue, 25 Feb 2020 13:49:32 -0500
X-MC-Unique: mEPfYc_cPrak1wILQNMV6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADB381005512;
        Tue, 25 Feb 2020 18:49:29 +0000 (UTC)
Received: from [10.36.117.12] (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C7CA1001DC0;
        Tue, 25 Feb 2020 18:49:22 +0000 (UTC)
Subject: Re: [PATCH RFC v4 06/13] mm: Allow to offline unmovable PageOffline()
 pages via MEM_GOING_OFFLINE
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Qian Cai <cai@lca.pw>, Pingfan Liu <kernelfans@gmail.com>
References: <20191212171137.13872-1-david@redhat.com>
 <20191212171137.13872-7-david@redhat.com>
 <6ec496580ddcb629d22589a1cba8cd61cbd53206.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <267ea186-aba8-1a93-bd55-ac641f78d07e@redhat.com>
Date:   Tue, 25 Feb 2020 19:49:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6ec496580ddcb629d22589a1cba8cd61cbd53206.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>  /*
>>   * Scan pfn range [start,end) to find movable/migratable pages (LRU p=
ages,
>> - * non-lru movable pages and hugepages). We scan pfn because it's muc=
h
>> - * easier than scanning over linked list. This function returns the p=
fn
>> - * of the first found movable page if it's found, otherwise 0.
>> + * non-lru movable pages and hugepages).
>> + *
>> + * Returns:
>> + *	0 in case a movable page is found and movable_pfn was updated.
>> + *	-ENOENT in case no movable page was found.
>> + *	-EBUSY in case a definetly unmovable page was found.
>>   */
>> -static unsigned long scan_movable_pages(unsigned long start, unsigned=
 long end)
>> +static int scan_movable_pages(unsigned long start, unsigned long end,
>> +			      unsigned long *movable_pfn)
>>  {
>>  	unsigned long pfn;
>> =20
>> @@ -1247,18 +1251,29 @@ static unsigned long scan_movable_pages(unsign=
ed long start, unsigned long end)
>>  			continue;
>>  		page =3D pfn_to_page(pfn);
>>  		if (PageLRU(page))
>> -			return pfn;
>> +			goto found;
>>  		if (__PageMovable(page))
>> -			return pfn;
>> +			goto found;
>> +
>> +		/*
>> +		 * Unmovable PageOffline() pages where somebody still holds
>> +		 * a reference count (after MEM_GOING_OFFLINE) can definetly
>> +		 * not be offlined.
>> +		 */
>> +		if (PageOffline(page) && page_count(page))
>> +			return -EBUSY;
>=20
> So the comment confused me a bit because technically this function isn'=
t
> about offlining memory, it is about finding movable pages. I had to do =
a
> bit of digging to find the only consumer is __offline_pages, but if we =
are
> going to talk about "offlining" instead of "moving" in this function it
> might make sense to rename it.

Well, it's contained in memory_hotplug.c, and the only user of moving
pages around in there is offlining code :) And it's job is to locate
movable pages, skip over some (temporary? unmovable ones) and (now)
indicate definitely unmovable ones.

Any idea for a better name?
scan_movable_pages_and_stop_on_definitely_unmovable() is not so nice :)


>=20
>> =20
>>  		if (!PageHuge(page))
>>  			continue;
>>  		head =3D compound_head(page);
>>  		if (page_huge_active(head))
>> -			return pfn;
>> +			goto found;
>>  		skip =3D compound_nr(head) - (page - head);
>>  		pfn +=3D skip - 1;
>>  	}
>> +	return -ENOENT;
>> +found:
>> +	*movable_pfn =3D pfn;
>>  	return 0;
>>  }
>=20
> So I am looking at this function and it seems like your change complete=
ly
> changes the behavior. The code before would walk the entire range and i=
f
> at least 1 page was available to move you would return the PFN of that
> page. Now what seems to happen is that you will return -EBUSY as soon a=
s
> you encounter an offline page with a page count. I would think that wou=
ld
> slow down the offlining process since you have made the Unmovable
> PageOffline() page a head of line blocker that you have to wait to get
> around.

So, the comment says "Unmovable PageOffline() pages where somebody still
holds a reference count (after MEM_GOING_OFFLINE) can definitely not be
offlined". And the doc "-EBUSY in case a definitely unmovable page was
found."

So why would this make offlining slow? Offlining will be aborted,
because offlining is not possible.

Please note that this is the exact old behavior, where isolating the
page range would have failed directly and offlining would have been
aborted early. The old offlining failure in the case in the offlining
path would have been "failure to isolate range".

Also, note that the users of PageOffline() with unmovable pages are very
rare (only balloon drivers for now).

>=20
> Would it perhaps make more sense to add a return value initialized to
> ENOENT, and if you encounter one of these offline pages you change the
> return value to EBUSY, and then if you walk through the entire list
> without finding a movable page you just return the value?

Did you have a look in  which context this function is used, especially
[1] and [2]?

>=20
> Otherwise you might want to add a comment explaining why the function
> should stall instead of skipping over the unmovable section that will
> hopefully become movable later.

So we have "-EBUSY in case a definitely unmovable page was found.". Do
you have a better suggestion?

>=20
>> @@ -1528,7 +1543,8 @@ static int __ref __offline_pages(unsigned long s=
tart_pfn,
>>  	}
>> =20
>>  	do {
>> -		for (pfn =3D start_pfn; pfn;) {
>> +		pfn =3D start_pfn;
>> +		do {
>>  			if (signal_pending(current)) {
>>  				ret =3D -EINTR;
>>  				reason =3D "signal backoff";
>> @@ -1538,14 +1554,19 @@ static int __ref __offline_pages(unsigned long=
 start_pfn,
>>  			cond_resched();
>>  			lru_add_drain_all();
>> =20
>> -			pfn =3D scan_movable_pages(pfn, end_pfn);
>> -			if (pfn) {
>> +			ret =3D scan_movable_pages(pfn, end_pfn, &pfn);
>> +			if (!ret) {
>>  				/*
>>  				 * TODO: fatal migration failures should bail
>>  				 * out
>>  				 */
>>  				do_migrate_range(pfn, end_pfn);
>>  			}

[1] we detect a definite offlining blocker and

>> +		} while (!ret);
>> +
>> +		if (ret !=3D -ENOENT) {
>> +			reason =3D "unmovable page";

[2] we abort offlining

>> +			goto failed_removal_isolated;
>>  		}
>> =20
>>  		/*
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 5334decc9e06..840c0bbe2d9f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -8256,6 +8256,19 @@ bool has_unmovable_pages(struct zone *zone, str=
uct page *page, int count,
>>  		if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
>>  			continue;
>> =20
>> +		/*
>> +		 * We treat all PageOffline() pages as movable when offlining
>> +		 * to give drivers a chance to decrement their reference count
>> +		 * in MEM_GOING_OFFLINE in order to signalize that these pages
>=20
> You can probably just use "signal" or "indicate" instead of "signalize"=
.

Makes sense, "indicate" it is!

Thanks!

--=20
Thanks,

David / dhildenb

