Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360FE59BFD9
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 14:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiHVMzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 08:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiHVMzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 08:55:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D59D1901C;
        Mon, 22 Aug 2022 05:55:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6632912FC;
        Mon, 22 Aug 2022 05:55:23 -0700 (PDT)
Received: from [10.57.15.77] (unknown [10.57.15.77])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4AEF13F718;
        Mon, 22 Aug 2022 05:55:17 -0700 (PDT)
Message-ID: <c64e838a-dace-73dd-8ab9-7284166cf742@arm.com>
Date:   Mon, 22 Aug 2022 13:55:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/3] iommu/dma: Move public interfaces to linux/iommu.h
Content-Language: en-GB
To:     Christoph Hellwig <hch@infradead.org>
Cc:     joro@8bytes.org, will@kernel.org, catalin.marinas@arm.com,
        jean-philippe@linaro.org, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        tglx@linutronix.de, maz@kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, iommu@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1660668998.git.robin.murphy@arm.com>
 <9cd99738f52094e6bed44bfee03fa4f288d20695.1660668998.git.robin.murphy@arm.com>
 <YwNmosMGZdGtY3LX@infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YwNmosMGZdGtY3LX@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-08-22 12:21, Christoph Hellwig wrote:
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 70393fbb57ed..79cb6eb560a8 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -1059,4 +1059,40 @@ void iommu_debugfs_setup(void);
>>   static inline void iommu_debugfs_setup(void) {}
>>   #endif
>>   
>> +#ifdef CONFIG_IOMMU_DMA
>> +#include <linux/msi.h>
> 
> I don't think msi.h is actually needed here.
> 
> Just make the struct msi_desc and struct msi_msg forward declarations
> unconditional and we should be fine.

dma-iommu.c still needs to pick up msi.h for the actual definitions 
somehow, so it seemed logical to keep things the same shape as before. 
However I don't have a particularly strong preference either way.

Thanks,
Robin.
