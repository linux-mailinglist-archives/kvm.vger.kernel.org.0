Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377481D51EA
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgEOOkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 10:40:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37155 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgEOOkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 10:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589553611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gCcCO079xMryFuDKjpYaCNNg877TKEY087TF8OPD3O4=;
        b=W4zQ/hoBsocfcZwAxAO2BxtiZjmj3jZwpxDBAF2x+IZPYtNgn1DaXyg0ixLuAeFwEWGu0V
        YLgf4j/klLvhuf2YpkJwjj+wkKr67Uu4LHaY6MMxjqeHEiMva0pxHY6q2tJVab1mtpuN9E
        wBFL+rYv61H+XRdHMRNGnF2MQWp7QWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-0-oKqv5hNaKsc2bPRhjVwQ-1; Fri, 15 May 2020 10:40:09 -0400
X-MC-Unique: 0-oKqv5hNaKsc2bPRhjVwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69052107B7CE;
        Fri, 15 May 2020 14:40:08 +0000 (UTC)
Received: from [10.36.114.77] (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB00463B8B;
        Fri, 15 May 2020 14:40:03 +0000 (UTC)
Subject: Re: [PATCH v1 01/17] exec: Introduce
 ram_block_discard_set_(unreliable|required)()
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-2-david@redhat.com> <20200515095413.GB2954@work-vm>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <da581548-5ff8-eb59-15a1-02cd970788ab@redhat.com>
Date:   Fri, 15 May 2020 16:40:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515095413.GB2954@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.05.20 11:54, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
>> We want to replace qemu_balloon_inhibit() by something more generic.
>> Especially, we want to make sure that technologies that really rely on
>> RAM block discards to work reliably to run mutual exclusive with
>> technologies that break it.
>>
>> E.g., vfio will usually pin all guest memory, turning the virtio-balloon
>> basically useless and make the VM consume more memory than reported via
>> the balloon. While the balloon is special already (=> no guarantees, same
>> behavior possible afer reboots and with huge pages), this will be
>> different, especially, with virtio-mem.
>>
>> Let's implement a way such that we can make both types of technology run
>> mutually exclusive. We'll convert existing balloon inhibitors in successive
>> patches and add some new ones. Add the check to
>> qemu_balloon_is_inhibited() for now. We might want to make
>> virtio-balloon an acutal inhibitor in the future - however, that
>> requires more thought to not break existing setups.
>>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Richard Henderson <rth@twiddle.net>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  balloon.c             |  3 ++-
>>  exec.c                | 48 +++++++++++++++++++++++++++++++++++++++++++
>>  include/exec/memory.h | 41 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 91 insertions(+), 1 deletion(-)
>>
>> diff --git a/balloon.c b/balloon.c
>> index f104b42961..c49f57c27b 100644
>> --- a/balloon.c
>> +++ b/balloon.c
>> @@ -40,7 +40,8 @@ static int balloon_inhibit_count;
>>  
>>  bool qemu_balloon_is_inhibited(void)
>>  {
>> -    return atomic_read(&balloon_inhibit_count) > 0;
>> +    return atomic_read(&balloon_inhibit_count) > 0 ||
>> +           ram_block_discard_is_broken();
>>  }
>>  
>>  void qemu_balloon_inhibit(bool state)
>> diff --git a/exec.c b/exec.c
>> index 2874bb5088..52a6e40e99 100644
>> --- a/exec.c
>> +++ b/exec.c
>> @@ -4049,4 +4049,52 @@ void mtree_print_dispatch(AddressSpaceDispatch *d, MemoryRegion *root)
>>      }
>>  }
>>  
>> +static int ram_block_discard_broken;
> 
> This could do with a comment; if I'm reading this right then
>   +ve means broken
>   -ve means required
> 

I'll add to ram_block_discard_broken:

"If positive, discarding RAM is broken. If negative, discarding of RAM
is required to work correctly."

[...]

>>  
>> +/*
>> + * Inhibit technologies that rely on discarding of parts of RAM blocks to work
>> + * reliably, e.g., to manage the actual amount of memory consumed by the VM
>> + * (then, the memory provided by RAM blocks might be bigger than the desired
>> + * memory consumption). This *must* be set if:
> 
> 'technologies that rely on discarding of parts of RAM blocks to work
> reliably' is pretty long; I'm not sure of a better way of saying it
> though.

Maybe simply

"Inhibit technologies that rely on discarding of pages in RAM blocks to
work"?

?

-- 
Thanks,

David / dhildenb

