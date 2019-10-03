Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C267CC9C07
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfJCKSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfJCKSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:18:33 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 294498665A
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 10:18:33 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r21so498845wme.5
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 03:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kJvG7AsVE1kOxpy6R0lC9bIz0B0NBEXKBgW46F4eplU=;
        b=Rapr4OQ6sGjUk69achrG9fqu+CTUr/z+BYdMoW3Vch2GY7wncudSfF6TL1Ws+Kwk4S
         /gu4AAAuBsI9yszXtD0qg5ImgD/AwVneecyCatM26InMThHNLr+PZSF6r9JFvGWbGUno
         JgEZvMCYqL+Tn9Ya7pHH0lgQF1REbUOv9uTqKZzCWI3DNulcf4UmG/hsnDLj5jXyqWWE
         C8MDpmFPn3bjVgStGAQxUE1oQLoM9Soddcz1FATwXdYSWp2/7kULjogrD4xuF2P1o9ys
         hDeuHleZAxOpvLyfMy77pjPGJ8CwLRVKKMoBoRd1cOR0dnL2e792ThR1+2OUCDMtFO1t
         SlOQ==
X-Gm-Message-State: APjAAAVQdjp+zXCRQjChVoaYqda0+MA5GM4BItr2KpIH/ywoWNtiF0Nc
        N0gI3riec/BSibnE7vlYyqpsdQ++/XFVqZ5QeDxsXR2JxOqLeUIl3OjxUUdYx2V8wazVSgXba/Z
        dPz3Iiz0MOpBC
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr5375034wrr.135.1570097911580;
        Thu, 03 Oct 2019 03:18:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxyOo9+WbTEPSnrxk0HoOCGPhnve3bI8R+NZJKF9mI6DFxEWj+2jdnElRKabbYCZ/v+7iwKyg==
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr5375020wrr.135.1570097911387;
        Thu, 03 Oct 2019 03:18:31 -0700 (PDT)
Received: from [192.168.1.35] (240.red-88-21-68.staticip.rima-tde.net. [88.21.68.240])
        by smtp.gmail.com with ESMTPSA id h17sm3405934wme.6.2019.10.03.03.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 03:18:30 -0700 (PDT)
Subject: Re: [PATCH] accel/kvm: ensure ret always set
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20191002102212.6100-1-alex.bennee@linaro.org>
 <05d59eb3-1693-d5f4-0f6d-9642fd46c32a@redhat.com>
 <20191003092213.etjzlwgd7nlnzqay@steredhat>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e85b2eaa-1190-c372-5875-6a024ae3a9cd@redhat.com>
Date:   Thu, 3 Oct 2019 12:18:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191003092213.etjzlwgd7nlnzqay@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/19 11:22 AM, Stefano Garzarella wrote:
> On Wed, Oct 02, 2019 at 01:08:40PM +0200, Paolo Bonzini wrote:
>> On 02/10/19 12:22, Alex Bennée wrote:
>>> Some of the cross compilers rightly complain there are cases where ret
>>> may not be set. 0 seems to be the reasonable default unless particular
>>> slot explicitly returns -1.
>>>
> 
> Even Coverity reported it (CID 1405857).

And GCC ;)

/home/phil/source/qemu/accel/kvm/kvm-all.c: In function ‘kvm_log_clear’:
/home/phil/source/qemu/accel/kvm/kvm-all.c:1121:8: error: ‘ret’ may be 
used uninitialized in this function [-Werror=maybe-uninitialized]
      if (r < 0) {
         ^
cc1: all warnings being treated as errors
make[1]: *** [/home/phil/source/qemu/rules.mak:69: accel/kvm/kvm-all.o] 
Error 1

Fixes: 4222147dfb7

>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>>   accel/kvm/kvm-all.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index aabe097c41..d2d96d73e8 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -712,11 +712,11 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
>>>       KVMState *s = kvm_state;
>>>       uint64_t start, size, offset, count;
>>>       KVMSlot *mem;
>>> -    int ret, i;
>>> +    int ret = 0, i;
>>>   
>>>       if (!s->manual_dirty_log_protect) {
>>>           /* No need to do explicit clear */
>>> -        return 0;
>>> +        return ret;
>>>       }
>>>   
>>>       start = section->offset_within_address_space;
>>> @@ -724,7 +724,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *kml,
>>>   
>>>       if (!size) {
>>>           /* Nothing more we can do... */
>>> -        return 0;
>>> +        return ret;
>>>       }
>>>   
>>>       kvm_slots_lock(kml);
>>>
>>
>> Queued, thanks.
>>
>> Paolo
>>
> 
