Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BB236A6B4
	for <lists+kvm@lfdr.de>; Sun, 25 Apr 2021 12:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhDYKf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 06:35:58 -0400
Received: from foss.arm.com ([217.140.110.172]:48960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhDYKfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 06:35:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87EE3ED1;
        Sun, 25 Apr 2021 03:35:15 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9D5A3F73B;
        Sun, 25 Apr 2021 03:35:14 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2 6/8] arm/arm64: setup: Consolidate
 memory layout assumptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-7-drjones@redhat.com>
 <20210421064055.mdz3w4kgywyw5wiu@gator.home>
 <20210422161230.t7wmnq3zsyxgchy2@gator>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ea0e3205-dfeb-4f14-31d1-543ab4eda56e@arm.com>
Date:   Sun, 25 Apr 2021 11:35:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422161230.t7wmnq3zsyxgchy2@gator>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/22/21 5:12 PM, Andrew Jones wrote:
> On Wed, Apr 21, 2021 at 08:40:55AM +0200, Andrew Jones wrote:
>> On Tue, Apr 20, 2021 at 09:00:00PM +0200, Andrew Jones wrote:
>>> +	assert(mem.end);
>>>  	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
>> Eh, I promised Alex not to do this, but then didn't correct it quite
>> right. This should be
>>
>>   assert(!(mem.start & ~PHYS_MASK));
>>   if ((mem.end - 1) & ~PHYS_MASK)
>>      mem.end &= PHYS_MASK;
> I've changed this to 
>
>   assert(mem.end && !(mem.start & ~PHYS_MASK));
>   mem.end &= PHYS_MASK;
>
> for v3.

Looks good,

Thanks,

Alex

