Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33E398254
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 08:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFBHB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhFBHB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 03:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622617185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UKf0lOdGUnKEBEe6OBgcdT+Hi5/oJPRiHF9Bpb46ZMY=;
        b=gZ22RMWy5guNqgD+DYNryX64HFxeAjWztJ6TMu4Rf/Lq7zgbDaJBNhjRSQR80QOsc8d353
        +fe1YywH/aA8n1OOeTg1MEIvvsv6nFShLXmyZnsnc1wVPSGcEcibzRRNAVn4hnr2D6H+KB
        Djtz5KIvELMr/M3/HvkywaPC0H/eB1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-1dTLJXI_OKSNL7XS_7iIzw-1; Wed, 02 Jun 2021 02:59:42 -0400
X-MC-Unique: 1dTLJXI_OKSNL7XS_7iIzw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 667F98042A9;
        Wed,  2 Jun 2021 06:59:41 +0000 (UTC)
Received: from localhost (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1122A6A03D;
        Wed,  2 Jun 2021 06:59:37 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: unify header guards
In-Reply-To: <d87b32d6-1d41-1413-96c6-0d6b2361b079@redhat.com>
Organization: Red Hat GmbH
References: <20210601161525.462315-1-cohuck@redhat.com>
 <d87b32d6-1d41-1413-96c6-0d6b2361b079@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 02 Jun 2021 08:59:36 +0200
Message-ID: <87h7igrbtz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Huth <thuth@redhat.com> writes:

> On 01/06/2021 18.15, Cornelia Huck wrote:
>> Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
>> _S390X_FILE_H_. This makes it more obvious what the file is
>> about, and avoids possible name space collisions.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>> 
>> Only did s390x for now; the other archs seem to be inconsistent in
>> places as well, and I can also try to tackle them if it makes sense.
> ...
>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>> index 792881ec3249..61cd38fd36b7 100644
>> --- a/lib/s390x/asm/bitops.h
>> +++ b/lib/s390x/asm/bitops.h
>> @@ -8,8 +8,8 @@
>>    *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
>>    *
>>    */
>> -#ifndef _ASMS390X_BITOPS_H_
>> -#define _ASMS390X_BITOPS_H_
>> +#ifndef _ASM_S390X_BITOPS_H_
>> +#define _ASM_S390X_BITOPS_H_
>
> Why not the other way round (S390X_ASM_BITOPS_H) ?

Most existing guards were this way around, I don't really have a
preference here, we should just agree on one format :)

>
>  > diff --git a/s390x/sthyi.h b/s390x/sthyi.h
>  > index bbd74c6197c3..eb92fdd2f2b2 100644
>  > --- a/s390x/sthyi.h
>  > +++ b/s390x/sthyi.h
>  > @@ -7,8 +7,8 @@
>  >   * Authors:
>  >   *    Janosch Frank <frankja@linux.vnet.ibm.com>
>  >   */
>  > -#ifndef _STHYI_H_
>  > -#define _STHYI_H_
>  > +#ifndef _S390X_STHYI_H_
>  > +#define _S390X_STHYI_H_
>
> While we're at it: Do we also want to drop the leading (and trailing) 
> underscores here? ... since leading underscore followed by a capital letter 
> is a reserved namespace in C and you should normally not use these in nice 
> programs...? I think I'm ok with keeping the underscores in the files in the 
> lib folder (since these are our core libraries, similar to the system and 
> libc headers on a normal system), but in files that are not part of the lib 
> folder, we should rather avoid them.

Hm, I actually ended up _adding_ some underscores in various places... I
can certainly drop them for !lib.

What about the following structure:

- in lib/<arch>/asm/: _ARCH_ASM_FILE_H_
- in lib/<arch>/: _ARCH_FILE_H_
- in lib/linux/: _LINUX_FILE_H_
- in lib/: _FILE_H_
(lib/libfdt is imported code, leave untouched)
- in <arch>/: ARCH_FILE_H

