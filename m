Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E436B1414E0
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 00:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgAQXjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 18:39:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730117AbgAQXjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jan 2020 18:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579304339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2U00U6MqNDR4I0/JeaR1JvqIsMZiDBNQq4vxeR/9xR8=;
        b=REWG6G3t9xb2iRm3gD4QELqgaBIeGUpi45/qQ8pj8659DkahaItELRUYhYGrjM2NfTkuTV
        MK643p/msMDJVn6GuoU+wMwwY81hQfRv4fltTPHPJzi5juwldxOR1IiyyLbv6OfIItMFLE
        jrrfcZBZoABFQ6ExYNLC0Ly+osuR1S8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-Q6q6hV-oP3K079NwRXWn7Q-1; Fri, 17 Jan 2020 18:38:56 -0500
X-MC-Unique: Q6q6hV-oP3K079NwRXWn7Q-1
Received: by mail-wr1-f72.google.com with SMTP id c6so11066985wrm.18
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 15:38:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2U00U6MqNDR4I0/JeaR1JvqIsMZiDBNQq4vxeR/9xR8=;
        b=JZ5glnJrLF2nBaAF4HvdMKFyQyu6/g3wbSwE/7taZcZTyX2Rmd/hluZ3dYq4WCxBE6
         4Rs7d9oXs0jYu3hhUsdkfouDbaYWTto6SQd9+WBBFlvbxxYAI3dpoOYM9odipBdW5JYH
         j88KbOKtvuxHu+vl4dagxMLmfTg1XABH5vkuTeJF0HDB7zGHCAVaeyXCmUSm8D+ehgVd
         LHd6+mK46jX/XfQtAIzl3VWRZXnrs9iij/mvDg7xrZrnTatmbB+NlAWcgFVVv7ZQS5zl
         DLFLMITq0/Y6Gk03goxmQSeH/7y/XQIwlzIAgY2rVBuEu1NjBp/l515dCkELetaOySnu
         kO1w==
X-Gm-Message-State: APjAAAXo3zCKXUWBHWAMSW6fe82h1sp4qcEqVQTIyuxmt2RlZAdVLbK2
        5mtgR9S2SEbsBlSgvFFPy/kAZUiU9Fh/XgRC3u3tIxH8Cg6odbr6v0PP9VwK6v6sXVRPb0UuTv/
        Jd/cDr9Gv2iDO
X-Received: by 2002:a1c:3803:: with SMTP id f3mr7160591wma.134.1579304335539;
        Fri, 17 Jan 2020 15:38:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxceDT/6jiPzKXNps6vnYLriCIrAyYMpAV7+Z8Jjya+zqkW+fH1Fl2f4LWsY7+xBNkq3PjHoA==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr7160573wma.134.1579304335264;
        Fri, 17 Jan 2020 15:38:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:51b3:a120:7789:e749? ([2001:b07:6468:f312:51b3:a120:7789:e749])
        by smtp.gmail.com with ESMTPSA id f12sm1160721wmf.28.2020.01.17.15.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 15:38:54 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>, milanpa@amazon.com,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
Date:   Sat, 18 Jan 2020 00:38:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/20 15:59, Alexander Graf wrote:
> On 15.01.20 15:43, milanpa@amazon.com wrote:
>>>> Let's expose new interface to userspace for garhering these
>>>> statistics with one ioctl.
>>>>
>>>> Userspace application can read counter description once using
>>>> KVM_GET_SUPPORTED_DEBUGFS_STAT and periodically invoke the
>>>> KVM_GET_DEBUGFS_VALUES to get value update.
>>>
>>> This is an interface that requires a lot of logic and buffers from
>>> user space to retrieve individual, explicit counters. What if I just
>>> wanted to monitor the number of exits on every user space exit?
>>
>> In case we want to cover such latency sensitive use cases solution b),
>> with mmap'ed structs you suggested, would be a way to go, IMO.
>>
>>> Also, we're suddenly making the debugfs names a full ABI, because
>>> through this interface we only identify the individual stats through
>>> their names. That means we can not remove stats or change their
>>> names, because people may rely on them, no? Thining about this again,
>>> maybe they already are an ABI because people rely on them in debugfs
>>> though?

In theory not, in practice I have treated them as a kind of "soft" ABI:
if the meaning changes you should rename them, and removing them is
fine, but you shouldn't for example change the unit of measure (which is
not hard since they are all counters :) but perhaps you could have
nanoseconds vs TSC cycles in the future for some counters).

>>> I see two alternatives to this approach here:
>>>
>>> a) ONE_REG
>>>
>>> We can just add a new DEBUG arch in ONE_REG and expose ONE_REG per VM
>>> as well (if we really have to?). That gives us explicit identifiers
>>> for each stat with an explicit path to introduce new ones with very
>>> unique identifiers.
ONE_REG would force us to define constants for each counter, and would
make it hard to retire them.  I don't like this.

>>> b) part of the mmap'ed vcpu struct

Same here.  Even if we say the semantics of the struct would be exposed
to userspace via KVM_GET_SUPPORTED_DEBUGFS_STAT, someone might end up
getting this wrong and expecting a particular layout.  Milan's proposed
API has the big advantage of being hard to get wrong for userspace.  And
pushing the aggregation to userspace is not a huge chore, but it's still
a chore.

So unless someone has a usecase for latency-sensitive monitoring I'd
prefer to keep it simple (usually these kind of stats can even make
sense if you gather them over relatively large period of time, because
then you'll probably use something else like tracepoints to actually
pinpoint what's going on).

>>> 2) vcpu counters
>>>
>>> Most of the counters count on vcpu granularity, but debugfs only
>>> gives us a full VM view. Whatever we do to improve the situation, we
>>> should definitely try to build something that allows us to get the
>>> counters per vcpu (as well).
>>>
>>> The main purpose of these counters is monitoring. It can be quite
>>> important to know that only a single vCPU is going wild, compared to
>>> all of them for example.
>>
>> I agree, exposing per vcpu counters can be useful. I guess it didn't
>> make much sense exposing them through debugfs so aggregation was done
>> in kernel. However if we chose to go with approach 1-b) mmap counters
>> struct in userspace, we could do this.
> 
> The reason I dislike the debugfs/statfs approach is that it generates a
> completely separate permission and access paths to the stats. That's
> great for full system monitoring, but really bad when you have multiple
> individual tenants on a single host.

I agree, anything in sysfs is complementary to vmfd/vcpufd access.

Paolo

