Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118603A1927
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhFIPVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:21:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232861AbhFIPV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPs1wywtpCyKnad9uo0ufdiauhYEOI43/mf6957AL8M=;
        b=FuYjs1MguaMjHGTCDdYiqAkyZcLSWWldxSl3NeVlu02VYC11Odl3eLAxB9uZL5OGOulZ8A
        yBfmv9SbTxTT0RC9dlra8u3+jpngPdgb+86Z0+/r9qaOyhlZu9vDNQMfdYmJGpOiUFRynm
        FkuiDmW5jRr4DerUbskOeNKEAccU6sc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-kf6qpB-yPj-dkOTAj5ORMA-1; Wed, 09 Jun 2021 11:19:14 -0400
X-MC-Unique: kf6qpB-yPj-dkOTAj5ORMA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A9F0101C8AD;
        Wed,  9 Jun 2021 15:19:12 +0000 (UTC)
Received: from localhost (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19CFD60853;
        Wed,  9 Jun 2021 15:19:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for
 header guards format
In-Reply-To: <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
Organization: Red Hat GmbH
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
 <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 09 Jun 2021 17:19:06 +0200
Message-ID: <87a6nz12xh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09 2021, David Hildenbrand <david@redhat.com> wrote:

> On 09.06.21 16:37, Cornelia Huck wrote:
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   README.md | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>> 
>> diff --git a/README.md b/README.md
>> index 24d4bdaaee0d..687ff50d0af1 100644
>> --- a/README.md
>> +++ b/README.md
>> @@ -156,6 +156,15 @@ Exceptions:
>>   
>>     - While the kernel standard requires 80 columns, we allow up to 120.
>>   
>> +Header guards:
>> +
>> +Please try to adhere to adhere to the following patterns when adding
>> +"#ifndef <...> #define <...>" header guards:
>> +    ./lib:             _HEADER_H_
>> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
>> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
>
> I'd have used _ARCH_ASM_HEADER_H_

I had that first, but the pattern I ended up using caused way less churn
(this is basically what arm[64] uses.)

>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Thanks!

