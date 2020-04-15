Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DDD1AAC49
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbgDOPwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:52:00 -0400
Received: from foss.arm.com ([217.140.110.172]:47658 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbgDOPv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:51:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B02F91FB;
        Wed, 15 Apr 2020 08:51:56 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9CC33F6C4;
        Wed, 15 Apr 2020 08:51:55 -0700 (PDT)
Subject: Re: [PATCH kvmtool 00/18] Various fixes
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
 <20200415154433.GA18960@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a632133f-5db3-6208-c98f-c3a1050f6855@arm.com>
Date:   Wed, 15 Apr 2020 16:52:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415154433.GA18960@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 4/15/20 4:44 PM, Will Deacon wrote:
> On Tue, Apr 14, 2020 at 03:39:28PM +0100, Alexandru Elisei wrote:
>> I've taken the fixes from my reassignable BARs and PCIE support series [1]
>> and created this series because 1. they can be taken independently and 2.
>> rebasing a 32 patch series was getting very tedious.
>>
>> Changes from the original series:
>>
>> * Gathered Reviewed-by tags. Only patch #14 "virtio: Don't ignore
>>   initialization failures" doesn't have one.
>> * The virtio net device now frees the allocated devices and the ops copy on
>>   failure in patch #14.
>>
>> [1] https://www.spinics.net/lists/kvm/msg211272.html
> Thanks! Applied the lot, with Andre's Reviewed-by added to patch 14.
>
> I'm not able to test device passthrough at the moment, but I assume you 
> did? I once had ideas about sticking the virtio devices on a separate PCI
> bus from the passthrough devices, so we'll need to revert the change to
> the "bus range" property if we ever decide to do that.

Many thanks for merging the series!

The changes from the reassignable BARs and PCIE support series were minimal, so I
didn't do any passthrough testing for the standalone fixes (but I did test vesa
with sdl and vnc on x86 and virtio-pci on arm64). However, I did try passthrough
for all the devices that I could get my hands on for the reassignable BARs on
arm64 and x86 (the exact devices that I used are mentioned in the cover letter
[1]) and everything was working fine.

[1] https://www.spinics.net/lists/kvm/msg211272.html

Thanks,
Alex
>
> Will
