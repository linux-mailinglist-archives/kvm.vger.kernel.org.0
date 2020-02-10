Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E9D15747C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgBJM1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:27:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726796AbgBJM1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 07:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581337625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=5m4H1Fh/1nX1+ajlX9lkHOo2ehpwdS0YzXEzk+1Fnwk=;
        b=BwGrk533kf8UDuuxL8xnkPQ4RNe3+Q1pEU4443ppqpvlqMFyH2AZe9gKHdZM+15BhksnQx
        g1ACD+Ay5KM+vVzfyOgOjKnFIjBP7n32u9dQ7LVRi0IyS9pSEJtyLBNAN/PIhgPEpWO/Ie
        Ql/RJDJLD1yHjqtXLLtvbsvJq+Fo/iU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-CZ4PesSEMLCGd9SQjuH53w-1; Mon, 10 Feb 2020 07:26:59 -0500
X-MC-Unique: CZ4PesSEMLCGd9SQjuH53w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EA261857340;
        Mon, 10 Feb 2020 12:26:58 +0000 (UTC)
Received: from [10.36.117.242] (ovpn-117-242.ams2.redhat.com [10.36.117.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B213410013A7;
        Mon, 10 Feb 2020 12:26:55 +0000 (UTC)
Subject: Re: [PATCH 02/35] KVM: s390/interrupt: do not pin adapter interrupt
 pages
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-3-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <2cf62b84-8eb6-18d5-437b-7e86401b9c45@redhat.com>
Date:   Mon, 10 Feb 2020 13:26:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-3-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.20 12:39, Christian Borntraeger wrote:
> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>=20
> The adapter interrupt page containing the indicator bits is currently
> pinned. That means that a guest with many devices can pin a lot of
> memory pages in the host. This also complicates the reference tracking
> which is needed for memory management handling of protected virtual
> machines.
> We can reuse the pte notifiers to "cache" the page without pinning it.
>=20
> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---

So, instead of pinning explicitly, look up the page address, cache it,
and glue its lifetime to the gmap table entry. When that entry is
changed, invalidate the cached page. On re-access, look up the page
again and register the gmap notifier for the table entry again.

[...]

>  #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index c06c89d370a7..4bfb2f8fe57c 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -28,6 +28,7 @@
>  #include <asm/switch_to.h>
>  #include <asm/nmi.h>
>  #include <asm/airq.h>
> +#include <linux/pagemap.h>
>  #include "kvm-s390.h"
>  #include "gaccess.h"
>  #include "trace-s390.h"
> @@ -2328,8 +2329,8 @@ static int register_io_adapter(struct kvm_device =
*dev,
>  		return -ENOMEM;
> =20
>  	INIT_LIST_HEAD(&adapter->maps);
> -	init_rwsem(&adapter->maps_lock);
> -	atomic_set(&adapter->nr_maps, 0);
> +	spin_lock_init(&adapter->maps_lock);
> +	adapter->nr_maps =3D 0;
>  	adapter->id =3D adapter_info.id;
>  	adapter->isc =3D adapter_info.isc;
>  	adapter->maskable =3D adapter_info.maskable;
> @@ -2375,19 +2376,15 @@ static int kvm_s390_adapter_map(struct kvm *kvm=
, unsigned int id, __u64 addr)
>  		ret =3D -EFAULT;
>  		goto out;
>  	}
> -	ret =3D get_user_pages_fast(map->addr, 1, FOLL_WRITE, &map->page);
> -	if (ret < 0)
> -		goto out;
> -	BUG_ON(ret !=3D 1);
> -	down_write(&adapter->maps_lock);
> -	if (atomic_inc_return(&adapter->nr_maps) < MAX_S390_ADAPTER_MAPS) {
> +	spin_lock(&adapter->maps_lock);
> +	if (adapter->nr_maps < MAX_S390_ADAPTER_MAPS) {
> +		adapter->nr_maps++;
>  		list_add_tail(&map->list, &adapter->maps);

I do wonder if we should check for duplicates. The unmap path will only
remove exactly one entry. But maybe this can never happen or is already
handled on a a higher layer.

>  }
> @@ -2430,7 +2426,6 @@ void kvm_s390_destroy_adapters(struct kvm *kvm)
>  		list_for_each_entry_safe(map, tmp,
>  					 &kvm->arch.adapters[i]->maps, list) {
>  			list_del(&map->list);
> -			put_page(map->page);
>  			kfree(map);
>  		}
>  		kfree(kvm->arch.adapters[i]);

Between the gmap being removed in kvm_arch_vcpu_destroy() and
kvm_s390_destroy_adapters(), the entries would no longer properly get
invalidated. AFAIK, removing/freeing the gmap will not trigger any
notifiers.

Not sure if that's an issue (IOW, if we can have some very weird race).
But I guess we would have similar races already :)

> @@ -2690,6 +2685,31 @@ struct kvm_device_ops kvm_flic_ops =3D {
>  	.destroy =3D flic_destroy,
>  };
> =20
> +void kvm_s390_adapter_gmap_notifier(struct gmap *gmap, unsigned long s=
tart,
> +				    unsigned long end)
> +{
> +	struct kvm *kvm =3D gmap->private;
> +	struct s390_map_info *map, *tmp;
> +	int i;
> +
> +	for (i =3D 0; i < MAX_S390_IO_ADAPTERS; i++) {
> +		struct s390_io_adapter *adapter =3D kvm->arch.adapters[i];
> +
> +		if (!adapter)
> +			continue;

I have to ask very dumb: How is kvm->arch.adapters[] protected?

I don't see any explicit locking e.g., on
flic_set_attr()->register_io_adapter().


[...]> +static struct page *get_map_page(struct kvm *kvm,
> +				 struct s390_io_adapter *adapter,
> +				 u64 addr)
>  {
>  	struct s390_map_info *map;
> +	unsigned long uaddr;
> +	struct page *page;
> +	bool need_retry;
> +	int ret;
> =20
>  	if (!adapter)
>  		return NULL;
> +retry:
> +	page =3D NULL;
> +	uaddr =3D 0;
> +	spin_lock(&adapter->maps_lock);
> +	list_for_each_entry(map, &adapter->maps, list)
> +		if (map->guest_addr =3D=3D addr) {

Could it happen, that we don't have a fitting entry in the list?

> +			uaddr =3D map->addr;
> +			page =3D map->page;
> +			if (!page)
> +				map->page =3D ERR_PTR(-EBUSY);
> +			else if (IS_ERR(page) || !page_cache_get_speculative(page)) {
> +				spin_unlock(&adapter->maps_lock);
> +				goto retry;
> +			}
> +			break;
> +		}

Can we please factor out looking up the list entry to a separate
function, to be called under lock? (and e.g., use it below as well)

spin_lock(&adapter->maps_lock);
entry =3D fancy_new_function();
if (!entry)
	return NULL;
uaddr =3D entry->addr;
page =3D entry->page;
if (!page)
	...
spin_unlock(&adapter->maps_lock);


> +	spin_unlock(&adapter->maps_lock);
> +
> +	if (page)
> +		return page;
> +	if (!uaddr)
> +		return NULL;
> =20
> -	list_for_each_entry(map, &adapter->maps, list) {
> -		if (map->guest_addr =3D=3D addr)
> -			return map;
> +	down_read(&kvm->mm->mmap_sem);
> +	ret =3D set_pgste_bits(kvm->mm, uaddr, PGSTE_IN_BIT, PGSTE_IN_BIT);
> +	if (ret)
> +		goto fail;
> +	ret =3D get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
> +				    &page, NULL, NULL);
> +	if (ret < 1)
> +		page =3D NULL;
> +fail:
> +	up_read(&kvm->mm->mmap_sem);
> +	need_retry =3D true;
> +	spin_lock(&adapter->maps_lock);
> +	list_for_each_entry(map, &adapter->maps, list)
> +		if (map->guest_addr =3D=3D addr) {

Could it happen that our entry is suddenly no longer in the list?

> +			if (map->page =3D=3D ERR_PTR(-EBUSY)) {
> +				map->page =3D page;
> +				need_retry =3D false;
> +			} else if (IS_ERR(map->page)) {

else if (map->page =3D=3D ERR_PTR(-EINVAL)

or simpy "else" (every other value would be a BUG_ON, right?)

/* race with a notifier - don't store the entry and retry */

> +				map->page =3D NULL;> +			}



> +			break;
> +		}
> +	spin_unlock(&adapter->maps_lock);
> +	if (need_retry) {
> +		if (page)
> +			put_page(page);
> +		goto retry;
>  	}
> -	return NULL;
> +
> +	return page;

Wow, this function is ... special. Took me way to long to figure out
what is going on here. We certainly need comments in there.

I can see that

- ERR_PTR(-EBUSY) is used when somebody is about to do the
  get_user_pages_remote(). others have to loop until that is resolved.
- ERR_PTR(-EINVAL) is used when the entry gets invalidated by the
  notifier while somebody is about to set it (while still
  ERR_PTR(-EBUSY)). The one currently processing the entry will
  eventually set it back to NULL.

I think we should make this clearer by only setting ERR_PTR(-EINVAL) in
the notifier if already ERR_PTR(-EBUSY), along with a comment.

Can we document the values for map->page and how they are to be handled
right in the struct?

--=20
Thanks,

David / dhildenb

