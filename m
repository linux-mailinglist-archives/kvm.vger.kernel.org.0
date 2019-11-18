Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A870F100709
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 15:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfKROIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 09:08:14 -0500
Received: from mta01.hs-regensburg.de ([194.95.104.11]:56102 "EHLO
        mta01.hs-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfKROIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 09:08:14 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2019 09:08:13 EST
Received: from E16S02.hs-regensburg.de (e16s02.hs-regensburg.de [IPv6:2001:638:a01:8013::92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client CN "E16S02", Issuer "E16S02" (not verified))
        by mta01.hs-regensburg.de (Postfix) with ESMTPS id 47GrBv0K35zy7Q;
        Mon, 18 Nov 2019 14:58:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oth-regensburg.de;
        s=mta01-20160622; t=1574085495;
        bh=BP0zP3OW9XzDUFIK80nnJmyfc1wDEkpFtTQ47Ux99Uw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From;
        b=n73Lu6tfJbNvCSwc5NJYlUBDib51gI9FZpyWpeOXTWDx2Bltvhsu29mz52WNS+8z9
         TAME7t92l8CVEqTBzKHvzSm+8h4ZXXZNyeR+OJm3KbV4/Oyna41pOvdQiP3mJ6TbLu
         QKgZCcMqrXYPMFFF29hQGRBLllRfmkGa5KzvmAz7kUj6V878MWH3w/a1knTKEfxGfO
         Kx3CAxd5CI3pzz9n2uHaycamAekqx67Y8vaYaJ4jttNbPW19J4J88otNIHwrgpavh7
         e18hPdCuL9VXp1+XbaocdPCLHNvOeogUMjaTPgtlP8c0Bos/SHOoZZGYJ+n3f4CkF/
         Sl4fkh5/+q0iQ==
Received: from [192.168.178.10] (194.95.106.138) by E16S02.hs-regensburg.de
 (2001:638:a01:8013::92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 18 Nov
 2019 14:58:14 +0100
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
 <e86c01a8-8265-5e42-2fae-2c42c7e3d961@siemens.com>
From:   Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Autocrypt: addr=ralf.ramsauer@oth-regensburg.de; keydata=
 mQINBFFbFOQBEACuc/5RqBxcHJiMjuQo4cUit/whIFgjcorx77z/srj/Cn5mKnWMLgmhszFC
 nzrgLw+1KewrJ/+qcrJKmX3Dw58VaktfjV0QUEnPmQXND3PUIE4Bl01GZ4Z/NKtaavdTWPTH
 wKzjbDucCzYKMBEYT3AMQRwQLNBF7VboV1T2fy+J505P9LP649c/Ept5vAsFH/3k2YpVVYcf
 Xpxk7ZxxBa9Xj9jMkoEGK8YPj0bHtrjrtG+fDuQRdv4gVwdY+HdalLQXCzYVPEnA/w3kD69A
 tPVuJOK61hJz6rS2n5ByzFLitLB8Fe940AI3wy4Df2pB2UFnD51k2Cg3HKi5HqH4Mpsieixq
 m/pd37SoPwQoTeVX+ASeUNl2CibSi78IsbHnZBKMKfdlSCzqogRWGcZPivKIL0vQDpzSSn4C
 hiRNiTXLH7lhfIhlH/MgmjXanhYDVLzQNhIEYF2Op2XN0HeYD/aFHQxhQQNxvX6aEDj7t0aS
 fAmyULXq1DX+ttI9UY65hcdvQQHUVCNF+87Sggu4x1q8/cxDkdpRlCqdmEigXF7nHkbsOVq8
 T8B1j+Y2cGIU/ivyMO+pqEQm3QOWKBC8ndm49lCgxltsEL5Bd4j4dF08QCcWFVbF9cWb2obT
 KcHX3Vm+1zKz2HLR9gBZiEPjNoP9riVz+81ECNk42w9874pmLQARAQABtC9SYWxmIFJhbXNh
 dWVyIDxyYWxmLnJhbXNhdWVyQG90aC1yZWdlbnNidXJnLmRlPokCVAQTAQgAPgIbAwULCQgH
 AgYVCAkKCwIEFgIDAQIeAQIXgBYhBO+AJoipr99tPvqviPovtFKPEASbBQJbE/G6BQkJui5W
 AAoJEPovtFKPEASb3iAP/jhdGSwc91Jf+kcOKaWe40dFQn2bjFhoYXuD16AYoBHBVNNOFYW6
 ikYyAUFOMaWBvUBUu4eyFwPY8ewr7sXoH5RqheQc7bvtX+2lxI3dLbcDMlp2Apj1NVFUKNAy
 VKjPpWNNdR+iz6JVar/QUye++5WOaJ2Jdgc/AIfBAWZyBcrg16um8hb7TMX5++7OtEUVOSz6
 L9bZkp6S/E6WgnIturQDEcmvxGJjwZKsLMlFNhasex3fzRE8vVq2JONi/gGfso7EQx7jdYNH
 z9BkdSlhL2agtMhmBygRs8L6TXU/V5sv4UD7+BiEINDEJTPF9OAX44MCXslGmGn0Kltvf2vC
 NGfsmcSVcsiptRAvrafxCUW8CqgwGLeuJi/qLKF3oRYjvVYMxpBsqQLIksYrPxvMOXgh2uU/
 JJgxnS+spAh+33uqWLP00CmOT06WNwSY6k3WSYfA5EvsLCsrrmO8NOIUjMC8pLqiEFgXgw6M
 CANKNJN23Aapo+rPF+kHvnMR/YFrgapJn3VGrG5lELovqGyqc7afIgiiEMSUY1zcJ9VlS0Z4
 OvbTjvPYy4tb8aGgMQ6cmsqiaIpHFZ2UJtk4R5asCmwIkbVWQLxvNlX9J5bXr/PHU0UlYJYB
 mp34WgKNwgwyso67v0GZDKJyaBMvk7alZEOKGWcMKEE6Pr3ByURudR8w
Message-ID: <60b2a488-74b8-897c-4b25-e228d3fe7d55@oth-regensburg.de>
Date:   Mon, 18 Nov 2019 14:58:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e86c01a8-8265-5e42-2fae-2c42c7e3d961@siemens.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [194.95.106.138]
X-ClientProxiedBy: E16S04.hs-regensburg.de (2001:638:a01:8013::94) To
 E16S02.hs-regensburg.de (2001:638:a01:8013::92)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On 11/14/19 9:09 AM, Jan Kiszka wrote:
> On 13.11.19 22:24, Dave Hansen wrote:
>> On 11/13/19 12:23 AM, Paolo Bonzini wrote:
>>> On 13/11/19 07:38, Jan Kiszka wrote:
>>>> When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
>>>> couldn't simply be handled by the host. But I suppose the symptom of
>>>> that erratum is not "just" regular recoverable MCE, rather
>>>> sometimes/always an unrecoverable CPU state, despite the error code,
>>>> right?
>>> The erratum documentation talks explicitly about hanging the system, but
>>> it's not clear if it's just a result of the OS mishandling the MCE, or
>>> something worse.  So I don't know. :(  Pawan, do you?
>>
>> It's "something worse".
>>
>> I built a kernel module reproducer for this a long time ago.  The
>> symptom I observed was the whole system hanging hard, requiring me to go
>> hit the power button.  The MCE software machinery was not involved at
>> all from what I could tell.
> 
> Thanks for clarifying this - too bad.
> 
>>
>> About creating a unit test, I'd be personally happy to share my
>> reproducer, but I built it before this issue was root-caused.  There are

I'd appreciate if you could share your code.

>> actually quite a few underlying variants and a good unit test would make
>> sure to exercise all of them.  My reproducer probably only exercised a
>> single case.

Still, it triggers the issue, that's enough to compare it to my reproducer.

>>
> 
> Would be interesting to see this. Ralf and tried something quickly, but
> there seems to be a detail missing or wrong.

Yep, we still can't reproduce the issue on an affected CPU, and don't
know what we miss.

Thanks,
  Ralf

> 
> Jan
> 
