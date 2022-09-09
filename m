Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886DF5B313A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiIIIBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIIIA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:00:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8524C85F84
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662710453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8kXJThmh8lkcaH4ThL00dxXWXZVVggKVVWOSvSbJzBo=;
        b=D6OjEPFb2b/zEAbcXTFvR2i/EjI8fnQncIErweJ/LM/hfFU0M9FGjqXJ/N0wyzHcl/qlzY
        /teed5LAzuRxdGLjARaxLVOXgTzp8Gbaeknf5lB2o7dWXVXGfbYkgrgx0JlQ2Qn4F8gxTq
        kF13tZYjYAPMhZ3dg9UbyUU66YLQa+Q=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-lBssk86NPXqm42-kG0cG-Q-1; Fri, 09 Sep 2022 04:00:52 -0400
X-MC-Unique: lBssk86NPXqm42-kG0cG-Q-1
Received: by mail-qt1-f198.google.com with SMTP id fy12-20020a05622a5a0c00b00344569022f7so890635qtb.17
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 01:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8kXJThmh8lkcaH4ThL00dxXWXZVVggKVVWOSvSbJzBo=;
        b=nOrpkRxq4sGiKJJjDfSEi3fWReGnj35kIcg3dntKH5sBiCT/mX5PI4L/ahJ0Cf0X0T
         AKOeSg8kflKPH8LLFNqu3fx1KiP+0AB6XKZyWb4Vlza6kQX0lrWcqFXugiWptUscVFRC
         pxT8zvMf98ExSQfPzjhUfqQdt8ETnYiMQqOILtPtBJKR/dLZjSN07T7AWn1hAiGxH8uY
         vSAmnFS3VYCGBzS+xyE41tfTdcMeL0DkaHKGwaBDGrVEvT9nnD2i/1CcQB7F4Wu8lFT6
         N0ETEflWHd/l3ZCd4CByIJ0UMm6cUGZoCc4CsINAUIZqlKlb/FTHWQLm/iI+jQbqYt9V
         RGlQ==
X-Gm-Message-State: ACgBeo1SSbb5JQ80HkVgEVKViXSnFE9JF2wYno0wNrhQ3EBzaehKHQp+
        ACAT1ficnRL0LJovGfWA2EnTZSgl5wC41pd49t/KxiJqu/GZsjlTHLnn67J9dI9TuI9bza3tFO8
        Ec9Ydas8esI/G
X-Received: by 2002:a05:622a:514:b0:343:555a:d611 with SMTP id l20-20020a05622a051400b00343555ad611mr11485363qtx.486.1662710451460;
        Fri, 09 Sep 2022 01:00:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4O0+imJPdLBl9OFqfUKw+tM+5xAjMMdde5YWfyIvufRFOF06816S9HfGsSU69t3u7liyHV7Q==
X-Received: by 2002:a05:622a:514:b0:343:555a:d611 with SMTP id l20-20020a05622a051400b00343555ad611mr11485338qtx.486.1662710451195;
        Fri, 09 Sep 2022 01:00:51 -0700 (PDT)
Received: from ?IPV6:2a04:ee41:4:31cb:e591:1e1e:abde:a8f1? ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id bs44-20020a05620a472c00b006b5f06186aesm864617qkb.65.2022.09.09.01.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 01:00:50 -0700 (PDT)
Message-ID: <1c6d0b99-737e-c485-952e-6e21015de455@redhat.com>
Date:   Fri, 9 Sep 2022 10:00:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
 <YwOOcC72KKABKgU+@xz-m1.local>
 <d4601180-4c95-a952-2b40-d40fa8e55005@redhat.com>
 <YwqFfyZ1fMA9knnK@xz-m1.local>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YwqFfyZ1fMA9knnK@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Apologies for the delay to answer you.

[...]
>>
>> - Doing the above is still not enough, as KVM figures what operation to
>> do depending on the current state of the memslots.
>> Assuming we already have an already existing MR y, and now we get the
>> list DELETE(y) CREATE(y/2) (ie reducing y to half its size).
>> In this case the interval tree can't do anything, but it's very hard to
>> understand that the second request in the list is a CREATE, because when
>> KVM performs the check to understand which type of operation it is
>> (before doing any modification at all in the memslot list), it finds
>> that y (memslot with same id) exist, but has a different size than what
>> provided from userspace, therefore it could either fail, or misinterpret
>> it as another operation (currently fails -EINVALID).
> 
> Another good question..  I think that can be partly solved by not allowing
> ID duplication in the same batched ioctl, or maybe we can fail it.  From
> qemu perspective, we may need to change the memslot id allocation to not
> reuse IDs of being-deleted memslots until the batch is processed.
> 
> Something like adding similar INVALID tags to kvm memslots in QEMU when we
> are preparing the batch, then we should only reset memory_size==0 and clear
> INVALID tag after the ioctl returns.  Then during the batch, any new slots
> to be added from kvm_get_free_slot() will not return any duplication of a
> deleting one.

First of all, you're right. No interval tree is needed.

I think the approach I am currently using is something like what you
described above: when a DELETE operation is created in QEMU (there is no
MOVE), I set the invalid_slot flag to 1.
Then KVM will firstly process the requests with invalid_slot == 1, mark
the memslot invalid, and then process all the others (invalid included,
as they need the actual DELETE/MOVE operation).

> 
>> If we instead already provide the labels, then we can:
>> 	1. substitute the memslots pointed by DELETE/MOVE with invalid & swap
>> (so it is visible, non-atomic. But we don't care, as we are not deleting
>> anything)
>> 	2. delete the invalid memslot (in the inactive memslot list)
>> 	3. process the other requests (in the inactive memslot list)
>> 	4. single and atomic swap (step 2 and 3 are now visible).
>>
>> What do you think?
> 
> Adding some limitation to the new ioctl makes sense to me, especially
> moving the DELETE/MOVE to be handled earlier, rather than a complete
> mixture of all of them.
> 
> I'm wondering whether the batch ioctl can be layed out separately on the
> operations, then it can be clearly documented on the sequence of handling
> each op:
> 
>   struct kvm_userspace_memory_region_batch {
>          struct kvm_userspace_memory_region deletes[];
>          struct kvm_userspace_memory_region moves[];
>          struct kvm_userspace_memory_region creates[];
>          struct kvm_userspace_memory_region flags_only[];
>   };
> 
> So that the ordering can be very obvious.  But I didn't really think deeper
> than that.

No, I think it doesn't work. Oder needs to be preserved, I see many
DELETE+CREATE operations on the same slot id.
> 
> Side note: do we use MOVE at all in QEMU?

Nope :)

> 
>>
>> Bonus question: with this atomic operation, do we really need the
>> invalid memslot logic for MOVE/DELETE?
> 
> I think so.  Not an expert on that, but iiuc that's to make sure we'll zap
> all shadow paging that maps to the slots being deleted/moved.
> 
> Paolo can always help to keep me honest above.

Yes, we need to keep that logic.

v2 is coming soon.

Thank you,
Emanuele

