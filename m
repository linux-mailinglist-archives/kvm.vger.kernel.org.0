Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3220F28D
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 12:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbgF3KW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 06:22:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732451AbgF3KV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 06:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593512514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=QUKiASrudGULEksuLA4TxDL6wwCUQXyEbK7iHKlUsbk=;
        b=I/WqxBhXdscadRK1d9RU8HVen+o8udDB0AHMq4FIsS+DQc7RiS34tohaDZEURLfU2UcKyF
        Z88p95k3JWbnUwSpWotJ1mbGXj0cGAnX+AgEotDF4Uf1hqziXL66HMOMGl7JthS8ROEX8G
        iLAFD/udvfMRXmL3hOtseg0LYcU+otU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-2SObc8QXPciJRMItTBE3wg-1; Tue, 30 Jun 2020 06:21:52 -0400
X-MC-Unique: 2SObc8QXPciJRMItTBE3wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EBA5805EF1;
        Tue, 30 Jun 2020 10:21:51 +0000 (UTC)
Received: from [10.36.114.56] (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52C3D5C1C5;
        Tue, 30 Jun 2020 10:21:46 +0000 (UTC)
Subject: Re: [PATCH v5 10/21] virtio-mem: Paravirtualized memory hot(un)plug
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
 <20200626072248.78761-11-david@redhat.com>
 <20200630060405-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <b18557dc-d434-8951-f6a3-11e3a4195ddc@redhat.com>
Date:   Tue, 30 Jun 2020 12:21:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630060405-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.06.20 12:06, Michael S. Tsirkin wrote:
> On Fri, Jun 26, 2020 at 09:22:37AM +0200, David Hildenbrand wrote:
>> This is the very basic/initial version of virtio-mem. An introduction to
>> virtio-mem can be found in the Linux kernel driver [1]. While it can be
>> used in the current state for hotplug of a smaller amount of memory, it
>> will heavily benefit from resizeable memory regions in the future.
>>
>> Each virtio-mem device manages a memory region (provided via a memory
>> backend). After requested by the hypervisor ("requested-size"), the
>> guest can try to plug/unplug blocks of memory within that region, in order
>> to reach the requested size. Initially, and after a reboot, all memory is
>> unplugged (except in special cases - reboot during postcopy).
>>
>> The guest may only try to plug/unplug blocks of memory within the usable
>> region size. The usable region size is a little bigger than the
>> requested size, to give the device driver some flexibility. The usable
>> region size will only grow, except on reboots or when all memory is
>> requested to get unplugged. The guest can never plug more memory than
>> requested. Unplugged memory will get zapped/discarded, similar to in a
>> balloon device.
>>
>> The block size is variable, however, it is always chosen in a way such that
>> THP splits are avoided (e.g., 2MB). The state of each block
>> (plugged/unplugged) is tracked in a bitmap.
>>
>> As virtio-mem devices (e.g., virtio-mem-pci) will be memory devices, we now
>> expose "VirtioMEMDeviceInfo" via "query-memory-devices".
>>
>> --------------------------------------------------------------------------
>>
>> There are two important follow-up items that are in the works:
>> 1. Resizeable memory regions: Use resizeable allocations/RAM blocks to
>>    grow/shrink along with the usable region size. This avoids creating
>>    initially very big VMAs, RAM blocks, and KVM slots.
>> 2. Protection of unplugged memory: Make sure the gust cannot actually
>>    make use of unplugged memory.
>>
>> Other follow-up items that are in the works:
>> 1. Exclude unplugged memory during migration (via precopy notifier).
>> 2. Handle remapping of memory.
>> 3. Support for other architectures.
> 
> Question: I see that this does not check qemu_balloon_is_inhibited -
> is that because this works with VFIO, somehow?
> Or is this an oversight?

I use the new

if (ram_block_discard_require(true)) {
	error_setg(errp, "Discarding RAM is disabled");
	return;
}

in virtio_mem_device_realize. This will assure that incompatible
technologies (esp. VFIO) are inhibited and are not able to become active
as long as virtio-mem is around.

virtio_mem_is_busy() handles migration/postcopy, indicating "busy" while
migration is temporarily active.

(qemu_balloon_is_inhibited() is no more since "[PATCH v5 06/21]
virtio-balloon: Rip out qemu_balloon_inhibit()")

-- 
Thanks,

David / dhildenb

