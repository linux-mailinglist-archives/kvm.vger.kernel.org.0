Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A47F10CBAE
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfK1P0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:26:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35624 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfK1P0P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:26:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574954773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=AH9WJHTKN2Z8B/lBkdeBKWMIO3FfZw+i+u+gdYfmLmQ=;
        b=IqHOuH+tHz0YgUgQmAdesC3jeiibOSISEuhH9Un2wpVG5/m+lKj+lnSPVr+zVo3OzX/p02
        O+wPSOhPU6qmI4lREEGHkTw+8fcHcHJdmNNFJdaRf4RpHnLM4Rv/U75aSXizWayQlnd3/7
        msyyen9oOYxR7eUUrNPSIrI8f7i9suo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-XFxbmr_BOpaMBX0l6xe1Ng-1; Thu, 28 Nov 2019 10:26:12 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A0D91800D52;
        Thu, 28 Nov 2019 15:26:09 +0000 (UTC)
Received: from [10.36.118.27] (unknown [10.36.118.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 085775C1B0;
        Thu, 28 Nov 2019 15:25:54 +0000 (UTC)
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABtCREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT6JAj4EEwECACgFAljj9eoCGwMFCQlmAYAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEE3eEPcA/4Na5IIP/3T/FIQMxIfNzZshIq687qgG
 8UbspuE/YSUDdv7r5szYTK6KPTlqN8NAcSfheywbuYD9A4ZeSBWD3/NAVUdrCaRP2IvFyELj
 xoMvfJccbq45BxzgEspg/bVahNbyuBpLBVjVWwRtFCUEXkyazksSv8pdTMAs9IucChvFmmq3
 jJ2vlaz9lYt/lxN246fIVceckPMiUveimngvXZw21VOAhfQ+/sofXF8JCFv2mFcBDoa7eYob
 s0FLpmqFaeNRHAlzMWgSsP80qx5nWWEvRLdKWi533N2vC/EyunN3HcBwVrXH4hxRBMco3jvM
 m8VKLKao9wKj82qSivUnkPIwsAGNPdFoPbgghCQiBjBe6A75Z2xHFrzo7t1jg7nQfIyNC7ez
 MZBJ59sqA9EDMEJPlLNIeJmqslXPjmMFnE7Mby/+335WJYDulsRybN+W5rLT5aMvhC6x6POK
 z55fMNKrMASCzBJum2Fwjf/VnuGRYkhKCqqZ8gJ3OvmR50tInDV2jZ1DQgc3i550T5JDpToh
 dPBxZocIhzg+MBSRDXcJmHOx/7nQm3iQ6iLuwmXsRC6f5FbFefk9EjuTKcLMvBsEx+2DEx0E
 UnmJ4hVg7u1PQ+2Oy+Lh/opK/BDiqlQ8Pz2jiXv5xkECvr/3Sv59hlOCZMOaiLTTjtOIU7Tq
 7ut6OL64oAq+uQINBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCghCj/CA/lc/LMthqQ773ga
 uB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseBfDXHA6m4B3mUTWo13nid
 0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts6TZ+IrPOwT1hfB4WNC+X
 2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiuQmt3yqrmN63V9wzaPhC+
 xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKBTccu2AXJXWAE1Xjh6GOC
 8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvFFFyAS0Nk1q/7EChPcbRb
 hJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh2YmnmLRTro6eZ/qYwWkC
 u8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRkF3TwgucpyPtcpmQtTkWS
 gDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0LLH63+BrrHasfJzxKXzqg
 rW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4vq7oFCPsOgwARAQABiQIl
 BBgBAgAPBQJVy5+RAhsMBQkJZgGAAAoJEE3eEPcA/4NagOsP/jPoIBb/iXVbM+fmSHOjEshl
 KMwEl/m5iLj3iHnHPVLBUWrXPdS7iQijJA/VLxjnFknhaS60hkUNWexDMxVVP/6lbOrs4bDZ
 NEWDMktAeqJaFtxackPszlcpRVkAs6Msn9tu8hlvB517pyUgvuD7ZS9gGOMmYwFQDyytpepo
 YApVV00P0u3AaE0Cj/o71STqGJKZxcVhPaZ+LR+UCBZOyKfEyq+ZN311VpOJZ1IvTExf+S/5
 lqnciDtbO3I4Wq0ArLX1gs1q1XlXLaVaA3yVqeC8E7kOchDNinD3hJS4OX0e1gdsx/e6COvy
 qNg5aL5n0Kl4fcVqM0LdIhsubVs4eiNCa5XMSYpXmVi3HAuFyg9dN+x8thSwI836FoMASwOl
 C7tHsTjnSGufB+D7F7ZBT61BffNBBIm1KdMxcxqLUVXpBQHHlGkbwI+3Ye+nE6HmZH7IwLwV
 W+Ajl7oYF+jeKaH4DZFtgLYGLtZ1LDwKPjX7VAsa4Yx7S5+EBAaZGxK510MjIx6SGrZWBrrV
 TEvdV00F2MnQoeXKzD7O4WFbL55hhyGgfWTHwZ457iN9SgYi1JLPqWkZB0JRXIEtjd4JEQcx
 +8Umfre0Xt4713VxMygW0PnQt5aSQdMD58jHFxTk092mU+yIHj5LeYgvwSgZN4airXk5yRXl
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
Date:   Thu, 28 Nov 2019 16:25:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191119214653.24996.90695.stgit@localhost.localdomain>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: XFxbmr_BOpaMBX0l6xe1Ng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.11.19 22:46, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>=20
> Add support for the page reporting feature provided by virtio-balloon.
> Reporting differs from the regular balloon functionality in that is is
> much less durable than a standard memory balloon. Instead of creating a
> list of pages that cannot be accessed the pages are only inaccessible
> while they are being indicated to the virtio interface. Once the
> interface has acknowledged them they are placed back into their respectiv=
e
> free lists and are once again accessible by the guest system.

Maybe add something like "In contrast to ordinary balloon
inflation/deflation, the guest can reuse all reported pages immediately
after reporting has finished, without having to notify the hypervisor
about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."

[...]

>  /*
>   * Balloon device works in 4K page units.  So each page is pointed to by
> @@ -37,6 +38,9 @@
>  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
>  =09(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> =20
> +/*  limit on the number of pages that can be on the reporting vq */
> +#define VIRTIO_BALLOON_VRING_HINTS_MAX=0916

Maybe rename that from HINTS to REPORTS

> +
>  #ifdef CONFIG_BALLOON_COMPACTION
>  static struct vfsmount *balloon_mnt;
>  #endif
> @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
>  =09VIRTIO_BALLOON_VQ_DEFLATE,
>  =09VIRTIO_BALLOON_VQ_STATS,
>  =09VIRTIO_BALLOON_VQ_FREE_PAGE,
> +=09VIRTIO_BALLOON_VQ_REPORTING,
>  =09VIRTIO_BALLOON_VQ_MAX
>  };
> =20
> @@ -113,6 +118,10 @@ struct virtio_balloon {
> =20
>  =09/* To register a shrinker to shrink memory upon memory pressure */
>  =09struct shrinker shrinker;
> +
> +=09/* Unused page reporting device */

Sounds like the device is unused :D

"Device info for reporting unused pages" ?

I am in general wondering, should we rename "unused" to "free". I.e.,
"free page reporting" instead of "unused page reporting"? Or what was
the motivation behind using "unused" ?

> +=09struct virtqueue *reporting_vq;
> +=09struct page_reporting_dev_info pr_dev_info;
>  };
> =20
>  static struct virtio_device_id id_table[] =3D {
> @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, str=
uct virtqueue *vq)
> =20
>  }
> =20
> +void virtballoon_unused_page_report(struct page_reporting_dev_info *pr_d=
ev_info,
> +=09=09=09=09    unsigned int nents)
> +{
> +=09struct virtio_balloon *vb =3D
> +=09=09container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> +=09struct virtqueue *vq =3D vb->reporting_vq;
> +=09unsigned int unused, err;
> +
> +=09/* We should always be able to add these buffers to an empty queue. *=
/

This comment somewhat contradicts the error handling (and comment)
below. Maybe just drop it?

> +=09err =3D virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> +=09=09=09=09  GFP_NOWAIT | __GFP_NOWARN);
> +
> +=09/*
> +=09 * In the extremely unlikely case that something has changed and we
> +=09 * are able to trigger an error we will simply display a warning
> +=09 * and exit without actually processing the pages.
> +=09 */
> +=09if (WARN_ON(err))
> +=09=09return;

Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)

