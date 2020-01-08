Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B9133C87
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 08:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgAHH6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 02:58:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgAHH6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 02:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578470282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=3dmWQU4K3AqhLAU0j1T/evADH+vQEyjC60UvFGd/1KI=;
        b=ho2bOVVGnVH9uBS93BWTTus5ZabvwYPDXV96V9ULpCahshbxC3Y91rGy2a0ahfu/BHWmxf
        hRLRVKqw4IpbZsf1ya/NbeQyXK6xY9HIwvhekCyJJOwtDIx5zC2uSlRyJ5+d6NxlGqndiK
        ivDg8WAKkD6LmvGFOjYGt8vgXypfSDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-I1C0wdd1NqS3LgNf2H9Tsg-1; Wed, 08 Jan 2020 02:58:01 -0500
X-MC-Unique: I1C0wdd1NqS3LgNf2H9Tsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E814107ACC5;
        Wed,  8 Jan 2020 07:57:58 +0000 (UTC)
Received: from [10.40.204.26] (ovpn-204-26.brq.redhat.com [10.40.204.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC22E5C241;
        Wed,  8 Jan 2020 07:57:35 +0000 (UTC)
Subject: Re: [PATCH v16 0/9] mm / virtio: Provide support for free page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
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
Message-ID: <aebf72d6-3383-fcc5-7cea-efb930e4e245@redhat.com>
Date:   Wed, 8 Jan 2020 02:57:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/3/20 4:16 PM, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting free guest page=
s
> to a hypervisor so that the memory associated with those pages can be
> dropped and reused by other processes and/or guests on the host. Using
> this it is possible to avoid unnecessary I/O to disk and greatly improv=
e
> performance in the case of memory overcommit on the host.
>
> When enabled we will be performing a scan of free memory every 2 second=
s
> while pages of sufficiently high order are being freed. In each pass at=

> least one sixteenth of each free list will be reported. By doing this w=
e
> avoid racing against other threads that may be causing a high amount of=

> memory churn.
>
> The lowest page order currently scanned when reporting pages is
> pageblock_order so that this feature will not interfere with the use of=

> Transparent Huge Pages in the case of virtualization.
>
> Currently this is only in use by virtio-balloon however there is the ho=
pe
> that at some point in the future other hypervisors might be able to mak=
e
> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> currently using MADV_DONTNEED to indicate to the host kernel that the p=
age
> is currently free. It will be zeroed and faulted back into the guest th=
e
> next time the page is accessed.
>
> To track if a page is reported or not the Uptodate flag was repurposed =
and
> used as a Reported flag for Buddy pages. We walk though the free list
> isolating pages and adding them to the scatterlist until we either
> encounter the end of the list, processed as many pages as were listed i=
n
> nr_free prior to us starting, or have filled the scatterlist with pages=
 to
> be reported. If we fill the scatterlist before we reach the end of the
> list we rotate the list so that the first unreported page we encounter =
is
> moved to the head of the list as that is where we will resume after we
> have freed the reported pages back into the tail of the list.
>
> Below are the results from various benchmarks. I primarily focused on t=
wo
> tests. The first is the will-it-scale/page_fault2 test, and the other i=
s
> a modified version of will-it-scale/page_fault1 that was enabled to use=

> THP. I did this as it allows for better visibility into different parts=

> of the memory subsystem. The guest is running with 32G for RAM on one
> node of a E5-2630 v3. The host has had some features such as CPU turbo
> disabled in the BIOS.
>
> Test                   page_fault1 (THP)    page_fault2
> Name            tasks  Process Iter  STDEV  Process Iter  STDEV
> Baseline            1    1012402.50  0.14%     361855.25  0.81%
>                    16    8827457.25  0.09%    3282347.00  0.34%
>
> Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
>                    16    8784741.75  0.39%    3240669.25  0.48%
>
> Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
>                    16    8756219.00  0.24%    3226608.75  0.97%
>
> Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
>  page shuffle      16    8672601.25  0.49%    3223177.75  0.40%
>
> Patches Enabled     1    1003238.00  0.22%     360211.00  0.22%
>  shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%

Just to be sure that I understand your test setup correctly:
- You have a 32GB guest with a single node affined to a single node of yo=
ur host
(E5-2630).
- You have THP in both host and the guest enabled and set to 'madvise'.
- On top of the default x86_64 config and other virtio config options you=
 have
CONFIG_SLAB_FREELIST_RANDOM and CONFIG_SHUFFLE_PAGE_ALLOCATOR enabled for=
 the
third observation (Patches Enabled page shuffle).
did I miss anything?

Can you also remind me of the reason you have skipped recording the numbe=
r of
threads count reported as part of page_fault tests? Was it because you we=
re
observing different values with every fresh boot?


> The results above are for a baseline with a linux-next-20191219 kernel,=

> that kernel with this patch set applied but page reporting disabled in
> virtio-balloon, the patches applied and page reporting fully enabled, t=
he
> patches enabled with page shuffling enabled, and the patches applied wi=
th
> page shuffling enabled and an RFC patch that makes used of MADV_FREE in=

> QEMU. These results include the deviation seen between the average valu=
e
> reported here versus the high and/or low value. I observed that during =
the
> test memory usage for the first three tests never dropped whereas with =
the
> patches fully enabled the VM would drop to using only a few GB of the
> host's memory when switching from memhog to page fault tests.

Do you mean that in the later case you run the page fault tests after mem=
hog?
If so how much memory do you pass to memhog?

--=20
Nitesh

