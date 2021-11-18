Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5255455543
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 08:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhKRHPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 02:15:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243690AbhKRHMD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 02:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637219341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79ewvaYiUo9THszBLB/dRHHb/ozXVJC0AHWWIE4QzLc=;
        b=Di60uyfFbkq/1afPRQ/sEicHD4zlcOpJ4mULFzbtIQfxUpW7/y6ZIq1OKZYRvjsPexeucQ
        +z4TQLSlTZ+pvGSmfj1zxsR3wrYriFalQ3o5HIrpeWa7azp4eNICwPRW1EXhFEAKVGizmX
        MsdnOjtHVxYddHvYwcLTaxoT5gMxTk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-1ggQZ4dWPMKs5jUcVHMrzw-1; Thu, 18 Nov 2021 02:08:58 -0500
X-MC-Unique: 1ggQZ4dWPMKs5jUcVHMrzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C7831030C21;
        Thu, 18 Nov 2021 07:08:57 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E73E5D9DE;
        Thu, 18 Nov 2021 07:08:55 +0000 (UTC)
Message-ID: <c6a42ab2-34be-b75e-e474-4ca8a80cea48@redhat.com>
Date:   Thu, 18 Nov 2021 08:08:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: MMU: update comment on the number of page role
 combinations
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20211116101114.665451-1-pbonzini@redhat.com>
 <85599dcde5c8c6b74437fac28ebb62c38dafc6a8.camel@redhat.com>
 <42866023-7380-823d-c4c1-2fbf7b5d9527@redhat.com>
 <YZWBaW6P+TBKy9ez@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZWBaW6P+TBKy9ez@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 23:25, Sean Christopherson wrote:
>>
>> Here is a better writeup:
>>
>>   *   - invalid shadow pages are not accounted, so the bits are effectively 18
>>   *   - quadrant will only be used if gpte_is_8_bytes is zero (non-PAE paging);
>>   *     execonly and ad_disabled are only used for nested EPT which has
>>   *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
>>   *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
>>   *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
>>   *     paging has exactly one upper level, making level effectively redundant
>>   *     when gpte_is_8_bytes=0.
>>   *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if cr0_wp=0,
>>   *     therefore these three bits only give rise to 5 possibilities.
>>
>> FWIW, the full count becomes 6400 unless I screwed up the math.
> Which is "in the neighborhood of 2^13":-)
> 

2^12 if SMM is not counted.

Paolo

