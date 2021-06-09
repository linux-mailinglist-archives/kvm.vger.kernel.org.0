Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F233A1A20
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhFIPvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233986AbhFIPvV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623253766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1Rsw4qjtQzXYC5CUL44PJl6CJVfU6O96i1OlLTor14=;
        b=WEW+ubIVKEu4hIcDhSGjmz4XevqN+/z7jd6vvoT+K5zfIrpuAYVXPEmx2VSYiphRuNC1Ea
        xyc5m9D4BLrQMyGIXji1t4E5IKwE3AsP1MzAXl8e/mtDEJCkUN4MUzKWzuwBKEs44IzJv+
        35ax6LYDpiRVqKSwMOPANF7/k/sN/Rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-IjLxG5MGPm2Bo2kpGKrE2g-1; Wed, 09 Jun 2021 11:49:25 -0400
X-MC-Unique: IjLxG5MGPm2Bo2kpGKrE2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D7C100C609;
        Wed,  9 Jun 2021 15:49:24 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F6915D6AD;
        Wed,  9 Jun 2021 15:49:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-3-cohuck@redhat.com>
 <f20b32d0-9272-66d5-e106-a0af4340b95a@redhat.com> <877dj3122a.fsf@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <cf6d1548-0137-902a-4537-cc4d02aee887@redhat.com>
Date:   Wed, 9 Jun 2021 17:49:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877dj3122a.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2021 17:37, Cornelia Huck wrote:
> On Wed, Jun 09 2021, Laurent Vivier <lvivier@redhat.com> wrote:
> 
>> On 09/06/2021 16:37, Cornelia Huck wrote:
>>> Standardize header guards to _LIB_HEADER_H_.
>>>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  lib/alloc_page.h       | 4 ++--
>>>  lib/libcflat.h         | 4 ++--
>>>  lib/list.h             | 4 ++--
>>>  lib/pci-edu.h          | 4 ++--
>>>  lib/pci-host-generic.h | 4 ++--
>>>  lib/setjmp.h           | 4 ++--
>>>  lib/string.h           | 6 +++---
>>>  lib/vmalloc.h          | 4 ++--
>>>  8 files changed, 17 insertions(+), 17 deletions(-)
>>
>> What about lib/argv.h and lib/pci.h?
> 
> argv.h does not have a header guard yet (it probably should?)

I think if we want to standardize header guards we should add them where they are not.

But no real strong opinion on that...

Thanks,
Laurent

