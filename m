Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F52A4BD8
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKCQpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:45:22 -0500
Received: from foss.arm.com ([217.140.110.172]:52090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgKCQpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 11:45:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6138139F;
        Tue,  3 Nov 2020 08:45:21 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91DB53F66E;
        Tue,  3 Nov 2020 08:45:20 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: Add support for configuring the
 translation granule
To:     Andrew Jones <drjones@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-2-nikos.nikoleris@arm.com>
 <20201103130443.d7zt2zdzbg6hgq7c@kamzik.brq.redhat.com>
 <938dd93e-653b-492d-e8d9-d19fc54cb1f5@arm.com>
 <20201103161038.32orgisio5xy5cn2@kamzik.brq.redhat.com>
 <2f2a6f1a-2893-2a45-8145-8c013237025e@arm.com>
 <20201103163931.vs67zfhqnhn2y2wf@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4e5247ae-67d8-3a7e-d227-c52c20106fb8@arm.com>
Date:   Tue, 3 Nov 2020 16:46:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201103163931.vs67zfhqnhn2y2wf@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 11/3/20 4:39 PM, Andrew Jones wrote:
> On Tue, Nov 03, 2020 at 04:25:15PM +0000, Alexandru Elisei wrote:
>> Hi,
>>
>> On 11/3/20 4:10 PM, Andrew Jones wrote:
>>> On Tue, Nov 03, 2020 at 03:49:32PM +0000, Nikos Nikoleris wrote:
>>>>>> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
>>>>>> index 46af552..2a06207 100644
>>>>>> --- a/lib/arm64/asm/page.h
>>>>>> +++ b/lib/arm64/asm/page.h
>>>>>> @@ -10,38 +10,51 @@
>>>>>>    * This work is licensed under the terms of the GNU GPL, version 2.
>>>>>>    */
>>>>>> +#include <config.h>
>>>>>>   #include <linux/const.h>
>>>>>> -#define PGTABLE_LEVELS		2
>>>>>>   #define VA_BITS			42
>>>>> Let's bump VA_BITS to 48 while we're at it.
>>> I tried my suggestion to go to 48 VA bits, but it seems to break
>>> things for 64K pages.
>> I believe that is because we end up with PGTABLE_LEVELS=3 and in
>> mmu_set_ranges_sect() we try to install a block mapping at the PUD level, which is
>> forbidden by the architecture.
>>
>> I think the easiest fix for that is to always try to install block mapping at the
>> pmd level. The diff below fixed all errors (with 16k and 64k pages):
>> [..]
> Let's use 48.
>
Yes, that was a typo.

Thanks,
Alex
