Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A5981BB2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfHENQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:16:37 -0400
Received: from foss.arm.com ([217.140.110.172]:48146 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729505AbfHENGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:06:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E280D337;
        Mon,  5 Aug 2019 06:06:08 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FEBA3F77D;
        Mon,  5 Aug 2019 06:06:07 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com>
 <3bdd764a-b6f5-d17e-a703-d8eb13838efc@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <fd8b0c8d-79d1-1501-cee0-d3f6bc1c3487@arm.com>
Date:   Mon, 5 Aug 2019 14:06:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3bdd764a-b6f5-d17e-a703-d8eb13838efc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/2019 04:23, Zenghui Yu wrote:
> Hi Steven,
> 
> On 2019/8/2 22:50, Steven Price wrote:
>> Introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>
>> This only adds the details about "Stolen Time" as the details of "Live
>> Physical Time" have not been fully agreed.
>>
>> User space can specify a reserved area of memory for the guest and
>> inform KVM to populate the memory with information on time that the host
>> kernel has stolen from the guest.
>>
>> A hypercall interface is provided for the guest to interrogate the
>> hypervisor's support for this interface and the location of the shared
>> memory structures.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
>>   1 file changed, 107 insertions(+)
>>   create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
>                                     ^^^^^^^
> This directory has been renamed recently, see:
> 
> https://patchwork.ozlabs.org/patch/1136104/

Thanks for pointing that out - I'll move it in the next version.

Steve
