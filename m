Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE7F15D579
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgBNKZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:25:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729070AbgBNKZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581675930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=8DQpIWCnhORAHHXp5DnG+AO5PeBNuA6AihDSXqyGOxE=;
        b=IclvDJqvRoA8e1fwKs1grt7nneF65mHoO8O8iRZbEO4nch7kJ7GDDCdQ+StXSVIM7c+TGU
        G98+AUSIda7cvV9KOK7GUOEBFnH9tsvD1lV+8ETOTTr7y1rwOn4icvMlM9OAji5pZklVDG
        4DEtrdJP7Wc5aiW9JIV+4hwkU/sumNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-szMzKMpcNoKHSwYppZRe7A-1; Fri, 14 Feb 2020 05:25:28 -0500
X-MC-Unique: szMzKMpcNoKHSwYppZRe7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860758018A2;
        Fri, 14 Feb 2020 10:25:26 +0000 (UTC)
Received: from [10.36.118.137] (unknown [10.36.118.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 265AB790CF;
        Fri, 14 Feb 2020 10:25:23 +0000 (UTC)
Subject: Re: [PATCH 04/35] s390/protvirt: add ultravisor initialization
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-5-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <44aa351c-2333-e1df-42ce-6cf3a6808802@redhat.com>
Date:   Fri, 14 Feb 2020 11:25:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-5-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

>  #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                 =
         \
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index f2ab2528859f..5f178d557cc8 100644
> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -560,6 +560,8 @@ static void __init setup_memory_end(void)
>  			vmax =3D _REGION1_SIZE; /* 4-level kernel page table */
>  	}
> =20
> +	adjust_to_uv_max(&vmax);

I'd somewhat prefer

if (prot_virt_host)
	adjust_to_uv_max(&vmax);

> +
>  	/* module area is at the end of the kernel address space. */
>  	MODULES_END =3D vmax;
>  	MODULES_VADDR =3D MODULES_END - MODULES_LEN;
> @@ -1140,6 +1142,7 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
> =20
> +	setup_uv();

and

if (prot_virt_host)
	setup_uv();

Moving the checks out of the functions. Makes it clearer that this is
optional.

>  	setup_memory_end();
>  	setup_memory();
>  	dma_contiguous_reserve(memory_end);
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index fbf2a98de642..a06a628a88da 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -46,4 +46,57 @@ static int __init prot_virt_setup(char *val)
>  	return rc;
>  }
>  early_param("prot_virt", prot_virt_setup);
> +
> +static int __init uv_init(unsigned long stor_base, unsigned long stor_=
len)
> +{
> +	struct uv_cb_init uvcb =3D {
> +		.header.cmd =3D UVC_CMD_INIT_UV,
> +		.header.len =3D sizeof(uvcb),
> +		.stor_origin =3D stor_base,
> +		.stor_len =3D stor_len,
> +	};
> +	int cc;
> +
> +	cc =3D uv_call(0, (uint64_t)&uvcb);

Could do

int cc =3D uv_call(0, (uint64_t)&uvcb);

> +	if (cc || uvcb.header.rc !=3D UVC_RC_EXECUTED) {
> +		pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
> +		       uvcb.header.rc);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +void __init setup_uv(void)
> +{
> +	unsigned long uv_stor_base;
> +
> +	if (!prot_virt_host)
> +		return;
> +
> +	uv_stor_base =3D (unsigned long)memblock_alloc_try_nid(
> +		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
> +		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
> +	if (!uv_stor_base) {
> +		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n",
> +			uv_info.uv_base_stor_len);

pr_err() ? pr_warn()?

> +		goto fail;
> +	}
> +
> +	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
> +		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
> +		goto fail;
> +	}
> +
> +	pr_info("Reserving %luMB as ultravisor base storage\n",
> +		uv_info.uv_base_stor_len >> 20);
> +	return;
> +fail:

I'd add here:

pr_info("Disabling support for protected virtualization");

> +	prot_virt_host =3D 0;> +}
> +
> +void adjust_to_uv_max(unsigned long *vmax)
> +{
> +	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> +		*vmax =3D uv_info.max_sec_stor_addr;

Once you move the prot virt check out of this function

	*vmax =3D max_t(unsigned long, *vmax, uv_info.max_sec_stor_addr);

> +}
>  #endif
>=20


--=20
Thanks,

David / dhildenb

