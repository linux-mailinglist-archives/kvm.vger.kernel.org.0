Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F8A755F8D
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 11:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjGQJlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 05:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjGQJla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 05:41:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4636419B1;
        Mon, 17 Jul 2023 02:40:56 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 381E8D75;
        Mon, 17 Jul 2023 02:41:39 -0700 (PDT)
Received: from [10.1.27.35] (FVFF763DQ05P.cambridge.arm.com [10.1.27.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A8523F73F;
        Mon, 17 Jul 2023 02:40:52 -0700 (PDT)
Message-ID: <0c069be6-d67b-cb2c-9f1e-e65d45eda0f8@arm.com>
Date:   Mon, 17 Jul 2023 10:40:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230714144657.000064ef@Huawei.com>
 <42cbffac-05a8-a279-9bdb-f76354c1a1b1@arm.com>
 <20230714172825.00003e81@Huawei.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230714172825.00003e81@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2023 17:28, Jonathan Cameron wrote:
> On Fri, 14 Jul 2023 16:03:37 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> Hi Jonathan
>>
>> On 14/07/2023 14:46, Jonathan Cameron wrote:
>>> On Fri, 27 Jan 2023 11:22:48 +0000
>>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>>
>>> Hi Suzuki,
>>>
>>> Looking at this has been on the backlog for a while from our side and we are finally
>>> getting to it.  So before we dive in and given it's been 6 months, I wanted to check
>>> if you expect to post a new version shortly or if there is a rebased tree available?
>>
>> Thanks for your interest. We have been updating our trees to the latest
>> RMM specification (v1.0-eac2 now) and also rebasing Linux/KVM on top of
>> v6.5-rc1. We will post this as soon as we have all the components ready
>> (and the TF-RMM). At the earliest, this would be around early September.
>>
>> That said, the revised version will have the following changes :
>>    - Changes to the Stage2 management
>>    - Changes to RMM memory management for Realm
>>    - PMU/SVE support
>>
>> Otherwise, most of the changes remain the same (e.g., UABI). Happy to
>> hear feedback on those areas.
> 
> Hi Suzuki,
> 
> Thanks for the update.  If there is any chance of visibility of changes
> via a git tree etc that would be great in the meantime.  If not, such is life
> and I'll try to wait patiently :) + we'll review the existing code.

I am afraid not yet. Thanks for reviewing the changes :-)

Suzuki

