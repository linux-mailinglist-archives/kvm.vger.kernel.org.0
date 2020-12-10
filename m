Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99692D617A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbgLJQRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:17:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387589AbgLJQQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 11:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607616925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oUGlr7cXnqe8U3k73iOLov+r/9mAm+xr+LFq54efSGk=;
        b=AfgHfj09zrHXxNVESkC2wcKzQvO0mbofi4QAhoe/wt1bawqrMSzLs4Bn4oqPfZcluX+lJt
        +hgtyXUk3KnPb4U/rYxCAQYb1lC25OS+gIxGz9PGHPKQwdJOIDkDY8VLqKx2EXYxE5nyaL
        uoCbcmTS2ydsPmyJv42vOV5gDZixjwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-48HK3YcPME6g1JmyK9wKrw-1; Thu, 10 Dec 2020 11:15:23 -0500
X-MC-Unique: 48HK3YcPME6g1JmyK9wKrw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 646A7107ACE8;
        Thu, 10 Dec 2020 16:15:22 +0000 (UTC)
Received: from [10.36.115.117] (ovpn-115-117.ams2.redhat.com [10.36.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D85D5D9CC;
        Thu, 10 Dec 2020 16:15:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-3-frankja@linux.ibm.com>
 <c236052c-598b-0d88-c80b-4bb2a999ec46@redhat.com>
 <c08d511f-f9c0-5087-4e08-0c4ccbc4ebbf@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <bbc41642-028e-aae7-225d-a52eda54add1@redhat.com>
Date:   Thu, 10 Dec 2020 17:15:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <c08d511f-f9c0-5087-4e08-0c4ccbc4ebbf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.12.20 10:46, Janosch Frank wrote:
> On 12/9/20 10:15 AM, David Hildenbrand wrote:
>> On 08.12.20 16:09, Janosch Frank wrote:
>>> In the past we had some issues when developers wanted to use code
>>> snippets or constants from the kernel in a test or in the library. To
>>> remedy that the s390x maintainers decided to move all files to GPL 2
>>> (if possible).
>>>
>>> At the same time let's move to SPDX identifiers as they are much nicer
>>> to read.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  lib/s390x/asm-offsets.c     | 4 +---
>>>  lib/s390x/asm/arch_def.h    | 4 +---
>>>  lib/s390x/asm/asm-offsets.h | 4 +---
>>>  lib/s390x/asm/barrier.h     | 4 +---
>>>  lib/s390x/asm/cpacf.h       | 1 +
>>>  lib/s390x/asm/facility.h    | 4 +---
>>>  lib/s390x/asm/float.h       | 4 +---
>>>  lib/s390x/asm/interrupt.h   | 4 +---
>>>  lib/s390x/asm/io.h          | 4 +---
>>>  lib/s390x/asm/mem.h         | 4 +---
>>>  lib/s390x/asm/page.h        | 4 +---
>>>  lib/s390x/asm/pgtable.h     | 4 +---
>>>  lib/s390x/asm/sigp.h        | 4 +---
>>>  lib/s390x/asm/spinlock.h    | 4 +---
>>>  lib/s390x/asm/stack.h       | 4 +---
>>>  lib/s390x/asm/time.h        | 4 +---
>>>  lib/s390x/css.h             | 4 +---
>>>  lib/s390x/css_dump.c        | 4 +---
>>>  lib/s390x/css_lib.c         | 4 +---
>>>  lib/s390x/interrupt.c       | 4 +---
>>>  lib/s390x/io.c              | 4 +---
>>>  lib/s390x/mmu.c             | 4 +---
>>>  lib/s390x/mmu.h             | 4 +---
>>>  lib/s390x/sclp-console.c    | 5 +----
>>>  lib/s390x/sclp.c            | 4 +---
>>>  lib/s390x/sclp.h            | 5 +----
>>>  lib/s390x/smp.c             | 4 +---
>>>  lib/s390x/smp.h             | 4 +---
>>>  lib/s390x/stack.c           | 4 +---
>>>  lib/s390x/vm.c              | 3 +--
>>>  lib/s390x/vm.h              | 3 +--
>>>  31 files changed, 31 insertions(+), 90 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>>> index 61d2658..ee94ed3 100644
>>> --- a/lib/s390x/asm-offsets.c
>>> +++ b/lib/s390x/asm-offsets.c
>>> @@ -1,11 +1,9 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>  /*
>>>   * Copyright (c) 2017 Red Hat Inc
>>>   *
>>>   * Authors:
>>>   *  David Hildenbrand <david@redhat.com>
>>> - *
>>> - * This code is free software; you can redistribute it and/or modify it
>>> - * under the terms of the GNU Library General Public License version 2.
>>>   */
>>>  #include <libcflat.h>
>>>  #include <kbuild.h>
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index edc06ef..f3ab830 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -1,11 +1,9 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>  /*
>>>   * Copyright (c) 2017 Red Hat Inc
>>>   *
>>>   * Authors:
>>>   *  David Hildenbrand <david@redhat.com>
>>> - *
>>> - * This code is free software; you can redistribute it and/or modify it
>>> - * under the terms of the GNU Library General Public License version 2.
>>>   */
>>>  #ifndef _ASM_S390X_ARCH_DEF_H_
>>>  #define _ASM_S390X_ARCH_DEF_H_
>>> diff --git a/lib/s390x/asm/asm-offsets.h b/lib/s390x/asm/asm-offsets.h
>>> index a6d7af8..bed7f8e 100644
>>> --- a/lib/s390x/asm/asm-offsets.h
>>> +++ b/lib/s390x/asm/asm-offsets.h
>>> @@ -1,10 +1,8 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>  /*
>>>   * Copyright (c) 2017 Red Hat Inc
>>>   *
>>>   * Authors:
>>>   *  David Hildenbrand <david@redhat.com>
>>> - *
>>> - * This code is free software; you can redistribute it and/or modify it
>>> - * under the terms of the GNU Library General Public License version 2.
>>>   */
>>>  #include <generated/asm-offsets.h>
>>> diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
>>> index d862e78..8e2fd6d 100644
>>> --- a/lib/s390x/asm/barrier.h
>>> +++ b/lib/s390x/asm/barrier.h
>>> @@ -1,12 +1,10 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>  /*
>>>   * Copyright (c) 2017 Red Hat Inc
>>>   *
>>>   * Authors:
>>>   *  Thomas Huth <thuth@redhat.com>
>>>   *  David Hildenbrand <david@redhat.com>
>>> - *
>>> - * This code is free software; you can redistribute it and/or modify it
>>> - * under the terms of the GNU Library General Public License version 2.
>>>   */
>>>  #ifndef _ASM_S390X_BARRIER_H_
>>>  #define _ASM_S390X_BARRIER_H_
>>> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
>>> index 2146a01..805fcf1 100644
>>> --- a/lib/s390x/asm/cpacf.h
>>> +++ b/lib/s390x/asm/cpacf.h
>>> @@ -1,3 +1,4 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>  /*
>>>   * CP Assist for Cryptographic Functions (CPACF)
>>>   *
>>
>> This file was originally copied from Linux v4.13. So I'm wondering if
>> this should be
>>
>> SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>>
>> instead. Doesn't make a real difference in practice I guess?
>>
> Linux's arch/s390/include/asm/cpacf.h has the GPL-2.0 identifier, so why
> do you want the syscall note?

When we copied it in v4.13, there was no such identifier.

The tag was added in v4.14

commit b24413180f5600bcb3bb70fbed5cf186b60864bd
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Nov 1 15:07:57 2017 +0100

    License cleanup: add SPDX GPL-2.0 license identifier to files with
no license


So naive me checked COPYING and COPYING.new in v4.13 and spotted

The Linux Kernel is provided under:
	SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note


But as the tag was added in v4.14, GPL-2.0-only seems to be the right
thing to do I assume.


Acked-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

