Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731F933881
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 20:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfFCSqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 14:46:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFCSqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 14:46:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37A4B30001D9;
        Mon,  3 Jun 2019 18:46:01 +0000 (UTC)
Received: from [10.40.205.157] (unknown [10.40.205.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3026C17ADA;
        Mon,  3 Jun 2019 18:45:44 +0000 (UTC)
Subject: Re: [QEMU PATCH] KVM: Support for page hinting
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
 <20190603170432.1195-1-nitesh@redhat.com>
 <CAKgT0Udqm2qNQ1+mPkx7vx=c2a7Hjq92fKM30041e1kU47bcHA@mail.gmail.com>
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
Message-ID: <62b7adca-1cf6-f0d8-ab25-4a112a526754@redhat.com>
Date:   Mon, 3 Jun 2019 14:45:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udqm2qNQ1+mPkx7vx=c2a7Hjq92fKM30041e1kU47bcHA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o8VQJL8y5992b75EUeyDmBeTsYYoy1VP3"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 03 Jun 2019 18:46:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o8VQJL8y5992b75EUeyDmBeTsYYoy1VP3
Content-Type: multipart/mixed; boundary="r4YEkflGxLwWHWDYJ0BojViM41paD6JNA";
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
Message-ID: <62b7adca-1cf6-f0d8-ab25-4a112a526754@redhat.com>
Subject: Re: [QEMU PATCH] KVM: Support for page hinting
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170432.1195-1-nitesh@redhat.com>
 <CAKgT0Udqm2qNQ1+mPkx7vx=c2a7Hjq92fKM30041e1kU47bcHA@mail.gmail.com>
In-Reply-To: <CAKgT0Udqm2qNQ1+mPkx7vx=c2a7Hjq92fKM30041e1kU47bcHA@mail.gmail.com>

--r4YEkflGxLwWHWDYJ0BojViM41paD6JNA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 6/3/19 2:34 PM, Alexander Duyck wrote:
> On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> =
wrote:
>> Enables QEMU to call madvise on the pages which are reported
>> by the guest kernel.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> What commit-id is this meant to apply on top of? I can't apply this to
> the latest development version of QEMU.
>
>> ---
>>  hw/virtio/trace-events                        |  1 +
>>  hw/virtio/virtio-balloon.c                    | 85 ++++++++++++++++++=
+
>>  include/hw/virtio/virtio-balloon.h            |  2 +-
>>  include/qemu/osdep.h                          |  7 ++
>>  .../standard-headers/linux/virtio_balloon.h   |  1 +
>>  5 files changed, 95 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
>> index 07bcbe9e85..015565785c 100644
>> --- a/hw/virtio/trace-events
>> +++ b/hw/virtio/trace-events
>> @@ -46,3 +46,4 @@ virtio_balloon_handle_output(const char *name, uint6=
4_t gpa) "section name: %s g
>>  virtio_balloon_get_config(uint32_t num_pages, uint32_t actual) "num_p=
ages: %d actual: %d"
>>  virtio_balloon_set_config(uint32_t actual, uint32_t oldactual) "actua=
l: %d oldactual: %d"
>>  virtio_balloon_to_target(uint64_t target, uint32_t num_pages) "balloo=
n target: 0x%"PRIx64" num_pages: %d"
>> +virtio_balloon_hinting_request(unsigned long pfn, unsigned int num_pa=
ges) "Guest page hinting request: %lu size: %d"
>> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
>> index a12677d4d5..cbb630279c 100644
>> --- a/hw/virtio/virtio-balloon.c
>> +++ b/hw/virtio/virtio-balloon.c
>> @@ -33,6 +33,13 @@
>>
>>  #define BALLOON_PAGE_SIZE  (1 << VIRTIO_BALLOON_PFN_SHIFT)
>>
>> +struct guest_pages {
>> +       uint64_t phys_addr;
>> +       uint32_t len;
>> +};
>> +
> Any reason for matching up 64b addr w/ 32b size? The way I see it you
> would be be better off going with either 64b for both or 32b for both.
> I opted for the 32b approach in my case since there was already code
> in place for doing the PFN shift anyway in the standard virtio_balloon
> code path.
>
>> +void page_hinting_request(uint64_t addr, uint32_t len);
>> +
>>  static void balloon_page(void *addr, int deflate)
>>  {
>>      if (!qemu_balloon_is_inhibited()) {
>> @@ -207,6 +214,80 @@ static void balloon_stats_set_poll_interval(Objec=
t *obj, Visitor *v,
>>      balloon_stats_change_timer(s, 0);
>>  }
>>
>> +static void *gpa2hva(MemoryRegion **p_mr, hwaddr addr, Error **errp)
>> +{
>> +    MemoryRegionSection mrs =3D memory_region_find(get_system_memory(=
),
>> +                                                 addr, 1);
>> +
>> +    if (!mrs.mr) {
>> +        error_setg(errp, "No memory is mapped at address 0x%" HWADDR_=
PRIx, addr);
>> +        return NULL;
>> +    }
>> +
>> +    if (!memory_region_is_ram(mrs.mr) && !memory_region_is_romd(mrs.m=
r)) {
>> +        error_setg(errp, "Memory at address 0x%" HWADDR_PRIx "is not =
RAM", addr);
>> +        memory_region_unref(mrs.mr);
>> +        return NULL;
>> +    }
>> +
>> +    *p_mr =3D mrs.mr;
>> +    return qemu_map_ram_ptr(mrs.mr->ram_block, mrs.offset_within_regi=
on);
>> +}
>> +
>> +void page_hinting_request(uint64_t addr, uint32_t len)
>> +{
>> +    Error *local_err =3D NULL;
>> +    MemoryRegion *mr =3D NULL;
>> +    int ret =3D 0;
>> +    struct guest_pages *guest_obj;
>> +    int i =3D 0;
>> +    void *hvaddr_to_free;
>> +    uint64_t gpaddr_to_free;
>> +    void * temp_addr =3D gpa2hva(&mr, addr, &local_err);
>> +
>> +    if (local_err) {
>> +        error_report_err(local_err);
>> +        return;
>> +    }
>> +    guest_obj =3D temp_addr;
>> +    while (i < len) {
>> +       gpaddr_to_free =3D guest_obj[i].phys_addr;
>> +       trace_virtio_balloon_hinting_request(gpaddr_to_free,guest_obj[=
i].len);
>> +       hvaddr_to_free =3D gpa2hva(&mr, gpaddr_to_free, &local_err);
>> +       if (local_err) {
>> +               error_report_err(local_err);
>> +               return;
>> +       }
>> +       ret =3D qemu_madvise((void *)hvaddr_to_free, guest_obj[i].len,=
 QEMU_MADV_FREE);
>> +       if (ret =3D=3D -1)
>> +           printf("\n%d:%s Error: Madvise failed with error:%d\n", __=
LINE__, __func__, ret);
>> +       i++;
>> +    }
>> +}
>> +
> Have we made any determination yet on the MADV_FREE vs MADV_DONT_NEED?
One of the reason was mentioned by Andrea last time.
But I don't have any stats to prove one is better than the other.
It is in my todo list.
> My preference would be to have this code just reuse the existing
> balloon code as I did in my patch set. Then we can avoid the need to
> have multiple types in use. We could just have the balloon use the
> same as the hint.
>
>> +static void virtio_balloon_page_hinting(VirtIODevice *vdev, VirtQueue=
 *vq)
>> +{
>> +    VirtQueueElement *elem =3D NULL;
>> +    uint64_t temp_addr;
>> +    uint32_t temp_len;
>> +    size_t size, t_size =3D 0;
>> +
>> +    elem =3D virtqueue_pop(vq, sizeof(VirtQueueElement));
>> +    if (!elem) {
>> +       printf("\npop error\n");
>> +       return;
>> +    }
>> +    size =3D iov_to_buf(elem->out_sg, elem->out_num, 0, &temp_addr, s=
izeof(temp_addr));
>> +    t_size +=3D size;
>> +    size =3D iov_to_buf(elem->out_sg, elem->out_num, 8, &temp_len, si=
zeof(temp_len));
>> +    t_size +=3D size;
>> +    if (!qemu_balloon_is_inhibited())
>> +           page_hinting_request(temp_addr, temp_len);
>> +    virtqueue_push(vq, elem, t_size);
>> +    virtio_notify(vdev, vq);
>> +    g_free(elem);
>> +}
>> +
> If you are doing a u64 addr, and a u32 len, does that mean you are
> having to use a packed array between the guest and the host? This
> would be another good reason to have both settle on either u64 or u32.
I will take a look at this, thanks.
>
>>  static void virtio_balloon_handle_output(VirtIODevice *vdev, VirtQueu=
e *vq)
>>  {
>>      VirtIOBalloon *s =3D VIRTIO_BALLOON(vdev);
>> @@ -376,6 +457,7 @@ static uint64_t virtio_balloon_get_features(VirtIO=
Device *vdev, uint64_t f,
>>      VirtIOBalloon *dev =3D VIRTIO_BALLOON(vdev);
>>      f |=3D dev->host_features;
>>      virtio_add_feature(&f, VIRTIO_BALLOON_F_STATS_VQ);
>> +    virtio_add_feature(&f, VIRTIO_BALLOON_F_HINTING);
>>      return f;
>>  }
>>
>> @@ -445,6 +527,7 @@ static void virtio_balloon_device_realize(DeviceSt=
ate *dev, Error **errp)
>>      s->ivq =3D virtio_add_queue(vdev, 128, virtio_balloon_handle_outp=
ut);
>>      s->dvq =3D virtio_add_queue(vdev, 128, virtio_balloon_handle_outp=
ut);
>>      s->svq =3D virtio_add_queue(vdev, 128, virtio_balloon_receive_sta=
ts);
>> +    s->hvq =3D virtio_add_queue(vdev, 128, virtio_balloon_page_hintin=
g);
>>
>>      reset_stats(s);
>>  }
>> @@ -488,6 +571,8 @@ static void virtio_balloon_instance_init(Object *o=
bj)
>>
>>      object_property_add(obj, "guest-stats", "guest statistics",
>>                          balloon_stats_get_all, NULL, NULL, s, NULL);
>> +    object_property_add(obj, "guest-page-hinting", "guest page hintin=
g",
>> +                        NULL, NULL, NULL, s, NULL);
>>
>>      object_property_add(obj, "guest-stats-polling-interval", "int",
>>                          balloon_stats_get_poll_interval,
>> diff --git a/include/hw/virtio/virtio-balloon.h b/include/hw/virtio/vi=
rtio-balloon.h
>> index e0df3528c8..774498a6ca 100644
>> --- a/include/hw/virtio/virtio-balloon.h
>> +++ b/include/hw/virtio/virtio-balloon.h
>> @@ -32,7 +32,7 @@ typedef struct virtio_balloon_stat_modern {
>>
>>  typedef struct VirtIOBalloon {
>>      VirtIODevice parent_obj;
>> -    VirtQueue *ivq, *dvq, *svq;
>> +    VirtQueue *ivq, *dvq, *svq, *hvq;
>>      uint32_t num_pages;
>>      uint32_t actual;
>>      uint64_t stats[VIRTIO_BALLOON_S_NR];
>> diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
>> index 840af09cb0..4d632933a9 100644
>> --- a/include/qemu/osdep.h
>> +++ b/include/qemu/osdep.h
>> @@ -360,6 +360,11 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>>  #else
>>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
>>  #endif
>> +#ifdef MADV_FREE
>> +#define QEMU_MADV_FREE MADV_FREE
>> +#else
>> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>> +#endif
>>
>>  #elif defined(CONFIG_POSIX_MADVISE)
>>
>> @@ -373,6 +378,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
>> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>>
>>  #else /* no-op */
>>
>> @@ -386,6 +392,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
>>  #define QEMU_MADV_HUGEPAGE  QEMU_MADV_INVALID
>>  #define QEMU_MADV_NOHUGEPAGE  QEMU_MADV_INVALID
>>  #define QEMU_MADV_REMOVE QEMU_MADV_INVALID
>> +#define QEMU_MADV_FREE QEMU_MADV_INVALID
>>
>>  #endif
>>
>> diff --git a/include/standard-headers/linux/virtio_balloon.h b/include=
/standard-headers/linux/virtio_balloon.h
>> index 4dbb7dc6c0..f50c0d95ea 100644
>> --- a/include/standard-headers/linux/virtio_balloon.h
>> +++ b/include/standard-headers/linux/virtio_balloon.h
>> @@ -34,6 +34,7 @@
>>  #define VIRTIO_BALLOON_F_MUST_TELL_HOST        0 /* Tell before recla=
iming pages */
>>  #define VIRTIO_BALLOON_F_STATS_VQ      1 /* Memory Stats virtqueue */=

>>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM        2 /* Deflate balloon o=
n OOM */
>> +#define VIRTIO_BALLOON_F_HINTING       5 /* Page hinting virtqueue */=

> So this is obviously built against an old version of QEMU, the latest
> values for this include:
> #define VIRTIO_BALLOON_F_FREE_PAGE_HINT 3 /* VQ to report free pages */=

> #define VIRTIO_BALLOON_F_PAGE_POISON    4 /* Guest is using page poison=
ing */
>
> I wonder if we shouldn't look for a term other than "HINT"=20
We may have to come up with a different/better naming convention to
avoid any confusion.
> since there
> is already the code around providing hints to migration.
I will re-base to the top next time around.
--=20
Regards
Nitesh


--r4YEkflGxLwWHWDYJ0BojViM41paD6JNA--

--o8VQJL8y5992b75EUeyDmBeTsYYoy1VP3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAlz1atUACgkQo4ZA3AYy
ozl7DhAAxVWOwVKlmpB6uWcwxYXJQatHCV6ZJa4ekNFqJKootp9iG4/Z41vHLZqs
YcLX+OAH8ZmbcduO8KMQ4QpYh5YP/bkdazH7NA9sc/fijAyN0MFyErUvv8z8e7jH
CfMbPGwoz7L4/NQuGsV2MaXIFEWf4seP2X7s2aPjXDK5seLig+fHhKfejUr2LlqL
/ETiCk02uBdrIUXQ7O6fEWyTA0NfphYL+Mob7YS09BnOZ80lmQijjYFrh+eZnmlb
ZdRSIdjgdtEzIZnL1ocZ9aQB7uZb62DFhNnMI9SWhyHtwdv9ygEk22VrVg2BWtrk
FdasW9CZwxhMQD0qDPxeWA15U1twoc3DFwsKJMi6N6r86/noUzssNVXJdYT1op96
AXRBeqoYZaFRCZVcICO+wO7hXT7Xf9VAXI0UJynyjdHl22srd7dNbLmX4QNYOGsr
lok2zSucpSnCsy9amS3Q7hwjVImsdscgndRiYyHDxw7+k+MBkZfitsI2Hz1YFk4Z
pI9DMd+XqIL+PnfTgoysYIrxExmIw3/sFWV7vW4qsdzt24n0qFUUn7WDDNpq8a2N
Lqk6kd4jG5A7EZ7niQOy7xqY0Q4rkscFVFQyEjKMgj0ShQTIES0ZCfQocvmy9FAy
h2GC7UZt6d1Hy5zI4DSMSOE0wVDedtQxFEpFQB9ufW64fdCJAw4=
=DyEG
-----END PGP SIGNATURE-----

--o8VQJL8y5992b75EUeyDmBeTsYYoy1VP3--
