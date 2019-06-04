Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3881B3475F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 14:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfFDMzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 08:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbfFDMzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 08:55:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C43A78E3EA;
        Tue,  4 Jun 2019 12:55:31 +0000 (UTC)
Received: from [10.40.205.182] (unknown [10.40.205.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FEF75B684;
        Tue,  4 Jun 2019 12:55:13 +0000 (UTC)
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
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFl4pQoBEADT/nXR2JOfsCjDgYmE2qonSGjkM1g8S6p9UWD+bf7YEAYYYzZsLtbilFTe
 z4nL4AV6VJmC7dBIlTi3Mj2eymD/2dkKP6UXlliWkq67feVg1KG+4UIp89lFW7v5Y8Muw3Fm
 uQbFvxyhN8n3tmhRe+ScWsndSBDxYOZgkbCSIfNPdZrHcnOLfA7xMJZeRCjqUpwhIjxQdFA7
 n0s0KZ2cHIsemtBM8b2WXSQG9CjqAJHVkDhrBWKThDRF7k80oiJdEQlTEiVhaEDURXq+2XmG
 jpCnvRQDb28EJSsQlNEAzwzHMeplddfB0vCg9fRk/kOBMDBtGsTvNT9OYUZD+7jaf0gvBvBB
 lbKmmMMX7uJB+ejY7bnw6ePNrVPErWyfHzR5WYrIFUtgoR3LigKnw5apzc7UIV9G8uiIcZEn
 C+QJCK43jgnkPcSmwVPztcrkbC84g1K5v2Dxh9amXKLBA1/i+CAY8JWMTepsFohIFMXNLj+B
 RJoOcR4HGYXZ6CAJa3Glu3mCmYqHTOKwezJTAvmsCLd3W7WxOGF8BbBjVaPjcZfavOvkin0u
 DaFvhAmrzN6lL0msY17JCZo046z8oAqkyvEflFbC0S1R/POzehKrzQ1RFRD3/YzzlhmIowkM
 BpTqNBeHEzQAlIhQuyu1ugmQtfsYYq6FPmWMRfFPes/4JUU/PQARAQABtCVOaXRlc2ggTmFy
 YXlhbiBMYWwgPG5pbGFsQHJlZGhhdC5jb20+iQI9BBMBCAAnBQJZeKUKAhsjBQkJZgGABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEKOGQNwGMqM56lEP/A2KMs/pu0URcVk/kqVwcBhU
 SnvB8DP3lDWDnmVrAkFEOnPX7GTbactQ41wF/xwjwmEmTzLrMRZpkqz2y9mV0hWHjqoXbOCS
 6RwK3ri5e2ThIPoGxFLt6TrMHgCRwm8YuOSJ97o+uohCTN8pmQ86KMUrDNwMqRkeTRW9wWIQ
 EdDqW44VwelnyPwcmWHBNNb1Kd8j3xKlHtnS45vc6WuoKxYRBTQOwI/5uFpDZtZ1a5kq9Ak/
 MOPDDZpd84rqd+IvgMw5z4a5QlkvOTpScD21G3gjmtTEtyfahltyDK/5i8IaQC3YiXJCrqxE
 r7/4JMZeOYiKpE9iZMtS90t4wBgbVTqAGH1nE/ifZVAUcCtycD0f3egX9CHe45Ad4fsF3edQ
 ESa5tZAogiA4Hc/yQpnnf43a3aQ67XPOJXxS0Qptzu4vfF9h7kTKYWSrVesOU3QKYbjEAf95
 NewF9FhAlYqYrwIwnuAZ8TdXVDYt7Z3z506//sf6zoRwYIDA8RDqFGRuPMXUsoUnf/KKPrtR
 ceLcSUP/JCNiYbf1/QtW8S6Ca/4qJFXQHp0knqJPGmwuFHsarSdpvZQ9qpxD3FnuPyo64S2N
 Dfq8TAeifNp2pAmPY2PAHQ3nOmKgMG8Gn5QiORvMUGzSz8Lo31LW58NdBKbh6bci5+t/HE0H
 pnyVf5xhNC/FuQINBFl4pQoBEACr+MgxWHUP76oNNYjRiNDhaIVtnPRqxiZ9v4H5FPxJy9UD
 Bqr54rifr1E+K+yYNPt/Po43vVL2cAyfyI/LVLlhiY4yH6T1n+Di/hSkkviCaf13gczuvgz4
 KVYLwojU8+naJUsiCJw01MjO3pg9GQ+47HgsnRjCdNmmHiUQqksMIfd8k3reO9SUNlEmDDNB
 XuSzkHjE5y/R/6p8uXaVpiKPfHoULjNRWaFc3d2JGmxJpBdpYnajoz61m7XJlgwl/B5Ql/6B
 dHGaX3VHxOZsfRfugwYF9CkrPbyO5PK7yJ5vaiWre7aQ9bmCtXAomvF1q3/qRwZp77k6i9R3
 tWfXjZDOQokw0u6d6DYJ0Vkfcwheg2i/Mf/epQl7Pf846G3PgSnyVK6cRwerBl5a68w7xqVU
 4KgAh0DePjtDcbcXsKRT9D63cfyfrNE+ea4i0SVik6+N4nAj1HbzWHTk2KIxTsJXypibOKFX
 2VykltxutR1sUfZBYMkfU4PogE7NjVEU7KtuCOSAkYzIWrZNEQrxYkxHLJsWruhSYNRsqVBy
 KvY6JAsq/i5yhVd5JKKU8wIOgSwC9P6mXYRgwPyfg15GZpnw+Fpey4bCDkT5fMOaCcS+vSU1
 UaFmC4Ogzpe2BW2DOaPU5Ik99zUFNn6cRmOOXArrryjFlLT5oSOe4IposgWzdwARAQABiQIl
 BBgBCAAPBQJZeKUKAhsMBQkJZgGAAAoJEKOGQNwGMqM5ELoP/jj9d9gF1Al4+9bngUlYohYu
 0sxyZo9IZ7Yb7cHuJzOMqfgoP4tydP4QCuyd9Q2OHHL5AL4VFNb8SvqAxxYSPuDJTI3JZwI7
 d8JTPKwpulMSUaJE8ZH9n8A/+sdC3CAD4QafVBcCcbFe1jifHmQRdDrvHV9Es14QVAOTZhnJ
 vweENyHEIxkpLsyUUDuVypIo6y/Cws+EBCWt27BJi9GH/EOTB0wb+2ghCs/i3h8a+bi+bS7L
 FCCm/AxIqxRurh2UySn0P/2+2eZvneJ1/uTgfxnjeSlwQJ1BWzMAdAHQO1/lnbyZgEZEtUZJ
 x9d9ASekTtJjBMKJXAw7GbB2dAA/QmbA+Q+Xuamzm/1imigz6L6sOt2n/X/SSc33w8RJUyor
 SvAIoG/zU2Y76pKTgbpQqMDmkmNYFMLcAukpvC4ki3Sf086TdMgkjqtnpTkEElMSFJC8npXv
 3QnGGOIfFug/qs8z03DLPBz9VYS26jiiN7QIJVpeeEdN/LKnaz5LO+h5kNAyj44qdF2T2AiF
 HxnZnxO5JNP5uISQH3FjxxGxJkdJ8jKzZV7aT37sC+Rp0o3KNc+GXTR+GSVq87Xfuhx0LRST
 NK9ZhT0+qkiN7npFLtNtbzwqaqceq3XhafmCiw8xrtzCnlB/C4SiBr/93Ip4kihXJ0EuHSLn
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com>
Date:   Tue, 4 Jun 2019 08:55:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1r4wEcOdQAcNnie9zc6Jhc62ipIHYRpfb"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 04 Jun 2019 12:55:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1r4wEcOdQAcNnie9zc6Jhc62ipIHYRpfb
Content-Type: multipart/mixed; boundary="DmTv2NxOFhUyQOn3jnrM9d4k4CBKl82WI";
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
Message-ID: <4cdfee20-126e-bc28-cf1c-2cfd484ca28e@redhat.com>
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-2-nitesh@redhat.com>
 <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>
In-Reply-To: <CAKgT0Udnc_cmgBLFEZ5udexsc1cfjX1rJR3qQFOW-7bfuFh6gQ@mail.gmail.com>

--DmTv2NxOFhUyQOn3jnrM9d4k4CBKl82WI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/3/19 3:04 PM, Alexander Duyck wrote:
> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> =
wrote:
>> This patch introduces the core infrastructure for free page hinting in=

>> virtual environments. It enables the kernel to track the free pages wh=
ich
>> can be reported to its hypervisor so that the hypervisor could
>> free and reuse that memory as per its requirement.
>>
>> While the pages are getting processed in the hypervisor (e.g.,
>> via MADV_FREE), the guest must not use them, otherwise, data loss
>> would be possible. To avoid such a situation, these pages are
>> temporarily removed from the buddy. The amount of pages removed
>> temporarily from the buddy is governed by the backend(virtio-balloon
>> in our case).
>>
>> To efficiently identify free pages that can to be hinted to the
>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
>> chunks are reported to the hypervisor - especially, to not break up TH=
P
>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bit=
s
>> in the bitmap are an indication whether a page *might* be free, not a
>> guarantee. A new hook after buddy merging sets the bits.
>>
>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
>> asynchronously processes the bitmaps, trying to isolate and report pag=
es
>> that are still free. The backend (virtio-balloon) is responsible for
>> reporting these batched pages to the host synchronously. Once reportin=
g/
>> freeing is complete, isolated pages are returned back to the buddy.
>>
>> There are still various things to look into (e.g., memory hotplug, mor=
e
>> efficient locking, possible races when disabling).
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> So one thing I had thought about, that I don't believe that has been
> addressed in your solution, is to determine a means to guarantee
> forward progress. If you have a noisy thread that is allocating and
> freeing some block of memory repeatedly you will be stuck processing
> that and cannot get to the other work. Specifically if you have a zone
> where somebody is just cycling the number of pages needed to fill your
> hinting queue how do you get around it and get to the data that is
> actually code instead of getting stuck processing the noise?

It should not matter. As every time the memory threshold is met, entire
bitmap
is scanned and not just a chunk of memory for possible isolation. This
will guarantee
forward progress.

> Do you have any idea what the hit rate would be on a system that is on
> the more active side? From what I can tell you still are effectively
> just doing a linear search of memory, but you have the bitmap hints to
> tell what as not been freed recently, however you still don't know
> that the pages you have bitmap hints for are actually free until you
> check them.
>
>> ---
>>  drivers/virtio/Kconfig       |   1 +
>>  include/linux/page_hinting.h |  46 +++++++
>>  mm/Kconfig                   |   6 +
>>  mm/Makefile                  |   2 +
>>  mm/page_alloc.c              |  17 +--
>>  mm/page_hinting.c            | 236 ++++++++++++++++++++++++++++++++++=
+
>>  6 files changed, 301 insertions(+), 7 deletions(-)
>>  create mode 100644 include/linux/page_hinting.h
>>  create mode 100644 mm/page_hinting.c
>>
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 35897649c24f..5a96b7a2ed1e 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -46,6 +46,7 @@ config VIRTIO_BALLOON
>>         tristate "Virtio balloon driver"
>>         depends on VIRTIO
>>         select MEMORY_BALLOON
>> +       select PAGE_HINTING
>>         ---help---
>>          This driver supports increasing and decreasing the amount
>>          of memory within a KVM guest.
>> diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting=
=2Eh
>> new file mode 100644
>> index 000000000000..e65188fe1e6b
>> --- /dev/null
>> +++ b/include/linux/page_hinting.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PAGE_HINTING_H
>> +#define _LINUX_PAGE_HINTING_H
>> +
>> +/*
>> + * Minimum page order required for a page to be hinted to the host.
>> + */
>> +#define PAGE_HINTING_MIN_ORDER         (MAX_ORDER - 2)
>> +
>> +/*
>> + * struct page_hinting_cb: holds the callbacks to store, report and c=
leanup
>> + * isolated pages.
>> + * @prepare:           Callback responsible for allocating an array t=
o hold
>> + *                     the isolated pages.
>> + * @hint_pages:                Callback which reports the isolated pa=
ges synchornously
>> + *                     to the host.
>> + * @cleanup:           Callback to free the the array used for report=
ing the
>> + *                     isolated pages.
>> + * @max_pages:         Maxmimum pages that are going to be hinted to =
the host
>> + *                     at a time of granularity >=3D PAGE_HINTING_MIN=
_ORDER.
>> + */
>> +struct page_hinting_cb {
>> +       int (*prepare)(void);
>> +       void (*hint_pages)(struct list_head *list);
>> +       void (*cleanup)(void);
>> +       int max_pages;
>> +};
>> +
>> +#ifdef CONFIG_PAGE_HINTING
>> +void page_hinting_enqueue(struct page *page, int order);
>> +void page_hinting_enable(const struct page_hinting_cb *cb);
>> +void page_hinting_disable(void);
>> +#else
>> +static inline void page_hinting_enqueue(struct page *page, int order)=

>> +{
>> +}
>> +
>> +static inline void page_hinting_enable(struct page_hinting_cb *cb)
>> +{
>> +}
>> +
>> +static inline void page_hinting_disable(void)
>> +{
>> +}
>> +#endif
>> +#endif /* _LINUX_PAGE_HINTING_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index ee8d1f311858..177d858de758 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -764,4 +764,10 @@ config GUP_BENCHMARK
>>  config ARCH_HAS_PTE_SPECIAL
>>         bool
>>
>> +# PAGE_HINTING will allow the guest to report the free pages to the
>> +# host in regular interval of time.
>> +config PAGE_HINTING
>> +       bool
>> +       def_bool n
>> +       depends on X86_64
>>  endmenu
>> diff --git a/mm/Makefile b/mm/Makefile
>> index ac5e5ba78874..bec456dfee34 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -41,6 +41,7 @@ obj-y                 :=3D filemap.o mempool.o oom_k=
ill.o fadvise.o \
>>                            interval_tree.o list_lru.o workingset.o \
>>                            debug.o $(mmu-y)
>>
>> +
>>  # Give 'page_alloc' its own module-parameter namespace
>>  page-alloc-y :=3D page_alloc.o
>>  page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) +=3D shuffle.o
>> @@ -94,6 +95,7 @@ obj-$(CONFIG_Z3FOLD)  +=3D z3fold.o
>>  obj-$(CONFIG_GENERIC_EARLY_IOREMAP) +=3D early_ioremap.o
>>  obj-$(CONFIG_CMA)      +=3D cma.o
>>  obj-$(CONFIG_MEMORY_BALLOON) +=3D balloon_compaction.o
>> +obj-$(CONFIG_PAGE_HINTING) +=3D page_hinting.o
>>  obj-$(CONFIG_PAGE_EXTENSION) +=3D page_ext.o
>>  obj-$(CONFIG_CMA_DEBUGFS) +=3D cma_debug.o
>>  obj-$(CONFIG_USERFAULTFD) +=3D userfaultfd.o
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3b13d3914176..d12f69e0e402 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -68,6 +68,7 @@
>>  #include <linux/lockdep.h>
>>  #include <linux/nmi.h>
>>  #include <linux/psi.h>
>> +#include <linux/page_hinting.h>
>>
>>  #include <asm/sections.h>
>>  #include <asm/tlbflush.h>
>> @@ -873,10 +874,10 @@ compaction_capture(struct capture_control *capc,=
 struct page *page,
>>   * -- nyc
>>   */
>>
>> -static inline void __free_one_page(struct page *page,
>> +inline void __free_one_page(struct page *page,
>>                 unsigned long pfn,
>>                 struct zone *zone, unsigned int order,
>> -               int migratetype)
>> +               int migratetype, bool hint)
>>  {
>>         unsigned long combined_pfn;
>>         unsigned long uninitialized_var(buddy_pfn);
>> @@ -951,6 +952,8 @@ static inline void __free_one_page(struct page *pa=
ge,
>>  done_merging:
>>         set_page_order(page, order);
>>
>> +       if (hint)
>> +               page_hinting_enqueue(page, order);
> This is a bit early to probably be dealing with the hint. You should
> probably look at moving this down to a spot somewhere after the page
> has been added to the free list. It may not cause any issues with the
> current order setup, but moving after the addition to the free list
> will make it so that you know it is in there when you call this
> function.
I will take a look at this.
>
>>         /*
>>          * If this is not the largest possible page, check if the budd=
y
>>          * of the next-highest order is free. If it is, it's possible
>> @@ -1262,7 +1265,7 @@ static void free_pcppages_bulk(struct zone *zone=
, int count,
>>                 if (unlikely(isolated_pageblocks))
>>                         mt =3D get_pageblock_migratetype(page);
>>
>> -               __free_one_page(page, page_to_pfn(page), zone, 0, mt);=

>> +               __free_one_page(page, page_to_pfn(page), zone, 0, mt, =
true);
>>                 trace_mm_page_pcpu_drain(page, 0, mt);
>>         }
>>         spin_unlock(&zone->lock);
>> @@ -1271,14 +1274,14 @@ static void free_pcppages_bulk(struct zone *zo=
ne, int count,
>>  static void free_one_page(struct zone *zone,
>>                                 struct page *page, unsigned long pfn,
>>                                 unsigned int order,
>> -                               int migratetype)
>> +                               int migratetype, bool hint)
>>  {
>>         spin_lock(&zone->lock);
>>         if (unlikely(has_isolate_pageblock(zone) ||
>>                 is_migrate_isolate(migratetype))) {
>>                 migratetype =3D get_pfnblock_migratetype(page, pfn);
>>         }
>> -       __free_one_page(page, pfn, zone, order, migratetype);
>> +       __free_one_page(page, pfn, zone, order, migratetype, hint);
>>         spin_unlock(&zone->lock);
>>  }
>>
>> @@ -1368,7 +1371,7 @@ static void __free_pages_ok(struct page *page, u=
nsigned int order)
>>         migratetype =3D get_pfnblock_migratetype(page, pfn);
>>         local_irq_save(flags);
>>         __count_vm_events(PGFREE, 1 << order);
>> -       free_one_page(page_zone(page), page, pfn, order, migratetype);=

>> +       free_one_page(page_zone(page), page, pfn, order, migratetype, =
true);
>>         local_irq_restore(flags);
>>  }
>>
>> @@ -2968,7 +2971,7 @@ static void free_unref_page_commit(struct page *=
page, unsigned long pfn)
>>          */
>>         if (migratetype >=3D MIGRATE_PCPTYPES) {
>>                 if (unlikely(is_migrate_isolate(migratetype))) {
>> -                       free_one_page(zone, page, pfn, 0, migratetype)=
;
>> +                       free_one_page(zone, page, pfn, 0, migratetype,=
 true);
>>                         return;
>>                 }
>>                 migratetype =3D MIGRATE_MOVABLE;
> So it looks like you are using a parameter to identify if the page is
> a hinted page or not. I guess this works but it seems like it is a bit
> intrusive as you are adding an argument to specify that this is a
> specific page type.
Any suggestions on how we could do this in a less intrusive manner?
>
>> diff --git a/mm/page_hinting.c b/mm/page_hinting.c
>> new file mode 100644
>> index 000000000000..7341c6462de2
>> --- /dev/null
>> +++ b/mm/page_hinting.c
>> @@ -0,0 +1,236 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Page hinting support to enable a VM to report the freed pages back=

>> + * to the host.
>> + *
>> + * Copyright Red Hat, Inc. 2019
>> + *
>> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/slab.h>
>> +#include <linux/page_hinting.h>
>> +#include <linux/kvm_host.h>
>> +
>> +/*
>> + * struct hinting_bitmap: holds the bitmap pointer which tracks the f=
reed PFNs
>> + * and other required parameters which could help in retrieving the o=
riginal
>> + * PFN value using the bitmap.
>> + * @bitmap:            Pointer to the bitmap of free PFN.
>> + * @base_pfn:          Starting PFN value for the zone whose bitmap i=
s stored.
>> + * @free_pages:                Tracks the number of free pages of gra=
nularity
>> + *                     PAGE_HINTING_MIN_ORDER.
>> + * @nbits:             Indicates the total size of the bitmap in bits=
 allocated
>> + *                     at the time of initialization.
>> + */
>> +struct hinting_bitmap {
>> +       unsigned long *bitmap;
>> +       unsigned long base_pfn;
>> +       atomic_t free_pages;
>> +       unsigned long nbits;
>> +} bm_zone[MAX_NR_ZONES];
>> +
> This ignores NUMA doesn't it? Shouldn't you have support for other NUMA=
 nodes?
I will have to look into this.
>
>> +static void init_hinting_wq(struct work_struct *work);
>> +extern int __isolate_free_page(struct page *page, unsigned int order)=
;
>> +extern void __free_one_page(struct page *page, unsigned long pfn,
>> +                           struct zone *zone, unsigned int order,
>> +                           int migratetype, bool hint);
>> +const struct page_hinting_cb *hcb;
>> +struct work_struct hinting_work;
>> +
>> +static unsigned long find_bitmap_size(struct zone *zone)
>> +{
>> +       unsigned long nbits =3D ALIGN(zone->spanned_pages,
>> +                           PAGE_HINTING_MIN_ORDER);
>> +
>> +       nbits =3D nbits >> PAGE_HINTING_MIN_ORDER;
>> +       return nbits;
>> +}
>> +
> This doesn't look right to me. You are trying to do something like a
> DIV_ROUND_UP here, right? If so shouldn't you be aligning to 1 <<
> PAGE_HINTING_MIN_ORDER, instead of just PAGE_HINTING_MIN_ORDER?
> Another option would be to just do DIV_ROUND_UP with the 1 <<
> PAGE_HINTING_MIN_ORDER value.
I will double check this.
>
>> +void page_hinting_enable(const struct page_hinting_cb *callback)
>> +{
>> +       struct zone *zone;
>> +       int idx =3D 0;
>> +       unsigned long bitmap_size =3D 0;
>> +
>> +       for_each_populated_zone(zone) {
> The index for this doesn't match up to the index you used to define
> bm_zone. for_each_populated_zone will go through each zone in each
> pgdat. Right now you can only handle one pgdat.
Not sure if I understood this entirely. Can you please explain more on th=
is?
>
>> +               spin_lock(&zone->lock);
>> +               bitmap_size =3D find_bitmap_size(zone);
>> +               bm_zone[idx].bitmap =3D bitmap_zalloc(bitmap_size, GFP=
_KERNEL);
>> +               if (!bm_zone[idx].bitmap)
>> +                       return;
>> +               bm_zone[idx].nbits =3D bitmap_size;
>> +               bm_zone[idx].base_pfn =3D zone->zone_start_pfn;
>> +               spin_unlock(&zone->lock);
>> +               idx++;
>> +       }
>> +       hcb =3D callback;
>> +       INIT_WORK(&hinting_work, init_hinting_wq);
>> +}
>> +EXPORT_SYMBOL_GPL(page_hinting_enable);
>> +
>> +void page_hinting_disable(void)
>> +{
>> +       struct zone *zone;
>> +       int idx =3D 0;
>> +
>> +       cancel_work_sync(&hinting_work);
>> +       hcb =3D NULL;
>> +       for_each_populated_zone(zone) {
>> +               spin_lock(&zone->lock);
>> +               bitmap_free(bm_zone[idx].bitmap);
>> +               bm_zone[idx].base_pfn =3D 0;
>> +               bm_zone[idx].nbits =3D 0;
>> +               atomic_set(&bm_zone[idx].free_pages, 0);
>> +               spin_unlock(&zone->lock);
>> +               idx++;
>> +       }
>> +}
>> +EXPORT_SYMBOL_GPL(page_hinting_disable);
>> +
>> +static unsigned long pfn_to_bit(struct page *page, int zonenum)
>> +{
>> +       unsigned long bitnr;
>> +
>> +       bitnr =3D (page_to_pfn(page) - bm_zone[zonenum].base_pfn)
>> +                        >> PAGE_HINTING_MIN_ORDER;
>> +       return bitnr;
>> +}
>> +
>> +static void release_buddy_pages(struct list_head *pages)
>> +{
>> +       int mt =3D 0, zonenum, order;
>> +       struct page *page, *next;
>> +       struct zone *zone;
>> +       unsigned long bitnr;
>> +
>> +       list_for_each_entry_safe(page, next, pages, lru) {
>> +               zonenum =3D page_zonenum(page);
>> +               zone =3D page_zone(page);
>> +               bitnr =3D pfn_to_bit(page, zonenum);
>> +               spin_lock(&zone->lock);
>> +               list_del(&page->lru);
>> +               order =3D page_private(page);
>> +               set_page_private(page, 0);
>> +               mt =3D get_pageblock_migratetype(page);
>> +               __free_one_page(page, page_to_pfn(page), zone,
>> +                               order, mt, false);
>> +               spin_unlock(&zone->lock);
>> +       }
>> +}
>> +
>> +static void bm_set_pfn(struct page *page)
>> +{
>> +       unsigned long bitnr =3D 0;
>> +       int zonenum =3D page_zonenum(page);
>> +       struct zone *zone =3D page_zone(page);
>> +
>> +       lockdep_assert_held(&zone->lock);
>> +       bitnr =3D pfn_to_bit(page, zonenum);
>> +       if (bm_zone[zonenum].bitmap &&
>> +           bitnr < bm_zone[zonenum].nbits &&
>> +           !test_and_set_bit(bitnr, bm_zone[zonenum].bitmap))
>> +               atomic_inc(&bm_zone[zonenum].free_pages);
>> +}
>> +
>> +static void scan_hinting_bitmap(int zonenum, int free_pages)
>> +{
>> +       unsigned long set_bit, start =3D 0;
>> +       struct page *page;
>> +       struct zone *zone;
>> +       int scanned_pages =3D 0, ret =3D 0, order, isolated_cnt =3D 0;=

>> +       LIST_HEAD(isolated_pages);
>> +
>> +       ret =3D hcb->prepare();
>> +       if (ret < 0)
>> +               return;
>> +       for (;;) {
>> +               ret =3D 0;
>> +               set_bit =3D find_next_bit(bm_zone[zonenum].bitmap,
>> +                                       bm_zone[zonenum].nbits, start)=
;
>> +               if (set_bit >=3D bm_zone[zonenum].nbits)
>> +                       break;
>> +               page =3D pfn_to_online_page((set_bit << PAGE_HINTING_M=
IN_ORDER) +
>> +                               bm_zone[zonenum].base_pfn);
>> +               if (!page)
>> +                       continue;
>> +               zone =3D page_zone(page);
>> +               spin_lock(&zone->lock);
>> +
>> +               if (PageBuddy(page) && page_private(page) >=3D
>> +                   PAGE_HINTING_MIN_ORDER) {
>> +                       order =3D page_private(page);
>> +                       ret =3D __isolate_free_page(page, order);
>> +               }
>> +               clear_bit(set_bit, bm_zone[zonenum].bitmap);
>> +               spin_unlock(&zone->lock);
>> +               if (ret) {
>> +                       /*
>> +                        * restoring page order to use it while releas=
ing
>> +                        * the pages back to the buddy.
>> +                        */
>> +                       set_page_private(page, order);
>> +                       list_add_tail(&page->lru, &isolated_pages);
>> +                       isolated_cnt++;
>> +                       if (isolated_cnt =3D=3D hcb->max_pages) {
>> +                               hcb->hint_pages(&isolated_pages);
>> +                               release_buddy_pages(&isolated_pages);
>> +                               isolated_cnt =3D 0;
>> +                       }
>> +               }
>> +               start =3D set_bit + 1;
>> +               scanned_pages++;
>> +       }
>> +       if (isolated_cnt) {
>> +               hcb->hint_pages(&isolated_pages);
>> +               release_buddy_pages(&isolated_pages);
>> +       }
>> +       hcb->cleanup();
>> +       if (scanned_pages > free_pages)
>> +               atomic_sub((scanned_pages - free_pages),
>> +                          &bm_zone[zonenum].free_pages);
>> +}
>> +
>> +static bool check_hinting_threshold(void)
>> +{
>> +       int zonenum =3D 0;
>> +
>> +       for (; zonenum < MAX_NR_ZONES; zonenum++) {
>> +               if (atomic_read(&bm_zone[zonenum].free_pages) >=3D
>> +                               hcb->max_pages)
>> +                       return true;
>> +       }
>> +       return false;
>> +}
>> +
>> +static void init_hinting_wq(struct work_struct *work)
>> +{
>> +       int zonenum =3D 0, free_pages =3D 0;
>> +
>> +       for (; zonenum < MAX_NR_ZONES; zonenum++) {
>> +               free_pages =3D atomic_read(&bm_zone[zonenum].free_page=
s);
>> +               if (free_pages >=3D hcb->max_pages) {
>> +                       /* Find a better way to synchronize per zone
>> +                        * free_pages.
>> +                        */
>> +                       atomic_sub(free_pages,
>> +                                  &bm_zone[zonenum].free_pages);
>> +                       scan_hinting_bitmap(zonenum, free_pages);
>> +               }
>> +       }
>> +}
>> +
>> +void page_hinting_enqueue(struct page *page, int order)
>> +{
>> +       if (hcb && order >=3D PAGE_HINTING_MIN_ORDER)
>> +               bm_set_pfn(page);
>> +       else
>> +               return;
> You could probably flip the logic and save yourself an "else" by just
> doing something like:
> if (!hcb || order < PAGE_HINTING_MIN_ORDER)
>         return;
>
> I think it would also make this more readable.
>
+1
>> +
>> +       if (check_hinting_threshold()) {
>> +               int cpu =3D smp_processor_id();
>> +
>> +               queue_work_on(cpu, system_wq, &hinting_work);
>> +       }
>> +}
>> --
>> 2.21.0
>>
--=20
Regards
Nitesh


--DmTv2NxOFhUyQOn3jnrM9d4k4CBKl82WI--

--1r4wEcOdQAcNnie9zc6Jhc62ipIHYRpfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz2aigACgkQo4ZA3AYy
oznxZxAAh9gipjRhzIiSfyTcz4uwfr5Vz5W92GUQ7HuoqnNE4cUM4J1RptPMuf59
pJnJuc0cW8rRhn04W+bNr5JA8eBomgb5/BjxtuNITnO2TAS/Q1SQNaCxc2RxI9sH
0QXxKuG+S+tSVoMgUDgJFzdIBqW1RyLKJHySvFE1pYMcqwS8Ai33Kv1+B8Ih+PPK
Wf+L4AcC06PcvgphnHKnvfyWi2bP5o1FoBX+hTmG+I5h/MDJefkZOwU0t4m9CwR3
k2nOPMgZld6zfg/XSQ88QyQ0BFjoFAkDk3oy8yrQpa2tS3eQTf7EIIlFtalQegmP
7wKJ37FAcXQx19xV4FpvM3xjlzhhGbdQtbe4malvK88zE2F3Rvu/WNBtR7wOzRis
5JkdOzynCQ+mHkcOfELdGh4D5Q6zv9psBXE+gZJaDD/V1UoxCneSPU2AylFSYiEB
UpUMRnqRImEj8+t06U5IykqtbbRlN7qCrBSBABOVW3V9K51/A7csK/giH3CDgYxi
vM8HbXVLOe0NurJiJcUP7rh/sJEReRtQwejHFrg59Js2M0DVLvEA4qhzxzhGvjf1
AJILl2lvBPulrMmIEmZZg355cJ6nXt06aaxnzO+GUv5JF9xA1299kH9/nHArHky2
atpIx+dWGLpRly9l7sTRPBcsFxtw2OqW8kFBsVfkGqXzN6Pv2xs=
=7ir+
-----END PGP SIGNATURE-----

--1r4wEcOdQAcNnie9zc6Jhc62ipIHYRpfb--
