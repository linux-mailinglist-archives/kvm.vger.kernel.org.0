Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9341433111C
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhCHOl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:41:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229701AbhCHOlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615214514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uLw2M2R5jAa5NqaPTwkcnWHsCQpChxaH7wI7veOVDKI=;
        b=CZMOGsvuv4vurh69wstXtDC/KMdBXuY5u2MR/CXb0+xxhpi+Gh+wo6efWZbnmNVsOFjfvD
        PWvA4SG+6y+IszgXIWl9r5LP4Dozs9zi7MJyzlvUyzLFaQg3OgpNdzlskkFHKtGXy4dAPd
        +5/wEhBvmWFdVtM8LRauEMMaHGtuuB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-K2_a2qkbMBaZXpUu6y_8zw-1; Mon, 08 Mar 2021 09:41:52 -0500
X-MC-Unique: K2_a2qkbMBaZXpUu6y_8zw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A59F2801814;
        Mon,  8 Mar 2021 14:41:51 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-198.ams2.redhat.com [10.36.113.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C60C5D9D3;
        Mon,  8 Mar 2021 14:41:46 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
 <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3e59a15b-a2d0-4527-edb3-582c723ab526@redhat.com>
Date:   Mon, 8 Mar 2021 15:41:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/2021 15.13, Pierre Morel wrote:
> 
> 
> On 3/1/21 4:00 PM, Janosch Frank wrote:
>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>> In order to ease the writing of tests based on:
> 
> ...snip...
> 
>>> -static void test_sense(void)
>>> +static bool do_test_sense(void)
>>>   {
>>>       struct ccw1 *ccw;
>>> +    bool success = false;
>>
>> That is a very counter-intuitive name, something like "retval" might be
>> better.
>> You're free to use the normal int returns but unfortunately you can't
>> use the E* error constants like ENOMEM.
> 
> hum, I had retval and changed it to success on a proposition of Thomas...
> I find it more intuitive as a bool since this function succeed or fail, no 
> half way and is used for the reporting.
> 
> other opinion?

I'd say either "static int ..." + retval (with 0 for success), or "static 
bool ..." and "success" (with true for success) ... but "bool" + "retval" 
sounds confusing to me.

  Thomas

