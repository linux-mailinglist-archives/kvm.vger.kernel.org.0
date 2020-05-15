Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CBF1D4D7F
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 14:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgEOMMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 08:12:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28599 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgEOMMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 08:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589544728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=yX7f6BENrcm0S3e8GHmm7wE1vmyaHKzdDekAm9QRSpo=;
        b=E4GYn0+IFBU8rBKvyAumWiPDHROdrzGjPJIcQUOb+Ra2jgoUQR9NiJkMuAyOEf29BSL+gd
        MB0gos8x9/dOEvN1h2vq0g8yVMC3SQVt0do0DacrgDSjInw0zy/+Idi4jjWxNOxuniTJSM
        kmlEKJ62y4fU5D0k0EwZtmJ5X/tk0wQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-_0S5BqcGOQKxMPJO-x6vsg-1; Fri, 15 May 2020 08:12:06 -0400
X-MC-Unique: _0S5BqcGOQKxMPJO-x6vsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F3FE1B18BC0;
        Fri, 15 May 2020 12:12:05 +0000 (UTC)
Received: from [10.36.114.77] (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3119D60C87;
        Fri, 15 May 2020 12:12:01 +0000 (UTC)
Subject: Re: [PATCH v1 05/17] virtio-balloon: Rip out qemu_balloon_inhibit()
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-6-david@redhat.com> <20200515120927.GD2954@work-vm>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <8ca15530-5f35-8204-caf2-bb15496f39e9@redhat.com>
Date:   Fri, 15 May 2020 14:12:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515120927.GD2954@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.05.20 14:09, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
>> The only remaining special case is postcopy. It cannot handle
>> concurrent discards yet, which would result in requesting already sent
>> pages from the source. Special-case it in virtio-balloon instead.
>>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Juan Quintela <quintela@redhat.com>
>> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  balloon.c                  | 18 ------------------
>>  hw/virtio/virtio-balloon.c | 12 +++++++++++-
>>  include/sysemu/balloon.h   |  2 --
>>  migration/postcopy-ram.c   | 23 -----------------------
>>  4 files changed, 11 insertions(+), 44 deletions(-)
>>
>> diff --git a/balloon.c b/balloon.c
>> index c49f57c27b..354408c6ea 100644
>> --- a/balloon.c
>> +++ b/balloon.c
>> @@ -36,24 +36,6 @@
>>  static QEMUBalloonEvent *balloon_event_fn;
>>  static QEMUBalloonStatus *balloon_stat_fn;
>>  static void *balloon_opaque;
>> -static int balloon_inhibit_count;
>> -
>> -bool qemu_balloon_is_inhibited(void)
>> -{
>> -    return atomic_read(&balloon_inhibit_count) > 0 ||
>> -           ram_block_discard_is_broken();
>> -}
>> -
>> -void qemu_balloon_inhibit(bool state)
>> -{
>> -    if (state) {
>> -        atomic_inc(&balloon_inhibit_count);
>> -    } else {
>> -        atomic_dec(&balloon_inhibit_count);
>> -    }
>> -
>> -    assert(atomic_read(&balloon_inhibit_count) >= 0);
>> -}
>>  
>>  static bool have_balloon(Error **errp)
>>  {
>> diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
>> index a4729f7fc9..aa5b89fb47 100644
>> --- a/hw/virtio/virtio-balloon.c
>> +++ b/hw/virtio/virtio-balloon.c
>> @@ -29,6 +29,7 @@
>>  #include "trace.h"
>>  #include "qemu/error-report.h"
>>  #include "migration/misc.h"
>> +#include "migration/postcopy-ram.h"
>>  
>>  #include "hw/virtio/virtio-bus.h"
>>  #include "hw/virtio/virtio-access.h"
>> @@ -63,6 +64,15 @@ static bool virtio_balloon_pbp_matches(PartiallyBalloonedPage *pbp,
>>      return pbp->base_gpa == base_gpa;
>>  }
>>  
>> +static bool virtio_balloon_inhibited(void)
>> +{
>> +    PostcopyState ps = postcopy_state_get();
>> +
>> +    /* Postcopy cannot deal with concurrent discards (yet), so it's special. */
>> +    return ram_block_discard_is_broken() ||
>> +           (ps >= POSTCOPY_INCOMING_DISCARD && ps < POSTCOPY_INCOMING_END);
> 
> It's a shame this is open-coded here; it would be better to have
> something in migration.c ; we have a migration_in_postcopy but that's
> really the sending side; a 'migration_in_incoming_postcopy' would
> perhaps be good.

Yes, makes sense - then I can also reuse it in patch #10.

Thanks!

-- 
Thanks,

David / dhildenb

