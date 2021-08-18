Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9A3EFF04
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbhHRIU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:20:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239793AbhHRIUy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 04:20:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629274819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vwTwlNl/ChVG4Exw19xpoyut/CU/s2jMFLukh6oulq0=;
        b=LMoIWiuL86TMvffhN0CXYfFDoQ/rp1SMrDa4fIGIEZEXWtXdnaGH2LLP+ioppPbmSzgSTM
        8AN8GjBl1jc2KcRHsaC4cL777CmS+M0SKEQqH5L1+q9JtzANhmQbgOki0sCPS3JbR3U7n0
        M45DXJ2/GzwNu+Ya4lwrW6j9VWCpYGk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-UsiLyNNqOzuHME0_T9OQjw-1; Wed, 18 Aug 2021 04:20:16 -0400
X-MC-Unique: UsiLyNNqOzuHME0_T9OQjw-1
Received: by mail-ed1-f72.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so659975edu.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vwTwlNl/ChVG4Exw19xpoyut/CU/s2jMFLukh6oulq0=;
        b=pFjgXsVg7ZMd6kCo2nzXnmaxYA0qaAafvEfJbK178axhiN5n3nWQCEyoJLtC+c+41Y
         C3yx9J7Ww2SQF4fje1Ten8CIpW8EwniMt+fixUMvek8p2YvuTUvB+bRpUmf5nqBGgREq
         xSYKZrkk13KUigBX1KhPjGpaCSTJaPFJ8E0MLWsEdP9W0L6xNgEM2a2fH8RSQmVyi84i
         g3ao2UylGiXTLUgJnsSoG/vbzHA4QvBfT6EgEBzIm9jSckMBQ4hA11Wup1B9ypqR5d8n
         6E6cwzKzxvx/5L8a8GbmUhOt2SLWS/6lb0Uibwtt7znkJ2egEtYH8H3BZCXfxt+Ve2Nf
         wYGQ==
X-Gm-Message-State: AOAM533jZuGm79DrBNhBrwD81OEGx1rUUC+TTFla7uiB2sK2D9rrAH28
        8ZYU/4Dj6tuI05VWXRbvp4UUopAwyU3t9W/n2f5Pygp5IqMUCEiZN/mtTUEXDt4SEBNTJ01mhtP
        tylfAYv5uc1xN
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr8379454ejr.435.1629274815126;
        Wed, 18 Aug 2021 01:20:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQqDP2X2CVEYrBUvv3EWAA21MgH0S7mkn8oKJ0O51LTNGOJB/WUoqj+/ljUyB6Jr88QCr5cQ==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr8379448ejr.435.1629274814969;
        Wed, 18 Aug 2021 01:20:14 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id be23sm2203200edb.68.2021.08.18.01.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 01:20:14 -0700 (PDT)
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-2-frankja@linux.ibm.com>
 <20210813103240.33710ea6@p-imbrenda>
 <e0bcb199-7254-01bb-baee-7de83b62495a@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: lib: Extend bitops
Message-ID: <de5b6d16-9ec1-5d77-00ac-61305d90851a@redhat.com>
Date:   Wed, 18 Aug 2021 10:20:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e0bcb199-7254-01bb-baee-7de83b62495a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2021 13.31, Janosch Frank wrote:
> On 8/13/21 10:32 AM, Claudio Imbrenda wrote:
>> On Fri, 13 Aug 2021 07:36:08 +0000
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> Bit setting and clearing is never bad to have.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>   lib/s390x/asm/bitops.h | 102
>>> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102
>>> insertions(+)
>>>
>>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>>> index 792881ec..f5612855 100644
>>> --- a/lib/s390x/asm/bitops.h
>>> +++ b/lib/s390x/asm/bitops.h
>>> @@ -17,6 +17,78 @@
>>>   
>>>   #define BITS_PER_LONG	64
>>>   
>>> +static inline unsigned long *bitops_word(unsigned long nr,
>>> +					 const volatile unsigned
>>> long *ptr) +{
>>> +	unsigned long addr;
>>> +
>>> +	addr = (unsigned long)ptr + ((nr ^ (nr & (BITS_PER_LONG -
>>> 1))) >> 3);
>>> +	return (unsigned long *)addr;
>>
>> why not just
>>
>> return ptr + (nr / BITS_PER_LONG);
>>
>>> +}
>>> +
>>> +static inline unsigned long bitops_mask(unsigned long nr)
>>> +{
>>> +	return 1UL << (nr & (BITS_PER_LONG - 1));
>>> +}
>>> +
>>> +static inline uint64_t laog(volatile unsigned long *ptr, uint64_t
>>> mask) +{
>>> +	uint64_t old;
>>> +
>>> +	/* load and or 64bit concurrent and interlocked */
>>> +	asm volatile(
>>> +		"	laog	%[old],%[mask],%[ptr]\n"
>>> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
>>> +		: [mask] "d" (mask)
>>> +		: "memory", "cc" );
>>> +	return old;
>>> +}
>>
>> do we really need the artillery (asm) here?
>> is there a reason why we can't do this in C?
> 
> Those are the interlocked/atomic instructions and even though we don't
> exactly need them right now I wanted to add them for completeness.

I think I agree with Claudio - unless we really need them, we should not 
clog the sources with arbitrary inline assembly functions.

> We might be able to achieve the same via compiler functionality but this
> is not my expertise. Maybe Thomas or David have a few pointers for me?

I'm not an expert with atomic builtins either, but what's the point of this 
at all? Loading a value and OR-ing something into the value in one go? 
What's that good for?

  Thomas

