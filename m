Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553E9144428
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 19:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAUSTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 13:19:48 -0500
Received: from gecko.sbs.de ([194.138.37.40]:59271 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgAUSTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 13:19:47 -0500
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2020 13:19:45 EST
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 00LI8VZ3031796
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 19:08:31 +0100
Received: from [167.87.4.158] ([167.87.4.158])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 00LI8T8P017464;
        Tue, 21 Jan 2020 19:08:30 +0100
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
 <e86c01a8-8265-5e42-2fae-2c42c7e3d961@siemens.com>
 <60b2a488-74b8-897c-4b25-e228d3fe7d55@oth-regensburg.de>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <9f8b95d1-7b5f-d16d-2e5a-52f4b9cd0922@siemens.com>
Date:   Tue, 21 Jan 2020 19:08:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <60b2a488-74b8-897c-4b25-e228d3fe7d55@oth-regensburg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.11.19 14:58, Ralf Ramsauer wrote:
> Hi Dave,
> 
> On 11/14/19 9:09 AM, Jan Kiszka wrote:
>> On 13.11.19 22:24, Dave Hansen wrote:
>>> On 11/13/19 12:23 AM, Paolo Bonzini wrote:
>>>> On 13/11/19 07:38, Jan Kiszka wrote:
>>>>> When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
>>>>> couldn't simply be handled by the host. But I suppose the symptom of
>>>>> that erratum is not "just" regular recoverable MCE, rather
>>>>> sometimes/always an unrecoverable CPU state, despite the error code,
>>>>> right?
>>>> The erratum documentation talks explicitly about hanging the system, but
>>>> it's not clear if it's just a result of the OS mishandling the MCE, or
>>>> something worse.  So I don't know. :(  Pawan, do you?
>>>
>>> It's "something worse".
>>>
>>> I built a kernel module reproducer for this a long time ago.  The
>>> symptom I observed was the whole system hanging hard, requiring me to go
>>> hit the power button.  The MCE software machinery was not involved at
>>> all from what I could tell.
>>
>> Thanks for clarifying this - too bad.
>>
>>>
>>> About creating a unit test, I'd be personally happy to share my
>>> reproducer, but I built it before this issue was root-caused.  There are
> 
> I'd appreciate if you could share your code.
> 
>>> actually quite a few underlying variants and a good unit test would make
>>> sure to exercise all of them.  My reproducer probably only exercised a
>>> single case.
> 
> Still, it triggers the issue, that's enough to compare it to my reproducer.
> 
>>>
>>
>> Would be interesting to see this. Ralf and tried something quickly, but
>> there seems to be a detail missing or wrong.
> 
> Yep, we still can't reproduce the issue on an affected CPU, and don't
> know what we miss.

I just realized that this thread stranded. Ralf told me that he got no 
access to that reproducer which would be very valuable for us right now 
to validate a static mitigation method in Jailhouse. Any chance to get 
the access?

Thanks a lot,
Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
