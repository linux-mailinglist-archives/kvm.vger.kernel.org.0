Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B6933F8F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFDHMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 03:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfFDHMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 03:12:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C14D6C05FBCB;
        Tue,  4 Jun 2019 07:12:37 +0000 (UTC)
Received: from [10.36.117.37] (ovpn-117-37.ams2.redhat.com [10.36.117.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 454185B684;
        Tue,  4 Jun 2019 07:12:22 +0000 (UTC)
Subject: Re: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to
 the host
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-3-nitesh@redhat.com>
 <CAKgT0UdtHAvRd++enU3ouxebwV1T4KZbS_JkmyDbJ5jGkA1XaQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <604c496d-4df0-dca9-76dd-048917a5d132@redhat.com>
Date:   Tue, 4 Jun 2019 09:12:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdtHAvRd++enU3ouxebwV1T4KZbS_JkmyDbJ5jGkA1XaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 04 Jun 2019 07:12:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.19 00:38, Alexander Duyck wrote:
> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>
>> Enables the kernel to negotiate VIRTIO_BALLOON_F_HINTING feature with the
>> host. If it is available and page_hinting_flag is set to true, page_hinting
>> is enabled and its callbacks are configured along with the max_pages count
>> which indicates the maximum number of pages that can be isolated and hinted
>> at a time. Currently, only free pages of order >= (MAX_ORDER - 2) are
>> reported. To prevent any false OOM max_pages count is set to 16.
>>
>> By default page_hinting feature is enabled and gets loaded as soon
>> as the virtio-balloon driver is loaded. However, it could be disabled
>> by writing the page_hinting_flag which is a virtio-balloon parameter.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  drivers/virtio/virtio_balloon.c     | 112 +++++++++++++++++++++++++++-
>>  include/uapi/linux/virtio_balloon.h |  14 ++++
>>  2 files changed, 125 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
>> index f19061b585a4..40f09ea31643 100644
>> --- a/drivers/virtio/virtio_balloon.c
>> +++ b/drivers/virtio/virtio_balloon.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/mount.h>
>>  #include <linux/magic.h>
>> +#include <linux/page_hinting.h>
>>
>>  /*
>>   * Balloon device works in 4K page units.  So each page is pointed to by
>> @@ -48,6 +49,7 @@
>>  /* The size of a free page block in bytes */
>>  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
>>         (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
>> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES  16
>>
>>  #ifdef CONFIG_BALLOON_COMPACTION
>>  static struct vfsmount *balloon_mnt;
>> @@ -58,6 +60,7 @@ enum virtio_balloon_vq {
>>         VIRTIO_BALLOON_VQ_DEFLATE,
>>         VIRTIO_BALLOON_VQ_STATS,
>>         VIRTIO_BALLOON_VQ_FREE_PAGE,
>> +       VIRTIO_BALLOON_VQ_HINTING,
>>         VIRTIO_BALLOON_VQ_MAX
>>  };
>>
>> @@ -67,7 +70,8 @@ enum virtio_balloon_config_read {
>>
>>  struct virtio_balloon {
>>         struct virtio_device *vdev;
>> -       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
>> +       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
>> +                        *hinting_vq;
>>
>>         /* Balloon's own wq for cpu-intensive work items */
>>         struct workqueue_struct *balloon_wq;
>> @@ -125,6 +129,9 @@ struct virtio_balloon {
>>
>>         /* To register a shrinker to shrink memory upon memory pressure */
>>         struct shrinker shrinker;
>> +
>> +       /* object pointing at the array of isolated pages ready for hinting */
>> +       struct hinting_data *hinting_arr;
> 
> Just make this an array of size VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES.
> It will save a bunch of complexity later.

+1

[...]
> 
>> +struct virtio_balloon *hvb;
>> +bool page_hinting_flag = true;
>> +module_param(page_hinting_flag, bool, 0444);
>> +MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
>> +
>> +static bool virtqueue_kick_sync(struct virtqueue *vq)
>> +{
>> +       u32 len;
>> +
>> +       if (likely(virtqueue_kick(vq))) {
>> +               while (!virtqueue_get_buf(vq, &len) &&
>> +                      !virtqueue_is_broken(vq))
>> +                       cpu_relax();
>> +               return true;
> 
> Is this a synchronous setup? It seems kind of wasteful to have a
> thread busy waiting here like this. It might make more sense to just
> make this work like the other balloon queues and have a wait event
> with a wake up in the interrupt handler for the queue.

+1

[...]

> 
>> +       gpaddr = virt_to_phys(hvb->hinting_arr);
>> +       hint_req->phys_addr = cpu_to_virtio64(hvb->vdev, gpaddr);
>> +       hint_req->size = cpu_to_virtio32(hvb->vdev, entries);
>> +       sg_init_one(&sg, hint_req, sizeof(*hint_req));
>> +       err = virtqueue_add_outbuf(vq, &sg, 1, hint_req, GFP_KERNEL);
>> +       if (!err)
>> +               virtqueue_kick_sync(hvb->hinting_vq);
>> +
>> +       kfree(hint_req);
>> +}
>> +
>> +int page_hinting_prepare(void)
>> +{
>> +       hvb->hinting_arr = kmalloc_array(VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
>> +                                        sizeof(*hvb->hinting_arr), GFP_KERNEL);
>> +       if (!hvb->hinting_arr)
>> +               return -ENOMEM;
>> +       return 0;
>> +}
>> +
> 
> Why make the hinting_arr a dynamic allocation? You should probably
> just make it a static array within the virtio_balloon structure. Then
> you don't have the risk of an allocation failing and messing up the
> hints.

+1

> 
>> +void hint_pages(struct list_head *pages)
>> +{
>> +       struct page *page, *next;
>> +       unsigned long pfn;
>> +       int idx = 0, order;
>> +
>> +       list_for_each_entry_safe(page, next, pages, lru) {
>> +               pfn = page_to_pfn(page);
>> +               order = page_private(page);
>> +               hvb->hinting_arr[idx].phys_addr = pfn << PAGE_SHIFT;
>> +               hvb->hinting_arr[idx].size = (1 << order) * PAGE_SIZE;
>> +               idx++;
>> +       }
>> +       page_hinting_report(idx);
>> +}
>> +
> 
> Getting back to my suggestion from earlier today. It might make sense
> to not bother with the PAGE_SHIFT or PAGE_SIZE multiplication if you
> just record everything in VIRTIO_BALLOON_PAGES intead of using the
> actual address and size.

I think I prefer "addr + size".

> 
> Same comment here. Make this array a part of virtio_balloon and you
> don't have to free it.
> 
>> +static const struct page_hinting_cb hcb = {
>> +       .prepare = page_hinting_prepare,
>> +       .hint_pages = hint_pages,
>> +       .cleanup = page_hinting_cleanup,
>> +       .max_pages = VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
>> +};
> 
> With the above changes prepare and cleanup can be dropped.

+1

> 
>> +#endif
>> +
>>  static u32 page_to_balloon_pfn(struct page *page)
>>  {
>>         unsigned long pfn = page_to_pfn(page);
>> @@ -488,6 +574,7 @@ static int init_vqs(struct virtio_balloon *vb)
>>         names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>>         names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>>         names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>> +       names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
>>
>>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>>                 names[VIRTIO_BALLOON_VQ_STATS] = "stats";
>> @@ -499,11 +586,18 @@ static int init_vqs(struct virtio_balloon *vb)
>>                 callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>>         }
>>
>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
>> +               names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
>> +               callbacks[VIRTIO_BALLOON_VQ_HINTING] = NULL;
>> +       }
>>         err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>>                                          vqs, callbacks, names, NULL, NULL);
>>         if (err)
>>                 return err;
>>
>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
>> +               vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
>> +
>>         vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>>         vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>> @@ -942,6 +1036,14 @@ static int virtballoon_probe(struct virtio_device *vdev)
>>                 if (err)
>>                         goto out_del_balloon_wq;
>>         }
>> +
>> +#ifdef CONFIG_PAGE_HINTING
>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&
>> +           page_hinting_flag) {
>> +               hvb = vb;
>> +               page_hinting_enable(&hcb);
>> +       }
>> +#endif
>>         virtio_device_ready(vdev);
>>
>>         if (towards_target(vb))
>> @@ -989,6 +1091,12 @@ static void virtballoon_remove(struct virtio_device *vdev)
>>                 destroy_workqueue(vb->balloon_wq);
>>         }
>>
>> +#ifdef CONFIG_PAGE_HINTING
>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {

Nitesh, you should only disable if you actually enabled it
(page_hinting_flag).



-- 

Thanks,

David / dhildenb
