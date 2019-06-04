Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD98B34DDF
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfFDQmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbfFDQmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:42:51 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABA292F8BE7;
        Tue,  4 Jun 2019 16:42:45 +0000 (UTC)
Received: from [10.40.205.182] (unknown [10.40.205.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59EC052F9;
        Tue,  4 Jun 2019 16:42:24 +0000 (UTC)
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-2-nitesh@redhat.com>
 <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
 <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com>
 <CAKgT0Ud6uKpcj9HFHYOThCY=0_P0=quBLbsDR7uUMdbwcYeSTw@mail.gmail.com>
 <09e6caea-7000-b3e4-d297-df6bea78e127@redhat.com>
 <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <13b96507-6347-1702-7822-6efb0f1bbf20@redhat.com>
Date:   Tue, 4 Jun 2019 12:42:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jf1umoW1bcFaPAaBAQpdkCcXl2MICRVIC"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 04 Jun 2019 16:42:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jf1umoW1bcFaPAaBAQpdkCcXl2MICRVIC
Content-Type: multipart/mixed; boundary="hDVCrsXT6XY2ZnqUvudAAxDzhZ69HDqzd";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Paolo Bonzini <pbonzini@redhat.com>,
 lcapitulino@redhat.com, pagupta@redhat.com, wei.w.wang@intel.com,
 Yang Zhang <yang.zhang.wz@gmail.com>, Rik van Riel <riel@surriel.com>,
 David Hildenbrand <david@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 dodgen@google.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Message-ID: <13b96507-6347-1702-7822-6efb0f1bbf20@redhat.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-2-nitesh@redhat.com>
 <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
 <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com>
 <CAKgT0Ud6uKpcj9HFHYOThCY=0_P0=quBLbsDR7uUMdbwcYeSTw@mail.gmail.com>
 <09e6caea-7000-b3e4-d297-df6bea78e127@redhat.com>
 <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>
In-Reply-To: <CAKgT0UeMpcckGpT6OnC2kqgtyT2p9bvNgE2C0eqW1GOJTU-DHA@mail.gmail.com>

--hDVCrsXT6XY2ZnqUvudAAxDzhZ69HDqzd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/4/19 12:25 PM, Alexander Duyck wrote:
> On Tue, Jun 4, 2019 at 9:08 AM Nitesh Narayan Lal <nitesh@redhat.com> w=
rote:
>>
>> On 6/4/19 11:14 AM, Alexander Duyck wrote:
>>> On Tue, Jun 4, 2019 at 5:55 AM Nitesh Narayan Lal <nitesh@redhat.com>=
 wrote:
>>>> On 6/3/19 3:04 PM, Alexander Duyck wrote:
>>>>> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.c=
om> wrote:
>>>>>> This patch introduces the core infrastructure for free page hintin=
g in
>>>>>> virtual environments. It enables the kernel to track the free page=
s which
>>>>>> can be reported to its hypervisor so that the hypervisor could
>>>>>> free and reuse that memory as per its requirement.
>>>>>>
>>>>>> While the pages are getting processed in the hypervisor (e.g.,
>>>>>> via MADV_FREE), the guest must not use them, otherwise, data loss
>>>>>> would be possible. To avoid such a situation, these pages are
>>>>>> temporarily removed from the buddy. The amount of pages removed
>>>>>> temporarily from the buddy is governed by the backend(virtio-ballo=
on
>>>>>> in our case).
>>>>>>
>>>>>> To efficiently identify free pages that can to be hinted to the
>>>>>> hypervisor, bitmaps in a coarse granularity are used. Only fairly =
big
>>>>>> chunks are reported to the hypervisor - especially, to not break u=
p THP
>>>>>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The=
 bits
>>>>>> in the bitmap are an indication whether a page *might* be free, no=
t a
>>>>>> guarantee. A new hook after buddy merging sets the bits.
>>>>>>
>>>>>> Bitmaps are stored per zone, protected by the zone lock. A workque=
ue
>>>>>> asynchronously processes the bitmaps, trying to isolate and report=
 pages
>>>>>> that are still free. The backend (virtio-balloon) is responsible f=
or
>>>>>> reporting these batched pages to the host synchronously. Once repo=
rting/
>>>>>> freeing is complete, isolated pages are returned back to the buddy=
=2E
>>>>>>
>>>>>> There are still various things to look into (e.g., memory hotplug,=
 more
>>>>>> efficient locking, possible races when disabling).
>>>>>>
>>>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>>>> So one thing I had thought about, that I don't believe that has bee=
n
>>>>> addressed in your solution, is to determine a means to guarantee
>>>>> forward progress. If you have a noisy thread that is allocating and=

>>>>> freeing some block of memory repeatedly you will be stuck processin=
g
>>>>> that and cannot get to the other work. Specifically if you have a z=
one
>>>>> where somebody is just cycling the number of pages needed to fill y=
our
>>>>> hinting queue how do you get around it and get to the data that is
>>>>> actually code instead of getting stuck processing the noise?
>>>> It should not matter. As every time the memory threshold is met, ent=
ire
>>>> bitmap
>>>> is scanned and not just a chunk of memory for possible isolation. Th=
is
>>>> will guarantee
>>>> forward progress.
>>> So I think there may still be some issues. I see how you go from the
>>> start to the end, but how to you loop back to the start again as page=
s
>>> are added? The init_hinting_wq doesn't seem to have a way to get back=

>>> to the start again if there is still work to do after you have
>>> completed your pass without queue_work_on firing off another thread.
>>>
>> That will be taken care as the part of a new job, which will be
>> en-queued as soon
>> as the free memory count for the respective zone will reach the thresh=
old.
> So does that mean that you have multiple threads all calling
> queue_work_on until you get below the threshold?
Every time a page of order MAX_ORDER - 2 is added to the buddy, free
memory count will be incremented if the bit is not already set and its
value will be checked against the threshold.
>  If so it seems like
> that would get expensive since that is an atomic test and set
> operation that would be hammered until you get below that threshold.

Not sure if I understood "until you get below that threshold".
Can you please explain?
test_and_set_bit() will be called every time a page with MAX_ORDER -2
order is added to the buddy. (Not already hinted)


--=20
Regards
Nitesh


--hDVCrsXT6XY2ZnqUvudAAxDzhZ69HDqzd--

--jf1umoW1bcFaPAaBAQpdkCcXl2MICRVIC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz2n20ACgkQo4ZA3AYy
ozmdDRAAk+lwKdGjRKO3i+yCypPjo6aKDjJ5F4vchzVyvZ8mswaTucpjf3YbljB9
n3FDj0nRISWOuk7ySVX/xFPBAWqWvIpb5HKCp/2ciK2uxuGBSnzpxSvyRQ2uSxmS
fiegjiI3D2IPn6xFi6e5/Jt1zl1xz6W+DSfRHubRYU9nTiEpKzvSZ/DRC+CgUt8f
5A/F8Am+iKV1SCcwU/V0jp3T+w3Pj/qS/RwVm0l45aVc+f64nd008jzLWRo+XCTH
Su2Q9w/6jztle6XPkxWq9JkZT3BZzKfDyrX2KdmWjdPvpTkx9lUUTlha/ly4FkW8
H+H0DSZLR+KRlZb1YF7qUtzzMBDstNFGr8QWwEJ2y7bSjwZ1HPut3DTudGlfwcja
FL1bXALqy1KDN019sK+8Xiy4j/eZMxzpWBFoo1k8aB4x/OZDHH65Vxr67DshAfEf
k5hso0+j1mUqIzEWqaLiNd4lSs46cfJEB7oVrfLUKdZDE22eS6OP73LMnYM1ooAh
fygV+Ii0Iv4TLdevo23E83VKfdWJVY3n6jXqJwZLwoGxLUGKReRNbNREE7an6UjG
xUulUGbH7TKrGq0RAIMCojAiVg+Er4JQlOzLsopuup56gsUrFJNrKvSUPCX4gJKJ
Jbrq1bh0zkfV1QMl/2Nll1MGr6oaIt/Lyb+iUfzHGB6zCYXUelg=
=RfpA
-----END PGP SIGNATURE-----

--jf1umoW1bcFaPAaBAQpdkCcXl2MICRVIC--
