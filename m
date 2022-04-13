Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD54FF1EF
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiDMIdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 04:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiDMIdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 04:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CBEA45780
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 01:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649838687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NeUqm+ne36F4xgLJ0X00uzh5NyAKLt8TFOnpvu4oBhU=;
        b=Wz5/thO0BRBU/DLju2mJyh10fOIErs0OEFxngTrVWRV7NLBBOplaEM0/coCzGfbOE3iJ/C
        IRwnV7hlmMbRNoYOXoSTkxZ+GbRnZrZN4AdzvPLcphNrmY/3Pd9u/LKHNn0xQ+U3QdI7Qm
        IdwYuPkO/328qahR7+nBQJEFtVkP7rQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-NlrS8LEuPq-6-8md8r3kSA-1; Wed, 13 Apr 2022 04:31:25 -0400
X-MC-Unique: NlrS8LEuPq-6-8md8r3kSA-1
Received: by mail-wm1-f69.google.com with SMTP id l41-20020a05600c1d2900b0038ec007ac7fso2519332wms.4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 01:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NeUqm+ne36F4xgLJ0X00uzh5NyAKLt8TFOnpvu4oBhU=;
        b=n1ugCqn4SuQjv2gugFh0MmG4CSfUxdGH+6Q7aW8ROapSWBjwV4o5hQJOxPts7UrVxL
         iNw7Q++YL7naeV60pUy0Xa8NqCV2LuNN0vkpQLHld4K9f//jPge3JdZmaxlMpFbNglJX
         DIeYprd067MaJ2El3F1KGrNvxp3eUkV/l7DB6s5wcEu0hkbISoO1ujKo9uPnIfqE5p+K
         kBABGChhYc4LN1th/PqXpg867jxCf4IOmxkFkbdpIvzwUQAe/7Kwk+ZxAt6nYKXqvHbZ
         ZoBSUIQXDJNNBpakbYNlKh0lTHt4oscEQ6WarfDYpsAYGs/Dbg3vumhGsICHNNXSn82n
         xiSQ==
X-Gm-Message-State: AOAM533c28JhU6bnAYVfP3wI2hZ3VAr/ured4CKGxE2GVseYHWgeB/2P
        hGu5x0V9V9A+Daiisxe6qaVnk0W7BX0mH5PHO0ew/H1QkM2g9WcG3Z+4Rtoyywl+ZPbqweWuheD
        uOeFrocGxoaKa
X-Received: by 2002:a05:6000:1864:b0:207:b1b8:8344 with SMTP id d4-20020a056000186400b00207b1b88344mr4345739wri.172.1649838684609;
        Wed, 13 Apr 2022 01:31:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE77uz5Z4qxBFMdWfSHiOPeKoA86guzdUMpVNT5mhHJZqAhkmBKh6Y3vvYaiB/aZOzrfokaw==
X-Received: by 2002:a05:6000:1864:b0:207:b1b8:8344 with SMTP id d4-20020a056000186400b00207b1b88344mr4345721wri.172.1649838684401;
        Wed, 13 Apr 2022 01:31:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e10-20020a056000178a00b00207b6905778sm1243846wrg.33.2022.04.13.01.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:31:23 -0700 (PDT)
Message-ID: <64456e38-0994-f2bb-39df-a7614c98c62c@redhat.com>
Date:   Wed, 13 Apr 2022 10:31:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is
 constant
Content-Language: en-US
To:     Anton Romanov <romanton@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
References: <20220225013929.3577699-1-seanjc@google.com>
 <609de7ff-92e2-f96e-e6f5-127251f6e16d@redhat.com>
 <CAHFSQMj-Q08Fu1tdPuz+kcdvAoh2cuc_ZgH=qijSet55fxHLNw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHFSQMj-Q08Fu1tdPuz+kcdvAoh2cuc_ZgH=qijSet55fxHLNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 19:38, Anton Romanov wrote:
>> Queued, but I'd rather have a subject that calls out that max_tsc_khz
>> needs a replacement at vCPU creation time.  In fact, the real change
>> (and bug, and fix) is in kvm_arch_vcpu_create(), while the subject
>> mentions only the change in kvm_timer_init().
>>
>> What do you think of "KVM: x86: Use current rather than max TSC
>> frequency if it is constant"?
>
> Ping. This said "queued" but I don't think this ever landed.
> What's the status of this?
> Paolo, does this need more work?

The features in my second pull request were rejected by Linus so they 
will be in 5.19.  I'm going to open kvm/next today and the patches will 
be there.

Unfortunately he hasn't replied to my rebuttal at 
https://lore.kernel.org/kvm/30ffdecc-6ecd-5194-14ec-40e8b818889a@redhat.com/#t 
so I have no idea what his opinion is.  I'll try to get more stuff in 
early for the next releases.

Paolo