> +
> +=09virtqueue_kick(vq);
> +
> +=09/* When host has read buffer, this completes via balloon_ack */
> +=09wait_event(vb->acked, virtqueue_get_buf(vq, &unused));

Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
queue? What if both mechanisms are used concurrently and race/both wait
for the hypervisor?

Maybe we need a separate vb->acked + callback function.

> +}
> +
>  static void set_page_pfns(struct virtio_balloon *vb,
>  =09=09=09  __virtio32 pfns[], struct page *page)
>  {
> @@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  =09names[VIRTIO_BALLOON_VQ_DEFLATE] =3D "deflate";
>  =09names[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
>  =09names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> +=09names[VIRTIO_BALLOON_VQ_REPORTING] =3D NULL;
> =20
>  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>  =09=09names[VIRTIO_BALLOON_VQ_STATS] =3D "stats";
> @@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
>  =09=09callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
>  =09}
> =20
> +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +=09=09names[VIRTIO_BALLOON_VQ_REPORTING] =3D "reporting_vq";
> +=09=09callbacks[VIRTIO_BALLOON_VQ_REPORTING] =3D balloon_ack;
> +=09}
> +
>  =09err =3D vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>  =09=09=09=09=09 vqs, callbacks, names, NULL, NULL);
>  =09if (err)
>  =09=09return err;
> =20
> +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +=09=09vb->reporting_vq =3D vqs[VIRTIO_BALLOON_VQ_REPORTING];
> +

