Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7B37BF2E
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhELOE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 10:04:29 -0400
Received: from foss.arm.com ([217.140.110.172]:39862 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhELOE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 10:04:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 281096D;
        Wed, 12 May 2021 07:03:20 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6AEB3F718;
        Wed, 12 May 2021 07:03:19 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] arm: add eabi version of 64-bit
 division functions
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210512105440.748153-1-pbonzini@redhat.com>
 <20210512105440.748153-3-pbonzini@redhat.com>
 <e1aa58da-c4c9-6bb0-3aef-f17c12349577@arm.com>
 <2d068920-26c2-610c-c27d-b693e406b180@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1748f789-d804-aa8f-2e75-cf1a495f7609@arm.com>
Date:   Wed, 12 May 2021 15:04:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2d068920-26c2-610c-c27d-b693e406b180@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 5/12/21 2:51 PM, Paolo Bonzini wrote:
> On 12/05/21 15:44, Alexandru Elisei wrote:
>>> +    bl    __udivmoddi4
>>> +    ldr    r2, [sp, #8]             // remainder returned in r2-r3
>>> +    ldr    r3, [sp, #12]
>>> +    add    sp, sp, #16
>>> +    pop    {r11, pc}
>>
>> I'm not sure what is going on here. Is the function returning 2 64bit arguments as
>> an 128bit vector? Or is the function being called from assembly and this is a
>> convention between it and the caller?
>
> It's an eABI convention that spans the runtime and the compiler.
>
> https://developer.arm.com/documentation/ihi0043/e/?lang=en#standardized-compiler-helper-functions
> says it returns a "pair of (unsigned) long longs is returned in {{r0, r1}, {r2,
> r3}}, the quotient in {r0, r1}, and the remainder in {r2, r3}."

Thanks for the link, the functions are indeed returning the quotient in {r0, r1}
and remainder in {r2, r3} according to the convention:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

