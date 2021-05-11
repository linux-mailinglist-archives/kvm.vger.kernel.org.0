Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADD237AAD1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhEKPjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:39:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231782AbhEKPjQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 11:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620747490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA3YA8wLy3fJ4pK+UdDswwsR291TTeUp7+xqxJEhVYY=;
        b=JvK/votoefNpejtfrKXyIzJqbRD3zvmdizP8de6WbuwD4JmVqX2DlY57sg9nOi5pybh260
        jhPx/P/2Uh3kGqSFy3AWAy2DZnlkETui9gDtsop1neIL/VkVM3b0juRqLWzIoZH3RMnIdX
        DAPq5R8h8iQP6SMU4yny6SuTo5Ctklo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-YYlkW-XqNlaL-EEJdGG9tw-1; Tue, 11 May 2021 11:38:08 -0400
X-MC-Unique: YYlkW-XqNlaL-EEJdGG9tw-1
Received: by mail-ej1-f72.google.com with SMTP id z15-20020a170906074fb029038ca4d43d48so6135246ejb.17
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 08:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lA3YA8wLy3fJ4pK+UdDswwsR291TTeUp7+xqxJEhVYY=;
        b=WIhYIr6qlcUIosdO7ULF773J8ESf4+wq3aeqL/DiSCoqLjAz9u8LW0udrL0UMrOBOE
         7iWLRgzg1ux4GRCGKB8iUGmqawDMhjsVhCkIb8sDCD70qt/i3T4Ko8QWvnz+1oI+d+Lv
         4t7eGr6fgGZsUPJ3riABE5CGqyDLQiNZduDMAair9o0YKkRzTsWpXzvsqxBzUv/ecNuM
         cKKbPb+iAFuiVj31xyJHsaKWzBagZpjpznlOgQNw3byf+Vurara8ObYsOQWhaSCyiQ/+
         /J17fE5FSvKnb51aZsWz/bQLvaffVWKwJiR/1hYQ57wBbWpB3u8m7JzR8LSO6e4LBt2E
         LDXA==
X-Gm-Message-State: AOAM533lHMz1PUxbnlXLMiwAcdT6Ejf/DYHYrb9koFd+5t0LvoqvNpW9
        iI7gIXhyHIFVxKCOwJJEDtsu6IhliLvdriQRlMoBUPLgRdY030fCfPprV6yxogG5B2QPyVXel6O
        y9e1yijB658d/
X-Received: by 2002:a17:907:f81:: with SMTP id kb1mr32986021ejc.476.1620747485809;
        Tue, 11 May 2021 08:38:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+4xR4cq7DP1xS9MpVHR7xeg5rXqtoQ4ZWLRP0+lX+o33jqwD6v8lig6L4cWx0D+FfjDusqw==
X-Received: by 2002:a17:907:f81:: with SMTP id kb1mr32985989ejc.476.1620747485534;
        Tue, 11 May 2021 08:38:05 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id p2sm11700066ejo.108.2021.05.11.08.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 08:38:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature
 probing
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-3-frankja@linux.ibm.com>
 <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
 <20210511164137.0bba2493@ibm-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2f0284e1-b1e0-39d6-1fe0-3be808be1849@redhat.com>
Date:   Tue, 11 May 2021 17:38:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210511164137.0bba2493@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.05.21 16:41, Claudio Imbrenda wrote:
> On Tue, 11 May 2021 13:43:36 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 10.05.21 17:00, Janosch Frank wrote:
>>> Lets grab more of the feature bits from SCLP read info so we can use
>>> them in the cpumodel tests.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    lib/s390x/sclp.c | 20 ++++++++++++++++++++
>>>    lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
>>>    2 files changed, 55 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>> index f11c2035..f25cfdb2 100644
>>> --- a/lib/s390x/sclp.c
>>> +++ b/lib/s390x/sclp.c
>>> @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
>>>    	return (CPUEntry *)(_read_info + read_info->offset_cpu);
>>>    }
>>>    
>>> +static bool sclp_feat_check(int byte, int mask)
>>> +{
>>> +	uint8_t *rib = (uint8_t *)read_info;
>>> +
>>> +	return !!(rib[byte] & mask);
>>> +}
>>
>> Instead of a mask, I'd just check for bit (offset) numbers within the
>> byte.
>>
>> static bool sclp_feat_check(int byte, int bit)
>> {
>> 	uint8_t *rib = (uint8_t *)read_info;
>>
>> 	return !!(rib[byte] & (0x80 >> bit));
>> }
> 
> using a mask might be useful to check multiple facilities at the same
> time, but in that case the check should be

IMHO checking with a mask here multiple facilities will be very error 
prone either way ... and we only have a single byte to check for.


-- 
Thanks,

David / dhildenb

