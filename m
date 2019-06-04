Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598B1345EB
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 13:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfFDLvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 07:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfFDLvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 07:51:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9496A3B72;
        Tue,  4 Jun 2019 11:51:20 +0000 (UTC)
Received: from [10.40.205.182] (unknown [10.40.205.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45D6867260;
        Tue,  4 Jun 2019 11:50:53 +0000 (UTC)
Subject: Re: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to
 the host
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
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
 <604c496d-4df0-dca9-76dd-048917a5d132@redhat.com>
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
Message-ID: <a0794f3e-cf9c-f30a-5993-229c14fbe662@redhat.com>
Date:   Tue, 4 Jun 2019 07:50:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <604c496d-4df0-dca9-76dd-048917a5d132@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6NjG9l3ZfUIWqwgW8Rw3j6IdLhDSgrraq"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 04 Jun 2019 11:51:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6NjG9l3ZfUIWqwgW8Rw3j6IdLhDSgrraq
Content-Type: multipart/mixed; boundary="wbKqH0DBWRbbu6CF4s9EnEBmdNfs4bh6x";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: David Hildenbrand <david@redhat.com>,
 Alexander Duyck <alexander.duyck@gmail.com>
Cc: kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Paolo Bonzini <pbonzini@redhat.com>,
 lcapitulino@redhat.com, pagupta@redhat.com, wei.w.wang@intel.com,
 Yang Zhang <yang.zhang.wz@gmail.com>, Rik van Riel <riel@surriel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, dhildenb@redhat.com,
 Andrea Arcangeli <aarcange@redhat.com>
Message-ID: <a0794f3e-cf9c-f30a-5993-229c14fbe662@redhat.com>
Subject: Re: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to
 the host
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-3-nitesh@redhat.com>
 <CAKgT0UdtHAvRd++enU3ouxebwV1T4KZbS_JkmyDbJ5jGkA1XaQ@mail.gmail.com>
 <604c496d-4df0-dca9-76dd-048917a5d132@redhat.com>
In-Reply-To: <604c496d-4df0-dca9-76dd-048917a5d132@redhat.com>

--wbKqH0DBWRbbu6CF4s9EnEBmdNfs4bh6x
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/4/19 3:12 AM, David Hildenbrand wrote:
> On 04.06.19 00:38, Alexander Duyck wrote:
>> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com>=
 wrote:
>>> Enables the kernel to negotiate VIRTIO_BALLOON_F_HINTING feature with=
 the
>>> host. If it is available and page_hinting_flag is set to true, page_h=
inting
>>> is enabled and its callbacks are configured along with the max_pages =
count
>>> which indicates the maximum number of pages that can be isolated and =
hinted
>>> at a time. Currently, only free pages of order >=3D (MAX_ORDER - 2) a=
re
>>> reported. To prevent any false OOM max_pages count is set to 16.
>>>
>>> By default page_hinting feature is enabled and gets loaded as soon
>>> as the virtio-balloon driver is loaded. However, it could be disabled=

>>> by writing the page_hinting_flag which is a virtio-balloon parameter.=

>>>
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>> ---
>>>  drivers/virtio/virtio_balloon.c     | 112 ++++++++++++++++++++++++++=
+-
>>>  include/uapi/linux/virtio_balloon.h |  14 ++++
>>>  2 files changed, 125 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_=
balloon.c
>>> index f19061b585a4..40f09ea31643 100644
>>> --- a/drivers/virtio/virtio_balloon.c
>>> +++ b/drivers/virtio/virtio_balloon.c
>>> @@ -31,6 +31,7 @@
>>>  #include <linux/mm.h>
>>>  #include <linux/mount.h>
>>>  #include <linux/magic.h>
>>> +#include <linux/page_hinting.h>
>>>
>>>  /*
>>>   * Balloon device works in 4K page units.  So each page is pointed t=
o by
>>> @@ -48,6 +49,7 @@
>>>  /* The size of a free page block in bytes */
>>>  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
>>>         (1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
>>> +#define VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES  16
>>>
>>>  #ifdef CONFIG_BALLOON_COMPACTION
>>>  static struct vfsmount *balloon_mnt;
>>> @@ -58,6 +60,7 @@ enum virtio_balloon_vq {
>>>         VIRTIO_BALLOON_VQ_DEFLATE,
>>>         VIRTIO_BALLOON_VQ_STATS,
>>>         VIRTIO_BALLOON_VQ_FREE_PAGE,
>>> +       VIRTIO_BALLOON_VQ_HINTING,
>>>         VIRTIO_BALLOON_VQ_MAX
>>>  };
>>>
>>> @@ -67,7 +70,8 @@ enum virtio_balloon_config_read {
>>>
>>>  struct virtio_balloon {
>>>         struct virtio_device *vdev;
>>> -       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_p=
age_vq;
>>> +       struct virtqueue *inflate_vq, *deflate_vq, *stats_vq, *free_p=
age_vq,
>>> +                        *hinting_vq;
>>>
>>>         /* Balloon's own wq for cpu-intensive work items */
>>>         struct workqueue_struct *balloon_wq;
>>> @@ -125,6 +129,9 @@ struct virtio_balloon {
>>>
>>>         /* To register a shrinker to shrink memory upon memory pressu=
re */
>>>         struct shrinker shrinker;
>>> +
>>> +       /* object pointing at the array of isolated pages ready for h=
inting */
>>> +       struct hinting_data *hinting_arr;
>> Just make this an array of size VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES.=

>> It will save a bunch of complexity later.
> +1
>
> [...]
>>> +struct virtio_balloon *hvb;
>>> +bool page_hinting_flag =3D true;
>>> +module_param(page_hinting_flag, bool, 0444);
>>> +MODULE_PARM_DESC(page_hinting_flag, "Enable page hinting");
>>> +
>>> +static bool virtqueue_kick_sync(struct virtqueue *vq)
>>> +{
>>> +       u32 len;
>>> +
>>> +       if (likely(virtqueue_kick(vq))) {
>>> +               while (!virtqueue_get_buf(vq, &len) &&
>>> +                      !virtqueue_is_broken(vq))
>>> +                       cpu_relax();
>>> +               return true;
>> Is this a synchronous setup? It seems kind of wasteful to have a
>> thread busy waiting here like this. It might make more sense to just
>> make this work like the other balloon queues and have a wait event
>> with a wake up in the interrupt handler for the queue.
> +1
>
> [...]
>
>>> +       gpaddr =3D virt_to_phys(hvb->hinting_arr);
>>> +       hint_req->phys_addr =3D cpu_to_virtio64(hvb->vdev, gpaddr);
>>> +       hint_req->size =3D cpu_to_virtio32(hvb->vdev, entries);
>>> +       sg_init_one(&sg, hint_req, sizeof(*hint_req));
>>> +       err =3D virtqueue_add_outbuf(vq, &sg, 1, hint_req, GFP_KERNEL=
);
>>> +       if (!err)
>>> +               virtqueue_kick_sync(hvb->hinting_vq);
>>> +
>>> +       kfree(hint_req);
>>> +}
>>> +
>>> +int page_hinting_prepare(void)
>>> +{
>>> +       hvb->hinting_arr =3D kmalloc_array(VIRTIO_BALLOON_PAGE_HINTIN=
G_MAX_PAGES,
>>> +                                        sizeof(*hvb->hinting_arr), G=
FP_KERNEL);
>>> +       if (!hvb->hinting_arr)
>>> +               return -ENOMEM;
>>> +       return 0;
>>> +}
>>> +
>> Why make the hinting_arr a dynamic allocation? You should probably
>> just make it a static array within the virtio_balloon structure. Then
>> you don't have the risk of an allocation failing and messing up the
>> hints.
> +1
>
>>> +void hint_pages(struct list_head *pages)
>>> +{
>>> +       struct page *page, *next;
>>> +       unsigned long pfn;
>>> +       int idx =3D 0, order;
>>> +
>>> +       list_for_each_entry_safe(page, next, pages, lru) {
>>> +               pfn =3D page_to_pfn(page);
>>> +               order =3D page_private(page);
>>> +               hvb->hinting_arr[idx].phys_addr =3D pfn << PAGE_SHIFT=
;
>>> +               hvb->hinting_arr[idx].size =3D (1 << order) * PAGE_SI=
ZE;
>>> +               idx++;
>>> +       }
>>> +       page_hinting_report(idx);
>>> +}
>>> +
>> Getting back to my suggestion from earlier today. It might make sense
>> to not bother with the PAGE_SHIFT or PAGE_SIZE multiplication if you
>> just record everything in VIRTIO_BALLOON_PAGES intead of using the
>> actual address and size.
> I think I prefer "addr + size".
>
>> Same comment here. Make this array a part of virtio_balloon and you
>> don't have to free it.
>>
>>> +static const struct page_hinting_cb hcb =3D {
>>> +       .prepare =3D page_hinting_prepare,
>>> +       .hint_pages =3D hint_pages,
>>> +       .cleanup =3D page_hinting_cleanup,
>>> +       .max_pages =3D VIRTIO_BALLOON_PAGE_HINTING_MAX_PAGES,
>>> +};
>> With the above changes prepare and cleanup can be dropped.
> +1
>
>>> +#endif
>>> +
>>>  static u32 page_to_balloon_pfn(struct page *page)
>>>  {
>>>         unsigned long pfn =3D page_to_pfn(page);
>>> @@ -488,6 +574,7 @@ static int init_vqs(struct virtio_balloon *vb)
>>>         names[VIRTIO_BALLOON_VQ_DEFLATE] =3D "deflate";
>>>         names[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
>>>         names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
>>> +       names[VIRTIO_BALLOON_VQ_HINTING] =3D NULL;
>>>
>>>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) =
{
>>>                 names[VIRTIO_BALLOON_VQ_STATS] =3D "stats";
>>> @@ -499,11 +586,18 @@ static int init_vqs(struct virtio_balloon *vb)
>>>                 callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
>>>         }
>>>
>>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {=

>>> +               names[VIRTIO_BALLOON_VQ_HINTING] =3D "hinting_vq";
>>> +               callbacks[VIRTIO_BALLOON_VQ_HINTING] =3D NULL;
>>> +       }
>>>         err =3D vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_V=
Q_MAX,
>>>                                          vqs, callbacks, names, NULL,=
 NULL);
>>>         if (err)
>>>                 return err;
>>>
>>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING))
>>> +               vb->hinting_vq =3D vqs[VIRTIO_BALLOON_VQ_HINTING];
>>> +
>>>         vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
>>>         vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
>>>         if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) =
{
>>> @@ -942,6 +1036,14 @@ static int virtballoon_probe(struct virtio_devi=
ce *vdev)
>>>                 if (err)
>>>                         goto out_del_balloon_wq;
>>>         }
>>> +
>>> +#ifdef CONFIG_PAGE_HINTING
>>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING) &&=

>>> +           page_hinting_flag) {
>>> +               hvb =3D vb;
>>> +               page_hinting_enable(&hcb);
>>> +       }
>>> +#endif
>>>         virtio_device_ready(vdev);
>>>
>>>         if (towards_target(vb))
>>> @@ -989,6 +1091,12 @@ static void virtballoon_remove(struct virtio_de=
vice *vdev)
>>>                 destroy_workqueue(vb->balloon_wq);
>>>         }
>>>
>>> +#ifdef CONFIG_PAGE_HINTING
>>> +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_HINTING)) {=

> Nitesh, you should only disable if you actually enabled it
> (page_hinting_flag).
+1, thanks.
>
>
--=20
Regards
Nitesh


--wbKqH0DBWRbbu6CF4s9EnEBmdNfs4bh6x--

--6NjG9l3ZfUIWqwgW8Rw3j6IdLhDSgrraq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz2WxkACgkQo4ZA3AYy
ozm1FQ//XVKSJNgjmz/qdXNXpETt9ez/6slhNIBrFzlSaoU3WUS+dR3ZFQOSBLoA
G7RqLPYmhgh56fmgTd5hHEOYAtsYvAM76QfLZL2lRGN+4ePaqxO4UN81Ooz6qszr
yJf39XennhsYuYX33BGlg9bBn4wVSmt81wzTN//f0eto7guAdBtuhNdE6oNA8jOm
YNN28AmKKTWS/gwsurfxNc/gSv8l+PrrFqkXUH3KLGgYH9JJpHoh1xJvCEhbEbj/
fkDoLeeCaRGUBCZi8ykl+e+jpxucnP17gxtv+AYu+KuWH7zrz46vUzaTdVxcujHT
OKhBVI/KdHpVmcoIQf8z3lWgSMQvMVvXTvtxi+l44oeke6ojIR+ZR2VYYPodW1VG
e7UaDPd+BZtErJTVgOYmjd+tOShCP32j51H14kMvXgnDj/rNBPpUCzpHClSXF3o1
pKrHdDLNDSY//sk/nL+PVCLKQQDdwCZvFgkni3/uunl4QtlKdNIqTkhEhfLL9Fhv
su6yHpUEajB/lLllatOU6i1Q3vr/RQFIQUiyVFpRJ/B1YmwQVDkQAEKbBC30g9+T
ZeLp0cZEB4obElNWc9UGeHLPq1JF4I6LgXjpopGfsyj5tC6u+wZ5TlruM6UM079r
tPNzZ96Oy5n9zLbVnsGLUmoQlZZMqP/yz8TkKC6UPmvv1kbwEG4=
=vf8e
-----END PGP SIGNATURE-----

--6NjG9l3ZfUIWqwgW8Rw3j6IdLhDSgrraq--
