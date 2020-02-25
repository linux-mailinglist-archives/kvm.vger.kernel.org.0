Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645AD16F283
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 23:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBYWTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 17:19:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726827AbgBYWTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 17:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582669178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gCSArIx/3mY9oSIUMRjqx2+R3OvuPX6j2QVZuQeM+/k=;
        b=GHTS+twZm7rThRIRTIan3iEXMMTE22tyYPOnP0HDibeyc2iN4QA6J8xVzZ1eYEGNgIeo+K
        7uAiQ0surOa3O/HWcIpbGl7SRFRIWJ8ODZEUJFjwTawr+RMy0bdb6WUWsvDPvlBZ5lnZaf
        3Gpy7M1+EAIUHt9prW1N6Fy/s0U60to=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-W7WYJUYZNry96hYG-fYhtA-1; Tue, 25 Feb 2020 17:19:30 -0500
X-MC-Unique: W7WYJUYZNry96hYG-fYhtA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AE78107ACC4;
        Tue, 25 Feb 2020 22:19:27 +0000 (UTC)
Received: from [10.36.117.12] (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA1208B759;
        Tue, 25 Feb 2020 22:19:18 +0000 (UTC)
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
 <267ea186-aba8-1a93-bd55-ac641f78d07e@redhat.com>
 <3d719897039273a2bb8d0fe7d12563498ebd2897.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <e0892179-b14c-84c3-1284-fc789f16e1c7@redhat.com>
Date:   Tue, 25 Feb 2020 23:19:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3d719897039273a2bb8d0fe7d12563498ebd2897.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.02.20 22:46, Alexander Duyck wrote:
> On Tue, 2020-02-25 at 19:49 +0100, David Hildenbrand wrote:
>>>>  /*
>>>>   * Scan pfn range [start,end) to find movable/migratable pages (LRU=
 pages,
>>>> - * non-lru movable pages and hugepages). We scan pfn because it's m=
uch
>>>> - * easier than scanning over linked list. This function returns the=
 pfn
>>>> - * of the first found movable page if it's found, otherwise 0.
>>>> + * non-lru movable pages and hugepages).
>>>> + *
>>>> + * Returns:
>>>> + *	0 in case a movable page is found and movable_pfn was updated.
>>>> + *	-ENOENT in case no movable page was found.
>>>> + *	-EBUSY in case a definetly unmovable page was found.
>>>>   */
>>>> -static unsigned long scan_movable_pages(unsigned long start, unsign=
ed long end)
>>>> +static int scan_movable_pages(unsigned long start, unsigned long en=
d,
>>>> +			      unsigned long *movable_pfn)
>>>>  {
>>>>  	unsigned long pfn;
>>>> =20
>>>> @@ -1247,18 +1251,29 @@ static unsigned long scan_movable_pages(unsi=
gned long start, unsigned long end)
>>>>  			continue;
>>>>  		page =3D pfn_to_page(pfn);
>>>>  		if (PageLRU(page))
>>>> -			return pfn;
>>>> +			goto found;
>>>>  		if (__PageMovable(page))
>>>> -			return pfn;
>>>> +			goto found;
>>>> +
>>>> +		/*
>>>> +		 * Unmovable PageOffline() pages where somebody still holds
>>>> +		 * a reference count (after MEM_GOING_OFFLINE) can definetly
>>>> +		 * not be offlined.
>>>> +		 */
>>>> +		if (PageOffline(page) && page_count(page))
>>>> +			return -EBUSY;
>>>
>>> So the comment confused me a bit because technically this function is=
n't
>>> about offlining memory, it is about finding movable pages. I had to d=
o a
>>> bit of digging to find the only consumer is __offline_pages, but if w=
e are
>>> going to talk about "offlining" instead of "moving" in this function =
it
>>> might make sense to rename it.
>>
>> Well, it's contained in memory_hotplug.c, and the only user of moving
>> pages around in there is offlining code :) And it's job is to locate
>> movable pages, skip over some (temporary? unmovable ones) and (now)
>> indicate definitely unmovable ones.
>>
>> Any idea for a better name?
>> scan_movable_pages_and_stop_on_definitely_unmovable() is not so nice :=
)
>=20
> I dunno. What I was getting at is that the wording here would make it
> clearer if you simply stated that these pages "can definately not be
> moved". Saying you cannot offline a page that is PageOffline seems kind=
 of
> redundant, then again calling it an Unmovable and then saying it cannot=
 be
> moves is also redundant I suppose. In the end you don't move them, but

So, in summary, there are
- PageOffline() pages that are movable (balloon compaction).
- PageOffline() pages that cannot be moved and cannot be offlined (e.g.,
  no balloon compaction enabled, XEN, HyperV, ...) . page_count(page) >=3D
  0
- PageOffline() pages that cannot be moved, but can be offlined.
  page_count(page) =3D=3D 0.


> they can be switched to offline if the page count hits 0. When that
> happens you simply end up skipping over them in the code for
> __test_page_isolated_in_pageblock and __offline_isolated_pages.

Yes. The thing with the wording is that pages with (PageOffline(page) &&
!page_count(page)) can also not really be moved, but they can be skipped
when offlining. If we call that "moving them to /dev/null", then yes,
they can be moved to some degree :)

I can certainly do here e.g.,

/*
 * PageOffline() pages that are not marked __PageMovable() and have a
 * reference count > 0 (after MEM_GOING_OFFLINE) are definitely
 * unmovable. If their reference count would be 0, they could be skipped
 * when offlining memory sections.
 */

And maybe I'll add to the function doc, that unmovable pages that are
skipped in this function can include pages that can be skipped when
offlining (moving them to nirvana).

Other suggestions?

[...]

>>
>> [1] we detect a definite offlining blocker and
>>
>>>> +		} while (!ret);
>>>> +
>>>> +		if (ret !=3D -ENOENT) {
>>>> +			reason =3D "unmovable page";
>>
>> [2] we abort offlining
>>
>>>> +			goto failed_removal_isolated;
>>>>  		}
>>>> =20
>>>>  		/*
>=20
> Yeah, this is the piece I misread.  I knew the loop this was in previou=
sly
> was looping when returning -ENOENT so for some reason I had it in my he=
ad
> that you were still looping on -EBUSY.

Ah okay, I see. Yeah, that wouldn't make sense for the use case I have :)

>=20
> So the one question I would have is if at this point are we guaranteed
> that the balloon drivers have already taken care of the page count for =
all
> the pages they set to PageOffline? Based on the patch description I was
> thinking that this was going to be looping for a while waiting for the
> driver to clear the pages and then walking through them at the end of t=
he
> loop via check_pages_isolated_cb.

So, e.g., the patch description states

"Let's allow to do that by allowing to isolate any PageOffline() page
when offlining. This way, we can reach the memory hotplug notifier
MEM_GOING_OFFLINE, where the driver can signal that he is fine with
offlining this page by dropping its reference count."

Any balloon driver that does not allow offlining (e.g., XEN, HyperV,
virtio-balloon), will always have a refcount of (at least) 1. Drivers
that want to make use of that (esp. virtio-mem, but eventually also
HyperV), will drop their refcount via the MEM_GOING_OFFLINE call.

So yes, at this point, all applicable users were notified via
MEM_GOING_OFFLINE and had their chance to decrement the refcount. If
they didn't, offlining will be aborted.

Thanks again!

--=20
Thanks,

David / dhildenb

