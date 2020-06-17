Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972041FCDF0
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgFQM5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 08:57:48 -0400
Received: from foss.arm.com ([217.140.110.172]:57480 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgFQM5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 08:57:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACF301045;
        Wed, 17 Jun 2020 05:57:47 -0700 (PDT)
Received: from [10.37.8.7] (unknown [10.37.8.7])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B62F53F73C;
        Wed, 17 Jun 2020 05:57:44 -0700 (PDT)
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        George Cherian <gcherian@marvell.com>,
        James Morse <james.morse@arm.com>,
        Andrew Scull <ascull@google.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <42103fc0-fc87-960f-a83a-25e555613295@arm.com>
Date:   Wed, 17 Jun 2020 13:58:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9c0044564885d3356f76b55f35426987@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/16/20 5:18 PM, Marc Zyngier wrote:
> Hi Alexandru,
>
> On 2020-06-16 16:59, Alexandru Elisei wrote:
>> Hi,
>>
>> IMO, this patch does two different things: adds a new structure, kvm_s2_mmu, and
>> converts the memory management code to use the 4 level page table API. I realize
>> it's painful to convert the MMU code to use the p4d functions, and then modify
>> everything to use kvm_s2_mmu in a separate patch, but I believe
>> splitting it into
>> 2 would be better in the long run. The resulting patches will be
>> smaller and both
>> will have a better chance of being reviewed by the right people.
>
> I'm not sure how you want me to do this. The whole p4d mess is already in
> mainline (went via akpm directly to Linus), and I can't really revert it.

Silly me, I thought that *this* patch adds the p4d functions, but in fact they
were added in commit e9f6376858b9 ("arm64: add support for folded p4d page
tables"). Sorry for the noise, will pay more attention next time.

Thanks,
Alex
