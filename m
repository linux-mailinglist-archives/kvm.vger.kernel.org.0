Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF115B3152
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiIIIE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiIIIEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:04:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738421833
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662710690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZhiapT8W3Dsxl8eue9JSdoDtzpl5bhQQHua5fIvPGNE=;
        b=VAdBiVVO4iKi08vgDusWWs5kz5FaKWXa3sJjmEhe2FnDEMZmZL1iWj2vifHk7OanrJnxuf
        09YzvccDpd6ZTaERgLah8KlPyEzVvb6rEuCD+1/80c3w/fROhwWFnRf+4Urn/7vO4YIuUt
        QetB85qhQSUnvT1NEQk5ugeCXNqlpw0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-255-dqwFc73pNL2qh7OIvyZcbg-1; Fri, 09 Sep 2022 04:04:49 -0400
X-MC-Unique: dqwFc73pNL2qh7OIvyZcbg-1
Received: by mail-qt1-f199.google.com with SMTP id i19-20020ac85e53000000b00342f05b902cso915406qtx.7
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 01:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZhiapT8W3Dsxl8eue9JSdoDtzpl5bhQQHua5fIvPGNE=;
        b=AVzrjKhdZQUqvTUY/WQ0Acyq4t3M7Hdwn4sxk5GoICUhPsSTr5XdFdnGywOGVZxypz
         5KXz3/O+XM9guGFiyoTIA6pjigHdVkGY5hL8XZ2ot0yoI2BTCmdpEUonceLl+5khxdsS
         M9+6kDOyCOhHG0FvHVG92HjtHK2t9f/T9d6Y7UCClrwGyilCC71iflCOpzKyTza1oZSa
         dlxx8/SZQKqyI0tjlBqUlD7P7k9QiQUxloGgSZcHOcQuYshpU1gchTh00x2BxNVabqin
         ZG8fqDXg7ng8w4lPzi/QSAjK34dWa7EvsD/6GlCEXNPRfIASDQvUc54faAzpkGx6EUXt
         deDw==
X-Gm-Message-State: ACgBeo0D1ag8GYzHkUNgdJGtXRONh1jhtCOsixePwJMYtAz9B1fCUFpM
        kIXNxq9tqjRy0VDjCA1J87uTmfmHNTwc7+KxTp7/sf+Igqx9tsyfPsVbmOF9RBRIbJStsx9RvHa
        bu9T+vFGjdvFy
X-Received: by 2002:a05:620a:d51:b0:6bc:c53:5789 with SMTP id o17-20020a05620a0d5100b006bc0c535789mr9235739qkl.47.1662710689049;
        Fri, 09 Sep 2022 01:04:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4mGyHZ+OsnDu4dZxyfIVPB9bNJtnch0V3/Q2qfbyx3gFFzpfxyr6PiBdGybLudYBTBEQ7a0w==
X-Received: by 2002:a05:620a:d51:b0:6bc:c53:5789 with SMTP id o17-20020a05620a0d5100b006bc0c535789mr9235733qkl.47.1662710688850;
        Fri, 09 Sep 2022 01:04:48 -0700 (PDT)
Received: from ?IPV6:2a04:ee41:4:31cb:e591:1e1e:abde:a8f1? ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id v5-20020a05620a0f0500b006a6ebde4799sm883135qkl.90.2022.09.09.01.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 01:04:48 -0700 (PDT)
Message-ID: <2efe546d-2bc9-68b7-3016-a4674b42729c@redhat.com>
Date:   Fri, 9 Sep 2022 10:04:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
 <6cb75197-1d9e-babd-349a-3e56b3482620@redhat.com>
 <c1e0a91e-5c95-8c10-e578-39e41de79f6a@redhat.com>
 <e0a5f20c-32a5-b57d-0b32-3b1256243b02@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <e0a5f20c-32a5-b57d-0b32-3b1256243b02@redhat.com>
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



Am 26/08/2022 um 16:44 schrieb David Hildenbrand:
> On 26.08.22 16:32, Emanuele Giuseppe Esposito wrote:
>>
>>
>> Am 26/08/2022 um 16:15 schrieb David Hildenbrand:
>>> On 16.08.22 12:12, Emanuele Giuseppe Esposito wrote:
>>>> Instead of sending a single ioctl every time ->region_* or ->log_*
>>>> callbacks are called, "queue" all memory regions in a list that will
>>>> be emptied only when committing.
>>>>
>>>
>>> Out of interest, how many such regions does the ioctl support? As many
>>> as KVM theoretically supports? (32k IIRC)
>>>
>>
>> I assume you mean for the new ioctl, but yes that's a good question.
>>
>> The problem here is that we could have more than a single update per
>> memory region. So we are not limited anymore to the number of regions,
>> but the number of operations * number of region.
>>
>> I was thinking, maybe when pre-processing QEMU could divide a single
>> transaction into multiple atomic operations (ie operations on the same
>> memory region)? That way avoid sending a single ioctl with 32k *
>> #operation elements. Is that what you mean?
> 
> Oh, so we're effectively collecting slot updates and not the complete
> "slot" view, got it. Was the kernel series already sent so I can have a
> look?

I am going to send it today. I got something working, but it's a little
bit messy on the invalid slots part.

> 
> Note that there are some possible slot updates (like a split, or a
> merge) that involve multiple slots and that would have to be part of the
> same "transaction" to be atomic.
> 
> 

Limiting the size of operations in the IOCTL can be something for the
future. Currently it's already pretty complicated as it is (in the KVM
side), plus I don't see ioctls with more than 8 requests.

Thank you,
Emanuele

