Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD245153639
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgBERTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:19:01 -0500
Received: from foss.arm.com ([217.140.110.172]:49908 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgBERTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 12:19:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48EE21FB;
        Wed,  5 Feb 2020 09:19:00 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 591DE3F52E;
        Wed,  5 Feb 2020 09:18:59 -0800 (PST)
Subject: Re: [PATCH kvmtool 00/16] arm: Allow the user to define the memory
 layout
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <20200205171612.GC908@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ea711081-142a-6897-72c9-323d95d6311e@arm.com>
Date:   Wed, 5 Feb 2020 17:18:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200205171612.GC908@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/5/20 5:16 PM, Will Deacon wrote:
> On Mon, Sep 23, 2019 at 02:35:06PM +0100, Alexandru Elisei wrote:
>> The guest memory layout created by kvmtool is fixed: regular MMIO is below
>> 1G, PCI MMIO is below 2G, and the RAM always starts at the 2G mark. Real
>> hardware can have a different memory layout, and being able to create a
>> specific memory layout can be very useful for testing the guest kernel.
>>
>> This series allows the user the specify the memory layout for the
>> virtual machine by expanding the -m/--mem option to take an <addr>
>> parameter, and by adding architecture specific options to define the I/O
>> ports, regular MMIO and PCI MMIO memory regions.
>>
>> The user defined memory regions are implemented in patch #16; I consider
>> the patch to be an RFC because I'm not really sure that my approach is the
>> correct one; for example, I decided to make the options arch dependent
>> because that seemed like the path of least resistance, but they could have
>> just as easily implemented as arch independent and each architecture
>> advertised having support for them via a define (like with RAM base
>> address).
> Do you plan to repost this with Andre's comments addressed?

The series will conflict with my other series which add support for assignable
BARs and PCIE. I am definitely still interested in reposting this because I think
it's very useful, and I'll do it after the other patches get merged.

Thank you for taking a look!

Thanks,
Alex
>
> Will
