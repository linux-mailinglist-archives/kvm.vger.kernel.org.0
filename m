Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C927534C
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIWIeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 04:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbgIWIeu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 04:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600850089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9QmIAlLfRDBlkozhSVx32VjLU4/mzcYj/iI28/ylS0=;
        b=UQM46wlVcDvJCV8OeFDeyT4hKz4g/+XuniUCFaSMWw01b+qLJwu8TZ7hm4ZmJKoZU2SE0x
        d90LPc87iyhNmmNIy3XIb6nOEIYTnx9x8zMIRUuI6uoFZVKD2cM6d0gYwaHp+HHyosU9nL
        jpwnbLJdrwqt020cSKRSHfsimhb4xkw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-lNJd7dWYO6Kb0BgEv6WGjw-1; Wed, 23 Sep 2020 04:34:47 -0400
X-MC-Unique: lNJd7dWYO6Kb0BgEv6WGjw-1
Received: by mail-wr1-f72.google.com with SMTP id v12so8537436wrm.9
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 01:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V9QmIAlLfRDBlkozhSVx32VjLU4/mzcYj/iI28/ylS0=;
        b=DI1sRQpEuqcSUbE38VXxScpDftzJj8s0wr4bTXmwj24vhVPstmKoKu3PCT/Q8cWkQB
         n5d8BMNiJc3SsXLY/QfGNB0RUBaJQg3cv+a7MoUh0ZMO4DPFEU0KM0g9rb4SvONwdcGD
         8thpWZnJAFPApLDM9UiCofJXsEtyl8NArlSBX0AAPp/weHLxQ4dqygUVieP9f9hBpVDb
         vYNl4MjMyErw8ZI3FycPo+YlZICerezjy0UQjm+cPMgZs5sDfqaI4SBERDWMNcEv8+Au
         nJw8OWPp9QNmoIqYCoa52B5doDVCnSwOmV309c9rPfUfrN0mc4W0bCqsHWm76NCOU9Xn
         GsEA==
X-Gm-Message-State: AOAM530P5beC0t/0vp1q1SXjlwMIf5OvZlFIIz2oqyfWcqUd6xC7+oBI
        p4EpwPWsxrMGnCvJlqx3PncjwgDtODETbfUUIMf4L6XQIdejHqIqictoE4rNfaxSmWbcY4NNBMw
        s4aqRTo+Z2F0m
X-Received: by 2002:a1c:488:: with SMTP id 130mr5047301wme.164.1600850085473;
        Wed, 23 Sep 2020 01:34:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAXfuw0EMSaPOYeNL03RCVF3KB0m3rbV/oODwjvtwTnvCW++VDx+fdEay881HWfNKFd4bu5A==
X-Received: by 2002:a1c:488:: with SMTP id 130mr5047286wme.164.1600850085289;
        Wed, 23 Sep 2020 01:34:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id n10sm7760017wmk.7.2020.09.23.01.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 01:34:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Fix the getopt problem
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200923073931.74769-1-thuth@redhat.com>
 <0bc92d08-a642-32c9-0a73-102f6fd27913@redhat.com>
 <40a4f2f0-5ca2-2a7e-e558-bc35ffdb9b10@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <765c45b4-86d6-565b-b899-9478b072046a@redhat.com>
Date:   Wed, 23 Sep 2020 10:34:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <40a4f2f0-5ca2-2a7e-e558-bc35ffdb9b10@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 10:29, Thomas Huth wrote:
> On 23/09/2020 10.14, Paolo Bonzini wrote:
>> On 23/09/20 09:39, Thomas Huth wrote:
>>> The enhanced getopt is now not selected with a configure switch
>>> anymore, but by setting the PATH to the right location.
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  This fixes the new macOS build jobs on Travis :
>>>  https://travis-ci.com/github/huth/kvm-unit-tests/builds/186146708
>>>
>>>  .travis.yml | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> Pushed, and I also linked the gitlab repo to Travis:
>>
>> https://travis-ci.com/gitlab/kvm-unit-tests/KVM-Unit-Tests
> 
> Oh, that's sweet, thanks! I didn't know that Travis can also access
> gitlab repositories now :-)

Silver lining of being shamed :)

Paolo

