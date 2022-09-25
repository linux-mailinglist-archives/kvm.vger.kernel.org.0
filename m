Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B345E96DC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 01:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiIYXSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 19:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiIYXSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 19:18:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE9022B02
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664147887;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ptiGaD3G+IhVdhjFFBlKMExPKWawt6y48scQT8DiYO0=;
        b=bNFtBRgTKf30+vmrljhdinEM1mtch5rhw68AuP9YSPduxmfFVLc45rurzNC4NZkc+51g3T
        EFFKU/a6iTryUX3l3uEkaG0I/JMgs4Ka7yiq/T1k6veAS2UBQpEFEkLybvdmYuYqB9Pc/6
        sj8o1PkyImrPT7Z5Z2pC92Hurf1EF3I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-pIiwYQYYMLKk88B7wUEWBQ-1; Sun, 25 Sep 2022 19:18:03 -0400
X-MC-Unique: pIiwYQYYMLKk88B7wUEWBQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B57CE800B30;
        Sun, 25 Sep 2022 23:18:02 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E2A2492CA2;
        Sun, 25 Sep 2022 23:17:57 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
To:     Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org> <YyzYI/bvp/JnbcxS@xz-m1.local>
 <87czbmjhbh.wl-maz@kernel.org> <Yy36Stppz4tYBPiP@x1n>
 <87edw1i290.wl-maz@kernel.org> <87czblhv2a.wl-maz@kernel.org>
 <Yy8EmMhF+2jcm3m6@x1n> <878rm8ior6.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <66c66102-4c59-f5b4-5cb4-56488f8d156f@redhat.com>
Date:   Mon, 26 Sep 2022 09:17:54 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <878rm8ior6.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/25/22 4:57 AM, Marc Zyngier wrote:
> On Sat, 24 Sep 2022 14:22:32 +0100,
> Peter Xu <peterx@redhat.com> wrote:
>>
>> On Sat, Sep 24, 2022 at 12:26:53PM +0100, Marc Zyngier wrote:
>>> On Sat, 24 Sep 2022 09:51:39 +0100,
>>> Marc Zyngier <maz@kernel.org> wrote:
>>>>
>>>> I'm happy to bikeshed, but please spell it out for me. If we follow
>>>> the current scheme, we need 3 configuration symbols (of which we
>>>> already have one), and 2 capabilities (of which we already have one).
>>
>> I hope it's not bikeshedding.  I normally don't comment on namings at all
>> because many of them can be "bikeshedding" to me.  But this one is so
>> special because it directly collides with KVM_GET_DIRTY_LOG, which is other
>> method of dirty tracking.
> 
> Fair enough. I'm notoriously bad at sticking a name to things, so I'm
> always happy to receive suggestions.
> 
>>
>>>>
>>>> Do you have any concrete proposal for those?
>>>
>>> In order to make some forward progress, I've reworked the series[1]
>>> with another proposal for those:
>>>
>>> Config symbols:
>>>
>>> - HAVE_KVM_DIRTY_RING:
>>>    * mostly the same meaning as today
>>>    * not directly selected by any architecture
>>>    * doesn't expose any capability on its own
>>>
>>> - HAVE_KVM_DIRTY_RING_TSO:
>>>    * only for strongly ordered architectures
>>>    * selects HAVE_KVM_DIRTY_RING
>>>    * exposes KVM_CAP_DIRTY_LOG_RING
>>>    * selected by x86
>>>
>>> - HAVE_KVM_DIRTY_RING_ACQ_REL:
>>>    * selects HAVE_KVM_DIRTY_RING
>>>    * exposes KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>>>    * selected by arm64 and x86
>>>
>>> Capabilities:
>>>
>>> - KVM_CAP_DIRTY_LOG_RING: the good old x86-specific stuff, advertised
>>>    when HAVE_KVM_DIRTY_RING_TSO is selected
>>>
>>> - KVM_CAP_DIRTY_LOG_RING_ACQ_REL: the new acquire/release semantics,
>>>    advertised when HAVE_KVM_DIRTY_RING_ACQ_REL is selected
>>>
>>> This significantly reduces the churn and makes things slightly more
>>> explicit.
>>
>> This looks good to me, thanks.
> 
> OK, thanks for having a quick look. I'll repost this shortly, after
> I'm done reviewing Gavin's series.
> 

The config options and capabilities look good to me either. I will
post my v4 series, which will rebased on your v2 series.

Thanks,
Gavin

