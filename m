Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66D03F9814
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244893AbhH0KW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244773AbhH0KW7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630059730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAZVskqCKTPkIKY551qYvUlBuFGPkCeCXuuObTbsmn4=;
        b=B3Zeh6ef7Widm2vJKb0qBTewdm7CzMMPZmMi75RTRPdtoWWsxQD6PzRZMDp7Q4iqxre5cg
        zQxYL8STgo5b8UUHcaen4JVuxvVB0cLT1B5xXRxqr17FYxFZi8PzScHW2ApcQzd3tbGhUR
        gjWNmJtpAYlasiQbO8FztJ/n3iZtkJE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-Uv4HAKmEPWuBfB3Zxyhk4A-1; Fri, 27 Aug 2021 06:22:08 -0400
X-MC-Unique: Uv4HAKmEPWuBfB3Zxyhk4A-1
Received: by mail-wm1-f72.google.com with SMTP id y188-20020a1c7dc5000000b002e80e0b2f87so5701920wmc.1
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aAZVskqCKTPkIKY551qYvUlBuFGPkCeCXuuObTbsmn4=;
        b=jpry+CyOqNGmOwUlYlehFlv0iZs859n7jNqYIN84PM1DXpvTfSZ4zstWeTEjqMzIym
         Tsvz3StJlzpZE7ISK/hBu8rnEnYneZlt+pkxQqHLYwE/tUH2VcSwBJYevuhPW8l6G25/
         Z1w2ljLzga9HzYOrNzP4c2ZYFhEu/mBsmVfPdYn6zWsxG9vK6h5fVFMpoklWk64iSl6X
         zviPqnuGA4cGqaxydTZgdMRz9Xyz6fUnUlEsfqPz+et6q5a5eyPdkLZnfI4Tx84qW7N9
         17AObaDnlju3hKHUq94Xl/8zCZT5yfJWg17zLULBwOsxH9Hv8vs7vmp6XQ/tN4iqHJKz
         RhJQ==
X-Gm-Message-State: AOAM5322K0n+oVTwS70ulmgA/qKm7Cle/xUoHsv+FMW5OFqznKzDascf
        pHyDM6lbLsFS+7iTT3/sJ5QjIqbuzCmnqmuZxe9parWVxBxt2tUv/ohYC/WKZccotcXCl/Pkc22
        u4aHTu2OWCWX2
X-Received: by 2002:a1c:a544:: with SMTP id o65mr8036207wme.53.1630059727740;
        Fri, 27 Aug 2021 03:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOy3E/ljuKc9nvk7wd0g2v0+AwOwKFEiwWt2P200WRVD8hxFEikjNcaxnz4pGn2/m+znNUpA==
X-Received: by 2002:a1c:a544:: with SMTP id o65mr8036181wme.53.1630059727471;
        Fri, 27 Aug 2021 03:22:07 -0700 (PDT)
Received: from thuth.remote.csb (dynamic-046-114-148-182.46.114.pool.telefonica.de. [46.114.148.182])
        by smtp.gmail.com with ESMTPSA id g136sm1909114wmg.30.2021.08.27.03.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 03:22:07 -0700 (PDT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
 <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
 <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
Message-ID: <b98bba6f-7ea9-ac3d-96d8-3a17ab1714db@redhat.com>
Date:   Fri, 27 Aug 2021 12:22:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2aaffea2-0a20-1a6d-eebb-69b6cfe6e83c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 11.26, Pierre Morel wrote:
> 
> 
> On 8/26/21 7:07 AM, Thomas Huth wrote:
>> On 25/08/2021 18.20, Pierre Morel wrote:
>>> In Linux, cscope uses a wrong directory.
>>> Simply search from the directory where the make is started.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   Makefile | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index f7b9f28c..c8b0d74f 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux 
>>> $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>>>   cscope:
>>>       $(RM) ./cscope.*
>>>       find -L $(cscope_dirs) -maxdepth 1 \
>>> -        -name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | 
>>> sort -u > ./cscope.files
>>> +        -name '*.[chsS]' -exec realpath --relative-base=. {} \; | sort 
>>> -u > ./cscope.files
>>
>> Why is $PWD not pointing to the same location as "." ? Are you doing 
>> in-tree or out-of-tree builds?
>>
>>   Thomas
>>
> 
> In tree.
> That is the point, why is PWD indicating void ?
> I use a bash on s390x.
> inside bash PWD shows current directory
> GNU Make is 4.2.1 on Ubuntu 18.04

Hmm, looking at the code twice, $(PWD) is used a a Make variable, not as a 
shell variable. For using a shell variable, it should use double $$ instead ...
So yes, this is broken since $(PWD) does not seem to be an official Make 
variable. There is $(CURDIR) which could do the job, too, but I guess "." is 
just fine as well. Andrew, what do you think?

  Thomas

