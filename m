Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2844D525
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 11:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhKKKmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 05:42:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232257AbhKKKmM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 05:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636627163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0gdxW9mBWWc+JEXCZBmhzMkZ16GvCBFwqBu4beAo6o=;
        b=NT9VsZL3eaU+R6RZH96NPcX8lneAQGFW+ylnI6t1W6qA9DjI1CHTiSfYWJN5xzA/WgZj7L
        2jbKbKfWUSUMZTcxpa5ZgaKz1fWj7Va46zQGoHXQJVckx79F97kLkFjexQ1Sn5h7Nzhdj2
        1JRUZnWm/DxnAjv6Qb7bP+hRcG8qpIs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-05NioHl8NH-K-nDYZVjSfA-1; Thu, 11 Nov 2021 05:39:22 -0500
X-MC-Unique: 05NioHl8NH-K-nDYZVjSfA-1
Received: by mail-wm1-f71.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so2477041wmq.9
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 02:39:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=H0gdxW9mBWWc+JEXCZBmhzMkZ16GvCBFwqBu4beAo6o=;
        b=JilRpRSGjXeR5fjhDIuXD1ycDcPh+QMa/MMPCbPQD2BJT7ItP7ELv/qnI4k4aYfnZt
         HPDRNQPMdooz1BVPguMDacuwU0yiJf2u+SIGUQ2Slu62HSRrvcRXIdyp+JZjaey+Da81
         Bp6IQdvM2QoQjcblM1vMp1NDwelcWj3ZHunxbXYYrykYVuYNIWPArIDGtmhw10PueSfu
         dM39oRzvr39LfFtmUWmUHbs3+I8Xj3AzXc8sl7PaB7ocGT/a6jhUCSn7CFZ8tgc7mFoZ
         Fxg7yeIPqwdhOZya2nfLRsdZliG/oISVImuMS6/L/Q5ORTUhZL69Enk3Gcgp9kEFDBbG
         iaew==
X-Gm-Message-State: AOAM532KPJ1k+kIrYUKv5Ieqgvrq1iZkcqWphIfg6zRG98K2ckC8l3zE
        29+AMQJEG07iSDGKwuVX9W6l93NWKLZeUPNqHm/9u33Zwewp+HTcaJ2O611naSWVLgkOFZLCL6z
        I54hJJrkhoG6+
X-Received: by 2002:a05:6000:1a48:: with SMTP id t8mr7758190wry.66.1636627161197;
        Thu, 11 Nov 2021 02:39:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytqY9gWLLASfrKU+/DnnUJZrIwW4e8oFknMUGjm8bSvo6BqMl/1e1xZ3qnic6S77LHDi/ZnQ==
X-Received: by 2002:a05:6000:1a48:: with SMTP id t8mr7758172wry.66.1636627161034;
        Thu, 11 Nov 2021 02:39:21 -0800 (PST)
Received: from [192.168.3.132] (p4ff23ee8.dip0.t-ipconnect.de. [79.242.62.232])
        by smtp.gmail.com with ESMTPSA id g5sm3906197wri.45.2021.11.11.02.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 02:39:20 -0800 (PST)
Message-ID: <4828bb9d-6bfe-a9da-51a4-77f4e78f7556@redhat.com>
Date:   Thu, 11 Nov 2021 11:39:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com
References: <20211111100153.86088-1-pmorel@linux.ibm.com>
 <31f51c84-c7f9-8251-39a8-3ff38496ae5e@redhat.com>
 <20211111112806.50e4d22a@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211111112806.50e4d22a@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.11.21 11:28, Claudio Imbrenda wrote:
> On Thu, 11 Nov 2021 11:14:53 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 11.11.21 11:01, Pierre Morel wrote:
>>> The allocator allocate pages it follows the size must be rounded
>>> to pages before the allocation.
>>>
>>> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
>>>   
>>
>> What's the symptom of this? A failing test? Or is this just a pro-activ fix?
> 
> if size < PAGE_SIZE then we would allocate 0, and in general we are
> rounding down instead of up, which is obviously wrong.
> 

I know, but is this fixing a failing test or is this just a pro-activ fix?

-- 
Thanks,

David / dhildenb

