Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B340160F08
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 10:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBQJoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 04:44:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728849AbgBQJoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 04:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581932646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=km9B3ZeBn5XlL98sCPXMZzVK9PaqcIVBvQ7J/zpq0uU=;
        b=Gn9vZjlvBeWtIfNwoi54X7XXQkVllkzqvtB6z5nKpD+ZzbRaoGkY0jpKpek3pjWZY6t9TX
        J07UoO+C8hMVIVhvIYHN9UA5S1lsVzT3/InZ10bCuPrMvHMkk2oNrfmhGvp1nBN3IiXuEk
        5m/iF8stY3yTXRDD8a8KJsU8NUeCzCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-QQqE1gKUP7SUPBCcg4yN1g-1; Mon, 17 Feb 2020 04:43:59 -0500
X-MC-Unique: QQqE1gKUP7SUPBCcg4yN1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63BD4107ACCD;
        Mon, 17 Feb 2020 09:43:57 +0000 (UTC)
Received: from [10.36.117.64] (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B154B5DA2C;
        Mon, 17 Feb 2020 09:43:50 +0000 (UTC)
Subject: Re: [PATCH v2 02/42] KVM: s390/interrupt: do not pin adapter
 interrupt pages
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-3-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <073d3666-480e-5ba5-a46b-4cbd615f4174@redhat.com>
Date:   Mon, 17 Feb 2020 10:43:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214222658.12946-3-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.20 23:26, Christian Borntraeger wrote:
> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>=20
> The adapter interrupt page containing the indicator bits is currently
> pinned. That means that a guest with many devices can pin a lot of
> memory pages in the host. This also complicates the reference tracking
> which is needed for memory management handling of protected virtual
> machines. It might also have some strange side effects for madvise
> MADV_DONTNEED and other things.
>=20
> We can simply try to get the userspace page set the bits and free the
> page. By storing the userspace address in the irq routing entry instead
> of the guest address we can actually avoid many lookups and list walks
> so that this variant is very likely not slower.
>=20
> If userspace messes around with the memory slots the worst thing that
> can happen is that we write to some other memory within that process.
> As we get the the page with FOLL_WRITE this can also not be used to
> write to shared read-only pages.
>=20
> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> [borntraeger@de.ibm.com: patch simplification]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  Documentation/virt/kvm/devices/s390_flic.rst |  11 +-
>  arch/s390/include/asm/kvm_host.h             |   3 -
>  arch/s390/kvm/interrupt.c                    | 170 ++++++-------------
>  3 files changed, 53 insertions(+), 131 deletions(-)
>=20
> diff --git a/Documentation/virt/kvm/devices/s390_flic.rst b/Documentati=
on/virt/kvm/devices/s390_flic.rst
> index 954190da7d04..ea96559ba501 100644
> --- a/Documentation/virt/kvm/devices/s390_flic.rst
> +++ b/Documentation/virt/kvm/devices/s390_flic.rst
> @@ -108,16 +108,9 @@ Groups:
>        mask or unmask the adapter, as specified in mask
> =20
>      KVM_S390_IO_ADAPTER_MAP
> -      perform a gmap translation for the guest address provided in add=
r,
> -      pin a userspace page for the translated address and add it to th=
e
> -      list of mappings
> -
> -      .. note:: A new mapping will be created unconditionally; therefo=
re,
> -	        the calling code should avoid making duplicate mappings.
> -
> +      This is now a no-op. The mapping is purely done by the irq route=
.
>      KVM_S390_IO_ADAPTER_UNMAP
> -      release a userspace page for the translated address specified in=
 addr
> -      from the list of mappings
> +      This is now a no-op. The mapping is purely done by the irq route=
.
> =20

The interface should have accepted a hva from the very start and not
guest addresses ...

[...]

> =20
>  static int modify_io_adapter(struct kvm_device *dev,
> @@ -2456,12 +2378,13 @@ static int modify_io_adapter(struct kvm_device =
*dev,
>  		if (ret > 0)
>  			ret =3D 0;
>  		break;
> +	/*
> +	 * We resolve the gpa to hva when setting the IRQ routing. the set_ir=
q
> +	 * code uses get_user_pages_remote to do the actual write.

nit: "get_user_pages_remote()"

> +	 */
>  	case KVM_S390_IO_ADAPTER_MAP:
> -		ret =3D kvm_s390_adapter_map(dev->kvm, req.id, req.addr);
> -		break;
>  	case KVM_S390_IO_ADAPTER_UNMAP:
> -		ret =3D kvm_s390_adapter_unmap(dev->kvm, req.id, req.addr);
> -		break;
> +		return 0;
>  	default:
>  		ret =3D -EINVAL;
>  	}
> @@ -2699,19 +2622,21 @@ static unsigned long get_ind_bit(__u64 addr, un=
signed long bit_nr, bool swap)
>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>  }
> =20
> -static struct s390_map_info *get_map_info(struct s390_io_adapter *adap=
ter,
> -					  u64 addr)
> +static struct page *get_map_page(struct kvm *kvm,
> +				 struct s390_io_adapter *adapter,
> +				 u64 uaddr)
>  {
> -	struct s390_map_info *map;
> +	struct page *page =3D NULL;
> =20
>  	if (!adapter)
>  		return NULL;

AFAIKs, this check is not necessary.

> -
> -	list_for_each_entry(map, &adapter->maps, list) {
> -		if (map->guest_addr =3D=3D addr)
> -			return map;
> -	}
> -	return NULL;
> +	if (!uaddr)
> +		return NULL;

I do wonder if that check is necessary. I don't think so but might be
missing something.

> +	down_read(&kvm->mm->mmap_sem);
> +	get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
> +			      &page, NULL, NULL);
> +	up_read(&kvm->mm->mmap_sem);
> +	return page;
>  }
> =20
>  static int adapter_indicators_set(struct kvm *kvm,
> @@ -2720,30 +2645,35 @@ static int adapter_indicators_set(struct kvm *k=
vm,
>  {
>  	unsigned long bit;
>  	int summary_set, idx;
> -	struct s390_map_info *info;
> +	struct page *ind_page, *summary_page;
>  	void *map;
> =20
> -	info =3D get_map_info(adapter, adapter_int->ind_addr);
> -	if (!info)
> +	ind_page =3D get_map_page(kvm, adapter, adapter_int->ind_addr);
> +	if (!ind_page)
>  		return -1;
> -	map =3D page_address(info->page);
> -	bit =3D get_ind_bit(info->addr, adapter_int->ind_offset, adapter->swa=
p);
> -	set_bit(bit, map);
> -	idx =3D srcu_read_lock(&kvm->srcu);
> -	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
> -	set_page_dirty_lock(info->page);
> -	info =3D get_map_info(adapter, adapter_int->summary_addr);
> -	if (!info) {
> -		srcu_read_unlock(&kvm->srcu, idx);
> +	summary_page =3D get_map_page(kvm, adapter, adapter_int->summary_addr=
);
> +	if (!summary_page) {
> +		put_page(ind_page);
>  		return -1;
>  	}
> -	map =3D page_address(info->page);
> -	bit =3D get_ind_bit(info->addr, adapter_int->summary_offset,
> -			  adapter->swap);
> +
> +	idx =3D srcu_read_lock(&kvm->srcu);
> +	map =3D page_address(ind_page);
> +	bit =3D get_ind_bit(adapter_int->ind_addr,
> +			  adapter_int->ind_offset, adapter->swap);
> +	set_bit(bit, map);
> +	mark_page_dirty(kvm, adapter_int->ind_addr >> PAGE_SHIFT);
> +	set_page_dirty_lock(ind_page);
> +	map =3D page_address(summary_page);
> +	bit =3D get_ind_bit(adapter_int->summary_addr,
> +			  adapter_int->summary_offset, adapter->swap);
>  	summary_set =3D test_and_set_bit(bit, map);
> -	mark_page_dirty(kvm, info->guest_addr >> PAGE_SHIFT);
> -	set_page_dirty_lock(info->page);
> +	mark_page_dirty(kvm, adapter_int->summary_addr >> PAGE_SHIFT);
> +	set_page_dirty_lock(summary_page);
>  	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	put_page(ind_page);
> +	put_page(summary_page);
>  	return summary_set ? 0 : 1;
>  }
> =20
> @@ -2765,9 +2695,7 @@ static int set_adapter_int(struct kvm_kernel_irq_=
routing_entry *e,
>  	adapter =3D get_io_adapter(kvm, e->adapter.adapter_id);
>  	if (!adapter)
>  		return -1;
> -	down_read(&adapter->maps_lock);
>  	ret =3D adapter_indicators_set(kvm, adapter, &e->adapter);
> -	up_read(&adapter->maps_lock);
>  	if ((ret > 0) && !adapter->masked) {
>  		ret =3D kvm_s390_inject_airq(kvm, adapter);
>  		if (ret =3D=3D 0)
> @@ -2818,23 +2746,27 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
> -	int ret;
> +	u64 uaddr;
> =20
>  	switch (ue->type) {
> +	/* we store the userspace addresses instead of the guest addresses */
>  	case KVM_IRQ_ROUTING_S390_ADAPTER:
>  		e->set =3D set_adapter_int;
> -		e->adapter.summary_addr =3D ue->u.adapter.summary_addr;
> -		e->adapter.ind_addr =3D ue->u.adapter.ind_addr;
> +		uaddr =3D  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr=
);
> +		if (uaddr =3D=3D -EFAULT)
> +			return -EFAULT;
> +		e->adapter.summary_addr =3D uaddr;
> +		uaddr =3D  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
> +		if (uaddr =3D=3D -EFAULT)
> +			return -EFAULT;

AFAIK, leaving e->adapter.summary_addr set is not an issue.

Interesting, in kvm_s390_adapter_map(), we didn't synchronize again slot
updates when doing the gmap_translate(), which looks wrong to me ...

It seems to be the same thing here. I do wonder if it is safe to do a
gmap_translate() here, looks like this can race with
kvm_arch_commit_memory_region().

I would have assumed we need e.g., the slots_lock while doing the
gmap_translate() - or a srcu_read_lock(&vcpu->kvm->srcu) or similar ...


Apart from that, looks good to me.

--=20
Thanks,

David / dhildenb

