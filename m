Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66A210E922
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 11:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfLBKoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 05:44:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726276AbfLBKoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 05:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575283461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=YGWQ81L3lyuo9K5QveUzBPWYjnuYSLdtCHVCt9bI/E8=;
        b=dxsGAfrSQvcnN5qB0Zls54wp/GQmfJ/dYPZFDsyEjJC5Tzwlbycu34eQ5+WW8q66fp/lET
        wEho0lness2H3UzGgA+NmzN5tqsroczHCckuj69WNx4R2O47Ebdmj2hZTs6D6LRB/7fmL6
        fjeSu0zWup+3CHmBDUU9poOcZsAedrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-X2WFclr9OL--oefB_3xPsw-1; Mon, 02 Dec 2019 05:44:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7475107ACC4;
        Mon,  2 Dec 2019 10:44:16 +0000 (UTC)
Received: from [10.36.117.49] (ovpn-117-49.ams2.redhat.com [10.36.117.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6912367E56;
        Mon,  2 Dec 2019 10:44:00 +0000 (UTC)
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain>
 <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
 <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <c97bc21d-6394-7667-32a7-28f121fa1045@redhat.com>
Date:   Mon, 2 Dec 2019 11:43:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf8iebEXSovdWfXq1FvyGpqrF-X0VDrq-h8xavQkvA_9w@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: X2WFclr9OL--oefB_3xPsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

>> Sounds like the device is unused :D
>>
>> "Device info for reporting unused pages" ?
>>
>> I am in general wondering, should we rename "unused" to "free". I.e.,
>> "free page reporting" instead of "unused page reporting"? Or what was
>> the motivation behind using "unused" ?
>=20
> I honestly don't remember why I chose "unused" at this point. I can
> switch over to "free" if that is what is preferred.
>=20
> Looking over the code a bit more I suspect the reason for avoiding it
> is because free page hinting also mentioned reporting in a few spots.

Maybe we should fix these cases. FWIW, I'd prefer "free page reporting".
(e.g., pairs nicely with "free page hinting").

>>> +
>>> +     virtqueue_kick(vq);
>>> +
>>> +     /* When host has read buffer, this completes via balloon_ack */
>>> +     wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
>>
>> Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
>> queue? What if both mechanisms are used concurrently and race/both wait
>> for the hypervisor?
>>
>> Maybe we need a separate vb->acked + callback function.
>=20
> So if I understand correctly what is actually happening is that the
> wait event is simply a trigger that will wake us up, and at that point
> we check to see if the buffer we submitted is done. If not we go back
> to sleep. As such all we are really waiting on is the notification
> that the buffers we submitted have been processed. So it is using the
> same function but on a different virtual queue.

Very right, this is just a waitqueue (was only looking at this patch,
not the full code). This should indeed be fine.

>>>       vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
>>>       vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>>>       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>>> @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_device=
 *vdev)
>>>               if (err)
>>>                       goto out_del_balloon_wq;
>>>       }
>>> +
>>> +     vb->pr_dev_info.report =3D virtballoon_unused_page_report;
>>> +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
>>> +             unsigned int capacity;
>>> +
>>> +             capacity =3D min_t(unsigned int,
>>> +                              virtqueue_get_vring_size(vb->reporting_v=
q),
>>> +                              VIRTIO_BALLOON_VRING_HINTS_MAX);
>>> +             vb->pr_dev_info.capacity =3D capacity;
>>> +
>>> +             err =3D page_reporting_register(&vb->pr_dev_info);
>>> +             if (err)
>>> +                     goto out_unregister_shrinker;
>>> +     }
>>
>> It can happen here that we start reporting before marking the device
>> ready. Can that be problematic?
>>
>> Maybe we have to ignore any reports in virtballoon_unused_page_report()
>> until ready...
>=20
> I don't think there is an issue with us putting buffers on the ring
> before it is ready. I think it will just cause our function to sleep.
>=20
> I'm guessing that is the case since init_vqs will add a buffer to the
> stats vq and that happens even earlier in virtballoon_probe.
>=20

Interesting: "Note: vqs are enabled automatically after probe returns.".
Learned something new.

The virtballoon_changed(vdev) *after* virtio_device_ready(vdev) made me
wonder, because that could also fill the queues.

Maybe Michael can clarify.

>>> +
>>>       virtio_device_ready(vdev);
>>>
>>>       if (towards_target(vb))
>>>               virtballoon_changed(vdev);
>>>       return 0;
>>>
>>> +out_unregister_shrinker:
>>> +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM)=
)
>>> +             virtio_balloon_unregister_shrinker(vb);
>>
>> A sync is done implicitly, right? So after this call, we won't get any
>> new callbacks/are stuck in a callback.
>=20
> From what I can tell a read/write semaphore is used in
> unregister_shrinker when we delete it from the list so it shouldn't be
> an issue.

Yes, makes sense.

>=20
>>>  out_del_balloon_wq:
>>>       if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>>>               destroy_workqueue(vb->balloon_wq);
>>> @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_devic=
e *vdev)
>>>  {
>>>       struct virtio_balloon *vb =3D vdev->priv;
>>>
>>> +     if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
>>> +             page_reporting_unregister(&vb->pr_dev_info);
>>
>> Dito, same question regarding syncs.
>=20
> Yes, although for that one I was using pointer deletion, a barrier,
> and a cancel_work_sync since I didn't support a list.

Okay, perfect.

[...]
>>
>> Small and powerful patch :)
>=20
> Agreed. Although we will have to see if we can keep it that way.
> Ideally I want to leave this with the ability so specify what size
> scatterlist we receive. However if we have to flip it around then it
> will force us to add logic for chopping up the scatterlist for
> processing in chunks.

I hope we can keep it like that. Otherwise each and every driver has to
implement this chopping-up (e.g., a hypervisor that can only send one
hint at a time - e.g., via  a simple hypercall - would have to implement
that).


--=20
Thanks,

David / dhildenb

