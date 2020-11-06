Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C642A96F5
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 14:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgKFNZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 08:25:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbgKFNZG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 08:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604669105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkuxbR4G3FNGPeIH1SPkdjbNDS2i/SsFPcilaKLEB9Q=;
        b=gZEkjVsSzhM8PF05CrbOGIy06LlaieFn/sYgy9tSHt21u0jdYqPMssih9wvjV8wvX25O/7
        ty6XoYEr1HiV1SrdFghHSo85OcKiNVDnSX4DBxMTH7a8JlRihZXwBZ2IxAoIYU4oreMDhW
        NNQ/ABEsjn4V9V5itTFxrkP9jQ8+BRI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-DeMIhcz7PV60qa6O0bFwjw-1; Fri, 06 Nov 2020 08:25:03 -0500
X-MC-Unique: DeMIhcz7PV60qa6O0bFwjw-1
Received: by mail-wr1-f72.google.com with SMTP id q15so469168wrw.8
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 05:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qkuxbR4G3FNGPeIH1SPkdjbNDS2i/SsFPcilaKLEB9Q=;
        b=N9nZ5+lOC2n3jsiV4EO1ZZ12vtOGogQSxABW/fmyiXwEZnGomWkYWnJu5EgNu4rqfM
         OspC6nj/LIyVma7lF4nU3KC8XMDQoE0l+KC14dnEpdA413wPtJh0IySqrKRWJ/YWEPI5
         BrROAZ6r1W582CKchxUnnv/leVG56OfkctmOakXmnBpoWzjlM2UKemw/SXAm8enj9Z1W
         uOD66t1DsxZZ40ZuvN2TTAs7WV5C1ndWkPAt9uS0fGr4378Ha9VVSEgYH60xFU/UZaix
         b1mmvArhjwCH18D58Q/Az70pYo30Fu3uARwRkHrDU5h1C4ravHm7RytaruTk0p40ybJq
         v9UA==
X-Gm-Message-State: AOAM531f9e4VBrc4awfa895ddN4/iXzo03I9rGZsUBVPQ3rJpsEmFtM6
        4COUWKyX7IAY5Z+tOqWQAvqxILJDdERi4ZzweP87DBdWxNpw2lB3WYe0itR79tMyf4pNuORlrTL
        naOFpvQ8FZOW2
X-Received: by 2002:a7b:c772:: with SMTP id x18mr2613307wmk.185.1604669102569;
        Fri, 06 Nov 2020 05:25:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZ/2LRBRmoiShw0UuRFze9ZSUcWJNrDk2w76ayt2tZ+sF8mfL6vVrdwS624jyuuwMWXfuf+A==
X-Received: by 2002:a7b:c772:: with SMTP id x18mr2613286wmk.185.1604669102362;
        Fri, 06 Nov 2020 05:25:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.gmail.com with ESMTPSA id z6sm2385713wmi.1.2020.11.06.05.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 05:25:01 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
 <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
 <20200928173147.750e7358.cohuck@redhat.com>
 <136e1860-ddbc-edc0-7e67-fdbd8112a01e@linux.ibm.com>
 <f2ff3ddd-c70e-b2cc-b58f-bbcb1e4684d6@linux.ibm.com>
 <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc553f1a-8ddd-59b0-9dec-8bdddfb5483d@redhat.com>
Date:   Fri, 6 Nov 2020 14:25:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <63ac15b1-b4fe-b1b5-700f-ae403ce7fb85@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/20 15:15, Janosch Frank wrote:
>> Isn't it possible to go on with this patch series.
>> It can be adapted later to the changes that will be introduced by
>> Claudio when it is final.
>>
>>
> Pierre, that's outside of my jurisdiction, you're adding code to the
> common code library.
> 
> I've set Paolo CC, let's see if he finds this thread:)
> 

I have queued Claudio's series already, so let's start from there.

Paolo

