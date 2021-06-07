Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5214C39D92E
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFGJ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhFGJ7h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:59:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623059866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7awUZSmtwE73YaPk78D/jTjtxkiUtYiFGv2HHuxraCI=;
        b=c3CDToi3Jjx1MF7xeLRSUIt+9gg38lAKjsx7/WwiR9A5zTnWT51kPV2oP6xWy0t4gxfwsh
        ITrCst9Ixxmt9bJV8m9MK1nC5LABlIePfFT87Cm8JujUEBmiZd6aiCtWem2+1gvj/On16j
        yhgxtYtEYFXx8HTi7DHNxkSbBYbgI8U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-EHM5eWyVN22sQVZIJ8c7hw-1; Mon, 07 Jun 2021 05:57:44 -0400
X-MC-Unique: EHM5eWyVN22sQVZIJ8c7hw-1
Received: by mail-wm1-f69.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so3916445wml.2
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7awUZSmtwE73YaPk78D/jTjtxkiUtYiFGv2HHuxraCI=;
        b=Xqppfd/d0Z5k8ql7aqB3CS0gi5uDxxxMuMOjZ3Fbm89pUBNbmqIom00QORFlOlX+T3
         VVWVITIyc4YY0q1S2z3aoOd7SZ3j1bRa+uNbKhHmZI78ksSeDy/nzCwVQcB1CiZicF8I
         ZoZSCFkkyPCKtC8WJsIXp7+A3pjYVMl4BC1Nc8+AFiQWqCGusn9lLQLJVtf1RMqZ/Cvm
         shbl1E3QLddYry63gPPC2ZalVFNWYQxRoCz+qfI43h4fjFIpuqb6+hKhdgMe3FWDee9u
         H0HxYnHRqSwlI3ST8SaDQYqV52EWAtfIErdBNgvmPEZMT9GSZ7h+sjV8apslMuP0dRja
         BC7w==
X-Gm-Message-State: AOAM5328XITXQmdTVlomfEzJC/pt/2rIl9air73jHsgH4vdZ1/IhgKI+
        tFzhP244gVdqY7fhLJbFsIi71wjXKLqSeIqD6Gz6vik0I2A/67kgOfy51VWeovHSMIGvLdBH3Dv
        8sRqyoGX4wLeb
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr15684193wrm.177.1623059863449;
        Mon, 07 Jun 2021 02:57:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwy2JnuXPJlE8N8A5u5bpZ8cxRMhkZNB+GZy39rztvdiscVnZi0dfP0L8nuFzQIscu15FLhTw==
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr15684181wrm.177.1623059863324;
        Mon, 07 Jun 2021 02:57:43 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6188.dip0.t-ipconnect.de. [91.12.97.136])
        by smtp.gmail.com with ESMTPSA id l2sm15023010wrp.21.2021.06.07.02.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 02:57:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: run: Skip PV tests when tcg is
 the accelerator
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-4-frankja@linux.ibm.com>
 <92be69b9-227a-d01c-6877-738a4482b8c6@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <656f9301-70ec-a1e1-2d24-48ede0b07aca@redhat.com>
Date:   Mon, 7 Jun 2021 11:57:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <92be69b9-227a-d01c-6877-738a4482b8c6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.06.21 11:54, Thomas Huth wrote:
> On 18/03/2021 13.50, Janosch Frank wrote:
>> TCG doesn't support PV.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/run | 5 +++++
>>    1 file changed, 5 insertions(+)
>>
>> diff --git a/s390x/run b/s390x/run
>> index df7ef5ca..82922701 100755
>> --- a/s390x/run
>> +++ b/s390x/run
>> @@ -19,6 +19,11 @@ else
>>        ACCEL=$DEF_ACCEL
>>    fi
>>    
>> +if [ "${1: -7}" == ".pv.bin" ] || [ "${TESTNAME: -3}" == "_PV" ] && [ $ACCEL == "tcg" ]; then
> 
> Put $ACCEL in quotes?
> 
> With that nit fixed:
> 

Should these "==" be "=" ? Bash string comparisons always mess with my mind.


-- 
Thanks,

David / dhildenb

