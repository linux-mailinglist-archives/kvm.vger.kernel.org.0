Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C682C1FEFC1
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgFRKkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 06:40:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37093 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727084AbgFRKkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 06:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592476805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=XdGPv7w1Ry0Li9JG4IXQzC4bkKkG+CqvCKD/XU78Fig=;
        b=Axmd1WM+cLuAnZ9gzb9weruLLeUIPnvW46CEWehpJCmXRM4Hs1dLJswvOZh0WAz9gn7Aea
        TL/ZhZHV2GFQ3YyBUMiPSJ1CUuiznQ7cUrZ4XwqwM0sMBMUnnptrAVtGO4adVLzOPar4bJ
        cyxo5bfWQgF2YLOIoxpGbf36sQbA1yo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-tMvt_3-YM2msTGuxZ-ZORg-1; Thu, 18 Jun 2020 06:40:03 -0400
X-MC-Unique: tMvt_3-YM2msTGuxZ-ZORg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92284107ACCA;
        Thu, 18 Jun 2020 10:40:02 +0000 (UTC)
Received: from [10.36.114.105] (ovpn-114-105.ams2.redhat.com [10.36.114.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFACB6E9F3;
        Thu, 18 Jun 2020 10:39:57 +0000 (UTC)
Subject: Re: [PATCH v4 18/21] virtio-mem: Migration sanity checks
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-19-david@redhat.com> <20200617175936.GL2776@work-vm>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <c4c2953b-9e94-02d8-46ac-519ca61b5434@redhat.com>
Date:   Thu, 18 Jun 2020 12:39:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617175936.GL2776@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.06.20 19:59, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
>> We want to make sure that certain properties don't change during
>> migration, especially to catch user errors in a nice way. Let's migrate
>> a temporary structure and validate that the properties didn't change.
>>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Yep OK, but some comment below
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
>> ---
>>  hw/virtio/virtio-mem.c | 69 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 69 insertions(+)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 2df33f9125..450b8dc49d 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -519,12 +519,81 @@ static int virtio_mem_post_load(void *opaque, int version_id)
>>      return virtio_mem_restore_unplugged(VIRTIO_MEM(opaque));
>>  }
>>  
>> +typedef struct VirtIOMEMMigSanityChecks {
>> +    VirtIOMEM *parent;
>> +    uint64_t addr;
>> +    uint64_t region_size;
>> +    uint64_t block_size;
>> +    uint32_t node;
>> +} VirtIOMEMMigSanityChecks;
>> +
>> +static int virtio_mem_mig_sanity_checks_pre_save(void *opaque)
>> +{
>> +    VirtIOMEMMigSanityChecks *tmp = opaque;
>> +    VirtIOMEM *vmem = tmp->parent;
>> +
>> +    tmp->addr = vmem->addr;
>> +    tmp->region_size = memory_region_size(&vmem->memdev->mr);
>> +    tmp->block_size = vmem->block_size;
>> +    tmp->node = vmem->node;
>> +    return 0;
>> +}
>> +
>> +static int virtio_mem_mig_sanity_checks_post_load(void *opaque, int version_id)
>> +{
>> +    VirtIOMEMMigSanityChecks *tmp = opaque;
>> +    VirtIOMEM *vmem = tmp->parent;
>> +    const uint64_t new_region_size = memory_region_size(&vmem->memdev->mr);
>> +
>> +    if (tmp->addr != vmem->addr) {
>> +        error_report("Property '%s' changed from 0x%" PRIx64 " to 0x%" PRIx64,
>> +                     VIRTIO_MEM_ADDR_PROP, tmp->addr, vmem->addr);
>> +        return -EINVAL;
>> +    }
> 
> It seems weird that you do 'Property ...' and then the string; although
> you only do it for 3 out of 4.

Yeah, because it is a derived property of the memdev. I can just make
that clearer by referencing the memdev property.

> I was going to ask you to include the device name here, but I'm guessing
> when it fails the outer migration code will print a 'Failed loading
> device.....'  so at least you know what it is.
> I would want it to be obvious when I see a 'region size changed' that I
> knew it was my virtio-mem device that was screwy.

IIRC that should be the case, yes.

Thanks!


-- 
Thanks,

David / dhildenb

