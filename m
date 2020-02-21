Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966F0167B15
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 11:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgBUKq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 05:46:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgBUKq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 05:46:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582282015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=MWdFIGaN4vVGA2rn+y0DNLhAnokcl2mknwliiEst6Ok=;
        b=WPzFZW00SUuhtOyKaNq3oymshrl5g1h0k+DjQ6IIA9XMqLwnGhhJpidmOZvV5JHOf7SIB1
        YgCiIfLDuxC0vYig0JrpvJ/EsZxOi0Wh7TownZf5ITSl24Pyn0iv26pOl2/5be3TcOxQ0B
        /fa0nWTu/7FZwOJRS9ayrUq/+W0uLok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-ISGoaoSOP5y9s_6Z6SahBw-1; Fri, 21 Feb 2020 05:46:51 -0500
X-MC-Unique: ISGoaoSOP5y9s_6Z6SahBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 652341005512;
        Fri, 21 Feb 2020 10:46:50 +0000 (UTC)
Received: from [10.36.117.197] (ovpn-117-197.ams2.redhat.com [10.36.117.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1263860C87;
        Fri, 21 Feb 2020 10:46:47 +0000 (UTC)
Subject: Re: [PATCH v3 35/37] s390: protvirt: Add sysfs firmware interface for
 Ultravisor information
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
 <20200220104020.5343-36-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <4409e9ba-3b8c-69dd-815c-2b09d77d7598@redhat.com>
Date:   Fri, 21 Feb 2020 11:46:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220104020.5343-36-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.02.20 11:40, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> That information, e.g. the maximum number of guests or installed
> Ultravisor facilities, is interesting for QEMU, Libvirt and
> administrators.
> 
> Let's provide an easily parsable API to get that information.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 86 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 4539003dac9d..550e9617c459 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -323,5 +323,91 @@ int arch_make_page_accessible(struct page *page)
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(arch_make_page_accessible);
> +#endif
> +
> +#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
> +static ssize_t uv_query_facilities(struct kobject *kobj,
> +				   struct kobj_attribute *attr, char *page)
> +{
> +	return snprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
> +			uv_info.inst_calls_list[0],
> +			uv_info.inst_calls_list[1],
> +			uv_info.inst_calls_list[2],
> +			uv_info.inst_calls_list[3]);
> +}
> +
> +static struct kobj_attribute uv_query_facilities_attr =
> +	__ATTR(facilities, 0444, uv_query_facilities, NULL);
> +
> +static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
> +				       struct kobj_attribute *attr, char *page)
> +{
> +	return snprintf(page, PAGE_SIZE, "%d\n",
> +			uv_info.max_guest_cpus);
> +}
> +
> +static struct kobj_attribute uv_query_max_guest_cpus_attr =
> +	__ATTR(max_cpus, 0444, uv_query_max_guest_cpus, NULL);
> +
> +static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
> +				      struct kobj_attribute *attr, char *page)
> +{
> +	return snprintf(page, PAGE_SIZE, "%d\n",
> +			uv_info.max_num_sec_conf);
> +}
> +
> +static struct kobj_attribute uv_query_max_guest_vms_attr =
> +	__ATTR(max_guests, 0444, uv_query_max_guest_vms, NULL);
> +
> +static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
> +				       struct kobj_attribute *attr, char *page)
> +{
> +	return snprintf(page, PAGE_SIZE, "%lx\n",
> +			uv_info.max_sec_stor_addr);
> +}
> +
> +static struct kobj_attribute uv_query_max_guest_addr_attr =
> +	__ATTR(max_address, 0444, uv_query_max_guest_addr, NULL);
> +
> +static struct attribute *uv_query_attrs[] = {
> +	&uv_query_facilities_attr.attr,
> +	&uv_query_max_guest_cpus_attr.attr,
> +	&uv_query_max_guest_vms_attr.attr,
> +	&uv_query_max_guest_addr_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group uv_query_attr_group = {
> +	.attrs = uv_query_attrs,
> +};
>  
> +static struct kset *uv_query_kset;
> +struct kobject *uv_kobj;
> +
> +static int __init uv_info_init(void)
> +{
> +	int rc = -ENOMEM;
> +
> +	if (!test_facility(158))
> +		return 0;
> +
> +	uv_kobj = kobject_create_and_add("uv", firmware_kobj);
> +	if (!uv_kobj)
> +		return -ENOMEM;
> +
> +	uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
> +	if (!uv_query_kset)
> +		goto out_kobj;
> +
> +	rc = sysfs_create_group(&uv_query_kset->kobj, &uv_query_attr_group);
> +	if (!rc)
> +		return 0;
> +
> +	kset_unregister(uv_query_kset);
> +out_kobj:
> +	kobject_del(uv_kobj);
> +	kobject_put(uv_kobj);
> +	return rc;
> +}
> +device_initcall(uv_info_init);
>  #endif
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

