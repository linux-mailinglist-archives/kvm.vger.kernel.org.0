Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7473C36
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 22:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392397AbfGXUHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 16:07:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387941AbfGXUHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 16:07:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 728B1308FBAC;
        Wed, 24 Jul 2019 20:07:03 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 194C11843C;
        Wed, 24 Jul 2019 20:06:52 +0000 (UTC)
Subject: Re: [RFC][Patch v11 2/2] virtio-balloon: page_hinting: reporting to
 the host
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com
References: <20190710195158.19640-1-nitesh@redhat.com>
 <20190710195158.19640-3-nitesh@redhat.com>
 <20190724153951-mutt-send-email-mst@kernel.org>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <74181cce-5db2-3d0a-00d6-16966c876dcc@redhat.com>
Date:   Wed, 24 Jul 2019 16:06:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190724153951-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 24 Jul 2019 20:07:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/19 3:47 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 10, 2019 at 03:51:58PM -0400, Nitesh Narayan Lal wrote:
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
>>  drivers/virtio/Kconfig              |  1 +
>>  drivers/virtio/virtio_balloon.c     | 91 ++++++++++++++++++++++++++++-
>>  include/uapi/linux/virtio_balloon.h | 11 ++++
>>  3 files changed, 102 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 023fc3bc01c6..dcc0cb4269a5 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -47,6 +47,7 @@ config VIRTIO_BALLOON
>>  	tristate "Virtio balloon driver"
>>  	depends on VIRTIO
>>  	select MEMORY_BALLOON
>> +	select PAGE_HINTING
>>  	---help---
>>  	 This driver supports increasing and decreasing the amount
>>  	 of memory within a KVM guest.
>> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
>> index 44339fc87cc7..1fb0eb0b2c20 100644
>> --- a/drivers/virtio/virtio_balloon.c
>> +++ b/drivers/virtio/virtio_balloon.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/mount.h>
>>  #include <linux/magic.h>
>> +#include <linux/page_hinting.h>
>>  
>>  /*
>>   * Balloon device works in 4K page units.  So each page is pointed to by
>> @@ -35,6 +36,12 @@
>>  /* The size of a free page block in bytes */
>>  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
>>  	(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
>> +/* Number of isolated pages to be reported to the host at a time.
>> + * TODO:
>> + * 1. Set it via host.
>> + * 2. Find an optimal value for this.
>> + */
>> +#define PAGE_HINTING_MAX_PAGES	16
>>  
>>  #ifdef CONFIG_BALLOON_COMPACTION
>>  static struct vfsmount *balloon_mnt;
>> @@ -45,6 +52,7 @@ enum virtio_balloon_vq {
>>  	VIRTIO_BALLOON_VQ_DEFLATE,
>>  	VIRTIO_BALLOON_VQ_STATS,
>>  	VIRTIO_BALLOON_VQ_FREE_PAGE,
>> +	VIRTIO_BALLOON_VQ_HINTING,
>>  	VIRTIO_BALLOON_VQ_MAX
>>  };
>>  
>> @@ -54,7 +62,8 @@ enum virtio_balloon_config_read {
>>  
>>  struct virtio_balloon {
>>  	struct virtio_device *vdev;
>> -	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq;
>> +	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_page_vq,
>> +			 *hinting_vq;
>>  
>>  	/* Balloon's own wq for cpu-intensive work items */
>>  	struct workqueue_struct *balloon_wq;
>> @@ -112,6 +121,9 @@ struct virtio_balloon {
>>  
>>  	/* To register a shrinker to shrink memory upon memory pressure */
>>  	struct shrinker shrinker;
>> +
>> +	/* Array object pointing at the isolated pages ready for hinting */
>> +	struct isolated_memory isolated_pages[PAGE_HINTING_MAX_PAGES];
>>  };
>>  
>>  static struct virtio_device_id id_table[] = {
>> @@ -119,6 +131,66 @@ static struct virtio_device_id id_table[] = {
>>  	{ 0 },
>>  };
>>  
>> +static struct page_hinting_config page_hinting_conf;
>> +bool page_hinting_flag = true;
>> +struct virtio_balloon *hvb;
>> +module_param(page_hinting_flag, bool, 0444);
>> +MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
>> +
>> +static int page_hinting_report(void)
>> +{
>> +	struct virtqueue *vq = hvb->hinting_vq;
>> +	struct scatterlist sg;
>> +	int err = 0, unused;
>> +
>> +	mutex_lock(&hvb->balloon_lock);
>> +	sg_init_one(&sg, hvb->isolated_pages, sizeof(hvb->isolated_pages[0]) *
>> +		    PAGE_HINTING_MAX_PAGES);
>> +	err = virtqueue_add_outbuf(vq, &sg, 1, hvb, GFP_KERNEL);
> In Alex's patch, I really like it that he's passing pages as sg
> entries. IMHO that's both cleaner and allows seamless
> support for arbitrary page sizes.
>
> In particular ....
+1. I will also incorporate this change.
>
>> +	if (!err)
>> +		virtqueue_kick(hvb->hinting_vq);
>> +	wait_event(hvb->acked, virtqueue_get_buf(vq, &unused));
>> +	mutex_unlock(&hvb->balloon_lock);
>> +	return err;
>> +}
>> +
>> +void hint_pages(struct list_head *pages)
>> +{
>> +	struct device *dev = &hvb->vdev->dev;
>> +	struct page *page, *next;
>> +	int idx = 0, order, err;
>> +	unsigned long pfn;
>> +
>> +	list_for_each_entry_safe(page, next, pages, lru) {
>> +		pfn = page_to_pfn(page);
>> +		order = page_private(page);
>> +		hvb->isolated_pages[idx].phys_addr = pfn << PAGE_SHIFT;
>> +		hvb->isolated_pages[idx].size = (1 << order) * PAGE_SIZE;
>> +		idx++;
> ... passing native endian-ness values to host creates pain for
> cross-endian configurations.
>
>> +	}
>> +	err = page_hinting_report();
>> +	if (err < 0)
>> +		dev_err(dev, "Failed to hint pages, err = %d\n", err);
>> +}
>> +
>> +static void page_hinting_init(struct virtio_balloon *vb)
>> +{
>> +	struct device *dev = &vb->vdev->dev;
>> +	int err;
>> +
>> +	page_hinting_conf.hint_pages = hint_pages;
>> +	page_hinting_conf.max_pages = PAGE_HINTING_MAX_PAGES;
>> +	err = page_hinting_enable(&page_hinting_conf);
>> +	if (err < 0) {
>> +		dev_err(dev, "Failed to enable page-hinting, err = %d\n", err);
> It would be nicer to disable the feature bit then, or fail probe
> completely.
Makes sense. Thanks.
>> +		page_hinting_flag = false;
>> +		page_hinting_conf.hint_pages = NULL;
>> +		page_hinting_conf.max_pages = 0;
>> +		return;
>> +	}
>> +	hvb = vb;
>> +}
>> +
>>  static u32 page_to_balloon_pfn(struct page *page)
>>  {
>>  	unsigned long pfn = page_to_pfn(page);
>> @@ -475,6 +547,7 @@ static int init_vqs(struct virtio_balloon *vb)
>>  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>>  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>>  	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>> +	names[VIRTIO_BALLOON_VQ_HINTING] = NULL;
>>  
>>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>>  		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
>> @@ -486,11 +559,18 @@ static int init_vqs(struct virtio_balloon *vb)
>>  		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>>  	}
>>  
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {
>> +		names[VIRTIO_BALLOON_VQ_HINTING] = "hinting_vq";
>> +		callbacks[VIRTIO_BALLOON_VQ_HINTING] = balloon_ack;
>> +	}
>>  	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>>  					 vqs, callbacks, names, NULL, NULL);
>>  	if (err)
>>  		return err;
>>  
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
>> +		vb->hinting_vq = vqs[VIRTIO_BALLOON_VQ_HINTING];
>> +
>>  	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>>  	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>> @@ -929,6 +1009,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
>>  		if (err)
>>  			goto out_del_balloon_wq;
>>  	}
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&
>> +	    page_hinting_flag)
>> +		page_hinting_init(vb);
>>  	virtio_device_ready(vdev);
>>  
>>  	if (towards_target(vb))
>> @@ -976,6 +1059,10 @@ static void virtballoon_remove(struct virtio_device *vdev)
>>  		destroy_workqueue(vb->balloon_wq);
>>  	}
>>  
>> +	if (!page_hinting_flag) {
>> +		hvb = NULL;
>> +		page_hinting_disable();
>> +	}
>>  	remove_common(vb);
>>  #ifdef CONFIG_BALLOON_COMPACTION
>>  	if (vb->vb_dev_info.inode)
>> @@ -1030,8 +1117,10 @@ static unsigned int features[] = {
>>  	VIRTIO_BALLOON_F_MUST_TELL_HOST,
>>  	VIRTIO_BALLOON_F_STATS_VQ,
>>  	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
>> +	VIRTIO_BALLOON_F_HINTING,
>>  	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
>>  	VIRTIO_BALLOON_F_PAGE_POISON,
>> +	VIRTIO_BALLOON_F_HINTING,
>>  };
>>  
>>  static struct virtio_driver virtio_balloon_driver = {
>> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
>> index a1966cd7b677..29eed0ec83d3 100644
>> --- a/include/uapi/linux/virtio_balloon.h
>> +++ b/include/uapi/linux/virtio_balloon.h
>> @@ -36,6 +36,8 @@
>>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
>>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
>>  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
>> +/* TODO: Find a better name to avoid any confusion with FREE_PAGE_HINT */
>> +#define VIRTIO_BALLOON_F_HINTING	5 /* Page hinting virtqueue */
>>  
>>  /* Size of a PFN in the balloon interface. */
>>  #define VIRTIO_BALLOON_PFN_SHIFT 12
>> @@ -108,4 +110,13 @@ struct virtio_balloon_stat {
>>  	__virtio64 val;
>>  } __attribute__((packed));
>>  
>> +/*
>> + * struct isolated_memory- holds the pages which will be reported to the host.
>> + * @phys_add:	physical address associated with a page.
>> + * @size:	total size of memory to be reported.
>> + */
>> +struct isolated_memory {
>> +	__virtio64 phys_addr;
>> +	__virtio64 size;
>> +};
>>  #endif /* _LINUX_VIRTIO_BALLOON_H */
>> -- 
>> 2.21.0
-- 
Thanks
Nitesh
