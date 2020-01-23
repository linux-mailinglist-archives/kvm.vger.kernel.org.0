Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3C146795
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 13:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgAWMIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 07:08:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgAWMIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 07:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579781300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RgXWkEwlIleNM1/ERVwhuJYeJnlRBjicXMb4O8EyVI=;
        b=LwCdpqOLtcRV4HFIM9qXChD8eENO6ZdqunkkbTYBdRkVt0otqLEKi0+0Mt2g2sPVFJYXuL
        gLM9UvPgnMB1y70+rmg/n6UfHqhjzRRV3xH0EvzEClrv9Aa/oU+NgkkMgPuGUrtspO2ISG
        Zdyq/m3xTH/iQ0Amx15tj4EAFbxe8+0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-hggG8zT0NGaeTSZSUdfWzQ-1; Thu, 23 Jan 2020 07:08:19 -0500
X-MC-Unique: hggG8zT0NGaeTSZSUdfWzQ-1
Received: by mail-wr1-f72.google.com with SMTP id y7so1616098wrm.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 04:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2RgXWkEwlIleNM1/ERVwhuJYeJnlRBjicXMb4O8EyVI=;
        b=gxfMFqnKuPz4mc6MybYo9GpDjapm8l2FtmR7VZ6B7heWk1Yd8yGJ/cIVcywA2LrEK1
         emt5K97nwHpnd/Z/Tb2Ym3bcF1oWEp9A4Z6wo/y7LGzRfBuXJNJFSUEXG/1TLjj2gPBg
         8Btb/a9BsFEdRsHm2hI5Z7UHfI3n0mUmeDOo6qsJuN7BsU7WVzawWOHs47k30WlPMcvB
         fCf1YJkLkCCc4InvWOznDKZDkVXy524AKvg3NqP4ge+t8KBCYEEHG9wmrHbjY1wCLhjJ
         LcTbUZ8SvRR+HksolzryhlN8L1K+kP/xc8br5XeaBqE33BuYGmgZaly9H8hzgJmF/Dka
         vjcQ==
X-Gm-Message-State: APjAAAVq805EwPQtqldf+QcNNU3LqoPN7xy4HTYE7x8AlYSw3RGZAZgR
        FDWtRFFJQDICEEOUfbafZLB47N9V+m2SiSrznTtStKv6Vcp0Aovntq3ZGO5EXL4iQop9HHs2NZb
        KYLE0hzitglrz
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr4106775wma.177.1579781297923;
        Thu, 23 Jan 2020 04:08:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzubcGkGshKq5Cqqq/iMA8t+Tqd7uesdyRt5Yw5tcSspIZ1Oja3SQpP0lCMkWaWT+A1Ez04jg==
X-Received: by 2002:a1c:3b0a:: with SMTP id i10mr4106739wma.177.1579781297640;
        Thu, 23 Jan 2020 04:08:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id w8sm2675687wmm.0.2020.01.23.04.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 04:08:17 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>, milanpa@amazon.com,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
Date:   Thu, 23 Jan 2020 13:08:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 16:38, Alexander Graf wrote:
>>>> ONE_REG would force us to define constants for each counter, and would
>>>> make it hard to retire them.  I don't like this.
>>>
>>> Why does it make it hard to retire them? We would just return -EINVAL
>>> on retrieval, like we do for any other non-supported ONE_REG.
>>>
>>> It's the same as a file not existing in debugfs/statfs. Or an entry
>>> in the array of this patch to disappear.

The devil is in the details.  For example, would you retire uapi/
constants and cause programs to fail compilation?  Or do you keep the
obsolete constants forever?  Also, fixing the mapping from ONE_REG
number to stat would mean a switch statement (or loop of some kind---a
switch statement is basically an unrolled binary search) to access the
stats.  Instead returning the id in KVM_GET_SUPPORTED_DEBUGFS_STAT would
simplify returning the stats to a simple copy_to_user.

Of course, some of the complexity would be punted to userspace.  But
userspace is much closer to the humans that ultimately look at the
stats, so the question is: does userspace really care about knowing
which stat is which, or do they just care about having a name that will
ultimately be consumed by humans down the pipe?  If the latter (which is
also my gut feeling), that is also a point against ONE_REG.

> It's not a problem of exposing the type information - we have that today
> by implicitly saying "every counter is 64bit".
> 
> The thing I'm worried about is that we keep inventing these special
> purpose interfaces that really do nothing but transfer numbers in one
> way or another. ONE_REG's purpose was to unify them. Debug counters
> really are the same story.

See above: I am not sure they are the same story because their consumers
might be very different from registers.  Registers are generally
consumed by programs (to migrate VMs, for example) and only occasionally
by humans, while stats are meant to be consumed by humans.  We may
disagree on whether this justifies a completely different API...

Paolo

