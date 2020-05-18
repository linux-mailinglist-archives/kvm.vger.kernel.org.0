Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF41D7A72
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 15:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgERNxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 09:53:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33060 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbgERNxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 09:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589809989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=19Ps4GIZsOFiyU6+cY5oakxcO3nMV3zIWZ+ubAYx8Ps=;
        b=igPBUMuh8Qfj6VdbER1wjum4TnEEW0HlulOTMfaMTiT/AsDsx9Tg6cKPgxw0+qvcOj8fqL
        iCsQ2mmmdjWBcCXnwQ6E5ybdoZn0QJi2VApz3+kuyt8zPB2z7pRdYd1d16hctGzU9srBda
        g0KXR2pk+gki07f/yNsnekk4UXwsyxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-VboD-6FSPXWZxxen75tUIg-1; Mon, 18 May 2020 09:53:05 -0400
X-MC-Unique: VboD-6FSPXWZxxen75tUIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03ACD8015CF;
        Mon, 18 May 2020 13:53:04 +0000 (UTC)
Received: from [10.36.115.150] (ovpn-115-150.ams2.redhat.com [10.36.115.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 383725D9DC;
        Mon, 18 May 2020 13:52:56 +0000 (UTC)
Subject: Re: [PATCH v1 07/17] migration/rdma: Use
 ram_block_discard_set_broken()
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-8-david@redhat.com> <20200515124501.GE2954@work-vm>
 <96a58e88-2629-f2ee-5884-38d11e571548@redhat.com>
 <20200515175105.GL2954@work-vm>
 <1cac6cb0-7804-bab2-4ecf-044c369c1135@redhat.com>
 <20200515183652.GM2954@work-vm>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <f47032a1-7a44-cfc8-18ce-f0a9b4a010b6@redhat.com>
Date:   Mon, 18 May 2020 15:52:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515183652.GM2954@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.05.20 20:36, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
>> On 15.05.20 19:51, Dr. David Alan Gilbert wrote:
>>> * David Hildenbrand (david@redhat.com) wrote:
>>>> On 15.05.20 14:45, Dr. David Alan Gilbert wrote:
>>>>> * David Hildenbrand (david@redhat.com) wrote:
>>>>>> RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
>>>>>> to mark RAM block discards to be broken - however, to keep it simple
>>>>>> use ram_block_discard_is_required() instead of inhibiting.
>>>>>
>>>>> Should this be dependent on whether rdma->pin_all is set?
>>>>> Even with !pin_all some will be pinned at any given time
>>>>> (when it's registered with the rdma stack).
>>>>
>>>> Do you know how much memory this is? Is such memory only temporarily pinned?
>>>
>>> With pin_all not set, only a subset of memory, I think multiple 1MB
>>> chunks, are pinned at any one time.
>>>
>>>> At least with special-cases of vfio, it's acceptable if some memory is
>>>> temporarily pinned - we assume it's only the working set of the driver,
>>>> which guests will not inflate as long as they don't want to shoot
>>>> themselves in the foot.
>>>>
>>>> This here sounds like the guest does not know the pinned memory is
>>>> special, right?
>>>
>>> Right - for RDMA it's all of memory that's being transferred, and the
>>> guest doesn't see when each part is transferred.
>>
>>
>> Okay, so all memory will eventually be pinned, just not at the same
>> time, correct?
>>
>> I think this implies that any memory that was previously discarded will
>> be backed my new pages, meaning we will consume more memory than intended.
>>
>> If so, always disabling discarding of RAM seems to be the right thing to do.
> 
> Yeh that's probably true, although there's a check for 'buffer_is_zero'
> in the !rdma->pin_all case, if the entire area is zero (or probably if
> unmapped) then it sends a notification rather than registering; see
> qemu_rdma_write_one and search for 'This chunk has not yet been
> registered, so first check to see'

Right, if the whole chunk is zero, it will send a "compressed" zero
chunk to the target. That will result in a memset() in case the
destination is not already zero. So, both the source and the destination
will be at least be read.

But this only works if a complete chunk (1MB) is zero IIUC. If only one
page within a chunk is not zero (e.g., not inflated), the whole chunk
will be pinned. Also, "disabled chunk registration" seems to be another
case.

https://wiki.qemu.org/Features/RDMALiveMigration

"Finally, zero pages are only checked if a page has not yet been
registered using chunk registration (or not checked at all and
unconditionally written if chunk registration is disabled. This is
accomplished using the "Compress" command listed above. If the page
*has* been registered then we check the entire chunk for zero. Only if
the entire chunk is zero, then we send a compress command to zap the
page on the other side."

-- 
Thanks,

David / dhildenb