I'd register these in the same order they are defined (IOW, move this
further down)

>  =09vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
>  =09vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_device *=
vdev)
>  =09=09if (err)
>  =09=09=09goto out_del_balloon_wq;
>  =09}
> +
> +=09vb->pr_dev_info.report =3D virtballoon_unused_page_report;
> +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +=09=09unsigned int capacity;
> +
> +=09=09capacity =3D min_t(unsigned int,
> +=09=09=09=09 virtqueue_get_vring_size(vb->reporting_vq),
> +=09=09=09=09 VIRTIO_BALLOON_VRING_HINTS_MAX);
> +=09=09vb->pr_dev_info.capacity =3D capacity;
> +
> +=09=09err =3D page_reporting_register(&vb->pr_dev_info);
> +=09=09if (err)
> +=09=09=09goto out_unregister_shrinker;
> +=09}

It can happen here that we start reporting before marking the device
ready. Can that be problematic?

Maybe we have to ignore any reports in virtballoon_unused_page_report()
until ready...

> +
>  =09virtio_device_ready(vdev);
> =20
>  =09if (towards_target(vb))
>  =09=09virtballoon_changed(vdev);
>  =09return 0;
> =20
> +out_unregister_shrinker:
> +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> +=09=09virtio_balloon_unregister_shrinker(vb);

A sync is done implicitly, right? So after this call, we won't get any
new callbacks/are stuck in a callback.

>  out_del_balloon_wq:
>  =09if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  =09=09destroy_workqueue(vb->balloon_wq);
> @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_device =
*vdev)
>  {
>  =09struct virtio_balloon *vb =3D vdev->priv;
> =20
> +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +=09=09page_reporting_unregister(&vb->pr_dev_info);

Dito, same question regarding syncs.

>  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
>  =09=09virtio_balloon_unregister_shrinker(vb);
>  =09spin_lock_irq(&vb->stop_update_lock);
> @@ -1038,6 +1102,7 @@ static int virtballoon_validate(struct virtio_devic=
e *vdev)
>  =09VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
>  =09VIRTIO_BALLOON_F_FREE_PAGE_HINT,
>  =09VIRTIO_BALLOON_F_PAGE_POISON,
> +=09VIRTIO_BALLOON_F_REPORTING,
>  };
> =20
>  static struct virtio_driver virtio_balloon_driver =3D {
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/vir=
tio_balloon.h
> index a1966cd7b677..19974392d324 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -36,6 +36,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM=092 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT=093 /* VQ to report free pages *=
/
>  #define VIRTIO_BALLOON_F_PAGE_POISON=094 /* Guest is using page poisonin=
g */
> +#define VIRTIO_BALLOON_F_REPORTING=095 /* Page reporting virtqueue */
> =20
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
>=20
>=20

Small and powerful patch :)

--=20
Thanks,

David / dhildenb

