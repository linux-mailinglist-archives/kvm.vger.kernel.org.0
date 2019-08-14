Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFD78D280
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 13:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfHNLrz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 14 Aug 2019 07:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfHNLrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 07:47:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FA1B3098433;
        Wed, 14 Aug 2019 11:47:53 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F020600C8;
        Wed, 14 Aug 2019 11:47:41 +0000 (UTC)
Subject: Re: [RFC][Patch v12 2/2] virtio-balloon: interface to support free
 page reporting
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com
References: <20190812131235.27244-1-nitesh@redhat.com>
 <20190812131235.27244-3-nitesh@redhat.com>
 <20190814122949.4946f438.cohuck@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <c23f02b1-4bda-7dc6-9e28-4bad0a16cde6@redhat.com>
Date:   Wed, 14 Aug 2019 07:47:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814122949.4946f438.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 14 Aug 2019 11:47:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/14/19 6:29 AM, Cornelia Huck wrote:
> On Mon, 12 Aug 2019 09:12:35 -0400
> Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>> Enables the kernel to negotiate VIRTIO_BALLOON_F_REPORTING feature with
>> the host. If it is available and page_reporting_flag is set to true,
>> page_reporting is enabled and its callback is configured along with
>> the max_pages count which indicates the maximum number of pages that
>> can be isolated and reported at a time. Currently, only free pages of
>> order >= (MAX_ORDER - 2) are reported. To prevent any false OOM
>> max_pages count is set to 16.
>>
>> By default page_reporting feature is enabled and gets loaded as soon
>> as the virtio-balloon driver is loaded. However, it could be disabled
>> by writing the page_reporting_flag which is a virtio-balloon parameter.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  drivers/virtio/Kconfig              |  1 +
>>  drivers/virtio/virtio_balloon.c     | 64 ++++++++++++++++++++++++++++-
>>  include/uapi/linux/virtio_balloon.h |  1 +
>>  3 files changed, 65 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
>> index 226fbb995fb0..defec00d4ee2 100644
>> --- a/drivers/virtio/virtio_balloon.c
>> +++ b/drivers/virtio/virtio_balloon.c
> (...)
>
>> +static void virtballoon_page_reporting_setup(struct virtio_balloon *vb)
>> +{
>> +	struct device *dev = &vb->vdev->dev;
>> +	int err;
>> +
>> +	vb->page_reporting_conf.report = virtballoon_report_pages;
>> +	vb->page_reporting_conf.max_pages = PAGE_REPORTING_MAX_PAGES;
>> +	err = page_reporting_enable(&vb->page_reporting_conf);
>> +	if (err < 0) {
>> +		dev_err(dev, "Failed to enable reporting, err = %d\n", err);
>> +		page_reporting_flag = false;
> Should we clear the feature bit in this case as well?

I think yes.
If I am not wrong then in a case where page reporting setup fails for some
reason and at a later point the user wants to re-enable it then for that balloon
driver has to be reloaded.
Which would mean re-negotiation of the feature bit.

>
>> +		vb->page_reporting_conf.report = NULL;
>> +		vb->page_reporting_conf.max_pages = 0;
>> +		return;
>> +	}
>> +}
>> +
>>  static void set_page_pfns(struct virtio_balloon *vb,
>>  			  __virtio32 pfns[], struct page *page)
>>  {
>> @@ -476,6 +524,7 @@ static int init_vqs(struct virtio_balloon *vb)
>>  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>>  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>>  	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>> +	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
>>  
>>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>>  		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
>> @@ -487,11 +536,18 @@ static int init_vqs(struct virtio_balloon *vb)
>>  		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>>  	}
>>  
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
>> +		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
>> +		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
> Do we even want to try to set up the reporting queue if reporting has
> been disabled via module parameter? Might make more sense to not even
> negotiate the feature bit in that case.

True.
I think this should be replaced with something like (page_reporting_flag &&
virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)).

>
>> +	}
>>  	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>>  					 vqs, callbacks, names, NULL, NULL);
>>  	if (err)
>>  		return err;
>>  
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
>> +		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
>> +
>>  	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>>  	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>> @@ -924,6 +980,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
>>  		if (err)
>>  			goto out_del_balloon_wq;
>>  	}
>> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING) &&
>> +	    page_reporting_flag)
>> +		virtballoon_page_reporting_setup(vb);
> In that case, you'd only need to check for the feature bit here.

Why is that?
I think both the checks should be present here as we need both the conditions to
be true to enable page reporting.
However, the order should be reversed because of the reason you mentioned earlier.

>
>>  	virtio_device_ready(vdev);
>>  
>>  	if (towards_target(vb))
>> @@ -971,6 +1030,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
>>  		destroy_workqueue(vb->balloon_wq);
>>  	}
>>  
>> +	if (page_reporting_flag)
>> +		page_reporting_disable(&vb->page_reporting_conf);
> I think you should not disable it if the feature bit was never offered
> in the first place, right?

Yes.
I should check both feature bit and module parameter here.

>
>>  	remove_common(vb);
>>  #ifdef CONFIG_BALLOON_COMPACTION
>>  	if (vb->vb_dev_info.inode)
> (...)
-- 
Thanks
Nitesh

